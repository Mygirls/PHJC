//
//  Core+Push.m
//  CallMe
//
//  Created by renpan on 15/3/20.
//  Copyright (c) 2015年 XiZhe. All rights reserved.
//

#import "Core+Push.h"


//#import "WebViewController.h"
@interface Core ()
@end

@implementation Core (Push)

//- (void)push_process:(NSDictionary*)info from_app_run:(BOOL)from_app_run vc:(MainViewController *)main_vc
//{
//    _NSLog(@"Push From %d:\n%@", from_app_run, [info description]);
//    if(![self is_login])
//    {
//        return;
//    }
////    NSNumber* type = [info objectForKey:@"Type"];
////    NSString* user_id = [info objectForKey:@"UserId"];
////    if([type integerValue ] == 102)
////    {
////        NSDictionary* push_info = @{@"action": @"show_contact_record", @"user_id":user_id, @"original":info, @"from_app_run":@(from_app_run)};
////        if(from_app_run)
////        {
////            self.push_info = push_info;
////        }
////        else
////        {
////            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationPushProcess object:nil userInfo:push_info];
////        }
////    }
//    //
//    if (!from_app_run) {
//        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
//        localNotification.userInfo = info;
//        localNotification.soundName = UILocalNotificationDefaultSoundName;
//        localNotification.alertBody = [[info objectForKey:@"aps"] objectForKey:@"alert"];
//        localNotification.fireDate = [NSDate date];
//        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
//        return;
//    }
//    //处理推送条数
//    [CMCore dael_remote_notification_badge_with_is_alert:NO blockResult:^(NSNumber *code, id result, NSString *message) {
//    } blockRetry:nil];
//    //处理推送
//    //推送的是活动
//    if ([info[@"type"] integerValue] == 1) {
//        WebViewController *web_vc = [[WebViewController alloc] init];
//        web_vc.load = @{@"name":info[@"title"], @"url":info[@"webnet"]};
//        [main_vc go_next:web_vc animated:YES];
//        
//    }    
//}

@end
