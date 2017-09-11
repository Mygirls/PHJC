//
//  PHGradientView.m
//  MajqFramework
//
//  Created by JQ on 2017/9/6.
//  Copyright © 2017年 majq. All rights reserved.
//

#import "PHGradientView.h"
#define GradientColor_defalut1 [UIColor colorWithRed:249/255.0 green:138/255.0 blue:83/255.0 alpha:1]
#define GradientColor_defalut2 [UIColor colorWithRed:255/255.0 green:73/255.0 blue:37/255.0 alpha:1]

@implementation PHGradientView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _gradientcolors = @[(__bridge id)GradientColor_defalut1.CGColor,(__bridge id)GradientColor_defalut2.CGColor];
        _startPoint = CGPointMake(0, 0.5);
        _endPoint = CGPointMake(1, 0.5) ;
        
    }
    return self;
}

//MARK: - 设置属性

- (void)setGradientcolors:(NSArray *)gradientcolors {

    _gradientcolors = gradientcolors;
    
}
- (void)setStartPoint:(CGPoint)startPoint
{
    _startPoint = startPoint;
}

- (void)setEndPoint:(CGPoint)endPoint
{
    _endPoint = endPoint;
}


//MARK: - 绘制渐变
- (void)drawGradient {

    /**
     *  1.通过CAGradientLayer 设置渐变的背景。
     */
    CAGradientLayer *layer = [CAGradientLayer new];
    //colors存放渐变的颜色的数组 @[(__bridge id)GradientColor_defalut1.CGColor,(__bridge id)GradientColor_defalut2.CGColor]
    layer.colors = self.gradientcolors;
    /**
     * 起点和终点表示的坐标系位置，(0,0)表示左上角，(1,1)表示右下角
     */
    layer.startPoint = self.startPoint;
    layer.endPoint = self.endPoint;
    layer.frame = self.bounds;
    [self.layer addSublayer:layer];

}


//TODO: 暂时不封装
- (void)drawMultipleColorGradient
{
    
    /**
     *  方法2.CGGradientRef
     */
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGColorSpaceRef colorSpace=CGColorSpaceCreateDeviceRGB();
    /*指定渐变色
     space:颜色空间
     components:颜色数组,注意由于指定了RGB颜色空间，那么四个数组元素表示一个颜色（red、green、blue、alpha），
     如果有三个颜色则这个数组有4*3个元素
     locations:颜色所在位置（范围0~1），这个数组的个数不小于components中存放颜色的个数
     count:渐变个数，等于locations的个数
     */
    CGFloat compoents[12]={
        0,0,0,1,
        0.8,0.1,0.5,1.0,
        1.0,1.0,1.0,1.0
    };

    //设置渐变的位置
    CGFloat locations[3]={0,0.3,1.0};
    //创建梯度上下文
    CGGradientRef gradient= CGGradientCreateWithColorComponents(colorSpace, compoents, locations, 3);

    /*绘制线性渐变
     context:图形上下文
     gradient:渐变色
     startPoint:起始位置
     endPoint:终止位置
     options:绘制方式,kCGGradientDrawsBeforeStartLocation 开始位置之前就进行绘制，到结束位置之后不再绘制，
     kCGGradientDrawsAfterEndLocation开始位置之前不进行绘制，到结束点之后继续填充

     startPoint endPoint 不同与上一种方法，指的是真正的坐标
     */
    CGContextDrawLinearGradient(ctx, gradient, CGPointMake(self.frame.size.width/2, 0), CGPointMake(self.frame.size.width/2,self.frame.size.height), kCGGradientDrawsAfterEndLocation);
    
    //释放颜色空间
    CGColorSpaceRelease(colorSpace);
}



@end
