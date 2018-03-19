//
//  UIActivityIndicatorView+QDIM.m
//  QDIM
//
//  Created by qd-hxt on 2018/3/13.
//

#import "UIActivityIndicatorView+QDIM.h"

@implementation UIActivityIndicatorView (QDIM)

- (instancetype)initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyle)style size:(CGSize)size {
    if (self = [self initWithActivityIndicatorStyle:style]) {
        CGSize initialSize = self.bounds.size;
        CGFloat scale = size.width / initialSize.width;
        self.transform = CGAffineTransformMakeScale(scale, scale);
    }
    return self;
}


@end
