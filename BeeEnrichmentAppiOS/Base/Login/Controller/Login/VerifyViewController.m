//
//  VerifyViewController.m
//  BeeEnrichmentAppiOS
//
//  Created by dll on 2017/7/9.
//  Copyright © 2017年 DuLonglong. All rights reserved.
//

#import "VerifyViewController.h"

#import "LoginButtonView.h"
#import "Icon_TextField_Cell.h"
#import "Icon_TextField_IsSecurity_Cell.h"
#import "Icon_TextField_Button_Cell.h"
#import "LLLockPassword.h"

@interface VerifyViewController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate, UIAlertViewDelegate>
@property (strong, nonatomic) IBOutlet UIView *view_for_segment;
@property (strong, nonatomic) IBOutlet UITableView *login_tableView;
@property (nonatomic, strong) LoginButtonView *buttonView;
@property (nonatomic, strong) UITextField *phone_textField, *password_textField, *auth_code_textField;
@property (nonatomic, assign) BOOL isStartEditing;
@property (nonatomic, strong) Icon_TextField_Button_Cell *codeCell;

@end

@implementation VerifyViewController


-(void)viewDidLoad{
    
    [super viewDidLoad];
    
    [self set_tableFooterView];
    [self setInitInfo];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    _contentLabel.text = [NSString stringWithFormat:@"       %@，您好，因对接银行存管系统升级为了您的账户安全，请您绑定手机号码", _memberDic[@"member"][@"realname"]];
}

- (void)setInitInfo {
    if (_codeCell == nil) {
        _codeCell = [[NSBundle mainBundle] loadNibNamed:@"Icon_TextField_Button_Cell" owner:nil options:nil].lastObject;
        [_codeCell.send_message_button addTarget:self action:@selector(click_send_message_button:) forControlEvents:UIControlEventTouchUpInside];
        _codeCell.myTextField.delegate = self;
        _codeCell.myTextField.keyboardType = UIKeyboardTypeNumberPad;
        _codeCell.myTextField.placeholder = @"请输入验证码";
        _codeCell.imageView.image = [UIImage imageNamed:@"v1_icon_auth_code"];
        _auth_code_textField = _codeCell.myTextField;
    }
}

#pragma mark 设置tablefooterView 登录按钮/忘记密码按钮
- (void)set_tableFooterView {
    _buttonView = [LoginButtonView load_nib];
    [_buttonView setButtonIsenabled:NO];
    [_buttonView.login_btn setTitle:@"立即验证" forState:UIControlStateNormal];
    [_buttonView.login_btn addTarget:self action:@selector(click_login_button) forControlEvents:UIControlEventTouchUpInside];
    _buttonView.forget_password_btn.hidden = YES;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_login_tableView.tableFooterView == nil && indexPath.row == 1) {
        _login_tableView.tableFooterView = _buttonView;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kSectionFooterHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return kSectionFooterHeight;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        
        Icon_TextField_Cell *cell =  [tableView load_reuseable_cell_from_nib_with_class:[Icon_TextField_Cell class]];
        cell.imageView.image = [UIImage imageNamed:@"v1_icon_phone"];
        cell.myTextField.placeholder = @"请输入手机号";
        if (_phone_textField) {
            cell.myTextField.text = _phone_textField.text;
        }
        _phone_textField = cell.myTextField;
        cell.myTextField.keyboardType = UIKeyboardTypeNumberPad;
        cell.myTextField.delegate = self;
        if (_memberDic[@"member"][@"mobilePhone"] != nil) {
            _phone_textField.text = _memberDic[@"member"][@"mobilePhone"];
        }
        return cell;
    } else {
        return _codeCell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

- (void)close_keyboard {
    [_phone_textField resignFirstResponder];
    [_auth_code_textField resignFirstResponder];
    [_password_textField resignFirstResponder];
}

#pragma mark textField delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *str = textField.text;
    if ([string isEqualToString:@""]) {
        //当前是删除操作
        if (textField.text.length > 0) {
            str = [str substringToIndex:str.length-1];
        }else
        {
            [textField resignFirstResponder];
        }
    }else
    {
        str = [NSString stringWithFormat:@"%@%@",textField.text,string];
    }
    if (textField == _phone_textField && str.length > 0) {
        if ([CMCore checkNumberValid:str]) {
            if (str.length > 11) {
                [textField resignFirstResponder];
            }
        }else
        {
            [textField resignFirstResponder];
        }
    }
    if (textField == _auth_code_textField && str.length > 0 && ![CMCore checkNumberValid:str]) {
        [textField resignFirstResponder];
    }
    if (str.length > 0 && (_phone_textField.text.length > 0 && _auth_code_textField.text.length > 0)) {
        [_buttonView setButtonIsenabled:YES];
    }else
    {
        [_buttonView setButtonIsenabled:NO];
    }
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self set_is_enabled_login_button];
}

- (void)set_is_enabled_login_button
{
    if (_phone_textField.text.length > 0 && _auth_code_textField.text.length > 0) {
        [_buttonView setButtonIsenabled:YES];
    }else
    {
        [_buttonView setButtonIsenabled:NO];
    }
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    _isStartEditing = YES;
    if (textField == _phone_textField && _isStartEditing) {
        [_codeCell.send_message_button stopTimer];
    }
    return YES;
}
- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    [_buttonView setButtonIsenabled:NO];
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    _isStartEditing = NO;
    if (self.password_textField == textField) {
        
        [self click_login_button];
    }
    if (self.phone_textField == textField) {
        [self.password_textField becomeFirstResponder];
    }
    return YES;
}

#pragma mark 设置轻拍手势，点击空白区域键盘消失
- (void)set_close_keyboard {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(close_keyboard)];
    tap.delegate = self;
    [_login_tableView addGestureRecognizer:tap];
}

#pragma mark tap delegate
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (_isStartEditing) {
        _isStartEditing = NO;
        return YES;
    }
    return NO;
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

#pragma mark 登录按钮
- (void)click_login_button {
    [self close_keyboard];
        //发送验证码
        if (![CMCore checkPhoneValid:_phone_textField.text]) {
            [[JPAlert current] showAlertWithTitle:@"手机号码格式不正确" button:@"好的"];
            return;
        }
        if (![CMCore checkNumberValid:_auth_code_textField.text]) {
            [[JPAlert current] showAlertWithTitle:@"验证码只可为纯数字" button:@"好的"];
            return;
        }
    [self verifyLogin];
}

#pragma mark 验证登录
- (void)verifyLogin
{
    NSDictionary *dic = _memberDic[@"member"];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD showWithStatus:@"正在验证..."];
    [CMCore auth_verify_with_login_member_id:dic[@"accountCash"][@"memberId"] user_name:dic[@"realname"] auth_code:_auth_code_textField.text mobile_phone:_phone_textField.text is_alert:YES blockResult:^(NSNumber *code, id result, NSString *message) {
        [SVProgressHUD dismiss];
        if (result) {
            //            //保存user_info
            [CMCore save_user_info_with_member:result[@"member"]];
            //            //保存 access_token
            [CMCore save_access_token:result[@"accessToken"]];
            // UM登录埋点
            // [MobClick profileSignInWithPUID:result[@"member"][@"id"]];
            
            if ([LLLockPassword loadLockPassword].length > 0) {
                //有手势密码
                [CMCore setIs_ti_shi_set_gesture:NO];
            }else
            {
                [CMCore setIs_ti_shi_set_gesture:YES];
                
            }
            
            [self close_keyboard];
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        }

    } blockRetry:^(NSInteger index) {
        [SVProgressHUD dismiss];
        if (index == 1) {
            [self verifyLogin];
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
