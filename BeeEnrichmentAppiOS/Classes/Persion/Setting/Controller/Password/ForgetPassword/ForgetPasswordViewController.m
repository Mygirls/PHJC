//
//  ForgetPasswordViewController.m
//  BeeEnrichmentAppiOS
//
//  Created by dll on 15/12/22.
//  Copyright © 2015年 didai. All rights reserved.
//

#import "ForgetPasswordViewController.h"

#import "Icon_TextField_Button_Cell.h"
#import "Icon_TextField_Cell.h"
#import "ClickButtonView.h"
@interface ForgetPasswordViewController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UITextField *phone_textField, *auth_code_textField, *password_textField;
@property (nonatomic, strong) NSArray *icon_img_name_ary, *cell_placeholder_ary;
@property (nonatomic, strong) ClickButtonView *sure_button_view;
@end

@implementation ForgetPasswordViewController

- (void)init_ui {
    [super init_ui];
    [self set_tableFooterView];
    _icon_img_name_ary = @[@"v1_icon_phone", @"v1_icon_auth_code", @"v1_icon_password"];
    _cell_placeholder_ary = @[@"请输入手机号码", @"请输入短信验证码", @"设置6-16位登录密码"];
    [self set_close_keyboard];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self close_keyboard];
    [SVProgressHUD dismiss];
}

#pragma maek 设置按钮 可用／不可用
- (void)set_button_disabled
{
        _sure_button_view.click_button.alpha = 0.5;
    _sure_button_view.click_button.enabled = NO;
}
- (void)set_button_enabled
{
        _sure_button_view.click_button.alpha = 1.0;
    _sure_button_view.click_button.enabled = YES;
}
#pragma mark 设置tablefooterView 登录按钮/忘记密码按钮
- (void)set_tableFooterView {
    _sure_button_view = [ClickButtonView load_nib];

    [self set_button_disabled];
    [_sure_button_view.click_button setTitle:@"确认" forState:UIControlStateNormal];
    [_sure_button_view.click_button addTarget:self action:@selector(click_sure_button) forControlEvents:UIControlEventTouchUpInside];
    
}
#pragma mark 确认按钮
- (void)click_sure_button {
    [self close_keyboard];
    if (![CMCore checkPhoneValid:_phone_textField.text]) {
        [[JPAlert current] showAlertWithTitle:@"手机号码格式不正确" button:@"好的"];
        return;
    }
    if (![CMCore checkNumberValid:_auth_code_textField.text] || _auth_code_textField.text.length == 0) {
        [[JPAlert current] showAlertWithTitle:@"请输入短信验证码" button:@"好的"];
        return;
    }
    if (![CMCore check_login_pasword_valid:_password_textField.text]) {
        [[JPAlert current] showAlertWithTitle:@"请输入登录密码(6-16位),只允许包含数字，字符，字母" button:@"好的"];
        return;
    }
    //修改密码(忘记密码)
    [self go_update_password];
}
#pragma mark 发送验证码
- (void)click_send_message_button:(LTimerButton *)button {
    [self close_keyboard];
    if (![CMCore checkPhoneValid:_phone_textField.text]) {
        [[JPAlert current] showAlertWithTitle:@"手机号码格式不正确" button:@"好的"];
        return;
    }
    [self send_message_with_button:button];
    
}
#pragma mark tableView delegate/dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    }else
    {
        return 1;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kTableViewRowHeight;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return kSectionFooterHeight;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kSectionHeaderHeight;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1 && indexPath.row == 0) {
        _tableView.tableFooterView = _sure_button_view;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 1) {
        //验证码
        Icon_TextField_Button_Cell *cell = [tableView load_reuseable_cell_from_nib_with_class:[Icon_TextField_Button_Cell class]];
        [cell.send_message_button addTarget:self action:@selector(click_send_message_button:) forControlEvents:UIControlEventTouchUpInside];
        cell.imageView.image = [UIImage imageNamed:_icon_img_name_ary[1]];
        cell.myTextField.placeholder = _cell_placeholder_ary[1];
        cell.myTextField.delegate = self;
        cell.myTextField.keyboardType = UIKeyboardTypeNumberPad;
        _auth_code_textField = cell.myTextField;
        return cell;
    }else
    {
        Icon_TextField_Cell *cell = [tableView load_reuseable_cell_from_nib_with_class:[Icon_TextField_Cell class]];
        cell.imageView.image = [UIImage imageNamed:_icon_img_name_ary[indexPath.section * 2 + indexPath.row]];
        cell.myTextField.placeholder = _cell_placeholder_ary[indexPath.section * 2 + indexPath.row];
        cell.myTextField.delegate = self;
        if (indexPath.section == 0) {
            //手机号码
            _phone_textField = cell.myTextField;
            cell.myTextField.keyboardType = UIKeyboardTypeNumberPad;
            if (_setPasswordType == SetPasswordTypeUpdate) {
                //修改登录密码
                _phone_textField.text = [NSString stringWithFormat:@"%@",[CMCore get_user_info_member][@"mobilePhone"]];
                _phone_textField.enabled = false;
            }
        }else
        {
            _password_textField = cell.myTextField;
            cell.myTextField.keyboardType = UIKeyboardTypeNamePhonePad;
            cell.myTextField.returnKeyType = UIReturnKeyDone;
        }
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark textField delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ((textField == _password_textField && [NSString stringWithFormat:@"%@%@",_password_textField.text, string].length > 0 && _phone_textField.text.length >  0 && _auth_code_textField.text.length > 0) || (textField == _auth_code_textField && [NSString stringWithFormat:@"%@%@",_auth_code_textField.text, string].length > 0 && _password_textField.text.length >  0 && _phone_textField.text.length > 0) || (textField == _phone_textField && [NSString stringWithFormat:@"%@%@",_phone_textField.text, string].length > 0 && _password_textField.text.length >  0 && _auth_code_textField.text.length > 0)) {
        [self set_button_enabled];
    }else
    {
        [self set_button_disabled];
    }
    
    if ([string isEqualToString:@""] && textField.text.length - 1 == 0) {
        [self set_button_disabled];
        return YES;
    }
    if (textField == _phone_textField) {
        if ([NSString stringWithFormat:@"%@%@",textField.text, string].length <=11) {
            return YES;
        }
        [_phone_textField resignFirstResponder];
        return NO;
    }
    if ((textField == _phone_textField || textField == _auth_code_textField) && ![CMCore checkNumberValid:[NSString stringWithFormat:@"%@%@",textField.text, string]]) {
        return NO;
    }
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (_phone_textField.text.length > 0 && _password_textField.text.length > 0 && _auth_code_textField.text.length > 0) {
        [self set_button_enabled];
    }else
    {
        [self set_button_disabled];
    }
}
- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    [self set_button_disabled];
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
#pragma mark 设置轻拍手势，点击空白区域键盘消失
- (void)set_close_keyboard {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(close_keyboard)];
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
}
- (void)close_keyboard {
    [_phone_textField resignFirstResponder];
    [_auth_code_textField resignFirstResponder];
    [_password_textField resignFirstResponder];
}
#pragma mark tap delegate
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return YES;
}
#pragma mark 网络请求－更新密码 修改／忘记密码
- (void)go_update_password {
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD showWithStatus:@"正在更新密码..."];
    [CMCore update_password_mobile_phone:_phone_textField.text auth_code:_auth_code_textField.text password:_password_textField.text is_alert:YES blockResult:^(NSNumber *code, id result, NSString *message) {
        [SVProgressHUD dismiss];
        if (result) {
            [CMCore logout];
            if (_setPasswordType == SetPasswordTypeForget) {
//                [self.tabBarController setSelectedIndex:0];
//                [self go_back:YES viewController:self];
                return;
            }

            LoginNavigationController* loginNav = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginNavigationController"];
            [self.navigationController presentViewController:loginNav animated:YES completion:nil];
            self.tabBarController.selectedIndex = 3;
            [self.navigationController popToRootViewControllerAnimated:NO];
            
        }
    } blockRetry:^(NSInteger index) {
        [SVProgressHUD dismiss];
        if (index == 1) {
            [self go_update_password];
            
        }
    }];
}
#pragma mark 网络情求－发送验证码
- (void)send_message_with_button:(LTimerButton*)button
{
    //发送验证码 100注册 200忘记
    [button startTimerWithCount:60];
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD showWithStatus:@"正在发送验证码..."];
    [CMCore get_auth_code_with_with_mobile_phone:_phone_textField.text is_alert:YES blockResult:^(NSNumber *code, id result, NSString *message) {
        if ([code integerValue] == 200) {
            
            [SVProgressHUD setMinimumDismissTimeInterval:1.5];
            [SVProgressHUD showSuccessWithStatus:@"发送成功，请查收"];
        }
    } blockRetry:^(NSInteger index) {
        [SVProgressHUD dismiss];
        if (index == 1) {
            [self click_send_message_button:button];
        }
    }];
}
@end
