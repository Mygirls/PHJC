//
//  ForgetPasswordViewController.h
//  BeeEnrichmentAppiOS
//
//  Created by dll on 15/12/22.
//  Copyright © 2015年 didai. All rights reserved.
//

#import "JPViewController.h"
typedef enum {
    SetPasswordTypeUpdate,  // 修改密码
    SetPasswordTypeForget, // 忘记密码密码
}SetPasswordType;
@interface ForgetPasswordViewController : JPViewController
@property (nonatomic)SetPasswordType setPasswordType;
@end
