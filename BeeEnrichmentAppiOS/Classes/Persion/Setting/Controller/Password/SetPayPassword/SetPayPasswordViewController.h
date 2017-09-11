//
//  SetPayPasswordViewController.h
//  BeeEnrichmentAppiOS
//
//  Created by dll on 16/1/5.
//  Copyright © 2016年 didai. All rights reserved.
//

#import "JPViewController.h"

@interface SetPayPasswordViewController : JPViewController
@property (nonatomic, strong) ProductsDetailModel *data_dic;
@property (nonatomic, copy)NSString *login_password_str;
@property (nonatomic, assign) NSInteger type;//100 更新支付密码(有支付密码{修改/忘记支付密码}) 200 设置支付密码(没有支付密码)
@property (nonatomic, strong) NSString *enterType;

@end
