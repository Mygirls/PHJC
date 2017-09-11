//
//  UIView+CornerRadius.m
//  CallMe
//
//  Created by renpan on 15/5/12.
//  Copyright (c) 2015年 XiZhe. All rights reserved.
//

#import "UIView+CornerRadius.h"

@implementation UIView (CornerRadius)
- (void)addCornerRadiusByRoundingCorners:(UIRectCorner)roundingCorners cornerRadii:(CGSize)cornerRadii
{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:roundingCorners cornerRadii:cornerRadii];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

- (void)addFullCornersWithCornerRadius:(CGFloat)radius borderWidth:(CGFloat)borderWidth borderColor:(UIColor*)borderColor
{
    [self.layer setCornerRadius:radius];
    self.layer.masksToBounds = YES;
    self.layer.borderWidth = borderWidth;
    if(borderColor)
    {
        self.layer.borderColor = [borderColor CGColor];
    }
}
@end
