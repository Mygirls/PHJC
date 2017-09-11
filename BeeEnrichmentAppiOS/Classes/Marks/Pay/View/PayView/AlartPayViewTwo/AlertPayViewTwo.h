//
//  AlertPayViewTwo.h
//  BeeEnrichmentAppiOS
//
//  Created by MC on 2016/11/11.
//  Copyright © 2016年 didai. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AlertPayViewTwo;

@protocol AlertPayMoneyViewDelegate <NSObject>

@optional

-(void)AlertPayMoneyView:(AlertPayViewTwo *)view WithPasswordString:(NSString *)Password;


@end

@interface AlertPayViewTwo : UIView


@property (nonatomic,assign)id <AlertPayMoneyViewDelegate>AlertPayMoneyViewDelegate;

@property (nonatomic, copy) NSString *phoneStr;
//忘记密码
@property (nonatomic,)UIButton *forgetBtn;

///  TF
@property (nonatomic,)UITextField *TF;

///  假的输入框
@property (nonatomic,)UIView *view_box;
@property (nonatomic,)UIView *view_box2;
@property (nonatomic,)UIView *view_box3;
@property (nonatomic,)UIView *view_box4;
@property (nonatomic,)UIView *view_box5;
@property (nonatomic,)UIView *view_box6;

///   密码点
@property (nonatomic,)UILabel *lable_point;
@property (nonatomic,)UILabel *lable_point2;
@property (nonatomic,)UILabel *lable_point3;
@property (nonatomic,)UILabel *lable_point4;
@property (nonatomic,)UILabel *lable_point5;
@property (nonatomic,)UILabel *lable_point6;
+ (instancetype)alertViewDefault;
- (void)show;

@end
