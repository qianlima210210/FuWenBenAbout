//
//  QDIMLocalizedMacro.h
//  QDIM
//
//  Created by qd-hxt on 2018/3/12.
//

#ifndef QDIMLocalizedMacro_h
#define QDIMLocalizedMacro_h

#define QDIMLocalizedStrFromBundle(key, bundle) \
NSLocalizedStringFromTableInBundle(key, @"Language", bundle, nil)

#define QDIMLocalizedImgFromBundle(string, bundle) \
NSLocalizedStringFromTableInBundle(string, @"Image", bundle, nil)

#define QDIMCreateImageFromBundle(imgName, bundle)   \
[UIImage imageNamed:imgName inBundle:bundle compatibleWithTraitCollection:nil]

//获取bundle
static inline NSBundle* QDIMBundleFromClass(Class aClass, NSString*resourceName)
{
    NSBundle *bundle = [NSBundle bundleForClass:aClass];
    NSURL * url = [bundle URLForResource:resourceName withExtension:@"bundle"];
    if (nil == url) {
        return nil;
    }
    return [NSBundle bundleWithURL:url];
}

#endif /* QDIMLocalizedMacro_h */
