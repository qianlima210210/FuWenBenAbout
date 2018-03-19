//
//  QDIMInputContentView.m
//  QDIM
//
//  Created by 许龙 on 2018/3/13.
//

#import "QDIMInputContentView.h"
#import "QDIMInputBar.h"
#import "QDIMToolPanel.h"
#import "QDIMCommonDefines.h"

@interface QDIMInputContentView () <QDIMInputBarDelegate>

@property (nonatomic, strong) QDIMInputBar *inputBar;

@property (nonatomic, strong) QDIMToolPanel *toolPanel;

@end

//static inline UIViewAnimationOptions animationOptionsWithCurve(UIViewAnimationCurve curve) {
//    switch (curve) {
//        case UIViewAnimationCurveEaseInOut:
//            return UIViewAnimationOptionCurveEaseInOut;
//        case UIViewAnimationCurveEaseIn:
//            return UIViewAnimationOptionCurveEaseIn;
//        case UIViewAnimationCurveEaseOut:
//            return UIViewAnimationOptionCurveEaseOut;
//        case UIViewAnimationCurveLinear:
//            return UIViewAnimationOptionCurveLinear;
//    }
//
//    return curve << 16;
//}



@implementation QDIMInputContentView

#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor grayColor];
        
        [self setUpSubViewsWithFrame:frame];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Override Methods
- (BOOL)resignFirstResponder {

    if (self.inputBar.status == QDIMInputBarStatusShowFace || self.inputBar.status == QDIMInputBarStatusShowMore) {
        self.inputBar.status = QDIMInputBarStatusNothing;
        [self.inputBar resignFirstResponder];
        if (self.delegate && [self.delegate respondsToSelector:@selector(inputContentView:heightChange:)]) {
            [self.delegate inputContentView:self heightChange:QDIMInputBarNormalHeigt];
        }
    }
    
    return [super resignFirstResponder];
}

#pragma mark - Private Methods
- (void)setUpSubViewsWithFrame:(CGRect)frame {
    self.inputBar = [[[QDIMInputBar inputBarNib] instantiateWithOwner:self options:nil] firstObject];
    _inputBar.delegate = self;
    //使用约束时，需要设置为NO
    self.inputBar.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_inputBar];
    
    NSLayoutConstraint *inputBarTopConstraint = [NSLayoutConstraint constraintWithItem:_inputBar attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
    NSLayoutConstraint *inputBarLeftConstraint = [NSLayoutConstraint constraintWithItem:_inputBar attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
    NSLayoutConstraint *inputBarRightConstraint = [NSLayoutConstraint constraintWithItem:_inputBar attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
    NSLayoutConstraint *inputBarHeightConstraint = [NSLayoutConstraint constraintWithItem:_inputBar attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0 constant:QDIMInputBarNormalHeigt];
    [self addConstraints:@[inputBarTopConstraint, inputBarLeftConstraint, inputBarRightConstraint]];
    
    [self.inputBar addConstraint:inputBarHeightConstraint];

}

- (void)showPanelView:(BOOL)animated {
    self.toolPanel.frame = CGRectMake(0, CGRectGetMaxY(self.frame), CGRectGetWidth(self.frame), QDIMToolPanelViewHeight);
    self.toolPanel.alpha = 1;
    if (animated) {
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationCurveEaseInOut animations:^{
            self.toolPanel.frame = CGRectMake(0, QDIMInputBarNormalHeigt, CGRectGetWidth(self.frame), QDIMToolPanelViewHeight);
        } completion:nil];
    }else {
        self.toolPanel.frame = CGRectMake(0, QDIMInputBarNormalHeigt, CGRectGetWidth(self.frame), QDIMToolPanelViewHeight);
    }
}

- (void)hiddenPanelView:(BOOL)animated {
    if (animated) {
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.toolPanel.alpha = 0;
        } completion:^(BOOL finished) {
            
        }];
    }
}


#pragma mark - Notification Methods
- (void)keyboardWillShow:(NSNotification *)noti {
    
}

- (void)keyboardWillHide:(NSNotification *)noti {
    if (self.inputBar.status == QDIMInputBarStatusShowFace || self.inputBar.status == QDIMInputBarStatusShowMore ) {
        return;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(inputContentView:heightChange:)]) {
        [self.delegate inputContentView:self heightChange:QDIMInputBarNormalHeigt];
    }
}

- (void)keyboardWillChangeFrame:(NSNotification *)noti {
    NSDictionary *userInfo = noti.userInfo;
//    NSTimeInterval animationDuration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
//    UIViewAnimationCurve animationCurve = [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    CGRect keyboardFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    if ((self.inputBar.status == QDIMInputBarStatusShowFace || self.inputBar.status == QDIMInputBarStatusShowMore) && CGRectGetMinY(keyboardFrame) >= QDIM_SCREEN_HEIGHT - QDIMToolPanelViewHeight) {
        return;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(inputContentView:heightChange:)]) {
        [self.delegate inputContentView:self heightChange:QDIMInputBarNormalHeigt + CGRectGetHeight(keyboardFrame)];
    }
}

#pragma mark - Delegate
#pragma mark QDIMInputBarDelegate
- (void)updateInputBar:(QDIMInputBar *)inputBar fromStatus:(QDIMInputBarStatus)fromStatus toStatus:(QDIMInputBarStatus)toStatus {
    switch (toStatus) {
        case QDIMInputBarStatusNothing:
            
            break;
        case QDIMInputBarStatusShowVoice: {
            if (self.delegate && [self.delegate respondsToSelector:@selector(inputContentView:heightChange:)]) {
                [self.delegate inputContentView:self heightChange:QDIMInputBarNormalHeigt];
            }
        }
            break;
        case QDIMInputBarStatusShowKeyboard: {
            if (fromStatus == QDIMInputBarStatusShowMore || fromStatus == QDIMInputBarStatusShowFace) {
                [self hiddenPanelView:YES];
            }
        }
            break;
        case QDIMInputBarStatusShowFace:
            [self showPanelView:YES];
            if (self.delegate && [self.delegate respondsToSelector:@selector(inputContentView:heightChange:)]) {
                [self.delegate inputContentView:self heightChange:QDIMToolPanelViewHeight + QDIMInputBarNormalHeigt];
            }
            break;

        case QDIMInputBarStatusShowMore: {
            [self showPanelView:YES];
            if (self.delegate && [self.delegate respondsToSelector:@selector(inputContentView:heightChange:)]) {
                [self.delegate inputContentView:self heightChange:QDIMToolPanelViewHeight + QDIMInputBarNormalHeigt];
            }
        }
            break;
            
        default:
            break;
    }
}


@end
