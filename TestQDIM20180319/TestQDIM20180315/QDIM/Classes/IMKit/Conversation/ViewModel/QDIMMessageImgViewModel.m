//
//  QDIMMessageImgViewModel.m
//  QDIM
//
//  Created by QDHL on 2018/3/14.
//

#import "QDIMMessageImgViewModel.h"

@interface QDIMMessageImgViewModel()

@property (nonatomic, strong) QDIMMessageImgModel *imgModel;

@end

@implementation QDIMMessageImgViewModel

/**
 初始化图片视图模型

 @param imgModel 图片模型
 @return 图片视图模型
 */
-(instancetype)initWithImgModel: (QDIMMessageImgModel*)imgModel{
    self = [super init];
    if (self != nil) {
        _imgModel = imgModel;
        
    }
    return self;
}


@end
