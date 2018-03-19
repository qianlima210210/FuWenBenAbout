//
//  QDIMMessageTextModel.m
//  QDIM
//
//  Created by Yuanys on 2018/3/13.
//

#import "QDIMMessageTextModel.h"

@implementation QDIMMessageTextModel

-(instancetype)initWithText:(NSString*)text {
    self = [super init];
    if (self != nil) {
        _text = text;
    }
    return self;
}

@end
