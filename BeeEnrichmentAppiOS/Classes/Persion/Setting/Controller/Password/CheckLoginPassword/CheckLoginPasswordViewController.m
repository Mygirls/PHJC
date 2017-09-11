//
//  CheckLoginPasswordViewController.m
//  BeeEnrichmentAppiOS
//
//  Created by dll on 16/1/5.
//  Copyright © 2016年 didai. All rights reserved.
//

#import "CheckLoginPasswordViewController.h"

#import "Icon_TextField_Cell.h"
#import "ClickButtonView.h"

#import "SetPayPasswordViewController.h"

@interface CheckLoginPasswordViewController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong)UITextField *login_pasword_textField;
@property (nonatomic, strong)ClickButtonView *click_button_view;

@end

@implementation CheckLoginPasswordViewController
- (void)init_ui
{
    [super init_ui];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self close_keyboard];
}
- (void)set_tableFooterView
{
    _click_button_view = [ClickButtonView load_nib];
    [self set_button_disabled];
    [_click_button_view.click_button setTitle:@"下一步" forState:UIControlStateNormal];
    [_click_button_view.click_button addTarget:self action:@selector(click_sure_button) forControlEvents:UIControlEventTouchUpInside];
    _tableView.tableFooterView = _click_button_view;
}
#pragma mark 设置button可用／不可用
- (void)set_button_disabled
{
        _click_button_view.click_button.alpha = 0.5;
    _click_button_view.click_button.enabled = NO;
}
- (void)set_button_enabled
{
        _click_button_view.click_button.alpha = 1.0;
    _click_button_view.click_button.enabled = YES;
}

#pragma mark 点击验证登录密码
- (void)click_sure_button
{
    [self close_keyboard];
    if (![CMCore check_login_pasword_valid:_login_pasword_textField.text]) {
        [[JPAlert current] showAlertWithTitle:@"请输入登录密码(6-16位),只允许包含数字，字符，字母" button:@"好的"];
        return;
    }
    [self check_login_password];
    
}
#pragma mark tableView delegate/dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
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
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        [self set_tableFooterView];
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Icon_TextField_Cell *cell = [tableView load_reuseable_cell_from_nib_with_class:[Icon_TextField_Cell class]];
    cell.imageView.image = [UIImage imageNamed:@"v1_icon_password"];
    cell.myTextField.secureTextEntry = YES;
    cell.myTextField.placeholder = @"请输入登录密码";
    _login_pasword_textField = cell.myTextField;
    cell.myTextField.delegate = self;
    cell.myTextField.returnKeyType = UIReturnKeyDone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark 输入框delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@""] && textField.text.length - 1 == 0) {
        [self set_button_disabled];
    }
    if ([NSString stringWithFormat:@"%@%@",_login_pasword_textField.text, string].length > 0) {
        [self set_button_enabled];
    }else
    {
        [self set_button_disabled];
    }
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (_login_pasword_textField.text.length > 0) {
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
- (void)close_keyboard
{
    [_login_pasword_textField resignFirstResponder];
}
#pragma mark tap delegate
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return YES;
}
#pragma mark 设置支付密码
- (void)go_setPayPassword_vc
{
    SetPayPasswordViewController *set_pay_password_vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SetPayPasswordViewController"];
    set_pay_password_vc.enterType = _enterType;
    set_pay_password_vc.login_password_str = _login_pasword_textField.text;
    set_pay_password_vc.type = _type;
    set_pay_password_vc.data_dic = _data_dic;
    //100 更新支付密码(有支付密码{修改/忘记支付密码}) 200 设置支付密码(没有支付密码)
    if (_type == 100) {
        set_pay_password_vc.title = @"修改支付密码";
    }else
    {
        set_pay_password_vc.title = @"设置支付密码";
        set_pay_password_vc.type = 200;
    }
    [self go_next:set_pay_password_vc animated:YES viewController:self];
}
#pragma mark 网络请求－验证登录密码
- (void)check_login_password
{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD showWithStatus:@"正在验证登录密码"];
    [CMCore auth_login_passwd_with_login_passwd:_login_pasword_textField.text is_alert:YES blockResult:^(NSNumber *code, id result, NSString *message) {
        [SVProgressHUD dismiss];
        if ([code integerValue] == 200) {
            [self go_setPayPassword_vc];
            
        }
    } blockRetry:^(NSInteger index) {
        [SVProgressHUD dismiss];
        if (index == 1) {
            [self check_login_password];
        }
    }];
}

@end
