//
//  CTRunItem.h
//  TestQDIM20180315
//
//  Created by QDHL on 2018/3/21.
//  Copyright © 2018年 QDHL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CTRunItem : NSObject

@property (nonatomic, copy) NSString *substring;
//子字符串范围
@property NSRange substringRange;

@property CGRect rect;

@end
