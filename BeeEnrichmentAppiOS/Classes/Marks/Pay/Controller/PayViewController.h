//
//  PayViewController.h
//  BeeEnrichmentAppiOS
//
//  Created by dll on 15/12/22.
//  Copyright © 2015年 didai. All rights reserved.
//

#import "JPViewController.h"

@interface PayViewController : JPViewController

@property (nonatomic, strong) ProductsDetailModel *data_dic;
//产品dic 银行卡dic（第一次支付的时候）, *bank_card_dic
@property (nonatomic, copy) NSString *bankCardPhone;


@end
