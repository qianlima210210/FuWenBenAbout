//
//  QDIMMessageViewFactory.h
//  QDIM
//
//  Created by Yuanys on 2018/3/12.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class QDIMBaseMessageModel;
@class QDIMBaseMessageView;

@interface QDIMMessageViewFactory : NSObject


/**
 创建MessageView

 @param messageModel 消息模型
 @return messageView
 */
+ (nonnull QDIMBaseMessageView *)createMessageView:(nonnull QDIMBaseMessageModel *)messageModel;

@end
