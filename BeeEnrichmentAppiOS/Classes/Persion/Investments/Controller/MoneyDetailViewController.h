//
//  MoneyDetailViewController.h
//  BeeEnrichmentAppiOS
//
//  Created by dll on 15/12/28.
//  Copyright © 2015年 didai. All rights reserved.
//

#import "JPViewController.h"

@interface MoneyDetailViewController : JPViewController

@property (nonatomic, strong) BeePlanModel *data_dic;
@property (nonatomic, strong) NSMutableDictionary *data_dic_old;
@property (nonatomic, assign) NSInteger enterType;// 4:老客户

@end
