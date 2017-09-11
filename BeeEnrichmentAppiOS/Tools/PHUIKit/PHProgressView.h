//
//  PHProgressView.h
//  MajqFramework
//
//  Created by JQ on 2017/9/6.
//  Copyright © 2017年 majq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PHGradientView.h"

/* 进度条类型 */
typedef enum : NSUInteger {
    ProgressViewAllGradient,    //整个进度条都是渐变的
    ProgressViewNotAllGradient, //currentThumbImg 后面不是渐变的
    
} PHProgressViewType;

@interface PHProgressView : UIView

@property(nonatomic,assign)CGFloat progressPercentage;

@property(nonatomic,assign)CGFloat progressHeight;

@property(nonatomic,assign)UIImage *currentThumbImg;

/* The array of CGColorRef objects defining the color of each gradient
 * stop. Defaults to nil. Animatable. */
@property(nonatomic,strong)NSArray *progressColors;


@property(nonatomic,assign)PHProgressViewType progressViewType;

/* 显示进度条 */
- (void)progressShow;

@end
