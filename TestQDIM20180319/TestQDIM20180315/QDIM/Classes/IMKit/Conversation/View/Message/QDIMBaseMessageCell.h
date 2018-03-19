//
//  QDIMBaseMessageCell.h
//  Pods
//
//  Created by Yuanys on 2018/3/8.
//

#import <UIKit/UIKit.h>

@class QDIMBaseMessageModel;
@interface QDIMBaseMessageCell : UITableViewCell

#pragma mark - Public

/**
 唯一构造方法

 @return cell对象
 */
+ (nonnull instancetype)cellFromNib;

/**
 设置显示消息

 @param message 消息模型
 */
- (void)setMessage:(nonnull QDIMBaseMessageModel *)message;

@end
