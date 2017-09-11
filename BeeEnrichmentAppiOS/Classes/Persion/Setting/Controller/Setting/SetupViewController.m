//
//  SetupViewController.m
//  BeeEnrichmentAppiOS
//
//  Created by dll on 16/8/3.
//  Copyright © 2016年 didai. All rights reserved.
//

#import "SetupViewController.h"
#import "SetupCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "MQChatViewManager.h"
#import "AboutAppViewController.h"
#import "CMBaseTabBarController.h"
#import "ForgetPasswordViewController.h"
#import "CheckLoginPasswordViewController.h"
#import "SetPayPasswordViewController.h"
#import "LLLockViewController.h"//手势密码
#import "ServiceView.h"
#import "UIColor+Addition.h"
#import "ClickButtonView.h"

#import "SFYZPasswordViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>
@interface SetupViewController ()<UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate,ServiceViewDelegate>{

    BOOL _isBoolPush;

}
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *titleArray, *titleArrayImage;
@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) NSString *versions;
@property (nonatomic, assign) NSInteger strBool;

@property (nonatomic, strong) MemberModel *user_info;
@property (nonatomic, strong) UISwitch *is_open_hand_password_switch;
@property (nonatomic, strong) UISwitch *is_push_switch;

@property (nonatomic, strong) ClickButtonView  *click_button_view;
@property (nonatomic,assign) BOOL isChooseTouchID;

@end

@implementation SetupViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"设置";
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    self.isChooseTouchID = [defaults boolForKey:@"isChoose"];
    [CMCore about_us_with_is_alert:YES blockResult:^(NSNumber *code, id result, NSString *message) {
        if ([code integerValue] == 200) {
            
            _versions =  result[@"version"];
            [self.tableView reloadData];

        }
    } blockRetry:^(NSInteger index) {
        
   
    }];

    self.user_info = [MemberModel mj_objectWithKeyValues:[CMCore get_user_info_member]];
    _is_open_hand_password_switch = [[UISwitch alloc] init];
    [_is_open_hand_password_switch addTarget:self action:@selector(click_switch_action) forControlEvents:UIControlEventValueChanged];
    
    _is_push_switch = [[UISwitch alloc] init];
    [_is_push_switch addTarget:self action:@selector(click_switch_push) forControlEvents:UIControlEventValueChanged];
    
    if ([[UIApplication sharedApplication] currentUserNotificationSettings].types  == UIUserNotificationTypeNone) {
        
        
    }else{
        _isBoolPush = YES;
        _is_push_switch.on = YES;
        
    }
    
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    //下划线颜色
    [self.tableView setSeparatorColor:[UIColor colorWithHex:@"#e1e1e1" ]];
    [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    _tableView.backgroundColor = [UIColor colorWithHex:@"#f1f1f1"];
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [self set];
    if ([CMCore is_login]) {
    }else
    {
        [self go_back:NO viewController:self];
    }
    [self.tableView reloadData];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
#pragma mark 设置数据ui 
- (void)set {
    self.user_info =  [MemberModel mj_objectWithKeyValues:[CMCore get_user_info_member]];
    if ([CMCore is_open_gesture_password] && [LLLockPassword loadLockPassword]) {
        //手势密码是有的，开启状态
        _is_open_hand_password_switch.on = YES;
        
        NSString *str = @"";
        _strBool = self.user_info.hasPayPassword;
        
        if (_strBool) {
            //有支付密码
            str = @"修改支付密码";
            
            
        }else
        {
            //没有支付密码
            str = @"设置支付密码";
        }
        _titleArray = [NSMutableArray arrayWithObjects:@[@"手机账号", @"修改登录密码", str,@"手势密码"],@[@"关于普汇",@"安全保障",@"联系客服"],@[@"当前版本"],nil];
        _titleArrayImage = [NSMutableArray arrayWithObjects: @[@"v1.6_set_tel", @"v1.6_set_login_mima", @"v1.6_set_mima", @"v1.6_set_top",@"v1.6_set_gesture_password"],@[@"v1.6_set_min_about",@"v1.6_anquan_safety_guarantee",@"v1.6_phone"],
                            @[@"v1.6_set_versions"], nil];
        
        NSMutableArray * arr = [[NSMutableArray alloc]initWithArray:_titleArray[0]];
        [arr addObject:@"修改手势密码"];
        [arr addObject:@"信息推送"];
        [_titleArray replaceObjectAtIndex:0 withObject:arr];
        NSMutableArray * arr1 = [[NSMutableArray alloc]initWithArray:_titleArrayImage[0]];
        [arr1 addObject:@"v1.6_set_push"];
        [_titleArrayImage replaceObjectAtIndex:0 withObject:arr1];
        
    }else
    {
        _is_open_hand_password_switch.on = NO;
        NSString *str = @"";
        _strBool = _user_info.hasPayPassword;
        if (_strBool) {
            //有支付密码
            str = @"修改支付密码";
        }else
        {
            //没有支付密码
            str = @"设置支付密码";
            
        }
        _titleArray = [NSMutableArray arrayWithObjects:@[@"手机账号", @"修改登录密码", str, @"手势密码", @"信息推送"], @[@"联系客服"],@[@"当前版本"], nil];
        _titleArrayImage = [NSMutableArray arrayWithObjects: @[@"v1.6_set_tel", @"v1.6_set_login_mima", @"v1.6_set_mima", @"v1.6_set_top", @"v1.6_set_push"],@[@"v1.6_phone"],@[@"v1.6_set_versions"], nil];
    }

}
#pragma mark 是否开启消息推送
- (void)click_switch_push {
    
    if ([[UIApplication sharedApplication] currentUserNotificationSettings].types  == UIUserNotificationTypeNone) {
        
        if (_is_push_switch.on == NO) {
            
        }
        else{
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"未允许通知" message:@"是否允许通知？" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
                _isBoolPush = NO;
                _is_push_switch.on = NO;
            }];
            UIAlertAction * allowAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [[UIApplication sharedApplication]openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                _isBoolPush = NO;
                _is_push_switch.on = NO;
            }];
            [alert  addAction:cancelAction];
            [alert addAction:allowAction];
            [self presentViewController:alert animated:YES completion:nil];
            
        }
    }else{
        if (_is_push_switch.on == NO) {
            
            [[JPAlert current] showAlertWithTitle:@"温馨提示" content:@"是否关闭信息推送" button:@[@"取消", @"确定"] block:^(UIAlertView *alert, NSInteger index) {
                if (index == 1) {
                    // 开用
                    _isBoolPush = NO;
                    
                    [CMCore register_push_with_application:[UIApplication sharedApplication] launchOptions:nil];
                    
                }else{
                    
                    _is_push_switch.on = YES;
                }
            }];
            
        }else{
            [[JPAlert current] showAlertWithTitle:@"温馨提示" content:@"是否开启信息推送" button:@[@"取消", @"确定"] block:^(UIAlertView *alert, NSInteger index) {
                if (index == 1) {
                    _isBoolPush = YES;
                    
                    // 关用
                    [[UIApplication sharedApplication]unregisterForRemoteNotifications];
                }else{
                    
                    _is_push_switch.on = NO;
                    
                }
            }];
        }
    }
    
    
    
    
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _titleArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    NSArray * arr = [_titleArray objectAtIndex:section];
    return arr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return kSectionFooterHeight;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SetupCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SetupCell"];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"SetupCell" owner:nil options:nil].lastObject;
    }
    [cell setSeparatorInset:UIEdgeInsetsZero];
    [cell setLayoutMargins:UIEdgeInsetsZero];
    cell.titleLabel.font = [UIFont fontWithName:FontOfAttributed size:16];
    cell.titleLabel.textColor = [UIColor colorWithHex:@"#444444"];
    cell.hotMarkImageView.image = [UIImage imageNamed:_titleArrayImage[indexPath.section][indexPath.row]];
    cell.titleLabel.text = _titleArray[indexPath.section][indexPath.row];
    if (indexPath.section == 1) {
        
    }else if (indexPath.section == 2) {
        cell.titleLabel.text = [NSString stringWithFormat:@"当前版本：v%@",[CMCore app_version]];
        cell.arrowImageView.image = nil;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }else if (indexPath.section == 0) {
        if ([CMCore is_open_gesture_password] && [LLLockPassword loadLockPassword]) {
            cell.titleLabel.text = _titleArray[indexPath.section][indexPath.row];
            
            if (indexPath.row == 0) {
                cell.detailContraint.constant = -6;
                cell.detailLabel.text = [NSString stringWithFormat:@"%@****%@",[_user_info.mobilePhone substringToIndex:3],[_user_info.mobilePhone substringFromIndex:7]];
                cell.detailLabel.textColor = [UIColor colorWithHex:@"#949494"];
                cell.arrowImageView.image = nil;
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            }else if (indexPath.row == 1) {
            }else if (indexPath.row == 2) {
            }else if (indexPath.row == 3) {
                cell.arrowImageView.image = nil;
                cell.accessoryView = _is_open_hand_password_switch;
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            }else if (indexPath.row == 4) {

            }else if (indexPath.row == 5) {
                cell.arrowImageView.image = nil;
                cell.accessoryView = _is_push_switch;
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                
            }else if (indexPath.row == 6){
                cell.arrowImageView.image = nil;
                UISwitch * payTouchID= [[UISwitch alloc] init];
                payTouchID.on = self.isChooseTouchID;
                [payTouchID addTarget:self action:@selector(openTouchID:) forControlEvents:UIControlEventTouchUpInside];
                cell.accessoryView = payTouchID;
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            }
        }else {
            cell.titleLabel.text = _titleArray[indexPath.section][indexPath.row];
            
            if (indexPath.row == 0) {
                cell.detailContraint.constant = -6;
                if (_user_info.mobilePhone == nil || [_user_info.mobilePhone isEqualToString:@""]) {
                    cell.detailLabel.text = @"***";
                }else {
                    cell.detailLabel.text = [NSString stringWithFormat:@"%@****%@",   [_user_info.mobilePhone substringToIndex:3],[_user_info.mobilePhone substringFromIndex:7]];
                }
                
                cell.detailLabel.textColor = [UIColor colorWithHex:@"#949494"];
                cell.arrowImageView.image = nil;
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            }else if (indexPath.row == 1) {
            }else if (indexPath.row == 2) {
            }else if (indexPath.row == 3) {
                cell.arrowImageView.image = nil;
                cell.accessoryView = _is_open_hand_password_switch;
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            }else if (indexPath.row == 4) {
                cell.arrowImageView.image = nil;
                cell.accessoryView = _is_push_switch;
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            }else if (indexPath.row == 5){
                cell.arrowImageView.image = nil;
                UISwitch * payTouchID= [[UISwitch alloc] init];
                payTouchID.on = self.isChooseTouchID;
                [payTouchID addTarget:self action:@selector(openTouchID:) forControlEvents:UIControlEventTouchUpInside];
                cell.accessoryView = payTouchID;
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            }
        }
    }
    
    return cell;
}

#pragma mark --指纹开启
- (void)openTouchID:(UISwitch *)switchCell{
    self.user_info = [MemberModel mj_objectWithKeyValues:[CMCore get_user_info_member]];
    if (_user_info.hasPayPassword) {
        if (switchCell.on == YES) {
            
            // 判断用户手机系统是否是 iOS 8.0 以上版本
            if ([UIDevice currentDevice].systemVersion.floatValue < 8.0) {
                [switchCell setOn:NO];
                return;
            }else{
                // 实例化本地身份验证上下文
                LAContext *context= [[LAContext alloc] init];
                
                // 判断是否支持指纹识别
                if (![context canEvaluatePolicy:LAPolicyDeviceOwnerAuthentication error:NULL]) {
                    
                    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Touch ID未开启" message:nil preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        [switchCell setOn:NO];
                        self.isChooseTouchID = NO;
                        
                        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
                        [defaults setBool:self.isChooseTouchID forKey:@"isChoose"];
                        [defaults synchronize];
                        dispatch_async(dispatch_get_main_queue(), ^{[self.tableView reloadData];});

                    }];

                    [alert  addAction:cancelAction];

                    [self presentViewController:alert animated:YES completion:nil];
                    
                    
                    return;
                    
                }
                
                [context evaluatePolicy:LAPolicyDeviceOwnerAuthentication
                        localizedReason:@"请验证指纹"
                                  reply:^(BOOL success, NSError * _Nullable error) {
                                      
                                      // 输入指纹开始验证，异步执行
                                      if (success) {
                                          self.isChooseTouchID = switchCell.isOn;
                                          [self refreshUI:[NSString stringWithFormat:@"指纹验证成功"] message:nil];
                                          
                                      } else {
                                          [switchCell setOn:NO];
                                          NSString * string = error.userInfo[@"NSLocalizedDescription"];
                                          if ([string containsString:@"Canceled by user"]) {
                                              self.isChooseTouchID = NO;
                                              //  NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
                                              //  [defaults setBool:self.isChooseTouchID forKey:@"isChoose"];
                                              //  [defaults synchronize];
                                              dispatch_async(dispatch_get_main_queue(), ^{[self.tableView reloadData];});
                                          }
                                          //  else if ([string containsString:@"Fallback authentication mechanism selected"]){
                                          //
                                          //   }
                                      }
                                      NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
                                      [defaults setBool:self.isChooseTouchID forKey:@"isChoose"];
                                      [defaults synchronize];
                                      
                                  }];
            }
        }else{
//            [switchCell setOn:NO];
            self.isChooseTouchID = NO;
            NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
            [defaults setBool:self.isChooseTouchID forKey:@"isChoose"];
            [defaults synchronize];
            
        }
    }else{
        //没有支付密码
        [switchCell setOn:NO];
        [self go_check_payPassword_vc];
    }
    
}


// 主线程刷新 UI
- (void)refreshUI:(NSString *)str message:(NSString *)msg {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:str
                                                                       message:msg
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        [self presentViewController:alert animated:YES completion:^{
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [alert dismissViewControllerAnimated:YES completion:^{
                    if ([str isEqualToString:@"指纹验证成功"]) {
                        
                        SFYZPasswordViewController * viewC = [[SFYZPasswordViewController alloc] init];
                        viewC.isSuccessBlock = ^{
                            self.isChooseTouchID = NO;
                            NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
                            [defaults setBool:self.isChooseTouchID forKey:@"isChoose"];
                            [defaults synchronize];
                            [self.tableView reloadData];
                        };
                        [self go_next:viewC animated:YES viewController:self];
                    }else{
                        

                    }
                }];
            });
        }];
    });
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
        }else if (indexPath.row == 1) {
            //修改登录密码
            [self go_forget_password_vc];
        }else if (indexPath.row == 2) {
            [MobClick event:me_setting_setPayPasswordID];
            //修改支付密码
            [self go_check_payPassword_vc];

        }
        if ([CMCore is_open_gesture_password] && [LLLockPassword loadLockPassword]) {
            if (indexPath.row == 4) {
                [self go_genghuan_top_powssword];
            }
        }
    }
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
             //关于普汇
             [self go_about_app];
        }else if (indexPath.row == 1) {
            // 保障信息
            [self go_ensure];
        }else if (indexPath.row == 2) {
            [self go_service];
        }
    }
    if (indexPath.section == 2) {
        [self checkVersion];
//            //鼓励一下
//            NSString *str = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@",APP_ID];
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 2 && indexPath.row == 0) {
        [self set_tableFooterView];
    }
}
#pragma mark 退出
- (void)set_tableFooterView
{
    _click_button_view = [ClickButtonView load_nib];
    [_click_button_view set_button_enabled];
    [_click_button_view.click_button setTitle:@"安全退出" forState:UIControlStateNormal];
    [_click_button_view.click_button addTarget:self action:@selector(click_logout_button) forControlEvents:UIControlEventTouchUpInside];
    _tableView.tableFooterView = _click_button_view;
}
- (void)click_logout_button {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"确定要退出账号吗？" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}
#pragma mark 联系客服
- (void)go_service {
    [MobClick event:me_setting_serviceID];
    ServiceView *alert = [ServiceView alertViewDefault];
    alert.delegate = self;
    
    [alert show];
}
//更换手势密码
-(void)go_genghuan_top_powssword{
   
    LLLockViewController *llock_vc = [self.storyboard instantiateViewControllerWithIdentifier:@"LLLockViewController"];
    
    llock_vc.nLockViewType = LLLockViewTypeModify;

    [self presentViewController:llock_vc animated:YES completion:nil];


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
    NSString *phone = _user_info.mobilePhone;
    NSString *name = _user_info.realname;
    NSString *source = [[UIDevice currentDevice] name];
    [MQManager setClientInfo:@{@"name":name.length > 0 && ![name isKindOfClass:[NSNull class]]?name:phone, @"tel":phone, @"source":source} completion:^(BOOL success, NSError *error) {
    }];
    MQChatViewManager *chatViewManager = [[MQChatViewManager alloc] init];
    chatViewManager.chatViewStyle.navBarTintColor = [CMCore basic_black_color];
    chatViewManager.chatViewStyle.enableOutgoingAvatar = false;
    [chatViewManager pushMQChatViewControllerInViewController:self];
}


// 保障信息
- (void)go_ensure
{
    [MobClick event:me_setting_guaranteeID];
    WebViewController *web_vc = [self.storyboard instantiateViewControllerWithIdentifier:@"WebViewController"];
    [web_vc load_withUrl:@"https://www.beejc.cn/web/bee/safeInformation/safe_infomation_base_url.html" title:@"保障信息" canScaling:NO];// isShowCloseItem:YES
    [self go_next:web_vc animated:YES viewController:self];
}

// 关于普汇
- (void)go_about_app
{
    [MobClick event:me_setting_aboutMinID];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD showWithStatus:@"正在加载相关信息"];
    [CMCore about_us_with_is_alert:YES blockResult:^(NSNumber *code, id result, NSString *message) {
        [SVProgressHUD dismiss];
        if ([code integerValue] == 200) {
            AboutAppViewController *about_app_vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AboutAppViewController"];
           
            about_app_vc.aboutAppM = [AboutAppModel mj_objectWithKeyValues:result];
            [self go_next:about_app_vc animated:YES viewController:self];
        }
    } blockRetry:^(NSInteger index) {
        [SVProgressHUD dismiss];
        if (index == 1) {
            [self go_about_app];
        }
    }];
}

//修改登录密码
- (void)go_forget_password_vc
{
    [MobClick event:me_setting_setLoginPasswordID];
    ForgetPasswordViewController *update_vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ForgetPasswordViewController"];
    update_vc.setPasswordType = SetPasswordTypeUpdate;
    [self go_next:update_vc animated:YES viewController:self];
}

#pragma mark - sheetDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.cancelButtonIndex != buttonIndex) {
        if (buttonIndex == 1) {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults removeObjectForKey:@"Fingerprint_token"];
            [defaults removeObjectForKey:@"isChoose"];
            [CMCore logout];
            LoginNavigationController* loginNav = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginNavigationController"];
            [self.navigationController presentViewController:loginNav animated:YES completion:nil];
            self.tabBarController.selectedIndex = 3;
            [self.navigationController popToRootViewControllerAnimated:NO];
        }else {
            
        }
    }
}
#pragma mark 修改支付密码
- (void)go_check_payPassword_vc
{
    _user_info = [MemberModel mj_objectWithKeyValues:[CMCore get_user_info_member]];
    CheckLoginPasswordViewController *check_login_password_vc = [self.storyboard instantiateViewControllerWithIdentifier:@"CheckLoginPasswordViewController"];
    check_login_password_vc.enterType = @"setting";
    //100 更新支付密码(有支付密码{修改/忘记支付密码}) 200 设置支付密码(没有支付密码)
    if (_user_info.hasPayPassword) {
        check_login_password_vc.type = 100;
    }else {
        check_login_password_vc.type = 200;
    }
    [self go_next:check_login_password_vc animated:YES viewController:self];
}

#pragma mark 是否开启手势密码
- (void)click_switch_action {
   
    [MobClick event:me_setting_gesturePassewordID];
    LLLockViewController *llock_vc = [self.storyboard instantiateViewControllerWithIdentifier:@"LLLockViewController"];
    llock_vc.status = 100;//检查密码并关闭手势密码
    if (_is_open_hand_password_switch.on) {
        //开启手势密码，创建手势密码
        //设置手势密码
        llock_vc.nLockViewType = LLLockViewTypeCreate;
        NSString *str = @"";
        if (!_user_info.hasPayPassword) {
            _strBool = 1;
        }else {
            _strBool = 0;
        }
        _strBool = _user_info.hasPayPassword;
       
        if (_strBool) {
            //有支付密码
            str = @"修改支付密码";
            
            
        }else
        {
            //没有支付密码
            str = @"设置支付密码";
            
        }
        _titleArray = [NSMutableArray arrayWithObjects:@[@"手机账号", @"修改登录密码", str,@"手势密码"],@[@"关于普汇",@"安全保障",@"联系客服"],@[@"当前版本"],nil];
        _titleArrayImage = [NSMutableArray arrayWithObjects: @[@"v1.6_set_tel", @"v1.6_set_login_mima", @"v1.6_set_mima", @"v1.6_set_top",@"v1.6_set_gesture_password"],@[@"v1.6_set_min_about",@"v1.6_anquan_safety_guarantee",@"v1.6_phone"],
                            @[@"v1.6_set_versions"], nil];
        
        NSMutableArray * arr = [[NSMutableArray alloc]initWithArray:_titleArray[0]];
        [arr addObject:@"修改手势密码"];
        [arr addObject:@"信息推送"];

        [_titleArray replaceObjectAtIndex:0 withObject:arr];
        NSMutableArray * arr1 = [[NSMutableArray alloc]initWithArray:_titleArrayImage[0]];
        [arr1 addObject:@"v1.6_set_push"];

        [_titleArrayImage replaceObjectAtIndex:0 withObject:arr1];

        [self.tableView reloadData];
    }else {
        llock_vc.nLockViewType = LLLockViewTypeCheck;
        llock_vc.status = 100;
        //将关闭手势密码，要重新输入一次设置好的密码
        NSString *str = @"";
        _strBool = _user_info.hasPayPassword;
        if (_strBool) {
            //有支付密码
            str = @"修改支付密码";
        }else
        {
            //没有支付密码
            str = @"设置支付密码";
            
        }
        _titleArray = [NSMutableArray arrayWithObjects:@[@"手机账号", @"修改登录密码", str, @"手势密码", @"信息推送"],@[@"关于普汇",@"安全保障",@"联系客服"],@[@"当前版本"], nil];
        _titleArrayImage = [NSMutableArray arrayWithObjects: @[@"v1.6_set_tel", @"v1.6_set_login_mima", @"v1.6_set_mima", @"v1.6_set_top", @"v1.6_set_push"],@[@"v1.6_set_min_about",@"v1.6_anquan_safety_guarantee",@"v1.6_phone"],
                            @[@"v1.6_set_versions"], nil];

        [_tableView reloadData];
    }
    [self presentViewController:llock_vc animated:YES completion:nil];
}

#pragma mark 判断当前版本
- (void)checkVersion {
    [MobClick event:me_setting_nowVersionID];
    //当前版本是否是最新版本 先判断是否需要强更，再判断版本号
    
    [CMCore get_basic_config_is_alert:YES blockResult:^(NSNumber *code, id result, NSString *message) {
        if (result) {
            if ([result[@"mustUpdate"] integerValue]) {
                if ([[CMCore app_version] compare:result[@"iosNewestVersion"]] == NSOrderedAscending) {
                    [[JPAlert current] showAlertWithTitle:@"版本更新" content:@"当前不是最新版本，请前去更新" button:@[@"更新"] block:^(UIAlertView *alert, NSInteger index) {
                        NSString *str = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@", result[@"appId"]?:APP_ID];
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
                    }];
                }
            }else {
                // 先判断是否需要更新，再判断版本号
                if ([result[@"enableUpdate"] integerValue]) {
                    if ([[CMCore app_version] compare:result[@"iosNewestVersion"]] == NSOrderedAscending) {
                        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                        [defaults removeObjectForKey:@"Fingerprint_token"];
                        [defaults removeObjectForKey:@"isChoose"];
                        [[JPAlert current] showAlertWithTitle:@"版本更新" content:@"有可用的新版本，前去更新?" button:@[@"取消", @"更新"] block:^(UIAlertView *alert, NSInteger index) {
                            if (index == 1) {
                                NSString *str = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@", result[@"appId"]?:APP_ID];
                                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
                            }
                        }];
                    }else {
                        [[JPAlert current] showAlertWithTitle:@"温馨提示" content:@"当前已经是最新版本" button:@"好的" block:^(UIAlertView *alert, NSInteger index) {
                        }];
                    }
                }
            }
        }
    } blockRetry:^(NSInteger index) {
        if (index == 1) {
            [self checkVersion];
        }
    }];

    
}


@end
