//
//  QDIMNavigationButton.m
//  QDIM-QDIM
//
//  Created by qd-hxt on 2018/3/12.
//

#import "QDIMNavigationButton.h"
#import "QDIMCommonDefines.h"
#import "QDIMConfigurationMacros.h"
#import "UIImage+QDIM.h"
#import "UIViewController+QDIM.h"

@interface QDIMNavigationButton()

@property(nonatomic, assign) QDIMNavigationButtonPosition buttonPosition;
@end

@implementation QDIMNavigationButton

- (instancetype)init {
    return [self initWithType:QDIMNavigationButtonTypeNormal];
}

- (instancetype)initWithType:(QDIMNavigationButtonType)type {
    return [self initWithType:type title:nil];
}

- (instancetype)initWithType:(QDIMNavigationButtonType)type title:(NSString *)title {
    if (self = [super initWithFrame:CGRectZero]) {
        _type = type;
        self.buttonPosition = QDIMNavigationButtonPositionNone;
        self.useForBarButtonItem = YES;
        [self setTitle:title forState:UIControlStateNormal];
        [self renderButtonStyle];
        [self sizeToFit];
    }
    return self;
}

- (instancetype)initWithImage:(UIImage *)image {
    if (self = [self initWithType:QDIMNavigationButtonTypeImage]) {
        [self setImage:image forState:UIControlStateNormal];
        // 系统在iOS8及以后的版本默认对image的UIBarButtonItem加了上下3、左右11的padding，所以这里统一一下
        self.contentEdgeInsets = UIEdgeInsetsMake(3, 11, 3, 11);
        [self sizeToFit];
    }
    return self;
}

// 对按钮内容添加偏移，让UIBarButtonItem适配最新设备的系统行为，统一位置
- (UIEdgeInsets)alignmentRectInsets {
    
    UIEdgeInsets insets = [super alignmentRectInsets];
    if (!self.useForBarButtonItem || self.buttonPosition == QDIMNavigationButtonPositionNone) {
        return insets;
    }
    
    if (self.buttonPosition == QDIMNavigationButtonPositionLeft) {
        // 正值表示往左偏移
        if (self.type == QDIMNavigationButtonTypeImage) {
            insets = qdim_UIEdgeInsetsSetLeft(insets, 11);
        } else {
            insets = qdim_UIEdgeInsetsSetLeft(insets, 8);
        }
    } else if (self.buttonPosition == QDIMNavigationButtonPositionRight) {
        // 正值表示往右偏移
        if (self.type == QDIMNavigationButtonTypeImage) {
            insets = qdim_UIEdgeInsetsSetRight(insets, 11);
        } else {
            insets = qdim_UIEdgeInsetsSetRight(insets, 8);
        }
    }
    
    
    BOOL isBackOrImageType = self.type == QDIMNavigationButtonTypeBack || self.type == QDIMNavigationButtonTypeImage;
    if (isBackOrImageType) {
        insets = qdim_UIEdgeInsetsSetTop(insets, QDIM_PixelOne);
    } else {
        insets = qdim_UIEdgeInsetsSetTop(insets, 1);
    }
    
    return insets;
}

- (void)renderButtonStyle {
    UIFont *font = QDIM_NavBarButtonFont;
    if (font) {
        self.titleLabel.font = font;
    }
    self.titleLabel.backgroundColor = QDIM_UIColorClear;
    self.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.contentMode = UIViewContentModeCenter;
    self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.adjustsImageWhenHighlighted = NO;
    self.adjustsImageWhenDisabled = NO;
    
    switch (self.type) {
        case QDIMNavigationButtonTypeNormal:
        case QDIMNavigationButtonTypeImage:
            break;
        case QDIMNavigationButtonTypeBold: {
            font = QDIM_NavBarButtonFontBold;
            if (font) {
                self.titleLabel.font = font;
            }
        }
            break;
        case QDIMNavigationButtonTypeBack: {
            self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            UIImage *backIndicatorImage = QDIM_NavBarBackIndicatorImage;
            if (!backIndicatorImage) {
                NSLog(@"NavBarBackIndicatorImage 为 nil，无法创建正确的 QDIMNavigationButtonTypeBack 按钮");
                return;
            }
            [self setImage:backIndicatorImage forState:UIControlStateNormal];
            [self setImage:[backIndicatorImage qdim_imageWithAlpha:QDIM_NavBarHighlightedAlpha] forState:UIControlStateHighlighted];
            [self setImage:[backIndicatorImage qdim_imageWithAlpha:QDIM_NavBarDisabledAlpha] forState:UIControlStateDisabled];
        }
            break;
            
        default:
            break;
    }
}

- (void)setUseForBarButtonItem:(BOOL)useForBarButtonItem {
    if (_useForBarButtonItem != useForBarButtonItem) {
        if (self.type == QDIMNavigationButtonTypeBack) {
            // 只针对返回按钮，调整箭头和title之间的间距
            // @warning 这些数值都是每个iOS版本核对过没问题的，如果修改则要检查要每个版本里与系统UIBarButtonItem的布局是否一致
            if (useForBarButtonItem) {
                UIOffset titleOffsetBaseOnSystem = UIOffsetMake(QDIM_IOS_VERSION >= 11.0 ? 6 : 7, 0);// 经过这些数值的调整后，自定义返回按钮的位置才能和系统默认返回按钮的位置对准，而配置表里设置的值是在这个调整的基础上再调整
                UIOffset configurationOffset = QDIM_NavBarBarBackButtonTitlePositionAdjustment;
                self.titleEdgeInsets = UIEdgeInsetsMake(titleOffsetBaseOnSystem.vertical + configurationOffset.vertical, titleOffsetBaseOnSystem.horizontal + configurationOffset.horizontal, -titleOffsetBaseOnSystem.vertical - configurationOffset.vertical, -titleOffsetBaseOnSystem.horizontal - configurationOffset.horizontal);
                self.contentEdgeInsets = UIEdgeInsetsMake(QDIM_IOS_VERSION >= 11.0 ? 0 : 1,// iOS 11 以前的自定义返回按钮要特地往下偏移一点才会和系统的一模一样
                                                          QDIM_IOS_VERSION >= 11.0 ? -8 : 0,// iOS 11 使用了自定义按钮后整个按钮都会强制被往右边挪 8pt，所以这里要通过 contentEdgeInsets.left 偏移回来
                                                          0,
                                                          self.titleEdgeInsets.left);// 保证 button 有足够的宽度
            }
            // 由于contentEdgeInsets会影响frame的大小，所以更新数值后需要重新计算size
            [self sizeToFit];
        }
    }
    _useForBarButtonItem = useForBarButtonItem;
}

- (void)setImage:(UIImage *)image forState:(UIControlState)state {
    if (image && image.renderingMode == UIImageRenderingModeAutomatic) {
        // 由于 QDIMNavigationButton 是用于 UIBarButtonItem 的，所以默认的行为应该是尽量去跟随 tintColor，所以做了这个优化
        image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    }
    [super setImage:image forState:state];
}

// 自定义nav按钮，需要根据这个来修改title的三态颜色。
- (void)tintColorDidChange {
    [super tintColorDidChange];
    [self setTitleColor:self.tintColor forState:UIControlStateNormal];
    [self setTitleColor:[self.tintColor colorWithAlphaComponent:QDIM_NavBarHighlightedAlpha] forState:UIControlStateHighlighted];
    [self setTitleColor:[self.tintColor colorWithAlphaComponent:QDIM_NavBarDisabledAlpha] forState:UIControlStateDisabled];
}

// 返回按钮的文字会自动匹配上一个界面的title，如果需要自定义title，则直接用initWithType:title:工具类来做
+ (UIBarButtonItem *)backBarButtonItemWithTarget:(id)target action:(SEL)selector tintColor:(UIColor *)tintColor {
    NSString *backTitle = nil;
    if (QDIM_NeedsBackBarButtonItemTitle) {
        backTitle = @"返回"; // 默认文字用返回
        
        if ([target isKindOfClass:[UIViewController class]]) {
            UIViewController *viewController = (UIViewController *)target;
            UIViewController *previousViewController = viewController.qdim_previousViewController;
            if (previousViewController.navigationItem.backBarButtonItem) {
                // 如果前一个界面有
                backTitle = previousViewController.navigationItem.backBarButtonItem.title;
                
            } else if (previousViewController.title) {
                backTitle = previousViewController.title;
            }
        }
        
    } else {
        backTitle = @" ";
    }
    
    return [self systemBarButtonItemWithType:QDIMNavigationButtonTypeBack title:backTitle tintColor:tintColor position:QDIMNavigationButtonPositionLeft target:target action:selector];
}

+ (UIBarButtonItem *)backBarButtonItemWithTarget:(id)target action:(SEL)selector {
    return [self backBarButtonItemWithTarget:target action:selector tintColor:nil];
}

+ (UIBarButtonItem *)closeBarButtonItemWithTarget:(id)target action:(SEL)selector tintColor:(UIColor *)tintColor {
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:QDIM_NavBarCloseButtonImage style:UIBarButtonItemStylePlain target:target action:selector];
    item.tintColor = tintColor;
    return item;
}

+ (UIBarButtonItem *)closeBarButtonItemWithTarget:(id)target action:(SEL)selector {
    return [self closeBarButtonItemWithTarget:target action:selector tintColor:nil];
}

+ (UIBarButtonItem *)barButtonItemWithNavigationButton:(QDIMNavigationButton *)button tintColor:(UIColor *)tintColor position:(QDIMNavigationButtonPosition)position target:(id)target action:(SEL)selector {
    if (target) {
        [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    }
    button.tintColor = tintColor;
    button.buttonPosition = position;
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    return barButtonItem;
}

+ (UIBarButtonItem *)barButtonItemWithNavigationButton:(QDIMNavigationButton *)button position:(QDIMNavigationButtonPosition)position target:(id)target action:(SEL)selector {
    return [self barButtonItemWithNavigationButton:button tintColor:nil position:position target:target action:selector];
}

+ (UIBarButtonItem *)barButtonItemWithType:(QDIMNavigationButtonType)type title:(NSString *)title tintColor:(UIColor *)tintColor position:(QDIMNavigationButtonPosition)position target:(id)target action:(SEL)selector {
    UIBarButtonItem *barButtonItem = [QDIMNavigationButton systemBarButtonItemWithType:type title:title tintColor:tintColor position:position target:target action:selector];
    return barButtonItem;
}

+ (UIBarButtonItem *)barButtonItemWithType:(QDIMNavigationButtonType)type title:(NSString *)title position:(QDIMNavigationButtonPosition)position target:(id)target action:(SEL)selector {
    return [QDIMNavigationButton barButtonItemWithType:type title:title tintColor:nil position:position target:target action:selector];
}

+ (UIBarButtonItem *)barButtonItemWithImage:(UIImage *)image tintColor:(UIColor *)tintColor position:(QDIMNavigationButtonPosition)position target:(id)target action:(SEL)selector {
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:target action:selector];
    barButtonItem.tintColor = tintColor;
    return barButtonItem;
}

+ (UIBarButtonItem *)barButtonItemWithImage:(UIImage *)image position:(QDIMNavigationButtonPosition)position target:(id)target action:(SEL)selector {
    return [QDIMNavigationButton barButtonItemWithImage:image tintColor:nil position:position target:target action:selector];
}

+ (UIBarButtonItem *)systemBarButtonItemWithType:(QDIMNavigationButtonType)type title:(NSString *)title tintColor:(UIColor *)tintColor position:(QDIMNavigationButtonPosition)position target:(id)target action:(SEL)selector {
    switch (type) {
            
        case QDIMNavigationButtonTypeBack:
        {
            // 因为有可能出现有箭头图片又有title的情况，所以这里不适合用barButtonItemWithImage:target:action:的那个接口
            QDIMNavigationButton *button = [[QDIMNavigationButton alloc] initWithType:QDIMNavigationButtonTypeBack title:title];
            button.buttonPosition = position;
            [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
            button.tintColor = tintColor;
            UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
            return barButtonItem;
        }
            break;
            
        case QDIMNavigationButtonTypeBold:
        {
            UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStyleDone target:target action:selector];
            barButtonItem.tintColor = tintColor;
            if (QDIM_NavBarButtonFontBold) {
                [barButtonItem setTitleTextAttributes:@{NSFontAttributeName:QDIM_NavBarButtonFontBold} forState:UIControlStateNormal];
                [barButtonItem setTitleTextAttributes:[barButtonItem titleTextAttributesForState:UIControlStateNormal] forState:UIControlStateHighlighted];// iOS 11 如果不显式设置 highlighted 的样式，点击时字体会从加粗变成默认，导致抖动
            }
            return barButtonItem;
        }
            break;
            
        case QDIMNavigationButtonTypeImage:
            // icon - 这种类型请通过barButtonItemWithImage:position:target:action:来定义
            return nil;
            
        default:
        {
            UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:target action:selector];
            barButtonItem.tintColor = tintColor;
            return barButtonItem;
        }
            break;
    }
}

@end
