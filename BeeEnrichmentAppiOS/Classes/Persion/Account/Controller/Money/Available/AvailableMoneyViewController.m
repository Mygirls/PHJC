//
//  AvailableMoneyViewController.m
//  BeeEnrichmentAppiOS
//
//  Created by dll on 15/12/24.
//  Copyright © 2015年 didai. All rights reserved.
//

#import "AvailableMoneyViewController.h"

#import "Auto_Touzi_Explanation_Cell.h"
#import "WithdrawButtonView.h"
#import "MyWalletHeadCell.h"
#import "WithdrawViewController.h"//提现
#import "WithdrawListViewController.h"//提现列表
#import "BankCardInformationViewController.h"//绑卡
#import "MoneyViewController.h"
@interface AvailableMoneyViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UserModel *userMD;
@property (nonatomic, strong) UISwitch *auto_switch;
@property (nonatomic, strong) WithdrawButtonView *footBtnView;

@end

@implementation AvailableMoneyViewController
- (void)init_ui {
    [super init_ui];
    [self set_refresh];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"提现记录" style:UIBarButtonItemStylePlain target:self action:@selector(go_tixian_vc)];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(go_dingqi_vc) name:@"InvestmentRecord" object:nil];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    if ([CMCore is_login]) {
        //登录状态
        [self get_doing_withdraw_info];
    }else
    {
        self.tabBarController.selectedIndex = 0;
        [self go_back:YES viewController:self];
        return;
    }
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_tableView.mj_header  endRefreshing];
}
#pragma mark 刷新
- (void)set_refresh
{
    __weak AvailableMoneyViewController *_self = self;
    _tableView.mj_header = [WMRefreshHeader headerWithRefreshingBlock:^{
        [_self get_doing_withdraw_info];
    }];
}
- (void)set_tableFooter_view {
    
    self.footBtnView = [WithdrawButtonView load_nib];
    
    [self.footBtnView.click_button addTarget:self action:@selector(click_tixian_buttton:) forControlEvents:UIControlEventTouchUpInside];
    
    _tableView.tableFooterView = self.footBtnView;
}
#pragma mark 是否自动投资
- (void)changeSwitchValued
{
    if (_auto_switch.on) {
        
        [self set_is_enabled_auto_toubiao_with_type:1];
    }else
    {
        
        [self set_is_enabled_auto_toubiao_with_type:0];
    }
    
    [_tableView reloadData];
}
#pragma mark 网络请求－设置是否自动投资
- (void)set_is_enabled_auto_toubiao_with_type:(NSInteger)type
{
    [CMCore auto_bid_enabled_with_enabled:type is_alert:YES blockResult:^(NSNumber *code, id result, NSString *message) {

        if (result) {
            _userMD = [UserModel mj_objectWithKeyValues:result];
            [CMCore save_user_info_with_member:result[@"member"]];
            [_tableView reloadData];
        }
        
        [_tableView reloadData];
    } blockRetry:^(NSInteger index) {

        if (index == 1) {
            [self set_is_enabled_auto_toubiao_with_type:type];
        }
    }];
}
#pragma mark 自动投资协议
- (void)click_auto_property_button
{
    WebViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"WebViewController"];
    //自动投标协议automatic_agreement
    NSString *url = [NSString stringWithFormat:@"%@automatic_agreement",HTTP_API_BASIC];
    [vc load_withUrl:url title:@"自动投标协议" canScaling:YES];// isShowCloseItem:NO
    [self go_next:vc animated:YES viewController:self];
    
}
#pragma mark 提现
- (void)click_tixian_buttton:(UIButton *)btn {
    
    [MobClick event:me_availableBalance_presentID];
    if (_money.length > 0 &&[_money doubleValue] > 0) {
        if ([CMCore get_bank_card_info]) {
            WithdrawViewController *ti_xian_vc = [self.storyboard instantiateViewControllerWithIdentifier:@"WithdrawViewController"];
            ti_xian_vc.money = [NSString stringWithFormat:@"%.2f",floor(_userMD.member.accountCash.useMoney * 100) / 100];
            [self go_next:ti_xian_vc animated:YES viewController:self];
        }else
        {
            [[JPAlert current] showAlertWithTitle:@"绑定银行卡" content:@"绑卡时需扣款2元，完成后将全额退还至账户余额" button:@[@"取消", @"去绑卡"] block:^(UIAlertView *alert, NSInteger index) {
                if (index == 1) {
                    BankCardInformationViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"BankCardInformationViewController"];
                    [self go_next:vc animated:YES viewController:self];
                }
            }];
        }
    
    }else
    {
        [[JPAlert current] showAlertWithTitle:@"您目前没有可用余额" button:@"好的"];

        return;
    }
}

#pragma mark 点击我的资产－跳转定期资产列表
- (void)go_dingqi_vc {
    MoneyViewController *dingqi_vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MoneyViewController"];
    dingqi_vc.navtitle = @"投资记录";
    [self go_next:dingqi_vc animated:YES viewController:self];
}

#pragma mark 提现记录
- (void)go_tixian_vc
{
    [MobClick event:me_availableBalance_presentRecordID];
    WithdrawListViewController *ti_xian_list_vc = [self.storyboard instantiateViewControllerWithIdentifier:@"WithdrawListViewController"];
    [self go_next:ti_xian_list_vc animated:YES viewController:self];
}
#pragma mark tableView delegate/dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3-2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return kScreenWidth / 2;
    }
    if (indexPath.section == 2) {
        if (_auto_switch.on) {
            return 90;
        }else
        {
            return 60;
        }
    }
    return kTableViewRowHeight;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return kSectionFooterHeight;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kSectionFooterHeight;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2-2 && indexPath.row == 0) {
        
        [self set_tableFooter_view];
        if ([([NSString stringWithFormat:@"%.2f", floor(_userMD.member.accountCash.useMoney * 100) / 100]?:_money) isEqual:@"0.00"]) {//没有余额
            self.footBtnView.click_button.hidden = YES;
            self.footBtnView.no_money_view.hidden = NO;
            self.footBtnView.grayButton.hidden = NO;
            self.footBtnView.bottomTitleTopContraint.constant = 19.5;
        }else {// 有余额
            self.footBtnView.click_button.hidden = NO;
            self.footBtnView.no_money_view.hidden = YES;
            self.footBtnView.grayButton.hidden = YES;
            self.footBtnView.bottomTitleTopContraint.constant = -71.5 + 19.5;
            
        }

    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        MyWalletHeadCell *cell = [tableView load_reuseable_cell_from_nib_with_class:[MyWalletHeadCell class]];
        cell.title.text = @"可用余额(元)";
        _money = [NSString stringWithFormat:@"%.2f",floor(_userMD.member.accountCash.useMoney * 100)/100]?:_money;
        cell.available_money.text = _money;
        cell.all_money.text = [NSString stringWithFormat:@"%.2f",floor(_userMD.doingWithdrawMoney *100)/100];
        cell.accessory_title.text = @"正在提现(元)";
        return cell;
        return nil;
    }else if (indexPath.section == 1)
    {
        UITableViewCell *cell = [tableView load_reuseable_cell_with_style:UITableViewCellStyleDefault _class:[UITableViewCell class]];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.text = @"自动投资产品";
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.accessoryView = _auto_switch;
        return cell;
    }else
    {
        Auto_Touzi_Explanation_Cell *cell = [tableView load_reuseable_cell_from_nib_with_class:[Auto_Touzi_Explanation_Cell class]];
        if (_auto_switch.on) {
            //
            cell.short_view.hidden = YES;
            cell.long_view.hidden = NO;
        }else
        {
            cell.short_view.hidden = NO;
            cell.long_view.hidden = YES;
        }
        [cell.auto_touzi_property_button addTarget:self action:@selector(click_auto_property_button) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark 网络请求－获取正在提现及可用余额
- (void)get_doing_withdraw_info
{
    [CMCore get_doing_withdraw_info_with_is_alert:YES blockResult:^(NSNumber *code, id result, NSString *message) {
        [_tableView.mj_header  endRefreshing];
        if (result) {
            _userMD = [UserModel mj_objectWithKeyValues:result];
            [CMCore save_user_info_with_member:result[@"member"]];
            [_tableView reloadData];
        }
    } blockRetry:^(NSInteger index) {
        //        [SVProgressHUD dismiss];
        [_tableView.mj_header  endRefreshing];
        if (index == 1) {
            [self get_doing_withdraw_info];
        }
    }];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
