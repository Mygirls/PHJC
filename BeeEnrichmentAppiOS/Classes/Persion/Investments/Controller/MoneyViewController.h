//
//  MoneyViewController.h
//  BeeEnrichmentAppiOS
//
//  Created by dll on 15/12/24.
//  Copyright © 2015年 didai. All rights reserved.
//

#import "JPViewController.h"

@interface MoneyViewController : JPViewController
@property (nonatomic, strong) NSString *navtitle;
@property (nonatomic, assign) NSInteger type;// 1:累计投资 2:投资记录 3:累计收益 4:老客户投资记录
@property (nonatomic, strong) NSString *enterType;
@property (nonatomic, assign) NSUInteger market_type;
@end
