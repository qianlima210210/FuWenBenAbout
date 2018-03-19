//
//  QDIMHelper.h
//  QDIM-QDIM
//
//  Created by qd-hxt on 2018/3/12.
//

#import <UIKit/UIKit.h>

@interface QDIMHelper : NSObject

+ (instancetype _Nonnull)sharedInstance;

@end

@interface QDIMHelper (SystemVersion)
+ (NSInteger)numbericOSVersion;
+ (NSComparisonResult)compareSystemVersion:(nonnull NSString *)currentVersion toVersion:(nonnull NSString *)targetVersion;
+ (BOOL)isCurrentSystemAtLeastVersion:(nonnull NSString *)targetVersion;
+ (BOOL)isCurrentSystemLowerThanVersion:(nonnull NSString *)targetVersion;
@end

@interface QDIMHelper (DynamicType)

/// 返回当前contentSize的level，这个值可以在设置里面的“字体大小”查看，辅助功能里面有个“更大字体”可以设置更大的字体，不过这里我们这个接口将更大字体都做了统一，都返回“字体大小”里面最大值。
+ (nonnull NSNumber *)preferredContentSizeLevel;

/// 设置当前cell的高度，heights是有七个数值的数组，对于不支持的iOS版本，则选择中间的值返回。
+ (CGFloat)heightForDynamicTypeCell:(nonnull NSArray *)heights;
@end

@interface QDIMHelper (Device)

+ (BOOL)isIPad;
+ (BOOL)isIPadPro;
+ (BOOL)isIPod;
+ (BOOL)isIPhone;
+ (BOOL)isSimulator;

+ (BOOL)is58InchScreen;
+ (BOOL)is55InchScreen;
+ (BOOL)is47InchScreen;
+ (BOOL)is40InchScreen;
+ (BOOL)is35InchScreen;

+ (CGSize)screenSizeFor58Inch;
+ (CGSize)screenSizeFor55Inch;
+ (CGSize)screenSizeFor47Inch;
+ (CGSize)screenSizeFor40Inch;
+ (CGSize)screenSizeFor35Inch;

// 用于获取 iPhoneX 安全区域的 insets
+ (UIEdgeInsets)safeAreaInsetsForIPhoneX;

/// 判断当前设备是否高性能设备，只会判断一次，以后都直接读取结果，所以没有性能问题
+ (BOOL)isHighPerformanceDevice;

@end

@interface QDIMHelper (UIGraphic)

/// 获取一像素的大小
+ (CGFloat)pixelOne;

/// 判断size是否超出范围
+ (void)inspectContextSize:(CGSize)size;

/// context是否合法
+ (void)inspectContextIfInvalidatedInDebugMode:(CGContextRef _Nonnull)context;
+ (BOOL)inspectContextIfInvalidatedInReleaseMode:(CGContextRef _Nonnull)context;
@end

@interface QDIMHelper (ViewController)

/**
 * 获取当前应用里最顶层的可见viewController
 * @warning 注意返回值可能为nil，要做好保护
 */
+ (nullable UIViewController *)visibleViewController;

@end

@interface QDIMHelper (UIApplication)

+ (void)renderStatusBarStyleDark;

+ (void)renderStatusBarStyleLight;

+ (void)dimmedApplicationWindow;

+ (void)resetDimmedApplicationWindow;

@end
