//
//  UIColor+Addition.m
//  JuHuiTuan
//
//  Created by Chenxi Cai on 14-10-29.
//  Copyright (c) 2014年 JuHuiTuan. All rights reserved.
//

#import "UIColor+Addition.h"

@implementation UIColor (Addition)



+ (UIColor *)colorWithHex:(NSString *)hexColor
{
	
	if (hexColor == nil) {
        return nil;
    }
    if ([hexColor length] < 7 ) {
        return nil;
    }
    
    unsigned int red, green, blue;
    NSRange range;
    range.length = 2;
    
    range.location = 1;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&red];
    range.location = 3;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&green];
    range.location = 5;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&blue];
    
    return [UIColor colorWithRed:(float)(red/255.0f) green:(float)(green/255.0f) blue:(float)(blue/255.0f) alpha:1.0f];
	
}

@end
