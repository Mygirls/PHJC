//
//  UILabel+Size.h
//  CallMe
//
//  Created by renpan on 15/6/6.
//  Copyright (c) 2015年 XiZhe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Size)
+ (CGSize)fit_size_with_size:(CGSize)size font:(UIFont*)font text:(NSString*)text lineBreakMode:(NSLineBreakMode)lineBreakMode;
+ (CGSize)fit_size_with_size:(CGSize)size font:(UIFont*)font text:(NSString*)text;
@end
