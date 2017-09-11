//
//  ZSDPaymentView.h
//  demo
//
//  Created by shaw on 15/4/11.
//  Copyright (c) 2015年 shaw. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZSDPaymentView;

@protocol PaymentViewDelegate <NSObject>

- (void)get_password_str:(NSString *)string;
@optional
- (void)cancel_payment_handle:(ZSDPaymentView*)payment;
@end

@interface ZSDPaymentView : UIView
@property (nonatomic,copy) NSString *title;
@property (nonatomic, assign) NSInteger numbers_count;
@property (nonatomic, strong) LTimerButton *bottom_button;
@property (nonatomic, strong) UILabel *phone_label, *description_label, *title_label, *money_label;
@property (nonatomic,copy) NSString *goodsName;
@property (nonatomic,assign) CGFloat amount;
@property (nonatomic, assign) id<PaymentViewDelegate>delegate;
-(void)show;
-(void)dismiss;
@end
