//
//  MBProgressHUDHelper.h
//  CallMe
//
//  Created by renpan on 15/3/29.
//  Copyright (c) 2015年 XiZhe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+JPNSObjectExtend.h"
#import <MBProgressHUD/MBProgressHUD.h>

@interface MBProgressHUDHelper : NSObject
+ (void)showHUD_animated:(BOOL)animated text:(NSString*)text;
@end
