//
//  QDIMBaseMessageCell.m
//  Pods
//
//  Created by Yuanys on 2018/3/8.
//

#import "QDIMBaseMessageCell.h"
#import "QDIMBaseMessageModel.h"
#import "QDIMMessageViewFactory.h"
#import "QDIMBaseMessageView.h"

// 头像边距（只约束，上、左、右）
#define kHeadImgInset UIEdgeInsetsMake(0.f, 15.f, 0.f, 15.f)
// 头像宽高
#define kHeadImgSize CGSizeMake(60.f, 60.f)

// MessageView边距（只约束，上、左、右）
#define kMessageViewInset UIEdgeInsetsMake(0.f, 90.f, 0.f, 90.f)

@interface QDIMBaseMessageCell()
// 头像
@property (weak, nonatomic) IBOutlet UIImageView *headImgView;

// 头像约束：上、左、右、宽、高
@property (unsafe_unretained, nonatomic) IBOutlet NSLayoutConstraint *headImgTop;
@property (unsafe_unretained, nonatomic) IBOutlet NSLayoutConstraint *headImgLeading;
@property (unsafe_unretained, nonatomic) IBOutlet NSLayoutConstraint *headImgTrailing;
@property (unsafe_unretained, nonatomic) IBOutlet NSLayoutConstraint *headImgHeight;
@property (unsafe_unretained, nonatomic) IBOutlet NSLayoutConstraint *headImgWidth;

// MessageView
@property (nonatomic, strong) QDIMBaseMessageView *messageView;

// 消息模型
@property (nonatomic, strong) QDIMBaseMessageModel *mesage;

@end

@implementation QDIMBaseMessageCell

+ (instancetype)cellFromNib
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].lastObject;
}

- (void)setMessage:(nonnull QDIMBaseMessageModel *)message
{
    // 1.保存message
    self.mesage = message;
    
    // 2.更新HeadView约束
    [self updateHeadImgLayout:message.showType];
    
    // 3.创建messageView
    if (self.messageView != nil) {
        [self.messageView removeFromSuperview];
    }
    self.messageView = [QDIMMessageViewFactory createMessageView:message];
    [self.contentView addSubview:self.messageView];
    
    // 4.更新messageView约束
    [self updateMessageViewLayout:message.showType];
    
    // 更新布局
    [self layoutIfNeeded];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // 头像约束
    self.headImgTop.constant = kHeadImgInset.top;
    self.headImgLeading.constant = kHeadImgInset.left;
    self.headImgTrailing.constant = kHeadImgInset.right;
    self.headImgWidth.constant = kHeadImgSize.width;
    self.headImgHeight.constant = kHeadImgSize.height;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


#pragma mark - Private
// 修改头像约束
- (void)updateHeadImgLayout:(QDIMBaseMessageModelShowType)showType
{
    if (showType == QDIMBaseMessageModelShowType_left) {
        // 1.修改头像约束
        // 高优先级
        self.headImgLeading.priority = UILayoutPriorityDefaultHigh;
        // 低优先级
        self.headImgTrailing.priority = UILayoutPriorityDefaultLow;
    }else if (showType == QDIMBaseMessageModelShowType_Right) {
        // 1.修改头像约束
        // 低优先级
        self.headImgLeading.priority = UILayoutPriorityDefaultLow;
        // 高优先级
        self.headImgTrailing.priority = UILayoutPriorityDefaultHigh;
    }
}

// 修改MessageView约束
- (void)updateMessageViewLayout:(QDIMBaseMessageModelShowType)showType
{
    // 1.约束宽高
    NSLayoutConstraint *widthCons = [NSLayoutConstraint constraintWithItem:self.messageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.f   constant:self.messageView.frame.size.width];
    NSLayoutConstraint *heightCons = [NSLayoutConstraint constraintWithItem:self.messageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.f constant:self.messageView.frame.size.height];
    [self.messageView addConstraints:@[widthCons, heightCons]];
    
    // 2.约束位置
    NSLayoutConstraint *topCons = [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.messageView attribute:NSLayoutAttributeTop multiplier:1.f constant:kMessageViewInset.top];
    
    NSLayoutAttribute layoutAttribute  = NSLayoutAttributeLeading;
    if (showType == QDIMBaseMessageModelShowType_left) {
        layoutAttribute = NSLayoutAttributeLeading;
    }else if (showType == QDIMBaseMessageModelShowType_Right) {
        layoutAttribute = NSLayoutAttributeTrailing;
    }
    
    NSLayoutConstraint *secondCons = [NSLayoutConstraint constraintWithItem:self.contentView attribute:layoutAttribute relatedBy:NSLayoutRelationEqual toItem:self.messageView attribute:NSLayoutAttributeTop multiplier:1.f constant:kMessageViewInset.left];
    [self.contentView addConstraints:@[topCons, secondCons]];
}

// 是否显示头像
- (BOOL)isShowHeads
{
    return self.mesage.messageType != QDIMCellMessageType_SysTip;
}
@end
