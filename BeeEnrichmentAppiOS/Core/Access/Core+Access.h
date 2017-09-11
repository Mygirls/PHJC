//
//  Core+Access.h
//  CarMirrorAppiOS
//
//  Created by renpan on 15/9/22.
//  Copyright © 2015年 HangZhouShangFu. All rights reserved.
//

#import "Core.h"
@interface Core (Access)
- (void)save_device_token:(NSString*)device_token;
- (NSString*)get_device_token;
- (void)save_access_token:(NSString*)access_token;
- (NSString*)get_access_token;
- (void)save_user_info_with_member:(NSDictionary*)member;
- (void)save_user_info_with_access:(NSDictionary*)access;
- (NSDictionary*)get_user_info_member;
- (NSDictionary*)get_user_info_access;
- (NSDictionary*)get_bank_card_info;

//保存银行卡列表
- (void)save_bank_list_info:(NSArray*)bank_list;
- (NSArray*)get_bank_list;
- (void)save_borrow_type:(NSString *)borrow_type;
- (NSString *)get_borrow_type;
- (BOOL)is_login;
- (void)logout;
//保存启动图信息
- (void)save_launch_image_info:(NSDictionary *)launch_image_info;
//获取启动图信息
- (NSDictionary *)get_launch_image_info;



@end
