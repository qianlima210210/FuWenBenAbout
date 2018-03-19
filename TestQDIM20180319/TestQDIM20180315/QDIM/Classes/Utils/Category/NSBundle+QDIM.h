//
//  NSBundle+QDIM.h
//  QDIM
//
//  Created by qd-hxt on 2018/3/12.
//

#import <Foundation/Foundation.h>

@interface NSBundle (QDIM)


+ (NSBundle *)qdim_bundleFromClass:(Class)aClass resourceName:(NSString *)resourceName;

@end
