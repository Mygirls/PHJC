//
//  Core+Other.m
//  BeeEnrichmentAppiOS
//
//  Created by dll on 16/6/24.
//  Copyright © 2016年 didai. All rights reserved.
//

#import "Core+Other.h"
#import <sys/utsname.h>
#import "TransferPayViewController.h"
#import "SetPayPasswordViewController.h"
#import "PayViewController.h"
#import "LoginNavigationController.h"
#import "CheckLoginPasswordViewController.h"

#import <FUMobilePay/FUMobilePay.h>
#import <FUMobilePay/NSString+Extension.h>

@implementation Core (Other)
- (NSString*)app_version
{
    NSDictionary* info = [[NSBundle mainBundle] infoDictionary];
    NSString *version = [info objectForKey:@"CFBundleShortVersionString"];
    return version;
}

//最新版本
- (NSString *)last_version
{
    NSMutableURLRequest *url_request = [[NSMutableURLRequest alloc] init];
    NSString *str = [NSString stringWithFormat:@"https://itunes.apple.com/lookup?id=%@",APP_ID];
    NSString *last_version = @"";
    
    [url_request setURL:[NSURL URLWithString:str]];
    [url_request setHTTPMethod:@"POST"];
    [url_request setTimeoutInterval:10.0];
    NSData *result_data = [NSURLConnection sendSynchronousRequest:url_request returningResponse:nil error:nil];// 发送同步请求
    if (result_data) {
        NSDictionary *json_dic = [NSJSONSerialization JSONObjectWithData:result_data options:0 error:nil];
        NSArray *info_ary = [json_dic objectForKey:@"results"];
        if ([info_ary count]) {
            NSDictionary *dic = [info_ary objectAtIndex:0];
            last_version = [dic objectForKey:@"version"];
            [JPConfigCurrent setObject:last_version forKey:@"last_version"];
        }
    }
    return last_version;
}


#pragma mark 检查版本
- (void)check_version {
    
    [CMCore get_basic_config_is_alert:YES blockResult:^(NSNumber *code, id result, NSString *message) {
        
        if (result) {
            if ([result[@"mustUpdate"] integerValue]) {
                if ([[CMCore app_version] compare:result[@"iosNewestVersion"]] == NSOrderedAscending) {
                    [[JPAlert current] showAlertWithTitle:@"版本更新" content:@"当前不是最新版本，请前去更新" button:@[@"更新"] block:^(UIAlertView *alert, NSInteger index) {
                        NSString *str = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@", result[@"appId"]?:APP_ID];
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
                    }];
                }
            }else {
                // 先判断是否需要更新，再判断版本号
                if ([result[@"enableUpdate"] integerValue]) {
                    if ([[CMCore app_version] compare:result[@"iosNewestVersion"]] == NSOrderedAscending) {
                        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                        [defaults removeObjectForKey:@"Fingerprint_token"];
                        [defaults removeObjectForKey:@"isChoose"];
                        [[JPAlert current] showAlertWithTitle:@"版本更新" content:@"有可用的新版本，前去更新?" button:@[@"取消", @"更新"] block:^(UIAlertView *alert, NSInteger index) {
                            if (index == 1) {
                                NSString *str = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@", result[@"appId"]?:APP_ID];
                                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
                            }
                        }];
                    }
                }
            }

        }
    } blockRetry:^(NSInteger index) {
        if (index == 1) {
            [self check_version];
            
        }
    }];
}

//拨打电话
- (void)call_service_phone_with_view:(UIView *)view phone:(NSString *)phone {
    
    NSRange rg = {8,4};
    
    NSString *now_date_str = [[NSDate getCurrentTime] substringWithRange:rg];//hhmm
    NSInteger now_date_int = [now_date_str integerValue];
    if ((now_date_int >= 900 && now_date_int <= 2130)) { //在工作时间段内
        
        NSString *phoneNum = phone;// 电话号码
        NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",phoneNum]];
        
        if ( !self.phoneCallWebView ) {
            self.phoneCallWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
            [view addSubview:self.phoneCallWebView];
        }
        [self.phoneCallWebView loadRequest:[NSURLRequest requestWithURL:phoneURL]];
        
    }else {
        [[JPAlert current] showAlertWithTitle:@"温馨提示" content:@"服务时间：工作日9:00-21:30" button:@"好的" block:^(UIAlertView *alert, NSInteger index) {
            
        }];
    }
}

//评论
- (void)showComment {
    if (self.alert == nil) {
        self.alert = [[NSBundle mainBundle] loadNibNamed:@"AlertView" owner:nil options:nil].firstObject;
    }
    if ([CMCore get_launch_image_info]
        && [[CMCore get_launch_image_info][@"enable_comment"] boolValue]
        && ([CMCore enabledComment]==0 || [CMCore enabledComment]==2)) {
        
        int x = arc4random()%20+1;  //0没有出现过，1，去瞅瞅 2，稍后再说 3，不再出现
        if (x == 8) {
            [self.alert showCommentView];
        }
    }
}

- (NSString *)get_last_version {
    NSString *last_version = [JPConfigCurrent objectForKey:@"last_version"];
    return last_version;
}

#pragma mark 是否登录，是否有paypassword 是否有绑定银行卡
- (void)check_isLogin_isHavePaypassword_isHaveBankCard_with_vc:(JPViewController*)vc data_dic:(ProductsDetailModel *)data_dic alertString:(NSString *)alertString judgeStr:(NSString *)judgeStr
{
    if ([CMCore is_login]) {
        NSDictionary *user_info_dic = [CMCore get_user_info_member];
        
        if ([CMCore get_bank_card_info]) { // 是否绑定银卡
            if ([user_info_dic[@"hasPayPassword"] boolValue]) { // 判断是否有支付密码  //已经绑定银行卡且有支付密码
              
                if ([[[CMCore get_bank_card_info] allKeys] containsObject:@"bankCardId"] && [CMCore get_bank_card_info][@"bankCardId"]) {
                    if ([judgeStr isEqualToString:@"normal"]) {
                        PayViewController *pay_vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"PayViewController"];
                        pay_vc.data_dic = data_dic;
                        [vc go_next:pay_vc animated:YES viewController:vc];
                        
                    }else {
                        TransferPayViewController * tPay_vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"TransferPayViewController"];
                        tPay_vc.data_dic = data_dic;
                        [vc.navigationController pushViewController:tPay_vc animated:YES];
                    }
                }else {
                    [[JPAlert current] showAlertWithTitle:@"绑定银行卡" content:@"银行卡信息不完整" button:@[@"取消", @"去绑卡"] block:^(UIAlertView *alert, NSInteger index) {
                        if (index == 1) {
                            //没有绑定银行卡，push to 绑定银行卡界面
                            BankCardInformationViewController *add_bank_vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"BankCardInformationViewController"];
                            add_bank_vc.data_dic = data_dic;
                            add_bank_vc.typeOfStyle =  @"007";
                            [vc go_next:add_bank_vc animated:YES viewController:vc];
                        }
                    }];
                }
            }else {

                [[JPAlert current] showAlertWithTitle:@"温馨提示" content:@"请先设置支付密码" button:@[@"再看看", @"去设置"] block:^(UIAlertView *alert, NSInteger index) {
                    if (index == 1) {
                        //没有支付密码
                        SetPayPasswordViewController *set_paypassword_vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SetPayPasswordViewController"];
                        set_paypassword_vc.title = @"设置支付密码";
                        set_paypassword_vc.data_dic = data_dic;
                        [vc go_next:set_paypassword_vc animated:YES viewController:vc];
                        
//                        CheckLoginPasswordViewController *check_login_password_vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CheckLoginPasswordViewController"];
//                        //100 更新支付密码(有支付密码{修改/忘记支付密码}) 200 设置支付密码(没有支付密码)
//                        check_login_password_vc.type = 200;
//                        check_login_password_vc.data_dic = data_dic;
//                        [vc.navigationController pushViewController:check_login_password_vc animated:YES];
                    }
                }];
                
                
                
            }
            
        }else {
            [[JPAlert current] showAlertWithTitle:@"绑定银行卡" content:alertString button:@[@"取消", @"去绑卡"] block:^(UIAlertView *alert, NSInteger index) {
                if (index == 1) {
                    //没有绑定银行卡，push to 绑定银行卡界面
                    BankCardInformationViewController *add_bank_vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"BankCardInformationViewController"];
                    add_bank_vc.data_dic = data_dic;
                    [vc go_next:add_bank_vc animated:YES viewController:vc];
                }
            }];
        }
        
        
    }else{
        //没有登录
        LoginNavigationController *login_navc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LoginNavigationController"];
        [vc presentViewController:login_navc animated:YES completion:nil];
    }
}

/**
 *  显示加载动画
 *
 *  @param flag YES 显示，NO 不显示
 */
- (void)showLoadingView:(BOOL)flag
{
    if (flag)
    {
        [self.theController.view addSubview:self.panelView];
        [self.loadingView startAnimating];
    }
    else
    {
        [self.panelView removeFromSuperview];
    }
}

#pragma mark 远程推送
- (void) register_push_with_application:(UIApplication *)application launchOptions:(NSDictionary *)launchOptions {
    //远程推送
    if ([application respondsToSelector:@selector(registerForRemoteNotifications)]) {
        
        [application registerUserNotificationSettings:[UIUserNotificationSettings
                                                       settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge)
                                                       categories:nil]];
        [application registerForRemoteNotifications];
        
    }else
    {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
}

/*
 price:需要处理的数字，
 position：保留小数点第几位，
 
 NSRoundDown代表的就是 四舍五入。
 NSRoundDown 只舍不入
 NSRoundPlain 四舍五入
 NSRoundUp 只入不舍
 */
-(NSString *)notRounding:(CGFloat)price afterPoint:(NSInteger)position {
    NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown scale:position raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    NSDecimalNumber *ouncesDecimal;
    NSDecimalNumber *roundedOunces;
    
    ouncesDecimal = [[NSDecimalNumber alloc] initWithFloat:price];
    roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    return [NSString stringWithFormat:@"%@",roundedOunces];
}

- (void)alertWithError:(NSError *)error
{
    NSString *result = nil;
    if (!error) {
        result = [NSString stringWithFormat:@"分享成功"];
    }
    else{
        NSMutableString *str = [NSMutableString string];
        if (error.userInfo) {
            for (NSString *key in error.userInfo) {
                [str appendFormat:@"%@ = %@\n", key, error.userInfo[key]];
            }
        }
        if (error) {
            
            if (error.code == 2009) {
                result = @"取消了分享";
            }else {
                result = [NSString stringWithFormat:@"Share fail with error code: %d\n%@",(int)error.code, str];
            }
            
        }
        else{
            result = [NSString stringWithFormat:@"分享失败"];
        }
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享"
                                                    message:result
                                                   delegate:nil
                                          cancelButtonTitle:NSLocalizedString(@"确定", @"sure")
                                          otherButtonTitles:nil];
    [alert show];
}

#pragma mark 分享
- (void)share_with_dict:(NSDictionary *)dict vc:(UIViewController *)vc {
    
    if ([CMCore is_login])
    {
        ShareKindsView *shareV = [ShareKindsView load_nib];
        shareV.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        shareV.clickShareBlock = ^(NSInteger index) {
            switch (index) {
                case 0://微信好友 SSDKPlatformSubTypeWechatSession
                {
                    
                    [self shareWebPageToPlatformType:UMSocialPlatformType_WechatSession title:dict[@"title"] contenText:dict[@"content"] ? dict[@"content"] : @"点击查看详情" share_url:dict[@"share_url"] image_url:UMS_THUMB_IMAGE];
                }
                    break;
                case 1://微信朋友圈 SSDKPlatformSubTypeWechatTimeline
                {
                    
                    [self shareWebPageToPlatformType:UMSocialPlatformType_WechatTimeLine title:dict[@"title"] contenText:dict[@"content"] ? dict[@"content"] : @"点击查看详情" share_url:dict[@"share_url"] image_url:UMS_THUMB_IMAGE];
                }
                    break;
                case 2://短信
                {
                    [self shareWebPageToPlatformType:UMSocialPlatformType_Sms title:dict[@"title"] contenText:dict[@"content"] ? dict[@"content"] : @"点击查看详情" share_url:dict[@"share_url"] image_url:UMS_THUMB_IMAGE];
                    
                    
                }
                    break;
                default:
                {
                    [SVProgressHUD dismiss];
                }
                    break;
            }
        };
        [shareV show];
    }
    else
    {
        [[JPAlert current] showAlertWithTitle:@"先登录后才可以分享哦" button:@"好的"];
        LoginNavigationController* login = [vc.storyboard instantiateViewControllerWithIdentifier:@"LoginNavigationController"];
        [vc.navigationController presentViewController:login animated:YES completion:nil];
    }
    
}


#pragma mark 友盟,网页分享
//网页分享
- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType title:(NSString *)title contenText:(NSString *)contentText share_url:(NSString *)share_url image_url:(NSString *)image_url
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    NSString* thumbURL = image_url;
    //    [NSString stringWithFormat:@"%@",__self.headView.imgView.image];
    //创建网页内容对象
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title descr:contentText thumImage:thumbURL];
    //设置网页地址
    
    if (platformType == UMSocialPlatformType_Sms) {
        shareObject.webpageUrl = [NSString stringWithFormat:@"%@: %@",title,share_url];
    }else {
        shareObject.webpageUrl = share_url;
    }
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                UMSocialLogInfo(@"response message is %@",resp.message);
                //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                
            }else{
                UMSocialLogInfo(@"response data is %@",data);
            }
        }
        [CMCore alertWithError:error];
    }];
}

#pragma mark 判断机型

- (NSString *)iphoneType {
    
    struct utsname systemInfo;
    
    uname(&systemInfo);
    
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    
    
    if ([platform isEqualToString:@"iPhone5,1"]) {
        return @"iPhone 5";
    }
    
    
    if ([platform isEqualToString:@"iPhone5,2"]) {
        return @"iPhone 5";
    }
    
    if ([platform isEqualToString:@"iPhone5,3"]) {
        return @"iPhone 5c";
    }
    
    if ([platform isEqualToString:@"iPhone5,4"]) {
        return @"iPhone 5c";
    }
    
    if ([platform isEqualToString:@"iPhone6,1"]) {
        return @"iPhone 5s";
    }
    
    if ([platform isEqualToString:@"iPhone7,1"]) {
        return @"iPhone 6 Plus";
    }
    if ([platform isEqualToString:@"iPhone7,2"]) {
        
    }
    
    if ([platform isEqualToString:@"iPhone8,1"]) {
        return @"iPhone 6s";
    }
    
    if ([platform isEqualToString:@"iPhone8,2"]) {
        
    }
    if ([platform isEqualToString:@"iPhone9,1"]) {
        return @"iPhone 7";
    }
    
    if ([platform isEqualToString:@"iPhone9,2"]) {
        return @"iPhone 7 Plus";
    }
    
    
    return platform;
    
}

- (NSString *)calculateForExpectedMoneyWithRate:(double)rate period:(NSInteger)period money:(double)money totalDay:(NSInteger )totalDay daysRemaining:(NSInteger)daysRemaining
{

    NSDecimalNumber *rateNumber = [[NSDecimalNumber alloc] initWithDouble:rate];
    NSDecimalNumber *periodNumber = [[NSDecimalNumber alloc] initWithLong:period];
    NSDecimalNumber *moneyNumber = [[NSDecimalNumber alloc] initWithDouble:money];
    NSDecimalNumber *totalDayNumber = [[NSDecimalNumber alloc] initWithLong:totalDay];
    NSDecimalNumber *monthNumber = [[NSDecimalNumber alloc] initWithLong:12];
    NSDecimalNumber *daysRemainingNumber = [[NSDecimalNumber alloc] initWithLong:daysRemaining];
    NSDecimalNumber *oneHundredNumber = [[NSDecimalNumber alloc] initWithLong:100];
    NSDecimalNumber *resultNumber;
    resultNumber = [[[[[[rateNumber decimalNumberByDividingBy:monthNumber] decimalNumberByMultiplyingBy:periodNumber] decimalNumberByMultiplyingBy:moneyNumber] decimalNumberByDividingBy:totalDayNumber] decimalNumberByMultiplyingBy:daysRemainingNumber] decimalNumberByDividingBy:oneHundredNumber];
    NSDecimalNumberHandler *handler = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown scale:2 raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:YES];
    resultNumber = [resultNumber decimalNumberByRoundingAccordingToBehavior:handler];
    return [resultNumber stringValue];
}

- (void)get_user_info
{
    
    [CMCore get_user_info_with_is_alert:YES blockResult:^(NSNumber *code, id result, NSString *message) {
        [SVProgressHUD dismiss];
        if ([code integerValue] == 200) {
            //成功获取用户信息
            //保存user_info
            [CMCore save_user_info_with_member:result[@"member"]];
            
            //保存 access_token
            //            [CMCore save_access_token:result[@"accessToken"]];
        }
    } blockRetry:^(NSInteger index) {
        [SVProgressHUD dismiss];
        if (index == 1) {
            [self get_user_info];
        }
    }];
}
#pragma mark 时间戳转换
- (NSString *)turnToDate:(NSString *)string
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    [fmt setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *timeDate = [[NSDate alloc] initWithTimeIntervalSince1970:[string longLongValue]/1000.0];
    NSString *timeStr = [fmt stringFromDate:timeDate];
    return timeStr;
}

#pragma mark 富友支付
- (void)fuyouPayWithOrderNo:(NSString *)orderNo payMoney:(double)payMoney bankCardInfoMD:(BankCardsModel *)bankCardInfoMD backCallUrl:(NSString *)backCallUrl
{
    
    NSString * myVERSION = [NSString stringWithFormat:@"2.0"] ; //SDK 接口版本参数  定值
    NSString * myMCHNTCD = MchntCd ; // 商户号
    NSString * myMCHNTORDERID = orderNo ;// 商户订单号
    NSString * myUSERID = [CMCore get_user_info_member][@"id"]; // 用户编号
    NSString * myAMT = [NSString stringWithFormat:@"%.0f", payMoney * 100];  // 注意: 富友的单位是分
    NSString * myBANKCARD = bankCardInfoMD.bankCardId; // 银行卡号
    NSString * myBACKURL = [NSString stringWithFormat:@"%@", backCallUrl] ; // 回调地址
    NSString * myNAME = bankCardInfoMD.realname; // 姓名
    NSString * myIDNO = bankCardInfoMD.idCard;// 证件编号
    NSString * myIDTYPE = @"0"; // 证件类型(目前只支持身份证)
    NSString * myTYPE = @"02";
    NSString * mySIGNTP = @"MD5";
    NSString * myMCHNTCDKEY = MyMCHNTCDKEY ;//商户秘钥
    NSString * mySIGN = [NSString stringWithFormat:@"%@|%@|%@|%@|%@|%@|%@|%@|%@|%@|%@|%@" , myTYPE,myVERSION,myMCHNTCD,myMCHNTORDERID,myUSERID,myAMT,myBANKCARD,myBACKURL,myNAME,myIDNO,myIDTYPE,myMCHNTCDKEY] ;
    mySIGN = [mySIGN MD5String] ; //签名字段
    NSDictionary * dicD = @{@"TYPE":myTYPE,@"VERSION":myVERSION,@"MCHNTCD":myMCHNTCD,@"MCHNTORDERID":myMCHNTORDERID,@"USERID":myUSERID,@"AMT":myAMT,@"BANKCARD":myBANKCARD,@"BACKURL":myBACKURL,@"NAME":myNAME,@"IDNO":myIDNO,@"IDTYPE":myIDTYPE,@"SIGNTP":mySIGNTP,@"SIGN":mySIGN , @"TEST" : [NSNumber numberWithBool:TestNumber]} ;
    FUMobilePay *pay = [FUMobilePay shareInstance];
    if([pay respondsToSelector:@selector(mobilePay:delegate:)])
        [pay performSelector:@selector(mobilePay:delegate:) withObject:dicD withObject:self];
}

#pragma mark H5地址管理  
// markType参数: 10计划标  20散标  30装让标
- (NSString *)getH5AddressWithEnterType:(H5EnterType ) enterType targeId:(NSString *)targeId markType:(NSInteger)markType {
    NSString *urlStr = nil;
    NSString *baseUrlStr = @"https://www.phjucai.com/web/bee/";
    switch (enterType) {
        case H5EnterTypeDetails:
            switch (markType) {
                case 10:
                    urlStr = [baseUrlStr stringByAppendingFormat:@"BeePlan/index.html?target_id=%@", targeId];
                    break;
                case 20:
                    urlStr = [baseUrlStr stringByAppendingFormat:@"Details/index.html?target_id=%@&access_token=%@", targeId, [CMCore get_access_token]];
                    break;
                case 30:
                    urlStr = [baseUrlStr stringByAppendingFormat:@"transfer/index.html?target_id=%@", targeId];
                    break;
                    
                default:
                    break;
            }
            break;
        case H5EnterTypeRecord:
            urlStr = [baseUrlStr stringByAppendingFormat:@"invest/index.html?target_id=%@&market_type=%zd", targeId, markType];
            break;
        case H5EnterTypeSecurity:
            urlStr = [baseUrlStr stringByAppendingString:@"article/index.html?article_id=68"];
            break;
        case H5EnterTypeInvitation:
            urlStr = [baseUrlStr stringByAppendingFormat:@"share/index.html?mobile_phone=%@",[CMCore get_user_info_member][@"mobilePhone"]];
            break;
        case H5EnterTypeInvitationDetails:
            urlStr = [baseUrlStr stringByAppendingFormat:@"InvitationDetails/index.html?mobile_phone=%@&access_token=%@", [CMCore get_user_info_member][@"mobilePhone"], [CMCore get_access_token]];
            break;
        case H5EnterTypeMemberLEVEL:
            urlStr = [baseUrlStr stringByAppendingFormat:@"MemberLEVEL/index.html"];
            break;
        case H5EnterTypeProblems:
            urlStr =[baseUrlStr stringByAppendingFormat:@"Problems/index.html"];
            break;
            
        case H5EnterTypeUserRegistered:
            urlStr = [baseUrlStr stringByAppendingFormat:@"contract/user/user_registered_protocol.html"];
            break;
            
        case  H5EnterTypeContractRisk:
            urlStr = [baseUrlStr stringByAppendingFormat:@"contract/risk/index.html"];
            break;
        case H5EnterTypeContractPlan:
            urlStr = [baseUrlStr stringByAppendingFormat:@"contract/plan/index.html"];
            break;
            
        case H5EnterTypeContractPay:
            urlStr = [baseUrlStr stringByAppendingFormat:@"contract/pay/Fuyou.html"];
            break;
        case H5EnterTypePlatformIntroduction:
            urlStr = [baseUrlStr stringByAppendingString:@"article/index.html?article_id=65"];//[baseUrlStr stringByAppendingFormat:@"platformIntroduction/platform_is_introduced.html" ];
            break;
        case H5EnterTypeSupportBank:
            urlStr = [baseUrlStr stringByAppendingFormat:@"supportBank/index.html" ];
            break;
        case H5EnterTypeTermsOfUseAndPrivacy:
            urlStr = [baseUrlStr stringByAppendingFormat:@"contract/user/privacy.html"];
            break;
        case H5EnterTypeAppContractRecordSubject:
            urlStr = [baseUrlStr stringByAppendingFormat:@"contract/user/app_contract_record_subject_demo.html"];
            break;
        case H5EnterTypeTermsOfUseAndPrivacyTranfer:
            urlStr = [baseUrlStr stringByAppendingString:@"termsOfUseAndPrivacy"];
            break;
        case H5EnterTypeContractTransfer:
            urlStr = [baseUrlStr stringByAppendingString:@"contract/transfer/index.html"];
            break;
        default:
            break;
    }
    return urlStr;
}



@end
