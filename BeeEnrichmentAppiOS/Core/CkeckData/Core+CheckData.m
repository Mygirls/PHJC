//
//  Core+CheckData.m
//  BeeEnrichmentAppiOS
//
//  Created by dll on 16/6/24.
//  Copyright © 2016年 didai. All rights reserved.
//

#import "Core+CheckData.h"

@implementation Core (CheckData)
- (NSString *)trim:(NSString *)string
{
    return [string stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
}
//手机号是否规范
- (BOOL)checkPhoneValid:(NSString *)string
{
    if ([[self trim:string] length]==11) {
        NSString *regex = @"^[1|0]\\d{10}$";
//        NSString *regex = @"^1(3\\d|5\\d|7[017]|8[0-35-9])\\d{8}$";
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
        BOOL isMatch = [pred evaluateWithObject:string];
        return isMatch;
    } else {
        return NO;
    }
}
//身份证号是否规范
- (BOOL)checkIDCardValid:(NSString *)string
{
    if ([[self trim:string] length]==18) {
        NSString *regex = @"^[0-9]{6}[0-9]{4}((0[0-9])|(1[0-2]))(([0|1|2][0-9])|3[0-1])[0-9]{3}([0-9]|X)$";
        //^[0-9]{17}([0-9]|X)$
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
        BOOL isMatch = [pred evaluateWithObject:string];
        return isMatch;
    }else if([[self trim:string] length] == 15) {
        NSString *regex = @"^[1-9]{6}[0-9]{2}((0[0-9])|(1[0-2]))(([0|1|2][0-9])|3[0-1])[0-9]{3}$";
        //^[0-9]{17}([0-9]|X)$
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
        BOOL isMatch = [pred evaluateWithObject:string];
        return isMatch;
    }else {
        return NO;
    }
    
}
//提现密码是否规范
- (BOOL)check_password_valid:(NSString *)string {
    if ([[self trim:string] length]==6) {
        NSString *regex = @"[0-9]{6}";
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
        BOOL isMatch = [pred evaluateWithObject:string];
        return isMatch;
    }
    else {
        return NO;
    }
}
//登录密码（修改登录密码）
- (BOOL)check_login_pasword_valid:(NSString *)string {
    if (string.length < 6 || string.length > 16) {
        return NO;
    }
    return ![self IsChinese:string];
}
//判断是否有中文
-(BOOL)IsChinese:(NSString *)str {
    for(int i=0; i< [str length];i++){
        int a = [str characterAtIndex:i];
        if((a > 0x4e00 && a < 0x9fff)|| a == 0x20)//0x20空格
        {
            return YES;
        }
    }
    return NO;
    
}
//输入的金额是否规范
- (BOOL)check_moneyValid:(NSString *)string {
    NSString *regex = @"^(\\d*$|(^\\d+(.\\d{1,2})?$))$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    if ([pred evaluateWithObject:string] && [string doubleValue] >= 0.01) {
        return YES;
    }
    return NO;
}
//是否是纯数字（里程，银行卡号，验证码）
- (BOOL)checkNumberValid:(NSString *)string {
    NSString *regex = @"^[0-9]*$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    if ([pred evaluateWithObject:string]) {
        return YES;
    }
    return NO;
}

//输入的姓名是否是中文2-5个汉字
- (BOOL)checkNameValid:(NSString *)string {
    NSString *regex = @"^([\u4e00-\u9fa5]){2,5}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    if ([pred evaluateWithObject:string]) {
        return YES;
    }
    return NO;
}
//#pragma mark 验证码
////验证码重发倒计时
//- (void)start_timer:(UIButton *)button {
//    [self stop_timer:button];
//    button.backgroundColor = [UIColor whiteColor];
//    button = button;
//    [button setTitle:@"60秒后重发" forState:UIControlStateNormal];
//    button.alpha = 0.5;
//    button.enabled = NO;
//    self.timer_count = 59;
//    self.timer_for_code = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timer_action:) userInfo:nil repeats:YES];
//}
////
//- (void)stop_timer:(UIButton *)button {
//    if(self.timer_for_code)
//    {
//        [self.timer_for_code invalidate];
//        self.timer_for_code = nil;
//        [button setTitle:@"发送验证码" forState:UIControlStateNormal];
//        button.alpha = 1.0f;
//        button.enabled = YES;
//    }
//}
////验证码
//- (void)timer_action:(id)sender {
//    if(self.timer_count > 0)
//    {
//        NSString *title = [NSString stringWithFormat:@"%d秒后重发",(int)self.timer_count];
//        self.button.titleLabel.text = title;
//        [self.button setTitle:title forState:UIControlStateNormal];
//    }
//    else
//    {
//        [self stop_timer:self.button];
//        [self.button setTitle:@"发送验证码" forState:UIControlStateNormal];
//        self.button.alpha = 1.0f;
//        self.button.enabled = YES;
//        
//    }
//    self.timer_count--;
//}
@end
