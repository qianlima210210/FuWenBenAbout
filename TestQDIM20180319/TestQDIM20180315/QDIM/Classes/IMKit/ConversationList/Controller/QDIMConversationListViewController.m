#import "QDIMConversationListViewController.h"
#import "QDIMNavigationButton.h"
#import "QDIMConversationViewController.h"
#import "UIView+QDIM.h"
#import "QDIMInternalHeader.h"
#import "QDIMHelper.h"

@interface QDIMConversationListViewController ()

@property(nonatomic, strong) NSArray<NSString *> *keywords;
@property(nonatomic, strong) NSMutableArray<NSString *> *searchResultsKeywords;
//@property(nonatomic, strong) QDIMSearchController *searchController;

@end

@implementation QDIMConversationListViewController

- (void)didInitialized {
    [super didInitialized];
    
    self.titleView.needsLoadingView = YES;
    self.titleView.qdim_needsDifferentDebugColor = YES;
    
    self.titleView.loadingViewHidden = NO;
    self.titleView.needsLoadingPlaceholderSpace = NO;
    self.titleView.title = @"收取中...";
    self.titleView.subtitle = nil;
    self.titleView.style = QDIMNavigationTitleViewStyleDefault;
    self.titleView.accessoryType = QDIMNavigationTitleViewAccessoryTypeNone;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.titleView.needsLoadingPlaceholderSpace = YES;
        self.titleView.loadingViewHidden = YES;
        self.titleView.title = @"千信";
        self.titleView.subtitle = @"(2)";
    });
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.searchController = [[QDIMSearchController alloc] initWithContentsViewController:self];
//    self.searchController.searchResultsDelegate = self;
//    self.searchController.searchBar.qdim_usedAsTableHeaderView = YES;// 以 tableHeaderView 的方式使用 searchBar 的话，将其置为 YES，以辅助兼容一些系统 bug
//    self.tableView.tableHeaderView = self.searchController.searchBar;
}

#pragma mark - override

- (void)setNavigationItemsIsInEditMode:(BOOL)isInEditMode animated:(BOOL)animated {
    [super setNavigationItemsIsInEditMode:isInEditMode animated:animated];
    
    self.navigationItem.rightBarButtonItem = [QDIMNavigationButton barButtonItemWithImage:QDIM_UIImageMake(@"barbuttonicon_add") position:QDIMNavigationButtonPositionRight target:self action:@selector(handleRightItemEvent)];
    
    //    测试使用
    self.navigationItem.leftBarButtonItem = [QDIMNavigationButton barButtonItemWithImage:QDIM_UIImageMake(@"barbuttonicon_question") position:QDIMNavigationButtonPositionLeft target:self action:@selector(handleLeftItemEvent)];
}

- (void)handleRightItemEvent {

}

- (void)handleLeftItemEvent {
    
    self.titleView.loadingViewHidden = NO;
    self.titleView.needsLoadingPlaceholderSpace = NO;
    self.titleView.title = @"收取中...";
    self.titleView.subtitle = nil;
    self.titleView.style = QDIMNavigationTitleViewStyleDefault;
    self.titleView.accessoryType = QDIMNavigationTitleViewAccessoryTypeNone;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.titleView.needsLoadingPlaceholderSpace = YES;
        self.titleView.loadingViewHidden = YES;
        self.titleView.title = @"千信";
        self.titleView.subtitle = @"(2)";
    });
}

#pragma mark - UITableViewDelete

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    QDIMConversationViewController *viewController = [[QDIMConversationViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}

//#pragma mark - <QDIMSearchControllerDelegate>
//
//- (void)searchController:(QDIMSearchController *)searchController updateResultsForSearchString:(NSString *)searchString {
//    [self.searchResultsKeywords removeAllObjects];
//
//    for (NSString *keyword in self.keywords) {
//        if ([keyword containsString:searchString]) {
//            [self.searchResultsKeywords addObject:keyword];
//        }
//    }
//
//    [searchController.tableView reloadData];
//
////    if (self.searchResultsKeywords.count == 0) {
////        [searchController showEmptyViewWithText:@"没有匹配结果" detailText:nil buttonTitle:nil buttonAction:NULL];
////    } else {
////        [searchController hideEmptyView];
////    }
//}
//
//- (void)willPresentSearchController:(QDIMSearchController *)searchController {
//    [QDIMHelper renderStatusBarStyleDark];
//    self.tabBarController.tabBar.hidden = YES;
//}
//
//- (void)willDismissSearchController:(QDIMSearchController *)searchController {
//    BOOL oldStatusbarLight = NO;
////    if ([self respondsToSelector:@selector(shouldSetStatusBarStyleLight)]) {
////        oldStatusbarLight = [self shouldSetStatusBarStyleLight];
////    }
//    if (oldStatusbarLight) {
//        [QDIMHelper renderStatusBarStyleLight];
//    } else {
//        [QDIMHelper renderStatusBarStyleDark];
//    }
//    self.tabBarController.tabBar.hidden = NO;
//}

@end
