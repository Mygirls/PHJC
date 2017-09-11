//
//  PrivilegeTwoCell.h
//  BeeEnrichmentAppiOS
//
//  Created by dll on 2017/6/8.
//  Copyright © 2017年 DuLonglong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class VipModel;
@interface PrivilegeTwoCell : UITableViewCell
@property (nonatomic, strong) VipModel *pTDic;

@property (strong, nonatomic) IBOutlet UIButton *commonBirthdayBtn;
@property (strong, nonatomic) IBOutlet UIButton *vipBirthdayBtn;
@property (strong, nonatomic) IBOutlet UIButton *vipUpgradeBtn;
@property (strong, nonatomic) IBOutlet UIButton *vipHolidayBtn;
@property (strong, nonatomic) IBOutlet UIButton *vipSurpriseBtn;


@property (strong, nonatomic) IBOutlet UIButton *svipBirthdayBtn;
@property (strong, nonatomic) IBOutlet UIButton *svipUpgradeBtn;
@property (strong, nonatomic) IBOutlet UIButton *svipHolidayBtn;
@property (strong, nonatomic) IBOutlet UIButton *svipSurpriseBtn;

@end
