//
//  ViewController.m
//  TestQDIM20180315
//
//  Created by QDHL on 2018/3/15.
//  Copyright © 2018年 QDHL. All rights reserved.
//

#import "ViewController.h"
#import "QDIMMessageTextModel.h"
#import "QDIMMessageTextViewModel.h"
#import "QDIMMessageTextView.h"
#import "CTRunUrl.h"

@interface ViewController ()

@property (nonatomic, strong) QDIMMessageTextView *textView;
@property (nonatomic, strong) QDIMMessageTextModel *m;
@property (nonatomic, strong) QDIMMessageTextViewModel *vm;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    _m = [[QDIMMessageTextModel alloc]init];
    _m.showType = 1;
    _m.text = @"改变hr@163.com世界创造价值😱由于子视图是用自动布局的由于https://www.baidu❤️.com子视图是用自动布局的由于子视图是用自动布局的由于子视图是用自动布局的由于子视图是用自动布局的子视图不会自我调整021-54377032的要更新他们的约束me@163.com❤️";
    _vm = [[QDIMMessageTextViewModel alloc]initWithTextModel:_m];
    
    _textView = [[QDIMMessageTextView alloc]initWithTextViewModel:_vm];
    //_textView.backgroundColor = UIColor.redColor;
    _textView.frame = CGRectMake(30, 100, 300, 200);
    //_textView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_textView];
    
    
    __block NSInteger index = 0;
    [_vm.attributedText.string enumerateSubstringsInRange:NSMakeRange(0, [_vm.attributedText length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {

        NSString *urlStr = [NSString stringWithFormat:@"https://www.Label%@",@(index)];
        CTRunUrl *runUrl = [CTRunUrl URLWithString:urlStr];
         
         runUrl.index = index;
         runUrl.rangValue = [NSValue valueWithRange:substringRange];
         [_vm.attributedText addAttribute:NSLinkAttributeName
                         value:runUrl
                         range:substringRange];
         index++;
         NSLog(@"length=%ld", index);
     }];
    
//    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:_textView
//                                                           attribute:NSLayoutAttributeTop
//                                                           relatedBy:NSLayoutRelationEqual
//                                                              toItem:self.view
//                                                           attribute:NSLayoutAttributeTop
//                                                          multiplier:1.0
//                                                            constant:100.0];
//    NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:_textView
//                                                            attribute:NSLayoutAttributeLeft
//                                                            relatedBy:NSLayoutRelationEqual
//                                                               toItem:self.view
//                                                            attribute:NSLayoutAttributeLeft
//                                                           multiplier:1.0
//                                                             constant:30.0];
//    NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:_textView
//                                                             attribute:NSLayoutAttributeWidth
//                                                             relatedBy:NSLayoutRelationEqual
//                                                                toItem:nil
//                                                             attribute:NSLayoutAttributeNotAnAttribute
//                                                            multiplier:1.0
//                                                              constant:200];
//    NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:_textView
//                                                              attribute:NSLayoutAttributeHeight
//                                                              relatedBy:NSLayoutRelationEqual
//                                                                 toItem:nil
//                                                              attribute:NSLayoutAttributeNotAnAttribute
//                                                             multiplier:1.0
//                                                               constant:300.0];
//    [self.view addConstraints:@[top, left]];
//    [self.textView addConstraints:@[width, height]];
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_textView layoutSubViewWithMaxWidth:315.0];
    NSLog(@"%@", _textView);
    
    NSLog(@"height = %f", [QDIMMessageTextView viewHeight:_m maxWidth:315.0]);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
