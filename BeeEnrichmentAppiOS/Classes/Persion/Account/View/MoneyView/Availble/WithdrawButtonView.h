//
//  WithdrawButtonView.h
//  BeeEnrichmentAppiOS
//
//  Created by dll on 15/12/24.
//  Copyright © 2015年 didai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WithdrawButtonView : UIView

@property (strong, nonatomic) IBOutlet UIButton *click_button;
@property (weak, nonatomic) IBOutlet UIView *no_money_view;
@property (weak, nonatomic) IBOutlet UIButton *grayButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomTitleTopContraint;
@property (weak, nonatomic) IBOutlet UILabel *contentTextLable;


@end
