//
//  QDIMConversationViewController.m
//  QDIM
//
//  Created by qd-hxt on 2018/3/9.
//

#import "QDIMConversationViewController.h"
#import "QDIMInputBar.h"
#import "QDIMInputContentView.h"


@interface QDIMConversationViewController () <UITableViewDelegate, UITableViewDataSource, QDIMInputContentViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) QDIMInputContentView *inputContentView;

@end


@implementation QDIMConversationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"聊天";
    
    [self.view addSubview:self.tableView];
    self.tabBarController.tabBar.hidden = YES;
    
    self.inputContentView = [[QDIMInputContentView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame) - QDIMInputBarNormalHeigt, CGRectGetWidth(self.view.frame), QDIMInputBarNormalHeigt)];
    _inputContentView.delegate = self;
    [self.view addSubview:_inputContentView];
    
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundView.backgroundColor = [UIColor orangeColor];
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    }
    return _tableView;
}

- (void)didInitialized {
    [super didInitialized];
}

#pragma mark - override

- (void)setNavigationItemsIsInEditMode:(BOOL)isInEditMode animated:(BOOL)animated {
    [super setNavigationItemsIsInEditMode:isInEditMode animated:animated];
    self.title = @"郭靖";
}

#pragma mark - Delegate

#pragma mark UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.inputContentView resignFirstResponder];
}

#pragma mark QDIMInputContentViewDelegate
- (void)inputContentView:(QDIMInputContentView *)inputContentView heightChange:(CGFloat)height {
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.tableView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - height);
        self.inputContentView.frame = CGRectMake(0, CGRectGetHeight(self.view.frame) - height, CGRectGetWidth(self.view.frame), height);
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark UITableViewDataSource && UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"123"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"123"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"第 %ld 行", (long)indexPath.row];
    cell.contentView.backgroundColor = [UIColor orangeColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.view endEditing:YES];
}


@end

