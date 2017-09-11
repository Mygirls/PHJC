//
//  MyRedPacketsViewController.h
//  BeeEnrichmentAppiOS
//
//  Created by hwm on 16/10/12.
//  Copyright © 2016年 didai. All rights reserved.
//

#import "JPViewController.h"
@class PackageModel;
@interface MyRedPacketsViewController : JPViewController

// 礼包类型
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) NSMutableArray<PackageModel *> *dataArray;
// 礼包入口
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger tagRed;
// 支付理财券
//@property (nonatomic, strong) ProductsDetailModel *dataDic;
@property (nonatomic, assign) double money;
@property (nonatomic, assign) NSInteger time;
@property (nonatomic, assign) NSInteger totalPackages;


@end
