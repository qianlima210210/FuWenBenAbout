//
//  UIView+QDIM.m
//  QDIM
//
//  Created by qd-hxt on 2018/3/13.
//

#import "UIView+QDIM.h"
#import "QDIMHeader.h"
#import "CALayer+QDIM.h"
#import "UIColor+QDIM.h"
#import "NSObject+QDIM.h"
#import "UIImage+QDIM.h"
#import <objc/runtime.h>

@interface UIView ()

/// QDIM_Debug
@property(nonatomic, assign, readwrite) BOOL qdim_hasDebugColor;
/// QDIM_Border
@property(nonatomic, strong, readwrite) CAShapeLayer *qdim_borderLayer;

@end

@implementation UIView (QDIM)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        if (@available(iOS 11, *)) {
            QDIM_ReplaceMethod([self class], @selector(safeAreaInsetsDidChange), @selector(qdim_safeAreaInsetsDidChange));
        }
        
        // 检查调用这系列方法的两个 view 是否存在共同的父 view，不存在则可能导致转换结果错误
        QDIM_ReplaceMethod([self class], @selector(convertPoint:toView:), @selector(qdim_convertPoint:toView:));
        QDIM_ReplaceMethod([self class], @selector(convertPoint:fromView:), @selector(qdim_convertPoint:fromView:));
        QDIM_ReplaceMethod([self class], @selector(convertRect:toView:), @selector(qdim_convertRect:toView:));
        QDIM_ReplaceMethod([self class], @selector(convertRect:fromView:), @selector(qdim_convertRect:fromView:));
    });
}

- (instancetype)qdim_initWithSize:(CGSize)size {
    return [self initWithFrame:qdim_CGRectMakeWithSize(size)];
}

- (UIEdgeInsets)qdim_safeAreaInsets {
    if (@available(iOS 11.0, *)) {
        return self.safeAreaInsets;
    }
    return UIEdgeInsetsZero;
}

static char kAssociatedObjectKey_safeAreaInsetsBeforeChange;
- (void)setQdim_safeAreaInsetsBeforeChange:(UIEdgeInsets)qdim_safeAreaInsetsBeforeChange {
    objc_setAssociatedObject(self, &kAssociatedObjectKey_safeAreaInsetsBeforeChange, [NSValue valueWithUIEdgeInsets:qdim_safeAreaInsetsBeforeChange], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIEdgeInsets)qdim_safeAreaInsetsBeforeChange {
    return [((NSValue *)objc_getAssociatedObject(self, &kAssociatedObjectKey_safeAreaInsetsBeforeChange)) UIEdgeInsetsValue];
}

- (void)qdim_safeAreaInsetsDidChange {
    [self qdim_safeAreaInsetsDidChange];
    self.qdim_safeAreaInsetsBeforeChange = self.qdim_safeAreaInsets;
}

- (void)qdim_removeAllSubviews {
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

+ (void)qdim_animateWithAnimated:(BOOL)animated duration:(NSTimeInterval)duration delay:(NSTimeInterval)delay options:(UIViewAnimationOptions)options animations:(void (^)(void))animations completion:(void (^)(BOOL finished))completion {
    if (animated) {
        [UIView animateWithDuration:duration delay:delay options:options animations:animations completion:completion];
    } else {
        if (animations) {
            animations();
        }
        if (completion) {
            completion(YES);
        }
    }
}

+ (void)qdim_animateWithAnimated:(BOOL)animated duration:(NSTimeInterval)duration animations:(void (^)(void))animations completion:(void (^)(BOOL finished))completion {
    if (animated) {
        [UIView animateWithDuration:duration animations:animations completion:completion];
    } else {
        if (animations) {
            animations();
        }
        if (completion) {
            completion(YES);
        }
    }
}

+ (void)qdim_animateWithAnimated:(BOOL)animated duration:(NSTimeInterval)duration animations:(void (^)(void))animations {
    if (animated) {
        [UIView animateWithDuration:duration animations:animations];
    } else {
        if (animations) {
            animations();
        }
    }
}

- (BOOL)hasSharedAncestorViewWithView:(UIView *)view {
    UIView *sharedAncestorView = self;
    if (!view) {
        return YES;
    }
    while (sharedAncestorView && ![view isDescendantOfView:sharedAncestorView]) {
        sharedAncestorView = sharedAncestorView.superview;
    }
    return !!sharedAncestorView;
}

- (BOOL)isUIKitPrivateView {
    // 系统有些东西本身也存在不合理，但我们不关心这种，所以过滤掉
    if ([self isKindOfClass:[UIWindow class]]) return YES;
    
    __block BOOL isPrivate = NO;
    NSString *classString = NSStringFromClass(self.class);
    [@[@"LayoutContainer", @"NavigationItemButton", @"NavigationItemView", @"SelectionGrabber", @"InputViewContent"] enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (([classString hasPrefix:@"UI"] || [classString hasPrefix:@"_UI"]) && [classString containsString:obj]) {
            isPrivate = YES;
            *stop = YES;
        }
    }];
    return isPrivate;
}

- (void)alertConvertValueWithView:(UIView *)view {
    if (QDIM_IS_DEBUG && ![self isUIKitPrivateView] && ![self hasSharedAncestorViewWithView:view]) {
        NSLog(@"进行坐标系转换运算的 %@ 和 %@ 不存在共同的父 view，可能导致运算结果不准确（特别是在横屏状态下）", self, view);
    }
}

- (CGPoint)qdim_convertPoint:(CGPoint)point toView:(nullable UIView *)view {
    [self alertConvertValueWithView:view];
    return [self qdim_convertPoint:point toView:view];
}

- (CGPoint)qdim_convertPoint:(CGPoint)point fromView:(nullable UIView *)view {
    [self alertConvertValueWithView:view];
    return [self qdim_convertPoint:point fromView:view];
}

- (CGRect)qdim_convertRect:(CGRect)rect toView:(nullable UIView *)view {
    [self alertConvertValueWithView:view];
    return [self qdim_convertRect:rect toView:view];
}

- (CGRect)qdim_convertRect:(CGRect)rect fromView:(nullable UIView *)view {
    [self alertConvertValueWithView:view];
    return [self qdim_convertRect:rect fromView:view];
}

@end


@implementation UIView (QDIM_Runtime)

- (BOOL)qdim_hasOverrideUIKitMethod:(SEL)selector {
    // 排序依照 Xcode Interface Builder 里的控件排序，但保证子类在父类前面
    NSMutableArray<Class> *viewSuperclasses = [[NSMutableArray alloc] initWithObjects:
                                               [UILabel class],
                                               [UIButton class],
                                               [UISegmentedControl class],
                                               [UITextField class],
                                               [UISlider class],
                                               [UISwitch class],
                                               [UIActivityIndicatorView class],
                                               [UIProgressView class],
                                               [UIPageControl class],
                                               [UIStepper class],
                                               [UITableView class],
                                               [UITableViewCell class],
                                               [UIImageView class],
                                               [UICollectionView class],
                                               [UICollectionViewCell class],
                                               [UICollectionReusableView class],
                                               [UITextView class],
                                               [UIScrollView class],
                                               [UIDatePicker class],
                                               [UIPickerView class],
                                               [UIVisualEffectView class],
                                               [UIWebView class],
                                               [UIWindow class],
                                               [UINavigationBar class],
                                               [UIToolbar class],
                                               [UITabBar class],
                                               [UISearchBar class],
                                               [UIControl class],
                                               [UIView class],
                                               nil];
    
    if (@available(iOS 9.0, *)) {
        [viewSuperclasses insertObject:[UIStackView class] atIndex:0];
    }
    
    for (NSInteger i = 0, l = viewSuperclasses.count; i < l; i++) {
        Class superclass = viewSuperclasses[i];
        if ([self qdim_hasOverrideMethod:selector ofSuperclass:superclass]) {
            return YES;
        }
    }
    return NO;
}

@end


@implementation UIView (QDIM_Debug)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        QDIM_ReplaceMethod([self class], @selector(layoutSubviews), @selector(qdim_debug_layoutSubviews));
        QDIM_ReplaceMethod([self class], @selector(addSubview:), @selector(qdim_debug_addSubview:));
        QDIM_ReplaceMethod([self class], @selector(becomeFirstResponder), @selector(qdim_debug_becomeFirstResponder));
    });
}

static char kAssociatedObjectKey_needsDifferentDebugColor;
- (void)setQdim_needsDifferentDebugColor:(BOOL)qdim_needsDifferentDebugColor {
    objc_setAssociatedObject(self, &kAssociatedObjectKey_needsDifferentDebugColor, @(qdim_needsDifferentDebugColor), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (BOOL)qdim_needsDifferentDebugColor {
    BOOL flag = [objc_getAssociatedObject(self, &kAssociatedObjectKey_needsDifferentDebugColor) boolValue];
    return flag;
}

static char kAssociatedObjectKey_shouldShowDebugColor;
- (void)setQdim_shouldShowDebugColor:(BOOL)qdim_shouldShowDebugColor {
    objc_setAssociatedObject(self, &kAssociatedObjectKey_shouldShowDebugColor, @(qdim_shouldShowDebugColor), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (qdim_shouldShowDebugColor) {
        [self setNeedsLayout];
    }
}
- (BOOL)qdim_shouldShowDebugColor {
    BOOL flag = [objc_getAssociatedObject(self, &kAssociatedObjectKey_shouldShowDebugColor) boolValue];
    return flag;
}

static char kAssociatedObjectKey_hasDebugColor;
- (void)setQdim_hasDebugColor:(BOOL)qdim_hasDebugColor {
    objc_setAssociatedObject(self, &kAssociatedObjectKey_hasDebugColor, @(qdim_hasDebugColor), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (BOOL)qdim_hasDebugColor {
    BOOL flag = [objc_getAssociatedObject(self, &kAssociatedObjectKey_hasDebugColor) boolValue];
    return flag;
}

- (void)qdim_debug_layoutSubviews {
    [self qdim_debug_layoutSubviews];
    if (self.qdim_shouldShowDebugColor) {
        self.qdim_hasDebugColor = YES;
        self.backgroundColor = [self debugColor];
        [self renderColorWithSubviews:self.subviews];
    }
}

- (void)renderColorWithSubviews:(NSArray *)subviews {
    for (UIView *view in subviews) {
        if (@available(iOS 9.0, *)) {
            if ([view isKindOfClass:[UIStackView class]]) {
                UIStackView *stackView = (UIStackView *)view;
                [self renderColorWithSubviews:stackView.arrangedSubviews];
            }
        }
        view.qdim_hasDebugColor = YES;
        view.qdim_shouldShowDebugColor = self.qdim_shouldShowDebugColor;
        view.qdim_needsDifferentDebugColor = self.qdim_needsDifferentDebugColor;
        view.backgroundColor = [self debugColor];
    }
}

- (UIColor *)debugColor {
    if (!self.qdim_needsDifferentDebugColor) {
        return QDIM_UIColorTestRed;
    } else {
        return [[UIColor qdim_randomColor] colorWithAlphaComponent:.8];
    }
}

- (void)qdim_debug_addSubview:(UIView *)view {
    if (view == self) {
        NSAssert(NO, @"把自己作为 subview 添加到自己身上！\n%@", [NSThread callStackSymbols]);
    }
    [self qdim_debug_addSubview:view];
}

- (BOOL)qdim_debug_becomeFirstResponder {
    if (QDIM_IS_SIMULATOR && ![self isKindOfClass:[UIWindow class]] && self.window && !self.window.keyWindow) {
        [self QDIMSymbolicUIViewBecomeFirstResponderWithoutKeyWindow];
    }
    return [self qdim_debug_becomeFirstResponder];
}

- (void)QDIMSymbolicUIViewBecomeFirstResponderWithoutKeyWindow {
    NSLog(@"尝试让一个处于非 keyWindow 上的 %@ becomeFirstResponder，可能导致界面显示异常，请添加 '%@' 的 Symbolic Breakpoint 以捕捉此类信息\n%@", NSStringFromClass(self.class), NSStringFromSelector(_cmd), [NSThread callStackSymbols]);
}

@end


@implementation UIView (QDIM_Border)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        QDIM_ReplaceMethod([self class], @selector(initWithFrame:), @selector(qdim_initWithFrame:));
        QDIM_ReplaceMethod([self class], @selector(initWithCoder:), @selector(qdim_initWithCoder:));
        QDIM_ReplaceMethod([self class], @selector(layoutSublayersOfLayer:), @selector(qdim_layoutSublayersOfLayer:));
    });
}

- (instancetype)qdim_initWithFrame:(CGRect)frame {
    [self qdim_initWithFrame:frame];
    [self setDefaultStyle];
    return self;
}

- (instancetype)qdim_initWithCoder:(NSCoder *)aDecoder {
    [self qdim_initWithCoder:aDecoder];
    [self setDefaultStyle];
    return self;
}

- (void)qdim_layoutSublayersOfLayer:(CALayer *)layer {
    
    [self qdim_layoutSublayersOfLayer:layer];
    
    if ((!self.qdim_borderLayer && self.qdim_borderPosition == QDIMBorderViewPositionNone) || (!self.qdim_borderLayer && self.qdim_borderWidth == 0)) {
        return;
    }
    
    if (self.qdim_borderLayer && self.qdim_borderPosition == QDIMBorderViewPositionNone && !self.qdim_borderLayer.path) {
        return;
    }
    
    if (self.qdim_borderLayer && self.qdim_borderWidth == 0 && self.qdim_borderLayer.lineWidth == 0) {
        return;
    }
    
    if (!self.qdim_borderLayer) {
        self.qdim_borderLayer = [CAShapeLayer layer];
        [self.qdim_borderLayer qdim_removeDefaultAnimations];
        [self.layer addSublayer:self.qdim_borderLayer];
    }
    self.qdim_borderLayer.frame = self.bounds;
    
    CGFloat borderWidth = self.qdim_borderWidth;
    self.qdim_borderLayer.lineWidth = borderWidth;
    self.qdim_borderLayer.strokeColor = self.qdim_borderColor.CGColor;
    self.qdim_borderLayer.lineDashPhase = self.qdim_dashPhase;
    if (self.qdim_dashPattern) {
        self.qdim_borderLayer.lineDashPattern = self.qdim_dashPattern;
    }
    
    UIBezierPath *path = nil;
    
    if (self.qdim_borderPosition != QDIMBorderViewPositionNone) {
        path = [UIBezierPath bezierPath];
    }
    
    if (self.qdim_borderPosition & QDIMBorderViewPositionTop) {
        [path moveToPoint:CGPointMake(0, borderWidth / 2)];
        [path addLineToPoint:CGPointMake(CGRectGetWidth(self.bounds), borderWidth / 2)];
    }
    
    if (self.qdim_borderPosition & QDIMBorderViewPositionLeft) {
        [path moveToPoint:CGPointMake(borderWidth / 2, 0)];
        [path addLineToPoint:CGPointMake(borderWidth / 2, CGRectGetHeight(self.bounds) - 0)];
    }
    
    if (self.qdim_borderPosition & QDIMBorderViewPositionBottom) {
        [path moveToPoint:CGPointMake(0, CGRectGetHeight(self.bounds) - borderWidth / 2)];
        [path addLineToPoint:CGPointMake(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) - borderWidth / 2)];
    }
    
    if (self.qdim_borderPosition & QDIMBorderViewPositionRight) {
        [path moveToPoint:CGPointMake(CGRectGetWidth(self.bounds) - borderWidth / 2, 0)];
        [path addLineToPoint:CGPointMake(CGRectGetWidth(self.bounds) - borderWidth / 2, CGRectGetHeight(self.bounds))];
    }
    
    self.qdim_borderLayer.path = path.CGPath;
}

- (void)setDefaultStyle {
    self.qdim_borderWidth = QDIM_PixelOne;
    self.qdim_borderColor = QDIM_UIColorSeparator;
}

static char kAssociatedObjectKey_borderPosition;
- (void)setQdim_borderPosition:(QDIMBorderViewPosition)qdim_borderPosition {
    objc_setAssociatedObject(self, &kAssociatedObjectKey_borderPosition, @(qdim_borderPosition), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self setNeedsLayout];
}

- (QDIMBorderViewPosition)qdim_borderPosition {
    return (QDIMBorderViewPosition)[objc_getAssociatedObject(self, &kAssociatedObjectKey_borderPosition) unsignedIntegerValue];
}

static char kAssociatedObjectKey_borderWidth;
- (void)setQdim_borderWidth:(CGFloat)qdim_borderWidth {
    objc_setAssociatedObject(self, &kAssociatedObjectKey_borderWidth, @(qdim_borderWidth), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self setNeedsLayout];
}

- (CGFloat)qdim_borderWidth {
    return (CGFloat)[objc_getAssociatedObject(self, &kAssociatedObjectKey_borderWidth) floatValue];
}

static char kAssociatedObjectKey_borderColor;
- (void)setQdim_borderColor:(UIColor *)qdim_borderColor {
    objc_setAssociatedObject(self, &kAssociatedObjectKey_borderColor, qdim_borderColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self setNeedsLayout];
}

- (UIColor *)qdim_borderColor {
    return (UIColor *)objc_getAssociatedObject(self, &kAssociatedObjectKey_borderColor);
}

static char kAssociatedObjectKey_dashPhase;
- (void)setQdim_dashPhase:(CGFloat)qdim_dashPhase {
    objc_setAssociatedObject(self, &kAssociatedObjectKey_dashPhase, @(qdim_dashPhase), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self setNeedsLayout];
}

- (CGFloat)qdim_dashPhase {
    return (CGFloat)[objc_getAssociatedObject(self, &kAssociatedObjectKey_dashPhase) floatValue];
}

static char kAssociatedObjectKey_dashPattern;
- (void)setQdim_dashPattern:(NSArray<NSNumber *> *)qdim_dashPattern {
    objc_setAssociatedObject(self, &kAssociatedObjectKey_dashPattern, qdim_dashPattern, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self setNeedsLayout];
}

- (NSArray *)qdim_dashPattern {
    return (NSArray<NSNumber *> *)objc_getAssociatedObject(self, &kAssociatedObjectKey_dashPattern);
}

static char kAssociatedObjectKey_borderLayer;
- (void)setQdim_borderLayer:(CAShapeLayer *)qdim_borderLayer {
    objc_setAssociatedObject(self, &kAssociatedObjectKey_borderLayer, qdim_borderLayer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CAShapeLayer *)qdim_borderLayer {
    return (CAShapeLayer *)objc_getAssociatedObject(self, &kAssociatedObjectKey_borderLayer);
}

@end


@implementation UIView (QDIM_Layout)

- (CGFloat)qdim_top {
    return CGRectGetMinY(self.frame);
}

- (void)setQdim_top:(CGFloat)top {
    self.frame = qdim_CGRectSetY(self.frame, top);
}

- (CGFloat)qdim_left {
    return CGRectGetMinX(self.frame);
}

- (void)setQdim_left:(CGFloat)left {
    self.frame = qdim_CGRectSetX(self.frame, left);
}

- (CGFloat)qdim_bottom {
    return CGRectGetMaxY(self.frame);
}

- (void)setQdim_bottom:(CGFloat)bottom {
    self.frame = qdim_CGRectSetY(self.frame, bottom - CGRectGetHeight(self.frame));
}

- (CGFloat)qdim_right {
    return CGRectGetMaxX(self.frame);
}

- (void)setQdim_right:(CGFloat)right {
    self.frame = qdim_CGRectSetX(self.frame, right - CGRectGetWidth(self.frame));
}

- (CGFloat)qdim_width {
    return CGRectGetWidth(self.frame);
}

- (void)setQdim_width:(CGFloat)width {
    self.frame = qdim_CGRectSetWidth(self.frame, width);
}

- (CGFloat)qdim_height {
    return CGRectGetHeight(self.frame);
}

- (void)setQdim_height:(CGFloat)height {
    self.frame = qdim_CGRectSetHeight(self.frame, height);
}

- (CGFloat)qdim_extendToTop {
    return self.qdim_top;
}

- (void)setQdim_extendToTop:(CGFloat)qdim_extendToTop {
    self.qdim_height = self.qdim_bottom - qdim_extendToTop;
    self.qdim_top = qdim_extendToTop;
}

- (CGFloat)qdim_extendToLeft {
    return self.qdim_left;
}

- (void)setQdim_extendToLeft:(CGFloat)qdim_extendToLeft {
    self.qdim_width = self.qdim_right - qdim_extendToLeft;
    self.qdim_left = qdim_extendToLeft;
}

- (CGFloat)qdim_extendToBottom {
    return self.qdim_bottom;
}

- (void)setQdim_extendToBottom:(CGFloat)qdim_extendToBottom {
    self.qdim_height = qdim_extendToBottom - self.qdim_top;
    self.qdim_bottom = qdim_extendToBottom;
}

- (CGFloat)qdim_extendToRight {
    return self.qdim_right;
}

- (void)setQdim_extendToRight:(CGFloat)qdim_extendToRight {
    self.qdim_width = qdim_extendToRight - self.qdim_left;
    self.qdim_right = qdim_extendToRight;
}

- (CGFloat)qdim_leftWhenCenterInSuperview {
    return qdim_CGFloatGetCenter(CGRectGetWidth(self.superview.bounds), CGRectGetWidth(self.frame));
}

- (CGFloat)qdim_topWhenCenterInSuperview {
    return qdim_CGFloatGetCenter(CGRectGetHeight(self.superview.bounds), CGRectGetHeight(self.frame));
}

@end


@implementation UIView (QDIM_Snapshotting)

- (UIImage *)qdim_snapshotLayerImage {
    return [UIImage qdim_imageWithView:self];
}

- (UIImage *)qdim_snapshotImageAfterScreenUpdates:(BOOL)afterScreenUpdates {
    return [UIImage qdim_imageWithView:self afterScreenUpdates:afterScreenUpdates];
}

@end
