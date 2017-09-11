//
//  BankCardInformationViewController.h
//  BeeEnrichmentAppiOS
//
//  Created by dll on 15/12/22.
//  Copyright © 2015年 didai. All rights reserved.
//

#import "JPViewController.h"
#import "ProductsModel.h"

@interface BankCardInformationViewController : JPViewController

@property (nonatomic, strong) ProductsDetailModel *data_dic;//, *current_bankCard_info
// 007 是什么意思?
@property (nonatomic, strong) NSString *typeOfStyle;

@end
