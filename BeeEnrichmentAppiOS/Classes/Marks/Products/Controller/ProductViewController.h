//
//  ProductViewController.h
//  BeeEnrichmentAppiOS
//
//  Created by dll on 15/12/22.
//  Copyright © 2015年 didai. All rights reserved.
//

#import "JPViewController.h"

@interface ProductViewController : JPViewController
@property (nonatomic, assign) NSInteger enterType;// 1计划 2普通
@property (nonatomic, strong) ProductsDetailModel *data_dic;
@property (nonatomic, assign) NSInteger judgeBuy;
@property (nonatomic, strong) NSArray *flagOfHistory;

@end
