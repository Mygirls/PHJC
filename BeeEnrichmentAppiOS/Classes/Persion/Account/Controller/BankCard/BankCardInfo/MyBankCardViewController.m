//
//  MyBankCardViewController.m
//  BeeEnrichmentAppiOS
//
//  Created by dll on 15/12/24.
//  Copyright © 2015年 didai. All rights reserved.
//
#import "ServiceView.h"
#import "MQChatViewManager.h"
#import "MyBankCardViewController.h"
#import "AddCardCell.h"
#import "BankCardCell.h"
#import "NoBankCardView.h"//添加银行卡按钮
#import "BankCardInformationViewController.h"//绑卡
#import "NoDataPointView.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface MyBankCardViewController ()<UITableViewDataSource, UITableViewDelegate,ServiceViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) BankCardsModel *bankCardInfoMD;
@property (nonatomic, strong) NoBankCardView *noBankCardView;
@property (nonatomic, strong) NSString *rightTitle;

@end
__weak MyBankCardViewController *myBankWeakSelf;
@implementation MyBankCardViewController

- (void)init_ui {
    [super init_ui];
    myBankWeakSelf = self;
    self.navigationItem.title = @"我的银行卡";
    [self get_user_info];
    if ([CMCore get_bank_card_info]) {
        _rightTitle = @"限额说明";
    }else {
        _rightTitle = @"支持银行";
    }
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:_rightTitle style:UIBarButtonItemStyleDone target:self action:@selector(goSuportBanks)];
    
    _noBankCardView = [NoBankCardView load_nib];
    _noBankCardView.clickButtonBlock = ^(){
        [myBankWeakSelf clickAddBank];
    };
}

#pragma mark 限额说明
- (void)goSuportBanks {
    NSString *url = [CMCore getH5AddressWithEnterType:H5EnterTypeSupportBank targeId:nil markType:0];
    WebViewController *webVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"WebViewController"];
    [webVC load_withUrl:url title:_rightTitle canScaling:NO];
    [self.navigationController pushViewController:webVC animated:YES];
}

- (void)clickAddBank
{
    [[JPAlert current] showAlertWithTitle:@"绑定银行卡" content:@"绑卡时需扣款2元，完成后将全额退还至账户余额" button:@[@"取消", @"去绑卡"] block:^(UIAlertView *alert, NSInteger index) {
        if (index == 1) {
            BankCardInformationViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"BankCardInformationViewController"];
            [self go_next:vc animated:YES viewController:self];
        }
    }];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [self get_user_info];
//    [_tableView reloadData];

}

#pragma mark 银行卡信息
- (void)set_bankAccessoryInfo
{
    
    if (![CMCore get_bank_list]) {
        [self get_bankList];
    }else
    {
        NSString *bank_title = [CMCore get_bank_card_info][@"bankTitle"];
        NSMutableArray<BankCardsModel *> *banCards = [BankCardsModel mj_objectArrayWithKeyValuesArray:[CMCore get_bank_list]];
        for (BankCardsModel *dic in banCards) {
            if ([dic.title isEqualToString:bank_title]) {
                _bankCardInfoMD = dic;
                break;
            }
        }
        
        _tableView.tableFooterView = nil;
    }
    
}
#pragma mark 网络请求－获取银行卡列表
- (void)get_bankList
{
    //获取银行卡列表
    [CMCore get_bank_list_with_is_alert:YES blockResult:^(NSNumber *code, id result, NSString *message) {
        if (result) {
            [CMCore save_bank_list_info:result];
            [self set_bankAccessoryInfo];
        }
    } blockRetry:^(NSInteger index) {
        
        if (index == 1) {
            [self get_bankList];
        }
    }];
}
#pragma mark 客服
- (void)click_service_phone_button {
    [CMCore call_service_phone_with_view:self.view phone:SERVICE_PHONE];
}

#pragma mark tableView delegate/dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([CMCore get_bank_card_info]) {
        
        return 1;
    }else
    {
        return 0;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 210;
    }
    return 200;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return kSectionFooterHeight;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kSectionFooterHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        BankCardCell *cell = [tableView load_reuseable_cell_from_nib_with_class:[BankCardCell class]];
        DLog(@"%@", [CMCore get_bank_card_info]);
        BankCardsModel *dic = [BankCardsModel mj_objectWithKeyValues:[CMCore get_bank_card_info]];
        cell.model = dic;
        if (_bankCardInfoMD) {
            cell.bank_basic_info = _bankCardInfoMD;
        }
        return cell;
    }else
    {
        AddCardCell *cell = [tableView load_reuseable_cell_from_nib_with_class:[AddCardCell class]];
        UITapGestureRecognizer *deblockTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(go_check_can_change_bank_card)];
        [cell.deblockView addGestureRecognizer:deblockTap];
        [cell.phoneBtn addTarget:self action:@selector(callPhone) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1) {
        //检查是否可以解绑
        //        [self go_check_can_change_bank_card];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
    tableView.tableFooterView = self.noBankCardView;
}

#pragma mark - 打电话给客服
- (void)callPhone
{
    ServiceView *alert = [ServiceView alertViewDefault];
    alert.delegate = self;
    [alert show];
}

- (void)alertView:(ServiceView *)alertView clickedCustomButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        //客服热线
        [CMCore call_service_phone_with_view:self.view phone:SERVICE_PHONE];
    }else{
        //对话普汇
        [self go_chat];
    }
}
//基本功能 - 在线客服 对话普汇
- (void)go_chat
{
    NSString *phone = [CMCore get_user_info_member][@"mobilePhone"];
    NSString *name = [CMCore get_user_info_member][@"realname"];
    NSString *source = [[UIDevice currentDevice] name];
    [MQManager setClientInfo:@{@"name":name.length > 0 && ![name isKindOfClass:[NSNull class]]?name:phone, @"tel":phone, @"source":source} completion:^(BOOL success, NSError *error) {
    }];
    MQChatViewManager *chatViewManager = [[MQChatViewManager alloc] init];
    chatViewManager.chatViewStyle.navBarTintColor = [CMCore basic_black_color];
    chatViewManager.chatViewStyle.enableOutgoingAvatar = false;
    [chatViewManager pushMQChatViewControllerInViewController:self];
}

#pragma mark 网络请求－解绑银行卡？
- (void)go_check_can_change_bank_card
{
    //检查是否可以解绑
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD showWithStatus:@"正在验证银行卡信息"];
    [CMCore unbind_bank_card_with_is_alert:YES blockResult:^(NSNumber *code, id result, NSString *message) {
        if (result) {
            NSDictionary *dic = result;
            NSString *str = result[@"message"];
            if (str.length > 0) {
                [[JPAlert current]showAlertWithTitle:str button:@"好的"];
            }
            
            if ([dic[@"can"] integerValue] == 1) {
                if ([CMCore get_bank_card_info]) {
                    [JPConfigCurrent removeObjectForKey:@"bank_card_info"];
                    [_tableView reloadData];
                }
                [self get_user_info];
            }else
            {
                [SVProgressHUD dismiss];
            }
        }
        
    } blockRetry:^(NSInteger index) {
        [SVProgressHUD dismiss];
        if (index == 1) {
            [self go_check_can_change_bank_card];
        }
    }];
}
#pragma mark 网络请求－获取用户信息
- (void)get_user_info
{
    
    [CMCore get_user_info_with_is_alert:YES blockResult:^(NSNumber *code, id result, NSString *message) {
        [SVProgressHUD dismiss];
        if (result != nil || result) {
            [CMCore save_user_info_with_member:result[@"member"]];
            if (![CMCore get_bank_card_info]) {
                _tableView.tableFooterView = self.noBankCardView;
                
            }else
            {
                [self set_bankAccessoryInfo];
            }
            [_tableView reloadData];
        }
    } blockRetry:^(NSInteger index) {
        [SVProgressHUD dismiss];
        if (index == 1) {
            [self get_user_info];
        }
    }];
}


@end
