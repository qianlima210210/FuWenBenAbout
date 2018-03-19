//
//  UITableView+QDIM.h
//  QDIM
//
//  Created by qd-hxt on 2018/3/14.
//

#import <UIKit/UIKit.h>

@interface UITableView (QDIM)

/**
 将当前tableView按照QMUI统一定义的宏来渲染外观
 */
- (void)qdim_styledAsQDIMTableView;

/**
 取消选择状态
 */
- (void)qdim_clearSelection;

@end
