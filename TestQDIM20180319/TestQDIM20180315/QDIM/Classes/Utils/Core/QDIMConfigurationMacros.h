//
//  QDIMConfigurationMacros.h
//  QDIM-QDIM
//
//  Created by qd-hxt on 2018/3/12.
//

#import "QDIMConfiguration.h"

/**
*  提供一系列方便书写的宏，以便在代码里读取配置表的各种属性。
*  @warning 请不要在 + load 方法里调用 QMUIConfigurationTemplate 或 QMUIConfigurationMacros 提供的宏，那个时机太早，可能导致 crash
*  @waining 维护时，如果需要增加一个宏，则需要定义一个新的 QMUIConfiguration 属性。
*/


// 单例的宏

#define QDIMConfig ({[[QDIMConfiguration sharedInstance] applyInitialTemplate];[QDIMConfiguration sharedInstance];})


#pragma mark - Global Color

// 基础颜色
#define QDIM_UIColorClear                [QDIMConfig clearColor]
#define QDIM_UIColorWhite                [QDIMConfig whiteColor]
#define QDIM_UIColorBlack                [QDIMConfig blackColor]
#define QDIM_UIColorGray                 [QDIMConfig grayColor]
#define QDIM_UIColorGrayDarken           [QDIMConfig grayDarkenColor]
#define QDIM_UIColorGrayLighten          [QDIMConfig grayLightenColor]
#define QDIM_UIColorRed                  [QDIMConfig redColor]
#define QDIM_UIColorGreen                [QDIMConfig greenColor]
#define QDIM_UIColorBlue                 [QDIMConfig blueColor]
#define QDIM_UIColorYellow               [QDIMConfig yellowColor]

// 功能颜色
#define QDIM_UIColorLink                 [QDIMConfig linkColor]                       // 全局统一文字链接颜色
#define QDIM_UIColorDisabled             [QDIMConfig disabledColor]                   // 全局统一文字disabled颜色
#define QDIM_UIColorForBackground        [QDIMConfig backgroundColor]                 // 全局统一的背景色
#define QDIM_UIColorMask                 [QDIMConfig maskDarkColor]                   // 全局统一的mask背景色
#define QDIM_UIColorMaskWhite            [QDIMConfig maskLightColor]                  // 全局统一的mask背景色，白色
#define QDIM_UIColorSeparator            [QDIMConfig separatorColor]                  // 全局分隔线颜色
#define QDIM_UIColorSeparatorDashed      [QDIMConfig separatorDashedColor]            // 全局分隔线颜色（虚线）
#define QDIM_UIColorPlaceholder          [QDIMConfig placeholderColor]                // 全局的输入框的placeholder颜色

// 测试用的颜色
#define QDIM_UIColorTestRed              [QDIMConfig testColorRed]
#define QDIM_UIColorTestGreen            [QDIMConfig testColorGreen]
#define QDIM_UIColorTestBlue             [QDIMConfig testColorBlue]

// 可操作的控件
#pragma mark - UIControl

#define QDIM_UIControlHighlightedAlpha       [QDIMConfig controlHighlightedAlpha]          // 一般control的Highlighted透明值
#define QDIM_UIControlDisabledAlpha          [QDIMConfig controlDisabledAlpha]             // 一般control的Disable透明值

// 按钮
#pragma mark - UIButton
#define QDIM_ButtonHighlightedAlpha          [QDIMConfig buttonHighlightedAlpha]           // 按钮Highlighted状态的透明度
#define QDIM_ButtonDisabledAlpha             [QDIMConfig buttonDisabledAlpha]              // 按钮Disabled状态的透明度
#define QDIM_ButtonTintColor                 [QDIMConfig buttonTintColor]                  // 普通按钮的颜色

#define QDIM_GhostButtonColorBlue            [QDIMConfig ghostButtonColorBlue]              // QMUIGhostButtonColorBlue的颜色
#define QDIM_GhostButtonColorRed             [QDIMConfig ghostButtonColorRed]               // QMUIGhostButtonColorRed的颜色
#define QDIM_GhostButtonColorGreen           [QDIMConfig ghostButtonColorGreen]             // QMUIGhostButtonColorGreen的颜色
#define QDIM_GhostButtonColorGray            [QDIMConfig ghostButtonColorGray]              // QMUIGhostButtonColorGray的颜色
#define QDIM_GhostButtonColorWhite           [QDIMConfig ghostButtonColorWhite]             // QMUIGhostButtonColorWhite的颜色

#define QDIM_FillButtonColorBlue            [QDIMConfig fillButtonColorBlue]              // QMUIFillButtonColorBlue的颜色
#define QDIM_FillButtonColorRed             [QDIMConfig fillButtonColorRed]               // QMUIFillButtonColorRed的颜色
#define QDIM_FillButtonColorGreen           [QDIMConfig fillButtonColorGreen]             // QMUIFillButtonColorGreen的颜色
#define QDIM_FillButtonColorGray            [QDIMConfig fillButtonColorGray]              // QMUIFillButtonColorGray的颜色
#define QDIM_FillButtonColorWhite           [QDIMConfig fillButtonColorWhite]             // QMUIFillButtonColorWhite的颜色

// 输入框
#pragma mark - TextField & TextView
#define QDIM_TextFieldTintColor              [QDIMConfig textFieldTintColor]               // 全局UITextField、UITextView的tintColor
#define QDIM_TextFieldTextInsets             [QDIMConfig textFieldTextInsets]              // QMUITextField的内边距


#pragma mark - NavigationBar

#define QDIM_NavBarHighlightedAlpha                          [QDIMConfig navBarHighlightedAlpha]
#define QDIM_NavBarDisabledAlpha                             [QDIMConfig navBarDisabledAlpha]
#define QDIM_NavBarButtonFont                                [QDIMConfig navBarButtonFont]
#define QDIM_NavBarButtonFontBold                            [QDIMConfig navBarButtonFontBold]
#define QDIM_NavBarBackgroundImage                           [QDIMConfig navBarBackgroundImage]
#define QDIM_NavBarShadowImage                               [QDIMConfig navBarShadowImage]
#define QDIM_NavBarBarTintColor                              [QDIMConfig navBarBarTintColor]
#define QDIM_NavBarTintColor                                 [QDIMConfig navBarTintColor]
#define QDIM_NavBarTitleColor                                [QDIMConfig navBarTitleColor]
#define QDIM_NavBarTitleFont                                 [QDIMConfig navBarTitleFont]
#define QDIM_NavBarLargeTitleColor                           [QDIMConfig navBarLargeTitleColor]
#define QDIM_NavBarLargeTitleFont                            [QDIMConfig navBarLargeTitleFont]
#define QDIM_NavBarBarBackButtonTitlePositionAdjustment      [QDIMConfig navBarBackButtonTitlePositionAdjustment]
#define QDIM_NavBarBackIndicatorImage                        [QDIMConfig navBarBackIndicatorImage]                          // 自定义的返回按钮，尺寸建议与系统的返回按钮尺寸一致（iOS8下实测系统大小是(13, 21)），可提高性能
#define QDIM_NavBarCloseButtonImage                          [QDIMConfig navBarCloseButtonImage]

#define QDIM_NavBarLoadingMarginRight                        [QDIMConfig navBarLoadingMarginRight]                          // titleView里左边的loading的右边距
#define QDIM_NavBarAccessoryViewMarginLeft                   [QDIMConfig navBarAccessoryViewMarginLeft]                     // titleView里的accessoryView的左边距
#define QDIM_NavBarActivityIndicatorViewStyle                [QDIMConfig navBarActivityIndicatorViewStyle]                  // titleView loading 的style
#define QDIM_NavBarAccessoryViewTypeDisclosureIndicatorImage [QDIMConfig navBarAccessoryViewTypeDisclosureIndicatorImage]   // titleView上倒三角的默认图片


#pragma mark - TabBar

#define QDIM_TabBarBackgroundImage                           [QDIMConfig tabBarBackgroundImage]
#define QDIM_TabBarBarTintColor                              [QDIMConfig tabBarBarTintColor]
#define QDIM_TabBarShadowImageColor                          [QDIMConfig tabBarShadowImageColor]
#define QDIM_TabBarTintColor                                 [QDIMConfig tabBarTintColor]
#define QDIM_TabBarItemTitleColor                            [QDIMConfig tabBarItemTitleColor]
#define QDIM_TabBarItemTitleColorSelected                    [QDIMConfig tabBarItemTitleColorSelected]
#define QDIM_TabBarItemTitleFont                             [QDIMConfig tabBarItemTitleFont]


#pragma mark - Toolbar

#define QDIM_ToolBarHighlightedAlpha                         [QDIMConfig toolBarHighlightedAlpha]
#define QDIM_ToolBarDisabledAlpha                            [QDIMConfig toolBarDisabledAlpha]
#define QDIM_ToolBarTintColor                                [QDIMConfig toolBarTintColor]
#define QDIM_ToolBarTintColorHighlighted                     [QDIMConfig toolBarTintColorHighlighted]
#define QDIM_ToolBarTintColorDisabled                        [QDIMConfig toolBarTintColorDisabled]
#define QDIM_ToolBarBackgroundImage                          [QDIMConfig toolBarBackgroundImage]
#define QDIM_ToolBarBarTintColor                             [QDIMConfig toolBarBarTintColor]
#define QDIM_ToolBarShadowImageColor                         [QDIMConfig toolBarShadowImageColor]
#define QDIM_ToolBarButtonFont                               [QDIMConfig toolBarButtonFont]


#pragma mark - SearchBar

#define QDIM_SearchBarTextFieldBackground                    [QDIMConfig searchBarTextFieldBackground]
#define QDIM_SearchBarTextFieldBorderColor                   [QDIMConfig searchBarTextFieldBorderColor]
#define QDIM_SearchBarBottomBorderColor                      [QDIMConfig searchBarBottomBorderColor]
#define QDIM_SearchBarBarTintColor                           [QDIMConfig searchBarBarTintColor]
#define QDIM_SearchBarTintColor                              [QDIMConfig searchBarTintColor]
#define QDIM_SearchBarTextColor                              [QDIMConfig searchBarTextColor]
#define QDIM_SearchBarPlaceholderColor                       [QDIMConfig searchBarPlaceholderColor]
#define QDIM_SearchBarFont                                   [QDIMConfig searchBarFont]
#define QDIM_SearchBarSearchIconImage                        [QDIMConfig searchBarSearchIconImage]
#define QDIM_SearchBarClearIconImage                         [QDIMConfig searchBarClearIconImage]
#define QDIM_SearchBarTextFieldCornerRadius                  [QDIMConfig searchBarTextFieldCornerRadius]


#pragma mark - TableView / TableViewCell

#define QDIM_TableViewEstimatedHeightEnabled            [QDIMConfig tableViewEstimatedHeightEnabled]            // 是否要开启全局 UITableView 的 estimatedRow(Section/Footer)Height

#define QDIM_TableViewBackgroundColor                   [QDIMConfig tableViewBackgroundColor]                   // 普通列表的背景色
#define QDIM_TableViewGroupedBackgroundColor            [QDIMConfig tableViewGroupedBackgroundColor]            // Grouped类型的列表的背景色
#define QDIM_TableSectionIndexColor                     [QDIMConfig tableSectionIndexColor]                     // 列表右边索引条的文字颜色，iOS6及以后生效
#define QDIM_TableSectionIndexBackgroundColor           [QDIMConfig tableSectionIndexBackgroundColor]           // 列表右边索引条的背景色，iOS7及以后生效
#define QDIM_TableSectionIndexTrackingBackgroundColor   [QDIMConfig tableSectionIndexTrackingBackgroundColor]   // 列表右边索引条按下时的背景色，iOS6及以后生效
#define QDIM_TableViewSeparatorColor                    [QDIMConfig tableViewSeparatorColor]                    // 列表分隔线颜色
#define QDIM_TableViewCellBackgroundColor               [QDIMConfig tableViewCellBackgroundColor]               // 列表 cell 的背景色
#define QDIM_TableViewCellSelectedBackgroundColor       [QDIMConfig tableViewCellSelectedBackgroundColor]       // 列表 cell 按下时的背景色
#define QDIM_TableViewCellWarningBackgroundColor        [QDIMConfig tableViewCellWarningBackgroundColor]        // 列表 cell 在未读状态下的背景色
#define QDIM_TableViewCellNormalHeight                  [QDIMConfig tableViewCellNormalHeight]                  // 默认 cell 的高度

#define QDIM_TableViewCellDisclosureIndicatorImage      [QDIMConfig tableViewCellDisclosureIndicatorImage]      // 列表 cell 右边的箭头图片
#define QDIM_TableViewCellCheckmarkImage                [QDIMConfig tableViewCellCheckmarkImage]                // 列表 cell 右边的打钩checkmark
#define QDIM_TableViewCellDetailButtonImage             [QDIMConfig tableViewCellDetailButtonImage]             // 列表 cell 右边的 i 按钮
#define QDIM_TableViewCellSpacingBetweenDetailButtonAndDisclosureIndicator [QDIMConfig tableViewCellSpacingBetweenDetailButtonAndDisclosureIndicator]   // 列表 cell 右边的 i 按钮和向右箭头之间的间距（仅当两者都使用了自定义图片并且同时显示时才生效）

#define QDIM_TableViewSectionHeaderBackgroundColor      [QDIMConfig tableViewSectionHeaderBackgroundColor]
#define QDIM_TableViewSectionFooterBackgroundColor      [QDIMConfig tableViewSectionFooterBackgroundColor]
#define QDIM_TableViewSectionHeaderFont                 [QDIMConfig tableViewSectionHeaderFont]
#define QDIM_TableViewSectionFooterFont                 [QDIMConfig tableViewSectionFooterFont]
#define QDIM_TableViewSectionHeaderTextColor            [QDIMConfig tableViewSectionHeaderTextColor]
#define QDIM_TableViewSectionFooterTextColor            [QDIMConfig tableViewSectionFooterTextColor]
#define QDIM_TableViewSectionHeaderAccessoryMargins     [QDIMConfig tableViewSectionHeaderAccessoryMargins]
#define QDIM_TableViewSectionFooterAccessoryMargins     [QDIMConfig tableViewSectionFooterAccessoryMargins]
#define QDIM_TableViewSectionHeaderContentInset         [QDIMConfig tableViewSectionHeaderContentInset]
#define QDIM_TableViewSectionFooterContentInset         [QDIMConfig tableViewSectionFooterContentInset]

#define QDIM_TableViewGroupedSectionHeaderFont          [QDIMConfig tableViewGroupedSectionHeaderFont]
#define QDIM_TableViewGroupedSectionFooterFont          [QDIMConfig tableViewGroupedSectionFooterFont]
#define QDIM_TableViewGroupedSectionHeaderTextColor     [QDIMConfig tableViewGroupedSectionHeaderTextColor]
#define QDIM_TableViewGroupedSectionFooterTextColor     [QDIMConfig tableViewGroupedSectionFooterTextColor]
#define QDIM_TableViewGroupedSectionHeaderAccessoryMargins   [QDIMConfig tableViewGroupedSectionHeaderAccessoryMargins]
#define QDIM_TableViewGroupedSectionFooterAccessoryMargins   [QDIMConfig tableViewGroupedSectionFooterAccessoryMargins]
#define QDIM_TableViewGroupedSectionHeaderDefaultHeight [QDIMConfig tableViewGroupedSectionHeaderDefaultHeight]
#define QDIM_TableViewGroupedSectionFooterDefaultHeight [QDIMConfig tableViewGroupedSectionFooterDefaultHeight]
#define QDIM_TableViewGroupedSectionHeaderContentInset  [QDIMConfig tableViewGroupedSectionHeaderContentInset]
#define QDIM_TableViewGroupedSectionFooterContentInset  [QDIMConfig tableViewGroupedSectionFooterContentInset]

#define QDIM_TableViewCellTitleLabelColor               [QDIMConfig tableViewCellTitleLabelColor]               // cell的title颜色
#define QDIM_TableViewCellDetailLabelColor              [QDIMConfig tableViewCellDetailLabelColor]              // cell的detailTitle颜色

#pragma mark - UIWindowLevel
#define QDIM_UIWindowLevelQMUIAlertView                  [QDIMConfig windowLevelQMUIAlertView]
#define QDIM_UIWindowLevelQMUIImagePreviewView           [QDIMConfig windowLevelQMUIImagePreviewView]

#pragma mark - QMUILog
#define QDIM_ShouldPrintDefaultLog                       [QDIMConfig shouldPrintDefaultLog]
#define QDIM_ShouldPrintInfoLog                          [QDIMConfig shouldPrintInfoLog]
#define QDIM_ShouldPrintWarnLog                          [QDIMConfig shouldPrintWarnLog]

#pragma mark - Others

#define QDIM_SupportedOrientationMask                        [QDIMConfig supportedOrientationMask]          // 默认支持的横竖屏方向
#define QDIM_AutomaticallyRotateDeviceOrientation            [QDIMConfig automaticallyRotateDeviceOrientation]  // 是否在界面切换或 viewController.supportedOrientationMask 发生变化时自动旋转屏幕，默认为 NO
#define QDIM_StatusbarStyleLightInitially                    [QDIMConfig statusbarStyleLightInitially]      // 默认的状态栏内容是否使用白色，默认为NO，也即黑色
#define QDIM_NeedsBackBarButtonItemTitle                     [QDIMConfig needsBackBarButtonItemTitle]       // 全局是否需要返回按钮的title，不需要则只显示一个返回image
#define QDIM_HidesBottomBarWhenPushedInitially               [QDIMConfig hidesBottomBarWhenPushedInitially] // QMUICommonViewController.hidesBottomBarWhenPushed 的初始值，默认为 NO，以保持与系统默认值一致，但通常建议改为 YES，因为一般只有 tabBar 首页那几个界面要求为 NO
#define QDIM_PreventConcurrentNavigationControllerTransitions [QDIMConfig preventConcurrentNavigationControllerTransitions] // PreventConcurrentNavigationControllerTransitions : 自动保护 QMUINavigationController 在上一次 push/pop 尚未结束的时候就进行下一次 push/pop 的行为，避免产生 crash
#define QDIM_NavigationBarHiddenInitially                    [QDIMConfig navigationBarHiddenInitially]      // preferredNavigationBarHidden 的初始值，默认为NO
#define QDIM_ShouldFixTabBarTransitionBugInIPhoneX           [QDIMConfig shouldFixTabBarTransitionBugInIPhoneX] // 是否需要自动修复 iOS 11 下，iPhone X 的设备在 push 界面时，tabBar 会瞬间往上跳的 bug
