//
//  AlertPayMoneyView.h
//  BeeEnrichmentAppiOS
//
//  Created by dll on 16/8/17.
//  Copyright © 2016年 didai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LTimerButton.h"





typedef void(^CommitButtonActionBlock)(UIView *backViewOfAlertMoney);

@interface AlertPayMoneyView : UIView  <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet LTimerButton *obtainBtn;
@property (weak, nonatomic) IBOutlet UILabel *informationLbl;
@property (strong, nonatomic) IBOutlet UILabel *phoneNumLabel;
@property (strong, nonatomic) IBOutlet UITextField *contentTextField;
@property (strong, nonatomic) IBOutlet UIButton *commitB;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, copy) CommitButtonActionBlock commitBtn;

- (void)show_view;
-(void)removeFromSuperviewS;

@end
