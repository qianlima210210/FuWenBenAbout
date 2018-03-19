//
//  UIFont+QDIM.h
//  QDIM
//
//  Created by qd-hxt on 2018/3/13.
//

#import <UIKit/UIKit.h>

#define QDIM_UIFontLightMake(size) [UIFont qdim_lightSystemFontOfSize:size]
#define QDIM_UIFontLightWithFont(_font) [UIFont qdim_lightSystemFontOfSize:_font.pointSize]
#define QDIM_UIDynamicFontMake(_pointSize) [UIFont qdim_dynamicSystemFontOfSize:_pointSize weight:QDIMFontWeightNormal italic:NO]
#define QDIM_UIDynamicFontMakeWithLimit(_pointSize, _upperLimitSize, _lowerLimitSize) [UIFont qdim_dynamicSystemFontOfSize:_pointSize upperLimitSize:_upperLimitSize lowerLimitSize:_lowerLimitSize weight:QDIMFontWeightNormal italic:NO]
#define QDIM_UIDynamicFontBoldMake(_pointSize) [UIFont qdim_dynamicSystemFontOfSize:_pointSize weight:QDIMFontWeightBold italic:NO]
#define QDIM_UIDynamicFontBoldMakeWithLimit(_pointSize, _upperLimitSize, _lowerLimitSize) [UIFont qdim_dynamicSystemFontOfSize:_pointSize upperLimitSize:_upperLimitSize lowerLimitSize:_lowerLimitSize weight:QDIMFontWeightBold italic:NO]
#define QDIM_UIDynamicFontLightMake(_pointSize) [UIFont qdim_dynamicSystemFontOfSize:_pointSize weight:QDIMFontWeightLight italic:NO]
#define QDIM_UIDynamicFontLightMakeWithLimit(_pointSize, _upperLimitSize, _lowerLimitSize) [UIFont qdim_dynamicSystemFontOfSize:_pointSize upperLimitSize:_upperLimitSize lowerLimitSize:_lowerLimitSize weight:QDIMFontWeightLight italic:NO]

typedef NS_ENUM(NSUInteger, QDIMFontWeight) {
    QDIMFontWeightLight,
    QDIMFontWeightNormal,
    QDIMFontWeightBold
};

@interface UIFont (QDIM)

/**
 *  返回系统字体的细体
 *
 *  @param fontSize 字体大小
 *
 *  @return 变细的系统字体的 UIFont 对象
 */
+ (UIFont *)qdim_lightSystemFontOfSize:(CGFloat)fontSize;

/**
 *  根据需要生成一个 UIFont 对象并返回
 *  @param size     字号大小
 *  @param weight   字体粗细
 *  @param italic   是否斜体
 */
+ (UIFont *)qdim_systemFontOfSize:(CGFloat)size
                           weight:(QDIMFontWeight)weight
                           italic:(BOOL)italic;

/**
 *  根据需要生成一个支持响应动态字体大小调整的 UIFont 对象并返回
 *  @param  size    字号大小
 *  @param  weight  字重
 *  @param  italic  是否斜体
 *  @return         支持响应动态字体大小调整的 UIFont 对象
 */
+ (UIFont *)qdim_dynamicSystemFontOfSize:(CGFloat)size
                                  weight:(QDIMFontWeight)weight
                                  italic:(BOOL)italic;

/**
 *  返回支持动态字体的UIFont，支持定义最小和最大字号
 *
 *  @param pointSize        默认的size
 *  @param upperLimitSize   最大的字号限制
 *  @param lowerLimitSize   最小的字号显示
 *  @param weight           字重
 *  @param italic           是否斜体
 *
 *  @return                 支持响应动态字体大小调整的 UIFont 对象
 */
+ (UIFont *)qdim_dynamicSystemFontOfSize:(CGFloat)pointSize
                          upperLimitSize:(CGFloat)upperLimitSize
                          lowerLimitSize:(CGFloat)lowerLimitSize
                                  weight:(QDIMFontWeight)weight
                                  italic:(BOOL)italic;


@end
