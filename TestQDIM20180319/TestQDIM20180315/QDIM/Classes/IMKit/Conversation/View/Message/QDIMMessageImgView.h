//
//  QDIMMessageImgView.h
//  QDIM
//
//  Created by QDHL on 2018/3/14.
//

#import "QDIMBaseMessageView.h"
#import "QDIMMessageImgViewModel.h"

@interface QDIMMessageImgView : QDIMBaseMessageView

/**
 初始化消息图片视图
 
 @param imgViewModel 图片视图模型
 @return 消息图片视图
 */
-(instancetype)initWithImgViewModel: (QDIMMessageImgViewModel*)imgViewModel;

@end
