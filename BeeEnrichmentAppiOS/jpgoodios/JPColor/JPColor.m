//
//  JPColor.m
//  ShiHang
//
//  Created by renpan on 14/11/3.
//  Copyright (c) 2014年 xizhe. All rights reserved.
//

#import "JPColor.h"

@implementation JPColor

@end

@implementation UIColor (JPColor)

+ (UIImage *)image_with_color:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end