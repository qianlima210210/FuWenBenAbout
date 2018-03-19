//
//  ViewController.m
//  BYChatLabelDemo
//
//  Created by QDHL on 2018/3/13.
//  Copyright © 2018年 QDHL. All rights reserved.
//
#import "ViewController.h"
#import "BYChatLabel.h"
#import "NSAttributedString+AttributedStringHeight.h"

@interface ViewController ()
    @property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthConstraint;

@property (weak, nonatomic) IBOutlet BYChatLabel *label;
    
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSString *string = @"http://www.baidu.com2018-03-18 09:24:22.637412http://www.baidu.com2018-03-18 09:24:22.637412http://www.baidu.com2018-03-18 09:24:22.637412+0800 BYChatLabelDemo[64255:6670931] 您点击了url链接=http://www.baidu.com于子视图http://www.baidu.com于子视图http://www.baidu.com于子视图http://www.baidu.com于子视图http://www.baidu.com于子视图heightOfAttributedStringWithSize改变世界创13661150881造价值由于子视图是用自动布局的由于子视图是用自动hr@163.com布局的由于子视图是用自动布局的由http://www.baidu.com于子视图是用自👌动布局的由于子视图🙃是用自动布局的子视图不❤️会自我调整的要更新他们的约束";
    
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:string];
    NSMutableParagraphStyle *s = [NSMutableParagraphStyle new];
    s.lineBreakMode = NSLineBreakByWordWrapping;
    s.alignment = NSTextAlignmentLeft;
    
    [attStr addAttributes:@{NSFontAttributeName : _label.font, NSParagraphStyleAttributeName : s} range:NSMakeRange(0, string.length)];
    self.label.attributedText = attStr;
    
    /*方法一
    UITextView *view=[[UITextView alloc] init];
    view.textContainer.lineFragmentPadding = 0;
    view.attributedText = self.label.attributedText;
    CGSize size=[view sizeThatFits:CGSizeMake(_label.bounds.size.width, CGFLOAT_MAX)];
    
    //计算属性文本高度
    _heightConstraint.constant = size.height - 16;
    _widthConstraint.constant = size.width;
     */
    
    /*方法二
    CGSize size=[self.label sizeThatFits:CGSizeMake(_label.bounds.size.width, CGFLOAT_MAX)];
    _heightConstraint.constant = size.height;
    _widthConstraint.constant = size.width;
    */
    
    /*方法三(宽度上可能会造成浪费，因为最大行不可能等于标签的宽度)*/
    _heightConstraint.constant = [attStr heightOfAttributedStringWithSize:CGSizeMake(self.label.bounds.size.width, 1000) font:self.label.font];
     
}

-(CGFloat)heightOfSingleLineAttributeString{
    
    NSString *string = @"test";
    
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:string];
    NSMutableParagraphStyle *style = [NSMutableParagraphStyle new];
    style.lineBreakMode = NSLineBreakByWordWrapping;
    style.alignment = NSTextAlignmentLeft;
    
    [attStr addAttributes:@{NSFontAttributeName : _label.font, NSParagraphStyleAttributeName : style} range:NSMakeRange(0, string.length)];
    
    UITextView *view=[[UITextView alloc] init];
    view.textContainer.lineFragmentPadding = 0;
    view.attributedText = attStr;
    CGSize size=[view sizeThatFits:CGSizeMake(_label.bounds.size.width, CGFLOAT_MAX)];
    
    return size.height;
}

@end
