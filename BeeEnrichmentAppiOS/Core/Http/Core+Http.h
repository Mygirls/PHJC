//
//  Core+Http.h
//  CarMirrorAppiOS
//
//  Created by renpan on 15/9/21.
//  Copyright © 2015年 HangZhouShangFu. All rights reserved.
//

#import "Core.h"

@interface Core (Http)
#pragma mark  登录
- (AFHTTPRequestOperation*)login_with_mobile_phone:(NSString*)mobile_phone password:(NSString*)password is_alert:(BOOL)is_alert blockResult:(resultBlock)blockResult blockRetry:(retryBlock)blockRetry;

#pragma mark  快速登录
- (AFHTTPRequestOperation*)fast_login_with_mobile:(NSString*)mobile auth_code:(NSString*)auth_code is_alert:(BOOL)is_alert blockResult:(resultBlock)blockResult blockRetry:(retryBlock)blockRetry;
#pragma mark  注册
- (AFHTTPRequestOperation*)register_with_mobile_phone:(NSString*)mobile_phone auth_code:(NSString*)auth_code password:(NSString *)password invite_code:(NSString*)invite_code is_alert:(BOOL)is_alert blockResult:(resultBlock)blockResult blockRetry:(retryBlock)blockRetry;
#pragma mark  指纹支付发送验证短信
-(AFHTTPRequestOperation*)sendCheckMessageWithIs_alert:(BOOL)is_alert blockResult:(resultBlock)blockResult blockRetry:(retryBlock)blockRetry ;
#pragma mark  指纹支付验证短信
-(AFHTTPRequestOperation*)checkMessageWithFingerprint_token:(NSString *)fingerprint_token andCode:(NSString *)code is_alert:(BOOL)is_alert blockResult:(resultBlock)blockResult blockRetry:(retryBlock)blockRetry;
#pragma mark  指纹支付确认
-(AFHTTPRequestOperation*)take_order_with_payWithFinger:(NSString *)finger  isSuccess:(BOOL )isSuccess subject_id:(NSString *)subject_id market_type:(NSInteger)market_type total_money_actual:(NSString*)total_money_actual money_pay:(NSString *)money_pay interest_pay:(NSString *)interest_pay remaining_pay:(NSString*)remaining_pay total_money:(NSString*)total_money coupon_id:(NSString*)coupon_id is_alert:(BOOL)is_alert blockResult:(resultBlock)blockResult blockRetry:(retryBlock)blockRetry;
#pragma mark  忘记登陆密码／修改登录密码
- (AFHTTPRequestOperation*)update_password_mobile_phone:(NSString*)mobile_phone auth_code:(NSString*)auth_code password:(NSString *)password is_alert:(BOOL)is_alert blockResult:(resultBlock)blockResult blockRetry:(retryBlock)blockRetry;
#pragma mark  设置交易密码/修改支付密码
- (AFHTTPRequestOperation*)update_pay_passwd_with_pay_password:(NSString*)pay_password is_alert:(BOOL)is_alert blockResult:(resultBlock)blockResult blockRetry:(retryBlock)blockRetry;
#pragma mark  验证登录密码
- (AFHTTPRequestOperation*)auth_login_passwd_with_login_passwd:(NSString*)login_passwd is_alert:(BOOL)is_alert blockResult:(resultBlock)blockResult blockRetry:(retryBlock)blockRetry;
#pragma mark  老用户验证
- (AFHTTPRequestOperation*)auth_verify_with_login_member_id:(NSString*)member_id user_name:(NSString*)user_name auth_code:(NSString*)auth_code mobile_phone:(NSString*)mobile_phone is_alert:(BOOL)is_alert blockResult:(resultBlock)blockResult blockRetry:(retryBlock)blockRetry;
#pragma mark  短信验证码
- (AFHTTPRequestOperation*)get_auth_code_with_with_mobile_phone:(NSString*)mobile_phone  is_alert:(BOOL)is_alert blockResult:(resultBlock)blockResult blockRetry:(retryBlock)blockRetry;
#pragma mark  用户信息
- (AFHTTPRequestOperation*)get_user_info_with_is_alert:(BOOL)is_alert blockResult:(resultBlock)blockResult blockRetry:(retryBlock)blockRetry;
#pragma mark  用户头像
- (AFHTTPRequestOperation*)update_user_head_url_with_head_image:(UIImage *)head_image is_alert:(BOOL)is_alert blockResult:(resultBlock)blockResult blockRetry:(retryBlock)blockRetry;
#pragma mark  我的二维码
- (AFHTTPRequestOperation*)my_qrcode_with_is_alert:(BOOL)is_alert blockResult:(resultBlock)blockResult blockRetry:(retryBlock)blockRetry;
#pragma mark  获取推荐列表
- (AFHTTPRequestOperation*)get_recommend_is_alert:(BOOL)is_alert blockResult:(resultBlock)blockResult blockRetry:(retryBlock)blockRetry;
#pragma mark   新首页轮播列表
- (AFHTTPRequestOperation*)get_recommend_carousel_is_alert:(BOOL)is_alert blockResult:(resultBlock)blockResult blockRetry:(retryBlock)blockRetry;
#pragma mark  获取理财超市列表
- (AFHTTPRequestOperation*)get_subject_list_with_subject_status:(NSInteger)subject_status page:(NSInteger)page count:(NSInteger)count is_alert:(BOOL)is_alert  blockResult:(resultBlock)blockResult blockRetry:(retryBlock)blockRetry;
#pragma mark  理财产品详情
- (AFHTTPRequestOperation*)get_subject_detail_with_subject_id:(NSString *)subject_id market_type:(NSInteger)market_type is_alert:(BOOL)is_alert blockResult:(resultBlock)blockResult blockRetry:(retryBlock)blockRetry;
#pragma mark  获取银行列表
- (AFHTTPRequestOperation*)get_bank_list_with_is_alert:(BOOL)is_alert blockResult:(resultBlock)blockResult blockRetry:(retryBlock)blockRetry;
#pragma mark  检查是否可以更换银行卡
- (AFHTTPRequestOperation*)unbind_bank_card_with_is_alert:(BOOL)is_alert blockResult:(resultBlock)blockResult blockRetry:(retryBlock)blockRetry;
#pragma mark  支付————只有余额
- (AFHTTPRequestOperation*)take_order_with_pay_password:(NSString*)pay_password_md5 subject_id:(NSString*)subject_id market_type:(NSInteger)market_type total_money_actual:(NSString*)total_money_actual bank_pay:(NSString*)bank_pay money_pay:(NSString*)money_pay interest_pay:(NSString*)interest_pay remaining_pay:(NSString*)remaining_pay total_money:(NSString*)total_money coupon_id:(NSString*)coupon_id is_alert:(BOOL)is_alert pay_key:(NSString *)pay_key blockResult:(resultBlock)blockResult blockRetry:(retryBlock)blockRetry;
#pragma mark  支付验证码----余额＋银行
- (AFHTTPRequestOperation*)take_order_sms_code_bank_with_member_coupon_id:(NSString*)member_coupon_id total_money:(NSString*)total_money remaining_pay:(NSString*)remaining_pay bank_pay:(NSString*)bank_pay total_money_actual:(NSString*)total_money_actual subject_id:(NSString*)subject_id realname:(NSString*)realname mobile_phone:(NSString*)mobile_phone bank_card_id:(NSString*)bank_card_id id_card:(NSString*)id_card is_alert:(BOOL)is_alert blockResult:(resultBlock)blockResult blockRetry:(retryBlock)blockRetry;
#pragma mark  支付－－银行卡＋余额
- (AFHTTPRequestOperation*)order_pay_bank_with_market_type:(NSInteger)market_type order_id:(NSString*)order_id order_number:(NSString*)order_number sms_code:(NSString*)sms_code is_alert:(BOOL)is_alert pay_key: (NSString *)pay_key blockResult:(resultBlock)blockResult blockRetry:(retryBlock)blockRetry;
#pragma mark   发现动态
- (AFHTTPRequestOperation*)get_discover_with_home:(NSString *)home is_alert:(BOOL)is_alert blockResult:(resultBlock)blockResult blockRetry:(retryBlock)blockRetry;
#pragma mark  我的资产
- (AFHTTPRequestOperation*)get_my_money_with_is_alert:(BOOL)is_alert blockResult:(resultBlock)blockResult blockRetry:(retryBlock)blockRetry;
/*
#pragma mark  定期资产
- (AFHTTPRequestOperation*)enter_product_detail_with_status:(NSInteger)status page:(NSInteger)page count:(NSInteger)count is_alert:(BOOL)is_alert blockResult:(resultBlock)blockResult blockRetry:(retryBlock)blockRetry;
 */
#pragma mark  投资记录
- (AFHTTPRequestOperation*)invest_record_with_status:(NSInteger)status
                                                page:(NSInteger)page
                                               count:(NSInteger)count
                                            is_alert:(BOOL)is_alert
                                         blockResult:(resultBlock)blockResult
                                          blockRetry:(retryBlock)blockRetry;

#pragma mark   投资记录------优选计划
- (AFHTTPRequestOperation*)invest_record_for_plan_with_status:(NSInteger)status
                                                  market_type:(NSInteger)market_type
                                                         page:(NSInteger)page
                                                        count:(NSInteger)count
                                                     is_alert:(BOOL)is_alert
                                                  blockResult:(resultBlock)blockResult
                                                   blockRetry:(retryBlock)blockRetry;
#pragma mark   投资记录------旧
- (AFHTTPRequestOperation*)invest_record_with_status:(NSInteger)status market_type:(NSInteger)market_type page:(NSInteger)page count:(NSInteger)count is_alert:(BOOL)is_alert blockResult:(resultBlock)blockResult blockRetry:(retryBlock)blockRetry;
#pragma mark   投资记录------优选计划详情
- (AFHTTPRequestOperation*)invest_record_for_plan_with_beePlanId:(NSString *)beePlanId is_alert:(BOOL)is_alert blockResult:(resultBlock)blockResult blockRetry:(retryBlock)blockRetry;
#pragma mark  获取合同
- (AFHTTPRequestOperation*)contract_record_with_order_id:(NSString*)order_id order_number:(NSString *)contract_record_with is_alert:(BOOL)is_alert blockResult:(resultBlock)blockResult blockRetry:(retryBlock)blockRetry;
#pragma mark   获取合同-----old老客户
- (AFHTTPRequestOperation*)contract_record_with_old_order_id:(NSString*)order_id  order_number:(NSString *)order_number is_alert:(BOOL)is_alert blockResult:(resultBlock)blockResult blockRetry:(retryBlock)blockRetry;
#pragma mark  关于我们
- (AFHTTPRequestOperation*)about_us_with_is_alert:(BOOL)is_alert blockResult:(resultBlock)blockResult blockRetry:(retryBlock)blockRetry;
#pragma mark  交易记录
- (AFHTTPRequestOperation*)transaction_record_with_page:(NSInteger)page count:(NSInteger)count is_alert:(BOOL)is_alert blockResult:(resultBlock)blockResult blockRetry:(retryBlock)blockRetry;
#pragma mark  理财产品记录
- (AFHTTPRequestOperation*)customer_product_list_with_is_alert:(BOOL)is_alert blockResult:(resultBlock)blockResult blockRetry:(retryBlock)blockRetry;

#pragma mark  理财产品记录 old 老客户
- (AFHTTPRequestOperation*)old_customer_product_list_with_is_alert:(BOOL)is_alert blockResult:(resultBlock)blockResult blockRetry:(retryBlock)blockRetry;
#pragma mark  获取可用余额＋正在提现金额
- (AFHTTPRequestOperation*)get_doing_withdraw_info_with_is_alert:(BOOL)is_alert blockResult:(resultBlock)blockResult blockRetry:(retryBlock)blockRetry;
#pragma mark  设置自动投标
- (AFHTTPRequestOperation*)auto_bid_enabled_with_enabled:(NSInteger)enabled is_alert:(BOOL)is_alert blockResult:(resultBlock)blockResult blockRetry:(retryBlock)blockRetry;
#pragma mark  提现
- (AFHTTPRequestOperation*)submit_withdraw_with_money:(NSString*)money auth_code:(NSString*)auth_code is_alert:(BOOL)is_alert blockResult:(resultBlock)blockResult blockRetry:(retryBlock)blockRetry;
#pragma mark  获取提现记录
- (AFHTTPRequestOperation*)withdraw_list_with_page:(NSInteger)page count:(NSInteger)count  is_alert:(BOOL)is_alert blockResult:(resultBlock)blockResult blockRetry:(retryBlock)blockRetry;
#pragma mark  获取礼包
- (AFHTTPRequestOperation*)get_red_packet_lis_with_is_alert:(BOOL)is_alert market_type:(NSArray *)market_type_array blockResult:(resultBlock)blockResult blockRetry:(retryBlock)blockRetry;
#pragma mark  兑换礼包
- (AFHTTPRequestOperation*)exchange_red_packet_with_get_passwd:(NSString*)get_passwd is_alert:(BOOL)is_alert blockResult:(resultBlock)blockResult blockRetry:(retryBlock)blockRetry;
#pragma mark 获取历史礼包
- (AFHTTPRequestOperation*)get_historyPacket_lis_with_is_alert:(BOOL)is_alert type:(NSInteger)type blockResult:(resultBlock)blockResult blockRetry:(retryBlock)blockRetry;
#pragma mark  获取可用理财券－－－支付时
- (AFHTTPRequestOperation*)get_order_couold_use_coupon_list_with_product_id:(NSString*)product_id is_alert:(BOOL)is_alert market_type:(NSInteger)market_type_interger blockResult:(resultBlock)blockResult blockRetry:(retryBlock)blockRetry;
#pragma mark  获取用户拥有的所有理财券
- (AFHTTPRequestOperation*)get_member_coupon_list_with_is_alert:(BOOL)is_alert blockResult:(resultBlock)blockResult blockRetry:(retryBlock)blockRetry;
#pragma mark  兑换理财券
- (AFHTTPRequestOperation*)exchange_coupon_with_get_passwd:(NSString*)get_passwd is_alert:(BOOL)is_alert blockResult:(resultBlock)blockResult blockRetry:(retryBlock)blockRetry;
#pragma mark  分享
- (AFHTTPRequestOperation*)share_with_key:(NSString*)key platform:(NSString*)plateform is_alert:(BOOL)is_alert blockResult:(resultBlock)blockResult blockRetry:(retryBlock)blockRetry;
#pragma mark  邀请列表
- (AFHTTPRequestOperation*)invited_list_with_page:(NSInteger)page count:(NSInteger)count is_alert:(BOOL)is_alert blockResult:(resultBlock)blockResult blockRetry:(retryBlock)blockRetry;
#pragma mark  获取基地址
- (NSString*)api_base_url;
#pragma mark  线下产品标的
- (AFHTTPRequestOperation*)get_subject_order_list_with_fp_order_id:(NSString*)fp_order_id is_alert:(BOOL)is_alert blockResult:(resultBlock)blockResult blockRetry:(retryBlock)blockRetry;
#pragma mark  绑定银行卡前获取的短信
- (AFHTTPRequestOperation*)bank_card_send_sms_before_confirm_with_realname:(NSString*)realname mobile_phone:(NSString*)mobile_phone bank_card_id:(NSString*)bank_card_id id_card:(NSString*)id_card user_mobile_phone:(NSString*)user_mobile_phone bank_name:(NSString*)bank_name member_id:(NSString *)member_id bank_code:(NSString *)bank_code is_alert:(BOOL)is_alert blockResult:(resultBlock)blockResult blockRetry:(retryBlock)blockRetry;
#pragma mark  绑定银行卡
- (AFHTTPRequestOperation*)bank_card_confirm_with_order_no:(NSString*)order_no sms_code:(NSString*)sms_code is_alert:(BOOL)is_alert bank_name:bank_name blockResult:(resultBlock)blockResult blockRetry:(retryBlock)blockRetry;
#pragma mark  获取基础配置，如launch_image
- (AFHTTPRequestOperation*)get_basic_config_is_alert:(BOOL)is_alert blockResult:(resultBlock)blockResult blockRetry:(retryBlock)blockRetry;
#pragma mark  获取VIP列表
- (AFHTTPRequestOperation*)get_vip_list_with_is_alert:(BOOL)is_alert blockResult:(resultBlock)blockResult blockRetry:(retryBlock)blockRetry;
#pragma mark 获取消息小站
- (AFHTTPRequestOperation*)get_stationBee_list_with_page:(NSInteger)page count:(NSInteger)count is_alert:(BOOL)is_alert  blockResult:(resultBlock)blockResult blockRetry:(retryBlock)blockRetry;
#pragma mark  判断是否是新手
- (AFHTTPRequestOperation*)judge_is_new_client_is_alert:(BOOL)is_alert  blockResult:(resultBlock)blockResult blockRetry:(retryBlock)blockRetry;
#pragma mark  vip 领取礼券
- (AFHTTPRequestOperation*)getVipGiftBagWithCoupon_id:(NSString *)coupon_id is_alert:(BOOL)is_alert  blockResult:(resultBlock)blockResult blockRetry:(retryBlock)blockRetry;

@end
