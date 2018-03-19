//
//  QDIMMessageImgView.m
//  QDIM
//
//  Created by QDHL on 2018/3/14.
//

#import "QDIMMessageImgView.h"

@interface QDIMMessageImgView()

@property (nonatomic, strong) QDIMMessageImgViewModel *imgViewModel;

@end

@implementation QDIMMessageImgView

- (void)layoutSubViewWithMaxWidth:(CGFloat)maxWidth
{
    
}

+ (CGFloat)viewHeight:(QDIMBaseMessageModel *)messageModel maxWidth:(CGFloat)maxWidth
{
    return 0.f;
}

/**
 初始化消息图片视图
 
 @param imgViewModel 图片视图模型
 @return 消息图片视图
 */
-(instancetype)initWithImgViewModel: (QDIMMessageImgViewModel*)imgViewModel{
    self = [super init];
    if (self != nil) {
        _imgViewModel = imgViewModel;
    }
    
    return self;
}

@end
