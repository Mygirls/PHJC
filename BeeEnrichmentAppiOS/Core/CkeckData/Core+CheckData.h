//
//  Core+CheckData.h
//  BeeEnrichmentAppiOS
//
//  Created by dll on 16/6/24.
//  Copyright © 2016年 didai. All rights reserved.
//

#import "Core.h"

@interface Core (CheckData)
//
- (BOOL)checkPhoneValid:(NSString *)string;
- (BOOL)check_password_valid:(NSString *)string;
- (BOOL)check_login_pasword_valid:(NSString *)string;
- (BOOL)checkIDCardValid:(NSString *)string;
- (BOOL)check_moneyValid:(NSString *)string;
- (BOOL)checkNumberValid:(NSString *)string;
- (BOOL)checkNameValid:(NSString *)string;

@end
