//
//  QDIMConfiguration.m
//  QDIM-QDIM
//
//  Created by qd-hxt on 2018/3/12.
//

#import "QDIMConfiguration.h"
#import <objc/runtime.h>
#import "QDIMCommonDefines.h"
#import "UIImage+QDIM.h"

@implementation QDIMConfiguration

+ (instancetype)sharedInstance {
    static dispatch_once_t pred;
    static QDIMConfiguration *sharedInstance;
    dispatch_once(&pred, ^{
        sharedInstance = [[QDIMConfiguration alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initDefaultConfiguration];
    }
    return self;
}

static BOOL QDIM_hasAppliedInitialTemplate;
- (void)applyInitialTemplate {
    if (QDIM_hasAppliedInitialTemplate) {
        return;
    }
    
    Protocol *protocol = @protocol(QDIMConfigurationTemplateProtocol);
    int numberOfClasses = objc_getClassList(NULL, 0);
    if (numberOfClasses > 0) {
        Class *classes = (__unsafe_unretained Class *)malloc(sizeof(Class) * numberOfClasses);
        numberOfClasses = objc_getClassList(classes, numberOfClasses);
        for (int i = 0; i < numberOfClasses; i++) {
            Class class = classes[i];
            if ([NSStringFromClass(class) hasPrefix:@"QDIMConfigurationTemplate"] && [class conformsToProtocol:protocol]) {
                if ([class instancesRespondToSelector:@selector(shouldApplyTemplateAutomatically)]) {
                    id<QDIMConfigurationTemplateProtocol> template = [[class alloc] init];
                    if ([template shouldApplyTemplateAutomatically]) {
                        QDIM_hasAppliedInitialTemplate = YES;
                        [template applyConfigurationTemplate];
                        // 只应用第一个 shouldApplyTemplateAutomatically 的主题
                        break;
                    }
                }
            }
        }
        free(classes);
    }
    
    QDIM_hasAppliedInitialTemplate = YES;
}

#pragma mark - 初始化默认值

- (void)initDefaultConfiguration {
    
#pragma mark - Global Color
    
    self.clearColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0];
    self.whiteColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    self.blackColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
    self.grayColor = QDIM_UIColorMake(179, 179, 179);
    self.grayDarkenColor = QDIM_UIColorMake(163, 163, 163);
    self.grayLightenColor = QDIM_UIColorMake(198, 198, 198);
    self.redColor = QDIM_UIColorMake(250, 58, 58);
    self.greenColor = QDIM_UIColorMake(159, 214, 97);
    self.blueColor = QDIM_UIColorMake(49, 189, 243);
    self.yellowColor = QDIM_UIColorMake(255, 207, 71);
    
    self.linkColor = QDIM_UIColorMake(56, 116, 171);
    self.disabledColor = self.grayColor;
    self.backgroundColor = self.whiteColor;
    self.maskDarkColor = QDIM_UIColorMakeWithRGBA(0, 0, 0, .35f);
    self.maskLightColor = QDIM_UIColorMakeWithRGBA(255, 255, 255, .5f);
    self.separatorColor = QDIM_UIColorMake(222, 224, 226);
    self.separatorDashedColor = QDIM_UIColorMake(17, 17, 17);
    self.placeholderColor = QDIM_UIColorMake(196, 200, 208);
    
    self.testColorRed = QDIM_UIColorMakeWithRGBA(255, 0, 0, .3);
    self.testColorGreen = QDIM_UIColorMakeWithRGBA(0, 255, 0, .3);
    self.testColorBlue = QDIM_UIColorMakeWithRGBA(0, 0, 255, .3);
    
#pragma mark - UIControl
    
    self.controlHighlightedAlpha = 0.5f;
    self.controlDisabledAlpha = 0.5f;
    
#pragma mark - UIButton
    
    self.buttonHighlightedAlpha = self.controlHighlightedAlpha;
    self.buttonDisabledAlpha = self.controlDisabledAlpha;
    self.buttonTintColor = self.blueColor;
    
    self.ghostButtonColorBlue = self.blueColor;
    self.ghostButtonColorRed = self.redColor;
    self.ghostButtonColorGreen = self.greenColor;
    self.ghostButtonColorGray = self.grayColor;
    self.ghostButtonColorWhite = self.whiteColor;
    
    self.fillButtonColorBlue = self.blueColor;
    self.fillButtonColorRed = self.redColor;
    self.fillButtonColorGreen = self.greenColor;
    self.fillButtonColorGray = self.grayColor;
    self.fillButtonColorWhite = self.whiteColor;
    
#pragma mark - UITextField & UITextView
    
    self.textFieldTintColor = nil;
    self.textFieldTextInsets = UIEdgeInsetsMake(0, 7, 0, 7);
    
#pragma mark - NavigationBar
    
    self.navBarHighlightedAlpha = 0.2f;
    self.navBarDisabledAlpha = 0.2f;
    self.navBarButtonFont = nil;
    self.navBarButtonFontBold = nil;
    self.navBarBackgroundImage = nil;
    self.navBarShadowImage = nil;
    self.navBarBarTintColor = nil;
    self.navBarTintColor = nil;
    self.navBarTitleColor = nil;
    self.navBarTitleFont = nil;
    self.navBarLargeTitleColor = nil;
    self.navBarLargeTitleFont = nil;
    self.navBarBackButtonTitlePositionAdjustment = UIOffsetZero;
    self.navBarBackIndicatorImage = nil;
    self.navBarCloseButtonImage = [UIImage qdim_imageWithShape:QDIMImageShapeNavClose size:CGSizeMake(16, 16) tintColor:self.navBarTintColor];
    
    self.navBarLoadingMarginRight = 3;
    self.navBarAccessoryViewMarginLeft = 5;
    self.navBarActivityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    self.navBarAccessoryViewTypeDisclosureIndicatorImage = [[UIImage qdim_imageWithShape:QDIMImageShapeTriangle size:CGSizeMake(8, 5) tintColor:self.navBarTitleColor] qdim_imageWithOrientation:UIImageOrientationDown];
    
#pragma mark - TabBar
    
    self.tabBarBackgroundImage = nil;
    self.tabBarBarTintColor = nil;
    self.tabBarShadowImageColor = nil;
    self.tabBarTintColor = nil;
    self.tabBarItemTitleColor = nil;
    self.tabBarItemTitleColorSelected = self.tabBarTintColor;
    self.tabBarItemTitleFont = nil;
    
#pragma mark - Toolbar
    
    self.toolBarHighlightedAlpha = 0.4f;
    self.toolBarDisabledAlpha = 0.4f;
    self.toolBarTintColor = nil;
    self.toolBarTintColorHighlighted = [self.toolBarTintColor colorWithAlphaComponent:self.toolBarHighlightedAlpha];
    self.toolBarTintColorDisabled = [self.toolBarTintColor colorWithAlphaComponent:self.toolBarDisabledAlpha];
    self.toolBarBackgroundImage = nil;
    self.toolBarBarTintColor = nil;
    self.toolBarShadowImageColor = nil;
    self.toolBarButtonFont = nil;
    
#pragma mark - SearchBar
    
    self.searchBarTextFieldBackground = nil;
    self.searchBarTextFieldBorderColor = nil;
    self.searchBarBottomBorderColor = nil;
    self.searchBarBarTintColor = nil;
    self.searchBarTintColor = nil;
    self.searchBarTextColor = nil;
    self.searchBarPlaceholderColor = self.placeholderColor;
    self.searchBarFont = nil;
    self.searchBarSearchIconImage = nil;
    self.searchBarClearIconImage = nil;
    self.searchBarTextFieldCornerRadius = 2.0;
    
#pragma mark - TableView / TableViewCell
    
    self.tableViewEstimatedHeightEnabled = YES;
    
    self.tableViewBackgroundColor = nil;
    self.tableViewGroupedBackgroundColor = nil;
    self.tableSectionIndexColor = nil;
    self.tableSectionIndexBackgroundColor = nil;
    self.tableSectionIndexTrackingBackgroundColor = nil;
    self.tableViewSeparatorColor = self.separatorColor;
    
    self.tableViewCellNormalHeight = 44;
    self.tableViewCellTitleLabelColor = nil;
    self.tableViewCellDetailLabelColor = nil;
    self.tableViewCellBackgroundColor = self.whiteColor;
    self.tableViewCellSelectedBackgroundColor = QDIM_UIColorMake(238, 239, 241);
    self.tableViewCellWarningBackgroundColor = self.yellowColor;
    self.tableViewCellDisclosureIndicatorImage = nil;
    self.tableViewCellCheckmarkImage = nil;
    self.tableViewCellDetailButtonImage = nil;
    self.tableViewCellSpacingBetweenDetailButtonAndDisclosureIndicator = 12;
    
    self.tableViewSectionHeaderBackgroundColor = QDIM_UIColorMake(244, 244, 244);
    self.tableViewSectionFooterBackgroundColor = QDIM_UIColorMake(244, 244, 244);
    self.tableViewSectionHeaderFont = QDIM_UIFontBoldMake(12);
    self.tableViewSectionFooterFont = QDIM_UIFontBoldMake(12);
    self.tableViewSectionHeaderTextColor = self.grayDarkenColor;
    self.tableViewSectionFooterTextColor = self.grayColor;
    self.tableViewSectionHeaderAccessoryMargins = UIEdgeInsetsMake(0, 15, 0, 0);
    self.tableViewSectionFooterAccessoryMargins = UIEdgeInsetsMake(0, 15, 0, 0);
    self.tableViewSectionHeaderContentInset = UIEdgeInsetsMake(4, 15, 4, 15);
    self.tableViewSectionFooterContentInset = UIEdgeInsetsMake(4, 15, 4, 15);
    
    self.tableViewGroupedSectionHeaderFont = QDIM_UIFontMake(12);
    self.tableViewGroupedSectionFooterFont = QDIM_UIFontMake(12);
    self.tableViewGroupedSectionHeaderTextColor = self.grayDarkenColor;
    self.tableViewGroupedSectionFooterTextColor = self.grayColor;
    self.tableViewGroupedSectionHeaderAccessoryMargins = UIEdgeInsetsMake(0, 15, 0, 0);
    self.tableViewGroupedSectionFooterAccessoryMargins = UIEdgeInsetsMake(0, 15, 0, 0);
    self.tableViewGroupedSectionHeaderDefaultHeight = UITableViewAutomaticDimension;
    self.tableViewGroupedSectionFooterDefaultHeight = UITableViewAutomaticDimension;
    self.tableViewGroupedSectionHeaderContentInset = UIEdgeInsetsMake(16, 15, 8, 15);
    self.tableViewGroupedSectionFooterContentInset = UIEdgeInsetsMake(8, 15, 2, 15);
    
#pragma mark - UIWindowLevel
    self.windowLevelQDIMAlertView = UIWindowLevelAlert - 4.0;
    self.windowLevelQDIMImagePreviewView = UIWindowLevelStatusBar + 1;
    
#pragma mark - QMUILog
    self.shouldPrintDefaultLog = YES;
    self.shouldPrintInfoLog = YES;
    self.shouldPrintWarnLog = YES;
    
#pragma mark - Others
    
    self.supportedOrientationMask = UIInterfaceOrientationMaskPortrait;
    self.automaticallyRotateDeviceOrientation = NO;
    self.statusbarStyleLightInitially = YES;
    self.needsBackBarButtonItemTitle = NO;
    self.hidesBottomBarWhenPushedInitially = YES;
    self.preventConcurrentNavigationControllerTransitions = YES;
    self.navigationBarHiddenInitially = NO;
    self.shouldFixTabBarTransitionBugInIPhoneX = NO;
}

- (void)setNavBarButtonFont:(UIFont *)navBarButtonFont {
    _navBarButtonFont = navBarButtonFont;
}

- (void)setNavBarTintColor:(UIColor *)navBarTintColor {
    _navBarTintColor = navBarTintColor;
    if (navBarTintColor) {
        NSLog(@"%@", [QDIMHelper visibleViewController]);
        [QDIMHelper visibleViewController].navigationController.navigationBar.tintColor = _navBarTintColor;
    }
}

- (void)setNavBarBarTintColor:(UIColor *)navBarBarTintColor {
    _navBarBarTintColor = navBarBarTintColor;
    if (navBarBarTintColor) {
        [UINavigationBar appearance].barTintColor = _navBarBarTintColor;
        [QDIMHelper visibleViewController].navigationController.navigationBar.barTintColor = _navBarBarTintColor;
    }
}

- (void)setNavBarShadowImage:(UIImage *)navBarShadowImage {
    _navBarShadowImage = navBarShadowImage;
    if (navBarShadowImage) {
        [UINavigationBar appearance].shadowImage = _navBarShadowImage;
        [QDIMHelper visibleViewController].navigationController.navigationBar.shadowImage = _navBarShadowImage;
    }
}

- (void)setNavBarBackgroundImage:(UIImage *)navBarBackgroundImage {
    _navBarBackgroundImage = navBarBackgroundImage;
    if (navBarBackgroundImage) {
        [[UINavigationBar appearance] setBackgroundImage:_navBarBackgroundImage forBarMetrics:UIBarMetricsDefault];
        [[QDIMHelper visibleViewController].navigationController.navigationBar setBackgroundImage:_navBarBackgroundImage forBarMetrics:UIBarMetricsDefault];
    }
}

- (void)setNavBarTitleFont:(UIFont *)navBarTitleFont {
    _navBarTitleFont = navBarTitleFont;
    [self updateNavigationBarTitleAttributesIfNeeded];
}

- (void)setNavBarTitleColor:(UIColor *)navBarTitleColor {
    _navBarTitleColor = navBarTitleColor;
    [self updateNavigationBarTitleAttributesIfNeeded];
}

- (void)updateNavigationBarTitleAttributesIfNeeded {
    if (self.navBarTitleFont || self.navBarTitleColor) {
        NSMutableDictionary<NSString *, id> *titleTextAttributes = [[NSMutableDictionary alloc] init];
        if (self.navBarTitleFont) {
            [titleTextAttributes setValue:self.navBarTitleFont forKey:NSFontAttributeName];
        }
        if (self.navBarTitleColor) {
            [titleTextAttributes setValue:self.navBarTitleColor forKey:NSForegroundColorAttributeName];
        }
        [UINavigationBar appearance].titleTextAttributes = titleTextAttributes;
        [QDIMHelper visibleViewController].navigationController.navigationBar.titleTextAttributes = titleTextAttributes;
    }
}

- (void)setNavBarLargeTitleFont:(UIFont *)navBarLargeTitleFont {
    _navBarLargeTitleFont = navBarLargeTitleFont;
    [self updateNavigationBarLargeTitleTextAttributesIfNeeded];
}

- (void)setNavBarLargeTitleColor:(UIColor *)navBarLargeTitleColor {
    _navBarLargeTitleColor = navBarLargeTitleColor;
    [self updateNavigationBarLargeTitleTextAttributesIfNeeded];
}

- (void)updateNavigationBarLargeTitleTextAttributesIfNeeded {
    if (@available(iOS 11, *)) {
        if (self.navBarLargeTitleFont || self.navBarLargeTitleColor) {
            NSMutableDictionary<NSString *, id> *largeTitleTextAttributes = [[NSMutableDictionary alloc] init];
            if (self.navBarLargeTitleFont) {
                largeTitleTextAttributes[NSFontAttributeName] = self.navBarLargeTitleFont;
            }
            if (self.navBarLargeTitleColor) {
                largeTitleTextAttributes[NSForegroundColorAttributeName] = self.navBarLargeTitleColor;
            }
            [UINavigationBar appearance].largeTitleTextAttributes = largeTitleTextAttributes;
            [QDIMHelper visibleViewController].navigationController.navigationBar.largeTitleTextAttributes = largeTitleTextAttributes;
        }
    }
}

- (void)setNavBarBackIndicatorImage:(UIImage *)navBarBackIndicatorImage {
    _navBarBackIndicatorImage = navBarBackIndicatorImage;
    
    if (_navBarBackIndicatorImage) {
        UINavigationBar *navBarAppearance = [UINavigationBar appearance];
        UINavigationBar *navigationBar = [QDIMHelper visibleViewController].navigationController.navigationBar;
        
        // 返回按钮的图片frame是和系统默认的返回图片的大小一致的（13, 21），所以用自定义返回箭头时要保证图片大小与系统的箭头大小一样，否则无法对齐
        CGSize systemBackIndicatorImageSize = CGSizeMake(13, 21); // 在iOS 8-11 上实际测量得到
        CGSize customBackIndicatorImageSize = _navBarBackIndicatorImage.size;
        if (!CGSizeEqualToSize(customBackIndicatorImageSize, systemBackIndicatorImageSize)) {
            CGFloat imageExtensionVerticalFloat = qdim_CGFloatGetCenter(systemBackIndicatorImageSize.height, customBackIndicatorImageSize.height);
            _navBarBackIndicatorImage = [[_navBarBackIndicatorImage qdim_imageWithSpacingExtensionInsets:UIEdgeInsetsMake(imageExtensionVerticalFloat,
                                                                                                                          0,
                                                                                                                          imageExtensionVerticalFloat,
                                                                                                                          systemBackIndicatorImageSize.width - customBackIndicatorImageSize.width)] imageWithRenderingMode:_navBarBackIndicatorImage.renderingMode];
        }
        
        navBarAppearance.backIndicatorImage = _navBarBackIndicatorImage;
        navBarAppearance.backIndicatorTransitionMaskImage = _navBarBackIndicatorImage;
        navigationBar.backIndicatorImage = _navBarBackIndicatorImage;
        navigationBar.backIndicatorTransitionMaskImage = _navBarBackIndicatorImage;
    }
}

- (void)setNavBarBackButtonTitlePositionAdjustment:(UIOffset)navBarBackButtonTitlePositionAdjustment {
    _navBarBackButtonTitlePositionAdjustment = navBarBackButtonTitlePositionAdjustment;
    
    if (!UIOffsetEqualToOffset(UIOffsetZero, _navBarBackButtonTitlePositionAdjustment)) {
        UIBarButtonItem *backBarButtonItem = [UIBarButtonItem appearance];
        [backBarButtonItem setBackButtonTitlePositionAdjustment:_navBarBackButtonTitlePositionAdjustment forBarMetrics:UIBarMetricsDefault];
        [[QDIMHelper visibleViewController].navigationController.navigationItem.backBarButtonItem setBackButtonTitlePositionAdjustment:_navBarBackButtonTitlePositionAdjustment forBarMetrics:UIBarMetricsDefault];
    }
}

- (void)setToolBarTintColor:(UIColor *)toolBarTintColor {
    _toolBarTintColor = toolBarTintColor;
    if (toolBarTintColor) {
        [QDIMHelper visibleViewController].navigationController.toolbar.tintColor = _toolBarTintColor;
    }
}

- (void)setToolBarBarTintColor:(UIColor *)toolBarBarTintColor {
    _toolBarBarTintColor = toolBarBarTintColor;
    if (toolBarBarTintColor) {
        [UIToolbar appearance].barTintColor = _toolBarBarTintColor;
        [QDIMHelper visibleViewController].navigationController.toolbar.barTintColor = _toolBarBarTintColor;
    }
}

- (void)setToolBarBackgroundImage:(UIImage *)toolBarBackgroundImage {
    _toolBarBackgroundImage = toolBarBackgroundImage;
    if (toolBarBackgroundImage) {
        [[UIToolbar appearance] setBackgroundImage:_toolBarBackgroundImage forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
        [[QDIMHelper visibleViewController].navigationController.toolbar setBackgroundImage:_toolBarBackgroundImage forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    }
}

- (void)setToolBarShadowImageColor:(UIColor *)toolBarShadowImageColor {
    _toolBarShadowImageColor = toolBarShadowImageColor;
    if (_toolBarShadowImageColor) {
        UIImage *shadowImage = [UIImage qdim_imageWithColor:_toolBarShadowImageColor size:CGSizeMake(1, QDIM_PixelOne) cornerRadius:0];
        [[UIToolbar appearance] setShadowImage:shadowImage forToolbarPosition:UIBarPositionAny];
        [[QDIMHelper visibleViewController].navigationController.toolbar setShadowImage:shadowImage forToolbarPosition:UIBarPositionAny];
    }
}

- (void)setTabBarTintColor:(UIColor *)tabBarTintColor {
    _tabBarTintColor = tabBarTintColor;
    if (tabBarTintColor) {
        [QDIMHelper visibleViewController].tabBarController.tabBar.tintColor = _tabBarTintColor;
    }
}

- (void)setTabBarBarTintColor:(UIColor *)tabBarBarTintColor {
    _tabBarBarTintColor = tabBarBarTintColor;
    if (tabBarBarTintColor) {
        [UITabBar appearance].barTintColor = _tabBarBarTintColor;
        [QDIMHelper visibleViewController].tabBarController.tabBar.barTintColor = _tabBarBarTintColor;
    }
}

- (void)setTabBarBackgroundImage:(UIImage *)tabBarBackgroundImage {
    _tabBarBackgroundImage = tabBarBackgroundImage;
    if (tabBarBackgroundImage) {
        [UITabBar appearance].backgroundImage = _tabBarBackgroundImage;
        [QDIMHelper visibleViewController].tabBarController.tabBar.backgroundImage = _tabBarBackgroundImage;
    }
}

- (void)setTabBarShadowImageColor:(UIColor *)tabBarShadowImageColor {
    _tabBarShadowImageColor = tabBarShadowImageColor;
    if (_tabBarShadowImageColor) {
        UIImage *shadowImage = [UIImage qdim_imageWithColor:_tabBarShadowImageColor size:CGSizeMake(1, QDIM_PixelOne) cornerRadius:0];
        [[UITabBar appearance] setShadowImage:shadowImage];
        [QDIMHelper visibleViewController].tabBarController.tabBar.shadowImage = shadowImage;
    }
}

- (void)setTabBarItemTitleColor:(UIColor *)tabBarItemTitleColor {
    _tabBarItemTitleColor = tabBarItemTitleColor;
    if (_tabBarItemTitleColor) {
        NSMutableDictionary<NSString *, id> *textAttributes = [[NSMutableDictionary alloc] initWithDictionary:[[UITabBarItem appearance] titleTextAttributesForState:UIControlStateNormal]];
        textAttributes[NSForegroundColorAttributeName] = _tabBarItemTitleColor;
        [[UITabBarItem appearance] setTitleTextAttributes:textAttributes forState:UIControlStateNormal];
        [[QDIMHelper visibleViewController].tabBarController.tabBar.items enumerateObjectsUsingBlock:^(UITabBarItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj setTitleTextAttributes:textAttributes forState:UIControlStateNormal];
        }];
    }
}

- (void)setTabBarItemTitleFont:(UIFont *)tabBarItemTitleFont {
    _tabBarItemTitleFont = tabBarItemTitleFont;
    if (_tabBarItemTitleFont) {
        NSMutableDictionary<NSString *, id> *textAttributes = [[NSMutableDictionary alloc] initWithDictionary:[[UITabBarItem appearance] titleTextAttributesForState:UIControlStateNormal]];
        textAttributes[NSFontAttributeName] = _tabBarItemTitleFont;
        [[UITabBarItem appearance] setTitleTextAttributes:textAttributes forState:UIControlStateNormal];
        [[QDIMHelper visibleViewController].tabBarController.tabBar.items enumerateObjectsUsingBlock:^(UITabBarItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj setTitleTextAttributes:textAttributes forState:UIControlStateNormal];
        }];
    }
}

- (void)setTabBarItemTitleColorSelected:(UIColor *)tabBarItemTitleColorSelected {
    _tabBarItemTitleColorSelected = tabBarItemTitleColorSelected;
    if (_tabBarItemTitleColorSelected) {
        NSMutableDictionary<NSString *, id> *textAttributes = [[NSMutableDictionary alloc] initWithDictionary:[[UITabBarItem appearance] titleTextAttributesForState:UIControlStateSelected]];
        textAttributes[NSForegroundColorAttributeName] = _tabBarItemTitleColorSelected;
        [[UITabBarItem appearance] setTitleTextAttributes:textAttributes forState:UIControlStateSelected];
        [[QDIMHelper visibleViewController].tabBarController.tabBar.items enumerateObjectsUsingBlock:^(UITabBarItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj setTitleTextAttributes:textAttributes forState:UIControlStateSelected];
        }];
    }
}

@end
