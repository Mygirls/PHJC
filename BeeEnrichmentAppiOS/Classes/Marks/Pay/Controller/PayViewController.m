//
//  PayViewController.m
//  BeeEnrichmentAppiOS
//
//  Created by dll on 15/12/22.
//  Copyright © 2015年 didai. All rights reserved.
//
#import "informationAleatView.h"
#import "PayViewController.h"
#import "AlertPayViewTwo.h"//密码框
#import "Label_TextField_Cell.h"
#import "Button_Label_DetailLabel_Cell.h"
#import "Tpye_PayCellTableViewCell.h"
#import "TableHeaderView1.h"
#import "TableHeaderView2.h"
#import "PayButtonView.h"
#import "ZSDPaymentView.h"
#import "AlertPayMoneyView.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import "MyPackageViewController.h"// 我的礼包
#import "CheckLoginPasswordViewController.h"//验证登录密码
#import "MoneyViewController.h"//定期资产
#import "BankCardInformationViewController.h" //添加银行卡信息
#import "SetPayPasswordViewController.h"//设置交易密码
#import "PackageModel.h"
#import "CMBaseTabBarController.h"

#import <FUMobilePay/FUMobilePay.h>
#import <FUMobilePay/NSString+Extension.h>

/*
 输入金额＝理财券＋余额＋银行卡
 */
@interface PayViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIGestureRecognizerDelegate, UIActionSheetDelegate,AlertPayMoneyViewDelegate, FYPayDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) UITextField *money_textField, *password_textField;
@property (nonatomic, strong) UILabel *shouYi_money, *yu_e_money_label, *bank_money_label, *youhui_label;
@property (nonatomic, strong) NSString* record_id, *order_id, *order_number, *backCallUrl;
@property (nonatomic, assign) double you_hui_money, yu_e_moeny, bank_money, have_yu_e_money , total_money;
@property (nonatomic, assign) NSInteger max_limite_money, min_limite_money;
@property (nonatomic, strong) UIButton *choice_yu_e_button, *choice_bank_button, *currentClikckedButton, *button;
@property (nonatomic, strong) MemberModel *memberMD;
@property (nonatomic, strong) BankCardsModel *bankCardInfoMD;
@property (nonatomic, strong) PackageModel *youhui_dic;
@property (nonatomic, strong) PayButtonView *buttonView;
@property (nonatomic, strong) ZSDPaymentView *payment;
@property (nonatomic, strong) AlertPayMoneyView *alertMoneyNew;
@property (nonatomic, strong) AlertPayMoneyView *alertMoney;
@property (nonatomic, strong) UIView *backViewOfAlertMoney;
@property (nonatomic, assign) NSInteger indexVC;
@property (nonatomic, assign) NSInteger tagIndex;
@property (nonatomic, strong) Tpye_PayCellTableViewCell *upCell, *downCell;
@property (nonatomic, strong) AlertPayViewTwo * alertPayViewTwo;
//理财列表
@property (nonatomic, assign) NSInteger counts;

@end

@implementation PayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
    [self get_user_info_with_message:nil];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self close_keyboard];
    [SVProgressHUD dismiss];
}

- (void)initUI {
    // 加通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(get_youhuiquan_with_dic:) name:@"packageSelecte" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(get_youhuiquanNo_with_dic:) name:@"packageSelecteNo" object:nil];
    _have_yu_e_money = floor([[CMCore get_user_info_member][@"accountCash"][@"useMoney"] doubleValue] * 100) / 100;
    _you_hui_money = 0.00;
    NSInteger max_money = floor(_data_dic.purchaseMaxAmount * 100) / 100;
    NSInteger min_money = floor(_data_dic.purchaseMinAmount * 100) / 100;
    NSInteger remaining_money = floor(_data_dic.remainingAmount * 100) / 100;
    if (max_money) {
        _max_limite_money = max_money > remaining_money ? remaining_money : max_money;
    }else {
        _max_limite_money = floor(_data_dic.remainingAmount * 100) / 100;
    }
    _min_limite_money = _max_limite_money < min_money ? _max_limite_money : min_money;
    if (_max_limite_money == _min_limite_money) {
        _total_money = _min_limite_money;
    }
    [self set_tableFooterView];
    [self set_close_keyboard];
    if (_data_dic.enableCoupon) {
        [SVProgressHUD showWithStatus:@"正在加载"];
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
        [self load_youhui_list];
    }
    _tableView.separatorColor = [UIColor colorWithHex:@"#E1E1E1"];
    _tableView.separatorInset = UIEdgeInsetsMake(0,0, 0, 0);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"账户" style:UIBarButtonItemStylePlain target:nil action:nil];
}

//设置tablefooterView 登录按钮/忘记密码按钮
- (void)set_tableFooterView {
    
    _buttonView = [PayButtonView load_nib];
    NSInteger entryType = _data_dic.marketType;
//    _buttonView.property_button.hidden = YES;
//    _buttonView.property_button.enabled = NO;
    if (entryType == 10) {// 优选计划
        [_buttonView.property_button setTitle:@"《债权转让协议》" forState:UIControlStateNormal];
    }else if (entryType == 20) { // 普通
        [_buttonView.property_button setTitle:@"《使用条款和隐私政策》" forState:UIControlStateNormal];
    }
    if (_min_limite_money == _max_limite_money) {
        [[JPAlert current] showAlertWithTitle:@"可购金额小于起购金额，需全部购买" button:@"我知道了"];
        if (_buttonView.is_agree_button.selected == NO) {
            [_buttonView setButtonIsenabled:YES];
        }else {
            [_buttonView setButtonIsenabled:NO];
        }
    }else
    {
        [_buttonView setButtonIsenabled:NO];
    }
    _buttonView.change_card_info_button.hidden = YES;
    [_buttonView.sure_button setTitle:@"确认支付" forState:UIControlStateNormal];
    [_buttonView.sure_button addTarget:self action:@selector(click_sure_button) forControlEvents:UIControlEventTouchUpInside];
    [_buttonView.is_agree_button addTarget:self action:@selector(click_agree_button:) forControlEvents:UIControlEventTouchUpInside];
    [_buttonView.property_button addTarget:self action:@selector(click_property_button) forControlEvents:UIControlEventTouchUpInside];
    [_buttonView.change_card_info_button addTarget:self action:@selector(change_card_info) forControlEvents:UIControlEventTouchUpInside];
    
}

#pragma mark 设置一些数据
- (void)set_selected_button
{
    // 判断使用体验金是，_you_hui_money = 0.00
    if (_youhui_dic && (_youhui_dic.type == 40)) {
        _you_hui_money = 0.00;
    }
    if (_total_money > 0)
    {
        if (_youhui_dic && _total_money < _youhui_dic.condition.minBuyMoney)
        {
            _youhui_dic = [PackageModel new];
            _you_hui_money = 0;
            if (_counts)
            {
                
                _youhui_label.text = [NSString stringWithFormat:@"有%ld张",(long)_counts];
            }
        }
        NSInteger total = [[NSString stringWithFormat:@"%.02f", _total_money] integerValue];
        if (_total_money >= _min_limite_money &&  total % 1 == 0 && _buttonView.is_agree_button.selected == NO)
        {
            [_buttonView setButtonIsenabled:YES];
        }else
        {
            [_buttonView setButtonIsenabled:NO];
        }
        double money = _total_money - _you_hui_money;
        
        if (_have_yu_e_money < money)
        {
            //可用余额 < 要支付余额 =此时= 银行卡必须选中
            _choice_bank_button.selected = YES;//选中
            if (_choice_yu_e_button.selected == NO)
            {
                _yu_e_moeny = 0.00;
            }else
            {
                _yu_e_moeny = _have_yu_e_money;
            }
            _bank_money = money - _yu_e_moeny > 0 ? money -_yu_e_moeny : 0;
        }else  // 可用余额 > 要支付余额  =默认= 选择 余额
        {
            
            if (_currentClikckedButton == _choice_yu_e_button) {//当前选择的btn == 余额
                _choice_bank_button.selected = !_choice_yu_e_button.selected;
            }else  if (_currentClikckedButton == _choice_bank_button)  // 当前选择的btn == 银行卡
            {
                _choice_yu_e_button.selected = !_choice_bank_button.selected;
            }else  if (_currentClikckedButton == nil) { // 用户没有主动选择 支付选项
                _choice_yu_e_button.selected = YES;
                _choice_bank_button.selected = NO;
            }
            if (_choice_yu_e_button.selected) {
                _yu_e_moeny = money > 0 ? money : 0;
                _bank_money = 0.00;
            }else
            {
                _bank_money = money > 0 ? money : 0;
                _yu_e_moeny = 0.00;
            }
        }
    }else
    {
        _bank_money = 0;
        _yu_e_moeny = 0;
        [_buttonView setButtonIsenabled:NO];
    }
    
    _bank_money_label.text = [NSString stringWithFormat:@"%.2f", floor(_bank_money * 100) / 100];
    _yu_e_money_label.text = [NSString stringWithFormat:@"%.2f", floor(_yu_e_moeny * 100) / 100];
}
#pragma mark 设置轻拍手势，点击空白区域键盘消失
- (void)set_close_keyboard {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(close_keyboard)];
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
}
- (void)close_keyboard {
    [_money_textField resignFirstResponder];
    
}
#pragma mark tap delegate
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return YES;
}

#pragma mark 设置收益label的显示
- (void)set_shouYiMoneyWithString:(NSString *)string
{
    NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc] initWithString:@"收益(元): " attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:@"＃949494"]}];
    NSMutableAttributedString *str2 = [[NSMutableAttributedString alloc] initWithString:string];
    [str1 appendAttributedString:str2];
    _shouYi_money.attributedText = str1;
}
#pragma mark 上一界面选择理财券之后响应的delegate
- (void)get_youhuiquan_with_dic:(NSNotification *)dic
{
    //    NSDictionary *dd = info.userInfo;
    _youhui_dic = [PackageModel mj_objectWithKeyValues:dic.userInfo];
    
    if (_youhui_dic.type == 30) {// 红包
        _you_hui_money = [_youhui_dic.value doubleValue];
    }else
    {
        _you_hui_money = 0;
    }
    [self set_selected_button];
    if (_youhui_dic && (_youhui_dic.type == 40 )) {
        _youhui_label.text = [NSString stringWithFormat:@"体验金%@元", _youhui_dic.value];
    }else if(_youhui_dic.type == 10)
    {// 加息券
        _youhui_label.text = [NSString stringWithFormat:@"加息券%@%%", _youhui_dic.value];
    }else if(_youhui_dic.type
             == 30) {// 红包
        _youhui_label.text = [NSString stringWithFormat:@"红包%@元",_youhui_dic.value];
    }else if (_youhui_dic.type == 20) {
        _youhui_label.text = [NSString stringWithFormat:@"抵扣金%@元", _youhui_dic.value
                              ];
    }
    
}
#pragma mark 上一界面选择理财券之后响应的delegate22222
- (void)get_youhuiquanNo_with_dic:(NSNotification *)info
{
    _youhui_dic = [PackageModel mj_objectWithKeyValues:info.userInfo];
    _youhui_label.text = @"请重新选择优惠券";
}

#pragma mark 点击忘记密码
- (void)go_check_loginPassword_vc
{
    [_alertPayViewTwo removeFromSuperview];
    NSDictionary *user_info = [CMCore get_user_info_member];

    //100 更新支付密码(有支付密码) 200 设置支付密码(没有或忘记支付密码)
    CheckLoginPasswordViewController *check_login_password_vc = [self.storyboard instantiateViewControllerWithIdentifier:@"CheckLoginPasswordViewController"];
    if ([user_info[@"hasPayPassword"] integerValue]) {
        check_login_password_vc.type = 100;
    }else {
        check_login_password_vc.type = 200;
    }
    [self go_next:check_login_password_vc animated:YES viewController:self];
}

#pragma mark 协议
- (void)go_web_vc
{
    NSInteger entryType = _data_dic.marketType;
    if (entryType == 10) {// 优选计划
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"债权转让协议" delegate:self cancelButtonTitle:@"退出" destructiveButtonTitle:nil otherButtonTitles:@"使用条款和隐私政策", @"投资风险告知书",@"授权委托书", nil];
        [sheet showInView:self.view];
    }else if (entryType == 20) { // 普通
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"使用条款和隐私政策" delegate:self cancelButtonTitle:@"退出" destructiveButtonTitle:nil otherButtonTitles:@"使用条款和隐私政策",@"投资风险告知书",@"标的合同协议", nil];
        [sheet showInView:self.view];
    }
    
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
                web_url = [CMCore getH5AddressWithEnterType:H5EnterTypeUserRegistered targeId:nil markType:0 ];
            }
                break;
            case 1:
            {
                title = @"投资风险告知书";
                web_url = [CMCore getH5AddressWithEnterType:H5EnterTypeContractRisk targeId:nil markType:0 ];
            }
                break;
            case 2:
            {
                NSInteger entryType = _data_dic.marketType;
                if (entryType == 10) {
                    title = @"授权委托书";
                    web_url = [CMCore getH5AddressWithEnterType:H5EnterTypeContractPlan targeId:nil markType:0];
                }else if (entryType == 20) {
                    title = @"标的合同协议";
                    web_url = [CMCore getH5AddressWithEnterType:H5EnterTypeAppContractRecordSubject targeId:nil markType:0];//[web_url stringByAppendingString:@"app_contract_record_subject"];
                }
                
            }
                break;
            default:
                break;
        }
        WebViewController *web_vc = [self.storyboard instantiateViewControllerWithIdentifier:@"WebViewController"];
        //隐私协议terms_of_use_and_privacy
        [web_vc load_withUrl:web_url title:title canScaling:YES];// isShowCloseItem:YES
        [self go_next:web_vc animated:YES viewController:self];
    }
}

#pragma mark 选择理财券
- (void)go_select_youhui_vc
{
    
    MyPackageViewController *vc = [[MyPackageViewController alloc] init];
    vc.type = @"pay";
    vc.dataDic = _data_dic;
    vc.market_type_interger = _data_dic.marketType;
    vc.indexVC = [[[NSUserDefaults standardUserDefaults] objectForKey:@"index_VC"] integerValue];
    [[NSUserDefaults standardUserDefaults ] setBool:(_money_textField.text.length != 0) forKey:@"isInpuMoney"];
    vc.moneyD = [NSString stringWithFormat:@"%@",_money_textField.text];
    [self go_next:vc animated:YES viewController:self];
}
#pragma mark 网络请求－ 加载可用理财券列表
- (void)load_youhui_list
{
    [CMCore get_order_couold_use_coupon_list_with_product_id:_data_dic.ID is_alert:YES market_type:_data_dic.marketType blockResult:^(NSNumber *code, id result, NSString *message) {
        if (result)
        {
            NSDictionary *dic = result;
            NSArray *array1 = dic[@"experienceGold"];
            NSArray *array2 = dic[@"increaseRates"];
            NSArray *array3 = dic[@"redPacket"];
            _counts = array1.count + array2.count + array3.count;
            
            [SVProgressHUD dismiss];
            [_tableView reloadData];
        }else {
            [SVProgressHUD dismiss];
        }
        
    } blockRetry:^(NSInteger index) {
        [SVProgressHUD dismiss];
        if (index == 1) {
            [self load_youhui_list];
        }
    }];
    
}

#pragma mark 网络请求－支付－仅余额
- (void)take_order_use_pay_password_with_str:(NSString*)string
{
    NSInteger youhui_money = _you_hui_money;
    if (_youhui_dic.type == 30) {
        _you_hui_money = 0;
    }else {
        _you_hui_money = youhui_money;
    }
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD showWithStatus:@"正在支付..."];
    [CMCore take_order_with_pay_password:string subject_id:_data_dic.ID market_type:_data_dic.marketType total_money_actual:[NSString stringWithFormat:@"%.02f",_total_money - _you_hui_money]  bank_pay:[NSString stringWithFormat:@"%.2f",_bank_money] money_pay:@"0" interest_pay:@"0" remaining_pay:[NSString stringWithFormat:@"%.2f",_yu_e_moeny] total_money:[NSString stringWithFormat:@"%.02f",_total_money] coupon_id:_youhui_dic.memberCouponId is_alert:YES pay_key:_button.selected ? _bankCardInfoMD.thirdPayList[_button.tag].platform : @"" blockResult:^(NSNumber *code, id result, NSString *message) {
        [SVProgressHUD dismiss];
        if (result != nil) {
            if (_bank_money > 0) {
                _order_id = result[@"orderId"];
                _order_number = result[@"orderNo"];
                _backCallUrl = result[@"backCallUrl"];
                [self fuyouPayAbout];
            }else {
                [_alertMoneyNew removeFromSuperviewS];
                [_alertMoney removeFromSuperview];
                NSString *str = result[@"message"];
                [self get_user_info_with_message:str];
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
            }
        }
    } blockRetry:^(NSInteger index) {
        [SVProgressHUD dismiss];
        if (index == 1) {
            [self take_order_use_pay_password_with_str:string];
//            [self AlertPayMoneyView:_alertPayViewTwo WithPasswordString:string];
            //                                     [self take_order_use_pay_password_with_str:string];
        }
    }];
}
#pragma mark 网络请求－支付 余额＋银行卡
- (void)take_order_use_auth_code_with_str:(NSString*)string
{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD showWithStatus:@"正在支付..."];
    [CMCore order_pay_bank_with_market_type:_data_dic.marketType order_id:_order_id order_number:_order_number sms_code:string  is_alert:YES pay_key:@"Fuiou" blockResult:^(NSNumber *code, id result, NSString *message) {
        
        if ([code integerValue] == 200) {
            [self get_user_info_with_message:result[@"message"]];
            informationAleatView *alert = [informationAleatView alertViewDefault];
            alert.title = @"支付成功";
            alert.iconImage = [UIImage imageNamed:@"v1.6chenggong_zhengque"];
            [alert show];
            MoneyViewController *dingqi_vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MoneyViewController"];
            dingqi_vc.market_type = _data_dic.marketType;
            UINavigationController *navc = self.tabBarController.viewControllers[3];
            [navc pushViewController:dingqi_vc animated:YES];
            self.tabBarController.selectedIndex = 3;
            [self.navigationController popToRootViewControllerAnimated:YES];
//            [self go_next:dingqi_vc animated:YES viewController:self];
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
    NSInteger youhui_money = _you_hui_money;
    if (_youhui_dic.type == 30) {
        _you_hui_money = 0;
    }else {
        _you_hui_money = youhui_money;
    }
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD showWithStatus:@"正在发送"];
    [self take_order_use_pay_password_with_str:@""];
}
#pragma mark 网络请求－获取用户信息
- (void)get_user_info_with_message:(NSString*)message
{
    if (message.length > 0) {
        if (_bank_money > 0) {
            [_alertMoney removeFromSuperview];
            [self.backViewOfAlertMoney removeFromSuperview];
        }
    }
    [CMCore get_user_info_with_is_alert:YES blockResult:^(NSNumber *code, id result, NSString *message) {
        [SVProgressHUD dismiss];
        if ([code integerValue] == 200) {
            //成功获取用户信息
            //保存user_info
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
        }
    }else{
        [self set_payment_with_paypassword];

    }
   
}


#pragma mark 网络请求－支付－指纹支付
- (void)take_order_use_payWithFinger:(NSString*)finger andIsSuccess:(BOOL)isSuccess
{
    NSInteger youhui_money = _you_hui_money;
    if (_youhui_dic.type == 30) {
        _you_hui_money = 0;
    }else {
        _you_hui_money = youhui_money;
    }
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD showWithStatus:@"正在支付..."];
    [CMCore take_order_with_payWithFinger:finger isSuccess:isSuccess subject_id:_data_dic.ID market_type:_data_dic.marketType
                      total_money_actual:[NSString stringWithFormat:@"%.0f",_total_money - _you_hui_money]
                                money_pay:@"0"
                             interest_pay:@"0"
                            remaining_pay:[NSString stringWithFormat:@"%.2f",_yu_e_moeny]
                             total_money:[NSString stringWithFormat:@"%.02f",_total_money]
                               coupon_id:_youhui_dic.memberCouponId
                                is_alert:YES
                             blockResult:^(NSNumber *code, id result, NSString *message) {
                                 
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
                                         UINavigationController *navc = self.tabBarController.viewControllers[3];
//                                         NSLog(@"%@", self.navigationController.viewControllers);
                                         [navc pushViewController:dingqi_vc animated:YES];
                                         [self.navigationController popToRootViewControllerAnimated:NO];
                                         self.tabBarController.selectedIndex = 3;
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
                                     //                                     [self AlertPayMoneyView:_alertPayViewTwo WithPasswordString:string];
                                     //[self take_order_use_pay_password_with_str:string];
                                 }
                             }];
}

#pragma mark 支付密码支付的设置
- (void)set_payment_with_paypassword
{
    _alertPayViewTwo = [AlertPayViewTwo alertViewDefault];
    _alertPayViewTwo.AlertPayMoneyViewDelegate = self;
    if (![_alertPayViewTwo.TF becomeFirstResponder])
    {
        //成为第一响应者。弹出键盘
        [_alertPayViewTwo.TF becomeFirstResponder];
    }
    
    [_alertPayViewTwo.forgetBtn addTarget:self action:@selector(go_check_loginPassword_vc) forControlEvents:UIControlEventTouchUpInside];
    [_alertPayViewTwo show];
}

#pragma mark  密码输入结束后调用此方法
-(void)AlertPayMoneyView:(AlertPayMoneyView *)view WithPasswordString:(NSString *)Password
{
    DLog(@"密码 = %@",Password);
    if (_bank_money > 0) {
        [self take_order_use_auth_code_with_str:Password];
    }else
    {
        [self take_order_use_pay_password_with_str:Password];
    }
    
}


#pragma mark 短信验证码支付的设置
- (void)set_payment_with_authcode
{
    //_payment.numbers_count = 4;
    //    NSString *phone =_bankCardPhone?_bankCardPhone:_bank_card_info[@"mobile_phone"];
    //    _payment.phone_label.text = [NSString stringWithFormat:@"%@****%@",[phone substringToIndex:3],[phone substringFromIndex:7]];
    //    [_payment.bottom_button addTarget:self action:@selector(click_send_message_button:) forControlEvents:UIControlEventTouchUpInside];
    //    [self click_send_message_button:_payment.bottom_button];
    
}
#pragma mark 点击确定按钮 确认支付
- (void)click_sure_button {
    [self close_keyboard];
    if (_bankCardInfoMD.thirdPayList.count <= 0) {
        [[JPAlert current] showAlertWithTitle:@"温馨提示" content:@"暂不支持此银行卡支付，请更换银行卡支付" button:@[@"确定"] block:^(UIAlertView *alert, NSInteger index) {
            
        }];
        return;
    }
    if (_total_money > 0) {
        if (_total_money > _max_limite_money || _total_money < _min_limite_money) {
            NSString *string = [NSString stringWithFormat:@"单笔投资金额范围为%ld~%ld",(long)_min_limite_money, (long)_max_limite_money];
            [[JPAlert current] showAlertWithTitle:string button:@"好的"];
            return;
        }
        if (_bank_money > 0) {
            [self click_send_message_button:_alertMoney.obtainBtn];// 获取订单号
//            if (![_bankCardInfoMD.thirdPayList[_button.tag].platform isEqualToString:@"Fuiou"]) {
//                [self bankPayNewBox]; // 银行支付弹出框
//            }
        }else {
//            [self loginWithTouchID];
            [self set_payment_with_paypassword];
        }
    }else {
        [[JPAlert current] showAlertWithTitle:@"请输入金额" button:@"好的"];
        return;
    }
}

#pragma mark - 富有支付
- (void)fuyouPayAbout
{
    
    NSString * myVERSION = [NSString stringWithFormat:@"2.0"] ; //SDK 接口版本参数  定值
    NSString * myMCHNTCD = MchntCd ; // 商户号
    NSString * myMCHNTORDERID = _order_number ;// 商户订单号
    NSString * myUSERID = [CMCore get_user_info_member][@"id"]; // 用户编号
    NSString * myAMT = [NSString stringWithFormat:@"%.0f", _bank_money * 100];  // 金额
    NSString * myBANKCARD = _bankCardInfoMD.bankCardId; // 银行卡号
    NSString * myBACKURL = [NSString stringWithFormat:@"%@", _backCallUrl] ; // 回调地址
    NSString * myNAME = _bankCardInfoMD.realname; // 姓名
    NSString * myIDNO = _bankCardInfoMD.idCard;// 证件编号
    NSString * myIDTYPE = @"0"; // 证件类型(目前只支持身份证)
    NSString * myTYPE = @"02";
    NSString * mySIGNTP = @"MD5";
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
    NSString *code = [NSString stringWithFormat:@"%@", responseParams[@"RESPONSECODE"]];
    if ([code isEqualToString:@"0000"]) {
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
        if (![code isEqualToString:@"8143"] ) {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:responseParams[@"RESPONSEMSG"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil] ;
            [alert show] ;
        }
    }
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

#pragma mark - 银行卡支付新的支付框
- (void)bankPayNewBox
{
    self.alertMoney = [[NSBundle mainBundle] loadNibNamed:@"AlertPayMoneyView" owner:nil options:nil].lastObject;
    self.alertMoneyNew = _alertMoney;
    NSString *phone =_bankCardPhone?_bankCardPhone:_bankCardInfoMD.mobilePhone;
    _alertMoney.phoneNumLabel.text = [NSString stringWithFormat:@"%@****%@",[phone substringToIndex:3],[phone substringFromIndex:7]];
    __weak AlertPayMoneyView *alertMoneyWeak = _alertMoney;
    __weak PayViewController *selfWeak = self;
    self.password_textField = alertMoneyWeak.contentTextField;
    _alertMoney.commitBtn = ^(UIView *backViewOfAlertMoney){
        selfWeak.backViewOfAlertMoney = backViewOfAlertMoney;
        [selfWeak take_order_use_auth_code_with_str:alertMoneyWeak.contentTextField.text];
    };
    
    [_alertMoney show_view];
}

#pragma mark 点击发送验证码按钮
- (void)click_send_message_button:(LTimerButton*)button
{
    [self close_keyboard];
    [self send_message_with_button:button];
}
- (void)change_card_info
{
    //有银行卡信息
    BankCardInformationViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"BankCardInformationViewController"];
    vc.data_dic = _data_dic;
    [self go_next:vc animated:YES viewController:self];
}
- (void)click_agree_button:(UIButton*)button {
    [self close_keyboard];
    if (button.selected) {
        button.selected = NO;
        
    }else
    {
        button.selected = YES;
    }
    if (button.selected == NO && _money_textField.text.length > 0 && [CMCore checkNumberValid:_money_textField.text] && [_money_textField.text integerValue] % 1 == 0) {
        [_buttonView setButtonIsenabled:YES];
    }else
    {
        [_buttonView setButtonIsenabled:NO];
    }
}
- (void)click_property_button {
    
    [self close_keyboard];
    [self go_web_vc];
    
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
    [self set_selected_button];
    
}

#pragma mark 清除缓存
- (void)remoSelectCoupon {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"isBool_selecteBtn"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"btn_index"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"index_VC"];
}

#pragma mark tableView delegate/dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 4;
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }else if (section == 1) {
        return 1;
//    }else if (section == 2){
//        return 2;
    }else {
        return 2;
//        return _bankCardInfoMD.thirdPayList.count;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section ==0) {
        return 60;
    }
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return kSectionFooterHeight;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 10;
    }
    return 40;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2 && indexPath.row == 1) {
        
        _tableView.tableFooterView = _buttonView;
    }
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return nil;
    }else if (section == 1) {
        TableHeaderView1 *view1 = [TableHeaderView1 load_nib];
        if (_data_dic.productType == 1) {
            //活期
            view1.hidden = YES;
        }else
        {
            //定期
            _shouYi_money = view1.money;
            CGFloat livi_year;
            if (_youhui_dic && _youhui_dic.type == 30) {// 红包
                livi_year = _data_dic.expectedAnnualRate + _data_dic.addAnnualRate;
            }else if (_youhui_dic.type == 10){// 加息券
                livi_year = _data_dic.expectedAnnualRate + _data_dic.addAnnualRate + [_youhui_dic.value doubleValue];
            }else {
                livi_year = _data_dic.expectedAnnualRate + _data_dic.addAnnualRate;
            }
            
                if (_data_dic.repaymentId == 200) {
                    //            本金*综合年化收益率*（1+期数）/（期数*24）
                    CGFloat month_lilv = livi_year / 100.0 / 12.0;
                    CGFloat month_lilv_add_one  = livi_year / 100.0 / 12.0 + 1;
                    CGFloat pre = pow(month_lilv_add_one, _data_dic.Period);
                    CGFloat sur = pow(month_lilv_add_one,  _data_dic.Period) -1;
                    
                    [self set_shouYiMoneyWithString:[NSString stringWithFormat:@"%.2f", _total_money  * month_lilv * pre / sur * _data_dic.Period - _total_money]];
                }else {
                    if (_data_dic.units == 1) {
                        [self set_shouYiMoneyWithString:[NSString stringWithFormat:@"%.2f", livi_year / 100.0 * _data_dic.Period * _total_money / 365.0 ]];
                    }else {
                        [self set_shouYiMoneyWithString:[NSString stringWithFormat:@"%.2f", livi_year / 100.0 * _data_dic.Period * _total_money / 12.0 ]];
                    }
                }
            
            if (_max_limite_money) {
                if (_min_limite_money == _max_limite_money) {
                   
                    view1.limite_money.text = [NSString stringWithFormat:@"%ld",(long)_min_limite_money];
                
                }else
                {
                    view1.limite_money.text = [NSString stringWithFormat:@"%ld~%ld",(long)_min_limite_money, (long)_max_limite_money];
                }
            }else { // _max_limite_money == 0  remainingAmount
                view1.limite_money.text = [NSString stringWithFormat:@"%ld~%d",(long)_min_limite_money, (int)_data_dic.remainingAmount];
            }
        }
        
        
        return view1;
    }else if (section == 2){
        TableHeaderView2 *view2 = [TableHeaderView2 load_nib];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"可用余额："];
        NSMutableAttributedString *restStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.2f", floor(_have_yu_e_money * 100) / 100] attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:@"#fd5353"]}];
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        Label_TextField_Cell *cell = [tableView load_reuseable_cell_from_nib_with_class:[Label_TextField_Cell class]];
        _money_textField = cell.detail_textField;
        cell.detail_textField.delegate = self;
        cell.detail_textField.keyboardType = UIKeyboardTypeNumberPad;
        cell.title_label.text = @"投资金额(元):";
        cell.detail_textField.textAlignment = NSTextAlignmentRight;
        cell.detail_textField.placeholder = @"请输入购买金额";
        if (_min_limite_money == _max_limite_money) {
            cell.detail_textField.text = [NSString stringWithFormat:@"%ld",(long)_min_limite_money];
            cell.detail_textField.enabled = NO;
            _total_money = _min_limite_money;
        }
        cell.accessoryType = UITableViewCellAccessoryNone;
        return cell;
    }else if (indexPath.section == 1) {
        UITableViewCell *cell = [tableView load_reuseable_cell_with_style:UITableViewCellStyleValue1 _class:[UITableViewCell class]];
        _youhui_label = cell.detailTextLabel;
        cell.textLabel.text = @"优惠";
        cell.textLabel.font = [UIFont fontWithName:FontOfAttributed size:14];
        cell.detailTextLabel.font = [UIFont fontWithName:FontOfAttributed size:14];
        if (_data_dic.enableCoupon) {
            //可以使用理财券
            NSString *str;
            if (_youhui_dic && _youhui_dic.type == 10) {
                str = [NSString stringWithFormat:@"加息%@%%",_youhui_dic.value];
            }else if(_youhui_dic && _youhui_dic.type == 30)
            {
                str = [NSString stringWithFormat:@"红包%@元",_youhui_dic.value];
            }
            NSString *string = @"选择优惠券";
            if (_counts) {
                string = [NSString stringWithFormat:@"有%ld张优惠券",(long)_counts];
                cell.detailTextLabel.textColor = [UIColor colorWithHex:@"#FD5353"];
            }else {
                string = @"无可用理财券";
                cell.detailTextLabel.textColor = [UIColor colorWithHex:@"＃949494"];
            }
            cell.detailTextLabel.text = _youhui_dic.value ? str:string;
            cell.detailTextLabel.font = [UIFont fontWithName:FontOfAttributed size:14];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else {
            //不可以使用理财券
            cell.detailTextLabel.text = @"此产品不支持使用理财券";
            cell.detailTextLabel.textColor = [UIColor colorWithHex:@"＃949494"];
            cell.detailTextLabel.font = [UIFont fontWithName:FontOfAttributed size:14];
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
        return cell;
        
    }else if (indexPath.section == 2){
        Button_Label_DetailLabel_Cell *cell = [tableView load_reuseable_cell_from_nib_with_class:[Button_Label_DetailLabel_Cell class]];
        if (indexPath.row == 0) {
            cell.title.text = @"账户余额";
            _choice_yu_e_button = cell.is_selected_button;
            _choice_yu_e_button.selected = YES;
            _yu_e_money_label = cell.money;
            
            [_choice_yu_e_button addTarget:self action:@selector(click_yu_e_button:) forControlEvents:UIControlEventTouchUpInside];
        }else if (indexPath.row == 1)
        {
            
            NSString *str = _bankCardInfoMD.bankCardId;
            str = [str substringFromIndex:str.length - 4];
            NSMutableAttributedString *att_str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ 尾号%@", _bankCardInfoMD.bankTitle?:@"银行卡",str]];
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
        if (_min_limite_money == _max_limite_money) {
            [self set_selected_button];
        }
       return cell;
        
    }else {
        Tpye_PayCellTableViewCell *cell0 = [tableView load_reuseable_cell_from_nib_with_class:[Tpye_PayCellTableViewCell class]];
        NSString *name = [NSString new];
        if ([_bankCardInfoMD.thirdPayList[indexPath.row].platform isEqualToString:@"Fuiou"]) {
            name = @"富有";
        }else {
            name = @"畅捷";
        }
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


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self close_keyboard];
    if (indexPath.section == 1 && _data_dic.enableCoupon) {
        if (_total_money >= _min_limite_money) {
            [self go_select_youhui_vc];
        } else{
            [[JPAlert current] showAlertWithTitle:@"请输入购买金额" button:@"好的"];
        }
    }
    
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            [self click_yu_e_button:_choice_yu_e_button];
        }else {
            [self click_bank_button:_choice_bank_button];
        }
    }
//    if (indexPath.section == 3 && _bankCardInfoMD.thirdPayList.count > 1) {
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

#pragma mark textField delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSMutableString *str = [NSMutableString stringWithFormat:@"%@%@",textField.text,string];
    if ([string isEqualToString:@""]) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"isBool_selecteBtn"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"btn_index"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"index_VC"];
        [str deleteCharactersInRange:range];
        CGFloat livi_year;
        _total_money= [str integerValue];
        if (_youhui_dic && _youhui_dic.type == 10) {
            livi_year = _data_dic.expectedAnnualRate + _data_dic.addAnnualRate + [_youhui_dic.value doubleValue];
        }else
        {
            livi_year = _data_dic.expectedAnnualRate + _data_dic.addAnnualRate;
        }
        if (_data_dic.repaymentId == 200) {
            //            本金*综合年化收益率*（1+期数）/（期数*24）
            CGFloat month_lilv = livi_year / 100.0 / 12.0;
            CGFloat month_lilv_add_one  = livi_year / 100.0 / 12.0 + 1;
            CGFloat pre = pow(month_lilv_add_one, _data_dic.Period);
            CGFloat sur = pow(month_lilv_add_one,  _data_dic.Period) -1;
            
            [self set_shouYiMoneyWithString:[NSString stringWithFormat:@"%.2f", _total_money  * month_lilv * pre / sur * _data_dic.Period - _total_money]];
        }else {
            if (_data_dic.units == 1) {
                [self set_shouYiMoneyWithString:[NSString stringWithFormat:@"%.2f", livi_year / 100.0 * _data_dic.Period * _total_money / 365.0 ]];
            }else {
                [self set_shouYiMoneyWithString:[NSString stringWithFormat:@"%.2f", livi_year / 100.0 * _data_dic.Period * _total_money / 12.0 ]];
            }
        }
        
        if (_youhui_dic && _total_money < _youhui_dic.condition.minBuyMoney) {
            _youhui_dic = nil;
            if (_counts) {
                _youhui_label.text = [NSString stringWithFormat:@"有%ld张",(long)_counts];
                _you_hui_money = 0;
            }else
            {
                _youhui_label.text = @"";
            }
        }
        [self set_selected_button];
        return YES;
    }
    
    if ([CMCore checkNumberValid:str] && [str integerValue] % 1 == 0 && str.length > 0 && [str integerValue] >= _min_limite_money && _buttonView.is_agree_button.selected == NO) {
        [_buttonView setButtonIsenabled:YES];
    }else
    {
        [_buttonView setButtonIsenabled:NO];
    }
    if ([CMCore checkNumberValid:str] && [str integerValue] <= _max_limite_money) {
        CGFloat livi_year;
        _total_money = [str integerValue];
        if (_youhui_dic && _youhui_dic.type == 10) {
            livi_year = _data_dic.expectedAnnualRate + _data_dic.addAnnualRate;
        }else 
        {
            livi_year = _data_dic.expectedAnnualRate + _data_dic.addAnnualRate + [_youhui_dic.value doubleValue];
        }
        if (_data_dic.repaymentId == 200) {
            CGFloat month_lilv = livi_year / 100.0 / 12.0;
            CGFloat month_lilv_add_one  = livi_year / 100.0 / 12.0 + 1;
            CGFloat pre = pow(month_lilv_add_one, _data_dic.Period);
            CGFloat sur = pow(month_lilv_add_one,  _data_dic.Period) -1;
            
            // 每月偿还利息=贷款本金×月利率×〔(1+月利率)^还款月数-(1+月利率)^(还款月序号-1)〕÷〔(1+月利率)^还款月数-1〕
            CGFloat monthInterest = 0.0;
            CGFloat preOfInvest = _total_money * month_lilv;
            CGFloat temp = monthInterest;
            for (int i = 1; i < _data_dic.Period + 1; i++) {
                monthInterest = preOfInvest * (pre - pow(month_lilv_add_one, i - 1)) / sur ;
                
                monthInterest = temp + floor(monthInterest * 100) / 100;
                temp = monthInterest;
                
            }
            //每月还本金
            [self set_shouYiMoneyWithString:[NSString stringWithFormat:@"%.2f", monthInterest]];
        }else {
            if (_data_dic.units == 1) {
                [self set_shouYiMoneyWithString:[NSString stringWithFormat:@"%.2f", livi_year / 100.0 * _data_dic.Period * _total_money / 365.0 ]];
            }else {
                [self set_shouYiMoneyWithString:[NSString stringWithFormat:@"%.2f", livi_year / 100.0 * _data_dic.Period * _total_money / 12.0 ]];
            }
            
        }
        
        [self set_selected_button];
        return YES;
    }else
    {
        if ([str integerValue] > _max_limite_money) {
            return NO;
        }
        [_buttonView setButtonIsenabled:NO];
        [self set_selected_button];
        return NO;
    }
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    _total_money = [textField.text integerValue];
    if (_youhui_dic && _total_money < _youhui_dic.condition.minBuyMoney) {
        _youhui_dic = nil;
        if (_counts) {
            
            _youhui_label.text = [NSString stringWithFormat:@"有%ld张",(long)_counts];
        }
    }
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    [_buttonView setButtonIsenabled:NO];
    if (_youhui_dic) {
        _youhui_dic = nil;
        if (_counts) {
            _youhui_label.text = [NSString stringWithFormat:@"有%ld张",(long)_counts];
            
            _you_hui_money = 0;
        }else
            _youhui_label.text = @"";
    }
    _total_money = 0;
    [self set_shouYiMoneyWithString:@"0.00"];
    [self set_selected_button];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"isBool_selecteBtn"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"btn_index"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"index_VC"];
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"isBool_selecteBtn"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"btn_index"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"index_VC"];
}
@end
