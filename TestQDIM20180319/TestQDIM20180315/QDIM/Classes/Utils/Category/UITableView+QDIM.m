//
//  UITableView+QDIM.m
//  QDIM
//
//  Created by qd-hxt on 2018/3/14.
//

#import "UITableView+QDIM.h"
#import "QDIMInternalHeader.h"

@implementation UITableView (QDIM)

- (void)qdim_styledAsQDIMTableView {
    UIColor *backgroundColor = nil;
    if (self.style == UITableViewStylePlain) {
        backgroundColor = QDIM_TableViewBackgroundColor;
        self.tableFooterView = [[UIView alloc] init]; // 去掉空白的cell
    } else {
        backgroundColor = QDIM_TableViewGroupedBackgroundColor;
    }
    if (backgroundColor) {
        self.backgroundColor = backgroundColor;
    }
    self.separatorColor = QDIM_TableViewSeparatorColor;
    self.backgroundView = [[UIView alloc] init]; // 设置一个空的 backgroundView，去掉系统的，以使 backgroundColor 生效
    
    self.sectionIndexColor = QDIM_TableSectionIndexColor;
    self.sectionIndexTrackingBackgroundColor = QDIM_TableSectionIndexTrackingBackgroundColor;
    self.sectionIndexBackgroundColor = QDIM_TableSectionIndexBackgroundColor;
}

- (void)qdim_clearSelection {
    NSArray<NSIndexPath *> *selectedIndexPaths = [self indexPathsForSelectedRows];
    for (NSIndexPath *indexPath in selectedIndexPaths) {
        [self deselectRowAtIndexPath:indexPath animated:YES];
    }
}

@end
