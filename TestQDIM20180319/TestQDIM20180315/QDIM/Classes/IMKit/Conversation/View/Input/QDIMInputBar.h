//
//  QDIMInputBar.h
//  Pods
//
//  Created by qd-hxt on 2018/3/8.
//

#import <UIKit/UIKit.h>

@class QDIMInputBar;

typedef NS_ENUM(NSInteger, QDIMInputBarStatus) {
    QDIMInputBarStatusNothing = 0, /**< 默认状态，什么也没有 */
    QDIMInputBarStatusShowKeyboard, /**< 正常键盘状态 */
    QDIMInputBarStatusShowVoice,/**< 录音状态 */
    QDIMInputBarStatusShowFace, /**< 表情状态 */
    QDIMInputBarStatusShowMore, /**< 更多功能状态 */
};

@protocol QDIMInputBarDelegate <NSObject>

- (void)updateInputBar:(QDIMInputBar *)inputBar
            fromStatus:(QDIMInputBarStatus)fromStatus
              toStatus:(QDIMInputBarStatus)toStatus;

@end



@interface QDIMInputBar : UIView

@property (nonatomic, weak  ) id<QDIMInputBarDelegate> delegate;

@property (nonatomic, assign) QDIMInputBarStatus status;


+ (UINib *)inputBarNib;


@end
