//
//  ZSDPaymentForm.h
//  demo
//
//  Created by shaw on 15/4/11.
//  Copyright (c) 2015年 shaw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZSDSetPasswordView.h"

typedef void(^ZSDPaymentForm_close_view)(void);
@interface ZSDPaymentForm : UIView

@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *goodsName;
@property (nonatomic,assign) CGFloat amount;

@property (nonatomic, assign) NSInteger numbers_count;
@property (weak, nonatomic) IBOutlet ZSDSetPasswordView *inputView;
@property (strong, nonatomic) IBOutlet LTimerButton *bottom_button;


@property (strong, nonatomic) IBOutlet UILabel *phone_label;
@property (strong, nonatomic) IBOutlet UILabel *description_label;

@property (strong, nonatomic) IBOutlet UILabel *money_label;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (nonatomic,copy) NSString *inputPassword;
@property (nonatomic,copy) void (^completeHandle)(NSString *inputPwd);

@property (nonatomic, strong) ZSDPaymentForm_close_view block_ZSDPaymentForm_close_view;

-(void)fieldBecomeFirstResponder;
-(CGSize)viewSize;

- (void)setBlock_ZSDPaymentForm_close_view:(ZSDPaymentForm_close_view)block_ZSDPaymentForm_close_view;

@end
