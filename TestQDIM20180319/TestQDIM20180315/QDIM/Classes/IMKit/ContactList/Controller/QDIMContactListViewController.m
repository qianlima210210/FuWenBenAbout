//
//  QDIMContactListViewController.m
//  QDIM
//
//  Created by qd-hxt on 2018/3/14.
//

#import "QDIMContactListViewController.h"

@interface QDIMContactListViewController ()

@end

@implementation QDIMContactListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)setNavigationItemsIsInEditMode:(BOOL)isInEditMode animated:(BOOL)animated {
    [super setNavigationItemsIsInEditMode:isInEditMode animated:animated];
    self.title = @"联系人";
}

@end
