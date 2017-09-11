//
//  TransactionCell.h
//  BeeEnrichmentAppiOS
//
//  Created by dll on 15/12/24.
//  Copyright © 2015年 didai. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MoneyFlowModel;
@interface TransactionCell : UITableViewCell
@property (strong,nonatomic) MoneyFlowModel *model;
@end
