//
//  PlanDetailCell.h
//  BeeEnrichmentAppiOS
//
//  Created by dll on 2017/5/19.
//  Copyright © 2017年 DuLonglong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlanDetailCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *titleLable;
@property (strong, nonatomic) IBOutlet UILabel *valueLabel;

+(instancetype)cellWithTableView:(UITableView *)tableView;
@end
