//
//  QDIMNavigationButton.h
//  QDIM-QDIM
//
//  Created by qd-hxt on 2018/3/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, QDIMNavigationButtonType) {
    QDIMNavigationButtonTypeNormal,         // 普通导航栏文字按钮
    QDIMNavigationButtonTypeBold,           // 导航栏加粗按钮
    QDIMNavigationButtonTypeImage,          // 图标按钮
    QDIMNavigationButtonTypeBack            // 自定义返回按钮(可以同时带有title)
};

typedef NS_ENUM(NSInteger, QDIMNavigationButtonPosition) {
    QDIMNavigationButtonPositionNone = -1,  // 不处于navigationBar最左（右）边的按钮，则使用None。用None则不会在alignmentRectInsets里调整位置
    QDIMNavigationButtonPositionLeft,       // 用于leftBarButtonItem，如果用于leftBarButtonItems，则只对最左边的item使用，其他item使用QDIMNavigationButtonPositionNone
    QDIMNavigationButtonPositionRight,      // 用于rightBarButtonItem，如果用于rightBarButtonItems，则只对最右边的item使用，其他item使用QDIMNavigationButtonPositionNone
};

/**
 *  QDIMNavigationButton 是用于 UINavigationItem 的按钮，有两种使用方式：
 *  1. 利用类方法，快速生成所需的 UIBarButtonItem，其中大部分 UIBarButtonItem 均使用系统的 initWithBarButtonSystemItem 或 initWithImage 接口创建，仅有返回按钮利用了 customView 来创建 UIBarButtonItem。
 *  2. 利用 init 方法生成一个 QDIMNavigationButton 实例，再通过类方法 + barButtonItemWithNavigationButton:position:target:action: 来生成一个对应的 UIBarButtonItem，此时 QDIMNavigationButton 将作为 UIBarButtonItem 的 customView。
 *  若能满足需求，建议优先使用第 1 种方式。
 *  @note 关于 tintColor：UIBarButtonItem 如果使用了 customView，则需要修改 customView.tintColor，如果没使用 customView，则直接修改 UIBarButtonItem.tintColor。
 */
@interface QDIMNavigationButton : UIButton

/**
 *  获取当前按钮的`QDIMNavigationButtonType`
 */
@property(nonatomic, assign, readonly) QDIMNavigationButtonType type;

/**
 *  设置按钮是否用于UINavigationBar上的UIBarButtonItem。若为YES，则会参照系统的按钮布局去更改QDIMNavigationButton的内容布局，若为NO，则内容布局与普通按钮没差别。默认为YES。
 */
@property(nonatomic, assign) BOOL useForBarButtonItem;

/**
 *  导航栏按钮的初始化函数，指定的初始化方法
 *  @param type 按钮类型
 *  @param title 按钮的title
 */
- (instancetype)initWithType:(QDIMNavigationButtonType)type title:(nullable NSString *)title;

/**
 *  导航栏按钮的初始化函数
 *  @param type 按钮类型
 */
- (instancetype)initWithType:(QDIMNavigationButtonType)type;

/**
 *  导航栏按钮的初始化函数
 *  @param image 按钮的image
 */
- (instancetype)initWithImage:(nullable UIImage *)image;

/**
 *  创建一个 type 为 QDIMNavigationButtonTypeBack 的 button 并作为 customView 用于生成一个 UIBarButtonItem，返回按钮的图片由配置表里的宏 NavBarBackIndicatorImage 决定。
 *  @param target 按钮点击事件的接收者
 *  @param selector 按钮点击事件的方法
 *  @param tintColor 按钮要显示的颜色，如果为 nil，则表示跟随当前 UINavigationBar 的 tintColor
 */
+ (nullable UIBarButtonItem *)backBarButtonItemWithTarget:(nullable id)target action:(nullable SEL)selector tintColor:(nullable UIColor *)tintColor;

/**
 *  创建一个 type 为 QDIMNavigationButtonTypeBack 的 button 并作为 customView 用于生成一个 UIBarButtonItem，返回按钮的图片由配置表里的宏 NavBarBackIndicatorImage 决定，按钮颜色跟随 UINavigationBar 的 tintColor。
 *  @param target 按钮点击事件的接收者
 *  @param selector 按钮点击事件的方法
 */
+ (nullable UIBarButtonItem *)backBarButtonItemWithTarget:(nullable id)target action:(nullable SEL)selector;

/**
 *  创建一个以 “×” 为图标的关闭按钮，图片由配置表里的宏 NavBarCloseButtonImage 决定。
 *  @param target 按钮点击事件的接收者
 *  @param selector 按钮点击事件的方法
 *  @param tintColor 按钮要显示的颜色，如果为 nil，则表示跟随当前 UINavigationBar 的 tintColor
 */
+ (UIBarButtonItem *)closeBarButtonItemWithTarget:(nullable id)target action:(nullable SEL)selector tintColor:(nullable UIColor *)tintColor;

/**
 *  创建一个以 “×” 为图标的关闭按钮，图片由配置表里的宏 NavBarCloseButtonImage 决定，图片颜色跟随 UINavigationBar.tintColor。
 *  @param target 按钮点击事件的接收者
 *  @param selector 按钮点击事件的方法
 */
+ (UIBarButtonItem *)closeBarButtonItemWithTarget:(nullable id)target action:(nullable SEL)selector;

/**
 *  创建一个 UIBarButtonItem
 *  @param type 按钮的类型
 *  @param title 按钮的标题
 *  @param tintColor 按钮的颜色，如果为 nil，则表示跟随当前 UINavigationBar 的 tintColor
 *  @param position 按钮在 UINavigationBar 上的左右位置，如果某一边的按钮有多个，则只有最左边（最右边）的按钮需要设置为 QDIMNavigationButtonPositionLeft（QDIMNavigationButtonPositionRight），靠里的按钮使用 QDIMNavigationButtonPositionNone 即可
 *  @param target 按钮点击事件的接收者
 *  @param selector 按钮点击事件的方法
 */
+ (nullable UIBarButtonItem *)barButtonItemWithType:(QDIMNavigationButtonType)type title:(nullable NSString *)title tintColor:(nullable UIColor *)tintColor position:(QDIMNavigationButtonPosition)position target:(nullable id)target action:(nullable SEL)selector;

/**
 *  创建一个 UIBarButtonItem
 *  @param type 按钮的类型
 *  @param title 按钮的标题
 *  @param position 按钮在 UINavigationBar 上的左右位置，如果某一边的按钮有多个，则只有最左边（最右边）的按钮需要设置为 QDIMNavigationButtonPositionLeft（QDIMNavigationButtonPositionRight），靠里的按钮使用 QDIMNavigationButtonPositionNone 即可
 *  @param target 按钮点击事件的接收者
 *  @param selector 按钮点击事件的方法
 */
+ (nullable UIBarButtonItem *)barButtonItemWithType:(QDIMNavigationButtonType)type title:(nullable NSString *)title position:(QDIMNavigationButtonPosition)position target:(nullable id)target action:(nullable SEL)selector;

/**
 *  将参数传进来的 button 作为 customView 用于生成一个 UIBarButtonItem。
 *  @param button 要作为 customView 的 QDIMNavigationButton
 *  @param tintColor 按钮的颜色，如果为 nil，则表示跟随当前 UINavigationBar 的 tintColor
 *  @param position 按钮在 UINavigationBar 上的左右位置，如果某一边的按钮有多个，则只有最左边（最右边）的按钮需要设置为 QDIMNavigationButtonPositionLeft（QDIMNavigationButtonPositionRight），靠里的按钮使用 QDIMNavigationButtonPositionNone 即可
 *  @param target 按钮点击事件的接收者
 *  @param selector 按钮点击事件的方法
 *
 *  @note tintColor、position、target、selector 等参数不需要对 QDIMNavigationButton 设置，通过参数传进来就可以了，就算设置了也会在这个方法里被覆盖。
 */
+ (nullable UIBarButtonItem *)barButtonItemWithNavigationButton:(QDIMNavigationButton *)button tintColor:(nullable UIColor *)tintColor position:(QDIMNavigationButtonPosition)position target:(nullable id)target action:(nullable SEL)selector;

/**
 *  将参数传进来的 button 作为 customView 用于生成一个 UIBarButtonItem。
 *  @param button 要作为 customView 的 QDIMNavigationButton
 *  @param position 按钮在 UINavigationBar 上的左右位置，如果某一边的按钮有多个，则只有最左边（最右边）的按钮需要设置为 QDIMNavigationButtonPositionLeft（QDIMNavigationButtonPositionRight），靠里的按钮使用 QDIMNavigationButtonPositionNone 即可
 *  @param target 按钮点击事件的接收者
 *  @param selector 按钮点击事件的方法
 *
 *  @note position、target、selector 等参数不需要对 QDIMNavigationButton 设置，通过参数传进来就可以了，就算设置了也会在这个方法里被覆盖。
 */
+ (nullable UIBarButtonItem *)barButtonItemWithNavigationButton:(QDIMNavigationButton *)button position:(QDIMNavigationButtonPosition)position target:(nullable id)target action:(nullable SEL)selector;

/**
 *  创建一个图片类型的 UIBarButtonItem
 *  @param image 按钮的图标
 *  @param tintColor 按钮的颜色，如果为 nil，则表示跟随当前 UINavigationBar 的 tintColor
 *  @param position 按钮在 UINavigationBar 上的左右位置，如果某一边的按钮有多个，则只有最左边（最右边）的按钮需要设置为 QDIMNavigationButtonPositionLeft（QDIMNavigationButtonPositionRight），靠里的按钮使用 QDIMNavigationButtonPositionNone 即可
 *  @param target 按钮点击事件的接收者
 *  @param selector 按钮点击事件的方法
 */
+ (nullable UIBarButtonItem *)barButtonItemWithImage:(nullable UIImage *)image tintColor:(nullable UIColor *)tintColor position:(QDIMNavigationButtonPosition)position target:(nullable id)target action:(nullable SEL)selector;

/**
 *  创建一个图片类型的 UIBarButtonItem
 *  @param image 按钮的图标
 *  @param position 按钮在 UINavigationBar 上的左右位置，如果某一边的按钮有多个，则只有最左边（最右边）的按钮需要设置为 QDIMNavigationButtonPositionLeft（QDIMNavigationButtonPositionRight），靠里的按钮使用 QDIMNavigationButtonPositionNone 即可
 *  @param target 按钮点击事件的接收者
 *  @param selector 按钮点击事件的方法
 */
+ (nullable UIBarButtonItem *)barButtonItemWithImage:(nullable UIImage *)image position:(QDIMNavigationButtonPosition)position target:(nullable id)target action:(nullable SEL)selector;

@end



NS_ASSUME_NONNULL_END
