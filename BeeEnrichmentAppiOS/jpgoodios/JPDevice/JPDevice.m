//
//  JPDevice.m
//  ShiHang
//
//  Created by renpan on 14/10/17.
//  Copyright (c) 2014年 xizhe. All rights reserved.
//

#import "JPDevice.h"
#import <sys/utsname.h>

#define CurrentDevice       [UIDevice currentDevice]

@interface JPDevice ()
@property (nonatomic, strong) NSDictionary* device_info;
@end

@implementation JPDevice
ShareInstanceDefine

- (void)init_data
{
    [super init_data];
    
    _device_info = @{
                     //iPhones
                     @"iPhone3,1": @{@"type":@(iPhone4), @"name":@"iPhone4"},
                     @"iPhone3,2": @{@"type":@(iPhone4), @"name":@"iPhone4"},
                     @"iPhone3,3": @{@"type":@(iPhone4), @"name":@"iPhone4"},
                     @"iPhone4,1": @{@"type":@(iPhone4S), @"name":@"iPhone4S"},
                     @"iPhone4,2": @{@"type":@(iPhone4S), @"name":@"iPhone4S"},
                     @"iPhone4,3": @{@"type":@(iPhone4S), @"name":@"iPhone4S"},
                     @"iPhone5,1": @{@"type":@(iPhone5), @"name":@"iPhone5"},
                     @"iPhone5,2": @{@"type":@(iPhone5), @"name":@"iPhone5"},
                     @"iPhone5,3": @{@"type":@(iPhone5C), @"name":@"iPhone5C"},
                     @"iPhone5,4": @{@"type":@(iPhone5C), @"name":@"iPhone5C"},
                     @"iPhone6,1": @{@"type":@(iPhone5S), @"name":@"iPhone5S"},
                     @"iPhone6,2": @{@"type":@(iPhone5S), @"name":@"iPhone5S"},
                     @"iPhone7,2": @{@"type":@(iPhone6), @"name":@"iPhone6"},
                     @"iPhone7,1": @{@"type":@(iPhone6Plus), @"name":@"iPhone6Plus"},
                     @"i386"     : @{@"type":@(Simulator), @"name":@"Simulator"},
                     @"x86_64"   : @{@"type":@(Simulator), @"name":@"Simulator"},
                     //iPads
                     @"iPad1,1": @{@"type":@(iPad1), @"name":@"iPad1"},
                     @"iPad2,1": @{@"type":@(iPad2), @"name":@"iPad2"},
                     @"iPad2,2": @{@"type":@(iPad2), @"name":@"iPad2"},
                     @"iPad2,3": @{@"type":@(iPad2), @"name":@"iPad2"},
                     @"iPad2,4": @{@"type":@(iPad2), @"name":@"iPad2"},
                     @"iPad2,5": @{@"type":@(iPadMini), @"name":@"iPadMini"},
                     @"iPad2,6": @{@"type":@(iPadMini), @"name":@"iPadMini"},
                     @"iPad2,7": @{@"type":@(iPadMini), @"name":@"iPadMini"},
                     @"iPad3,1": @{@"type":@(iPad3), @"name":@"iPad3"},
                     @"iPad3,2": @{@"type":@(iPad3), @"name":@"iPad3"},
                     @"iPad3,3": @{@"type":@(iPad3), @"name":@"iPad3"},
                     @"iPad3,4": @{@"type":@(iPad4), @"name":@"iPad4"},
                     @"iPad3,5": @{@"type":@(iPad4), @"name":@"iPad4"},
                     @"iPad3,6": @{@"type":@(iPad4), @"name":@"iPad4"},
                     @"iPad4,1": @{@"type":@(iPadAir), @"name":@"iPadAir"},
                     @"iPad4,2": @{@"type":@(iPadAir), @"name":@"iPadAir"},
                     @"iPad4,3": @{@"type":@(iPadAir), @"name":@"iPadAir"},
                     @"iPad4,4": @{@"type":@(iPadMini2), @"name":@"iPadMini2"},
                     @"iPad4,5": @{@"type":@(iPadMini2), @"name":@"iPadMini2"},
                     @"iPad4,6": @{@"type":@(iPadMini2), @"name":@"iPadMini2"},
                     @"iPad4,7": @{@"type":@(iPadMini3), @"name":@"iPadMini3"},
                     @"iPad4,8": @{@"type":@(iPadMini3), @"name":@"iPadMini3"},
                     @"iPad4,9": @{@"type":@(iPadMini3), @"name":@"iPadMini3"},
                     @"iPad5,3": @{@"type":@(iPadAir2), @"name":@"iPadAir2"},
                     @"iPad5,4": @{@"type":@(iPadAir2), @"name":@"iPadAir2"},
                     };
}

- (BOOL)is_ipad
{
    if(CurrentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPad)
    {
        return YES;
    }
    return NO;
}

- (BOOL)is_iphone
{
    if(CurrentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPhone)
    {
        return YES;
    }
    return NO;
}

- (NSString*)my_name
{
    return CurrentDevice.name;
}

- (NSString*)system_name
{
    return CurrentDevice.systemName;
}

- (NSString*)model
{
    return CurrentDevice.model;
}

- (NSString*)localizedModel
{
    return CurrentDevice.localizedModel;
}

- (NSString*)ios_version
{
    return CurrentDevice.systemVersion;
}

- (BOOL)is_greater_than_or_equal:(CGFloat)ios_version
{
    NSString* version = [self ios_version];
    if (version.doubleValue >= ios_version)
    {
        return YES;
    }
    return NO;
}

- (BOOL)is_less_than_or_equal:(CGFloat)ios_version
{
    NSString* version = [self ios_version];
    if (version.doubleValue <= ios_version)
    {
        return YES;
    }
    return NO;
}

- (BOOL)is_ios8
{
    if([self is_greater_than_or_equal:JP_IOS8])
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (UIInterfaceOrientation)current_orientation
{
    return [[UIApplication sharedApplication] statusBarOrientation];
}

- (NSString*)get_system_machine
{
    struct utsname system_info;
    uname(&system_info);
    NSString *machine = [NSString stringWithCString:system_info.machine encoding:NSUTF8StringEncoding];
    return machine;
}

- (NSString*)device_name
{
    NSDictionary* info = [_device_info objectForKey:[self get_system_machine]];
    return [info objectForKey:@"name"];
}

- (enum_device_type)device_type
{
    NSDictionary* info = [_device_info objectForKey:[self get_system_machine]];
    return [[info objectForKey:@"type"] integerValue];
}

- (enum_device_size)device_size
{
    CGFloat screen_height = 0;
    if ([self is_greater_than_or_equal:8])
    {
        UIInterfaceOrientation orientation = [self current_orientation];
        if (orientation ==  UIDeviceOrientationPortrait)
        {
            screen_height = [[UIScreen mainScreen] bounds].size.height;
        }
        else if((orientation == UIDeviceOrientationLandscapeRight) || (orientation == UIInterfaceOrientationLandscapeLeft))
        {
            screen_height = [[UIScreen mainScreen] bounds].size.width;
        }
    }
    else
    {
        screen_height = [[UIScreen mainScreen] bounds].size.height;
    }
    if (screen_height == 480)
        return iPhone35inch;
    else if(screen_height == 568)
        return iPhone4inch;
    else if(screen_height == 667)
        return  iPhone47inch;
    else if(screen_height == 736)
        return iPhone55inch;
    else
        return UnknownSize;
}
@end
