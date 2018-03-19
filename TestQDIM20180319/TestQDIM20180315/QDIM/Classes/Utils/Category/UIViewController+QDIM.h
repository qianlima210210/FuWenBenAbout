//
//  UIViewController+QDIM.h
//  QDIM
//
//  Created by qd-hxt on 2018/3/12.
//

#import <UIKit/UIKit.h>
#import "QDIMHelper.h"

@interface UIViewController (QDIM)

/** 获取和自身处于同一个UINavigationController里的上一个UIViewController */
@property(nullable, nonatomic, weak, readonly) UIViewController *qdim_previousViewController;

/** 获取上一个UIViewController的title，可用于设置自定义返回按钮的文字 */
@property(nullable, nonatomic, copy, readonly) NSString *qdim_previousViewControllerTitle;

/**
 *  获取当前controller里的最高层可见viewController（可见的意思是还会判断self.view.window是否存在）
 *
 *  @see 如果要获取当前App里的可见viewController，请使用 [QMUIHelper visibleViewController]
 *
 *  @return 当前controller里的最高层可见viewController
 */
- (nullable UIViewController *)qdim_visibleViewControllerIfExist;

@end

@interface UIViewController (Runtime)

/**
 *  判断当前类是否有重写某个指定的 UIViewController 的方法
 *  @param selector 要判断的方法
 *  @return YES 表示当前类重写了指定的方法，NO 表示没有重写，使用的是 UIViewController 默认的实现
 */
- (BOOL)qdim_hasOverrideUIKitMethod:(_Nonnull SEL)selector;

@end
