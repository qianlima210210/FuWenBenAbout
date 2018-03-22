//
//  QDIMMessageTextViewModel.m
//  QDIM
//
//  Created by QDHL on 2018/3/14.
//

#import "QDIMMessageTextViewModel.h"


@interface QDIMMessageTextViewModel()

@end

@implementation QDIMMessageTextViewModel

/**
 初始化消息文本视图模型

 @param textModel 文本模型
 @return 消息文本视图模型
 */
-(instancetype)initWithTextModel: (QDIMMessageTextModel*)textModel{
    self = [super init];
    if (self != nil) {
        _textModel = textModel;
        _font = [UIFont systemFontOfSize:17];
        
        [self translateAttributedText];
    }
    return self;
}

/**
 转换成属性文本
 */
-(void)translateAttributedText{
    NSString *string = _textModel.text ? _textModel.text : @"";
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString: string];
    
    NSMutableParagraphStyle *style = [NSMutableParagraphStyle new];
    style.lineSpacing = 3;
    style.lineBreakMode = NSLineBreakByWordWrapping;
    style.alignment = NSTextAlignmentLeft;
    
    [attStr addAttributes:@{NSFontAttributeName : _font, NSParagraphStyleAttributeName : style} range:NSMakeRange(0, _textModel.text.length)];
    
    _attributedText = attStr;
}


@end
