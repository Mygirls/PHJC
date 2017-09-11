//
//  Core+Access.m
//  CarMirrorAppiOS
//
//  Created by renpan on 15/9/22.
//  Copyright © 2015年 HangZhouShangFu. All rights reserved.
//

#import "Core+Access.h"
@interface Core ()

@end
@implementation Core (Access)
- (void)save_device_token:(NSString*)device_token
{
    NSString* t = device_token;
    if(t == nil)
    {
        t = @"";
    }
    [JPConfigCurrent setObject:t forKey:@"device_token"];
}

- (NSString*)get_device_token
{
    return [JPConfigCurrent objectForKey:@"device_token"]?:@"noDecviceToken";
}

- (void)save_access_token:(NSString*)access_token {
    [JPConfigCurrent setObject:access_token forKey:@"accessToken"];
}

- (NSString*)get_access_token
{
    NSString* ret = [JPConfigCurrent objectForKey:@"accessToken"];
    return ret;
}



- (void)save_user_info_with_member:(NSDictionary*)member
{
    [JPConfigCurrent setObject:[member JSONRepresentation] forKey:@"userInfoMember"];
    if ([[member allKeys] containsObject:@"bankCards"]) {
        [self save_bank_card_info:member[@"bankCards"]];
    }else
    {
        [self remove_bank_card_info];
    }
    
}
- (NSDictionary*)get_user_info_member
{
    NSString* user_info_member = [JPConfigCurrent objectForKey:@"userInfoMember"];
    if (![user_info_member isKindOfClass:[NSNull class]]) {
        return [user_info_member JSONValue];
    }
    return nil;
}



- (void)save_user_info_with_access:(NSDictionary*)access
{
    [JPConfigCurrent setObject:[access JSONRepresentation] forKey:@"user_info_access"];
}

- (NSDictionary*)get_user_info_access
{
    NSString* user_info_access = [JPConfigCurrent objectForKey:@"user_info_access"];
    if (![user_info_access isKindOfClass:[NSNull class]]) {
        return [user_info_access JSONValue];
    }
    return nil;
}



- (void)save_bank_card_info:(NSDictionary*)bank_card_info
{
    [JPConfigCurrent setObject:[bank_card_info JSONRepresentation] forKey:@"bank_card_info"];
}
- (void)remove_bank_card_info
{
    if ([self get_bank_card_info]) {
        [JPConfigCurrent removeObjectForKey:@"bank_card_info"];
    }
}
- (NSDictionary*)get_bank_card_info
{
    NSString* bank_card_info = [JPConfigCurrent objectForKey:@"bank_card_info"];
    if (![bank_card_info isKindOfClass:[NSNull class]]) {
        return [bank_card_info JSONValue];
    }
    return nil;
}



//保存银行卡列表
- (void)save_bank_list_info:(NSArray*)bank_list
{
    [JPConfigCurrent setObject:[bank_list JSONRepresentation] forKey:@"bank_list"];
}
- (NSArray*)get_bank_list
{
    NSString* bank_list = [JPConfigCurrent objectForKey:@"bank_list"];
    if (![bank_list isKindOfClass:[NSNull class]]) {
        return [bank_list JSONValue];
    }
    return nil;
}






- (void)save_borrow_type:(NSString *)borrow_type {
    [JPConfigCurrent setObject:borrow_type forKey:@"borrow_type"];
}

- (NSString *)get_borrow_type {
    NSString* ret = [JPConfigCurrent objectForKey:@"borrow_type"];
    return ret;
}
- (BOOL)is_login
{
    if([self get_user_info_member] && ![[self get_access_token] isKindOfClass:[NSNull class]] && [self get_access_token] != nil)
    {
        return YES;
    }
    return NO;
}

- (void)logout
{
    [JPConfigCurrent removeObjectForKey:@"userInfoMember"];
    [JPConfigCurrent removeObjectForKey:@"user_info_access"];
    [JPConfigCurrent removeObjectForKey:@"device_token"];
    [JPConfigCurrent removeObjectForKey:@"accessToken"];
    if ([self get_bank_card_info]) {
        [JPConfigCurrent removeObjectForKey:@"bankCards"];
    }
}
//保存启动图信息
- (void)save_launch_image_info:(NSDictionary *)launch_image_info {
    [JPConfigCurrent setObject:[launch_image_info JSONRepresentation] forKey:@"launch_image_info"];
}
//获取启动图信息
- (NSDictionary *)get_launch_image_info {
    NSString* launch_image_info = [JPConfigCurrent objectForKey:@"launch_image_info"];
    if (![launch_image_info isKindOfClass:[NSNull class]]) {
        return [launch_image_info JSONValue];
    }
    return nil;
}



@end
