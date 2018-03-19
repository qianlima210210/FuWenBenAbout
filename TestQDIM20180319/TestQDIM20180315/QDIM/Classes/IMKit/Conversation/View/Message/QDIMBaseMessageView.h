//
//  QDIMBaseMessageView.h
//  QDIM
//
//  Created by Yuanys on 2018/3/12.
//

#import <UIKit/UIKit.h>

@class QDIMBaseMessageModel;
@protocol QDIMBaseMessageViewProtocol <NSObject>

@required
/**
 根据宽度重新布局

 @param maxWidth 最大宽度
 */
- (void)layoutSubViewWithMaxWidth:(CGFloat)maxWidth;

/**
 获取View高度

 @param messageModel 消息模型
 @param maxWidth 最大宽度
 @return 高度
 */
+ (CGFloat)viewHeight:(QDIMBaseMessageModel *)messageModel maxWidth:(CGFloat)maxWidth;

@end

@interface QDIMBaseMessageView : UIView <QDIMBaseMessageViewProtocol>

@end
