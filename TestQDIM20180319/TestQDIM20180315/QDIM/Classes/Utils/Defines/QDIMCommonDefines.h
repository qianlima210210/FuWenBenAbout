//
//  QDIMCommonDefines.h
//  QDIM
//
//  Created by qd-hxt on 2018/3/9.
//

#ifndef QDIMCommonDefines_h
#define QDIMCommonDefines_h

#import <objc/runtime.h>
#import "QDIMHelper.h"
#import "UIColor+QDIM.h"
#import "QDIMLocalizedMacro.h"

#pragma mark - 变量-编译相关

// 判断当前是否debug编译模式
#ifdef DEBUG
#define QDIM_IS_DEBUG YES
#else
#define QDIM_IS_DEBUG NO
#endif


/// 判断当前编译使用的 Base SDK 版本是否为 iOS 8.0 及以上

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
#define QDIM_IOS8_SDK_ALLOWED YES
#endif


/// 判断当前编译使用的 Base SDK 版本是否为 iOS 9.0 及以上

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 90000
#define QDIM_IOS9_SDK_ALLOWED YES
#endif


/// 判断当前编译使用的 Base SDK 版本是否为 iOS 10.0 及以上

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 100000
#define QDIM_IOS10_SDK_ALLOWED YES
#endif


/// 判断当前编译使用的 Base SDK 版本是否为 iOS 11.0 及以上

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 110000
#define QDIM_IOS11_SDK_ALLOWED YES
#endif

#pragma mark - Clang

#define ArgumentToString(macro) #macro
#define ClangWarningConcat(warning_name) ArgumentToString(clang diagnostic ignored warning_name)

// 参数可直接传入 clang 的 warning 名，warning 列表参考：https://clang.llvm.org/docs/DiagnosticsReference.html
#define BeginIgnoreClangWarning(warningName) _Pragma("clang diagnostic push") _Pragma(ClangWarningConcat(#warningName))
#define EndIgnoreClangWarning _Pragma("clang diagnostic pop")

#define BeginIgnorePerformSelectorLeaksWarning BeginIgnoreClangWarning(-Warc-performSelector-leaks)
#define EndIgnorePerformSelectorLeaksWarning EndIgnoreClangWarning

#define BeginIgnoreAvailabilityWarning BeginIgnoreClangWarning(-Wpartial-availability)
#define EndIgnoreAvailabilityWarning EndIgnoreClangWarning

#define BeginIgnoreDeprecatedWarning BeginIgnoreClangWarning(-Wdeprecated-declarations)
#define EndIgnoreDeprecatedWarning EndIgnoreClangWarning


#pragma mark - 变量-设备相关

// 设备类型
#define QDIM_IS_IPAD [QDIMHelper isIPad]
#define QDIM_IS_IPAD_PRO [QDIMHelper isIPadPro]
#define QDIM_IS_IPOD [QDIMHelper isIPod]
#define QDIM_IS_IPHONE [QDIMHelper isIPhone]
#define QDIM_IS_SIMULATOR [QDIMHelper isSimulator]

// 操作系统版本号，只获取第二级的版本号，例如 10.3.1 只会得到 10.3
#define QDIM_IOS_VERSION ([[[UIDevice currentDevice] systemVersion] doubleValue])

// 数字形式的操作系统版本号，可直接用于大小比较；如 110205 代表 11.2.5 版本；根据 iOS 规范，版本号最多可能有3位
#define QDIM_IOS_VERSION_NUMBER [QDIMHelper numbericOSVersion]

// 是否横竖屏
// 用户界面横屏了才会返回YES
#define QDIM_IS_LANDSCAPE UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])
// 无论支不支持横屏，只要设备横屏了，就会返回YES
#define QDIM_IS_DEVICE_LANDSCAPE UIDeviceOrientationIsLandscape([[UIDevice currentDevice] orientation])

// 屏幕宽度，会根据横竖屏的变化而变化
#define QDIM_SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)

// 屏幕宽度，跟横竖屏无关
#define QDIM_DEVICE_WIDTH (QDIM_IS_LANDSCAPE ? [[UIScreen mainScreen] bounds].size.height : [[UIScreen mainScreen] bounds].size.width)

// 屏幕高度，会根据横竖屏的变化而变化
#define QDIM_SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)

// 屏幕高度，跟横竖屏无关
#define QDIM_DEVICE_HEIGHT (QDIM_IS_LANDSCAPE ? [[UIScreen mainScreen] bounds].size.width : [[UIScreen mainScreen] bounds].size.height)

// 设备屏幕尺寸
// iPhoneX
#define QDIM_IS_58INCH_SCREEN [QDIMHelper is58InchScreen]
// iPhone6/7/8 Plus
#define QDIM_IS_55INCH_SCREEN [QDIMHelper is55InchScreen]
// iPhone6/7/8
#define QDIM_IS_47INCH_SCREEN [QDIMHelper is47InchScreen]
// iPhone5/5s/SE
#define QDIM_IS_40INCH_SCREEN [QDIMHelper is40InchScreen]
// iPhone4/4s
#define QDIM_IS_35INCH_SCREEN [QDIMHelper is35InchScreen]

// 是否Retina
#define QDIM_IS_RETINASCREEN ([[UIScreen mainScreen] scale] >= 2.0)

// 是否放大模式（iPhone 6及以上的设备支持放大模式）
#define QDIM_IS_ZOOMEDMODE ([[UIScreen mainScreen] respondsToSelector:@selector(nativeScale)] ? (ScreenNativeScale > QDIM_ScreenScale) : NO)

#pragma mark - 变量-布局相关

// bounds && nativeBounds / scale && nativeScale
#define QDIM_ScreenBoundsSize ([[UIScreen mainScreen] bounds].size)
#define QDIM_ScreenNativeBoundsSize ([[UIScreen mainScreen] nativeBounds].size)
#define QDIM_ScreenScale ([[UIScreen mainScreen] scale])
#define QDIM_ScreenNativeScale ([[UIScreen mainScreen] nativeScale])

// 状态栏高度(来电等情况下，状态栏高度会发生变化，所以应该实时计算)
#define QDIM_StatusBarHeight ([[UIApplication sharedApplication] statusBarFrame].size.height)

// navigationBar相关frame
#define QDIM_NavigationBarHeight (QDIM_IS_LANDSCAPE ? PreferredVarForDevices(44, 32, 32, 32) : 44)

// toolBar相关frame
#define QDIM_ToolBarHeight (QDIM_IS_LANDSCAPE ? QDIM_PreferredVarForUniversalDevicesIncludingIPhoneX(44, 44, 53, 32, 32, 32) : QDIM_PreferredVarForUniversalDevicesIncludingIPhoneX(44, 44, 83, 44, 44, 44))

// tabBar相关frame
#define QDIM_TabBarHeight (QDIM_IS_LANDSCAPE ? QDIM_PreferredVarForUniversalDevicesIncludingIPhoneX(49, 49, 53, 32, 32, 32) : QDIM_PreferredVarForUniversalDevicesIncludingIPhoneX(49, 49, 83, 49, 49, 49))

// 保护 iPhoneX 安全区域的 insets
#define QDIM_IPhoneXSafeAreaInsets [QDIMHelper safeAreaInsetsForIPhoneX]

// 获取顶部导航栏占位高度，从而在布局 subviews 时可以当成 minY 参考
// 注意，以下两个宏已废弃，请尽量使用 UIViewController (QDIM) qmui_navigationBarMaxYInViewCoordinator 代替
#define QDIM_NavigationContentTop (StatusBarHeight + NavigationBarHeight)
#define NavigationContentStaticTop NavigationContentTop

// 获取一个像素
#define QDIM_PixelOne [QDIMHelper pixelOne]

// 获取最合适的适配值，默认以varFor55Inch为准，也即偏向大屏，特殊的，iPhone X 虽然英寸值更大，但由于宽度与 47inch 相等，因此布局上使用与 47inch 一样的值
#define QDIM_PreferredVarForDevices(varFor55Inch, varFor47or58Inch, varFor40Inch, varFor35Inch) QDIM_PreferredVarForUniversalDevices(varFor55Inch, varFor55Inch, varFor47or58Inch, varFor40Inch, varFor35Inch)

// 同上，加多一个iPad的参数
#define QDIM_PreferredVarForUniversalDevices(varForPad, varFor55Inch, varFor47or58Inch, varFor40Inch, varFor35Inch) QDIM_PreferredVarForUniversalDevicesIncludingIPhoneX(varForPad, varFor55Inch, varFor47or58Inch, varFor47or58Inch, varFor40Inch, varFor35Inch)

// 同上，包含 iPhoneX
#define QDIM_PreferredVarForUniversalDevicesIncludingIPhoneX(varForPad, varFor55Inch, varFor58Inch, varFor47Inch, varFor40Inch, varFor35Inch) (QDIM_IS_IPAD ? varForPad : (QDIM_IS_35INCH_SCREEN ? varFor35Inch : (QDIM_IS_40INCH_SCREEN ? varFor40Inch : (QDIM_IS_47INCH_SCREEN ? varFor47Inch : (QDIM_IS_55INCH_SCREEN ? varFor55Inch : varFor58Inch)))))

#pragma mark - 方法-创建器

// 使用文件名(不带后缀名)创建一个UIImage对象，会被系统缓存，适用于大量复用的小资源图
// 使用这个 API 而不是 imageNamed: 是因为后者在 iOS 8 下反而存在性能问题（by molice 不确定 iOS 9 及以后的版本是否还有这个问题）
#define QDIM_UIImageMake(imgName) QDIMCreateImageFromBundle(imgName, QDIMBundle)

// 使用文件名(不带后缀名，仅限png)创建一个UIImage对象，不会被系统缓存，用于不被复用的图片，特别是大图
#define QDIM_UIImageMakeWithFile(name) UIImageMakeWithFileAndSuffix(name, @"png")
#define QDIM_UIImageMakeWithFileAndSuffix(name, suffix) [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@.%@", [[NSBundle mainBundle] resourcePath], name, suffix]]

// 字体相关的宏，用于快速创建一个字体对象，更多创建宏可查看 UIFont+QDIM.h
#define QDIM_UIFontMake(size) [UIFont systemFontOfSize:size]
#define QDIM_UIFontItalicMake(size) [UIFont italicSystemFontOfSize:size] // 斜体只对数字和字母有效，中文无效
#define QDIM_UIFontBoldMake(size) [UIFont boldSystemFontOfSize:size]
#define QDIM_UIFontBoldWithFont(_font) [UIFont boldSystemFontOfSize:_font.pointSize]

// UIColor 相关的宏，用于快速创建一个 UIColor 对象，更多创建的宏可查看 UIColor+QDIM.h
#define QDIM_UIColorMake(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define QDIM_UIColorMakeWithRGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a/1.0]

#define QDIM_UIColorMakeWithHex(hex) [UIColor qdim_colorWithHexString:hex]


#pragma mark - 数学计算

#define QDIM_AngleWithDegrees(deg) (M_PI * (deg) / 180.0)


#pragma mark - 动画

#define QDIM_UIViewAnimationOptionsCurveOut (7<<16)
#define QDIM_UIViewAnimationOptionsCurveIn (8<<16)


#pragma mark - 其他

#define QDIM_StringFromBOOL(_flag) (_flag ? @"YES" : @"NO")

#pragma mark - 方法-C对象、结构操作

CG_INLINE BOOL
QDIM_ReplaceMethod(Class _class, SEL _originSelector, SEL _newSelector) {
    Method oriMethod = class_getInstanceMethod(_class, _originSelector);
    Method newMethod = class_getInstanceMethod(_class, _newSelector);
    if (!newMethod) {
        // class 里不存在该方法的实现
        return NO;
    }
    BOOL isAddedMethod = class_addMethod(_class, _originSelector, method_getImplementation(newMethod), method_getTypeEncoding(newMethod));
    if (isAddedMethod) {
        class_replaceMethod(_class, _newSelector, method_getImplementation(oriMethod), method_getTypeEncoding(oriMethod));
    } else {
        method_exchangeImplementations(oriMethod, newMethod);
    }
    return YES;
}

#pragma mark - CGFloat

/**
 *  某些地方可能会将 CGFLOAT_MIN 作为一个数值参与计算（但其实 CGFLOAT_MIN 更应该被视为一个标志位而不是数值），可能导致一些精度问题，所以提供这个方法快速将 CGFLOAT_MIN 转换为 0
 *  issue: https://github.com/QDIM/QMUI_iOS/issues/203
 */
CG_INLINE CGFloat
qdim_removeFloatMin(CGFloat floatValue) {
    return floatValue == CGFLOAT_MIN ? 0 : floatValue;
}

/**
 *  基于指定的倍数，对传进来的 qdim_floatValue 进行像素取整。若指定倍数为0，则表示以当前设备的屏幕倍数为准。
 *
 *  例如传进来 “2.1”，在 2x 倍数下会返回 2.5（0.5pt 对应 1px），在 3x 倍数下会返回 2.333（0.333pt 对应 1px）。
 */
CG_INLINE CGFloat
qdim_flatSpecificScale(CGFloat floatValue, CGFloat scale) {
    floatValue = qdim_removeFloatMin(floatValue);
    scale = scale == 0 ? QDIM_ScreenScale : scale;
    CGFloat flattedValue = ceil(floatValue * scale) / scale;
    return flattedValue;
}

/**
 *  基于当前设备的屏幕倍数，对传进来的 qdim_floatValue 进行像素取整。
 *
 *  注意如果在 Core Graphic 绘图里使用时，要注意当前画布的倍数是否和设备屏幕倍数一致，若不一致，不可使用 qdim_flat() 函数，而应该用 qdim_flatSpecificScale
 */
CG_INLINE CGFloat
qdim_flat(CGFloat floatValue) {
    return qdim_flatSpecificScale(floatValue, 0);
}

/**
 *  类似qdim_flat()，只不过 qdim_flat 是向上取整，而 qdim_floorInPixel 是向下取整
 */
CG_INLINE CGFloat
qdim_floorInPixel(CGFloat floatValue) {
    floatValue = qdim_removeFloatMin(floatValue);
    CGFloat resultValue = floor(floatValue * QDIM_ScreenScale) / QDIM_ScreenScale;
    return resultValue;
}

CG_INLINE BOOL
qdim_between(CGFloat minimumValue, CGFloat value, CGFloat maximumValue) {
    return minimumValue < value && value < maximumValue;
}

CG_INLINE BOOL
qdim_betweenOrEqual(CGFloat minimumValue, CGFloat value, CGFloat maximumValue) {
    return minimumValue <= value && value <= maximumValue;
}

/**
 *  调整给定的某个 CGFloat 值的小数点精度，超过精度的部分按四舍五入处理。
 *
 *  例如 qdim_CGFloatToFixed(0.3333, 2) 会返回 0.33，而 qdim_CGFloatToFixed(0.6666, 2) 会返回 0.67
 *
 *  @warning 参数类型为 CGFloat，也即意味着不管传进来的是 float 还是 double 最终都会被强制转换成 CGFloat 再做计算
 *  @warning 该方法无法解决浮点数精度运算的问题
 */
CG_INLINE CGFloat
qdim_CGFloatToFixed(CGFloat value, NSUInteger precision) {
    NSString *formatString = [NSString stringWithFormat:@"%%.%@f", @(precision)];
    NSString *toString = [NSString stringWithFormat:formatString, value];
#if defined(__LP64__) && __LP64__
    CGFloat result = [toString doubleValue];
#else
    CGFloat result = [toString floatValue];
#endif
    return result;
}

/// 用于居中运算
CG_INLINE CGFloat
qdim_CGFloatGetCenter(CGFloat parent, CGFloat child) {
    return qdim_flat((parent - child) / 2.0);
}

#pragma mark - CGPoint

/// 两个point相加
CG_INLINE CGPoint
qdim_CGPointUnion(CGPoint point1, CGPoint point2) {
    return CGPointMake(qdim_flat(point1.x + point2.x), qdim_flat(point1.y + point2.y));
}

/// 获取rect的center，包括rect本身的x/y偏移
CG_INLINE CGPoint
qdim_CGPointGetCenterWithRect(CGRect rect) {
    return CGPointMake(qdim_flat(CGRectGetMidX(rect)), qdim_flat(CGRectGetMidY(rect)));
}

CG_INLINE CGPoint
qdim_CGPointGetCenterWithSize(CGSize size) {
    return CGPointMake(qdim_flat(size.width / 2.0), qdim_flat(size.height / 2.0));
}

CG_INLINE CGPoint
qdim_CGPointToFixed(CGPoint point, NSUInteger precision) {
    CGPoint result = CGPointMake(qdim_CGFloatToFixed(point.x, precision), qdim_CGFloatToFixed(point.y, precision));
    return result;
}

CG_INLINE CGPoint
qdim_CGPointRemoveFloatMin(CGPoint point) {
    CGPoint result = CGPointMake(qdim_removeFloatMin(point.x), qdim_removeFloatMin(point.y));
    return result;
}

#pragma mark - UIEdgeInsets

/// 获取UIEdgeInsets在水平方向上的值
CG_INLINE CGFloat
qdim_UIEdgeInsetsGetHorizontalValue(UIEdgeInsets insets) {
    return insets.left + insets.right;
}

/// 获取UIEdgeInsets在垂直方向上的值
CG_INLINE CGFloat
qdim_UIEdgeInsetsGetVerticalValue(UIEdgeInsets insets) {
    return insets.top + insets.bottom;
}

/// 将两个UIEdgeInsets合并为一个
CG_INLINE UIEdgeInsets
qdim_UIEdgeInsetsConcat(UIEdgeInsets insets1, UIEdgeInsets insets2) {
    insets1.top += insets2.top;
    insets1.left += insets2.left;
    insets1.bottom += insets2.bottom;
    insets1.right += insets2.right;
    return insets1;
}

CG_INLINE UIEdgeInsets
qdim_UIEdgeInsetsSetTop(UIEdgeInsets insets, CGFloat top) {
    insets.top = qdim_flat(top);
    return insets;
}

CG_INLINE UIEdgeInsets
qdim_UIEdgeInsetsSetLeft(UIEdgeInsets insets, CGFloat left) {
    insets.left = qdim_flat(left);
    return insets;
}
CG_INLINE UIEdgeInsets
qdim_UIEdgeInsetsSetBottom(UIEdgeInsets insets, CGFloat bottom) {
    insets.bottom = qdim_flat(bottom);
    return insets;
}

CG_INLINE UIEdgeInsets
qdim_UIEdgeInsetsSetRight(UIEdgeInsets insets, CGFloat right) {
    insets.right = qdim_flat(right);
    return insets;
}

CG_INLINE UIEdgeInsets
qdim_UIEdgeInsetsToFixed(UIEdgeInsets insets, NSUInteger precision) {
    UIEdgeInsets result = UIEdgeInsetsMake(qdim_CGFloatToFixed(insets.top, precision), qdim_CGFloatToFixed(insets.left, precision), qdim_CGFloatToFixed(insets.bottom, precision), qdim_CGFloatToFixed(insets.right, precision));
    return result;
}

CG_INLINE UIEdgeInsets
qdim_UIEdgeInsetsRemoveFloatMin(UIEdgeInsets insets) {
    UIEdgeInsets result = UIEdgeInsetsMake(qdim_removeFloatMin(insets.top), qdim_removeFloatMin(insets.left), qdim_removeFloatMin(insets.bottom), qdim_removeFloatMin(insets.right));
    return result;
}

#pragma mark - CGSize

/// 判断一个size是否为空（宽或高为0）
CG_INLINE BOOL
qdim_CGSizeIsEmpty(CGSize size) {
    return size.width <= 0 || size.height <= 0;
}

/// 将一个CGSize像素对齐
CG_INLINE CGSize
qdim_CGSizeFlatted(CGSize size) {
    return CGSizeMake(qdim_flat(size.width), qdim_flat(size.height));
}

/// 将一个 CGSize 以 pt 为单位向上取整
CG_INLINE CGSize
qdim_CGSizeCeil(CGSize size) {
    return CGSizeMake(ceil(size.width), ceil(size.height));
}

/// 将一个 CGSize 以 pt 为单位向下取整
CG_INLINE CGSize
qdim_CGSizeFloor(CGSize size) {
    return CGSizeMake(floor(size.width), floor(size.height));
}

CG_INLINE CGSize
qdim_CGSizeToFixed(CGSize size, NSUInteger precision) {
    CGSize result = CGSizeMake(qdim_CGFloatToFixed(size.width, precision), qdim_CGFloatToFixed(size.height, precision));
    return result;
}

CG_INLINE CGSize
qdim_CGSizeRemoveFloatMin(CGSize size) {
    CGSize result = CGSizeMake(qdim_removeFloatMin(size.width), qdim_removeFloatMin(size.height));
    return result;
}

#pragma mark - CGRect

/// 判断一个 CGRect 是否存在NaN
CG_INLINE BOOL
qdim_CGRectIsNaN(CGRect rect) {
    return isnan(rect.origin.x) || isnan(rect.origin.y) || isnan(rect.size.width) || isnan(rect.size.height);
}

/// 系统提供的 CGRectIsInfinite 接口只能判断 CGRectInfinite 的情况，而该接口可以用于判断 INFINITY 的值
CG_INLINE BOOL
qdim_CGRectIsInf(CGRect rect) {
    return isinf(rect.origin.x) || isinf(rect.origin.y) || isinf(rect.size.width) || isinf(rect.size.height);
}

/// 判断一个 CGRect 是否合法（例如不带无穷大的值、不带非法数字）
CG_INLINE BOOL
qdim_CGRectIsValidated(CGRect rect) {
    return !CGRectIsNull(rect) && !CGRectIsInfinite(rect) && !qdim_CGRectIsNaN(rect) && !qdim_CGRectIsInf(rect);
}

/// 创建一个像素对齐的CGRect
CG_INLINE CGRect
qdim_CGRectFlatMake(CGFloat x, CGFloat y, CGFloat width, CGFloat height) {
    return CGRectMake(qdim_flat(x), qdim_flat(y), qdim_flat(width), qdim_flat(height));
}

/// 对CGRect的x/y、width/height都调用一次flat，以保证像素对齐
CG_INLINE CGRect
qdim_CGRectFlatted(CGRect rect) {
    return CGRectMake(qdim_flat(rect.origin.x), qdim_flat(rect.origin.y), qdim_flat(rect.size.width), qdim_flat(rect.size.height));
}

/// 为一个CGRect叠加scale计算
CG_INLINE CGRect
qdim_CGRectApplyScale(CGRect rect, CGFloat scale) {
    return qdim_CGRectFlatted(CGRectMake(CGRectGetMinX(rect) * scale, CGRectGetMinY(rect) * scale, CGRectGetWidth(rect) * scale, CGRectGetHeight(rect) * scale));
}

/// 计算view的水平居中，传入父view和子view的frame，返回子view在水平居中时的x值
CG_INLINE CGFloat
qdim_CGRectGetMinXHorizontallyCenterInParentRect(CGRect parentRect, CGRect childRect) {
    return qdim_flat((CGRectGetWidth(parentRect) - CGRectGetWidth(childRect)) / 2.0);
}

/// 计算view的垂直居中，传入父view和子view的frame，返回子view在垂直居中时的y值
CG_INLINE CGFloat
qdim_CGRectGetMinYVerticallyCenterInParentRect(CGRect parentRect, CGRect childRect) {
    return qdim_flat((CGRectGetHeight(parentRect) - CGRectGetHeight(childRect)) / 2.0);
}

/// 返回值：同一个坐标系内，想要layoutingRect和已布局完成的referenceRect保持垂直居中时，layoutingRect的originY
CG_INLINE CGFloat
qdim_CGRectGetMinYVerticallyCenter(CGRect referenceRect, CGRect layoutingRect) {
    return CGRectGetMinY(referenceRect) + qdim_CGRectGetMinYVerticallyCenterInParentRect(referenceRect, layoutingRect);
}

/// 返回值：同一个坐标系内，想要layoutingRect和已布局完成的referenceRect保持水平居中时，layoutingRect的originX
CG_INLINE CGFloat
qdim_CGRectGetMinXHorizontallyCenter(CGRect referenceRect, CGRect layoutingRect) {
    return CGRectGetMinX(referenceRect) + qdim_CGRectGetMinXHorizontallyCenterInParentRect(referenceRect, layoutingRect);
}

/// 为给定的rect往内部缩小insets的大小
CG_INLINE CGRect
qdim_CGRectInsetEdges(CGRect rect, UIEdgeInsets insets) {
    rect.origin.x += insets.left;
    rect.origin.y += insets.top;
    rect.size.width -= qdim_UIEdgeInsetsGetHorizontalValue(insets);
    rect.size.height -= qdim_UIEdgeInsetsGetVerticalValue(insets);
    return rect;
}

/// 传入size，返回一个x/y为0的CGRect
CG_INLINE CGRect
qdim_CGRectMakeWithSize(CGSize size) {
    return CGRectMake(0, 0, size.width, size.height);
}

CG_INLINE CGRect
qdim_CGRectFloatTop(CGRect rect, CGFloat top) {
    rect.origin.y = top;
    return rect;
}

CG_INLINE CGRect
qdim_CGRectFloatBottom(CGRect rect, CGFloat bottom) {
    rect.origin.y = bottom - CGRectGetHeight(rect);
    return rect;
}

CG_INLINE CGRect
qdim_CGRectFloatRight(CGRect rect, CGFloat right) {
    rect.origin.x = right - CGRectGetWidth(rect);
    return rect;
}

CG_INLINE CGRect
qdim_CGRectFloatLeft(CGRect rect, CGFloat left) {
    rect.origin.x = left;
    return rect;
}

/// 保持rect的左边缘不变，改变其宽度，使右边缘靠在right上
CG_INLINE CGRect
qdim_CGRectLimitRight(CGRect rect, CGFloat rightLimit) {
    rect.size.width = rightLimit - rect.origin.x;
    return rect;
}

/// 保持rect右边缘不变，改变其宽度和origin.x，使其左边缘靠在left上。只适合那种右边缘不动的view
/// 先改变origin.x，让其靠在offset上
/// 再改变size.width，减少同样的宽度，以抵消改变origin.x带来的view移动，从而保证view的右边缘是不动的
CG_INLINE CGRect
qdim_CGRectLimitLeft(CGRect rect, CGFloat leftLimit) {
    CGFloat subOffset = leftLimit - rect.origin.x;
    rect.origin.x = leftLimit;
    rect.size.width = rect.size.width - subOffset;
    return rect;
}

/// 限制rect的宽度，超过最大宽度则截断，否则保持rect的宽度不变
CG_INLINE CGRect
qdim_CGRectLimitMaxWidth(CGRect rect, CGFloat maxWidth) {
    CGFloat width = CGRectGetWidth(rect);
    rect.size.width = width > maxWidth ? maxWidth : width;
    return rect;
}

CG_INLINE CGRect
qdim_CGRectSetX(CGRect rect, CGFloat x) {
    rect.origin.x = qdim_flat(x);
    return rect;
}

CG_INLINE CGRect
qdim_CGRectSetY(CGRect rect, CGFloat y) {
    rect.origin.y = qdim_flat(y);
    return rect;
}

CG_INLINE CGRect
qdim_CGRectSetXY(CGRect rect, CGFloat x, CGFloat y) {
    rect.origin.x = qdim_flat(x);
    rect.origin.y = qdim_flat(y);
    return rect;
}

CG_INLINE CGRect
qdim_CGRectSetWidth(CGRect rect, CGFloat width) {
    rect.size.width = qdim_flat(width);
    return rect;
}

CG_INLINE CGRect
qdim_CGRectSetHeight(CGRect rect, CGFloat height) {
    rect.size.height = qdim_flat(height);
    return rect;
}

CG_INLINE CGRect
qdim_CGRectSetSize(CGRect rect, CGSize size) {
    rect.size = qdim_CGSizeFlatted(size);
    return rect;
}

CG_INLINE CGRect
qdim_CGRectToFixed(CGRect rect, NSUInteger precision) {
    CGRect result = CGRectMake(qdim_CGFloatToFixed(CGRectGetMinX(rect), precision),
                               qdim_CGFloatToFixed(CGRectGetMinY(rect), precision),
                               qdim_CGFloatToFixed(CGRectGetWidth(rect), precision),
                               qdim_CGFloatToFixed(CGRectGetHeight(rect), precision));
    return result;
}

CG_INLINE CGRect
qdim_CGRectRemoveFloatMin(CGRect rect) {
    CGRect result = CGRectMake(qdim_removeFloatMin(CGRectGetMinX(rect)),
                               qdim_removeFloatMin(CGRectGetMinY(rect)),
                               qdim_removeFloatMin(CGRectGetWidth(rect)),
                               qdim_removeFloatMin(CGRectGetHeight(rect)));
    return result;
}

/// outerRange 是否包含了 innerRange
CG_INLINE BOOL
qdim_NSContainingRanges(NSRange outerRange, NSRange innerRange) {
    if (innerRange.location >= outerRange.location && outerRange.location + outerRange.length >= innerRange.location + innerRange.length) {
        return YES;
    }
    return NO;
}

//为了外面也能使用其中的资源，所以把 [self class] 改为 [QDIMConfiguration class]
#define QDIMBundle QDIMBundleFromClass([QDIMHelper class], @"QDIM")

#define QDIMLocalizedStr(key) QDIMLocalizedStrFromBundle(key, QDIMBundle)
#define QDIMLocalizedImg(key) QDIMLocalizedStrFromBundle(key, QDIMBundle)


#endif /* QDIMUICommonDefines_h */
