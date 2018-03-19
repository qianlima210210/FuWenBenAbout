//
//  UIControl+QDIM.m
//  QDIM
//
//  Created by qd-hxt on 2018/3/14.
//

#import "UIControl+QDIM.h"
#import <objc/runtime.h>
#import "QDIMInternalHeader.h"

static char kAssociatedObjectKey_automaticallyAdjustTouchHighlightedInScrollView;
static char kAssociatedObjectKey_canSetHighlighted;
static char kAssociatedObjectKey_touchEndCount;
static char kAssociatedObjectKey_outsideEdge;

@interface UIControl ()

@property(nonatomic,assign) BOOL canSetHighlighted;
@property(nonatomic,assign) NSInteger touchEndCount;

@end

@implementation UIControl (QDIM)

- (void)setQdim_automaticallyAdjustTouchHighlightedInScrollView:(BOOL)qdim_automaticallyAdjustTouchHighlightedInScrollView {
    objc_setAssociatedObject(self, &kAssociatedObjectKey_automaticallyAdjustTouchHighlightedInScrollView, [NSNumber numberWithBool:qdim_automaticallyAdjustTouchHighlightedInScrollView], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)qdim_automaticallyAdjustTouchHighlightedInScrollView {
    return (BOOL)[objc_getAssociatedObject(self, &kAssociatedObjectKey_automaticallyAdjustTouchHighlightedInScrollView) boolValue];
}

- (void)setCanSetHighlighted:(BOOL)canSetHighlighted {
    objc_setAssociatedObject(self, &kAssociatedObjectKey_canSetHighlighted, [NSNumber numberWithBool:canSetHighlighted], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)canSetHighlighted {
    return (BOOL)[objc_getAssociatedObject(self, &kAssociatedObjectKey_canSetHighlighted) boolValue];
}

- (void)setTouchEndCount:(NSInteger)touchEndCount {
    objc_setAssociatedObject(self, &kAssociatedObjectKey_touchEndCount, @(touchEndCount), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSInteger)touchEndCount {
    return [objc_getAssociatedObject(self, &kAssociatedObjectKey_touchEndCount) integerValue];
}

- (void)setQdim_outsideEdge:(UIEdgeInsets)qdim_outsideEdge {
    objc_setAssociatedObject(self, &kAssociatedObjectKey_outsideEdge, [NSValue valueWithUIEdgeInsets:qdim_outsideEdge], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIEdgeInsets)qdim_outsideEdge {
    return [objc_getAssociatedObject(self, &kAssociatedObjectKey_outsideEdge) UIEdgeInsetsValue];
}


+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        Class clz = [self class];
        
        SEL beginSelector = @selector(touchesBegan:withEvent:);
        SEL swizzled_beginSelector = @selector(qdim_touchesBegan:withEvent:);
        
        SEL moveSelector = @selector(touchesMoved:withEvent:);
        SEL swizzled_moveSelector = @selector(qdim_touchesMoved:withEvent:);
        
        SEL endSelector = @selector(touchesEnded:withEvent:);
        SEL swizzled_endSelector = @selector(qdim_touchesEnded:withEvent:);
        
        SEL cancelSelector = @selector(touchesCancelled:withEvent:);
        SEL swizzled_cancelSelector = @selector(qdim_touchesCancelled:withEvent:);
        
        SEL pointInsideSelector = @selector(pointInside:withEvent:);
        SEL swizzled_pointInsideSelector = @selector(qdim_pointInside:withEvent:);
        
        SEL setHighlightedSelector = @selector(setHighlighted:);
        SEL swizzled_setHighlightedSelector = @selector(qdim_setHighlighted:);
        
        QDIM_ReplaceMethod(clz, beginSelector, swizzled_beginSelector);
        QDIM_ReplaceMethod(clz, moveSelector, swizzled_moveSelector);
        QDIM_ReplaceMethod(clz, endSelector, swizzled_endSelector);
        QDIM_ReplaceMethod(clz, cancelSelector, swizzled_cancelSelector);
        QDIM_ReplaceMethod(clz, pointInsideSelector, swizzled_pointInsideSelector);
        QDIM_ReplaceMethod(clz, setHighlightedSelector, swizzled_setHighlightedSelector);
        
    });
}



- (void)qdim_setHighlighted:(BOOL)highlighted {
    [self qdim_setHighlighted:highlighted];
    if (self.qdim_setHighlightedBlock) {
        self.qdim_setHighlightedBlock(highlighted);
    }
}

BeginIgnoreDeprecatedWarning
- (void)qdim_touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    self.touchEndCount = 0;
    if (self.qdim_automaticallyAdjustTouchHighlightedInScrollView) {
        self.canSetHighlighted = YES;
        [self qdim_touchesBegan:touches withEvent:event];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (self.canSetHighlighted) {
                [self setHighlighted:YES];
            }
        });
    } else {
        [self qdim_touchesBegan:touches withEvent:event];
    }
}

- (void)qdim_touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if (self.qdim_automaticallyAdjustTouchHighlightedInScrollView) {
        self.canSetHighlighted = NO;
        [self qdim_touchesMoved:touches withEvent:event];
    } else {
        [self qdim_touchesMoved:touches withEvent:event];
    }
}

- (void)qdim_touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (self.qdim_automaticallyAdjustTouchHighlightedInScrollView) {
        self.canSetHighlighted = NO;
        if (self.touchInside) {
            [self setHighlighted:YES];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.02 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                // 如果延迟时间太长，会导致快速点击两次，事件会触发两次
                // 对于 3D Touch 的机器，如果点击按钮的时候在按钮上停留事件稍微长一点点，那么 touchesEnded 会被调用两次
                // 把 super touchEnded 放到延迟里调用会导致长按无法触发点击，先这么改，再想想怎么办。// [self qdim_touchesEnded:touches withEvent:event];
                [self sendActionsForAllTouchEventsIfCan];
                if (self.highlighted) {
                    [self setHighlighted:NO];
                }
            });
        } else {
            [self setHighlighted:NO];
        }
    } else {
        [self qdim_touchesEnded:touches withEvent:event];
    }
}

- (void)qdim_touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    if (self.qdim_automaticallyAdjustTouchHighlightedInScrollView) {
        self.canSetHighlighted = NO;
        [self qdim_touchesCancelled:touches withEvent:event];
        if (self.highlighted) {
            [self setHighlighted:NO];
        }
    } else {
        [self qdim_touchesCancelled:touches withEvent:event];
    }
}
EndIgnoreDeprecatedWarning

- (BOOL)qdim_pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    if (([event type] != UIEventTypeTouches)) {
        return [self qdim_pointInside:point withEvent:event];
    }
    UIEdgeInsets qdim_outsideEdge = self.qdim_outsideEdge;
    CGRect boundsInsetOutsideEdge = CGRectMake(CGRectGetMinX(self.bounds) + qdim_outsideEdge.left, CGRectGetMinY(self.bounds) + qdim_outsideEdge.top, CGRectGetWidth(self.bounds) - qdim_UIEdgeInsetsGetHorizontalValue(qdim_outsideEdge), CGRectGetHeight(self.bounds) - qdim_UIEdgeInsetsGetVerticalValue(qdim_outsideEdge));
    return CGRectContainsPoint(boundsInsetOutsideEdge, point);
}

// 这段代码需要以一个独立的方法存在，因为一旦有坑，外面可以直接通过runtime调用这个方法
// 但，不要开放到.h文件里，理论上外面不应该用到它
- (void)sendActionsForAllTouchEventsIfCan {
    self.touchEndCount += 1;
    if (self.touchEndCount == 1) {
        [self sendActionsForControlEvents:UIControlEventAllTouchEvents];
    }
}

- (void)setQdim_setHighlightedBlock:(void (^)(BOOL))qdim_setHighlightedBlock {
    objc_setAssociatedObject(self, @selector(qdim_setHighlightedBlock), qdim_setHighlightedBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)(BOOL))qdim_setHighlightedBlock {
    return objc_getAssociatedObject(self, _cmd);
}

@end
