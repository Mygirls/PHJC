
//
//  Core.m
//  CarMirrorAppiOS
//
//  Created by renpan on 15/9/17.
//  Copyright (c) 2015年 HangZhouShangFu. All rights reserved.
//

#import "Core.h"
#import "Reachability.h"
#import <AddressBook/AddressBook.h>


#pragma mark today change codes
@interface Core()<CLLocationManagerDelegate>

@end

@implementation Core
ShareInstanceDefine

- (void)init_data
{
    _http = [JPHttpWrapper current];
    _http.debug_mode = YES;
    JPLogEnable(JPLogEnableDefault);
    //    JPLogLevel(JPLogLevelAll);
    [self set_default_theme];
    
    NSString* url = [self api_base_url];
    if (!url) {
//        [JPConfigCurrent setObject:@"https://www.phjucai.com/shangfu_api" forKey:@"api_base_url"];
    }else
    {
        [JPConfigCurrent setObject:url forKey:@"api_base_url"];
    }
    
}

- (NSString*)get_api_base_url
{
    return [JPConfigCurrent objectForKey:@"api_base_url"];
}

- (NSString*)get_api_base_url_with_api
{
    return [[self get_api_base_url] stringByAppendingPathComponent:@"api"];
}
- (NSString*)get_api_base_url_with_webapi
{
    return [[self get_api_base_url] stringByAppendingPathComponent:@"webapi"];
}
- (NSString*)get_api_base_url_with_mobile
{
    return [[[self get_api_base_url] stringByAppendingPathComponent:@"mobile"] stringByAppendingString:@"/"];
}

- (void)setIs_first_run:(BOOL)is_first_run
{
    [JPConfigCurrent setBool:is_first_run forKey:@"is_first_run"];
}

- (BOOL)is_first_run
{
    id exist = [JPConfigCurrent objectForKey:@"is_first_run"];
    if(exist == nil)
    {
        [JPConfigCurrent setBool:YES forKey:@"is_first_run"];
    }
    return [JPConfigCurrent boolForKey:@"is_first_run"];
}
//是否开启手势密码
- (BOOL)is_open_gesture_password
{
    id exist = [JPConfigCurrent objectForKey:@"is_open_gesture_password"];
    if(exist == nil)
    {
        [JPConfigCurrent setBool:YES forKey:@"is_open_gesture_password"];
    }
    return [JPConfigCurrent boolForKey:@"is_open_gesture_password"];
}
- (void)setIs_open_gesture_password:(BOOL)is_open_gesture_password
{
    [JPConfigCurrent setBool:is_open_gesture_password forKey:@"is_open_gesture_password"];
}

////是否开启自动理财
//- (BOOL)is_open_auto_licai
//{
//    id exist = [JPConfigCurrent objectForKey:@"is_open_auto_licai"];
//    if(exist == nil)
//    {
//        [JPConfigCurrent setBool:YES forKey:@"is_open_auto_licai"];
//    }
//    return [JPConfigCurrent boolForKey:@"is_open_auto_licai"];
//}
//- (void)setIs_open_auto_licai:(BOOL)is_open_auto_licai
//{
//    [JPConfigCurrent setBool:is_open_auto_licai forKey:@"is_open_auto_licai"];
//}

//是否提示设置手势密码
- (void)setIs_ti_shi_set_gesture:(BOOL)is_ti_shi_set_gesture
{
    [JPConfigCurrent setBool:is_ti_shi_set_gesture forKey:@"is_ti_shi_set_gesture"];
}
-(BOOL)is_ti_shi_set_gesture
{
    id exist = [JPConfigCurrent objectForKey:@"is_ti_shi_set_gesture"];
    if(exist == nil)
    {
        [JPConfigCurrent setBool:YES forKey:@"is_ti_shi_set_gesture"];
    }
    return [JPConfigCurrent boolForKey:@"is_ti_shi_set_gesture"];
}


//评论弹框的状态 1:朕去瞅瞅，2:朕很忙，3:别再烦朕 0:当前没有出现过弹框
- (void)setEnabledCommentWithNum:(NSInteger)num
{
    [JPConfigCurrent setObject:[NSString stringWithFormat:@"%ld",(long)num] forKey:@"EnabledComment"];
}
- (NSInteger)enabledComment
{
    id exist = [JPConfigCurrent objectForKey:@"EnabledComment"];
    if (exist == nil) {
        [JPConfigCurrent setObject:@"0" forKey:@"EnabledComment"];
        return 0;
    }
    return [[JPConfigCurrent objectForKey:@"EnabledComment"] integerValue];
    
}

- (NSString *)clearZeroWithString:(NSString *)string
{
    if (string.length > 1) {
        NSString *lastStr = [string substringFromIndex:[string length] - 1];
        NSInteger index = 0;
        while ([lastStr isEqualToString:@"0"] || [lastStr isEqualToString:@"."]) {
            index = string.length;
            string = [string substringToIndex:index - 1];
            if ([lastStr isEqualToString:@"."]) {
                break;
            }
            lastStr = [string substringFromIndex:string.length - 1];
        }
        return string;
    }else {
        return string;
    }
}

- (BOOL)isExistenceNetwork
{
    BOOL isExistenceNetwork;
    Reachability *reachability = [Reachability reachabilityWithHostName:@"www.didai.com"];
    switch([reachability currentReachabilityStatus]){
        case NotReachable: isExistenceNetwork = FALSE;
            NSLog(@"无网");
            break;
        case ReachableViaWWAN: isExistenceNetwork = TRUE;
            NSLog(@"手机网");
            break;
        case ReachableViaWiFi: isExistenceNetwork = TRUE;
            NSLog(@"wifi");
            break;
    }
    return isExistenceNetwork;
}

- (void)get_bankList
{
    //获取银行卡列表
    [CMCore get_bank_list_with_is_alert:YES blockResult:^(NSNumber *code, id result, NSString *message) {
        if (result) {
            [CMCore save_bank_list_info:result];
            
        }
    } blockRetry:^(NSInteger index) {
        
        if (index == 1) {
            [self get_bankList];
        }
    }];
}



@end
