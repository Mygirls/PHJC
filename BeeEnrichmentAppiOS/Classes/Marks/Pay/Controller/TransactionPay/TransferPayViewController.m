//
//  TransferPayViewController.m
//  BeeEnrichmentAppiOS
//
//  Created by dll on 16/12/13.
//  Copyright © 2016年 didai. All rights reserved.
//

#import "TransferPayViewController.h"
#import "Button_Label_DetailLabel_Cell.h"
#import "Tpye_PayCellTableViewCell.h"
#import "PayButtonView.h"
#import "TableHeaderView2.h"
#import "TransferHeaderView.h"
#import "AlertPayViewTwo.h"//密码框
#import "informationAleatView.h"
#import "AlertPayMoneyView.h"
#import "ZSDPaymentView.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import "MoneyViewController.h"// 投资记录
#import "CheckLoginPasswordViewController.h"
#import "SetPayPasswordViewController.h"
#import "CMBaseTabBarController.h"

#import <FUMobilePay/FUMobilePay.h>
#import <FUMobilePay/NSString+Extension.h>

@interface TransferPayViewController ()<UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate, AlertPayMoneyViewDelegate, FYPayDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) BankCardsModel *bankCardInfoMD;
@property (nonatomic, strong) MemberModel *memberMD;
@property (nonatomic, assign) double have_yu_e_money, total_money;
@property (nonatomic, strong) UIButton *choice_yu_e_button, *choice_bank_button, *currentClikckedButton, *pastClickedButton, *button;
@property (nonatomic, strong) UILabel *yu_e_money_label, *bank_money_label, *actualMoneyLabel, *expectMoneyLabel, *currentClikckedLabel, *pastClickedLabel;
@property (nonatomic, assign) NSInteger max_limite_money, min_limite_money;
@property (nonatomic, strong) UITextField *inputTF, *money_textField, *password_textField, *phone_textField;
@property (nonatomic, strong) TransferHeaderView *tHeaderView;
@property (nonatomic, strong) ZSDPaymentView *payment;
@property (nonatomic, strong) PayButtonView *buttonView;
@property (nonatomic, strong) AlertPayMoneyView *alertMoneyNew;
@property (nonatomic, strong) AlertPayMoneyView *alertMoney;
@property (nonatomic, strong) UIView *backViewOfAlertMoney;
@property (nonatomic, strong) NSMutableString *flagStr;
@property (nonatomic, strong) AlertPayViewTwo * alertPayViewTwo;
@property (nonatomic, strong) NSString* record_id, *order_id, *order_number, *backCallUrl;
@property (nonatomic, strong) Tpye_PayCellTableViewCell *upCell, *downCell;
@end

@implementation TransferPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
    [self get_user_info_with_message:nil];
    if (_data_dic.purchaseMinAmount >= _data_dic.currentMoney) {
        [[JPAlert current] showAlertWithTitle:@"可购金额小于起购金额，需全部购买" button:@"我知道了"];
        _inputTF.enabled = NO;
        [self allReceiveBtnAction];
        _tHeaderView.allReceiveBtn.enabled = NO;
        [self makeSureButtonClick];
    }
}

- (void)initUI {
    _flagStr = [@"" mutableCopy];
    self.navigationItem.title = @"支付";
    _tHeaderView = [[NSBundle mainBundle] loadNibNamed:@"TransferHeaderView" owner:nil options:nil].lastObject;
    _tHeaderView.dic = _data_dic;
    _inputTF = _tHeaderView.inputTF;
    _inputTF.delegate = self;
    _actualMoneyLabel = _tHeaderView.actualMoney;
    _expectMoneyLabel = _tHeaderView.expectMoney;
    [_tHeaderView.allReceiveBtn addTarget:self action:@selector(allReceiveBtnAction) forControlEvents:UIControlEventTouchUpInside];
    self.tableView.tableHeaderView = _tHeaderView;
    self.automaticallyAdjustsScrollViewInsets = YES;
    [self set_tableFooterView];
    _memberMD = [MemberModel mj_objectWithKeyValues:[CMCore get_user_info_member]];
    _have_yu_e_money = _memberMD.accountCash.useMoney;
    NSInteger max_money = _data_dic.purchaseMaxAmount;
    NSInteger min_money = _data_dic.purchaseMinAmount;
    NSInteger remaining_money = _data_dic.currentMoney;
    if (max_money) {
        _max_limite_money = max_money > remaining_money ? remaining_money : max_money;
        
    }else {
        _max_limite_money = _data_dic.currentMoney;
        
    }
    _min_limite_money = _max_limite_money < min_money ? _max_limite_money : min_money;
    if (_max_limite_money == _min_limite_money) {
        _total_money = _min_limite_money;
    }
    
    _actualMoneyLabel.hidden = YES;
    [self set_close_keyboard];
}

- (void)makeSureButtonClick
{
    if (_flagStr.length > 0 && (_choice_yu_e_button.selected || _choice_bank_button.selected) && !_buttonView.is_agree_button.selected) {
        [_buttonView setButtonIsenabled:YES];
    } else {
        [_buttonView setButtonIsenabled:NO];
    }
}
#pragma mark - 承接全部按钮
- (void)allReceiveBtnAction
{
    _inputTF.text = [NSString stringWithFormat:@"%.2f", floor(_data_dic.currentMoney * 100) / 100];
    ExtraModel * dayDic =_data_dic.extra;
    /** 转让标的利息计算
     * 收益计算方式：
     * 单位：天
     * 年化 / 365 * 剩余天数（包含今天）* 购买金额 / 100
     * 单位：月
     * 年化 / 12 * 月(period) * 承接金额(购买金额) / 周期（总天数）* 剩余天数 / 100*/
    double rate = _data_dic.actualAnnualRate;
    NSInteger daysReamining = dayDic.daysRemaining;
    NSInteger period = _data_dic.Period;
    double moneySt = _data_dic.currentMoney;
    NSInteger totalDay = dayDic.totalDay;
    if (_data_dic.units == 1) {
        _expectMoneyLabel.text = [NSString stringWithFormat:@"%.2lf", rate / 365.0 * daysReamining * [_inputTF.text doubleValue] / 100];
    } else {
        _expectMoneyLabel.text = [CMCore calculateForExpectedMoneyWithRate:rate period:period money:moneySt totalDay:totalDay daysRemaining:daysReamining];
    }
    _actualMoneyLabel.text = _inputTF.text;
    [self judgeMoney];
}

- (void)judgeMoney
{
    if (_have_yu_e_money > [_inputTF.text doubleValue]) {
        if (_choice_bank_button.selected) {
            _choice_bank_button.selected = NO;
        }
        if (!_choice_yu_e_button.selected) {
            _choice_yu_e_button.selected = YES;
        }
        _yu_e_money_label.text = [NSString stringWithFormat:@"%.2f", [_actualMoneyLabel.text doubleValue]];
        _bank_money_label.text = @"0.00";
    } else {
        if (!_choice_bank_button.selected) {
            _choice_bank_button.selected = YES;
        }
        _yu_e_money_label.text = [NSString stringWithFormat:@"%.2f", _have_yu_e_money];
        _bank_money_label.text = [NSString stringWithFormat:@"%.2f", [_actualMoneyLabel.text doubleValue] - _have_yu_e_money];
    }
    _flagStr = [_inputTF.text mutableCopy];
    [self makeSureButtonClick];
}

//设置tablefooterView 登录按钮/忘记密码按钮
- (void)set_tableFooterView {
    _buttonView = [PayButtonView load_nib];
//    _buttonView.property_button.hidden = YES;
//    _buttonView.property_button.enabled = NO;
    [_buttonView.property_button setTitle:@"《债权转让协议》" forState:UIControlStateNormal];
    
    [self makeSureButtonClick];
    
    _buttonView.change_card_info_button.hidden = YES;
    [_buttonView.sure_button setTitle:@"确认支付" forState:UIControlStateNormal];
    
    [_buttonView.sure_button addTarget:self action:@selector(click_sure_button_pay) forControlEvents:UIControlEventTouchUpInside];
    
    [_buttonView.is_agree_button addTarget:self action:@selector(click_agree_button:) forControlEvents:UIControlEventTouchUpInside];
    
    [_buttonView.property_button addTarget:self action:@selector(click_property_button) forControlEvents:UIControlEventTouchUpInside];
    
    [_buttonView.change_card_info_button addTarget:self action:@selector(change_card_info) forControlEvents:UIControlEventTouchUpInside];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    if (section == 0) {
        return 2;
//    } else{
//        return _bankCardInfoMD.thirdPayList.count;
//
//    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 41;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return kSectionFooterHeight;
    }else {
        return 131;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        TableHeaderView2 *view2 = [TableHeaderView2 load_nib];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"可用余额(元)："];
        NSMutableAttributedString *restStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.2f",floor(_have_yu_e_money * 100) / 100] attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:@"#fd5353"]}];
        [str appendAttributedString:restStr];
        view2.detail_label.attributedText = str;
        view2.detail_button.hidden = YES;
        return view2;
    }else {
        TableHeaderView2 *view2 = [TableHeaderView2 load_nib];
        view2.title.text = @"支付通道";
        view2.detail_button.hidden = YES;
        return view2;
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 0) {
    
        return _buttonView;
    }else {
        return [UIView new];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        Button_Label_DetailLabel_Cell *cell = [tableView load_reuseable_cell_from_nib_with_class:[Button_Label_DetailLabel_Cell class]];
        if (indexPath.row == 0) {
            cell.title.text = @"账户余额(元)";
            _choice_yu_e_button = cell.is_selected_button;
            _choice_yu_e_button.selected = YES;
            _yu_e_money_label = cell.money;
            [_choice_yu_e_button addTarget:self action:@selector(click_yu_e_button:) forControlEvents:UIControlEventTouchUpInside];
        }else
        {
            NSString *str = _bankCardInfoMD.bankCardId;
            str = [str substringFromIndex:str.length - 4];
            NSMutableAttributedString *att_str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ 尾号%@",_bankCardInfoMD.bankTitle?:@"银行卡",str]];
            NSRange rg = {att_str.length - 6, 6};
            [att_str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:@"#444444"] range:rg];
            [att_str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:rg];
            cell.title.attributedText = att_str;
            cell.is_selected_button.enabled = YES;
            _choice_bank_button = cell.is_selected_button;
            _choice_bank_button.selected = YES;
            _bank_money_label = cell.money;
            [_choice_bank_button addTarget:self action:@selector(click_bank_button:) forControlEvents:UIControlEventTouchUpInside];
        }
        [self judgeMoney];
        return cell;
    }else {
        Tpye_PayCellTableViewCell *cell0 = [tableView load_reuseable_cell_from_nib_with_class:[Tpye_PayCellTableViewCell class]];
        NSString *name = [NSString new];
//        if ([_bankCardInfoMD.thirdPayList[indexPath.row].platform isEqualToString:@"Fuiou"]) {
//            name = @"富有";
//        }else {
//            name = @"畅捷";
//        }
        cell0.titileLabel.text = [NSString stringWithFormat:@"%@支付", name];
        
        if (_bankCardInfoMD.thirdPayList[indexPath.row].dailyLimit > 10000) {
            cell0.moneyLabel.text = [NSString stringWithFormat:@"日限额:%.0f万", _bankCardInfoMD.thirdPayList[indexPath.row].dailyLimit / 10000];
        }else {
            cell0.moneyLabel.text = [NSString stringWithFormat:@"日限额:%.1f万", _bankCardInfoMD.thirdPayList[indexPath.row].dailyLimit / 10000];
        }
        cell0.isChoicedButton.tag = indexPath.row;
        if (indexPath.row == 0 && !_button.selected) {
            cell0.isChoicedButton.selected = YES;
            _upCell = cell0;
            _button = _upCell.isChoicedButton;
        }else {
            _downCell = cell0;
        }
        [cell0.isChoicedButton addTarget:self action:@selector(clikBtnToChoicePayStyle:) forControlEvents:UIControlEventTouchUpInside];
        [self judgeMoney];
        return cell0;
    }
    
}

- (void)clikBtnToChoicePayStyle:(UIButton *)btn
{
    
    if ((_upCell.isChoicedButton.selected && btn.tag == 0) || (_downCell.isChoicedButton.selected && btn.tag == 1)) {
        return;
    }
    if (_upCell.isChoicedButton.selected) {
        _upCell.isChoicedButton.selected = NO;
        _downCell.isChoicedButton.selected = YES;
        _button = _downCell.isChoicedButton;
    }else {
        _downCell.isChoicedButton.selected = NO;
        _upCell.isChoicedButton.selected = YES;
        _button = _upCell.isChoicedButton;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [self click_yu_e_button:_choice_yu_e_button];
        }else {
            [self click_bank_button:_choice_bank_button];
        }
    }
//    if (indexPath.section == 1 && _bankCardInfoMD.thirdPayList.count > 1) {
//        if ((_upCell.isChoicedButton.selected && indexPath.row == 0) || (_downCell.isChoicedButton.selected && indexPath.row == 1)) {
//            return;
//        }
//        if (_upCell.isChoicedButton.selected) {
//            _upCell.isChoicedButton.selected = NO;
//            _downCell.isChoicedButton.selected = YES;
//            _button = _downCell.isChoicedButton;
//        }else {
//            _downCell.isChoicedButton.selected = NO;
//            _upCell.isChoicedButton.selected = YES;
//            _button = _upCell.isChoicedButton;
//        }
//    }
    
}

#pragma mark - textFieldDelegate
- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    _inputTF.text = @"";
    _flagStr = [@"" mutableCopy];
    _actualMoneyLabel.text = @"0.00";
    _expectMoneyLabel.text = @"0.00";
    _yu_e_money_label.text = @"0.00";
    _bank_money_label.text = @"0.00";
    
    [self makeSureButtonClick];
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (![CMCore checkNumberValid:string]) {
        return  NO;
    }
    ExtraModel * dayDic = _data_dic.extra;
    NSMutableString *str = nil;
    //    str = [_inputTF.text mutableCopy];
    str = [NSMutableString stringWithFormat:@"%@%@",textField.text,string];
    if ([string isEqualToString:@""]) {
        [str deleteCharactersInRange:range];
    }
    str = [NSMutableString stringWithFormat:@"%.2f", [str doubleValue]];
    _flagStr = str;
    if ([str doubleValue] > _max_limite_money) {
        return NO;
    }
    if (str.length == 0) {
        _actualMoneyLabel.text = @"0.00";
        _bank_money_label.text = @"0.00";
        _yu_e_money_label.text = @"0.00";
    }else {
        _actualMoneyLabel.text = str;
        if (_have_yu_e_money > [str doubleValue]) {
            if (_choice_bank_button.selected) {
                _choice_bank_button.selected = NO;
            }
            if (!_choice_yu_e_button.selected) {
                _choice_yu_e_button.selected = YES;
            }
            _yu_e_money_label.text = _actualMoneyLabel.text;
            _bank_money_label.text = @"0.00";
        }else {
            if (!_choice_bank_button.selected) {
                _choice_bank_button.selected = YES;
            }
            if (_choice_yu_e_button.selected) {
                _bank_money_label.text = [NSString stringWithFormat:@"%.2f", [_actualMoneyLabel.text doubleValue] - _have_yu_e_money];
                _yu_e_money_label.text = [NSString stringWithFormat:@"%.2f", _have_yu_e_money];
            }else {
                _bank_money_label.text = [NSString stringWithFormat:@"%.2f", [_actualMoneyLabel.text doubleValue]];
                _yu_e_money_label.text = @"0.00";
            }
        }
    }
    
    //    NSDictionary * dayDic =_data_dic[@"extra"];
    /** 转让标的利息计算
     * 收益计算方式：
     * 单位：天
     * 年化 / 365 * 剩余天数（包含今天）* 购买金额 / 100
     * 单位：月
     * 年化 / 12 * 月(period) * 承接金额(购买金额) / 周期（总天数）* 剩余天数 / 100*/
    double rate=  _data_dic.actualAnnualRate;
    NSInteger daysRemaining = dayDic.daysRemaining;
    NSInteger period = _data_dic.Period;
    NSString *moneySt = [NSString stringWithFormat:@"%@", str];
    NSInteger totalDay = dayDic.totalDay;
    double expect;
    if (_data_dic.units == 1) {
        expect = floor(rate / 365.0 * (daysRemaining  + 1) * [str doubleValue] / 100 * 100) / 100;
        _expectMoneyLabel.text = [NSString stringWithFormat:@"%.2lf", expect];
    } else {
        _expectMoneyLabel.text = [CMCore calculateForExpectedMoneyWithRate:rate period:period money:[moneySt doubleValue] totalDay:totalDay daysRemaining:daysRemaining];
    }
    [self makeSureButtonClick];
    return YES;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if (action == @selector(paste:))//禁止粘贴
        return NO;
    if (action == @selector(select:))// 禁止选择
        return NO;
    if (action == @selector(selectAll:))// 禁止全选
        return NO;
    return NO;
}

#pragma mark 点击余额
- (void)click_yu_e_button:(UIButton*)button
{
    [self close_keyboard];
    if (button.selected) {
        button.selected = NO;
    }else
    {
        button.selected = YES;
    }
    _currentClikckedButton = button;
    _pastClickedButton = _choice_bank_button;
    _currentClikckedLabel = _yu_e_money_label;
    _pastClickedLabel = _bank_money_label;
    [self set_selected_button];
}
#pragma mark 点击银行卡
- (void)click_bank_button:(UIButton*)button
{
    [self close_keyboard];
    if (button.selected) {
        button.selected = NO;
    }else
    {
        button.selected = YES;
    }
    _currentClikckedButton = button;
    _pastClickedButton = _choice_yu_e_button;
    _currentClikckedLabel = _bank_money_label;
    _pastClickedLabel = _yu_e_money_label;
    [self set_selected_button];
}

#pragma mark 设置一些数据
- (void)set_selected_button
{
    
    DLog(@"设置数据");
    if ([_inputTF.text doubleValue] > _have_yu_e_money) {
        if (_choice_yu_e_button.selected) {
            _choice_bank_button.selected = YES;
            _yu_e_money_label.text = [NSString stringWithFormat:@"%.2f", _have_yu_e_money];
            _bank_money_label.text = [NSString stringWithFormat:@"%.2f", [_actualMoneyLabel.text doubleValue] - _have_yu_e_money];
        }else {
            _choice_bank_button.selected = YES;
            _yu_e_money_label.text = @"0.00";
            _bank_money_label.text = [NSString stringWithFormat:@"%.2f", [_actualMoneyLabel.text doubleValue]];
        }
    }else {
        if (_currentClikckedButton.selected) {
            _pastClickedButton.selected = NO;
            _currentClikckedLabel.text = [NSString stringWithFormat:@"%.2f", [_actualMoneyLabel.text doubleValue]];
            _pastClickedLabel.text = @"0.00";
        }else {
            _pastClickedButton.selected = YES;
            _currentClikckedLabel.text = @"0.00";
            _pastClickedLabel.text = [NSString stringWithFormat:@"%.2f", [_actualMoneyLabel.text doubleValue]];
        }
    }
}

#pragma mark 确认按钮
- (void)click_sure_button_pay {
    if ([_inputTF.text integerValue] < _data_dic.purchaseMinAmount) {
        [[JPAlert current] showAlertWithTitle:@"小于起投金额" button:@"好的"];
        return;
    }
    if ([_bank_money_label.text doubleValue] > 0) {
        [self click_send_message_button:_alertMoney.obtainBtn];// 获取订单号
//        if (![[CMCore get_bank_card_info][@"thirdPayList"][_button.tag][@"platform"] isEqualToString:@"Fuiou"]) {//
//            [self bankPayNewBox]; // 银行支付弹出框
//        }
    }else {
        [self set_payment_with_paypassword];
//        [self loginWithTouchID];
    }
}

#pragma mark - 富有支付
- (void)fuyouPayAbout
{
    
    NSString * myVERSION = [NSString stringWithFormat:@"2.0"] ;     //SDK 接口版本参数  定值
    NSString * myMCHNTCD = MchntCd ;                      // 商户号
    NSString * myMCHNTORDERID = _order_number ;              // 商户订单号
    NSString * myUSERID = [CMCore get_user_info_member][@"id"] ;                        // 用户编号
    NSString * myAMT = [NSString stringWithFormat:@"%.0f", [_bank_money_label.text doubleValue] * 100];                              // 金额
    NSString * myBANKCARD = _bankCardInfoMD.bankCardId ;                    // 银行卡号
    NSString * myBACKURL = [NSString stringWithFormat:@"%@", _backCallUrl] ;                                // 回调地址
    
    NSString * myNAME = _bankCardInfoMD.realname;                            // 姓名
    NSString * myIDNO = _bankCardInfoMD.idCard;                            // 证件编号
    NSString * myIDTYPE = [NSString stringWithFormat:@"0"] ;                        // 证件类型(目前只支持身份证)
    NSString * myTYPE = [NSString stringWithFormat:@"02"] ;
    NSString * mySIGNTP = [NSString stringWithFormat:@"MD5"] ;
    NSString * myMCHNTCDKEY = MyMCHNTCDKEY ;//商户秘钥
    NSString * mySIGN = [NSString stringWithFormat:@"%@|%@|%@|%@|%@|%@|%@|%@|%@|%@|%@|%@" , myTYPE,myVERSION,myMCHNTCD,myMCHNTORDERID,myUSERID,myAMT,myBANKCARD,myBACKURL,myNAME,myIDNO,myIDTYPE,myMCHNTCDKEY] ;
    mySIGN = [mySIGN MD5String] ; //签名字段
    NSDictionary * dicD = @{@"TYPE":myTYPE,@"VERSION":myVERSION,@"MCHNTCD":myMCHNTCD,@"MCHNTORDERID":myMCHNTORDERID,@"USERID":myUSERID,@"AMT":myAMT,@"BANKCARD":myBANKCARD,@"BACKURL":myBACKURL,@"NAME":myNAME,@"IDNO":myIDNO,@"IDTYPE":myIDTYPE,@"SIGNTP":mySIGNTP,@"SIGN":mySIGN , @"TEST" : [NSNumber numberWithBool:TestNumber]} ;

    FUMobilePay *pay = [FUMobilePay shareInstance];
    if([pay respondsToSelector:@selector(mobilePay:delegate:)])
        [pay performSelector:@selector(mobilePay:delegate:) withObject:dicD withObject:self];
    
}

#pragma mark ------支付结果回调------
- (void)payCallBack:(BOOL)success responseParams:(NSDictionary *)responseParams
{
    if ([responseParams[@"RESPONSECODE"] isEqualToString:@"0000"]) {
        [SVProgressHUD showSuccessWithStatus:@"支付成功"];
        [SVProgressHUD setMinimumDismissTimeInterval:1.5];
        MoneyViewController *dingqi_vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MoneyViewController"];
        dingqi_vc.enterType = @"pay";
        dingqi_vc.navtitle = @"投资记录";
        
        dingqi_vc.market_type = _data_dic.marketType;
        UINavigationController *navc = self.tabBarController.viewControllers[3];
        
        [navc pushViewController:dingqi_vc animated:YES];
        
        self.tabBarController.selectedIndex = 3;
        
        [self.navigationController popToRootViewControllerAnimated:NO];
    } else {
        if (![responseParams[@"RESPONSECODE"] isEqualToString:@"8143"] ) {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:responseParams[@"RESPONSEMSG"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil] ;
            [alert show] ;
        }
    }
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}


#pragma mark - 指纹验证
- (void)loginWithTouchID {
    
    //步骤1：检查Touch ID是否可用
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    BOOL isChooseTouchID = [defaults boolForKey:@"isChoose"];
    
    if (isChooseTouchID == YES) {
        LAContext * context = [[LAContext alloc] init];
        NSError * error = nil;
        BOOL canUseTouchID = [context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error] ;
        
        
        if (canUseTouchID) {
            [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"请验证指纹" reply:^(BOOL success, NSError * _Nullable error) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    
                    if (success == YES) {
                        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
                        NSString * finger = [defaults objectForKey:@"Fingerprint_token"];
                        [self take_order_use_payWithFinger:finger andIsSuccess:success];
                        
                    }else {
                        NSString * string = error.userInfo[@"NSLocalizedDescription"];
                        if ([string containsString:@"Canceled by user"]) {
                            
                        }else if ([string containsString:@"Fallback authentication mechanism selected"]){
                            
                            [self set_payment_with_paypassword];//Canceled by user
                        }
                        
                    }
                    
                });
                
            }];
            
        }else {
            [self set_payment_with_paypassword];
            //            [self set_payment_with_paypassword];
        }
    }else{
        [self set_payment_with_paypassword];
        
    }
    
}

#pragma mark 网络请求－支付－指纹支付
- (void)take_order_use_payWithFinger:(NSString*)finger andIsSuccess:(BOOL)isSuccess
{
    
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD showWithStatus:@"正在支付..."];
    [CMCore take_order_with_payWithFinger:finger isSuccess:isSuccess subject_id:_data_dic.ID market_type:_data_dic.marketType total_money_actual:_actualMoneyLabel.text money_pay:_inputTF.text interest_pay:[NSString stringWithFormat:@"%.2f",[_actualMoneyLabel.text doubleValue] - [_inputTF.text doubleValue]] remaining_pay:[NSString stringWithFormat:@"%.2f",[_actualMoneyLabel.text doubleValue] - [@"0" doubleValue]] total_money:_actualMoneyLabel.text coupon_id:@"" is_alert:YES blockResult:^(NSNumber *code, id result, NSString *message) {
        
        [SVProgressHUD dismiss];
        NSString *str = result[@"message"];
        [self get_user_info_with_message:str];
        if ([code integerValue] == 200) {
            //  self.payment.delegate = nil;
            [self.alertPayViewTwo removeFromSuperview];
            informationAleatView *alert = [informationAleatView alertViewDefault];
            alert.title = @"支付成功";
            alert.iconImage = [UIImage imageNamed:@"v1.6chenggong_zhengque"];
            [alert show];
            
            MoneyViewController *dingqi_vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MoneyViewController"];
            dingqi_vc.enterType = @"pay";
            dingqi_vc.navtitle = @"投资记录";
            dingqi_vc.market_type = _data_dic.marketType;
            
            [self go_next:dingqi_vc animated:YES viewController:self];
        }else {
            // [self.alertPayViewTwo removeFromSuperview];
            informationAleatView *alert = [informationAleatView alertViewDefault];
            alert.title = @"支付失败";
            alert.iconImage = [UIImage imageNamed:@"v1.6cuowu"];
            [alert show];
        }
        
    } blockRetry:^(NSInteger index) {
        [SVProgressHUD dismiss];
        if (index == 1) {
            //            [self AlertPayMoneyView:_alertPayViewTwo WithPasswordString:string];
            //            [self take_order_use_pay_password_with_str:string];
        }
    }];
}

#pragma mark 支付密码支付的设置
- (void)set_payment_with_paypassword
{
    _alertPayViewTwo = [AlertPayViewTwo alertViewDefault];
    _alertPayViewTwo.AlertPayMoneyViewDelegate = self;
    if (![_alertPayViewTwo.TF becomeFirstResponder]) {
        //成为第一响应者。弹出键盘
        [_alertPayViewTwo.TF becomeFirstResponder];
    }
    
    [_alertPayViewTwo.forgetBtn addTarget:self action:@selector(go_check_loginPassword) forControlEvents:UIControlEventTouchUpInside];
    [_alertPayViewTwo show];
}


#pragma mark  密码输入结束后调用此方法
-(void)AlertPayMoneyView:(AlertPayMoneyView *)view WithPasswordString:(NSString *)Password
{
    if ([_bank_money_label.text doubleValue] > 0) {
        [self take_order_use_auth_code_with_str:Password];
    }else
    {
        [self take_order_use_pay_password_with_str:Password];
    }
}
#pragma mark 设置支付密码
- (void)go_check_loginPassword
{
    [_alertPayViewTwo removeFromSuperview];
    NSDictionary *user_info = [CMCore get_user_info_member];
    
    //100 更新支付密码(有支付密码{修改/忘记}) 200 设置支付密码(没有支付密码)
    CheckLoginPasswordViewController *check_login_password_vc = [self.storyboard instantiateViewControllerWithIdentifier:@"CheckLoginPasswordViewController"];
    if ([user_info[@"hasPayPassword"] integerValue]) {
        check_login_password_vc.type = 100;
    }else {
        check_login_password_vc.type = 200;
    }
    [self go_next:check_login_password_vc animated:YES viewController:self];
}

#pragma mark - 银行卡支付新的支付框
- (void)bankPayNewBox
{
    self.alertMoney = [[NSBundle mainBundle] loadNibNamed:@"AlertPayMoneyView" owner:nil options:nil].lastObject;
    self.alertMoneyNew = _alertMoney;
    NSString *phone =_bankCardPhone?_bankCardPhone:_bankCardInfoMD.mobilePhone;
    _alertMoney.phoneNumLabel.text = [NSString stringWithFormat:@"%@****%@",[phone substringToIndex:3],[phone substringFromIndex:7]];
    __weak AlertPayMoneyView *alertMoneyWeak = _alertMoney;
    __weak TransferPayViewController *selfTransWeak = self;
    self.password_textField = alertMoneyWeak.contentTextField;
    _alertMoney.commitBtn = ^(UIView *backViewOfAlertMoney){
        selfTransWeak.backViewOfAlertMoney = backViewOfAlertMoney;
        [selfTransWeak take_order_use_auth_code_with_str:alertMoneyWeak.contentTextField.text];
    };
    
    [_alertMoney show_view];
}

#pragma mark 同意协议按钮
- (void)click_agree_button:(UIButton*)button {
    DLog(@"同意协议按钮");
    [self close_keyboard];
    if (button.selected) {
        button.selected = NO;
    }else {
        button.selected = YES;
    }
    [self makeSureButtonClick];
}

#pragma mark - 修改银行卡信息
- (void)change_card_info
{
    //有银行卡信息
    BankCardInformationViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"BankCardInformationViewController"];
    vc.data_dic = _data_dic;
    [self go_next:vc animated:YES viewController:self];
}

#pragma mark - 协议弹出框
- (void)click_property_button {
    
    [self close_keyboard];
    [self go_web_vc];
    
}

#pragma mark 协议
- (void)go_web_vc
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"债权转让协议" delegate:self cancelButtonTitle:@"退出" destructiveButtonTitle:nil otherButtonTitles:@"使用条款和隐私政策",@"投资风险告知书", @"债权转让协议", nil];
    [sheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.cancelButtonIndex != buttonIndex) {
        NSString *title = @"";
        NSString *web_url = HTTP_API_BASIC;
        switch (buttonIndex) {
            case 0:
            {
                title = @"使用条款和隐私政策";
                web_url = [CMCore getH5AddressWithEnterType:H5EnterTypeTermsOfUseAndPrivacyTranfer targeId:nil markType:0 ];//[web_url stringByAppendingString:@"termsOfUseAndPrivacy"];
            }
                break;
            case 1:
            {
                title = @"投资风险告知书";
                web_url = [CMCore getH5AddressWithEnterType:H5EnterTypeContractRisk targeId:nil markType:0 ];//@"https://zxweb.beejc.com/bee/contract/risk/index.html";//[web_url stringByAppendingString:@"app_touzi_fengxian_gaozhishu"];
            }
                break;
            case 2:
            {
                title = @"债权转让协议";
                web_url = [CMCore getH5AddressWithEnterType:H5EnterTypeContractTransfer targeId:nil markType:0 ];//@"https://zxweb.beejc.com/bee/contract/transfer/index.html";//[web_url stringByAppendingString:@"app_zhaiquan_zhuanrang_xieyi"];
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

#pragma mark 设置轻拍手势，点击空白区域键盘消失
- (void)set_close_keyboard
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(close_keyboard)];
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
}

- (void)close_keyboard
{
    [_inputTF resignFirstResponder];
}

#pragma mark tap delegate
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return YES;
}



#pragma mark 网络请求－支付－仅余额
- (void)take_order_use_pay_password_with_str:(NSString*)string
{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD showWithStatus:@"正在支付..."];
    [CMCore take_order_with_pay_password:string subject_id:_data_dic.ID market_type:_data_dic.marketType total_money_actual:_actualMoneyLabel.text bank_pay:[NSString stringWithFormat:@"%.2f",[_bank_money_label.text doubleValue]] money_pay:_inputTF.text interest_pay:[NSString stringWithFormat:@"%.2f",[_actualMoneyLabel.text doubleValue] - [_inputTF.text doubleValue]] remaining_pay:[NSString stringWithFormat:@"%.2f",[_actualMoneyLabel.text doubleValue] - [[NSString stringWithFormat:@"%.2f",[_bank_money_label.text doubleValue]] doubleValue]] total_money:_actualMoneyLabel.text coupon_id:@"" is_alert:YES pay_key:_button.selected ? _bankCardInfoMD.thirdPayList[_button.tag].platform : @"" blockResult:^(NSNumber *code, id result, NSString *message) {
        if (result != nil) {
            if ([_bank_money_label.text doubleValue] > 0) {
                //验证码
                _order_id = result[@"orderId"];
                _order_number = result[@"orderNo"];
                _backCallUrl = result[@"backCallUrl"];
                //            if ([[CMCore get_bank_card_info][@"thirdPayList"][_button.tag][@"platform"] isEqualToString:@"Fuiou"]) {//
                [self fuyouPayAbout];
                //            }
            }else {
                NSString *str = result[@"message"];
                [self get_user_info_with_message:str];
                if ([code integerValue] == 200) {
                    self.payment.delegate = nil;
                    [self.alertPayViewTwo removeFromSuperview];
                    informationAleatView *alert = [informationAleatView alertViewDefault];
                    alert.title = @"支付成功";
                    alert.iconImage = [UIImage imageNamed:@"v1.6chenggong_zhengque"];
                    [alert show];
                    
                    MoneyViewController *dingqi_vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MoneyViewController"];
                    dingqi_vc.enterType = @"pay";
                    dingqi_vc.navtitle = @"投资记录";
                    dingqi_vc.market_type = _data_dic.marketType;
                    
                    UINavigationController *navc = self.tabBarController.viewControllers[3];
                    [navc pushViewController:dingqi_vc animated:YES];
                    self.tabBarController.selectedIndex = 3;
                    [self.navigationController popToRootViewControllerAnimated:NO];
                }else {
                    [self.alertPayViewTwo removeFromSuperview];
                    informationAleatView *alert = [informationAleatView alertViewDefault];
                    alert.title = @"密码有误";
                    alert.iconImage = [UIImage imageNamed:@"v1.6cuowu"];
                    [alert show];
                }
                
                
                
            }
            
        }else {
            [_alertMoneyNew removeFromSuperviewS];
        }

    } blockRetry:^(NSInteger index) {
        [SVProgressHUD dismiss];
        if (index == 1) {
            //                                     [self take_order_use_pay_password_with_str:string bank_pay:bank_pay];
            [self AlertPayMoneyView:_alertPayViewTwo WithPasswordString:string];
            //[self take_order_use_pay_password_with_str:string];
        }
    }];
    
}

#pragma mark 网络请求－支付 余额＋银行卡
- (void)take_order_use_auth_code_with_str:(NSString*)string
{
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    
    [SVProgressHUD showWithStatus:@"正在支付..."];
    [CMCore order_pay_bank_with_market_type:_data_dic.marketType
                                   order_id:_order_id
                               order_number:_order_number
                                   sms_code:string
                                   is_alert:YES
                                    pay_key:_button.selected?_bankCardInfoMD.thirdPayList[_button.tag].platform : @""
                                blockResult:^(NSNumber *code, id result, NSString *message) {
                                    if ([code integerValue] == 200) {
                                        [self get_user_info_with_message:result[@"message"]];
                                        informationAleatView *alert = [informationAleatView alertViewDefault];
                                        alert.title = @"支付成功";
                                        alert.iconImage = [UIImage imageNamed:@"v1.6chenggong_zhengque"];
                                        [alert show];
                                        MoneyViewController *dingqi_vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MoneyViewController"];
                                        dingqi_vc.market_type = _data_dic.marketType;                                        UINavigationController *navc = self.tabBarController.viewControllers[3];
                                        [navc pushViewController:dingqi_vc animated:YES];
                                        self.tabBarController.selectedIndex = 3;
                                        [self.navigationController popToRootViewControllerAnimated:NO];
                                    }else {
                                        _alertMoney.informationLbl.text = @"支付验证码无效或输入有误请重新输入";
                                    }
                                    [SVProgressHUD dismiss];
                                    
                                } blockRetry:^(NSInteger index) {
                                    [SVProgressHUD dismiss];
                                    if (index == 1) {
                                        [self take_order_use_auth_code_with_str:string];
                                    }
                                }];
}

#pragma 网络请求－发送验证码
- (void)send_message_with_button:(LTimerButton*)button
{
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD showWithStatus:@"正在发送"];
    [self take_order_use_pay_password_with_str:@""];
}

#pragma mark 点击发送验证码按钮
- (void)click_send_message_button:(LTimerButton*)button
{
    [self close_keyboard];
    
    [self send_message_with_button:button];
}

#pragma mark 网络请求－获取用户信息
- (void)get_user_info_with_message:(NSString*)message
{
    if (message.length > 0 && [_bank_money_label.text doubleValue] > 0) {
        [_alertMoney removeFromSuperview];
        [self.backViewOfAlertMoney removeFromSuperview];
    }
    [CMCore get_user_info_with_is_alert:YES blockResult:^(NSNumber *code, id result, NSString *message) {
        [SVProgressHUD dismiss];
        if (result) {
            [CMCore save_user_info_with_member:result[@"member"]];
            _memberMD = [MemberModel mj_objectWithKeyValues:result[@"member"]];
            _bankCardInfoMD = _memberMD.bankCards;
            [_tableView reloadData];
        }
    } blockRetry:^(NSInteger index) {
        [SVProgressHUD dismiss];
        if (index == 1) {
            [self get_user_info_with_message:message];
        }
    }];
}

@end
