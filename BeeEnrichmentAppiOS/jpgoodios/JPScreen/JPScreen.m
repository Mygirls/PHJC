//
//  JPScreen.m
//  ShiHang
//
//  Created by renpan on 14/10/20.
//  Copyright (c) 2014年 xizhe. All rights reserved.
//

#import "JPScreen.h"
#import "JPDevice.h"

@implementation JPScreen

+ (CGSize)screen_size
{
    return [[UIScreen mainScreen] bounds].size;
}

+ (CGFloat)screen_width
{
    return [[UIScreen mainScreen] bounds].size.width;
}

+ (CGFloat)screen_height
{
    return [[UIScreen mainScreen] bounds].size.height;
}

+ (CGRect)screen_bounds
{
    return CGRectMake(0, 0, [self screen_width], [self screen_height]);
}

+ (CGSize)application_size
{
    return [[UIScreen mainScreen] applicationFrame].size;
}

+ (CGFloat)application_width
{
    return [[UIScreen mainScreen] applicationFrame].size.width;
}

+ (CGFloat)application_height
{
    return [[UIScreen mainScreen] applicationFrame].size.height;
}

+ (CGRect)application_bounds
{
    return CGRectMake(0, 0, [self application_width], [self application_height]);
}

+ (CGFloat)current_screen_width
{
    if([JPDeviceCurrent is_greater_than_or_equal:JP_IOS8])
    {
        return [self screen_width];
    }
    else
    {
        if(UIInterfaceOrientationIsLandscape([JPDeviceCurrent current_orientation]))
        {
            return [self screen_height];
        }
        else
        {
            return [self screen_width];
        }
    }
}

+ (CGFloat)current_screen_height
{
    if([JPDeviceCurrent is_greater_than_or_equal:JP_IOS8])
    {
        return [self screen_height];
    }
    else
    {
        if(UIInterfaceOrientationIsLandscape([JPDeviceCurrent current_orientation]))
        {
            return [self screen_width];
        }
        else
        {
            return [self screen_height];
        }
    }
}

+ (CGFloat)current_application_width
{
    if([JPDeviceCurrent is_greater_than_or_equal:JP_IOS8])
    {
        return [self application_width];
    }
    else
    {
        if(UIInterfaceOrientationIsLandscape([JPDeviceCurrent current_orientation]))
        {
            return [self application_height];
        }
        else
        {
            return [self application_width];
        }
    }
}

+ (CGFloat)current_application_height
{
    if([JPDeviceCurrent is_greater_than_or_equal:JP_IOS8])
    {
        return [self application_height];
    }
    else
    {
        if(UIInterfaceOrientationIsLandscape([JPDeviceCurrent current_orientation]))
        {
            return [self application_width];
        }
        else
        {
            return [self application_height];
        }
    }
}

+ (UIWindow*)find_top_window
{
    NSEnumerator *frontToBackWindows = [UIApplication.sharedApplication.windows reverseObjectEnumerator];
    for (UIWindow *window in frontToBackWindows){
        BOOL windowOnMainScreen = window.screen == UIScreen.mainScreen;
        BOOL windowIsVisible = !window.hidden && window.alpha > 0;
        BOOL windowLevelNormal = window.windowLevel == UIWindowLevelNormal;
        
        if (windowOnMainScreen && windowIsVisible && windowLevelNormal) {
            return window;
        }
    }
    return nil;
}
@end
