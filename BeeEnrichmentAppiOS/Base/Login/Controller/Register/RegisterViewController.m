//
//  RegisterViewController.m
//  BeeEnrichmentAppiOS
//
//  Created by dll on 15/12/21.
//  Copyright © 2015年 didai. All rights reserved.
//

#import "RegisterViewController.h"

#import "Icon_TextField_Cell.h"
#import "Icon_TextField_Button_Cell.h"
#import "RegisterButtonView.h"

#import "LLLockViewController.h"
@interface RegisterViewController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIAlertViewDelegate, UIGestureRecognizerDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *icon_img_ary, *cell_placeholder_ary;
@property (nonatomic, strong) RegisterButtonView *buttonView;
@property (nonatomic, strong) UITextField *phone_textField, *auth_code_textField, *password_textField, *invite_phone_textField;
@end

@implementation RegisterViewController

-(void)viewDidLoad{
    
    [super viewDidLoad];
    self.tableView.separatorColor = [UIColor colorWithHex:@"#e1e1e1"];
}

- (void)init_ui {
    [super init_ui];
    [self set_tableFooterView];
    _icon_img_ary = @[@"v1_icon_phone", @"v1_icon_auth_code", @"v1_icon_password", @"v1_icon_user_add"];
    _cell_placeholder_ary = @[@"请输入手机号码", @"请输入短信验证码", @"设置6-16位登录密码", @"如有邀请人，请输入邀请人手机号"];
    [self set_close_keyboard];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self close_keyboard];
    [SVProgressHUD dismiss];
}
#pragma mark 设置tablefooterView 登录按钮/忘记密码按钮
- (void)set_tableFooterView {
    _buttonView = [RegisterButtonView load_nib];
    _buttonView.bottom_view.hidden = NO;
    [_buttonView setButtonIsenabled:false];
    [_buttonView.sure_button addTarget:self action:@selector(click_register_button) forControlEvents:UIControlEventTouchUpInside];
    [_buttonView.is_agree_button addTarget:self action:@selector(click_agree_button:) forControlEvents:UIControlEventTouchUpInside];
    [_buttonView.property_button addTarget:self action:@selector(go_property_vc) forControlEvents:UIControlEventTouchUpInside];
    [_buttonView.accessory_button addTarget:self action:@selector(click_service_phone) forControlEvents:UIControlEventTouchUpInside];
    
}
#pragma mark 客服
- (void)click_service_phone
{
    [CMCore call_service_phone_with_view:self.view phone:SERVICE_PHONE];
}
#pragma mark 注册按钮
- (void)click_register_button {
    [self close_keyboard];
    if (![CMCore checkPhoneValid:_phone_textField.text]) {
        [[JPAlert current] showAlertWithTitle:@"手机号格式不正确" button:@"好的"];
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
    if (_invite_phone_textField.text.length > 0) {
        if (![CMCore checkPhoneValid:_invite_phone_textField.text] || _invite_phone_textField.text.length < 11) {
            [[JPAlert current] showAlertWithTitle:@"请输入邀请人手机号码（11位数字）,并确定其正确性" button:@"好的"];
            return;
        }
    }
//注册
    [self go_register];
    
}
#pragma mark 同意协议按钮
- (void)click_agree_button:(UIButton*)button {
    [self close_keyboard];
    if (button.selected) {
        button.selected = NO;
        if (_phone_textField.text.length > 0 && _auth_code_textField.text.length > 0 && _password_textField.text.length > 0) {
            [_buttonView setButtonIsenabled:YES];
        }else
        {
            [_buttonView setButtonIsenabled:NO];
        }
    }else
    {
        button.selected = YES;
        if (_buttonView.sure_button.enabled) {
            [_buttonView setButtonIsenabled:NO];
        }
    }
}
#pragma mark 发送验证码，100 注册 200忘记密码
- (void)click_send_message_button:(LTimerButton *)button {
    [self close_keyboard];
    if (![CMCore checkPhoneValid:_phone_textField.text]) {
        [[JPAlert current] showAlertWithTitle:@"手机号格式不正确" button:@"好的"];
        return;
    }
    [self send_message_with_button:button];
}
#pragma mark tableView delegate/dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
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
    if (indexPath.section == 1 && indexPath.row == 1) {
        _tableView.tableFooterView = _buttonView;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 1) {
        Icon_TextField_Button_Cell *cell = [tableView load_reuseable_cell_from_nib_with_class:[Icon_TextField_Button_Cell class]];
        [cell.send_message_button addTarget:self action:@selector(click_send_message_button:) forControlEvents:UIControlEventTouchUpInside];
        cell.imageView.image = [UIImage imageNamed:_icon_img_ary[1]];
        cell.myTextField.placeholder = _cell_placeholder_ary[1];
        
        _auth_code_textField = cell.myTextField;
        cell.myTextField.keyboardType = UIKeyboardTypeNumberPad;
        cell.myTextField.delegate = self;
        return cell;
    }else
    {
        Icon_TextField_Cell *cell = [tableView load_reuseable_cell_from_nib_with_class:[Icon_TextField_Cell class]];
        cell.imageView.image = [UIImage imageNamed:_icon_img_ary[indexPath.section * 2 + indexPath.row]];
        cell.myTextField.placeholder = _cell_placeholder_ary[indexPath.section * 2 + indexPath.row];
        cell.myTextField.returnKeyType = UIReturnKeyDone;
        cell.myTextField.delegate = self;
        cell.myTextField.keyboardType = UIKeyboardTypeNumberPad;
        if (indexPath.section == 0 && indexPath.row == 0) {
            _phone_textField = cell.myTextField;
        }else if (indexPath.section == 1) {
            if (indexPath.row == 0) {
                _password_textField = cell.myTextField;
                cell.myTextField.keyboardType = UIKeyboardTypeNamePhonePad;
            }else
            {
                _invite_phone_textField = cell.myTextField;
            }
        }
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark 输入框 delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ((textField == _password_textField && [NSString stringWithFormat:@"%@%@",_password_textField.text, string].length > 0 && _phone_textField.text.length >  0 && _auth_code_textField.text.length > 0) ||
        (textField == _auth_code_textField && [NSString stringWithFormat:@"%@%@",_auth_code_textField.text, string].length > 0 && _password_textField.text.length >  0 && _phone_textField.text.length > 0) ||
        (textField == _phone_textField && [NSString stringWithFormat:@"%@%@",_phone_textField.text, string].length > 0 && _password_textField.text.length >  0 && _auth_code_textField.text.length > 0) ||
        (textField == _invite_phone_textField && [NSString stringWithFormat:@"%@%@",_invite_phone_textField.text, string].length > 0 && _password_textField.text.length > 0 && _phone_textField.text.length > 0 && _auth_code_textField.text.length > 0)) {
        [_buttonView setButtonIsenabled:YES];
    }else
    {
        [_buttonView setButtonIsenabled:NO];
    }
    
    if ([string isEqualToString:@""] && textField.text.length - 1 == 0) {
        [_buttonView setButtonIsenabled:NO];
        return YES;
    }
    if (textField == _phone_textField || textField == _invite_phone_textField) {
        if ([NSString stringWithFormat:@"%@%@",textField.text, string].length <=11) {
            return YES;
        }
        [_phone_textField resignFirstResponder];
        [_invite_phone_textField resignFirstResponder];
        return NO;
    }
    if ((textField == _phone_textField || textField == _auth_code_textField || textField == _invite_phone_textField) && ![CMCore checkNumberValid:[NSString stringWithFormat:@"%@%@",textField.text, string]]) {
        return NO;
    }
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (_phone_textField.text.length > 0 && _auth_code_textField.text.length > 0 && _password_textField.text.length > 0) {
        [_buttonView setButtonIsenabled:YES];
    }else
    {
        [_buttonView setButtonIsenabled:NO];
    }
}
- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    [_buttonView setButtonIsenabled:NO];
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
#pragma mark alertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == alertView.cancelButtonIndex) {
        
    }else
    {
        LLLockViewController *llock_vc = [self.storyboard instantiateViewControllerWithIdentifier:@"LLLockViewController"];
        llock_vc.nLockViewType = LLLockViewTypeCreate;
        [self presentViewController:llock_vc animated:YES completion:nil];
    }
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
    [_invite_phone_textField resignFirstResponder];
}
#pragma mark tap delegate
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return YES;
}
#pragma mark 查看注册协议
- (void)go_property_vc {
    [self close_keyboard];
    WebViewController *web_vc = [self.storyboard instantiateViewControllerWithIdentifier:@"WebViewController"];
    //注册协议user_registered_protocol
    NSString *url = [CMCore getH5AddressWithEnterType:H5EnterTypeUserRegistered targeId:nil markType:0];
    [web_vc load_withUrl:url title:@"协议与政策" canScaling:YES];// isShowCloseItem:YES
    [self go_next:web_vc animated:YES viewController:self];
}
#pragma mark 网络请求－注册
- (void)go_register {
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD showWithStatus:@"正在注册"];
    [CMCore register_with_mobile_phone:_phone_textField.text auth_code:_auth_code_textField.text password:_password_textField.text invite_code:_invite_phone_textField.text is_alert:YES blockResult:^(NSNumber *code, id result, NSString *message) {
        [SVProgressHUD dismiss];
        
        if (result) {
            [[JPAlert current] showAlertWithTitle:@"温馨提示" content:@"注册成功" button:@[@"确定"] block:^(UIAlertView *alert, NSInteger index) {
                [self.navigationController popViewControllerAnimated:YES];
            }];
            // 不返回用户数据
            //提示设置手势密码
            [CMCore setIs_ti_shi_set_gesture:YES];
        }
    } blockRetry:^(NSInteger index) {
        [SVProgressHUD dismiss];
        if (index == 1) {
            [self click_register_button];
        }
    }];
}
#pragma mark 网络请求－发送验证码
- (void)send_message_with_button:(LTimerButton*)button
{
    [button startTimerWithCount:60];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD showWithStatus:@"正在发送验证码"];
    [CMCore get_auth_code_with_with_mobile_phone:_phone_textField.text is_alert:YES blockResult:^(NSNumber *code, id result, NSString *message) {
        [SVProgressHUD dismiss];
        if ([code integerValue] == 200) {
            [SVProgressHUD setMinimumDismissTimeInterval:1.5];
            [SVProgressHUD showSuccessWithStatus:@"发送成功，请查收"];
        }
    } blockRetry:^(NSInteger index) {
        if (index == 1) {
            [self click_send_message_button:button];
        }
    }];
}
@end
