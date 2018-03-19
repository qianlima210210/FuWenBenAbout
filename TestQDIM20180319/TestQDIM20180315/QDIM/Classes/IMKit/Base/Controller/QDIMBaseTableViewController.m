//
//  QDIMBaseTableViewController.m
//  QDIM
//
//  Created by qd-hxt on 2018/3/14.
//

#import "QDIMBaseTableViewController.h"
#import "UITableView+QDIM.h"
#import "UIView+QDIM.h"
#import "QDIMInternalHeader.h"

const UIEdgeInsets QDIMCommonTableViewControllerInitialContentInsetNotSet = {-1, -1, -1, -1};
NSString *const QDIMCommonTableViewControllerSectionHeaderIdentifier = @"QDIMSectionHeaderView";
NSString *const QDIMCommonTableViewControllerSectionFooterIdentifier = @"QDIMSectionFooterView";

@interface QDIMBaseTableViewController ()

@end

@implementation QDIMBaseTableViewController

- (instancetype)initWithStyle:(UITableViewStyle)style {
    if (self = [super initWithNibName:nil bundle:nil]) {
        [self didInitializedWithStyle:style];
    }
    return self;
}

- (instancetype)init {
    return [self initWithStyle:UITableViewStylePlain];
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    return [self init];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self didInitializedWithStyle:UITableViewStylePlain];
    }
    return self;
}

- (void)didInitializedWithStyle:(UITableViewStyle)style {
    _style = style;
}

- (void)dealloc {
    // 用下划线而不是self.xxx来访问tableView，避免dealloc时self.view尚未被加载，此时调用self.tableView反而会触发loadView
    _tableView.delegate = nil;
    _tableView.dataSource = nil;
}

- (NSString *)description {
#ifdef DEBUG
    if (![self isViewLoaded]) {
        return [super description];
    }
    
    NSString *result = [NSString stringWithFormat:@"%@\ntableView:\t\t\t\t%@", [super description], self.tableView];
    NSInteger sections = [self.tableView.dataSource numberOfSectionsInTableView:self.tableView];
    if (sections > 0) {
        NSMutableString *sectionCountString = [[NSMutableString alloc] init];
        [sectionCountString appendFormat:@"\ndataCount(%@):\t\t\t\t(\n", @(sections)];
        NSInteger sections = [self.tableView.dataSource numberOfSectionsInTableView:self.tableView];
        for (NSInteger i = 0; i < sections; i++) {
            NSInteger rows = [self.tableView.dataSource tableView:self.tableView numberOfRowsInSection:i];
            [sectionCountString appendFormat:@"\t\t\t\t\t\t\tsection%@ - rows%@%@\n", @(i), @(rows), i < sections - 1 ? @"," : @""];
        }
        [sectionCountString appendString:@"\t\t\t\t\t\t)"];
        result = [result stringByAppendingString:sectionCountString];
    }
    return result;
#else
    return [super description];
#endif
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIColor *backgroundColor = nil;
    if (self.style == UITableViewStylePlain) {
        backgroundColor = QDIM_TableViewBackgroundColor;
    } else {
        backgroundColor = QDIM_TableViewGroupedBackgroundColor;
    }
    if (backgroundColor) {
        self.view.backgroundColor = backgroundColor;
    }
}

- (void)initSubviews {
    [super initSubviews];
    [self initTableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView qdim_clearSelection];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [self layoutTableView];
    
//    if ([self shouldAdjustTableViewContentInsetsInitially] && !self.hasSetInitialContentInset) {
//        self.tableView.contentInset = self.tableViewInitialContentInset;
//        if ([self shouldAdjustTableViewScrollIndicatorInsetsInitially]) {
//            self.tableView.scrollIndicatorInsets = self.tableViewInitialScrollIndicatorInsets;
//        } else {
//            // 默认和tableView.contentInset一致
//            self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
//        }
//        [self.tableView qmui_scrollToTop];
//        self.hasSetInitialContentInset = YES;
//    }
//
//    [self hideTableHeaderViewInitialIfCanWithAnimated:NO force:NO];
    
    [self layoutEmptyView];
}

- (void)layoutTableView {
    BOOL shouldChangeTableViewFrame = !CGRectEqualToRect(self.view.bounds, self.tableView.frame);
    if (shouldChangeTableViewFrame) {
        self.tableView.frame = self.view.bounds;
    }
}

- (void)layoutEmptyView {
    
}

- (void)initTableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:self.style];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self.tableView qdim_styledAsQDIMTableView];
        [self.view addSubview:self.tableView];
    }
}

#pragma mark - <UITableViewDelegate, UITableViewDataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSString *title = [self tableView:tableView realTitleForHeaderInSection:section];
    if (title) {
        UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:QDIMCommonTableViewControllerSectionHeaderIdentifier];
        return headerView;
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    NSString *title = [self tableView:tableView realTitleForFooterInSection:section];
    if (title) {
        UITableViewHeaderFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:QDIMCommonTableViewControllerSectionFooterIdentifier];
        return footerView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if ([tableView.delegate respondsToSelector:@selector(tableView:viewForHeaderInSection:)]) {
        UIView *view = [tableView.delegate tableView:tableView viewForHeaderInSection:section];
        if (view) {
            CGFloat height = [view sizeThatFits:CGSizeMake(CGRectGetWidth(tableView.bounds) - qdim_UIEdgeInsetsGetHorizontalValue(tableView.qdim_safeAreaInsets), CGFLOAT_MAX)].height;
            return height;
        }
    }
    // 分别测试过 iOS 11 前后的系统版本，最终总结，对于 Plain 类型的 tableView 而言，要去掉 header / footer 请使用 0，对于 Grouped 类型的 tableView 而言，要去掉 header / footer 请使用 CGFLOAT_MIN
    return tableView.style == UITableViewStylePlain ? 0 : QDIM_TableViewGroupedSectionHeaderDefaultHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if ([tableView.delegate respondsToSelector:@selector(tableView:viewForFooterInSection:)]) {
        UIView *view = [tableView.delegate tableView:tableView viewForFooterInSection:section];
        if (view) {
            CGFloat height = [view sizeThatFits:CGSizeMake(CGRectGetWidth(tableView.bounds) - qdim_UIEdgeInsetsGetHorizontalValue(tableView.qdim_safeAreaInsets), CGFLOAT_MAX)].height;
            return height;
        }
    }
    // 分别测试过 iOS 11 前后的系统版本，最终总结，对于 Plain 类型的 tableView 而言，要去掉 header / footer 请使用 0，对于 Grouped 类型的 tableView 而言，要去掉 header / footer 请使用 CGFLOAT_MIN
    return tableView.style == UITableViewStylePlain ? 0 : QDIM_TableViewGroupedSectionFooterDefaultHeight;
}

// 是否有定义某个section的header title
- (NSString *)tableView:(UITableView *)tableView realTitleForHeaderInSection:(NSInteger)section {
    if ([tableView.dataSource respondsToSelector:@selector(tableView:titleForHeaderInSection:)]) {
        NSString *sectionTitle = [tableView.dataSource tableView:tableView titleForHeaderInSection:section];
        if (sectionTitle && sectionTitle.length > 0) {
            return sectionTitle;
        }
    }
    return nil;
}

// 是否有定义某个section的footer title
- (NSString *)tableView:(UITableView *)tableView realTitleForFooterInSection:(NSInteger)section {
    if ([tableView.dataSource respondsToSelector:@selector(tableView:titleForFooterInSection:)]) {
        NSString *sectionFooter = [tableView.dataSource tableView:tableView titleForFooterInSection:section];
        if (sectionFooter && sectionFooter.length > 0) {
            return sectionFooter;
        }
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [[UITableViewCell alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return QDIM_TableViewCellNormalHeight;
}

- (UITableView *)tableView {
    if (!_tableView) {
        BeginIgnoreAvailabilityWarning
        [self loadViewIfNeeded];
        EndIgnoreAvailabilityWarning
    }
    return _tableView;
}

@end
