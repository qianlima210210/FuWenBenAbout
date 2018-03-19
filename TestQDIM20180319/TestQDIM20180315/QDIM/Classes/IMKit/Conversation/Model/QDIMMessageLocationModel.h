//
//  QDIMMessageLocationModel.h
//  QDIM
//
//  Created by Yuanys on 2018/3/13.
//

#import "QDIMBaseMessageModel.h"

@interface QDIMMessageLocationModel : QDIMBaseMessageModel
/** 经度 */
@property(nonatomic, strong) NSString           *locationLongitude;
/** 纬度 */
@property(nonatomic, strong) NSString           *locationLatitude;
/** 位置名称 */
@property(nonatomic, strong) NSString           *locationTitle;
/** 地址 */
@property(nonatomic, strong) NSString           *locationAddress;
/** 图片Data */
@property(nonatomic, strong) NSData             *locationImage;
/** 图片JPG */
//@property(nonatomic, strong) UIImage            *locationImageJPG;


@end
