//
//  PHGradientView.h
//  MajqFramework
//
//  Created by JQ on 2017/9/6.
//  Copyright © 2017年 majq. All rights reserved.
//

#import "PHBaseView.h"

@interface PHGradientView : UIView

/* The array of CGColorRef objects defining the color of each gradient
 * stop. Defaults to nil. Animatable. */
@property(nonatomic,strong)NSArray *gradientcolors; //渐变颜色 默认为whiteColor

/**
 * 起点和终点表示的坐标系位置，(0,0)表示左上角，(1,1)表示右下角
 */
@property(nonatomic,assign)CGPoint startPoint; //渐变颜色起点,默认为(0, 0.5)
@property(nonatomic,assign)CGPoint endPoint; //渐变颜色终点,默认为(1, 0.5)

/* 绘制 渐变View */
- (void)drawGradient ;



@end
