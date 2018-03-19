//
//  NSBundle+QDIM.m
//  QDIM
//
//  Created by qd-hxt on 2018/3/12.
//

#import "NSBundle+QDIM.h"

@implementation NSBundle (QDIM)

+ (NSBundle *)qdim_bundleFromClass:(Class)aClass resourceName:(NSString*)resourceName {
    NSBundle *bundle = [NSBundle bundleForClass:aClass];
    NSURL * url = [bundle URLForResource:resourceName withExtension:@"bundle"];
    if ( nil == url ) {
        return nil;
    }
    return [self bundleWithURL:url];
}

@end
