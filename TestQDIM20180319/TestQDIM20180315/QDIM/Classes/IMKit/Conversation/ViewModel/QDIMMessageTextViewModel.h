//
//  QDIMMessageTextViewModel.h
//  QDIM
//
//  Created by QDHL on 2018/3/14.
//

#import <Foundation/Foundation.h>
#import "QDIMMessageTextModel.h"

@interface QDIMMessageTextViewModel : NSObject

//视图模型对应的数据模型
@property (nonatomic, strong) QDIMMessageTextModel *textModel;
//用来生成属性文本的字体
@property (nonatomic, strong) UIFont *font;
//为标签准备的属性文本
@property (nonatomic, strong) NSMutableAttributedString *attributedText;

//文本视图高度
@property CGFloat height;

/**
 初始化消息文本视图模型
 
 @param textModel 文本模型
 @return 消息文本视图模型
 */
-(instancetype)initWithTextModel: (QDIMMessageTextModel*)textModel;

@end
