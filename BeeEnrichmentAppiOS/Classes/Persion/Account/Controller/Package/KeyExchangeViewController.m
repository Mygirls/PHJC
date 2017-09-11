//
//  KeyExchangeViewController.m
//  BeeEnrichmentAppiOS
//
//  Created by hwm on 16/10/12.
//  Copyright © 2016年 didai. All rights reserved.
//

#import "KeyExchangeViewController.h"
#import "UIColor+Addition.h"
#import "mistakeView.h"
@interface KeyExchangeViewController (){
    UITextField * _commandTextField;
    UIButton *_affirmButton;
}

@end

@implementation KeyExchangeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"口令礼包兑换";
    self.view.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.00];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textChange)name:UITextFieldTextDidChangeNotification object:_commandTextField];
    [self creat_ui];
}

-(void)creat_ui{
    _commandTextField = [[UITextField alloc] init];
    _commandTextField.frame = CGRectMake(25, kScreenHeight/667*30, kScreenWidth-50, kScreenHeight/667*45);
    _commandTextField.borderStyle = UITextBorderStyleRoundedRect;
    _commandTextField.clearButtonMode = UITextFieldViewModeAlways;
    _commandTextField.tag = 10;
    _commandTextField.clearsOnBeginEditing = YES;
    [self.view addSubview:_commandTextField];
    _commandTextField.layer.cornerRadius=5.0f;
    _commandTextField.layer.masksToBounds=YES;
    _commandTextField.textColor = [UIColor colorWithHex:@"#FC5554"];
    _commandTextField.placeholder = @"请您输入口令进行兑换";
    _affirmButton = [[UIButton alloc] initWithFrame:CGRectMake(25,  kScreenHeight/667*100, kScreenWidth-50, kScreenHeight/667*45)];
    _affirmButton.backgroundColor = [UIColor colorWithHex:@"#e1e1e1"];
    _affirmButton.titleLabel.font = [UIFont systemFontOfSize:21];
    [_affirmButton setTitle:@"确认兑换" forState:UIControlStateNormal];
    [_affirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_affirmButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_affirmButton];
    [_affirmButton.layer setMasksToBounds:YES];
    [_affirmButton.layer setCornerRadius:5.0];
    _affirmButton.enabled= NO;
}

-(void)textChange
{
    if (_commandTextField.text.length >= 1) {
        _affirmButton.backgroundColor = [UIColor colorWithHex:@"#FC5554"];
        _affirmButton.enabled= YES;
        _commandTextField.layer.borderWidth= 1.0f;
        _commandTextField.layer.borderColor=[[UIColor colorWithHex:@"#FC5554"]CGColor];
    }else{
        _commandTextField.layer.borderWidth= 0.0f;
        _affirmButton.backgroundColor = [UIColor colorWithHex:@"#e1e1e1"];
        _affirmButton.enabled= NO;
    }
}

#pragma mark 点击兑换
-(void)buttonClicked:(UIButton *)sender{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD showWithStatus:@"正在兑换"];
    [self dui_huan_redPacket_with_text:_commandTextField.text];
}

#pragma mark 兑换礼包请求数据
- (void)dui_huan_redPacket_with_text:(NSString*)text
{
    [_commandTextField resignFirstResponder];
    [CMCore exchange_coupon_with_get_passwd:text is_alert:YES blockResult:^(NSNumber *code, id result, NSString *message) {
        if ([code integerValue] == 200) {
            [SVProgressHUD dismiss];
            mistakeView *alert = [mistakeView alertViewDefault];
            alert.title = @"恭喜您,礼包领取成功";
            alert.iconImage = [UIImage imageNamed:@"v1.5_zhengque"];
            [alert show];
            // 发通知
            [NSNotificationCenter defaultCenter] ;
            [self performSelector:@selector(pop) withObject:nil afterDelay:0.7];
        }else{
            [SVProgressHUD dismiss];
            [self.view endEditing:YES];
            mistakeView *alert = [mistakeView alertViewDefault];
            alert.title = message;
            alert.iconImage = [UIImage imageNamed:@"v1.5_error"];
            [alert show];
        }
    } blockRetry:^(NSInteger index) {
        [SVProgressHUD dismiss];
        if (index == 1) {
            [self dui_huan_redPacket_with_text:text];
        }
    }];
}

- (void)pop {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_commandTextField resignFirstResponder];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self ];
}


@end
