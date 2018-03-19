//
//  QDIMMessageTextView.h
//  QDIM
//
//  Created by QDHL on 2018/3/14.
//

#import "QDIMBaseMessageView.h"
#import "QDIMMessageTextViewModel.h"

@interface QDIMMessageTextView : QDIMBaseMessageView

/**
 初始化消息文本视图
 
 @param textViewModel 文本视图模型
 @return 消息文本视图
 */
-(instancetype)initWithTextViewModel: (QDIMMessageTextViewModel*)textViewModel;

@end
