//
//  QDIMBaseMessageModel.h
//  Pods
//
//  Created by Yuanys on 2018/3/8.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// 聊天cell类型
typedef enum {
    QDIMCellMessageType_Text      = 0, // 文本
    QDIMCellMessageType_Img       = 1, // 图片(宽高限制：iponeX = 420px * 420px，iphone6 = 280px * 280px )
    QDIMCellMessageType_Location  = 2, // 位置
    QDIMCellMessageType_Video     = 3, // 视频
    QDIMCellMessageType_Voice     = 4, // 音频
    QDIMCellMessageType_SysTip    = 5, // 系统提示
} QDIMCellMessageType;

// 聊天内容显示位置，左侧、右侧
typedef enum {
    QDIMBaseMessageModelShowType_left  = 0, // 左侧
    QDIMBaseMessageModelShowType_Right = 1  // 右侧
} QDIMBaseMessageModelShowType;


@interface QDIMBaseMessageModel : NSObject

// 聊天内容显示位置
@property (nonatomic, assign) QDIMBaseMessageModelShowType showType;
// 消息类型
@property (nonatomic, assign) QDIMCellMessageType messageType;
// 发送者头像
@property (nonatomic, copy) NSString *headImgUrl;
// 发送者id
@property (nonatomic, copy) NSString *fromUserId;
// 发送时间（时间戳）
@property (nonatomic, assign) NSTimeInterval sendTimeInterval;

@end
