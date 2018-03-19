//
//  BYChatLabel.m
//
//  Created by maqianli on 2018/3/13.
//  Copyright © 2018年 QDHL. All rights reserved.
//

#import "BYChatLabel.h"
#import "NSAttributedString+AttributedStringHeight.h"

@interface BYChatLabel()

@end

@implementation BYChatLabel

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self != nil){
        [self initProperties];
        [self addObserverForAttributedText];
        [self prepareTextSystem];
    }
    return self;
}
    
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self != nil){
        [self initProperties];
        [self addObserverForAttributedText];
        [self prepareTextSystem];
    }
    return self;
}
    
-(void)initProperties{
    self.numberOfLines = 0;
    self.userInteractionEnabled = YES;    
    
    _touchesBeganLocationMapRange = NSMakeRange(0, 0);
    
    _textStorage = [NSTextStorage new];
    _layoutManager = [NSLayoutManager new];
    _textContainer = [NSTextContainer new];
    
    _textContainer.lineFragmentPadding = 0;
}

-(void)dealloc{
    [self removeObserver:self forKeyPath:@"attributedText"];
}
    
-(void)layoutSubviews{
    [super layoutSubviews];
    //指定绘制文本的区域
//    UITextView *view=[[UITextView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 0)];
//    view.attributedText = self.attributedText;
//    CGSize size=[view sizeThatFits:CGSizeMake(self.bounds.size.width, CGFLOAT_MAX)];
//
//    _textContainer.size = CGSizeMake(self.bounds.size.width, size.height - 16);
    _textContainer.size = self.bounds.size;
}
    
//绘制文本--TextKit接管底层实现，本质上是绘制NSTextStorage中的属性字符串
-(void)drawTextInRect:(CGRect)rect{
    NSRange range = NSMakeRange(0, _textStorage.length);
    
    //绘制背景颜色
    [_layoutManager drawBackgroundForGlyphRange:range atPoint:CGPointZero];
    
    //绘制glyphs
    [_layoutManager drawGlyphsForGlyphRange:range atPoint:CGPointZero];
}
    
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //先获取最后一个字符的位置
    CGRect lastCharFrame = [self characterRectAtIndex:_textStorage.length - 1];
    
    CGPoint point = [touches.anyObject locationInView:self];
    //触摸点是否有效
    CGFloat maxX = lastCharFrame.origin.x + lastCharFrame.size.width;
    CGFloat maxY = lastCharFrame.origin.y + lastCharFrame.size.height;
    if(point.y > maxY){
        return;
    }else if (point.x > maxX && point.y > lastCharFrame.origin.y){
        return;
    }
    
    NSUInteger index = [_layoutManager glyphIndexForPoint:point inTextContainer:_textContainer fractionOfDistanceThroughGlyph:nil];
    
    NSArray *ranges = [[[self urlRanges]arrayByAddingObjectsFromArray:[self phoneNumberRanges]]arrayByAddingObjectsFromArray:[self emailRanges]];
    
    for (NSDictionary *item in ranges) {
        CGFloat location = ((NSNumber*)[item objectForKey:@"location"]).floatValue;
        CGFloat length = ((NSNumber*)[item objectForKey:@"length"]).floatValue;
        NSRange range = NSMakeRange(location, length);
        
        if(NSLocationInRange(index, range)){
            [_textStorage addAttributes:@{NSForegroundColorAttributeName : UIColor.redColor} range:range];
            [self setNeedsDisplay];
            
            _touchesBeganLocationMapRange = range;
        }
    }
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if(NSEqualRanges(_touchesBeganLocationMapRange, NSMakeRange(0, 0))){
        return;
    }
    
    //先恢复touchesBeganLocationMapRange显示状态
    [_textStorage addAttributes:@{NSForegroundColorAttributeName : UIColor.blueColor} range:_touchesBeganLocationMapRange];
    [self setNeedsDisplay];
    
    //获取点击点击对应索引
    CGPoint point = [touches.anyObject locationInView:self];
    NSUInteger index = [_layoutManager glyphIndexForPoint:point inTextContainer:_textContainer fractionOfDistanceThroughGlyph:nil];
    
    //判断是否url的点击
    NSArray *urlRanges = [self urlRanges];
    NSString *urlString = [self getValidClicedWithIndex:index ranges:urlRanges];
    if (urlString) {
        [self clickedType:BYURLClickedTypeOnChatLabel string:urlString];
    }
    
    //判断是否电话号码的点击
    NSArray *phoneNumberRanges = [self phoneNumberRanges];
    NSString *phoneNumberString = [self getValidClicedWithIndex:index ranges:phoneNumberRanges];
    if (phoneNumberString) {
        [self clickedType:BYPhoneNumClickedTypeOnChatLabel string:phoneNumberString];
    }
    
    //判断是否邮箱地址的点击
    NSArray *emailRanges = [self emailRanges];
    NSString *emailString = [self getValidClicedWithIndex:index ranges:emailRanges];
    if (emailString) {
        [self clickedType:BYEmailClickedTypeOnChatLabel string:emailString];
    }

    //最后恢复_touchesBeganLocationMapRange
    _touchesBeganLocationMapRange = NSMakeRange(0, 0);
}

//获取有效点击字符串
-(NSString*)getValidClicedWithIndex:(NSInteger)index ranges:(NSArray*)ranges {
    NSString *result = nil;
    
    for (NSDictionary *item in ranges) {
        CGFloat location = ((NSNumber*)[item objectForKey:@"location"]).floatValue;
        CGFloat length = ((NSNumber*)[item objectForKey:@"length"]).floatValue;
        NSRange range = NSMakeRange(location, length);
        
        if(NSLocationInRange(index, range)){
            if(NSEqualRanges(_touchesBeganLocationMapRange, range)){
                result = [_textStorage attributedSubstringFromRange:range].string;
            }
        }
    }
    
    return  result;
}

//处理有效点击
-(void)clickedType:(BYClickedTypeOnChatLabel)type string:(NSString*)string {
    switch (type) {
        case BYURLClickedTypeOnChatLabel:
            NSLog(@"您点击了url链接=%@", string);
            break;
        case BYPhoneNumClickedTypeOnChatLabel:
            NSLog(@"您点击了电话号码=%@", string);
            break;
        case BYEmailClickedTypeOnChatLabel:
            NSLog(@"您点击了邮箱地址=%@", string);
            break;
            
        default:
            break;
    }
}

//获取指定字形的位置范围
- (CGRect)characterRectAtIndex:(NSUInteger)charIndex
{
    if (charIndex >= _textStorage.length) {
        return CGRectZero;
    }
    NSRange characterRange = NSMakeRange(charIndex, 1);
    NSRange glyphRange = [self.layoutManager glyphRangeForCharacterRange:characterRange actualCharacterRange:nil];
    return [self.layoutManager boundingRectForGlyphRange:glyphRange inTextContainer:self.textContainer];
}
    
 #pragma mark -- 观察attributedText变化
-(void)addObserverForAttributedText{
    [self addObserver:self forKeyPath:@"attributedText" options:NSKeyValueObservingOptionNew context:nil];
}
     
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:@"attributedText"]){
        [self prepareTextContent];
    }
}
    
#pragma mark -- 设置TextKit核心对象
//准备文本系统
-(void)prepareTextSystem {
    //准备文本内容
    [self prepareTextContent];
    
    //设置对象关系
    [_textStorage addLayoutManager:_layoutManager];
    [_layoutManager addTextContainer:_textContainer];
}
    
//准备文本内容
-(void)prepareTextContent {
    if(self.attributedText != nil){
        [_textStorage setAttributedString:self.attributedText];
    }else if(self.text != nil){
        NSAttributedString *attributedString = [[NSAttributedString alloc]initWithString:self.text];
        [_textStorage setAttributedString:attributedString];
    }else{
        NSAttributedString *attributedString = [[NSAttributedString alloc]initWithString:@""];
        [_textStorage setAttributedString:attributedString];
    }
    
    //设置URL、电话、邮箱颜色及背景颜色
    NSArray *ranges = [[[self urlRanges] arrayByAddingObjectsFromArray:[self phoneNumberRanges]] arrayByAddingObjectsFromArray:[self emailRanges]];
    
    for (NSDictionary *item in ranges) {
        CGFloat location = ((NSNumber*)[item objectForKey:@"location"]).floatValue;
        CGFloat length = ((NSNumber*)[item objectForKey:@"length"]).floatValue;
        NSRange range = NSMakeRange(location, length);
        
        [_textStorage addAttributes:@{NSForegroundColorAttributeName : UIColor.blueColor} range:range];
    }
}
    
#pragma mark -- 正则表达式处理
//根据正则表达式获取网址范围数组
-(NSArray*)urlRanges {
    //设置正则表达式
    NSString *pattern = @"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)";
    NSRegularExpression *regx = [[NSRegularExpression alloc]initWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
    
    //匹配所有项
    NSRange range = NSMakeRange(0, _textStorage.string.length);
    NSArray *matches = [regx matchesInString:_textStorage.string options:NSMatchingReportProgress range:range];
    
    //遍历所有适配结果
    NSMutableArray *ranges = [NSMutableArray array];
    
    for (NSTextCheckingResult *item in matches) {
        NSRange range = item.range;
        [ranges addObject:@{@"location": [NSNumber numberWithFloat:range.location], @"length":[NSNumber numberWithFloat:range.length]}];
    }
    
    return ranges;
}

//根据正则表达式获取手机号码范围数组
-(NSArray*)phoneNumberRanges {
    //设置正则表达式
    NSString *pattern = @"\\d{3,4}[- ]?\\d{7,8}";
    NSRegularExpression *regx = [[NSRegularExpression alloc]initWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
    
    //匹配所有项
    NSRange range = NSMakeRange(0, _textStorage.string.length);
    NSArray *matches = [regx matchesInString:_textStorage.string options:NSMatchingReportProgress range:range];
    
    //遍历所有适配结果
    NSMutableArray *ranges = [NSMutableArray array];
    
    for (NSTextCheckingResult *item in matches) {
        NSRange range = item.range;
        [ranges addObject:@{@"location": [NSNumber numberWithFloat:range.location], @"length":[NSNumber numberWithFloat:range.length]}];
    }
    
    return ranges;
}

//根据正则表达式获取email范围数组
-(NSArray*)emailRanges {
    //设置正则表达式
    NSString *pattern = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSRegularExpression *regx = [[NSRegularExpression alloc]initWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
    
    //匹配所有项
    NSRange range = NSMakeRange(0, _textStorage.string.length);
    NSArray *matches = [regx matchesInString:_textStorage.string options:NSMatchingReportProgress range:range];
    
    //遍历所有适配结果
    NSMutableArray *ranges = [NSMutableArray array];
    
    for (NSTextCheckingResult *item in matches) {
        NSRange range = item.range;
        [ranges addObject:@{@"location": [NSNumber numberWithFloat:range.location], @"length":[NSNumber numberWithFloat:range.length]}];
    }
    
    return ranges;
}

@end

























