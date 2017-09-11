//
//  JPDevice.h
//  ShiHang
//
//  Created by renpan on 14/10/17.
//  Copyright (c) 2014年 xizhe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSObject+JPNSObjectExtend.h"

#define JPDeviceCurrent        [JPDevice current]

#define JP_IOS6                    (6.0)
#define JP_IOS7                    (7.0)
#define JP_IOS8                    (8.0)

#define JP_GTE(_V)                  [JPDeviceCurrent is_greater_than_or_equal:_V]
#define JP_LTE(_V)                  [JPDeviceCurrent is_less_than_or_equal:_V]

typedef NS_ENUM(NSInteger, enum_device_type){
    Simulator = 0,
    iPhone4 = 3,
    iPhone4S = 4,
    iPhone5 = 5,
    iPhone5C = 6,
    iPhone5S = 7,
    iPhone6 = 8,
    iPhone6Plus = 9,
    
    iPad1 = 10,
    iPad2 = 11,
    iPadMini = 12,
    iPad3 = 13,
    iPad4 = 14,
    iPadAir = 15,
    iPadMini2 = 16,
    iPadAir2 = 17,
    iPadMini3 = 18
};

typedef NS_ENUM(NSInteger, enum_device_size){
    UnknownSize = 0,
    iPhone35inch = 1,
    iPhone4inch = 2,
    iPhone47inch = 3,
    iPhone55inch = 4
};

@interface JPDevice : NSObject
- (BOOL)is_ipad;
- (BOOL)is_iphone;
- (NSString*)my_name;
- (NSString*)system_name;
- (NSString*)model;
- (NSString*)localizedModel;
- (NSString*)ios_version;
- (BOOL)is_greater_than_or_equal:(CGFloat)ios_version;
- (BOOL)is_less_than_or_equal:(CGFloat)ios_version;
- (BOOL)is_ios8;

- (UIInterfaceOrientation)current_orientation;

- (NSString*)device_name;
- (enum_device_type)device_type;
- (enum_device_size)device_size;
@end
