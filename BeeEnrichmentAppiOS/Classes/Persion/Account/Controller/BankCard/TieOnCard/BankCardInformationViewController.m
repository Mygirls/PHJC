//
//  BankCardInformationViewController.m
//  BeeEnrichmentAppiOS
//
//  Created by dll on 15/12/22.
//  Copyright © 2015年 didai. All rights reserved.
//

#import "BankCardInformationViewController.h"
#import "RegisterButtonView.h"
#import "Label_TextField_Cell.h"
#import "AlertPayMoneyView.h"
#import "PayViewController.h"
#import "ZSDPaymentView.h"
#import "BankCarInfoFootView.h"//footView
#import "WMPickerViewSheet.h"//弹窗
#import "CheckLoginPasswordViewController.h"
#import "SetPayPasswordViewController.h"

#import <FUMobilePay/FUMobilePay.h>
#import <FUMobilePay/NSString+Extension.h>


#define SectionHeadHeight 44

@interface BankCardInformationViewController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate, UIActionSheetDelegate, FYPayDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong)ZSDPaymentView *payment;
@property (nonatomic, strong) NSArray *cell_title_ary, *cell_placeholder_ary;
@property (nonatomic, strong) BankCarInfoFootView *buttonView;
@property (nonatomic, strong) UITextField *name_textField, *idCard_textField, *bankCard_textField, *phone_textField, *password_textField, *nameCarBank_textField;
@property (nonatomic, copy) NSString *order_no, *backCallUrlStr, *bank_name, *bank_code;

@property (nonatomic, strong) AlertPayMoneyView *alertMoneyNew;
@property (nonatomic, strong) AlertPayMoneyView *alertMoney;
@property (nonatomic, strong) UIView *backViewOfAlertMoney;
@property (nonatomic, strong) MemberModel *memberM;
@property (nonatomic, strong) WMPickerViewSheet *pickerViewSheet;

@end
__weak BankCardInformationViewController *_bankCardInfoSelf;
@implementation BankCardInformationViewController
- (void)init_ui {
    [super init_ui];
    _bankCardInfoSelf = self;
    _cell_title_ary = @[@"姓名", @"身份证号", @"银行卡", @"银行卡卡号", @"手机号"];
    _cell_placeholder_ary = @[@"请输入您的姓名", @"请输入您的身份证号",@"请输入您的开户银行",@"请输入您的银行卡卡号", @"请输入银行预留的手机号"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"支持银行" style:UIBarButtonItemStylePlain target:self action:@selector(goSuportBank)];
    [self get_user_info];
    [self set_close_keyboard];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (![CMCore is_login]) {
        self.tabBarController.selectedIndex = 0;
    }
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self close_keyboard];
    [SVProgressHUD dismiss];
}

#pragma mark 支持银行
- (void)goSuportBank {
    NSString *url = [CMCore getH5AddressWithEnterType:H5EnterTypeSupportBank targeId:nil markType:0];
    WebViewController *webVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"WebViewController"];
    [webVC load_withUrl:url title:@"支持银行" canScaling:NO];
    [self.navigationController pushViewController:webVC animated:YES];
}

#pragma mark 设置tablefooterView 登录按钮/忘记密码按钮
- (UIView *)set_tableFooterView {
    
    _pickerViewSheet = [WMPickerViewSheet load_nib];
    
    __weak typeof(self) weakSelf = self;
    _buttonView = [BankCarInfoFootView load_nib];
    [_buttonView setButtonIsenabled:NO];
    [_buttonView.registerBtn setTitle:@"确认" forState:UIControlStateNormal];
    //[_buttonView.registerBtn addTarget:self action:@selector(click_sure_button) forControlEvents:UIControlEventTouchUpInside];
    _buttonView.BankCarInfoFootViewClick = ^(NSInteger index) {
        if (index == 1) {// 同意
            [weakSelf click_agree_button:weakSelf.buttonView.isAgreeBtn];
        }else if (index == 2) {// 协议
            [weakSelf go_property_web_vc];
        }else if (index == 3) {// 确认
            [weakSelf click_sure_button];
        }
    };
    return _buttonView;
}
#pragma mark 点击确认按钮
- (void)click_sure_button {
    [self close_keyboard];
    if ([CMCore get_bank_card_info]) {
        if ([_typeOfStyle isEqualToString:@"007"]) {
            //绑定银行卡
            [self bank_card_send_sms_before_confirm];
        }else {
            //有银行卡信息
            if (![CMCore checkPhoneValid:_phone_textField.text]) {
                [[JPAlert current] showAlertWithTitle:@"请输入手机号" button:@"好的"];
                return;
            }
            //返回支付界面
            PayViewController *pay_vc = [self find_with_class:[PayViewController class]];
            if (pay_vc) {
                pay_vc.bankCardPhone = _phone_textField.text;
                [self go_back_to:pay_vc animated:YES];
            }
        }
    }else {
        //没有银行卡信息
        if (![CMCore checkNameValid:_name_textField.text]) {
            [[JPAlert current] showAlertWithTitle:@"请输入姓名" button:@"好的"];
            return;
        }
        if (_idCard_textField.text.length == 0 || ![CMCore checkIDCardValid:_idCard_textField.text]) {
            [[JPAlert current] showAlertWithTitle:@"请输入身份证号，并确定其准确性" button:@"好的"];
            return;
        }
        NSString *card = [_bankCard_textField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        if (![CMCore checkNumberValid:card] || card.length < 15) {
            [[JPAlert current] showAlertWithTitle:@"请输入银行卡号，并确定其准确性" button:@"好的"];
            return;
        }
        if (![CMCore checkPhoneValid:_phone_textField.text]) {
            [[JPAlert current] showAlertWithTitle:@"手机号格式不正确" button:@"好的"];
            return;
        }
        Label_TextField_Cell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
        NSString* bank_name = cell.detail_textField.text;
        if (bank_name.length == 0) {
            [[JPAlert current] showAlertWithTitle:@"请选择您的开户银行" button:@"好的"];
            return;
        }
        //绑定银行卡
        [self bank_card_send_sms_before_confirm];
    }
}
#pragma mark 发送短信验证码之前的确认请求
- (void)bank_card_send_sms_before_confirm {
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD showWithStatus:nil];
    Label_TextField_Cell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    NSString* bank_name = cell.detail_textField.text;
    NSString *card = [_bankCard_textField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([_typeOfStyle isEqualToString:@"007"]) {
        BankCardsModel *dic = [BankCardsModel mj_objectWithKeyValues:[CMCore get_bank_card_info]];
        //有银行卡信息
        card = dic.bankCardId;
        _name_textField.text = dic.realname;
        _idCard_textField.text = dic.idCard;
        _phone_textField.text = dic.mobilePhone;
    }
    [CMCore bank_card_send_sms_before_confirm_with_realname:_name_textField.text mobile_phone:_phone_textField.text bank_card_id:card id_card:_idCard_textField.text user_mobile_phone:nil bank_name:bank_name member_id:[CMCore get_user_info_member][@"id"] bank_code:_bank_code is_alert:YES blockResult:^(NSNumber *code, id result, NSString *message) {
        [SVProgressHUD dismiss];
        if (result != nil) {
            _order_no = result[@"orderNumber"];
            _backCallUrlStr = result[@"backCallUrl"];
//            if ([result[@"thirdPay"] containsString:@"ChanPay"]) {
//                [self bankPayNewBox];
//            }else if ([result[@"thirdPay"] containsString:@"Fuiou"]) {
                [self fuyouPay];
//            }
        }
    } blockRetry:^(NSInteger index) {
        [SVProgressHUD dismiss];
        if (index == 1) {
            [self bank_card_send_sms_before_confirm];
        }
    }];
}

#pragma mark 富友支付
- (void)fuyouPay {
    
    NSString * mchntCd = MchntCd;
    NSString * bankCard = [[_bankCard_textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString * amt = [@"200" stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];// 注意: 单位按分算
    NSString * mchntOrdId = [_order_no stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString * idNo = [_idCard_textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString * name = [_name_textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString * userId = [MemberModel mj_objectWithKeyValues:[CMCore get_user_info_member]].ID ;
    NSString * idType = @"0" ;
    NSString * myVERSION = @"2.0"; //SDK 接口版本参数  定值
    NSString * myMCHNTCD = mchntCd ; // 商户号
    NSString * myMCHNTORDERID = mchntOrdId ; // 商户订单号
    NSString * myUSERID = userId ;// 用户编号
    NSString * myAMT = amt ; // 金额
    NSString * myBANKCARD = bankCard ;  // 银行卡号
    NSString * myBACKURL = _backCallUrlStr;// 回调地址
    NSString * myNAME = name ; // 姓名
    NSString * myIDNO = idNo ;  // 证件编号
    NSString * myIDTYPE = idType ; // 证件类型(目前只支持身份证)
    NSString * myTYPE = @"02" ;
    NSString * mySIGNTP = @"MD5";
    NSString * myMCHNTCDKEY = MyMCHNTCDKEY;//商户秘钥5old71wihg2tqjug9kkpxnhx9hiujoqj
    NSString * mySIGN = [NSString stringWithFormat:@"%@|%@|%@|%@|%@|%@|%@|%@|%@|%@|%@|%@" , myTYPE,myVERSION,myMCHNTCD,myMCHNTORDERID,myUSERID,myAMT,myBANKCARD,myBACKURL,myNAME,myIDNO,myIDTYPE,myMCHNTCDKEY] ;
    mySIGN = [mySIGN MD5String] ;  //签名字段
    NSDictionary * dicD = @{@"TYPE":myTYPE,@"VERSION":myVERSION,@"MCHNTCD":myMCHNTCD,@"MCHNTORDERID":myMCHNTORDERID,@"USERID":myUSERID,@"AMT":myAMT,@"BANKCARD":myBANKCARD,@"BACKURL":myBACKURL,@"NAME":myNAME,@"IDNO":myIDNO,@"IDTYPE":myIDTYPE,@"SIGNTP":mySIGNTP,@"SIGN":mySIGN , @"TEST" : [NSNumber numberWithBool:TestNumber]} ;
    FUMobilePay * pay = [FUMobilePay shareInstance];
    if([pay respondsToSelector:@selector(mobilePay:delegate:)])
        [pay performSelector:@selector(mobilePay:delegate:) withObject:dicD withObject:self];
}

#pragma mark  富友支付结果回调
- (void)payCallBack:(BOOL)success responseParams:(NSDictionary *)responseParams
{
    
    NSString *responMESG = responseParams[@"RESPONSEMSG"];
    if ([responMESG containsString:@"成功"]) {
        [SVProgressHUD setMinimumDismissTimeInterval:1.5];
        [SVProgressHUD showSuccessWithStatus:@"绑卡成功"];
        if (_memberM.hasPayPassword) {
            [self.navigationController popViewControllerAnimated:YES];
        }else {
            //没有支付密码
            SetPayPasswordViewController *set_paypassword_vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SetPayPasswordViewController"];
            set_paypassword_vc.title = @"设置支付密码";
            set_paypassword_vc.data_dic = _data_dic;
            [self go_next:set_paypassword_vc animated:YES viewController:self];
        }
    }else {
        [[JPAlert current] showAlertWithTitle:@"温馨提示" content:responMESG button:@"好的" block:^(UIAlertView *alert, NSInteger index) {
            
        }];
    }
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

//#pragma mark 输入短信验证码弹框
//- (void)bankPayNewBox
//{
//    self.alertMoney = [[NSBundle mainBundle] loadNibNamed:@"AlertPayMoneyView" owner:nil options:nil].lastObject;
//    self.alertMoneyNew = _alertMoney;
//    NSString *phone = _phone_textField.text;
//    _alertMoney.phoneNumLabel.text = [NSString stringWithFormat:@"%@****%@",[phone substringToIndex:3],[phone substringFromIndex:7]];
//    __weak AlertPayMoneyView *alertMoneyWeak = _alertMoney;
//    __weak BankCardInformationViewController *selfWeak = self;
//    self.password_textField = alertMoneyWeak.contentTextField;
//    _alertMoney.commitBtn = ^(UIView *backViewOfAlertMoney){
//        selfWeak.backViewOfAlertMoney = backViewOfAlertMoney;
//        [selfWeak bank_card_confirm_with_code:alertMoneyWeak.contentTextField.text];
//    };
//    
//    [_alertMoney show_view];
//}

//#pragma mark 绑定银行卡
//- (void)bank_card_confirm_with_code:(NSString*)code {
//    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
//    [SVProgressHUD showWithStatus:@"正在绑定银行卡"];
//    [CMCore bank_card_confirm_with_order_no:_order_no sms_code:code is_alert:YES bank_name:_bank_name blockResult:^(NSNumber *code, id result, NSString *message) {
//        [SVProgressHUD dismiss];
//        if (result) {
//            [SVProgressHUD setMinimumDismissTimeInterval:1.5];
//            [SVProgressHUD showSuccessWithStatus:@"绑卡成功"];
//            [CMCore save_user_info_with_member:result[@"member"]];
//            _memberM = [MemberModel mj_objectWithKeyValues:result[@"member"]];
//            [_alertMoney removeFromSuperview];
//            [self.backViewOfAlertMoney removeFromSuperview];
//            if (_memberM.hasPayPassword) {
//                [self.navigationController popViewControllerAnimated:YES];
//            }else {
//                //没有支付密码
//                SetPayPasswordViewController *set_paypassword_vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SetPayPasswordViewController"];
//                set_paypassword_vc.title = @"设置支付密码";
//                set_paypassword_vc.data_dic = result;
//                [self go_next:set_paypassword_vc animated:YES viewController:self];
//            }
//        }
//    } blockRetry:^(NSInteger index) {
//        [SVProgressHUD dismiss];
//        if (index == 1) {
//            [self bank_card_confirm_with_code:code];
//        }
//    }];
//}

#pragma mark 是否同意协议
- (void)click_agree_button:(UIButton*)button {
    [self close_keyboard];
    if (button.selected) {
        button.selected = NO;
    }else
    {
        button.selected = YES;
    }
    if (button.selected == YES && _name_textField.text.length > 0 && _idCard_textField.text.length > 0 && _bankCard_textField.text.length > 0 && _phone_textField.text.length > 0 && _nameCarBank_textField.text.length > 0) {
        [_buttonView setButtonIsenabled:YES];
    }else
    {
        [_buttonView setButtonIsenabled:NO];
    }
    
    
}
#pragma mark 客服
- (void)click_service_phone_button {
    [self close_keyboard];
    [CMCore call_service_phone_with_view:self.view phone:SERVICE_PHONE];
}
#pragma mark headView
- (UIView *)setHeadView:(NSString *)title {
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, SectionHeadHeight)];
    v.backgroundColor = [UIColor clearColor];
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(15, 14.5, 20, 20)];
    lab.textColor = [UIColor colorWithHex:@"#949494"];
    lab.font = [UIFont fontWithName:FontOfAttributed size:14];
    lab.text = title;
    [lab sizeToFit];
    [v addSubview:lab];
    return v;
}
#pragma mark tableView delegate/dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    }else {
        return 3;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kTableViewRowHeight;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return kSectionFooterHeight;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return SectionHeadHeight;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return [self setHeadView:@"身份认证"];
    }else {
        return [self setHeadView:@"银行卡认证"];
    }
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1 && indexPath.row == 2) {
        _tableView.tableFooterView = [self set_tableFooterView];
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Label_TextField_Cell *cell = [tableView load_reuseable_cell_from_nib_with_class:[Label_TextField_Cell class]];
    cell.title_label.font = [UIFont fontWithName:FontOfAttributed size:14];
    cell.title_label.textColor = [UIColor colorWithHex:@"#444444"];
    cell.detail_textField.font = [UIFont fontWithName:FontOfAttributed size:14];
    cell.detail_textField.textColor = [UIColor colorWithHex:@"#444444"];
    cell.detail_textField.delegate = self;
    NSInteger index = indexPath.section * 2 + indexPath.row;
    cell.title_label.text = _cell_title_ary[index];
    cell.detail_textField.placeholder = _cell_placeholder_ary[index];
    cell.detail_textField.keyboardType = UIKeyboardTypeDefault;
    cell.detail_textField.returnKeyType = UIReturnKeyDone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            _name_textField = cell.detail_textField;
            _idCard_textField.keyboardType = UIKeyboardTypeDefault;
            _name_textField.returnKeyType = UIReturnKeyDone;
            _name_textField.delegate = self;
        }else
        {
            _idCard_textField = cell.detail_textField;
            _idCard_textField.keyboardType = UIKeyboardTypeDefault;
            _name_textField.returnKeyType = UIReturnKeyDone;
            _idCard_textField.delegate = self;
        }
    }else  if (indexPath.section == 1)
    {
        if (indexPath.row == 0) {
            UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"v1.6_down"]];
            [iv sizeToFit];
            cell.accessoryView = iv;
            _nameCarBank_textField = cell.detail_textField;
            cell.detail_textField.enabled = NO;
            _nameCarBank_textField.delegate = self;
            
        }else if (indexPath.row == 1) {
            _bankCard_textField = cell.detail_textField;
            _bankCard_textField.keyboardType = UIKeyboardTypeNumberPad;
            _bankCard_textField.delegate = self;
        }else if (indexPath.row == 2) {
            _phone_textField = cell.detail_textField;
            _phone_textField.delegate = self;
            _phone_textField.keyboardType = UIKeyboardTypeNumberPad;
            cell.detail_textField.keyboardType = UIKeyboardTypeNumberPad;
        }
    }
    if ([CMCore get_bank_card_info]) {
        BankCardsModel *dic = [BankCardsModel mj_objectWithKeyValues:[CMCore get_bank_card_info]];
        //有银行卡信息
        _bankCard_textField.enabled = NO;
        _name_textField.enabled = NO;
        _idCard_textField.enabled = NO;
        _phone_textField.enabled = NO;
        NSString *card = dic.bankCardId;
        NSString *name = dic.realname;
        NSString *id_card = dic.idCard;
        NSString *phone = dic.mobilePhone;
        
        _bankCard_textField.text = [NSString stringWithFormat:@"**** **** **** %@",[card substringFromIndex:card.length - 4]];
        
        _name_textField.text = [NSString stringWithFormat:@"%@ **",[name substringToIndex:1]];
        
        _idCard_textField.text = [NSString stringWithFormat:@"%@ **** %@",[id_card substringToIndex:4],[id_card substringFromIndex:id_card.length - 4]];
        _phone_textField.text = [NSString stringWithFormat:@"%@ **** %@", [phone substringToIndex:3], [phone substringFromIndex:7]];
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self close_keyboard];
    if (indexPath.section == 1 && indexPath.row == 0) {
        [self close_keyboard];
        [CMCore get_bank_list_with_is_alert:YES blockResult:^(NSNumber *code, id result, NSString *message) {
            if (result) {
                NSMutableArray<BankCardsModel *> *array = [BankCardsModel mj_objectArrayWithKeyValuesArray:result];
                NSMutableArray *list = [NSMutableArray array];
                NSMutableArray *englishNameList = [NSMutableArray array];
                for (BankCardsModel *dic in array) {
                    [list addObject:dic.title];
                    [englishNameList addObject:dic.code];
                }
                Label_TextField_Cell *cell = [tableView cellForRowAtIndexPath:indexPath];
                [self.pickerViewSheet showWithTitle:@"银行卡名称" height:266 array:list englishNameArr:englishNameList];
                self.pickerViewSheet.ClickEnsureBtnBlock = ^(NSString *info, NSString *englishName){
                    cell.detail_textField.text = info;
                    _bankCardInfoSelf.bank_name = info;
                    _bankCardInfoSelf.bank_code = englishName;
                    if (_name_textField.text.length > 0 && _bankCard_textField.text.length > 0 && _idCard_textField.text.length > 0 && _phone_textField.text.length > 0 && cell.detail_textField.text.length > 0) {
                        [_bankCardInfoSelf.buttonView setButtonIsenabled:YES];
                    }
                };
            }
            [SVProgressHUD dismiss];
        } blockRetry:^(NSInteger index) {
            [SVProgressHUD dismiss];
        }];
    }
    
}


#pragma mark 输入框delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@""] && [textField.text isEqualToString:@""]) {
        return NO;
    }
    if ([string isEqualToString:@""]) {
        if ([textField.text substringToIndex:textField.text.length - 1].length > 0) {
        }else
        {
            [_buttonView setButtonIsenabled:NO];
        }
    }
    if (
        (textField == _name_textField
         &&[NSString stringWithFormat:@"%@%@",_name_textField.text, string].length > 0
         && _idCard_textField.text.length > 0
         && _bankCard_textField.text.length > 0
         && _phone_textField.text.length > 0) ||
        (textField == _idCard_textField
         && [NSString stringWithFormat:@"%@%@",_idCard_textField.text, string].length > 0
         && _name_textField.text.length > 0
         && _bankCard_textField.text.length > 0
         && _phone_textField.text.length > 0) ||
        (textField == _bankCard_textField
         && [NSString stringWithFormat:@"%@%@",_bankCard_textField.text, string].length > 0
         && _idCard_textField.text.length > 0
         && _name_textField.text.length > 0
         && _phone_textField.text.length > 0) ||
        (textField == _phone_textField
         &&[NSString stringWithFormat:@"%@%@",_phone_textField.text, string].length > 0
         && _idCard_textField.text.length > 0
         && _bankCard_textField.text.length > 0
         && _name_textField.text.length > 0) ||
        (textField == _nameCarBank_textField
         &&[NSString stringWithFormat:@"%@%@",_nameCarBank_textField.text, string].length > 0
         && _idCard_textField.text.length > 0
         && _bankCard_textField.text.length > 0
         && _name_textField.text.length > 0 && _phone_textField.text.length > 0)) {
            if (_buttonView.isAgreeBtn.selected) {
                [_buttonView setButtonIsenabled:YES];
            }else
            {
                [_buttonView setButtonIsenabled:NO];
            }
        }else
        {
            [_buttonView setButtonIsenabled:NO];
        }
    if ([string isEqualToString:@""]) {
        return YES;
    }
    if ([CMCore get_bank_card_info]) {
        //有银行卡信息
        //手机号
        if (textField == _phone_textField) {
            NSString *str = [NSString stringWithFormat:@"%@%@",textField.text, string];
            if (str.length > 0 && _buttonView.isAgreeBtn.selected == YES) {
                [_buttonView setButtonIsenabled:YES];
            }
            if (str.length <=11) {
                return YES;
            }
            [_phone_textField resignFirstResponder];
            return NO;
        }
    }else
    {
        //身份证号
        if (textField == _idCard_textField) {
            
            NSString *regex = @"[a-zA-Z]";
            
            NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
            BOOL isMatch = [pred evaluateWithObject:string];
            if ([NSString stringWithFormat:@"%@%@",textField.text,string].length < 17 && isMatch == YES) {
                return NO;
            }
            
            if ([NSString stringWithFormat:@"%@%@",textField.text,string].length > 18 ) {
                if ([string isEqualToString:@"X"] || [CMCore checkNumberValid:string]||[string isEqualToString:@"x"]) {
                    return YES;
                }else {
                    return NO;
                }
            }
            
        }
        //银行卡
        if (_bankCard_textField == textField){
            //得到输入框的内容
            NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
            //检测是否为纯数字
            if ([CMCore checkNumberValid:string]) {
                //添加空格，每4位
                if (textField.text.length % 5 == 4 && textField.text.length <= 23) {
                    textField.text = [NSString stringWithFormat:@"%@ ", textField.text];
                }
                //只要19+4位数字
                if ([toBeString length] > 19+4)
                {
                    [_bankCard_textField resignFirstResponder];
                    return NO;
                }
            }else {
                return NO;
            }
        }
        //手机号
        if (textField == _phone_textField) {
            if ([NSString stringWithFormat:@"%@%@",textField.text, string].length <=11) {
                return YES;
            }
            [_phone_textField resignFirstResponder];
            return NO;
        }
    }
    
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if ([CMCore get_bank_card_info]) {
        if ( _phone_textField.text.length > 0 && _buttonView.isAgreeBtn.selected == YES) {
            [_buttonView setButtonIsenabled:YES];
        }else
        {
            [_buttonView setButtonIsenabled:NO];
        }
    }else
    {
        if (_name_textField.text.length > 0 && _idCard_textField.text.length > 0 && _bankCard_textField.text.length > 0 && _phone_textField.text.length > 0 && _buttonView.isAgreeBtn.selected == YES && _nameCarBank_textField.text.length > 0) {
            [_buttonView setButtonIsenabled:YES];
        }else
        {
            [_buttonView setButtonIsenabled:NO];
        }
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
#pragma mark 设置轻拍手势，点击空白区域键盘消失
- (void)set_close_keyboard {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(close_keyboard)];
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
}
- (void)close_keyboard {
    [_name_textField resignFirstResponder];
    [_idCard_textField resignFirstResponder];
    [_bankCard_textField resignFirstResponder];
    [_phone_textField resignFirstResponder];
    
}
#pragma mark tap delegate
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return YES;
}
#pragma mark 点击查看协议详情
- (void)go_property_web_vc {
    [self close_keyboard];
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:  @"使用条款和隐私政策",@"快捷签署服务委托协议", nil];
    
    [sheet showInView:self.view];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.cancelButtonIndex != buttonIndex) {
        NSString *title = @"";
        NSString *web_url;
        switch (buttonIndex) {
            case 0:
            {
                title = @"使用条款和隐私政策";
                web_url = [CMCore getH5AddressWithEnterType:H5EnterTypeTermsOfUseAndPrivacy targeId:nil markType:0];
            }
                break;
            case 1:
            {
                title = @"快捷签署服务委托协议";
                web_url = [CMCore getH5AddressWithEnterType:H5EnterTypeAppContractRecordSubject targeId:nil markType:0];
            }
                break;
            default:
                break;
        }
        WebViewController *web_vc = [self.storyboard instantiateViewControllerWithIdentifier:@"WebViewController"];
        [web_vc load_withUrl:web_url title:title canScaling:YES];// isShowCloseItem:YES
        [self go_next:web_vc animated:YES viewController:self];
    }
}
// 去支付界面
- (void)pushToPay {
    PayViewController *payvc = [self.storyboard instantiateViewControllerWithIdentifier:@"PayViewController"];
    payvc.data_dic = _data_dic;
    [self go_next:payvc animated:true viewController:self];
}
// 去集市
- (void)go_jishi {
    
}

#pragma mark 网络请求－获取用户信息
- (void)get_user_info
{
    
    [CMCore get_user_info_with_is_alert:YES blockResult:^(NSNumber *code, id result, NSString *message) {
        [SVProgressHUD dismiss];
        [CMCore save_user_info_with_member:result[@"member"]];
        _memberM = [MemberModel mj_objectWithKeyValues:result[@"member"]];
        [_tableView reloadData];
    } blockRetry:^(NSInteger index) {
        [SVProgressHUD dismiss];
        if (index == 1) {
            [self get_user_info];
        }
    }];
}
@end
