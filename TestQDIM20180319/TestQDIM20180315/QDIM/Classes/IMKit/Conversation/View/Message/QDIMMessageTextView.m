//
//  QDIMMessageTextView.m
//  QDIM
//
//  Created by QDHL on 2018/3/14.
//

#import "QDIMMessageTextView.h"
#import "BYChatLabel.h"


@interface QDIMMessageTextView()

@property CGFloat maxWidth;
@property (nonatomic, strong) QDIMMessageTextViewModel *textViewModel;

@property (strong, nonatomic) UIImageView *textBubbleBGImageView;
@property (strong, nonatomic) NSLayoutConstraint *widthConstraintOfTextBubbleBGImageView;
@property (strong, nonatomic) NSLayoutConstraint *heightConstraintOfTextBubbleBGImageView;


@property CGFloat chatLabelLeftMargin;
@property CGFloat chatLabelRightMargin;
@property CGFloat chatLabelTopMargin;
@property CGFloat chatLabelBottomMargin;

@end

@implementation QDIMMessageTextView
- (void)layoutSubViewWithMaxWidth:(CGFloat)maxWidth
{
    if (self.textViewModel.height == 0.0) {
        self.maxWidth = maxWidth;
        [self adjustLayoutConstraint];
    }
}

+ (CGFloat)viewHeight:(QDIMBaseMessageModel *)messageModel maxWidth:(CGFloat)maxWidth{
    QDIMMessageTextViewModel *vm = [[QDIMMessageTextViewModel alloc]initWithTextModel:(QDIMMessageTextModel*)messageModel];
    
    //获取chatLabel属性文本高度、宽度
    UITextView *view=[[UITextView alloc] init];
    view.textContainer.lineFragmentPadding = 0;
    view.attributedText = vm.attributedText;
    
    CGFloat allWidthMargin = 15.0 + 10.0;
    CGFloat allHeightMargin = 10.0 + 10.0;
    CGSize size=[view sizeThatFits:CGSizeMake(maxWidth - allWidthMargin, CGFLOAT_MAX)];
    
    CGFloat heightOfChatLabel = size.height - 16;
    //CGFloat widthOfChatLabel = size.width;
    
    //开始计算自身高度、宽度
    CGFloat heithtOfself = heightOfChatLabel + allHeightMargin;
    //CGFloat widthOfself = widthOfChatLabel + allWidthMargin;
    
    return heithtOfself;
}

/**
 初始化消息文本视图

 @param textViewModel 文本视图模型
 @return 消息文本视图
 */
-(instancetype)initWithTextViewModel: (QDIMMessageTextViewModel*)textViewModel {
    self = [super init];
    if (self != nil) {
        self.clipsToBounds=NO;
        _maxWidth = 0.0;
        _textViewModel = textViewModel;
        
        if (textViewModel.textModel.showType == 0) {
            _chatLabelLeftMargin = 15.0;
            _chatLabelRightMargin = 10.0;
        }else{
            _chatLabelLeftMargin = 10.0;
            _chatLabelRightMargin = 15.0;
        }
        _chatLabelTopMargin = 10;
        _chatLabelBottomMargin = 10;
        
        [self initSubViews];
    }
    
    return self;
}

/**
 初始化子视图
 */
-(void)initSubViews {
    //添加汽包背景
    [self addBubbleBGImageView];
    //添加聊天标签
    [self addChatLabel];
}


/**
 添加汽包背景
 */
-(void)addBubbleBGImageView {
    NSInteger type = _textViewModel.textModel.showType;
    NSString *imageName = type == 0 ? @"chat_bubble_received" : @"chat_bubble_sended";
    self.textBubbleBGImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imageName]];
    
    self.textBubbleBGImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.textBubbleBGImageView];
    type == 0 ? [self addConstraintBetweenSelfAndTextBubbleBGImageViewLeft] : [self addConstraintBetweenSelfAndTextBubbleBGImageViewRight];
}

/**
 添加self和textBubbleBGImageView之间的约束关系,textBubbleBGImageView位于左边
 */
-(void)addConstraintBetweenSelfAndTextBubbleBGImageViewLeft {
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:self.textBubbleBGImageView
                                                            attribute:NSLayoutAttributeTop
                                                            relatedBy:NSLayoutRelationEqual
                                                              toItem:self
                                                            attribute:NSLayoutAttributeTop
                                                            multiplier:1.0
                                                            constant:0.0];
    NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:self.textBubbleBGImageView
                                                           attribute:NSLayoutAttributeLeft
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:self
                                                           attribute:NSLayoutAttributeLeft
                                                          multiplier:1.0
                                                            constant:0.0];
    NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:self.textBubbleBGImageView
                                                             attribute:NSLayoutAttributeWidth
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:nil
                                                             attribute:NSLayoutAttributeNotAnAttribute
                                                            multiplier:1.0
                                                              constant:166];
    NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:self.textBubbleBGImageView
                                                             attribute:NSLayoutAttributeHeight
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:nil
                                                             attribute:NSLayoutAttributeNotAnAttribute
                                                            multiplier:1.0
                                                              constant:38];
    [self addConstraints:@[top, left]];
    [self.textBubbleBGImageView addConstraints:@[width, height]];
    self.widthConstraintOfTextBubbleBGImageView = width;
    self.heightConstraintOfTextBubbleBGImageView = height;
}

/**
 添加self和textBubbleBGImageView之间的约束关系,textBubbleBGImageView位于右边
 */
-(void)addConstraintBetweenSelfAndTextBubbleBGImageViewRight {
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:self.textBubbleBGImageView
                                                           attribute:NSLayoutAttributeTop
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:self
                                                           attribute:NSLayoutAttributeTop
                                                          multiplier:1.0
                                                            constant:0.0];
    NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:self.textBubbleBGImageView
                                                            attribute:NSLayoutAttributeRight
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self
                                                            attribute:NSLayoutAttributeRight
                                                           multiplier:1.0
                                                             constant:0.0];
    NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:self.textBubbleBGImageView
                                                             attribute:NSLayoutAttributeWidth
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:nil
                                                             attribute:NSLayoutAttributeNotAnAttribute
                                                            multiplier:1.0
                                                              constant:166];
    NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:self.textBubbleBGImageView
                                                              attribute:NSLayoutAttributeHeight
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:nil
                                                              attribute:NSLayoutAttributeNotAnAttribute
                                                             multiplier:1.0
                                                               constant:38];
    [self addConstraints:@[top, right]];
    [self.textBubbleBGImageView addConstraints:@[width, height]];
    self.widthConstraintOfTextBubbleBGImageView = width;
    self.heightConstraintOfTextBubbleBGImageView = height;
}


/**
 添加聊天标签
 */
-(void)addChatLabel {
    self.chatLabel = [[BYChatLabel alloc]initWithFrame:CGRectZero];
    self.chatLabel.font = self.textViewModel.font;
    self.chatLabel.attributedText = self.textViewModel.attributedText;
    
    self.chatLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.chatLabel];
    [self addConstraintBetweenSelfAndChatLabel];
}


/**
 添加self和chatLabel之间的约束关系
 */
-(void)addConstraintBetweenSelfAndChatLabel {
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:self.chatLabel
                                                           attribute:NSLayoutAttributeTop
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:self.textBubbleBGImageView
                                                           attribute:NSLayoutAttributeTop
                                                          multiplier:1.0
                                                            constant:self.chatLabelTopMargin];
    NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:self.chatLabel
                                                              attribute:NSLayoutAttributeBottom
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.textBubbleBGImageView
                                                              attribute:NSLayoutAttributeBottom
                                                             multiplier:1.0
                                                               constant:0 - self.chatLabelTopMargin];
    NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:self.chatLabel
                                                            attribute:NSLayoutAttributeLeft
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self.textBubbleBGImageView
                                                            attribute:NSLayoutAttributeLeft
                                                           multiplier:1.0
                                                             constant:self.chatLabelLeftMargin];
    NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:self.chatLabel
                                                            attribute:NSLayoutAttributeRight
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self.textBubbleBGImageView
                                                            attribute:NSLayoutAttributeRight
                                                           multiplier:1.0
                                                             constant: 0 - self.chatLabelRightMargin];
    [self addConstraints:@[top, bottom, left, right]];
}

/**
 调整布局约束
 根据self.maxWidth精确布局
 */
-(void)adjustLayoutConstraint{
    //获取chatLabel属性文本高度、宽度
    UITextView *view=[[UITextView alloc] init];
    view.textContainer.lineFragmentPadding = 0;
    view.attributedText = self.chatLabel.attributedText;
    CGSize size=[view sizeThatFits:CGSizeMake(self.maxWidth - self.chatLabelLeftMargin - self.chatLabelRightMargin, CGFLOAT_MAX)];
    
    CGFloat heightOfChatLabel = size.height - 16;
    CGFloat widthOfChatLabel = size.width;
    
    //开始计算自身高度、宽度
    CGFloat heithtOfself = self.chatLabelTopMargin + heightOfChatLabel + self.chatLabelBottomMargin;
    CGFloat widthOfself = self.chatLabelLeftMargin + widthOfChatLabel + self.chatLabelRightMargin;
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, widthOfself, heithtOfself);
    self.textViewModel.height = heithtOfself;
    
    //由于子视图是用自动布局的，所以即使上面frame发生的变化，子视图不会自我调整的，要更新他们的约束
    self.widthConstraintOfTextBubbleBGImageView.constant = widthOfself;
    self.heightConstraintOfTextBubbleBGImageView.constant = heithtOfself;
    
    //调整textBubbleBGImageView的image
    UIImage *image =self.textBubbleBGImageView.image;
    //设置拉伸图片的范围
    UIEdgeInsets ed = {25.0f, 10.0f, 10.0f, 10.0f};
    
    //将图片拉伸后，再赋值给receiveIV
    self.textBubbleBGImageView.image = [image resizableImageWithCapInsets:ed];
}


/**
 单行文本的高度

 @return 单行文本的高度
 */
-(CGFloat)heightOfSingleLineAttributeString{
    
    NSString *string = @"test";
    
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:string];
    NSMutableParagraphStyle *style = [NSMutableParagraphStyle new];
    style.lineSpacing = 3.0;
    style.lineBreakMode = NSLineBreakByWordWrapping;
    style.alignment = NSTextAlignmentLeft;
    
    [attStr addAttributes:@{NSFontAttributeName : self.chatLabel.font, NSParagraphStyleAttributeName : style} range:NSMakeRange(0, string.length)];
    
    UITextView *view=[[UITextView alloc] init];
    view.textContainer.lineFragmentPadding = 0;
    view.attributedText = attStr;
    CGSize size=[view sizeThatFits:CGSizeMake(self.maxWidth - self.chatLabelLeftMargin - self.chatLabelRightMargin, CGFLOAT_MAX)];
    
    return size.height;
}

@end
























