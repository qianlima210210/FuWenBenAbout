//
//  NSObject+QDIM.m
//  QDIM
//
//  Created by qd-hxt on 2018/3/13.
//

#import "NSObject+QDIM.h"
#import <objc/message.h>
#import <objc/runtime.h>

@implementation NSObject (QDIM)

- (BOOL)qdim_hasOverrideMethod:(SEL)selector ofSuperclass:(Class)superclass {
    if (![[self class] isSubclassOfClass:superclass]) {
        return NO;
    }
    
    if (![superclass instancesRespondToSelector:selector]) {
        return NO;
    }
    
    Method superclassMethod = class_getInstanceMethod(superclass, selector);
    Method instanceMethod = class_getInstanceMethod([self class], selector);
    if (!instanceMethod || instanceMethod == superclassMethod) {
        return NO;
    }
    return YES;
}

- (id)qdim_performSelectorToSuperclass:(SEL)aSelector {
    struct objc_super mySuper;
    mySuper.receiver = self;
    mySuper.super_class = class_getSuperclass(object_getClass(self));
    
    id (*objc_superAllocTyped)(struct objc_super *, SEL) = (void *)&objc_msgSendSuper;
    return (*objc_superAllocTyped)(&mySuper, aSelector);
}

- (id)qdim_performSelectorToSuperclass:(SEL)aSelector withObject:(id)object {
    struct objc_super mySuper;
    mySuper.receiver = self;
    mySuper.super_class = class_getSuperclass(object_getClass(self));
    
    id (*objc_superAllocTyped)(struct objc_super *, SEL, ...) = (void *)&objc_msgSendSuper;
    return (*objc_superAllocTyped)(&mySuper, aSelector, object);
}

- (void)qdim_performSelector:(SEL)selector {
    [self qdim_performSelector:selector withReturnValue:NULL arguments:NULL];
}

- (void)qdim_performSelector:(SEL)selector withArguments:(void *)firstArgument, ... {
    [self qdim_performSelector:selector withReturnValue:NULL arguments:firstArgument, NULL];
}

- (void)qdim_performSelector:(SEL)selector withReturnValue:(void *)returnValue {
    [self qdim_performSelector:selector withReturnValue:returnValue arguments:NULL];
}

- (void)qdim_performSelector:(SEL)selector withReturnValue:(void *)returnValue arguments:(void *)firstArgument, ... {
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[self methodSignatureForSelector:selector]];
    [invocation setTarget:self];
    [invocation setSelector:selector];
    
    if (firstArgument) {
        [invocation setArgument:firstArgument atIndex:2];
        
        va_list args;
        va_start(args, firstArgument);
        void *currentArgument;
        NSInteger index = 3;
        while ((currentArgument = va_arg(args, void *))) {
            [invocation setArgument:currentArgument atIndex:index];
            index++;
        }
        va_end(args);
    }
    
    [invocation invoke];
    
    if (returnValue) {
        [invocation getReturnValue:returnValue];
    }
}

- (void)qdim_enumrateInstanceMethodsUsingBlock:(void (^)(SEL))block {
    [NSObject qdim_enumrateInstanceMethodsOfClass:self.class usingBlock:block];
}

+ (void)qdim_enumrateInstanceMethodsOfClass:(Class)aClass usingBlock:(void (^)(SEL selector))block {
    unsigned int methodCount = 0;
    Method *methods = class_copyMethodList(aClass, &methodCount);
    
    for (unsigned int i = 0; i < methodCount; i++) {
        Method method = methods[i];
        SEL selector = method_getName(method);
        if (block) block(selector);
    }
    
    free(methods);
}

+ (void)qdim_enumerateProtocolMethods:(Protocol *)protocol usingBlock:(void (^)(SEL))block {
    unsigned int methodCount = 0;
    struct objc_method_description *methods = protocol_copyMethodDescriptionList(protocol, NO, YES, &methodCount);
    for (int i = 0; i < methodCount; i++) {
        struct objc_method_description methodDescription = methods[i];
        if (block) {
            block(methodDescription.name);
        }
    }
    free(methods);
}

@end
