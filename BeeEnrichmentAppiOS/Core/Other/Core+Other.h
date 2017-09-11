//
//  Core+Other.h
//  BeeEnrichmentAppiOS
//
//  Created by dll on 16/6/24.
//  Copyright © 2016年 didai. All rights reserved.
//

#import "Core.h"
//#import <UMSocialCore/UMSocialCore.h>
#import "ProductsModel.h"
#import "UserModel.h"

@class ProductsDetailModel;


typedef NS_ENUM(NSInteger, H5EnterType) {
    H5EnterTypeDetails = 0, // 项目详情
    H5EnterTypeRecord, // 购买人数
    H5EnterTypeSecurity, // 安全保障
    H5EnterTypeInvitationDetails, // 邀请明细
    H5EnterTypeInvitation, // 邀请
    H5EnterTypeMemberLEVEL, // vip等级说明
    H5EnterTypeProblems, // 常见问题
    H5EnterTypeUserRegistered, // 用户注册协议及隐私政策
    H5EnterTypeContractRisk, // 投资风险告知书
    H5EnterTypeContractPlan, // 计划授权委托书
    H5EnterTypeAppContractRecordSubject, // 标的合同协议
    H5EnterTypeContractPay, // 专用账户协议
    H5EnterTypePlatformIntroduction, // 产品简介 关于我们
    H5EnterTypeSupportBank, // 支持银行
    H5EnterTypeTermsOfUseAndPrivacy, // 绑卡: 使用条款和隐私
//    H5EnterTypePaymentAgreement, // 绑卡: 专用账户协议
//    H5EnterTypeElectronicSigningAgreement, // 绑卡: 快捷签署服务委托协议
    H5EnterTypeTermsOfUseAndPrivacyTranfer, // 转让: 使用条款和隐私政策
    H5EnterTypeContractTransfer // 债权转让协议
    
};
@interface Core (Other)

- (NSString*)app_version;

//最新版本
- (NSString *)last_version;

#pragma mark 判断当前版本
- (void)check_version;
- (NSString *)get_last_version;

//拨打电话
- (void)call_service_phone_with_view:(UIView *)view phone:(NSString *)phone;

//评论
- (void)showComment;

#pragma mark 是否登录，是否有paypassword 是否有绑定银行卡
- (void)check_isLogin_isHavePaypassword_isHaveBankCard_with_vc:(JPViewController*)vc
                                                      data_dic:(ProductsDetailModel *)data_dic
                                                   alertString:(NSString *)alertString
                                                      judgeStr:(NSString *)judgeStr;

- (void) register_push_with_application:(UIApplication *)application
                          launchOptions:(NSDictionary *)launchOptions;

-(NSString *)notRounding:(CGFloat)price
              afterPoint:(NSInteger)position;//只舍不入

- (void)showLoadingView:(BOOL)flag;
- (void)alertWithError:(NSError *)error;
- (void)share_with_dict:(NSDictionary *)dict vc:(UIViewController *)vc;
- (NSString *)iphoneType;

#pragma mark 月预期收益
- (NSString *)calculateForExpectedMoneyWithRate:(double)rate
                                         period:(NSInteger)period
                                          money:(double)money
                                       totalDay:(NSInteger )totalDay
                                  daysRemaining:(NSInteger)daysRemaining;

#pragma mark 时间戳转换
- (NSString *)turnToDate:(NSString *)string;

#pragma mark H5地址管理
- (NSString *)getH5AddressWithEnterType:(H5EnterType ) enterType
                                targeId:(NSString *)targeId
                               markType:(NSInteger)markType;

#pragma mark 富友支付
- (void)fuyouPayWithOrderNo:(NSString *)orderNo
                   payMoney:(double)payMoney
             bankCardInfoMD:(BankCardsModel *)bankCardInfoMD
                backCallUrl:(NSString *)backCallUrl;


@end
