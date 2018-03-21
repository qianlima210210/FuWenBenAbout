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
#import "CTRunItem.h"

@interface SelectedView : UIView

@property (nonatomic, strong) CTRunItem *first;
@property (nonatomic, strong)  CTRunItem *last;

@end

@implementation SelectedView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.opaque = NO;
    }
    return self;
}

-(void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    //将origin从标签坐标系转到其父视图坐标系
    //[self.blueLayer convertPoint:point fromLayer:self.layerView.layer]
    QDIMMessageTextView *textView =  (QDIMMessageTextView *)self.superview;
    
    CGPoint firstpoint = [self.layer convertPoint:self.first.rect.origin fromLayer:textView.chatLabel.layer];
    [self updatePinLayer:ctx point:firstpoint height:self.first.rect.size.height isLeft:true];
    
    CGPoint lastpoint = [self.layer convertPoint:self.last.rect.origin fromLayer:textView.chatLabel.layer];
    lastpoint.x = lastpoint.x + self.last.rect.size.width;
    [self updatePinLayer:ctx point:lastpoint height:self.last.rect.size.height isLeft:false];
    
}

- (void)updatePinLayer:(CGContextRef)ctx point:(CGPoint)point height:(CGFloat)height isLeft:(BOOL)isLeft {
    UIColor *color = [UIColor colorWithRed:0/255.0 green:128/255.0 blue:255/255.0 alpha:1.0];
    CGRect roundRect = CGRectMake(point.x - 5,
                                  isLeft?(point.y - 10):(point.y + height),
                                  10,
                                  10);
    //画圆
    CGContextAddEllipseInRect(ctx, roundRect);
    [color set];
    CGContextFillPath(ctx);
    
    CGContextMoveToPoint(ctx, point.x, point.y);
    CGContextAddLineToPoint(ctx, point.x, point.y + height);
    CGContextSetLineWidth(ctx, 2.0);
    CGContextSetStrokeColorWithColor(ctx, color.CGColor);
    
    CGContextStrokePath(ctx);
}

@end

@interface ViewController ()

@property (nonatomic, strong) QDIMMessageTextView *textView;
@property (nonatomic, strong) QDIMMessageTextModel *m;
@property (nonatomic, strong) QDIMMessageTextViewModel *vm;

@property (nonatomic, strong) NSMutableArray *glyphRangeArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _glyphRangeArray = [NSMutableArray arrayWithCapacity:10];
    
    UIButton *setMaxWidthBtn = [UIButton new];
    [setMaxWidthBtn setTitle:@"setMaxWidthBtn" forState:UIControlStateNormal];
    [setMaxWidthBtn addTarget:self action:@selector(setMaxWidthBtn:) forControlEvents:UIControlEventTouchUpInside];
    setMaxWidthBtn.frame = CGRectMake(30, 30, 50, 30);
    [self.view addSubview:setMaxWidthBtn];
    
    UIButton *btn = [UIButton new];
    [btn setTitle:@"test" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(testBtn:) forControlEvents:UIControlEventTouchUpInside];
    btn.frame = CGRectMake(90, 30, 50, 30);
    [self.view addSubview:btn];
    

    _m = [[QDIMMessageTextModel alloc]init];
    _m.showType = 0;
    _m.text = @"改变hr@163.com世界创造价值😱由于子视图是用自动布局的由于https://www.baidu❤️.com子视图是用自动布局的由于子视图是用自动布局的由于子视图是用自动布局的由于子视图是用自动布局的子视图不会自我调整021-54377032的要更新他们的约束me@163.com❤️";
    _vm = [[QDIMMessageTextViewModel alloc]initWithTextModel:_m];
    
    _textView = [[QDIMMessageTextView alloc]initWithTextViewModel:_vm];
    //_textView.backgroundColor = UIColor.redColor;
    _textView.frame = CGRectMake(30, 100, 300, 200);
    //_textView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_textView];
    
}

-(void)setMaxWidthBtn:(UIButton*)sender{
    [_textView layoutSubViewWithMaxWidth:315.0];
    NSLog(@"%@", _textView);
    NSLog(@"height = %f", [QDIMMessageTextView viewHeight:_m maxWidth:315.0]);
    
    __block NSInteger index = 0;
    [_vm.attributedText.string enumerateSubstringsInRange:NSMakeRange(0, [_vm.attributedText length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {

         CTRunItem *item = [CTRunItem new];
         item.substring = substring;
         item.substringRange = substringRange;

         [_glyphRangeArray addObject:item];

         index++;
         NSLog(@"length=%ld", (long)index);
     }];

    sender.enabled = NO;
    NSLog(@"数组长度=%ld", (unsigned long)_glyphRangeArray.count);
    
    sender.enabled = NO;
}

//模拟长按事件
-(void)testBtn:(UIButton*)sender{
    //遍历数组
    for (CTRunItem *item in self.glyphRangeArray) {
        UIColor *backColor = [UIColor colorWithRed:0.0 green:84.0 / 255.0 blue:166.0 / 255.0 alpha:0.2];
        [_textView.chatLabel.textStorage addAttributes:@{NSBackgroundColorAttributeName : backColor} range:item.substringRange];
        [_textView.chatLabel setNeedsDisplay];
        
        item.rect = [_textView.chatLabel characterRectAtIndex:item.substringRange.location];
        NSLog(@"%f,%f, %f, %f", item.rect.origin.x, item.rect.origin.y, item.rect.size.width, item.rect.size.height);
    }
    
    //添加选中视图
    SelectedView *select = [SelectedView new];
    select.frame = _textView.bounds;
    select.first = self.glyphRangeArray.firstObject;
    select.last = self.glyphRangeArray.lastObject;
    [_textView addSubview:select];
    
    sender.enabled = NO;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
}



@end
