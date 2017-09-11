//
//  PlanDetailCell.m
//  BeeEnrichmentAppiOS
//
//  Created by dll on 2017/5/19.
//  Copyright © 2017年 DuLonglong. All rights reserved.
//

#import "PlanDetailCell.h"


@implementation PlanDetailCell
- (void)awakeFromNib {
    [super awakeFromNib];
}

+(instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"PlanDetailCell";
    PlanDetailCell *planDetialCell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!planDetialCell) {
        planDetialCell = [[NSBundle mainBundle] loadNibNamed:identifier owner:nil options:nil].lastObject;
    }
    return planDetialCell;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
