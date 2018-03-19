//
//  QDIMMessageImgViewModel.h
//  QDIM
//
//  Created by QDHL on 2018/3/14.
//

#import <Foundation/Foundation.h>
#import "QDIMMessageImgModel.h"

@interface QDIMMessageImgViewModel : NSObject

@property (nonatomic, copy) NSString *thumbImgPath;

/**
 初始化图片视图模型
 
 @param imgModel 图片模型
 @return 图片视图模型
 */
-(instancetype)initWithImgModel: (QDIMMessageImgModel*)imgModel;

@end
