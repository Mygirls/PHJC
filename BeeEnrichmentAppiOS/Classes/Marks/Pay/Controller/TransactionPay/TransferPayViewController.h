//
//  TransferPayViewController.h
//  BeeEnrichmentAppiOS
//
//  Created by dll on 16/12/13.
//  Copyright © 2016年 didai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TransferPayViewController : UIViewController
@property (nonatomic, strong) ProductsDetailModel *data_dic;
//产品dic 银行卡dic（第一次支付的时候）, *bank_card_dic
@property (nonatomic, copy) NSString *bankCardPhone;
@end
