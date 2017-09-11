


//
//  Core+Http.m
//  CarMirrorAppiOS
//
//  Created by renpan on 15/9/21.
//  Copyright © 2015年 HangZhouShangFu. All rights reserved.
//

#import "Core+Http.h"
#import "CMBaseTabBarController.h"
@implementation Core (Http)
- (NSDictionary*)build_up_with_params:(NSMutableDictionary *)params
{
    NSString* _params = [[params JSONRepresentation] base64Encode];
    NSUInteger str_length = 10;
    NSRange rg = {0,str_length};
    NSString* sub_front = [_params substringWithRange:rg];
    rg.location = str_length;
    NSString* middle = [_params substringWithRange:rg];
    NSString* end_behind = [_params substringFromIndex:str_length * 2];
    NSString* full_params = [[NSString stringWithFormat:@"%@%@%@", middle, sub_front, end_behind] base64Encode];
    NSMutableDictionary* common_params = [NSMutableDictionary dictionary];
    [common_params setObject:@101 forKey:@"source"];//101
    NSString* current_time = [NSDate getCurrentTime];
    [common_params setObject:current_time forKey:@"time"];
    [common_params setObject:@"zh_CN" forKey:@"lang"];
    [common_params setObject:full_params forKey:@"params"];
    NSString* sign = [[NSString stringWithFormat:@"%@%@", [[NSString stringWithFormat:@"%@%@",full_params,current_time] md5], APP_KEY] md5];
    [common_params setObject:sign forKey:@"sign"];
    [common_params setObject:[self app_version] forKey:@"version"];
    [common_params setObject:@"mfjczsb" forKey:@"create_from"];
    [common_params setObject:[[[UIDevice currentDevice]identifierForVendor] UUIDString] forKey:@"device-udid"];
    NSString *member_id = [self get_user_info_member][@"id"]?:@"";
    [common_params setObject:member_id forKey:@"member_id"];
    NSString *momber_phone =[self get_user_info_member][@"memberPhone"]?:@"";
    [common_params setObject:momber_phone forKey:@"member_phone"];
    return common_params;
}

- (NSDictionary*)buildUpWithOldparams:(NSMutableDictionary*)params
{
    NSString* _params = [[params JSONRepresentation] base64Encode];
    NSUInteger str_length = 10;
    NSRange rg = {0,str_length};
    NSString* sub_front = [_params substringWithRange:rg];
    rg.location = str_length;
    NSString* middle = [_params substringWithRange:rg];
    NSString* end_behind = [_params substringFromIndex:str_length * 2];
    NSString* full_params = [[NSString stringWithFormat:@"%@%@%@", middle, sub_front, end_behind] base64Encode];
    NSMutableDictionary* common_params = [NSMutableDictionary dictionary];
    [common_params setObject:@101 forKey:@"source"];//101
    NSString* current_time = [NSDate getCurrentTime];
    [common_params setObject:current_time forKey:@"time"];
    [common_params setObject:@"zh_CN" forKey:@"lang"];
    [common_params setObject:full_params forKey:@"params"];
    NSString* sign = [[NSString stringWithFormat:@"%@%@", [[NSString stringWithFormat:@"%@%@",full_params,current_time] md5], APP_KEY] md5];
    [common_params setObject:sign forKey:@"sign"];
    [common_params setObject:[self app_version] forKey:@"version"];
    
    
    [common_params setObject:@"mfjczsb" forKey:@"clone_id"];
    [common_params setObject:[[[UIDevice currentDevice]identifierForVendor] UUIDString] forKey:@"device_udid"];
    return common_params;
}


#pragma mark  获取接口基地址
- (NSString*)api_base_url
{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] initWithDictionary: @
                                   {
                                       @"method": @"baseV2"
                                   }];
    NSDictionary* common_params = [self build_up_with_params:params];
    NSMutableArray* array_params = [[NSMutableArray alloc] init];
    for(NSString* key in [common_params allKeys])
    {
        NSString* value = [common_params objectForKey:key];
        [array_params addObject:[NSString stringWithFormat:@"%@=%@", key, value]];
    }
    NSString* post_data = [array_params componentsJoinedByString:@"&"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[HTTP_API_GET_BASE_URL stringByAppendingString:@"/api/system/baseV2"]]];
    [request setHTTPMethod:@"POST"];
    NSData* post_datas = [NSData dataWithBytes:[post_data UTF8String] length:[post_data length]];
    [request setHTTPBody:post_datas];
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSDictionary* ret = [data json];
    NSString* url = [ret objectForKey:@"value"];
    DLog(@"\n\n\n基地址:\n%@\n\n", url);
    return url;
    
}


- (AFHTTPRequestOperation*)processs_request_with_module:(NSString*)module params:(NSDictionary*)params file_list:(NSArray*)file_list is_alert:(BOOL)is_alert blockResult:(resultBlock)blockResult blockRetry:(retryBlock)blockRetry blockExpired:(expiredBlock)blockExpired progress:(uploadProgess)progress_block
{
    if (![self api_base_url] && ![CMCore isExistenceNetwork]) {
        [[JPAlert current] showAlertWithTitle:@"提示" content:@"当前网络不可用，请检查网络连接" button:@[@"重试", @"去设置"] block:^(UIAlertView* alertView, NSInteger index) {
            if (index) {
                NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if ([[UIApplication sharedApplication] canOpenURL:url]) {
                    [[UIApplication sharedApplication] openURL:url];
                }
                exit(0);
            }
            
        }];
        return nil;
    }
    
    if ([module isEqualToString:@"/login/sysLoginByUp"] || [module isEqualToString:@"/login/sysLoginByCode"] ||[module isEqualToString:@"/login/sysRegister"] || [module isEqualToString:@"/sms/getPhoneVerifyCode"] || [module isEqualToString:@"/login/bindMobilePhone"] || [module isEqualToString:@"/recharge/rechargeReady"] ||[module isEqualToString:@"/recharge/rechargeConfirm"]) {
        self.http.base_url = HTTP_API_GET_BASE_URL;
    }else {
        self.http.base_url = HTTP_API_DEFAULT;
    }
    
    
    if(file_list)
    {
        return [self.http post:module params:params file_list:file_list response:^(BOOL success, id responseObject, NSError *error, AFHTTPRequestOperation *operation) {
            if(success)
            {
                NSNumber* code = [responseObject objectForKey:@"code"];
                if([code integerValue] == 200)
                {
                    if(blockResult)
                    {
                        id result = [responseObject objectForKey:@"value"];
                        if([result isKindOfClass:[NSNull class]])
                        {
                            blockResult(code, nil, nil);
                        }
                        else
                        {
                            blockResult(code, result, nil);
                        }
                    }
                }
                else if([code integerValue] == 401) {
                    _NSLogObject(params);
                    if(blockResult)
                    {
                        blockResult(code, nil, @"已退出或在另外的设备登录，需要重新登录");
                    }
                    if(blockExpired)
                    {
                        blockExpired();
                    }
                    [self logout];
                    [[JPAlert current] showAlertWithTitle:@"已退出或在另外的设备登录，需要重新登录" content:nil button:@[@"重新登录"] block:^(UIAlertView* alertView, NSInteger index) {
                        [self logout];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self set_to_main_controller];
                        });
                    }];
                }
                else {
                    _NSLogObject(params);
                    NSString* message = [responseObject objectForKey:@"message"];
                    if(blockResult)
                    {
                        blockResult(code, nil, message);
                    }
                    if(is_alert)
                    {
                        [[JPAlert current] showAlertWithTitle:message content:nil button:@[@"好的"] block:^(UIAlertView* alertView, NSInteger index) {
                            if(blockRetry)
                            {
                                blockRetry(index);
                            }
                        }];
                        
                    }
                    else {
                        if(blockRetry)
                        {
                            blockRetry(1);
                        }
                    }
                }
            }
            else {
                _NSLogObject(params);
                if(blockResult)
                {
                    blockResult(nil, nil, @"网络传输失败，是否重试？");
                }
                if(is_alert)
                {
                    [[JPAlert current] showAlertWithTitle:@"网络传输失败，是否重试？" content:nil button:@[@"取消", @"重试"] block:^(UIAlertView* alertView, NSInteger index) {
                        if(blockRetry)
                        {
                            blockRetry(index);
                        }
                    }];
                }
                else {
                    if(blockRetry)
                    {
                        blockRetry(1);
                    }
                }
            }
        } progress:progress_block];
    }
    else
    {
        return [self.http post:module params:params response:^(BOOL success, id responseObject, NSError *error, AFHTTPRequestOperation *operation) {
            
            if(success)
            {
                NSNumber* code = [responseObject objectForKey:@"code"];
                if([code integerValue] == 200)
                {
                    if(blockResult)
                    {
                        id result = [responseObject objectForKey:@"value"];
                        if([result isKindOfClass:[NSNull class]])
                        {
                            blockResult(code, nil, nil);
                        }
                        else
                        {
                            blockResult(code, result, nil);
                        }
                    }
                }
                else if([code integerValue] == 401)
                {
                    _NSLogObject(params);
                    if(blockResult)
                    {
                        blockResult(code, nil, @"已退出或在另外的设备登录，需要重新登录");
                    }
                    if(blockExpired)
                    {
                        blockExpired();
                    }
                    [self logout];
                    [[JPAlert current] showAlertWithTitle:@"已退出或在另外的设备登录，需要重新登录" content:nil button:@[@"重新登录"] block:^(UIAlertView* alertView, NSInteger index) {
                        [self logout];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self set_to_main_controller];
                        });
                    }];
                }
                else
                {
                    _NSLogObject(params);
                    NSString* message = [responseObject objectForKey:@"message"];
                    
                    if(blockResult)
                    {
                        blockResult(code, nil, message);
                    }
                    if(is_alert)
                    {
                        if (![module isEqualToString:@"gift_bag"]) {
                            if ([module isEqual: @"bank"]) {
                                [[JPAlert current] showAlertWithTitle:@"绑定失败" content:message button:@[@"再试一次"] block:^(UIAlertView* alertView, NSInteger index) {
                                    
                                }];
                            }else {
                                if (message != nil && ![message isEqual:[NSNull null]] && message) {
                                    if (![module isEqualToString:@"/home/exchangeGift_Bag"]) {
                                        [[JPAlert current] showAlertWithTitle:message content:nil button:@[@"好的"] block:^(UIAlertView* alertView, NSInteger index) {
                                            if (index) {
                                                if(blockRetry)
                                                {
                                                    blockRetry(index);
                                                }
                                            }
                                            
                                        }];
                                    }
                                }
                                
                                
                            }
                        }
                        
                    }
                    else
                    {
                        if(blockRetry)
                        {
                            blockRetry(1);
                        }
                    }
                }
            }
            else
            {
                _NSLogObject(params);
                if(blockResult)
                {
                    blockResult(nil, nil, @"网络传输失败，是否重试？");
                }
                if(is_alert)
                {
                    [[JPAlert current] showAlertWithTitle:@"网络传输失败，是否重试？" content:nil button:@[@"取消", @"重试"] block:^(UIAlertView* alertView, NSInteger index) {
                        if (index) {
                            if(blockRetry)
                            {
                                blockRetry(index);
                            }
                        }
                    }];
                }
                else
                {
                    if(blockRetry)
                    {
                        blockRetry(1);
                    }
                }
            }
        }];
        
    }
}

#pragma mark  登录
- (AFHTTPRequestOperation*)login_with_mobile_phone:(NSString*)mobile_phone password:(NSString*)password is_alert:(BOOL)is_alert blockResult:(resultBlock)blockResult blockRetry:(retryBlock)blockRetry
{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] initWithDictionary: @
    {
        @"mobile_phone": mobile_phone,
        @"password_md5": [password md5],
        
        @"source_from_description":@(2),
        @"create_from":@"mfjczsb",
        @"agent_from": @"mfjczsb",
        @"device_model" : [NSString stringWithFormat:@"%@", [[UIDevice currentDevice] model]],
    }];

    if ([self get_device_token]) {
        [params setValue:[self get_device_token] forKey:@"device_token"];
    }
    return [self processs_request_with_module:@"/login/sysLoginByUp" params:[self build_up_with_params:params] file_list:nil is_alert:is_alert blockResult:blockResult blockRetry:blockRetry blockExpired:nil progress:nil];
}
#pragma mark  快速登录
- (AFHTTPRequestOperation*)fast_login_with_mobile:(NSString*)mobile auth_code:(NSString*)auth_code is_alert:(BOOL)is_alert blockResult:(resultBlock)blockResult blockRetry:(retryBlock)blockRetry
{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] initWithDictionary: @
    {

        @"mobile_phone": mobile,
        @"auth_code": auth_code,
        @"source_from_description":@(2),
        @"create_from":@"mfjczsb",
        @"agent_from": @"mfjczsb",
        @"device_model" : [NSString stringWithFormat:@"%@", [[UIDevice currentDevice] model]],
    }];
    if ([self get_device_token]) {
        [params setValue:[self get_device_token] forKey:@"device_token"];
    }
    return [self processs_request_with_module:@"/login/sysLoginByCode" params:[self build_up_with_params:params] file_list:nil is_alert:is_alert blockResult:blockResult blockRetry:blockRetry blockExpired:nil progress:nil];
}
#pragma mark  注册
- (AFHTTPRequestOperation*)register_with_mobile_phone:(NSString*)mobile_phone auth_code:(NSString*)auth_code password:(NSString *)password invite_code:(NSString*)invite_code is_alert:(BOOL)is_alert blockResult:(resultBlock)blockResult blockRetry:(retryBlock)blockRetry
{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] initWithDictionary: @
    {
        @"mobile_phone": mobile_phone,
        @"auth_code": auth_code,
        @"password_md5":[password md5],
        @"invited_mobile_phone": invite_code,
        @"source_from_description":@(2),
        @"create_from":@"mfjczsb",
        @"agent_from": @"mfjczsb",
    }];
    if ([self get_device_token]) {
        [params setValue:[self get_device_token] forKey:@"device_token"];
    }
    return [self processs_request_with_module:@"/login/sysRegister" params:[self build_up_with_params:params] file_list:nil is_alert:is_alert blockResult:blockResult blockRetry:blockRetry blockExpired:nil progress:nil];
}

#pragma mark  忘记登陆密码／修改登录密码
- (AFHTTPRequestOperation*)update_password_mobile_phone:(NSString*)mobile_phone auth_code:(NSString*)auth_code password:(NSString *)password is_alert:(BOOL)is_alert blockResult:(resultBlock)blockResult blockRetry:(retryBlock)blockRetry
{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] initWithDictionary:@
    {
        @"mobile_phone": mobile_phone,
        @"auth_code": auth_code,
        @"new_password_md5":[password md5],
        @"mobile_phone": [CMCore get_user_info_member][@"mobilePhone"]?:@"",
    }];
    if ([self get_device_token]) {
        [params setValue:[self get_device_token] forKey:@"device_token"];
    }
    return [self processs_request_with_module:@"/home/updateLoginPasswd" params:[self build_up_with_params:params] file_list:nil is_alert:is_alert blockResult:blockResult blockRetry:blockRetry blockExpired:nil progress:nil];
}
#pragma mark  设置交易密码/修改支付密码
- (AFHTTPRequestOperation*)update_pay_passwd_with_pay_password:(NSString*)pay_password is_alert:(BOOL)is_alert blockResult:(resultBlock)blockResult blockRetry:(retryBlock)blockRetry
{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] initWithDictionary: @
    {
        @"pay_password_md5":[pay_password md5],
        @"mobile_phone": [CMCore get_user_info_member][@"mobilePhone"]?:@"",
    }];
    if ([CMCore get_access_token]) {
        [params setValue:[CMCore get_access_token] forKey:@"access_token"];
    };
    return [self processs_request_with_module:@"/home/updatePayPasswd" params:[self build_up_with_params:params] file_list:nil is_alert:is_alert blockResult:blockResult blockRetry:blockRetry blockExpired:nil progress:nil];
}
#pragma mark  验证登录密码
- (AFHTTPRequestOperation*)auth_login_passwd_with_login_passwd:(NSString*)login_passwd is_alert:(BOOL)is_alert blockResult:(resultBlock)blockResult blockRetry:(retryBlock)blockRetry
{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] initWithDictionary: @
    {
        @"login_passwd_md5":[login_passwd md5],
        @"mobile_phone": [CMCore get_user_info_member][@"mobilePhone"]?:@"",
    }];
    if ([CMCore get_access_token]) {
        [params setValue:[CMCore get_access_token] forKey:@"access_token"];
    };
    return [self processs_request_with_module:@"/home/authLoginPasswd" params:[self build_up_with_params:params] file_list:nil is_alert:is_alert blockResult:blockResult blockRetry:blockRetry blockExpired:nil progress:nil];
}

#pragma mark  老用户验证
- (AFHTTPRequestOperation*)auth_verify_with_login_member_id:(NSString*)member_id user_name:(NSString*)user_name auth_code:(NSString*)auth_code mobile_phone:(NSString*)mobile_phone is_alert:(BOOL)is_alert blockResult:(resultBlock)blockResult blockRetry:(retryBlock)blockRetry
{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] initWithDictionary: @
    {
        @"member_id":member_id,
        @"user_name": user_name,
        @"auth_code": auth_code,
        @"mobile_phone": mobile_phone,
    }];
    return [self processs_request_with_module:@"/login/bindMobilePhone" params:[self build_up_with_params:params] file_list:nil is_alert:is_alert blockResult:blockResult blockRetry:blockRetry blockExpired:nil progress:nil];
}

#pragma mark  短信验证码
- (AFHTTPRequestOperation*)get_auth_code_with_with_mobile_phone:(NSString*)mobile_phone is_alert:(BOOL)is_alert blockResult:(resultBlock)blockResult blockRetry:(retryBlock)blockRetry
{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] initWithDictionary: @
    {
        @"mobile_phone": mobile_phone != nil ? mobile_phone : [CMCore get_user_info_member][@"mobilePhone"]
    }];
    if ([self get_access_token]) {
        [params setValue:[self get_access_token] forKey:@"access_token"];
    }
    return [self processs_request_with_module:@"/sms/getPhoneVerifyCode" params:[self build_up_with_params:params] file_list:nil is_alert:is_alert blockResult:blockResult blockRetry:blockRetry blockExpired:nil progress:nil];
}

#pragma mark  用户信息
- (AFHTTPRequestOperation*)get_user_info_with_is_alert:(BOOL)is_alert blockResult:(resultBlock)blockResult blockRetry:(retryBlock)blockRetry
{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] initWithDictionary:@
    {
        @"mobile_phone": [CMCore get_user_info_member][@"mobilePhone"]?:@"",
    }];
    
    if ([self get_access_token]) {
        [params setValue:[self get_access_token] forKey:@"access_token"];
    }
    
    return [self processs_request_with_module:@"/home/userInfo" params:[self build_up_with_params:params] file_list:nil is_alert:is_alert blockResult:blockResult blockRetry:blockRetry blockExpired:nil progress:nil];
}
#pragma mark  用户头像
- (AFHTTPRequestOperation*)update_user_head_url_with_head_image:(UIImage *)head_image is_alert:(BOOL)is_alert blockResult:(resultBlock)blockResult blockRetry:(retryBlock)blockRetry
{
    NSMutableArray *file_list = [NSMutableArray new];
    [file_list addObject:@{@"data": UIImageJPEGRepresentation(head_image, 0.7), @"name": @"head_image", @"file_name":@"head_image.jpg", @"mime_type": @"image/jpg"}];
    NSMutableDictionary* params = [[NSMutableDictionary alloc] initWithDictionary:@
    {
        @"mobile_phone": [CMCore get_user_info_member][@"mobilePhone"]?:@"",
    }];
    if ([CMCore get_access_token]) {
        [params setValue:[CMCore get_access_token] forKey:@"access_token"];
    };
    return [self processs_request_with_module:@"/home/updateUserHead" params:[self build_up_with_params:params] file_list:file_list is_alert:is_alert blockResult:blockResult blockRetry:blockRetry blockExpired:nil progress:nil];
}
#pragma mark  我的二维码
- (AFHTTPRequestOperation*)my_qrcode_with_is_alert:(BOOL)is_alert blockResult:(resultBlock)blockResult blockRetry:(retryBlock)blockRetry
{
    
    NSMutableDictionary* params = [[NSMutableDictionary alloc] initWithDictionary:@
    {

        @"mobile_phone": [CMCore get_user_info_member][@"mobilePhone"]?:@""
    }];
    if ([CMCore get_access_token]) {
        [params setValue:[CMCore get_access_token] forKey:@"access_token"];
    };
    return [self processs_request_with_module:@"member" params:[self build_up_with_params:params] file_list:nil is_alert:is_alert blockResult:blockResult blockRetry:blockRetry blockExpired:nil progress:nil];
}

#pragma mark  关于我们
- (AFHTTPRequestOperation*)about_us_with_is_alert:(BOOL)is_alert blockResult:(resultBlock)blockResult blockRetry:(retryBlock)blockRetry
{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] initWithDictionary: @
    {
        @"mobile_phone": [CMCore get_user_info_member][@"mobilePhone"]?:@""
    }];
    if ([CMCore get_access_token]) {
        [params setValue:[CMCore get_access_token] forKey:@"access_token"];
    };
    return [self processs_request_with_module:@"/home/aboutUs" params:[self build_up_with_params:params] file_list:nil is_alert:is_alert blockResult:blockResult blockRetry:blockRetry blockExpired:nil progress:nil];
}

#pragma mark  发现列表请求
- (AFHTTPRequestOperation*)get_discover_with_home:(NSString *)home is_alert:(BOOL)is_alert blockResult:(resultBlock)blockResult blockRetry:(retryBlock)blockRetry
{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] initWithDictionary: @
    {
        @"method": @"sfActivity",
        @"home" : home,
    }];
    
    return [self processs_request_with_module:@"/system/sfActivity" params:[self build_up_with_params:params] file_list:nil is_alert:is_alert blockResult:blockResult blockRetry:blockRetry blockExpired:nil progress:nil];
}

#pragma mark  获取推荐列表
- (AFHTTPRequestOperation*)get_recommend_is_alert:(BOOL)is_alert blockResult:(resultBlock)blockResult blockRetry:(retryBlock)blockRetry
{
    NSMutableDictionary* params = [[NSMutableDictionary alloc]  initWithDictionary: @
    {
        @"mobile_phone": [CMCore get_user_info_member][@"mobilePhone"]?:@""
    }];
//    if ([CMCore get_access_token]) {
//        [params setValue:[CMCore get_access_token] forKey:@"access_token"];
//    };
    return [self processs_request_with_module:@"/system/hotList" params:[self build_up_with_params:params] file_list:nil is_alert:is_alert blockResult:blockResult blockRetry:blockRetry blockExpired:nil progress:nil];
}

#pragma mark   新首页轮播列表
- (AFHTTPRequestOperation*)get_recommend_carousel_is_alert:(BOOL)is_alert blockResult:(resultBlock)blockResult blockRetry:(retryBlock)blockRetry
{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] initWithDictionary: @
    {
        @"method": @"getBrannerMenu",//getBrannerMenu
    }];
    return [self processs_request_with_module:@"/system/getBrannerMenu" params:[self build_up_with_params:params] file_list:nil is_alert:is_alert blockResult:blockResult blockRetry:blockRetry blockExpired:nil progress:nil];
}

#pragma mark  获取理财超市列表 page，count为－1时表示不传值
- (AFHTTPRequestOperation*)get_subject_list_with_subject_status:(NSInteger)subject_status page:(NSInteger)page count:(NSInteger)count is_alert:(BOOL)is_alert  blockResult:(resultBlock)blockResult blockRetry:(retryBlock)blockRetry
{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] initWithDictionary: @
    {
        @"method":@"marketList",
        @"market_type": @(subject_status),
        @"page":@(1),
        @"count":@(20)
    }];
    return [self processs_request_with_module:@"/system/marketList" params:[self build_up_with_params:params] file_list:nil is_alert:is_alert blockResult:blockResult blockRetry:blockRetry blockExpired:nil progress:nil];
}

#pragma mark  理财产品详情
- (AFHTTPRequestOperation*)get_subject_detail_with_subject_id:(NSString *)subject_id market_type:(NSInteger)market_type is_alert:(BOOL)is_alert blockResult:(resultBlock)blockResult blockRetry:(retryBlock)blockRetry
{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] initWithDictionary: @
    {
        @"market_type": @(market_type),
        @"_id":subject_id == nil ? @"" : subject_id
    }];
    return [self processs_request_with_module:@"/system/marketDetail" params:[self build_up_with_params:params] file_list:nil is_alert:is_alert blockResult:blockResult blockRetry:blockRetry blockExpired:nil progress:nil];
}

#pragma mark  获取银行列表
- (AFHTTPRequestOperation*)get_bank_list_with_is_alert:(BOOL)is_alert blockResult:(resultBlock)blockResult blockRetry:(retryBlock)blockRetry
{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] initWithDictionary: @
    {
        @"method": @"supportBank",
    }];
    return [self processs_request_with_module:@"/system/supportBank" params:[self build_up_with_params:params] file_list:nil is_alert:is_alert blockResult:blockResult blockRetry:blockRetry blockExpired:nil progress:nil];
}

#pragma mark  是否可以解绑银行卡
- (AFHTTPRequestOperation*)unbind_bank_card_with_is_alert:(BOOL)is_alert blockResult:(resultBlock)blockResult blockRetry:(retryBlock)blockRetry
{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] initWithDictionary: @
    {
        @"mobile_phone": [CMCore get_user_info_member][@"mobilePhone"]?:@""
        
    }];
    if ([CMCore get_access_token]) {
        [params setValue:[CMCore get_access_token] forKey:@"access_token"];
    };
    return [self processs_request_with_module:@"/home/unbindBank" params:[self build_up_with_params:params] file_list:nil is_alert:is_alert blockResult:blockResult blockRetry:blockRetry blockExpired:nil progress:nil];
}

#pragma mark  指纹支付发送验证短信
-(AFHTTPRequestOperation*)sendCheckMessageWithIs_alert:(BOOL)is_alert blockResult:(resultBlock)blockResult blockRetry:(retryBlock)blockRetry {
    NSMutableDictionary* params = [[NSMutableDictionary alloc] initWithDictionary: @
    {
        @"mobile_phone": [CMCore get_user_info_member][@"mobilePhone"]?:@""
        
    }];
    if ([CMCore get_access_token]) {
        [params setValue:[CMCore get_access_token] forKey:@"access_token"];
    };
    return [self processs_request_with_module:@"fingerprint_pay" params:[self build_up_with_params:params] file_list:nil is_alert:is_alert blockResult:blockResult blockRetry:blockRetry blockExpired:nil progress:nil];
}

#pragma mark  指纹支付验证短信
-(AFHTTPRequestOperation*)checkMessageWithFingerprint_token:(NSString *)fingerprint_token andCode:(NSString *)code is_alert:(BOOL)is_alert blockResult:(resultBlock)blockResult blockRetry:(retryBlock)blockRetry {
    
    NSMutableDictionary* params = [[NSMutableDictionary alloc] initWithDictionary: @
    {
        @"fingerprint_token":fingerprint_token,
        @"code":code,
        @"mobile_phone": [CMCore get_user_info_member][@"mobilePhone"]?:@""
        
    }];
    if ([CMCore get_access_token]) {
        [params setValue:[CMCore get_access_token] forKey:@"access_token"];
    };
    return [self processs_request_with_module:@"fingerprint_pay" params:[self build_up_with_params:params] file_list:nil is_alert:is_alert blockResult:blockResult blockRetry:blockRetry blockExpired:nil progress:nil];
}


#pragma mark  指纹支付确认
-(AFHTTPRequestOperation*)take_order_with_payWithFinger:(NSString *)finger isSuccess:(BOOL )isSuccess subject_id:(NSString *)subject_id market_type:(NSInteger)market_type total_money_actual:(NSString*)total_money_actual money_pay:(NSString *)money_pay interest_pay:(NSString *)interest_pay remaining_pay:(NSString*)remaining_pay total_money:(NSString*)total_money coupon_id:(NSString*)coupon_id is_alert:(BOOL)is_alert blockResult:(resultBlock)blockResult blockRetry:(retryBlock)blockRetry{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] initWithDictionary: @ {
        @"fingerprint_token_md5":finger,
        @"market_type":@(market_type),
        @"fingerprint_pay_tag":[NSNumber numberWithBool:isSuccess],
        @"_id":subject_id,
        @"bank_pay":@"0",
        @"remaining_pay":remaining_pay,
        @"total_money":total_money,
        @"total_money_actual":total_money_actual,
        @"money_pay":money_pay,
        @"interest_pay":interest_pay,
        @"member_coupon_id":coupon_id?:@"",
    }];
    if ([CMCore get_access_token]) {
        [params setValue:[CMCore get_access_token] forKey:@"access_token"];
    };
    return [self processs_request_with_module:@"order" params:[self build_up_with_params:params] file_list:nil is_alert:is_alert blockResult:blockResult blockRetry:blockRetry blockExpired:nil progress:nil];
}


#pragma mark  支付————余额+验证码
- (AFHTTPRequestOperation*)take_order_with_pay_password:(NSString*)pay_password_md5 subject_id:(NSString*)subject_id market_type:(NSInteger)market_type total_money_actual:(NSString*)total_money_actual bank_pay:(NSString*)bank_pay money_pay:(NSString*)money_pay interest_pay:(NSString*)interest_pay remaining_pay:(NSString*)remaining_pay total_money:(NSString*)total_money coupon_id:(NSString*)coupon_id is_alert:(BOOL)is_alert pay_key:(NSString *)pay_key blockResult:(resultBlock)blockResult blockRetry:(retryBlock)blockRetry
{
    NSNumber *p = nil;
    if ([bank_pay doubleValue] <= 0) {
        p = @(10);
    }else {
        p = @(20);
    }
    NSMutableDictionary* params = [[NSMutableDictionary alloc] initWithDictionary:@ {
        @"pay_password_md5":[pay_password_md5 md5],
        @"market_type":@(market_type),
        @"_id":subject_id,
        @"bank_pay":bank_pay,
        @"remaining_pay":remaining_pay,
        @"total_money":total_money,
        @"params":p,
        @"total_money_actual":total_money_actual,
        @"money_pay":money_pay,
        @"interest_pay":interest_pay,
        @"member_coupon_id":coupon_id?:@"",
        @"pay_way": pay_key,
        @"mobile_phone": [CMCore get_user_info_member][@"mobilePhone"]?:@"",
        @"member_id": [self get_user_info_member][@"id"]?:@"",
    }];
    if ([CMCore get_access_token]) {
        [params setValue:[CMCore get_access_token] forKey:@"access_token"];
    };
    return [self processs_request_with_module:@"/payOrder/payOrderReady" params:[self build_up_with_params:params] file_list:nil is_alert:is_alert blockResult:blockResult blockRetry:blockRetry blockExpired:nil progress:nil];
}

#pragma mark  支付验证码----余额＋银行
- (AFHTTPRequestOperation*)take_order_sms_code_bank_with_member_coupon_id:(NSString*)member_coupon_id total_money:(NSString*)total_money remaining_pay:(NSString*)remaining_pay bank_pay:(NSString*)bank_pay total_money_actual:(NSString*)total_money_actual subject_id:(NSString*)subject_id realname:(NSString*)realname mobile_phone:(NSString*)mobile_phone bank_card_id:(NSString*)bank_card_id id_card:(NSString*)id_card is_alert:(BOOL)is_alert blockResult:(resultBlock)blockResult blockRetry:(retryBlock)blockRetry {
    NSMutableDictionary* params = [[NSMutableDictionary alloc] initWithDictionary:@ {
        @"member_coupon_id":member_coupon_id?:@"",
        @"total_money": total_money,
        @"remaining_pay":remaining_pay,
        @"bank_pay":bank_pay,
        @"total_money_actual":total_money_actual,
        @"subject_id":subject_id,
        @"realname":realname,
        @"mobile_phone":mobile_phone,
        @"bank_card_id":bank_card_id,
        @"id_card":id_card,
        @"mobile_phone": [CMCore get_user_info_member][@"mobilePhone"]?:@"",
    }];
    if ([CMCore get_access_token]) {
        [params setValue:[CMCore get_access_token] forKey:@"access_token"];
    };
    return [self processs_request_with_module:@"order" params:[self build_up_with_params:params] file_list:nil is_alert:is_alert blockResult:blockResult blockRetry:blockRetry blockExpired:nil progress:nil];
}

#pragma mark  支付－－银行卡＋余额
- (AFHTTPRequestOperation*)order_pay_bank_with_market_type:(NSInteger)market_type order_id:(NSString*)order_id order_number:(NSString*)order_number sms_code:(NSString*)sms_code is_alert:(BOOL)is_alert pay_key: (NSString *)pay_key blockResult:(resultBlock)blockResult blockRetry:(retryBlock)blockRetry {
    NSMutableDictionary* params =[[NSMutableDictionary alloc] initWithDictionary: @ {
        @"market_type":@(market_type),
        @"order_id":order_id?:@"",
        @"order_number":order_number?:@"",
        @"sms_code":sms_code,
        @"pay_key": pay_key,
        @"mobile_phone": [CMCore get_user_info_member][@"mobilePhone"]?:@"",
    }];
    if ([CMCore get_access_token]) {
        [params setValue:[CMCore get_access_token] forKey:@"access_token"];
    };
    return [self processs_request_with_module:@"/payOrder/payOrderConfirm" params:[self build_up_with_params:params] file_list:nil is_alert:is_alert blockResult:blockResult blockRetry:blockRetry blockExpired:nil progress:nil];
}

#pragma mark  我的资产
- (AFHTTPRequestOperation*)get_my_money_with_is_alert:(BOOL)is_alert blockResult:(resultBlock)blockResult blockRetry:(retryBlock)blockRetry
{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] initWithDictionary:@
    {
        @"mobile_phone": [CMCore get_user_info_member][@"mobilePhone"]?:@"",
    }];
    if ([CMCore get_access_token] != nil || [CMCore get_access_token]) {
        [params setValue:[CMCore get_access_token] forKey:@"access_token"];
    };
    return [self processs_request_with_module:@"/home/myAssets" params:[self build_up_with_params:params] file_list:nil is_alert:is_alert blockResult:blockResult blockRetry:blockRetry blockExpired:nil progress:nil];
}

//#pragma mark  定期资产界面
//- (AFHTTPRequestOperation*)enter_product_detail_with_status:(NSInteger)status page:(NSInteger)page count:(NSInteger)count is_alert:(BOOL)is_alert blockResult:(resultBlock)blockResult blockRetry:(retryBlock)blockRetry
//{
//    NSMutableDictionary* params = [[NSMutableDictionary alloc] initWithDictionary: @
//    {
//        @"method": @"enter_product_detail",
//        @"access_token":[CMCore get_access_token]?:@"",
//        @"order_status":@(status),//200成功,300关闭
//        @"page":@(page),
//        @"count":@(count),
//        @"mobile_phone": [CMCore get_user_info_member][@"mobilePhone"]?:@"",
//    };
//    
//    return [self processs_request_with_module:@"member" params:[self build_up_with_params:params] file_list:nil is_alert:is_alert blockResult:blockResult blockRetry:blockRetry blockExpired:nil progress:nil];
//}

#pragma mark   投资记录
- (AFHTTPRequestOperation*)invest_record_with_status:(NSInteger)status page:(NSInteger)page count:(NSInteger)count is_alert:(BOOL)is_alert blockResult:(resultBlock)blockResult blockRetry:(retryBlock)blockRetry
{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] initWithDictionary:@
    {
        @"order_status":@(status),//200成功,300关闭
        @"page":@(page),
        @"count":@(count),
    }];
    if ([CMCore get_access_token]) {
        [params setValue:[CMCore get_access_token] forKey:@"access_token"];
    };
    return [self processs_request_with_module:@"order" params:[self build_up_with_params:params] file_list:nil is_alert:is_alert blockResult:blockResult blockRetry:blockRetry blockExpired:nil progress:nil];
}

#pragma mark   投资记录------新
- (AFHTTPRequestOperation*)invest_record_for_plan_with_status:(NSInteger)status market_type:(NSInteger)market_type page:(NSInteger)page count:(NSInteger)count is_alert:(BOOL)is_alert blockResult:(resultBlock)blockResult blockRetry:(retryBlock)blockRetry
{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] initWithDictionary:@
    {
        @"market_type":  @(market_type),
        @"order_status":@(status),
        @"page":@(page),
        @"count":@(count),
        @"mobile_phone": [CMCore get_user_info_member][@"mobilePhone"]?:@"",
    }];
    if ([CMCore get_access_token]) {
        [params setValue:[CMCore get_access_token] forKey:@"access_token"];
    };
    return [self processs_request_with_module:@"/home/marketRecord" params:[self build_up_with_params:params] file_list:nil is_alert:is_alert blockResult:blockResult blockRetry:blockRetry blockExpired:nil progress:nil];

}

#pragma mark   投资记录------旧 老客户
- (AFHTTPRequestOperation*)invest_record_with_status:(NSInteger)status market_type:(NSInteger)market_type page:(NSInteger)page count:(NSInteger)count is_alert:(BOOL)is_alert blockResult:(resultBlock)blockResult blockRetry:(retryBlock)blockRetry
{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] initWithDictionary: @
    {
        @"source":@"new_mfjc",
        @"method": @"market_record",
        @"market_type":  @(market_type),
        @"order_status":@(status),
        @"page":@(page),
        @"count":@(count),
        @"mobile_phone": [CMCore get_user_info_member][@"mobilePhone"]?:@""// @"15542779380"
    }];

    return [self processs_request_with_module:@"market" params:[self buildUpWithOldparams:params] file_list:nil is_alert:is_alert blockResult:blockResult blockRetry:blockRetry blockExpired:nil progress:nil];
    
}


#pragma mark   计划 投资记录详情
- (AFHTTPRequestOperation*)invest_record_for_plan_with_beePlanId:(NSString *)beePlanId is_alert:(BOOL)is_alert blockResult:(resultBlock)blockResult blockRetry:(retryBlock)blockRetry
{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] initWithDictionary: @
    {
        @"bee_plan_id": beePlanId,
    }];
    return [self processs_request_with_module:@"/home/beePlanDetails" params:[self build_up_with_params:params] file_list:nil is_alert:is_alert blockResult:blockResult blockRetry:blockRetry blockExpired:nil progress:nil];
}


#pragma mark  查看合同
- (AFHTTPRequestOperation*)contract_record_with_order_id:(NSString*)order_id  order_number:(NSString *)order_number is_alert:(BOOL)is_alert blockResult:(resultBlock)blockResult blockRetry:(retryBlock)blockRetry
{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] initWithDictionary: @
    {
        @"order_id":order_id ? : @"",
        @"order_no": order_number ? : @"",
        @"mobile_phone": [CMCore get_user_info_member][@"mobilePhone"]?:@"",
    }];
    return [self processs_request_with_module:@"order" params:[self build_up_with_params:params] file_list:nil is_alert:is_alert blockResult:blockResult blockRetry:blockRetry blockExpired:nil progress:nil];
}
#pragma mark  查看合同----old 老客户
- (AFHTTPRequestOperation*)contract_record_with_old_order_id:(NSString*)order_id  order_number:(NSString *)order_number is_alert:(BOOL)is_alert blockResult:(resultBlock)blockResult blockRetry:(retryBlock)blockRetry
{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] initWithDictionary: @
    {
        @"source":@"new_mfjc",
        @"method": @"contract_record_v2",
        @"order_id":order_id ? : @"",
        @"order_no": order_number ? : @"",
        @"mobile_phone": [CMCore get_user_info_member][@"mobilePhone"]?:@"",
    }];
    return [self processs_request_with_module:@"orderOld" params:[self buildUpWithOldparams:params] file_list:nil is_alert:is_alert blockResult:blockResult blockRetry:blockRetry blockExpired:nil progress:nil];
}


#pragma mark  获取vip特权列表
- (AFHTTPRequestOperation*)get_vip_list_with_is_alert:(BOOL)is_alert blockResult:(resultBlock)blockResult blockRetry:(retryBlock)blockRetry
{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] initWithDictionary: @
    {
        @"mobile_phone":[CMCore get_user_info_member][@"mobilePhone"]?:@"",
    }];
    if ([CMCore get_access_token]) {
        [params setValue:[CMCore get_access_token] forKey:@"access_token"];
    };
    return [self processs_request_with_module:@"/home/getVipList" params:[self build_up_with_params:params] file_list:nil is_alert:is_alert blockResult:blockResult blockRetry:blockRetry blockExpired:nil progress:nil];
}

#pragma mark  交易记录  资金明细
- (AFHTTPRequestOperation*)transaction_record_with_page:(NSInteger)page count:(NSInteger)count is_alert:(BOOL)is_alert blockResult:(resultBlock)blockResult blockRetry:(retryBlock)blockRetry
{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] initWithDictionary: @
    {
   
        @"page":@(page),
        @"count":@(count),
       
        @"mobile_phone":[CMCore get_user_info_member][@"mobilePhone"]?:@"",
    }];
    if ([CMCore get_access_token]) {
        [params setValue:[CMCore get_access_token] forKey:@"access_token"];
    };
    return [self processs_request_with_module:@"/home/transactionRecord" params:[self build_up_with_params:params] file_list:nil is_alert:is_alert blockResult:blockResult blockRetry:blockRetry blockExpired:nil progress:nil];
}
#pragma mark  理财产品记录
- (AFHTTPRequestOperation*)customer_product_list_with_is_alert:(BOOL)is_alert blockResult:(resultBlock)blockResult blockRetry:(retryBlock)blockRetry
{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] initWithDictionary: @
    {
        @"method": @"customerProduct_List",
        @"access_token":[CMCore get_access_token]?:@"",
        @"mobile_phone": [CMCore get_user_info_member][@"mobilePhone"]?:@"",
    }];
    return [self processs_request_with_module:@"/system/customerProduct_List" params:[self build_up_with_params:params] file_list:nil is_alert:is_alert blockResult:blockResult blockRetry:blockRetry blockExpired:nil progress:nil];
}

#pragma mark  理财产品记录 old 老客户
- (AFHTTPRequestOperation*)old_customer_product_list_with_is_alert:(BOOL)is_alert blockResult:(resultBlock)blockResult blockRetry:(retryBlock)blockRetry
{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] initWithDictionary: @
    {
        @"source":@"new_mfjc",
        @"method": @"customer_product_list",
        @"mobile_phone":[CMCore get_user_info_member][@"mobilePhone"]?:@""// @"13758253664"
    }];
    return [self processs_request_with_module:@"memberOld" params:[self buildUpWithOldparams:params] file_list:nil is_alert:is_alert blockResult:blockResult blockRetry:blockRetry blockExpired:nil progress:nil];
}

#pragma mark  获取正在提现金额
- (AFHTTPRequestOperation*)get_doing_withdraw_info_with_is_alert:(BOOL)is_alert blockResult:(resultBlock)blockResult blockRetry:(retryBlock)blockRetry
{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] initWithDictionary: @
    {
        
        @"mobile_phone": [CMCore get_user_info_member][@"mobilePhone"]?:@""
    }];
    if ([CMCore get_access_token]) {
        [params setValue:[CMCore get_access_token] forKey:@"access_token"];
    };
    return [self processs_request_with_module:@"/home/getDoingWithdrawInfo" params:[self build_up_with_params:params] file_list:nil is_alert:is_alert blockResult:blockResult blockRetry:blockRetry blockExpired:nil progress:nil];
}
#pragma mark  设置自动投标
- (AFHTTPRequestOperation*)auto_bid_enabled_with_enabled:(NSInteger)enabled is_alert:(BOOL)is_alert blockResult:(resultBlock)blockResult blockRetry:(retryBlock)blockRetry
{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] initWithDictionary: @
    {
        
        @"enabled":@(enabled),
        @"mobile_phone": [CMCore get_user_info_member][@"mobilePhone"]?:@"",
    }];
    if ([CMCore get_access_token]) {
        [params setValue:[CMCore get_access_token] forKey:@"access_token"];
    };
    return [self processs_request_with_module:@"member" params:[self build_up_with_params:params] file_list:nil is_alert:is_alert blockResult:blockResult blockRetry:blockRetry blockExpired:nil progress:nil];
}


#pragma mark  提现
- (AFHTTPRequestOperation*)submit_withdraw_with_money:(NSString*)money auth_code:(NSString*)auth_code is_alert:(BOOL)is_alert blockResult:(resultBlock)blockResult blockRetry:(retryBlock)blockRetry
{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] initWithDictionary: @
    {

        @"money":money,
        @"auth_code":auth_code,

        @"mobile_phone": [CMCore get_user_info_member][@"mobilePhone"]?:@"",
    }];
    if ([CMCore get_access_token]) {
        [params setValue:[CMCore get_access_token] forKey:@"access_token"];
    };
    return [self processs_request_with_module:@"/home/submitWithdraw" params:[self build_up_with_params:params] file_list:nil is_alert:is_alert blockResult:blockResult blockRetry:blockRetry blockExpired:nil progress:nil];
}
#pragma mark  获取提现记录
- (AFHTTPRequestOperation*)withdraw_list_with_page:(NSInteger)page count:(NSInteger)count is_alert:(BOOL)is_alert blockResult:(resultBlock)blockResult blockRetry:(retryBlock)blockRetry
{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] initWithDictionary:@
    {
        @"page":@(page),
        @"count":@(count),
        @"mobile_phone": [CMCore get_user_info_member][@"mobilePhone"]?:@"",
    }];
    if ([CMCore get_access_token]) {
        [params setValue:[CMCore get_access_token] forKey:@"access_token"];
    };
    return [self processs_request_with_module:@"/home/withdrawList" params:[self build_up_with_params:params] file_list:nil is_alert:is_alert blockResult:blockResult blockRetry:blockRetry blockExpired:nil progress:nil];
}
#pragma mark  获取所有理财券
- (AFHTTPRequestOperation*)get_red_packet_lis_with_is_alert:(BOOL)is_alert market_type:(NSArray *)market_type_array blockResult:(resultBlock)blockResult blockRetry:(retryBlock)blockRetry
{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] initWithDictionary: @
    {
        @"market_type":market_type_array,
        @"mobile_phone": [CMCore get_user_info_member][@"mobilePhone"]?:@"",
    }];
    if ([CMCore get_access_token]) {
        [params setValue:[CMCore get_access_token] forKey:@"access_token"];
    };
    return [self processs_request_with_module:@"/home/getMember_V2" params:[self build_up_with_params:params] file_list:nil is_alert:is_alert blockResult:blockResult blockRetry:blockRetry blockExpired:nil progress:nil];
}
/*get_red_packet_lis_with_is_alert*/
/*get_order_couold_use_coupon_list_with_product_id*/
#pragma mark  兑换理财券
- (AFHTTPRequestOperation*)exchange_red_packet_with_get_passwd:(NSString*)get_passwd is_alert:(BOOL)is_alert blockResult:(resultBlock)blockResult blockRetry:(retryBlock)blockRetry
{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] initWithDictionary: @
    {
        @"get_passwd":get_passwd,
        @"mobile_phone": [CMCore get_user_info_member][@"mobilePhone"]?:@"",
        
    }];
    return [self processs_request_with_module:@"/system/exchangeGift_Bag" params:[self build_up_with_params:params] file_list:nil is_alert:is_alert blockResult:blockResult blockRetry:blockRetry blockExpired:nil progress:nil];
}
#pragma mark  获取历史礼包
- (AFHTTPRequestOperation*)get_historyPacket_lis_with_is_alert:(BOOL)is_alert type:(NSInteger)type blockResult:(resultBlock)blockResult blockRetry:(retryBlock)blockRetry
{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] initWithDictionary:@
    {
        @"market_type":@(type),
        @"mobile_phone": [CMCore get_user_info_member][@"mobilePhone"]?:@"",
    }];
    if ([CMCore get_access_token]) {
        [params setValue:[CMCore get_access_token] forKey:@"access_token"];
    };
    return [self processs_request_with_module:@"/home/getMemberHistory_V2" params:[self build_up_with_params:params] file_list:nil is_alert:is_alert blockResult:blockResult blockRetry:blockRetry blockExpired:nil progress:nil];
}

#pragma mark  获取可用理财券－－ 支付时
- (AFHTTPRequestOperation*)get_order_couold_use_coupon_list_with_product_id:(NSString*)product_id is_alert:(BOOL)is_alert market_type:(NSInteger)market_type_interger blockResult:(resultBlock)blockResult blockRetry:(retryBlock)blockRetry
{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] initWithDictionary:@
    {
        @"subject_id":product_id,
        @"market_type":@(market_type_interger),
        @"mobile_phone": [CMCore get_user_info_member][@"mobilePhone"]?:@"",
    }];
    if ([CMCore get_access_token]) {
        [params setValue:[CMCore get_access_token] forKey:@"access_token"];
    };
    return [self processs_request_with_module:@"/system/getCoupon_List" params:[self build_up_with_params:params] file_list:nil is_alert:is_alert blockResult:blockResult blockRetry:blockRetry blockExpired:nil progress:nil];
}
#pragma mark  获取用户拥有的所有理财券
- (AFHTTPRequestOperation*)get_member_coupon_list_with_is_alert:(BOOL)is_alert blockResult:(resultBlock)blockResult blockRetry:(retryBlock)blockRetry
{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] initWithDictionary:@
    {
        @"mobile_phone": [CMCore get_user_info_member][@"mobilePhone"]?:@"",
    }];
    if ([CMCore get_access_token]) {
        [params setValue:[CMCore get_access_token] forKey:@"access_token"];
    };
    return [self processs_request_with_module:@"coupon" params:[self build_up_with_params:params] file_list:nil is_alert:is_alert blockResult:blockResult blockRetry:blockRetry blockExpired:nil progress:nil];
}

#pragma mark  兑换优惠券
- (AFHTTPRequestOperation*)exchange_coupon_with_get_passwd:(NSString*)get_passwd is_alert:(BOOL)is_alert blockResult:(resultBlock)blockResult blockRetry:(retryBlock)blockRetry
{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] initWithDictionary: @
    {
        @"get_passwd":get_passwd,
        @"mobile_phone": [CMCore get_user_info_member][@"mobilePhone"]?:@"",
    }];
    if ([CMCore get_access_token]) {
        [params setValue:[CMCore get_access_token] forKey:@"access_token"];
    };
    return [self processs_request_with_module:@"/home/exchangeGift_Bag" params:[self build_up_with_params:params] file_list:nil is_alert:is_alert blockResult:blockResult blockRetry:blockRetry blockExpired:nil progress:nil];
}

#pragma mark  分享
- (AFHTTPRequestOperation*)share_with_key:(NSString*)key platform:(NSString*)plateform is_alert:(BOOL)is_alert blockResult:(resultBlock)blockResult blockRetry:(retryBlock)blockRetry
{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] initWithDictionary:@
    {
        @"key":key,
        @"platform":plateform,
        @"mobile_phone": [CMCore get_user_info_member][@"mobilePhone"]?:@"",
        //key（暂时有''应用分享）
        //platform('ios', 'android', 'web', 'wechat', 选择一个)
        
    }];
    if ([CMCore get_access_token]) {
        [params setValue:[CMCore get_access_token] forKey:@"access_token"];
    };
    return [self processs_request_with_module:@"share" params:[self build_up_with_params:params] file_list:nil is_alert:is_alert blockResult:blockResult blockRetry:blockRetry blockExpired:nil progress:nil];
}
#pragma mark  邀请列表
- (AFHTTPRequestOperation*)invited_list_with_page:(NSInteger)page count:(NSInteger)count is_alert:(BOOL)is_alert blockResult:(resultBlock)blockResult blockRetry:(retryBlock)blockRetry
{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] initWithDictionary:@
    {
        @"mobile_phone": [CMCore get_user_info_member][@"mobilePhone"]?:@"",
        @"count":@(count),
        @"page":@(page),
    }];
    if ([CMCore get_access_token]) {
        [params setValue:[CMCore get_access_token] forKey:@"access_token"];
    };
    return [self processs_request_with_module:@"member" params:[self build_up_with_params:params] file_list:nil is_alert:is_alert blockResult:blockResult blockRetry:blockRetry blockExpired:nil progress:nil];
}

#pragma mark 线下产品标的 old 老客户
- (AFHTTPRequestOperation*)get_subject_order_list_with_fp_order_id:(NSString*)fp_order_id is_alert:(BOOL)is_alert blockResult:(resultBlock)blockResult blockRetry:(retryBlock)blockRetry
{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] initWithDictionary: @
    {
        @"method": @"get_subject_order_list_with_fp_order_id",
        @"source":@"new_mfjc",
        @"fp_order_id":fp_order_id,
        @"mobile_phone": [CMCore get_user_info_member][@"mobilePhone"]?:@"",
    }];
    
    return [self processs_request_with_module:@"fp_orderOld" params:[self buildUpWithOldparams:params] file_list:nil is_alert:is_alert blockResult:blockResult blockRetry:blockRetry blockExpired:nil progress:nil];
}
#pragma mark  绑定银行卡前获取的短信
- (AFHTTPRequestOperation*)bank_card_send_sms_before_confirm_with_realname:(NSString*)realname mobile_phone:(NSString*)mobile_phone bank_card_id:(NSString*)bank_card_id id_card:(NSString*)id_card user_mobile_phone:(NSString*)user_mobile_phone bank_name:(NSString*)bank_name member_id:(NSString *)member_id bank_code:(NSString *)bank_code is_alert:(BOOL)is_alert blockResult:(resultBlock)blockResult blockRetry:(retryBlock)blockRetry
{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] initWithDictionary:@
    {

        @"mobile_phone":[CMCore get_user_info_member][@"mobilePhone"],
        @"bank_realname":realname,
        @"bank_mobile_phone":mobile_phone,
        @"bank_card_id":bank_card_id,
        @"id_card":id_card,
        @"bank_name":bank_name,
        @"member_id":member_id,
        @"bank_code":bank_code,
    }];
    if ([CMCore get_access_token]) {
        [params setValue:[CMCore get_access_token] forKey:@"access_token"];
    };
    return [self processs_request_with_module:@"/system/bankCardSendConfirm" params:[self build_up_with_params:params] file_list:nil is_alert:is_alert blockResult:blockResult blockRetry:blockRetry blockExpired:nil progress:nil];
}
#pragma mark  绑定银行卡
- (AFHTTPRequestOperation*)bank_card_confirm_with_order_no:(NSString*)order_no sms_code:(NSString*)sms_code is_alert:(BOOL)is_alert bank_name:(NSString*)bank_name blockResult:(resultBlock)blockResult blockRetry:(retryBlock)blockRetry
{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] initWithDictionary:@
    {
        @"order_no":order_no,
        @"sms_code":sms_code,
        @"bank_name":bank_name,
        @"mobile_phone": [CMCore get_user_info_member][@"mobilePhone"]?:@"",
    }];
    if ([CMCore get_access_token]) {
        [params setValue:[CMCore get_access_token] forKey:@"access_token"];
    };
    return [self processs_request_with_module:@"/system/createPayConfirm" params:[self build_up_with_params:params] file_list:nil is_alert:is_alert blockResult:blockResult blockRetry:blockRetry blockExpired:nil progress:nil];
}
#pragma mark 获取基础配置，如launch_image
- (AFHTTPRequestOperation*)get_basic_config_is_alert:(BOOL)is_alert blockResult:(resultBlock)blockResult blockRetry:(retryBlock)blockRetry
{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] initWithDictionary: @
    {
        @"platform":@"ios",
        @"create_from":@"mfjczsb",
        @"mobile_phone": [CMCore get_user_info_member][@"mobilePhone"]?:@"",
    }];
    
    return [self processs_request_with_module:@"/system/basicConfig" params:[self build_up_with_params:params] file_list:nil is_alert:is_alert blockResult:blockResult blockRetry:blockRetry blockExpired:nil progress:nil];
}

#pragma mark 获取消息小站
- (AFHTTPRequestOperation*)get_stationBee_list_with_page:(NSInteger)page count:(NSInteger)count is_alert:(BOOL)is_alert  blockResult:(resultBlock)blockResult blockRetry:(retryBlock)blockRetry
{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] initWithDictionary: @
    {
        @"page":@(page),
        @"count":@(count),
        @"mobile_phone": [CMCore get_user_info_member][@"mobilePhone"]?:@"",
    }];
    if ([CMCore get_access_token]) {
        [params setValue:[CMCore get_access_token] forKey:@"access_token"];
    };
    return [self processs_request_with_module:@"/system/messageList" params:[self build_up_with_params:params] file_list:nil is_alert:is_alert blockResult:blockResult blockRetry:blockRetry blockExpired:nil progress:nil];
}

#pragma mark 判断是否是新手
- (AFHTTPRequestOperation*)judge_is_new_client_is_alert:(BOOL)is_alert  blockResult:(resultBlock)blockResult blockRetry:(retryBlock)blockRetry
{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] initWithDictionary: @
    {
        @"mobile_phone": [CMCore get_user_info_member][@"mobilePhone"]?:@"",
    }];
    if ([CMCore get_access_token]) {
        [params setValue:[CMCore get_access_token] forKey:@"access_token"];
    };
    return [self processs_request_with_module:@"/system/orderNewer_Check" params:[self build_up_with_params:params] file_list:nil is_alert:is_alert blockResult:blockResult blockRetry:blockRetry blockExpired:nil progress:nil];
}

#pragma mark - vip 领取礼券
- (AFHTTPRequestOperation*)getVipGiftBagWithCoupon_id:(NSString *)coupon_id is_alert:(BOOL)is_alert  blockResult:(resultBlock)blockResult blockRetry:(retryBlock)blockRetry
{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] initWithDictionary: @
    {
        @"coupon_id": coupon_id,
        @"mobile_phone": [CMCore get_user_info_member][@"mobilePhone"]?:@"",
    }];
    if ([CMCore get_access_token]) {
        [params setValue:[CMCore get_access_token] forKey:@"access_token"];
    };
    return [self processs_request_with_module:@"/home/receive" params:[self build_up_with_params:params] file_list:nil is_alert:is_alert blockResult:blockResult blockRetry:blockRetry blockExpired:nil progress:nil];
}


@end
