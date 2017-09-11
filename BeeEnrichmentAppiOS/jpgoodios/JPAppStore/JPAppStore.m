//
//  JPAppStore.m
//  CallMe
//
//  Created by renpan on 15/3/25.
//  Copyright (c) 2015年 XiZhe. All rights reserved.
//

#import "JPAppStore.h"
#import "JPDevice.h"

@implementation JPAppStore
+ (void)open_app_comment_with_app_id:(NSString*)app_id
{
    NSString* url = nil;
    if([JPDeviceCurrent is_greater_than_or_equal:7.0])
    {
        url = [@"itms-apps://itunes.apple.com/app/id" stringByAppendingString:app_id];
    }
    else
    {
        url = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@", app_id];
    }
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}
@end
