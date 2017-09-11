//
//  JPColor.h
//  ShiHang
//
//  Created by renpan on 14/11/3.
//  Copyright (c) 2014年 xizhe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JPColor : NSObject

@end

@interface UIColor (JPColor)
+ (UIImage *)image_with_color:(UIColor *)color;

@end