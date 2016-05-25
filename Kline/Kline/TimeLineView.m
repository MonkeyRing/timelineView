//
//  TimeLineView.m
//  Kline
//
//  Created by FundSmart IOS on 16/5/24.
//  Copyright © 2016年 黄海龙. All rights reserved.
//

#import "TimeLineView.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreGraphics/CoreGraphics.h>


typedef enum tagBorderType
{
    BorderTypeDashed,
    BorderTypeSolid
}BorderType;

@interface TimeLineView ()
{
    CAShapeLayer *_shapeLayer;
    
    BorderType _borderType;
    CGFloat _cornerRadius;
    CGFloat _borderWidth;
    NSUInteger _dashPattern;
    NSUInteger _spacePattern;
    UIColor *_borderColor;
}

@property(strong,nonatomic) TimeLineModel *times;

@end

@implementation TimeLineView


-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        self.userInteractionEnabled = YES;
    }
    return self;
}



- (void)drawRect:(CGRect)rect {
    [self drawPriceLine];
    [self drawAvgLine];
    [self drawVol];
}


-(void)drawGridBackgroundView:(CGContextRef)ctx andRect:(CGRect)rect
{
    //设置矩形填充颜色：红色
    CGContextSetRGBFillColor(ctx, 255, 255, 255, 1.0);
    //填充矩形
    CGContextFillRect(ctx, rect);
    //设置画笔颜色：黑色
    CGContextSetRGBStrokeColor(ctx, 0, 0, 0, 1);
    //设置画笔线条粗细
    CGContextSetLineWidth(ctx, 1.0);
    //画矩形边框
    CGContextAddRect(ctx,rect);
    
}


-(void)drawPriceLine{
    
    CGFloat hightRadio = 140/(self.timelines.high.floatValue  - self.timelines.low.floatValue);
    CGFloat x = 0;
    CGFloat priceY = 0;
    
    UIBezierPath *aPath = [UIBezierPath bezierPath];
    
    for(int i = 0 ; i < self.timelines.price.count;i++){
        //        x = (i + 2)* self.timelines.price.count / (UIScreen.mainScreen.bounds.size.width - 10);
        
        UIColor *color = [UIColor colorWithRed:0/255 green:153.0/255.0 blue:102.0/255.0 alpha:1];
        [color set];  //设置线条颜色
        aPath.lineWidth = 1;
        aPath.lineCapStyle = kCGLineCapRound;  //线条拐角
        aPath.lineJoinStyle = kCGLineCapRound;  //终点处理
        priceY = ((self.timelines.high.floatValue) - [self.timelines.price[i] doubleValue]) * hightRadio;
        if (i == 0) {
            [aPath moveToPoint:CGPointMake(x,priceY)];
        }else{
            [aPath addLineToPoint:CGPointMake(x, priceY)];
        }
        x = x + 1.48;
    }
    [aPath stroke]; //Draws line 根据坐标点连线
}


-(void)drawAvgLine{
    
    CGFloat hightRadio = 140/(self.timelines.high.floatValue - self.timelines.low.floatValue);
    CGFloat x = 0;
    CGFloat priceY = 0;
    
    UIBezierPath *aPath = [UIBezierPath bezierPath];
    for(int i = 0 ; i < self.timelines.avg.count;i++){
        UIColor *color = [UIColor redColor];
        [color set];  //设置线条颜色
        aPath.lineWidth = 1;
        aPath.lineCapStyle = kCGLineCapRound;  //线条拐角
        aPath.lineJoinStyle = kCGLineCapRound;  //终点处理
        priceY = (self.timelines.high.floatValue - [self.timelines.avg[i] doubleValue]) * hightRadio;
        if (i == 0) {
            [aPath moveToPoint:CGPointMake(x,priceY)];
        }else{
            [aPath addLineToPoint:CGPointMake(x, priceY)];
        }
        
        x = x + 1.48;
    }
    [aPath stroke]; //Draws line 根据坐标点连线
}



-(void)drawVol  {
    
    
    CGFloat maxValue = 0;
    CGFloat minValue = MAXFLOAT;
    
    // 找出成交量最大值最小值
    for (int i = 0; i < self.timelines.vol.count;i++){
        
        if (maxValue < [self.timelines.vol[i] doubleValue]) {
            maxValue = [self.timelines.vol[i] doubleValue];
        }else if (minValue > [self.timelines.vol[i] doubleValue]){
            minValue = [self.timelines.vol[i] doubleValue];
        }else{
            
        }
    }

    CGFloat hightRadio = 50/(maxValue - minValue);

    CGFloat volY = 0;
    CGFloat x = 0;
    CGFloat margin = 1;
    CGFloat h = 0;
    CGFloat w = 1;
    
    UIBezierPath *path ;
    for (int i = 0; i < self.timelines.vol.count; i++) {
        
        h = [self.timelines.vol[i] doubleValue] * hightRadio;
        volY = 200-h;
        path = [UIBezierPath bezierPathWithRect:CGRectMake(x, volY, w, h)];
        [[UIColor colorWithRed:124.0/255.0 green:181.0/255.0 blue:236.0/255.0 alpha:1] setFill];
        [path fillWithBlendMode:kCGBlendModeNormal alpha:1];
        x = x + w + margin;
    }
    [path stroke];
    
    
    UIBezierPath *dashPath = [UIBezierPath bezierPath];
    [dashPath moveToPoint:CGPointMake(0, 120)];
    [dashPath addLineToPoint:CGPointMake(self.frame.size.width, 120)];
    CGFloat dash[] = {2,2};
    [dashPath setLineDash:dash count:2 phase:0];//!!!
    [[UIColor lightGrayColor] setStroke];
    [dashPath stroke];
}


-(void)setTimelines:(TimeLineModel *)timelines{
    
    _timelines = timelines;
    [self setNeedsDisplay];
}


-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSSet *allTouches = [event allTouches];    //返回与当前接收者有关的所有的触摸对象
    UITouch *touch = [allTouches anyObject];   //视图中的所有对象
    CGPoint point = [touch locationInView:[touch view]]; //返回触摸点在视图中的当前坐标
    
//    CGContextSetStrokeColorWithColor(context,color.CGColor);
//    CGContextSetLineWidth(context, lineWidth);
//    CGContextBeginPath(context);
//    CGContextMoveToPoint(context, point.x, self.contentTop);
//    CGContextAddLineToPoint(context, point.x, self.contentBottom);
//    CGContextStrokePath(context);
//    
//    
//    CGContextBeginPath(context);
//    CGContextMoveToPoint(context, self.contentLeft, point.y);
//    CGContextAddLineToPoint(context, self.contentRight, point.y);
//    CGContextStrokePath(context);

}

@end
