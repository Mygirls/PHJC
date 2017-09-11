//
//  SubPlanListCell.h
//  BeeEnrichmentAppiOS
//
//  Created by dll on 2017/5/25.
//  Copyright © 2017年 DuLonglong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SubPlanListCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIButton *checkDetailBtn;
@property (strong, nonatomic) IBOutlet UILabel *subjectTitleLable;

+(instancetype)cellWithTableView:(UITableView *)tableView;
@end
