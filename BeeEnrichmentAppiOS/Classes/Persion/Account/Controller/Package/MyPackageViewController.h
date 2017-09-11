//
//  MyPackageViewController.h
//  BeeEnrichmentAppiOS
//
//  Created by hwm on 16/10/12.
//  Copyright © 2016年 didai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyPackageViewController : JPViewController

// 礼包入口
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger indexVC;
@property (nonatomic, assign) NSInteger tagIndex;
@property (nonatomic, assign) NSInteger selectVC;//花界面
// 支付理财券
@property (nonatomic, strong) ProductsDetailModel *dataDic;
@property (nonatomic, strong) NSString *moneyD;
// 可用优惠券
@property (nonatomic, strong) NSArray *dataListArray, *market_type_array;
@property (nonatomic, assign) NSInteger totalPackagess, market_type_interger;

@end
