//
//  MyAccountVersionTwoViewController.m
//  BeeEnrichmentAppiOS
//
//  Created by dll on 16/8/2.
//  Copyright © 2016年 didai. All rights reserved.
//

#import "MyAccountVersionTwoViewController.h"

#import "SetupViewController.h"// 设置界面
#import "MoneyViewController.h"// 定期资产
#import "MyTransactionViewController.h"// 交易记录
#import "MyBankCardViewController.h"// 银行卡界面
#import "OutLineProductListViewController.h"// 线下产品
#import "AvailableMoneyViewController.h"//我的余额
#import "AboutAppViewController.h"//
#import "MyAccountVersionTwoCell.h" // tableViewCell
#import "HeaderView.h"
#import "CMBaseTabBarController.h"
#import "ServiceView.h"
#import "MQChatViewManager.h"
#import "MyPackageViewController.h"// 我的礼包
#import "VipViewController.h"
#import "HistoryListViewController.h"// 老客户投资记录

#define Spc 5

@interface MyAccountVersionTwoViewController ()<UITableViewDelegate, UITableViewDataSource,UIWebViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,ServiceViewDelegate>

@property (nonatomic, assign) double memberMoney;
@property (nonatomic, strong) UILabel *vipLevel;
@property (nonatomic, strong) UserModel *UserMD;
@property (nonatomic, strong) HeaderView *headerView;
@property (nonatomic, strong) CMBaseTabBarController *rootTab;
@end

@implementation MyAccountVersionTwoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    _UserMD = [UserModel new];
    [self setheaderView];
    [self set_refresh];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    if ([CMCore is_login]) {
        [self get_user_info];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)set_refresh
{
    __weak MyAccountVersionTwoViewController *_self = self;
    _tableView.mj_header = [WMRefreshHeader headerWithRefreshingBlock:^{
        [_self load_my_money];
    }];
}

- (void)setheaderView
{
    __weak typeof(self) weakSelf = self;
    self.headerView = [[NSBundle mainBundle] loadNibNamed:@"HeaderView" owner:nil options:nil].lastObject;
    self.headerView.frame = CGRectMake(0, 0, kScreenWidth, 303);
    self.headerView.clickHeaderViewBlock = ^(HeaderViewButtonType index){
        switch (index) {
            case 0:
                [weakSelf choiceHeadImage];
                break;
            case 1:
                [weakSelf pushToMyVip];
                break;
            case 2:
                //设置
                [weakSelf go_setup];
                break;
            case 3:
                // 累计收益
                [weakSelf go_dingqi_list_vc:3];
                break;
            case 4:
                //累计投资
                [weakSelf go_dingqi_list_vc:1];
                break;
            case 5:
                //提现
                [weakSelf go_rest_money];
                break;
            case HeaderViewButtonTypeRestJiuzhan:
                // 旧站数据
                [weakSelf goToOldHistory];
                break;
            default:
                break;
        }
    };
    _tableView.tableHeaderView = self.headerView;
}

#pragma mark 头像选择
- (void)choiceHeadImage
{
    [MobClick endEvent:me_headIconID];
    [MobClick event:me_iconClickID];
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从相册中选择", nil];
    [sheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        //拍照
        [self take_photo];
    }else if (buttonIndex == 1) {
        //相册选择
        [self get_photo_from_library];
    }
}

- (void)take_photo
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0) {
            picker.navigationBar.barTintColor = [CMCore basic_color];
        }
        [self presentViewController:picker animated:YES completion:nil];
    }else {
        [[JPAlert current] showAlertWithTitle:@"摄像头不可用" button:@"好的"];
    }
}

- (void)get_photo_from_library
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.allowsEditing = YES;
        picker.delegate = self;
        if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0) {
            picker.navigationBar.barTintColor = [CMCore basic_color];
        }
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker animated:YES completion:nil];
    }else {
        [[JPAlert current] showAlertWithTitle:@"相册不可用" button:@"好的"];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    if ((picker.sourceType == UIImagePickerControllerSourceTypeCamera)) {
        
        [self saveImageToPhotos:image];
    }
    image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    _headerView.iconImageView.image = [image copy];
    [picker dismissViewControllerAnimated:YES completion:^{
        [self update_head_image:image];
    }];
}

//保存照片到相册
- (void)saveImageToPhotos:(UIImage *)saveImage
{
    UIImageWriteToSavedPhotosAlbum(saveImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

- (void)image:(UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo
{
    NSString *msg = nil ;
    if(error != NULL){
        msg = @"保存图片失败" ;
    }else{
        msg = @"保存图片成功" ;
    }
}

//更换头像
- (void)update_head_image:(UIImage *)image
{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD showWithStatus:@"正在上传头像"];
    [CMCore update_user_head_url_with_head_image:image is_alert:YES blockResult:^(NSNumber *code, id result, NSString *message) {
        if ([code integerValue] == 200) {
            [SVProgressHUD setMinimumDismissTimeInterval:1.5];
            [SVProgressHUD showSuccessWithStatus:@"上传成功"];
            [CMCore save_user_info_with_member:result[@"member"]];
            self.headerView.iconImageView.image = image;
        }else {
            [SVProgressHUD dismiss];
        }
    } blockRetry:^(NSInteger index) {
        [SVProgressHUD dismiss];
        if (index == 1) {
            [self update_head_image:image];
        }
    }];
}

#pragma mark 资产列表/ 投资记录
- (void)go_dingqi_list_vc:(NSInteger)type {
    MoneyViewController *dingqi_vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MoneyViewController"];
    if (type == 2) {
        // 投资记录
        dingqi_vc.type = 2;
//        dingqi_vc.market_type = 9090;
        dingqi_vc.navtitle = @"投资记录";
//        [MobClick event:me_investmentRecordID];
    }else if (type == 3) {
        // 累计收益
        dingqi_vc.type = 3;
        dingqi_vc.navtitle = @"累计收益";
//        [MobClick event:me_accumulatedIncomeID];
    }else if (type == 1) {
        // 累计投资
        dingqi_vc.type = 1;
        dingqi_vc.navtitle = @"累计投资";
//        [MobClick event:me_investmentPrincipalID];
    }
    [self go_next:dingqi_vc animated:YES viewController:self];
}

#pragma mark 余额
- (void)go_rest_money
{
    // 我的_提现
    [MobClick event:me_availableBalanceID];
    AvailableMoneyViewController *avail_vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AvailableMoneyViewController"];
    avail_vc.money = [NSString stringWithFormat:@"%.2f", _UserMD.member.accountCash.useMoney];
    [self go_next:avail_vc animated:YES viewController:self];
}

#pragma mark  我的vip
- (void)pushToMyVip {
//    [[JPAlert current] showAlertWithTitle:@"温馨提示" content:@"正在整理中,敬请期待!" button:@"好的" block:^(UIAlertView *alert, NSInteger index) {
//        
//    }];
//    [MobClick event:me_headPortraitID];
    VipViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"VipViewController"];
    vc.flagStr = @"HIDDEN";
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark 设置
- (void)go_setup
{
    [MobClick event:me_setUpID];
    SetupViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SetupViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark  资金明细
- (void)go_transaction_vc
{
    [MobClick event:me_transactionRecordID];
    MyTransactionViewController *my_transaction_vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MyTransactionViewController"];
    [self go_next:my_transaction_vc animated:YES viewController:self];
}
#pragma mark 邀请返利即人人分享
- (void)go_invite_friends {
//    [[JPAlert current] showAlertWithTitle:@"温馨提示" content:@"正在整理中,敬请期待!" button:@"好的" block:^(UIAlertView *alert, NSInteger index) {
//        
//    }];
    [MobClick event: me_getRebateInvitationID];
    WebViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"WebViewController"];
    NSString *rightUrl = [CMCore getH5AddressWithEnterType:H5EnterTypeInvitationDetails targeId:nil markType:0];
    NSString *url = [CMCore getH5AddressWithEnterType:H5EnterTypeInvitation targeId:nil markType:0];
    [vc load_withUrl:url title:@"邀请有礼" canScaling:NO];// isShowCloseItem:YES
    [vc load_withRightBarUrl:rightUrl title:@"邀请明细" canScaling:NO];// isShowCloseItem:YES
    [self go_next:vc animated:YES viewController:self];
}

#pragma mark 银行卡
- (void)go_bind_bank_card
{
    [MobClick event:me_myBankCardID];
    MyBankCardViewController *my_bank_vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MyBankCardViewController"];
    [self go_next:my_bank_vc animated:YES viewController:self];
}

#pragma mark 帮助中心
- (void)go_my_qrcode
{
    [[JPAlert current] showAlertWithTitle:@"温馨提示" content:@"正在整理中,敬请期待!" button:@"好的" block:^(UIAlertView *alert, NSInteger index) {
        
    }];
//    UIStoryboard *stor = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    WebViewController *vc = [stor instantiateViewControllerWithIdentifier:@"WebViewController"];
//    [vc load_withUrl:@"https://beejc.com/mobile/helper" title:@"帮助中心" canScaling:YES];// isShowCloseItem:YES
//    [self go_next:vc animated:YES viewController:self];
}

#pragma mark 理财、联系客服
- (void)go_next {
    [MobClick event:me_serviceID];
    NSString *str = [CMCore get_user_info_member][@"salesmanMobilePhone"];
    // 判断是否有业务员手机号码
    if (!(str.length == 11)) {
        [self go_kefu];
    }
}

#pragma mark 我的礼包
- (void)go_package {
    [MobClick event:me_myRedEnvelopID];
    MyPackageViewController *vc = [[MyPackageViewController alloc] init];
    vc.type = @"package";
    vc.market_type_array = @[@10, @20, @30];
    [self go_next:vc animated:YES viewController:self];
}

#pragma mark 关于普汇
- (void)go_about {
  
    [MobClick event:me_aboutMinID];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD showWithStatus:@"正在加载相关信息"];
    [CMCore about_us_with_is_alert:YES blockResult:^(NSNumber *code, id result, NSString *message) {
        [SVProgressHUD dismiss];
        AboutAppViewController *about_app_vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AboutAppViewController"];
        about_app_vc.aboutAppM = [AboutAppModel mj_objectWithKeyValues:result];
        [self go_next:about_app_vc animated:YES viewController:self];
    } blockRetry:^(NSInteger index) {
        [SVProgressHUD dismiss];
        if (index == 1) {
            [self go_about];
        }
    }];
}

#pragma mark 点击设置
- (void)go_setting
{
    [self go_setup];
}

#pragma mark 联系客服
- (void)go_kefu
{
    ServiceView *alert = [ServiceView alertViewDefault];
    alert.delegate = self;
    [alert show];
}

- (void)alertView:(ServiceView *)alertView clickedCustomButtonAtIndex:(NSInteger)buttonIndex
{
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

#pragma mark 去旧站记录
- (void)goToOldHistory {
    NSString *str = [CMCore get_user_info_member][@"salesmanMobilePhone"];
    // 判断是否有业务员手机号码
    if (!(str.length == 11)) {
        MoneyViewController *dingqi_vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MoneyViewController"];
        dingqi_vc.type = 4;
        dingqi_vc.market_type = 9090;
        dingqi_vc.navtitle = @"投资记录";
        [self.navigationController pushViewController:dingqi_vc animated:YES];
    } else {
        HistoryListViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HistoryListViewController"];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark tableview delegate UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 286;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kSectionFooterHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [[NSBundle mainBundle] loadNibNamed:@"TableFooterView" owner:nil options:nil].lastObject;
    return footerView;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    _headerView.model = _UserMD;
    MyAccountVersionTwoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyAccountVersionTwoCell"];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"MyAccountVersionTwoCell" owner:nil options:nil].lastObject;
    }
    cell.backOfCollectionView.backgroundColor = [UIColor grayColor];
    cell.clickItem = ^(NSInteger index){
        switch (index) {
            case 0:
                // 我的银行卡
                [self go_bind_bank_card];
                break;
            case 1:
                // 交易记录 / 资金明细
                [self go_transaction_vc];
                break;
            case 2:
                // 我的礼包
                [self go_package];
                break;
            case 3:
                // vip
                [self pushToMyVip];
                break;
            case 4:
                // 邀请返利
                [self go_invite_friends];
                break;
            case 5:
                // 投资记录
                [self go_dingqi_list_vc:2];
                break;
            case 6:
                // 帮助中心
                [self go_my_qrcode];
                break;
            case 7:
                // 线下理财,联系客服
                [self go_next];
                break;
            case 8:
                // 关于普汇
                [self go_about];
                break;
            default:
                break;
        }
    };
    return cell;
    
}

#pragma mark 获取用户信息
- (void)get_user_info
{
    [CMCore get_user_info_with_is_alert:YES blockResult:^(NSNumber *code, id result, NSString *message) {
        [SVProgressHUD dismiss];
        if ([code integerValue] == 200) {
            //成功获取用户信息
            //保存user_info
            [CMCore save_user_info_with_member:result[@"member"]];
            if ([CMCore is_login]) {
                [self load_my_money];
            }else {
                LoginNavigationController *login_navc = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginNavigationController"];
                [self presentViewController:login_navc animated:YES completion:nil];
                return;
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

#pragma mark 我的资产接口
- (void)load_my_money
{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD showWithStatus:@"努力加载中..."];
    [_tableView.mj_header  endRefreshing];
    [CMCore get_my_money_with_is_alert:YES blockResult:^(NSNumber *code, id result, NSString *message) {
        [SVProgressHUD dismiss];
        if (result) {
            _UserMD = [UserModel mj_objectWithKeyValues: result];
            [CMCore save_user_info_with_member:result[@"member"]];
            [_tableView reloadData];
        }
    }blockRetry:^(NSInteger index) {
        [SVProgressHUD dismiss];
        if (index == 1) {
            [_tableView.mj_header beginRefreshing];
        }
    }];
}

@end
