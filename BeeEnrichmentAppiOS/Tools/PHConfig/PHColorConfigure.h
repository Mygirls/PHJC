//
//  PHColorConfigure.h
//  MajqFramework
//
//  Created by JQ on 2017/9/6.
//  Copyright © 2017年 majq. All rights reserved.
//

#ifndef PHColorConfigure_h
#define PHColorConfigure_h

#define test_color  [UIColor grayColor]

#define PH_color(R, G, B, A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]

//#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

// 默认黑色
#define PHDefalutBlack_color [UIColor colorWithRed:84/255.0 green:84/255.0 blue:84/255.0 alpha:1]

// 默认红色
#define PHDefalutRed_color [UIColor colorWithRed:247/255.0 green:69/255.0 blue:69/255.0 alpha:1]


#define PHScreenWidth [UIScreen mainScreen].bounds.size.width
#define PHScreenHeight [UIScreen mainScreen].bounds.size.height

#endif /* PHColorConfigure_h */
