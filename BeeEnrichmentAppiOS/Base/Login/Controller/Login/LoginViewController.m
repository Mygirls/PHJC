//
//  LoginViewController.m
//  BeeEnrichmentAppiOS
//
//  Created by dll on 15/12/21.
//  Copyright © 2015年 didai. All rights reserved.
//

#import "LoginViewController.h"

#import "LoginButtonView.h"
#import "Icon_TextField_Cell.h"
#import "Icon_TextField_IsSecurity_Cell.h"
#import "Icon_TextField_Button_Cell.h"
#import <HMSegmentedControl/HMSegmentedControl.h>
#import "LLLockViewController.h"
#import "ForgetPasswordViewController.h"
#import "CMBaseTabBarController.h"
#import "VerifyViewController.h"

@interface LoginViewController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate, UIAlertViewDelegate>
@property (strong, nonatomic) IBOutlet UIView *view_for_segment;
@property (strong, nonatomic) IBOutlet UITableView *login_tableView;
@property (nonatomic, strong) LoginButtonView *buttonView;
@property (nonatomic, strong) Icon_TextField_Button_Cell *codeCell;
@property (nonatomic, strong) Icon_TextField_IsSecurity_Cell *passwordCell;

@property (nonatomic, strong) UITextField *phone_textField, *password_textField, *auth_code_textField;
@property (nonatomic, assign) BOOL isFastLogin, isStartEditing;
@property (nonatomic, strong) HMSegmentedControl *segment;

@end

@implementation LoginViewController


-(void)viewDidLoad{

    [super viewDidLoad];
    self.login_tableView.separatorColor = [UIColor colorWithHex:@"#e1e1e1"];
}

- (void)init_ui {
    [super init_ui];
    [self set_close_keyboard];
    [self set_tableFooterView];
    [self set_segment];
    [self setInitInfo];
    _isFastLogin = false;
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self close_keyboard];
}
- (void)setInitInfo {
    if (_passwordCell == nil) {
        _passwordCell = [[NSBundle mainBundle] loadNibNamed:@"Icon_TextField_IsSecurity_Cell" owner:nil options:nil].lastObject;
        [_passwordCell.is_security_button addTarget:self action:@selector(click_is_security_button:) forControlEvents:UIControlEventTouchUpInside];
        _passwordCell.imageView.image = [UIImage imageNamed:@"v1_icon_password"];
        _passwordCell.textField.placeholder = @"请输入登录密码";
        _passwordCell.textField.returnKeyType = UIReturnKeyDone;
        _passwordCell.textField.keyboardType = UIKeyboardTypeDefault;
        _password_textField = _passwordCell.textField;
        _passwordCell.textField.delegate = self;
    }
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
    [_buttonView.login_btn addTarget:self action:@selector(click_login_button) forControlEvents:UIControlEventTouchUpInside];
    [_buttonView.forget_password_btn addTarget:self action:@selector(go_forget_password_vc) forControlEvents:UIControlEventTouchUpInside];
}
#pragma mark 设置segment
- (void)set_segment
{
    if (_segment == nil) {
        NSDictionary *defaults = @{
                                   NSFontAttributeName : [UIFont systemFontOfSize:14],
                                   NSForegroundColorAttributeName : [UIColor grayColor],
                                   };
        NSDictionary *selected = @{
                                   NSFontAttributeName : [UIFont systemFontOfSize:14],
                                   NSForegroundColorAttributeName : [CMCore basic_color],
                                   };
        
        _segment = [[HMSegmentedControl alloc] initForAutoLayout];
        [_view_for_segment addSubview:_segment];
        _segment.selectionIndicatorHeight = 3;
        _segment.titleTextAttributes = defaults;
        _segment.selectedTitleTextAttributes = selected;
        [_segment addTarget:self action:@selector(segment_change_valued:) forControlEvents:UIControlEventValueChanged];
        
        _segment.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
        _segment.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
        _segment.backgroundColor = [UIColor clearColor];
        _segment.selectionIndicatorColor = [CMCore basic_color];
        
        [_segment autoPinEdgeToSuperviewEdge:ALEdgeTop];
        [_segment autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [_segment autoPinEdgeToSuperviewEdge:ALEdgeRight];
        [_segment autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:1];
        
        _segment.sectionTitles = @[@"普通登录", @"手机动态密码登录"];
        
    }
}
- (void)segment_change_valued:(HMSegmentedControl*)segment_control
{
    [self close_keyboard];
    if (segment_control.selectedSegmentIndex == 0) {
        _isFastLogin = NO;
    }else
    {
        _isFastLogin = YES;
    }
    if (_isFastLogin) {
        [_buttonView setButtonTitle:@"动态密码登录" isShowAccessoryBtn:NO];
    }else
    {
        [_buttonView setButtonTitle:@"立即登录" isShowAccessoryBtn:YES];
    }
    [_login_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark 返回
- (IBAction)click_left_item:(id)sender {
    [self close_keyboard];
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    CMBaseTabBarController *rootTab = (CMBaseTabBarController *)keyWindow.rootViewController;
    [rootTab setSelectedIndex:0];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
#pragma mark 密码安全输入
- (void)click_is_security_button:(UIButton *)btn {
    [self close_keyboard];
    if (btn.selected) {
        btn.selected = NO;
        _password_textField.secureTextEntry = YES;
    }else
    {
        btn.selected = YES;
        _password_textField.secureTextEntry = NO;
    }
}
#pragma mark 登录按钮
- (void)click_login_button {
    [self close_keyboard];
    
    if (!_isFastLogin) {
        //登录密码登录
//        if (![CMCore checkPhoneValid:_phone_textField.text]) {
//            [[JPAlert current] showAlertWithTitle:@"手机号码格式不正确" button:@"好的"];
//            return;
//        }
        if (![CMCore check_login_pasword_valid:_password_textField.text]) {
            [[JPAlert current] showAlertWithTitle:@"请输入登录密码(6-16位),只允许包含数字，字符，字母" button:@"好的"];
            return;
        }
        [self go_login];
    }else {
    //发送验证码
    if (![CMCore checkPhoneValid:_phone_textField.text]) {
        [[JPAlert current] showAlertWithTitle:@"手机号码格式不正确" button:@"好的"];
            return;
        }
    if (![CMCore checkNumberValid:_auth_code_textField.text]) {
            [[JPAlert current] showAlertWithTitle:@"验证码只可为纯数字" button:@"好的"];
            return;
    }
        [self fast_login];
        
        
    }
//    [self huoquyanzhengma];
}
#pragma mark 发送验证码
- (void)click_send_message_button:(LTimerButton*)button
{
    [self close_keyboard];
    if (![CMCore checkPhoneValid:_phone_textField.text]) {
        [[JPAlert current] showAlertWithTitle:@"手机号码格式不正确" button:@"好的"];
        return;
    }
    [self get_auth_code:button];
}
#pragma mark tableView delegate/dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
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
    return kSectionFooterHeight;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_login_tableView.tableFooterView == nil && indexPath.row == 1) {
        _login_tableView.tableFooterView = _buttonView;
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
        //普通登录
    if (indexPath.row == 0) {
        
        Icon_TextField_Cell *cell =  [tableView load_reuseable_cell_from_nib_with_class:[Icon_TextField_Cell class]];
        cell.imageView.image = [UIImage imageNamed:@"v1_icon_phone"];
        cell.myTextField.placeholder = @"请输入手机号";
        if (_phone_textField) {
            cell.myTextField.text = _phone_textField.text;
        }
        _phone_textField = cell.myTextField;
//        cell.myTextField.keyboardType = UIKeyboardTypeNumberPad;
        cell.myTextField.delegate = self;
        return cell;
    }else if (_isFastLogin) {
        return _codeCell;
    }else
    {
        return _passwordCell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self close_keyboard];
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
//        if ([CMCore checkNumberValid:str]) {
//            if (str.length > 11) {
//                [textField resignFirstResponder];
//            }
//        }else
//        {
//            [textField resignFirstResponder];
//        }
    }
    
    if (str.length > 0 && (_phone_textField.text.length > 0 && ((_isFastLogin && _auth_code_textField.text.length > 0) || (!_isFastLogin && _password_textField.text.length > 0)))) {
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
    if ((!_isFastLogin && _phone_textField.text.length > 0 && _password_textField.text.length > 0) ||
        (_isFastLogin && _phone_textField.text.length > 0 && _auth_code_textField.text.length > 0)) {
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
- (void)close_keyboard {
    [_phone_textField resignFirstResponder];
    [_password_textField resignFirstResponder];
    [_auth_code_textField resignFirstResponder];
    [self.view resignFirstResponder];
}
#pragma mark tap delegate
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (_isStartEditing) {
        _isStartEditing = NO;
        return YES;
    }
    return NO;
}
#pragma mark 忘记密码
- (void)go_forget_password_vc {
    [self close_keyboard];
    ForgetPasswordViewController *forget_vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ForgetPasswordViewController"];
    forget_vc.setPasswordType = SetPasswordTypeForget;
    [self go_next:forget_vc animated:YES viewController:self];
}
#pragma mark 网络请求－快速登录
- (void)fast_login
{
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD showWithStatus:@"正在登录..."];
    [CMCore fast_login_with_mobile:_phone_textField.text auth_code:_auth_code_textField.text is_alert:YES blockResult:^(NSNumber *code, id result, NSString *message) {
        [SVProgressHUD dismiss];
        if (result) {
            //保存user_info
            [CMCore save_user_info_with_member:result[@"member"]];
            //保存 access_token
            [CMCore save_access_token:result[@"accessToken"]];
            
            // UM登录埋点
          //  [MobClick profileSignInWithPUID:result[@"member"][@"_id"]];
            
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
            [self click_login_button];
        }
    }];
    
    
}
/*
 mobile_phone //手机号码
 access_token  //密钥
 memberId //用户ID
 beePlanId //标的ID
 */
#pragma mark 网络请求－普通登录
- (void)go_login {
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD showWithStatus:@"正在登录..."];
    [CMCore login_with_mobile_phone:_phone_textField.text password:_password_textField.text is_alert:YES blockResult:^(NSNumber *code, id result, NSString *message) {
        [SVProgressHUD dismiss];
        if (result) {
            NSDictionary *dic = result;
            MemberModel *memberInfoMD = [MemberModel mj_objectWithKeyValues:dic[@"member"]];
            if (memberInfoMD.sourceFrom && memberInfoMD.isBindMobilePhone == 1) {//sourceFrom == 1 老用户
                [CMCore save_user_info_with_member:dic[@"member"]];
                VerifyViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"VerifyViewController"];
                vc.memberDic = dic;
                vc.memberName = _phone_textField.text;
                [self.navigationController pushViewController:vc animated:YES];
            } else {
                [CMCore save_user_info_with_member:dic[@"member"]];
                [CMCore save_access_token:result[@"accessToken"]];
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
            
        }
    } blockRetry:^(NSInteger index) {
        [SVProgressHUD dismiss];
        if (index == 1) {
            [self go_login];
        }
    }];
}
#pragma mark 网络请求－获取验证码
- (void)get_auth_code:(LTimerButton*)button
{
    
    [button startTimerWithCount:60];
    [CMCore get_auth_code_with_with_mobile_phone:_phone_textField.text is_alert:YES blockResult:^(NSNumber *code, id result, NSString *message) {
        if ([code integerValue] == 200) {
            [SVProgressHUD setMinimumDismissTimeInterval:1.5];
            [SVProgressHUD showSuccessWithStatus:@"发送成功，请查收"];
        }
    } blockRetry:^(NSInteger index) {
        if (index == 1) {
            [self get_auth_code:button];
        }
    }];
}

@end
