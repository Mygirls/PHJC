//
//  TransferProductViewController.h
//  BeeEnrichmentAppiOS
//
//  Created by dll on 16/12/12.
//  Copyright © 2016年 didai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TransferProductViewController : JPViewController
@property (nonatomic, strong) ProductsDetailModel *productM;
@property (nonatomic, assign) NSInteger judgeBuy;
@property (nonatomic, strong) NSArray *flagOfHistory;
@end
