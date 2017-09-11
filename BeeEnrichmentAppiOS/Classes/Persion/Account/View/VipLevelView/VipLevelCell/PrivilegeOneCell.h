//
//  PrivilegeOneCell.h
//  BeeEnrichmentAppiOS
//
//  Created by dll on 2017/6/8.
//  Copyright © 2017年 DuLonglong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDCycleScrollView.h"
@class VipModel;
@interface PrivilegeOneCell : UITableViewCell 
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) VipModel *vipDic;
@property (nonatomic, strong) UITableView *pOTableView;
@end
