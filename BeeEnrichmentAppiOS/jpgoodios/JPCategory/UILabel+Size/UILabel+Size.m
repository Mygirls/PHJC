//
//  UILabel+Size.m
//  CallMe
//
//  Created by renpan on 15/6/6.
//  Copyright (c) 2015年 XiZhe. All rights reserved.
//

#import "UILabel+Size.h"

@implementation UILabel (Size)
+ (CGSize)fit_size_with_size:(CGSize)size font:(UIFont*)font text:(NSString*)text lineBreakMode:(NSLineBreakMode)lineBreakMode
{
    CGSize ret;
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    label.font = font;
    label.numberOfLines = 0;
    label.lineBreakMode = lineBreakMode;
    label.text = text;
    [label sizeToFit];
    ret = label.frame.size;
    return ret;
}

+ (CGSize)fit_size_with_size:(CGSize)size font:(UIFont*)font text:(NSString*)text
{
    return [self fit_size_with_size:size font:font text:text lineBreakMode:NSLineBreakByTruncatingTail];
}
@end
