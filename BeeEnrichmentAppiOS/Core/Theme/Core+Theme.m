//
//  Core+Theme.m
//  CarMirrorAppiOS
//
//  Created by renpan on 15/9/17.
//  Copyright (c) 2015年 HangZhouShangFu. All rights reserved.
//

#import "Core+Theme.h"

@implementation Core (Theme)
- (void)set_default_theme
{
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} forState:UIControlStateNormal];
    [[UINavigationBar appearance] setTitleTextAttributes:@{
                                                           NSForegroundColorAttributeName:[self basic_black_color],
                                                           NSFontAttributeName:[UIFont systemFontOfSize:16]}];
    
    
    
    
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:0.29 green:0.29 blue:0.29 alpha:1]];
    [[UINavigationBar appearance] setBackgroundImage:[UIColor image_with_color:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:0.29 green:0.29 blue:0.29 alpha:1]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:0.29 green:0.29 blue:0.29 alpha:1]}];
    [[UINavigationBar appearance] setTranslucent:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
}

- (void)set_theme_with_navigationBar_tabBar: (UINavigationBar *)navigationBar tabBar:(UITabBar *)tabBar navBarColor:(UIColor *)navBarColor
{

    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} forState:UIControlStateNormal];
    [[UINavigationBar appearance] setTitleTextAttributes:@{
                                                           NSForegroundColorAttributeName:[CMCore basic_black_color],
                                                           NSFontAttributeName:[UIFont systemFontOfSize:16]}];
    [navigationBar setTintColor:[UIColor colorWithRed:0.29 green:0.29 blue:0.29 alpha:1]];
    [navigationBar setBackgroundImage:[UIColor image_with_color:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
    [navigationBar setShadowImage:[UIColor image_with_color:navBarColor]];
    [navigationBar setTranslucent:NO];

    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:@"#f95f53"],NSFontAttributeName:[UIFont systemFontOfSize:11]} forState:UIControlStateSelected];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:@"#676767"],NSFontAttributeName:[UIFont systemFontOfSize:11]} forState:UIControlStateNormal];
    [tabBar setTintColor:[UIColor colorWithRed:0.29 green:0.29 blue:0.29 alpha:1]];
    [tabBar setBackgroundImage:[UIColor image_with_color:[UIColor whiteColor] ] ];
    [tabBar setShadowImage:[UIColor image_with_color:navBarColor] ];
    [tabBar setTranslucent:NO];
}

- (UIColor*)basic_color
{
    return [UIColor colorWithRed:0.97 green:0.32 blue:0.21 alpha:1];
}
- (UIColor *)basic_disabled_gray_color
{
    return [UIColor colorWithRed:0.83 green:0.83 blue:0.84 alpha:1];
}
- (UIColor *)basic_blue_color {
    return [UIColor colorWithRed:0.56 green:0.78 blue:0.97 alpha:1];
}
- (UIColor *)basic_black_color {
    return [UIColor colorWithRed:0.21 green:0.21 blue:0.21 alpha:1];
}
- (UIColor *)basic_red1_color {// 249 95 83
    return [UIColor colorWithHex:@"#F95F53"];
}
- (UIColor *)basic_gray1_color { // 103 103 103
    return [UIColor colorWithHex:@"#676767"];
}
- (UIColor *)basic_gray2_line_color { // 225 225 225
    return [UIColor colorWithHex:@"#E1E1E1"];
}


@end
