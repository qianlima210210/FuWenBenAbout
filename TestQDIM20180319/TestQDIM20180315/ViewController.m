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
//起点、终点项
@property (nonatomic, strong) CTRunItem *first;
@property (nonatomic, strong) CTRunItem *last;
//所有项数组
@property (nonatomic, strong) NSMutableArray *glyphRangeArray;

@property (nonatomic, strong) BYChatLabel *chatLabel;

//大头针半径
@property CGFloat radiusOfPin;

@end

@implementation SelectedView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.opaque = NO;
        
        _radiusOfPin = 5.0;
    }
    return self;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //获取开始位置
    CGPoint point = [touches.anyObject locationInView:self];
    
    //判断这个点位于情况：1、在两个大头针之外；2、在两个大头针内，但是不在大头针上；3、在大头针上
    //只处理3
    CGPoint firstPoint = [self.layer convertPoint:self.first.rect.origin fromLayer:_chatLabel.layer];
    CGRect firstRect = CGRectMake(firstPoint.x - _radiusOfPin,
                                  firstPoint.y - _radiusOfPin * 2,
                                  _radiusOfPin * 2,
                                  self.first.rect.size.height + _radiusOfPin * 2);
    if (CGRectContainsPoint(firstRect, point)) {
        NSLog(@"呵呵，你摸到了左边大头针");
    }
    
    CGPoint lastPoint = [self.layer convertPoint:self.last.rect.origin fromLayer:_chatLabel.layer];
    CGRect lastRect = CGRectMake(lastPoint.x + self.last.rect.size.width  - _radiusOfPin,
                                 lastPoint.y,
                                 _radiusOfPin * 2,
                                 self.last.rect.size.height + _radiusOfPin * 2);
    if (CGRectContainsPoint(lastRect, point)) {
        NSLog(@"呵呵，你摸到了右边大头针");
    }
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
}

-(void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    //将origin从标签坐标系转到自己坐标系
    CGPoint firstPoint = [self.layer convertPoint:self.first.rect.origin fromLayer:_chatLabel.layer];
    [self updatePinLayer:ctx point:firstPoint height:self.first.rect.size.height isLeft:true];
    
    CGPoint lastPoint = [self.layer convertPoint:self.last.rect.origin fromLayer:_chatLabel.layer];
    lastPoint.x = lastPoint.x + self.last.rect.size.width;
    [self updatePinLayer:ctx point:lastPoint height:self.last.rect.size.height isLeft:false];
    
}

- (void)updatePinLayer:(CGContextRef)ctx point:(CGPoint)point height:(CGFloat)height isLeft:(BOOL)isLeft {
    UIColor *color = [UIColor colorWithRed:0/255.0 green:128/255.0 blue:255/255.0 alpha:1.0];
    CGRect roundRect = CGRectZero;
    if (isLeft) {
        roundRect = CGRectMake(point.x - _radiusOfPin,
                                      point.y - _radiusOfPin * 2 + 3,
                                      _radiusOfPin * 2,
                                      _radiusOfPin * 2);
    }else{
        roundRect = CGRectMake(point.x - _radiusOfPin,
                                      point.y + height - 3,
                                      _radiusOfPin * 2,
                                      _radiusOfPin * 2);
    }

    //画圆
    CGContextAddEllipseInRect(ctx, roundRect);
    [color set];
    CGContextFillPath(ctx);
    
    CGContextMoveToPoint(ctx, point.x, point.y);
    CGContextAddLineToPoint(ctx, point.x, point.y + height - 3);
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
    select.first = self.glyphRangeArray[25];
    select.last = self.glyphRangeArray[25];
    
    select.chatLabel = _textView.chatLabel;
    [_textView addSubview:select];
    
    sender.enabled = NO;
}




@end
