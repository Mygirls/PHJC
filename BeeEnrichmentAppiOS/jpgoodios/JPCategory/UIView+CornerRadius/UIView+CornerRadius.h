//
//  UIView+CornerRadius.h
//  CallMe
//
//  Created by renpan on 15/5/12.
//  Copyright (c) 2015年 XiZhe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (CornerRadius)
- (void)addCornerRadiusByRoundingCorners:(UIRectCorner)roundingCorners cornerRadii:(CGSize)cornerRadii;
- (void)addFullCornersWithCornerRadius:(CGFloat)radius borderWidth:(CGFloat)borderWidth borderColor:(UIColor*)borderColor;
@end
