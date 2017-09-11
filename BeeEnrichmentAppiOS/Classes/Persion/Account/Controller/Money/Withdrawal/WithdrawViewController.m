//
//  WithdrawViewController.m
//  BeeEnrichmentAppiOS
//
//  Created by dll on 15/12/28.
//  Copyright © 2015年 didai. All rights reserved.
//

#import "WithdrawViewController.h"

#import "WithdrawFooterView1.h"
#import "WithdrawFooterView2.h"
#import "Label_TextField_Cell.h"
#import "RegisterButtonView.h"
#import "ZSDPaymentView.h"

#import <SDWebImage/UIImageView+WebCache.h>
#import "CheckLoginPasswordViewController.h"//验证登录信息
@interface WithdrawViewController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate,PaymentViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UITextField *money_textFiled;
@property (nonatomic, strong) RegisterButtonView *buttonView;
@property (nonatomic, strong) BankCardsModel *bankCardSInfoMD;
@property (nonatomic, strong) ZSDPaymentView *payment;

@end

@implementation WithdrawViewController
- (void)init_ui
{
    [super init_ui];
    [self set_close_keyboard];
    [self set_tableFooterView];
    _bankCardSInfoMD = [BankCardsModel mj_objectWithKeyValues:[CMCore get_bank_card_info]];
    // 设置银行辅助信息
    [self set_bankAccessoryInfo];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self close_keyboard];
    [SVProgressHUD dismiss];
}

- (void)set_bankAccessoryInfo
{
    if (![CMCore get_bank_list]) {
        [self get_bankList];
    }else
    {
        NSString *bank_title = _bankCardSInfoMD.bankTitle;
        for (BankCardsModel *dic in [CMCore get_bank_list]) {
            if ([dic.title isEqualToString:bank_title]) {
                _bankCardSInfoMD = dic;
                break;
            }
        }
    }
}

- (void)get_bankList
{
    //获取银行卡列表
    [CMCore get_bank_list_with_is_alert:YES blockResult:^(NSNumber *code, id result, NSString *message) {
        if (result) {
            [CMCore save_bank_list_info:result];
            [self set_bankAccessoryInfo];
        }
    } blockRetry:^(NSInteger index) {
        if (index == 1) {
            [self get_bankList];
        }
    }];
}

- (void)set_tableFooterView
{
    _buttonView = [RegisterButtonView load_nib];
    [_buttonView.sure_button setTitle:@"提现" forState:UIControlStateNormal];
    [_buttonView setButtonIsenabled:false];
    [_buttonView setPropertyButtonHidden:YES];
    _buttonView.bottom_view.hidden = YES;
    //支付密码提现
    [_buttonView.sure_button addTarget:self action:@selector(click_sure_button) forControlEvents:UIControlEventTouchUpInside];
}
//检查提现金额
- (BOOL)check_money
{
    [self close_keyboard];
    if ([CMCore check_moneyValid:_money_textFiled.text]) {
        if ( [_money_textFiled.text doubleValue] > [_money doubleValue] ) {
            [[JPAlert current] showAlertWithTitle:@"余额不足" button:@"好的"];
            return NO;
        }
        return YES;
    }else{
        [[JPAlert current] showAlertWithTitle:@"提现金额只可为数字，且最多有两位小数，提现金额必须不小于0.01元" button:@"好的"];
        return NO;
    }
}

//短信验证码提现
- (void)click_sure_button
{
    [self close_keyboard];
    if ([self check_money]) {
        _payment = [[ZSDPaymentView alloc] init];
        _payment.delegate = self;
        _payment.numbers_count = 6;
        _payment.money_label.text = [@"￥" stringByAppendingString:_money_textFiled.text];
        NSString *phone = _bankCardSInfoMD.mobilePhone;
        _payment.phone_label.text = [NSString stringWithFormat:@"%@****%@",[phone substringToIndex:3],[phone substringFromIndex:7]];
        [_payment.bottom_button addTarget:self action:@selector(click_send_message_button:) forControlEvents:UIControlEventTouchUpInside];
        [self click_send_message_button:_payment.bottom_button];
        _payment.title = @"短信验证码";
        [_payment show];
    }else
    {
        return;
    }
    
}

#pragma mark tableView delegate/dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 55;
    }
    return kTableViewRowHeight;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 30;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kSectionHeaderHeight;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1 && indexPath.row == 0) {
        
        _tableView.tableFooterView = _buttonView;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        WithdrawFooterView1 *view1 = [WithdrawFooterView1 load_nib];
        view1.money.text = [NSString stringWithFormat:@"%.2f元",[_money doubleValue]];
        return view1;
    }else
    {
        WithdrawFooterView2 *view2 = [WithdrawFooterView2 load_nib];
        return view2;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        UITableViewCell *cell = [tableView load_reuseable_cell_with_style:UITableViewCellStyleSubtitle _class:[UITableViewCell class]];
        cell.tintColor = [CMCore basic_color];
        cell.detailTextLabel.textColor = [UIColor colorWithRed:0.66 green:0.66 blue:0.66 alpha:1];
        if (_bankCardSInfoMD) {
            NSString *card = [[NSString stringWithFormat:@"%@",_bankCardSInfoMD.bankCardId] stringByReplacingOccurrencesOfString:@" " withString:@""];
            
            [cell.imageView sd_setImageWithURL:[NSURL URLWithString:_bankCardSInfoMD.logoUrl] placeholderImage:[UIImage imageNamed:@"v1.6_set_min_about"]];
            cell.textLabel.text = _bankCardSInfoMD.bankTitle;
            cell.detailTextLabel.text = [NSString stringWithFormat:@"尾号%@%@",[card substringFromIndex:card.length - 4], _bankCardSInfoMD.bankTitle?:@"银行卡"];
        }else
        {
            cell.textLabel.text = @"未绑定银行卡";
            cell.detailTextLabel.text = @"银行卡将在交易时被绑定";
            cell.imageView.image = nil;
        }
        
        
        return cell;
    }else
    {
        Label_TextField_Cell *cell = [tableView load_reuseable_cell_from_nib_with_class:[Label_TextField_Cell class]];
        cell.title_label.text = @"金额";
        cell.detail_textField.placeholder = @"请输入提现金额";
        _money_textFiled = cell.detail_textField;
        _money_textFiled.delegate = self;
        _money_textFiled.returnKeyType = UIReturnKeyDone;
        cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"v1_cell_accessory_yuan"]];
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark 输入框delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([NSString stringWithFormat:@"%@%@",textField.text, string].length > 0) {
        [_buttonView setButtonIsenabled:true];
    }else
    {
        [_buttonView setButtonIsenabled:false];
        
    }
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.text.length > 0) {
       [_buttonView setButtonIsenabled:true];
    }else
    {
        [_buttonView setButtonIsenabled:false];
    }
}
- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    [_buttonView setButtonIsenabled:false];
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark 设置轻拍手势，点击空白区域键盘消失
- (void)set_close_keyboard {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(close_keyboard)];
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
}
- (void)close_keyboard
{
    [_money_textFiled resignFirstResponder];
}
#pragma mark tap delegate
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return YES;
}

//paymentView delegate
- (void)get_password_str:(NSString *)string
{
    [_payment dismiss];
    [self submit_withdraw_with_string:string];
    
}


#pragma mark 忘记支付密码
- (void)go_check_loginPassword_vc
{
    [_payment removeFromSuperview];
    NSDictionary *user_info = [CMCore get_user_info_member];
    //100 更新支付密码(有支付密码{修改/忘记支付密码}) 200 设置支付密码(没有支付密码)
    CheckLoginPasswordViewController *check_login_password_vc = [self.storyboard instantiateViewControllerWithIdentifier:@"CheckLoginPasswordViewController"];
    if ([user_info[@"hasPayPassword"] integerValue]) {
        check_login_password_vc.type = 100;
    }else {
        check_login_password_vc.type = 200;
    }
    [self go_next:check_login_password_vc animated:YES viewController:self];
}

- (void)click_send_message_button:(LTimerButton*)button
{
    [button startTimerWithCount:60];
    button.layer.borderWidth = 0.5;
    button.layer.borderColor = [UIColor lightGrayColor].CGColor;

    [CMCore get_auth_code_with_with_mobile_phone:nil is_alert:YES blockResult:^(NSNumber *code, id result, NSString *message) {
        if ([code integerValue] == 200) {
            
        }else
        {
            [_payment dismiss];
        }

    } blockRetry:^(NSInteger index) {
        if (index == 1) {
            [self click_send_message_button:button];
        }
    }];
}


#pragma mark
- (void)submit_withdraw_with_string:(NSString*)string
{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD showWithStatus:@"正在提现..."];
    [CMCore submit_withdraw_with_money:_money_textFiled.text auth_code:string is_alert:YES blockResult:^(NSNumber *code, id result, NSString *message) {
        [SVProgressHUD dismiss];
        if ([code integerValue] == 200) {
            _payment.delegate = nil;
            [[JPAlert current] showAlertWithTitle:@"提现申请成功" button:@"好的"];
            [self go_back:YES viewController:self];
        }
    } blockRetry:^(NSInteger index) {
        [SVProgressHUD dismiss];
        if (index == 1) {
            [self get_password_str:string];
        }
    }];
}

@end
