//
//  QDIMMessageImgModel.m
//  QDIM
//
//  Created by Yuanys on 2018/3/13.
//

#import "QDIMMessageImgModel.h"

@implementation QDIMMessageImgModel

-(instancetype)initWithImgName:(NSString*)imgName {
    self = [super init];
    if (self != nil) {
        _imgName = imgName;
    }
    return self;
}

@end
