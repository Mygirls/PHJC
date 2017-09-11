//
//  MBProgressHUDHelper.m
//  CallMe
//
//  Created by renpan on 15/3/29.
//  Copyright (c) 2015年 XiZhe. All rights reserved.
//

#import "MBProgressHUDHelper.h"

@implementation MBProgressHUDHelper
ShareInstanceDefine

+ (void)showHUD_animated:(BOOL)animated text:(NSString*)text
{
    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:[JPScreen find_top_window] animated:animated];
    hud.label.text = text;
}

@end
