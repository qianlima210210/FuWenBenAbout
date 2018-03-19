//
//  QDIMMessageVideoModel.h
//  QDIM
//
//  Created by Yuanys on 2018/3/13.
//

#import "QDIMBaseMessageModel.h"

/** 聊天信息实体类-小视频,继承自聊天信息实体类，包括小视频信息 */
@interface QDIMMessageVideoModel : QDIMBaseMessageModel

/** 小视频的名称 */
@property (nonatomic,copy)  NSString * videoName;
/** 小视频缩略图 */
@property (nonatomic,strong) NSData * thumbImageData;
/** 视频data */
@property (nonatomic,strong) NSData * videoData;
/** 小视频时长 */
@property (nonatomic,assign)  NSInteger videoDuration;
/** 小视频大小 */
@property (nonatomic,assign)  NSInteger  videoSize;

@end
