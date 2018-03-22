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

typedef enum : NSUInteger {
    NoneMovingType,
    FirstPinMovingType,
    LastPinMovingType,
} MovingTypeOnSelectedView;

@interface SelectedView : UIView

//起点、终点项
@property (nonatomic, strong) CTRunItem *first;
@property (nonatomic, strong) CTRunItem *last;
//所有项数组
@property (nonatomic, strong) NSMutableArray *glyphRangeArray;

@property (nonatomic, strong) BYChatLabel *chatLabel;

//大头针半径
@property CGFloat radiusOfPin;

//标记移动类型
@property MovingTypeOnSelectedView movingType;

@end

@implementation SelectedView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.opaque = NO;
        
        _radiusOfPin = 5.0;
        _movingType = NoneMovingType;
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
        _movingType = FirstPinMovingType;
    }
    
    CGPoint lastPoint = [self.layer convertPoint:self.last.rect.origin fromLayer:_chatLabel.layer];
    CGRect lastRect = CGRectMake(lastPoint.x + self.last.rect.size.width  - _radiusOfPin,
                                 lastPoint.y,
                                 _radiusOfPin * 2,
                                 self.last.rect.size.height + _radiusOfPin * 2);
    if (CGRectContainsPoint(lastRect, point)) {
        NSLog(@"呵呵，你摸到了右边大头针");
        _movingType = LastPinMovingType;
    }
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (_movingType != NoneMovingType) {
        //获取开始位置
        CGPoint point = [touches.anyObject locationInView:self];

        //将point转为chatLabel中的点
        CGPoint pointInChatLabel = [_chatLabel.layer convertPoint:point fromLayer:self.layer];
        
        //入股pointInChatLabel在chatLabel内，则找到对应的CTRunItem
        if([_chatLabel.layer containsPoint:pointInChatLabel]){
            //获取pointInChatLabel对应的CTRunItem
            CTRunItem *item = nil;
            for (CTRunItem *temp in _glyphRangeArray) {
                if (CGRectContainsPoint(temp.rect, pointInChatLabel)) {
                    item = temp;
                    break;
                }
            }
            
            //对chatLabel的最后一行中的空白特殊处理
            if (item == nil) {
                item = _glyphRangeArray.lastObject;
            }
            
            //重新赋值first、last
            if (_movingType == FirstPinMovingType) {
                //判断item在数组中的索引，是否小于等于last在数组中的索引
                NSInteger itemIndex = [_glyphRangeArray indexOfObjectIdenticalTo:item];
                NSInteger lastIndex = [_glyphRangeArray indexOfObjectIdenticalTo:_last];
                if (itemIndex <= lastIndex) {
                    _first = item;
                    [self setNeedsDisplay];
                }
            }
            
            if (_movingType == LastPinMovingType) {
                //判断item在数组中的索引，是否大于等于first在数组中的索引
                NSInteger itemIndex = [_glyphRangeArray indexOfObjectIdenticalTo:item];
                NSInteger firstIndex = [_glyphRangeArray indexOfObjectIdenticalTo:_first];
                if (itemIndex >= firstIndex) {
                    _last = item;
                    [self setNeedsDisplay];
                }
            }
        }

    }
    
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    //恢复初始状态
    _movingType = NoneMovingType;
    
}

-(void)drawSelectedBG{
    //先恢复默认背景
    NSRange allRange = NSMakeRange(0, _chatLabel.attributedText.length);
    UIColor *defColor = [UIColor whiteColor];
    
    [_chatLabel.textStorage addAttributes:@{NSBackgroundColorAttributeName : defColor} range:allRange];
    [_chatLabel setNeedsDisplay];
    
    //在设置选中背景
    NSRange substringRange = NSMakeRange(_first.substringRange.location, _last.substringRange.location + _last.substringRange.length - _first.substringRange.location);
    UIColor *backColor = [UIColor colorWithRed:0.0 green:84.0 / 255.0 blue:166.0 / 255.0 alpha:0.2];

    [_chatLabel.textStorage addAttributes:@{NSBackgroundColorAttributeName : backColor} range:substringRange];
    [_chatLabel setNeedsDisplay];
    
    //输出处于选中的字符串
    NSString *subString = [_chatLabel.attributedText.string substringWithRange:substringRange];
    NSLog(@"%@",subString);
}

-(void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    
    //先绘制选中背景
    [self drawSelectedBG];
    
    //在绘制起始大头针
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    //将origin从标签坐标系转到自己坐标系
    CGPoint firstPoint = [self.layer convertPoint:self.first.rect.origin fromLayer:_chatLabel.layer];
    [self updatePinLayer:ctx point:firstPoint lineHeight:_chatLabel.font.lineHeight isLeft:true];
    
    CGPoint lastPoint = [self.layer convertPoint:self.last.rect.origin fromLayer:_chatLabel.layer];
    lastPoint.x = lastPoint.x + self.last.rect.size.width;
    [self updatePinLayer:ctx point:lastPoint lineHeight:_chatLabel.font.lineHeight isLeft:false];
    
}

- (void)updatePinLayer:(CGContextRef)ctx point:(CGPoint)point lineHeight:(CGFloat)height isLeft:(BOOL)isLeft {
    UIColor *color = [UIColor colorWithRed:0/255.0 green:128/255.0 blue:255/255.0 alpha:1.0];
    CGRect roundRect = CGRectZero;
    if (isLeft) {
        roundRect = CGRectMake(point.x - _radiusOfPin,
                                      point.y - _radiusOfPin * 2,
                                      _radiusOfPin * 2,
                                      _radiusOfPin * 2);
    }else{
        roundRect = CGRectMake(point.x - _radiusOfPin,
                                      point.y + height,
                                      _radiusOfPin * 2,
                                      _radiusOfPin * 2);
    }

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
    _m.text = @"    改变hr@163.com世界创造价值😱由于子视图是用自动布局的由于https://www.baidu❤️.com子视图是用自动布局的由于子视图是用自动布局的由于子视图是用自动布局的由于子视图是用自动布局的子视图不会自我调整021-54377032的要更新他们的约束me@163.com❤️";
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
//        UIColor *backColor = [UIColor colorWithRed:0.0 green:84.0 / 255.0 blue:166.0 / 255.0 alpha:0.2];
//        [_textView.chatLabel.textStorage addAttributes:@{NSBackgroundColorAttributeName : backColor} range:item.substringRange];
//        [_textView.chatLabel setNeedsDisplay];
        
        item.rect = [_textView.chatLabel characterRectAtIndex:item.substringRange.location];
        NSLog(@"%f,%f, %f, %f", item.rect.origin.x, item.rect.origin.y, item.rect.size.width, item.rect.size.height);
    }
    
    //添加选中视图
    SelectedView *select = [SelectedView new];
    //select.backgroundColor = UIColor.greenColor;
    select.glyphRangeArray = self.glyphRangeArray;
    select.first = self.glyphRangeArray.firstObject;
    select.last = self.glyphRangeArray.lastObject;
    select.chatLabel = _textView.chatLabel;
    
    select.frame = _textView.bounds;
    [_textView addSubview:select];
    
    sender.enabled = NO;
}




@end
