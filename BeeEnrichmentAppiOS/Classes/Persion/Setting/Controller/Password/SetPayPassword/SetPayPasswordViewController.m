//
//  SetPayPasswordViewController.m
//  BeeEnrichmentAppiOS
//
//  Created by dll on 16/1/5.
//  Copyright © 2016年 didai. All rights reserved.
//

#import "SetPayPasswordViewController.h"
#import "Icon_TextField_Cell.h"
#import "ClickButtonView.h"
#import "ProductViewController.h"
#import "TransferProductViewController.h"
#import "BankCardInformationViewController.h"//添加银行卡信息
#import "PayViewController.h"//支付
//#import "ManagePasswordViewController.h"//管理密码
#import "SetPayPasswordCell.h"

@interface SetPayPasswordViewController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *cell_placeholder_ary;
@property (nonatomic, strong) UITextField *newpassword_textField1, *newpassword_textField2;//
@property (nonatomic, strong) ClickButtonView *click_button_view;

@end

@implementation SetPayPasswordViewController

- (void)init_ui
{
    [super init_ui];

    _cell_placeholder_ary = @[@"请输入6位数字密码", @"请输入确认密码"];
    [_tableView setSeparatorInset:UIEdgeInsetsZero];
    [_tableView setSeparatorColor:[UIColor colorWithHex:@"#e1e1e1"]];
    [self set_close_keyboard];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self close_keyboard];
    [SVProgressHUD dismiss];
}
- (void)set_tableFooterView
{
    _click_button_view = [ClickButtonView load_nib];
    [self set_button_disabled];
    [_click_button_view.click_button setTitle:@"确定" forState:UIControlStateNormal];
    [_click_button_view.click_button addTarget:self action:@selector(click_sure_button) forControlEvents:UIControlEventTouchUpInside];
    _tableView.tableFooterView = _click_button_view;
}

#pragma mark 设置button可用／不可用
- (void)set_button_disabled
{
    _click_button_view.click_button.enabled = NO;
    [_click_button_view.click_button setBackgroundColor:[UIColor colorWithRed:0.80 green:0.80 blue:0.80 alpha:1.00]];
}
- (void)set_button_enabled
{
        _click_button_view.click_button.alpha = 1.0;
    _click_button_view.click_button.enabled = YES;
    [_click_button_view.click_button setBackgroundColor:[UIColor colorWithHex:@"#f95f53"]];
}
#pragma mark 点击 设置／修改支付密码／ 忘记支付密码
- (void)click_sure_button
{
    [self close_keyboard];
    if (![CMCore checkNumberValid:_newpassword_textField1.text] || ![CMCore checkNumberValid:_newpassword_textField2.text] || ![_newpassword_textField1.text isEqualToString:_newpassword_textField2.text] || _newpassword_textField1.text.length != 6) {
        [[JPAlert current] showAlertWithTitle:@"设置失败" content:@"新密码位数为6位纯数字且两次输入必须一致" button:@"好的" block:^(UIAlertView *alert, NSInteger index) {
        }];
        return;
    }else if ([_login_password_str isEqualToString:_newpassword_textField1.text]) {
        [[JPAlert current] showAlertWithTitle:@"设置失败" content:@"支付密码不能跟登录密码一样" button:@"好的" block:^(UIAlertView *alert, NSInteger index) {
        }];
        return;
    }
    
    [self set_payPassword];
    
    
    
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
    return kSectionHeaderHeight;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 1) {
      [self set_tableFooterView];
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    Icon_TextField_Cell *cell = [tableView load_reuseable_cell_from_nib_with_class:[Icon_TextField_Cell class]];
    
    SetPayPasswordCell *cell = [tableView load_reuseable_cell_from_nib_with_class:[SetPayPasswordCell class]];
    __weak typeof(cell) __cell = cell;
    cell.SetPayPasswordCellClickBtn = ^(){
        [self close_keyboard];
        if (indexPath.row == 0) {
            if (__cell.is_showmima_btn.selected) {
                __cell.is_showmima_btn.selected = NO;
                _newpassword_textField1.secureTextEntry = YES;
            }else
            {
                __cell.is_showmima_btn.selected = YES;
                _newpassword_textField1.secureTextEntry = NO;
            }
        }else {
            if (__cell.is_showmima_btn.selected) {
                __cell.is_showmima_btn.selected = NO;
                _newpassword_textField2.secureTextEntry = YES;
            }else
            {
                __cell.is_showmima_btn.selected = YES;
                _newpassword_textField2.secureTextEntry = NO;
            }
        }
        
  
    };
    NSInteger index = indexPath.row;
    cell.contentTextFile.secureTextEntry = YES;
    cell.contentTextFile.placeholder = _cell_placeholder_ary[index];
    cell.contentTextFile.delegate = self;
    cell.contentTextFile.keyboardType = UIKeyboardTypeNumberPad;
    if (indexPath.row == 0) {
        cell.titleLable.text = @"密码       ";
        _newpassword_textField1 = cell.contentTextFile;
    }else if (indexPath.row == 1)
    {
        cell.titleLable.text = @"确认密码";
        _newpassword_textField2 = cell.contentTextFile;
    }
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
    }else if ([CMCore checkNumberValid:string]) {
        if ((textField == _newpassword_textField1 && [NSString stringWithFormat:@"%@%@",_newpassword_textField1.text, string].length > 0 && _newpassword_textField2.text.length > 0) || (textField == _newpassword_textField2 && [NSString stringWithFormat:@"%@%@",_newpassword_textField2.text, string].length > 0 && _newpassword_textField1.text.length > 0)) {
            [self set_button_enabled];
            
        }else
        {
            [self set_button_disabled];
        }
        NSString *str = [NSString stringWithFormat:@"%@%@",textField.text, string];
        if (str.length == 7) {
            DLog(@"%@",textField.text);
            [textField resignFirstResponder];
            return NO;
        }
    }else {
        return NO;
    }
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (_newpassword_textField1.text.length > 0 && _newpassword_textField2.text.length > 0) {
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
    [_newpassword_textField1 resignFirstResponder];
    [_newpassword_textField2 resignFirstResponder];
}
#pragma mark tap delegate
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return YES;
}
#pragma mark 支付
- (void)go_pay_vc
{
    PayViewController *pay_vc = [self.storyboard instantiateViewControllerWithIdentifier:@"PayViewController"];
    
    pay_vc.data_dic = _data_dic;
    [self go_next:pay_vc animated:YES viewController:self];
}
#pragma mark 填写银行卡信息
- (void)go_add_bank_vc
{
    BankCardInformationViewController *add_bank_vc = [self.storyboard instantiateViewControllerWithIdentifier:@"BankCardInformationViewController"];
    add_bank_vc.data_dic = _data_dic;
    [self go_next:add_bank_vc animated:YES viewController:self];
}
//#pragma mark 网络请求－忘记交易密码
//- (void)forget_payPassword
//{
//    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
//    [SVProgressHUD showWithStatus:@"正在更新交易密码"];
//    [CMCore forget_pay_passwd_with_login_passwd:_login_password_str pay_password:_newpassword_textField1.text is_alert:YES blockResult:^(NSNumber *code, id result, NSString *message) {
//        [SVProgressHUD dismiss];
//        if ([code integerValue] == 200) {
//            //更新成功
//            if (![_enterType isEqualToString:@"setting"]) {
//                PayViewController *pay_vc = [self find_with_class:[PayViewController class]];
//                if ([pay_vc isKindOfClass:[NSNull class]]) {
//                    [self go_back:YES viewController:self];
//                }else
//                {
//                    [self go_back_to:pay_vc animated:YES];
//                }
//                return ;
//            }
//            if (_data_dic) {
//                //有产品信息
//                if ([[result[@"member"] allKeys] containsObject:@"bank_card_info"]) {
////                    / || [result[@"member"][@"remaining_sum"] doubleValue] > 0
//                    //有银行卡
//                    [self go_pay_vc];
//                }else
//                {
//                    //没有绑定银行卡
//                    [self go_add_bank_vc];
//                }
//                
//            }else
//            {
////                ManagePasswordViewController *manage_vc = [self find_with_class:[ManagePasswordViewController class]];
////                if (manage_vc) {
////                    [self go_back_to:manage_vc animated:YES];
////                }else
////                {
//                    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
//                    [SVProgressHUD showSuccessWithStatus:@"设置成功"];
//                    
//                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                        [SVProgressHUD dismiss];
//                        //没有产品信息
//                        [self go_back:YES viewController:self];
//                        
//                    });
////                }
//            }
//            
//        }
//    } blockRetry:^(NSInteger index) {
//        [SVProgressHUD dismiss];
//        if (index == 1) {
//            [self click_sure_button];
//        }
//    }];
//}
#pragma mark 网络请求－修改／设置交易密码
- (void)set_payPassword
{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD showWithStatus:@"正在设置交易密码"];
    [CMCore update_pay_passwd_with_pay_password:_newpassword_textField1.text is_alert:YES blockResult:^(NSNumber *code, id result, NSString *message) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showSuccessWithStatus:@"设置成功"];
        if (result) {
            [CMCore save_user_info_with_member:result[@"member"]];
            //            if (![_enterType isEqualToString:@"setting"]) {
            //                PayViewController *pay_vc = [self find_with_class:[PayViewController class]];
            //                if ([pay_vc isKindOfClass:[NSNull class]]) {
            //                    [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
            //                }else {
            //                    [self.navigationController popToViewController:pay_vc animated:YES];
            //                }
            //                return ;
            //            }
            if (_data_dic) {
                //有产品信息
                if ([self find_with_class:[ProductViewController class]]) {
                    ProductViewController *pay_vc = [self find_with_class:[ProductViewController class]];
                    [self.navigationController popToViewController:pay_vc animated:YES];
                }else if ([self find_with_class:[TransferProductViewController class]]){
                    TransferProductViewController *pay_vc = [self find_with_class:[TransferProductViewController class]];
                    [self.navigationController popToViewController:pay_vc animated:YES];
                } else {
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }
            } else {
                [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
                [SVProgressHUD showSuccessWithStatus:@"设置成功"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [SVProgressHUD dismiss];
                    //没有产品信息
                    [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
                });
            }
        }
    } blockRetry:^(NSInteger index) {
        [SVProgressHUD dismiss];
        if (index == 1) {
            [self click_sure_button];
        }
    }];
    
}
@end
