//
//  VipHeadView.h
//  BeeEnrichmentAppiOS
//
//  Created by dll on 2017/6/8.
//  Copyright © 2017年 DuLonglong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class VipModel;
typedef void(^backBtnActionBlock) ();
typedef void(^goInvestingActionBlock) ();
@interface VipHeadView : UIView
@property (nonatomic, strong) VipModel *dataDic;
@property (strong, nonatomic) IBOutlet UIImageView *headImageView;
@property (strong, nonatomic) IBOutlet UILabel *vipLevelLabel;
@property (strong, nonatomic) IBOutlet UILabel *mobilePhoneLabel;
@property (strong, nonatomic) IBOutlet UILabel *myTotalMoneyLabel;

@property (strong, nonatomic) IBOutlet UILabel *contentLabel;
@property (strong, nonatomic) IBOutlet UIImageView *vipImageView;

@property (nonatomic, copy) backBtnActionBlock backbtn;
@property (nonatomic, copy) goInvestingActionBlock goInvesting;

@end
