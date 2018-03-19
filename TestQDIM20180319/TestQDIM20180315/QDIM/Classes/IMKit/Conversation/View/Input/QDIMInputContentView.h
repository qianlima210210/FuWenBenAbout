//
//  QDIMInputContentView.h
//  QDIM
//
//  Created by 许龙 on 2018/3/13.
//

#import <UIKit/UIKit.h>

@class QDIMInputContentView;

@protocol QDIMInputContentViewDelegate <NSObject>

- (void)inputContentView:(QDIMInputContentView *)inputContentView heightChange:(CGFloat)height;

@end

#define QDIMInputBarNormalHeigt 50
#define QDIMToolPanelViewHeight 215


@interface QDIMInputContentView : UIView

@property (nonatomic, weak  ) id <QDIMInputContentViewDelegate> delegate;

@end
