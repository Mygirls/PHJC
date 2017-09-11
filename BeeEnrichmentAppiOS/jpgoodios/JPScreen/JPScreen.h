//
//  JPScreen.h
//  ShiHang
//
//  Created by renpan on 14/10/20.
//  Copyright (c) 2014年 xizhe. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface JPScreen : NSObject
+ (CGSize)screen_size;
+ (CGFloat)screen_width;
+ (CGFloat)screen_height;
+ (CGRect)screen_bounds;
+ (CGSize)application_size;
+ (CGFloat)application_width;
+ (CGFloat)application_height;
+ (CGRect)application_bounds;

+ (CGFloat)current_screen_width;
+ (CGFloat)current_screen_height;
+ (CGFloat)current_application_width;
+ (CGFloat)current_application_height;

+ (UIWindow*)find_top_window;
@end
