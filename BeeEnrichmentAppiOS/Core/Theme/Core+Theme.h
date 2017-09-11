//
//  Core+Theme.h
//  CarMirrorAppiOS
//
//  Created by renpan on 15/9/17.
//  Copyright (c) 2015年 HangZhouShangFu. All rights reserved.
//

#import "Core.h"

@interface Core (Theme)
- (void)set_default_theme;
- (void)set_theme_with_navigationBar_tabBar: (UINavigationBar *)navigationBar tabBar:(UITabBar *)tabBar navBarColor:(UIColor *)navBarColor;
- (UIColor *)basic_color;
- (UIColor *)basic_disabled_gray_color;
- (UIColor *)basic_blue_color;
- (UIColor *)basic_black_color;
- (UIColor *)basic_red1_color;
- (UIColor *)basic_gray1_color;
- (UIColor *)basic_gray2_line_color;
@end
