//
//  SubPlanListCell.m
//  BeeEnrichmentAppiOS
//
//  Created by dll on 2017/5/25.
//  Copyright © 2017年 DuLonglong. All rights reserved.
//

#import "SubPlanListCell.h"

@implementation SubPlanListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+(instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"SubPlanListCell";
    SubPlanListCell *subPlanListCell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!subPlanListCell) {
        subPlanListCell = [[NSBundle mainBundle] loadNibNamed:identifier owner:nil options:nil].lastObject;
    }
    return subPlanListCell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
