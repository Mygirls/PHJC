//
//  MyRedPacketsCell.h
//  BeeEnrichmentAppiOS
//
//  Created by hwm on 16/10/13.
//  Copyright © 2016年 didai. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PackageModel;
@interface MyRedPacketsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *contentTextLable;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleTopConstrant;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *outdataTopConstraint;
@property (weak, nonatomic) IBOutlet UIButton *choiceBtn;
@property (weak, nonatomic) IBOutlet UIImageView *outDataImageView;
@property (weak, nonatomic) IBOutlet UILabel *moneyLable;
@property (weak, nonatomic) IBOutlet UILabel *timeLable;
@property (weak, nonatomic) IBOutlet UILabel *title_lable;
@property (weak, nonatomic) IBOutlet UIImageView *backgroupImageView;
@property (weak, nonatomic) IBOutlet UILabel *renMinBiLable;
@property (nonatomic, strong) PackageModel *model;
@property (nonatomic, assign) NSInteger type;//礼包入口 1.有效，2无效


@end
