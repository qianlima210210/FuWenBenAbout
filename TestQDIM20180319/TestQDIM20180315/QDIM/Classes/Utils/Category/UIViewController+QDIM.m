//
//  UIViewController+QDIM.m
//  QDIM
//
//  Created by qd-hxt on 2018/3/12.
//

#import "UIViewController+QDIM.h"
#import "NSObject+QDIM.h"
#import "QDIMHeader.h"

@implementation UIViewController (QDIM)

- (UIViewController *)qdim_previousViewController {
    if (self.navigationController.viewControllers && self.navigationController.viewControllers.count > 1 && self.navigationController.topViewController == self) {
        NSUInteger count = self.navigationController.viewControllers.count;
        return (UIViewController *)[self.navigationController.viewControllers objectAtIndex:count - 2];
    }
    return nil;
}

- (NSString *)qdim_previousViewControllerTitle {
    UIViewController *previousViewController = [self qdim_previousViewController];
    if (previousViewController) {
        return previousViewController.title;
    }
    return nil;
}

- (UIViewController *)qdim_visibleViewControllerIfExist {
    
    if (self.presentedViewController) {
        return [self.presentedViewController qdim_visibleViewControllerIfExist];
    }
    
    if ([self isKindOfClass:[UINavigationController class]]) {
        return [((UINavigationController *)self).visibleViewController qdim_visibleViewControllerIfExist];
    }
    
    if ([self isKindOfClass:[UITabBarController class]]) {
        return [((UITabBarController *)self).selectedViewController qdim_visibleViewControllerIfExist];
    }
    
    if ([self isViewLoaded] && self.view.window) {
        return self;
    } else {
        NSLog(@"qdim_visibleViewControllerIfExist:，找不到可见的viewController。self = %@, self.view = %@, self.view.window = %@", self, [self isViewLoaded] ? self.view : nil, [self isViewLoaded] ? self.view.window : nil);
        return nil;
    }
}

@end

@implementation UIViewController (Runtime)

- (BOOL)qdim_hasOverrideUIKitMethod:(SEL)selector {
    // 排序依照 Xcode Interface Builder 里的控件排序，但保证子类在父类前面
    NSMutableArray<Class> *viewControllerSuperclasses = [[NSMutableArray alloc] initWithObjects:
                                                         [UIImagePickerController class],
                                                         [UINavigationController class],
                                                         [UITableViewController class],
                                                         [UICollectionViewController class],
                                                         [UITabBarController class],
                                                         [UISplitViewController class],
                                                         [UIPageViewController class],
                                                         [UIViewController class],
                                                         nil];
    
    if (NSClassFromString(@"UIAlertController")) {
        [viewControllerSuperclasses addObject:[UIAlertController class]];
    }
    if (NSClassFromString(@"UISearchController")) {
        [viewControllerSuperclasses addObject:[UISearchController class]];
    }
    for (NSInteger i = 0, l = viewControllerSuperclasses.count; i < l; i++) {
        Class superclass = viewControllerSuperclasses[i];
        if ([self qdim_hasOverrideMethod:selector ofSuperclass:superclass]) {
            return YES;
        }
    }
    return NO;
}

@end

@implementation UIViewController (NavigationBarTransition)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class cls = [self class];
        QDIM_ReplaceMethod(cls, @selector(viewWillAppear:), @selector(qdim_navigationBarTransition_viewWillAppear:));
    });
}

- (void)qdim_navigationBarTransition_viewWillAppear:(BOOL)animated {
    // 放在最前面，留一个时机给业务可以覆盖
    [self renderNavigationStyleInViewController:self animated:animated];
    [self qdim_navigationBarTransition_viewWillAppear:animated];
}

// 根据当前的viewController，统一处理导航栏底部的分隔线、状态栏的颜色
- (void)renderNavigationStyleInViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    // 针对一个 container view controller 里面包含了若干个 view controller，这种情况里面的 view controller 也会相应这个 render 方法，这样就会覆盖 container view controller 的设置，所以应该规避这种情况。
    if (viewController != viewController.navigationController.topViewController) {
        return;
    }
    
    // 以下用于控制 vc 的外观样式，如果某个方法有实现则用方法的返回值，否则再看配置表对应的值是否有配置，有配置就使用配置表，没配置则什么都不做，维持系统原生样式
    UIColor *tintColor = QDIM_NavBarTintColor;
    if (tintColor) {
        viewController.navigationController.navigationBar.tintColor = tintColor;
    }
}

@end
