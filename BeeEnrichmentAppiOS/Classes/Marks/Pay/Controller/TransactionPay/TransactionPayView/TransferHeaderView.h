//
//  TransferHeaderView.h
//  BeeEnrichmentAppiOS
//
//  Created by dll on 16/12/13.
//  Copyright © 2016年 didai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TransferHeaderView : UIView
@property (nonatomic, strong) ProductsDetailModel *dic;
@property (strong, nonatomic) IBOutlet UITextField *inputTF;
@property (strong, nonatomic) IBOutlet UILabel *actualMoney;
@property (strong, nonatomic) IBOutlet UILabel *expectMoney;
@property (strong, nonatomic) IBOutlet UIButton *allReceiveBtn;
@property (strong, nonatomic) IBOutlet UIView *redBackView;

@end
