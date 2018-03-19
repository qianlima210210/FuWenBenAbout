//
//  QDIMInputBar.m
//  Pods
//
//  Created by qd-hxt on 2018/3/8.
//

#import "QDIMInputBar.h"
#import "NSBundle+QDIM.h"
#import "UIImage+QDIM.h"

@interface QDIMInputBar () <UITextViewDelegate>

@property (nonatomic, weak  ) IBOutlet UIButton *voiceButton;/**< 语音或者文字Button */

@property (nonatomic, weak  ) IBOutlet UIButton *recordButton;/**< 录音Button */

@property (nonatomic, weak  ) IBOutlet UITextView *inputTextView;/**< 输入框 */

@property (nonatomic, weak  ) IBOutlet UIButton *faceButton;/**< 表情Button */

@property (nonatomic, weak  ) IBOutlet UIButton *moreButton;/**< 扩展Button */


@end



@implementation QDIMInputBar


#pragma mark - Get && Set && Init

+ (UINib *)inputBarNib {
    NSString *qdIMBundlePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"QDIM" ofType:@"bundle"];
    NSBundle *qdIMBundle = [NSBundle bundleWithPath:qdIMBundlePath];
    UINib *inputNib = [UINib nibWithNibName:NSStringFromClass([QDIMInputBar class]) bundle:qdIMBundle];
    return inputNib;
}



#pragma mark - Life Cycle

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.inputTextView.layer.borderColor = [[UIColor grayColor] CGColor];
    self.inputTextView.layer.borderWidth = 0.5;
    self.inputTextView.layer.cornerRadius = 5;
    
    self.recordButton.layer.borderColor = [[UIColor grayColor] CGColor];
    self.recordButton.layer.borderWidth = 0.5;
    self.recordButton.layer.cornerRadius = 5;
    [self.recordButton setTitle:@"按住 说话" forState:UIControlStateNormal];
    [self.recordButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    [self.voiceButton setTitle:@"V" forState:UIControlStateNormal];
    [self.faceButton setTitle:@"F" forState:UIControlStateNormal];
    [self.moreButton setTitle:@"+" forState:UIControlStateNormal];
    
}

#pragma mark - Public Methods
- (BOOL)resignFirstResponder {
    [self changeInputBarButtons];
    return [super resignFirstResponder];
}

#pragma mark - Private Methods
- (void)changeInputBarButtons {
    //这里只做根据状态改变按钮的显示
    switch (_status) {
        case QDIMInputBarStatusNothing:
        case QDIMInputBarStatusShowKeyboard:
        case QDIMInputBarStatusShowMore: {
            UIImage *voiceImage = [UIImage qdim_imageNamed:@"ToolViewInputVoice" inBundle:[NSBundle qdim_bundleFromClass:[QDIMInputBar class] resourceName:@"QDIM"]];
            [self.voiceButton setImage:voiceImage forState:UIControlStateNormal];
            UIImage *emotionImage = [UIImage qdim_imageNamed:@"ToolViewEmotion" inBundle:[NSBundle qdim_bundleFromClass:[QDIMInputBar class] resourceName:@"QDIM"]];
            [self.faceButton setImage:emotionImage forState:UIControlStateNormal];

            self.recordButton.hidden = YES;
            self.inputTextView.hidden = NO;
        }
            break;
        case QDIMInputBarStatusShowFace: {
            UIImage *voiceImage = [UIImage qdim_imageNamed:@"ToolViewInputVoice" inBundle:[NSBundle qdim_bundleFromClass:[QDIMInputBar class] resourceName:@"QDIM"]];
            [self.voiceButton setImage:voiceImage forState:UIControlStateNormal];
            UIImage *keyboardImage = [UIImage qdim_imageNamed:@"ToolViewKeyboard" inBundle:[NSBundle qdim_bundleFromClass:[QDIMInputBar class] resourceName:@"QDIM"]];
            [self.faceButton setImage:keyboardImage forState:UIControlStateNormal];
            self.recordButton.hidden = YES;
            self.inputTextView.hidden = NO;
        }
            break;
        case QDIMInputBarStatusShowVoice: {
            UIImage *keyboardImage = [UIImage qdim_imageNamed:@"ToolViewKeyboard" inBundle:[NSBundle qdim_bundleFromClass:[QDIMInputBar class] resourceName:@"QDIM"]];
            [self.voiceButton setImage:keyboardImage forState:UIControlStateNormal];
            UIImage *emotionImage = [UIImage qdim_imageNamed:@"ToolViewEmotion" inBundle:[NSBundle qdim_bundleFromClass:[QDIMInputBar class] resourceName:@"QDIM"]];
            [self.faceButton setImage:emotionImage forState:UIControlStateNormal];
            self.recordButton.hidden = NO;
            self.inputTextView.hidden = YES;
        }
            break;
        default:
            break;
    }
}


#pragma mark - IBAction
- (IBAction)voiceButtonClick:(UIButton *)sender {
    QDIMInputBarStatus lastStatus = self.status;
    if (self.status != QDIMInputBarStatusShowVoice) {
        self.status = QDIMInputBarStatusShowVoice;
        [self.inputTextView resignFirstResponder];
        [self.inputTextView resignFirstResponder];
    }else {
        self.status = QDIMInputBarStatusShowKeyboard;
        [self.inputTextView becomeFirstResponder];
    }
    [self changeInputBarButtons];
    if (self.delegate && [self.delegate respondsToSelector:@selector(updateInputBar:fromStatus:toStatus:)]) {
        [self.delegate updateInputBar:self fromStatus:lastStatus toStatus:self.status];
    }
}

- (IBAction)faceButtonClick:(UIButton *)sender {
    QDIMInputBarStatus lastStatus = self.status;
    if (self.status != QDIMInputBarStatusShowFace) {
        self.status = QDIMInputBarStatusShowFace;
        [self.inputTextView resignFirstResponder];
    }else {
        self.status = QDIMInputBarStatusShowKeyboard;
        [self.inputTextView becomeFirstResponder];
    }
    [self changeInputBarButtons];
    if (self.delegate && [self.delegate respondsToSelector:@selector(updateInputBar:fromStatus:toStatus:)]) {
        [self.delegate updateInputBar:self fromStatus:lastStatus toStatus:self.status];
    }
}

- (IBAction)moreButtonClick:(UIButton *)sender {
    QDIMInputBarStatus lastStatus = self.status;
    if (self.status != QDIMInputBarStatusShowMore) {
        self.status = QDIMInputBarStatusShowMore;
        [self.inputTextView resignFirstResponder];
    }else {
        self.status = QDIMInputBarStatusShowKeyboard;
        [self.inputTextView becomeFirstResponder];
    }

    [self changeInputBarButtons];
    if (self.delegate && [self.delegate respondsToSelector:@selector(updateInputBar:fromStatus:toStatus:)]) {
        [self.delegate updateInputBar:self fromStatus:lastStatus toStatus:self.status];
    }
}


#pragma mark - Delegate
#pragma mark UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView {
    self.status = QDIMInputBarStatusShowKeyboard;
    [self changeInputBarButtons];
}

@end
