//
//  ManagePasswordViewController.m
//  BeeEnrichmentAppiOS
//
//  Created by LiuXiaoMin on 15/12/25.
//  Copyright © 2015年 LiuXiaoMin. All rights reserved.
//

#import "ManagePasswordViewController.h"

#import "LLLockViewController.h"//手势密码
#import "ForgetPasswordViewController.h"//忘记密码
#import "CheckLoginPasswordViewController.h"//验证登录信息
#import "SetPayPasswordViewController.h"//设置支付密码
@interface ManagePasswordViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) UISwitch *is_open_hand_password_switch;
@property (nonatomic, strong) NSArray *cell_img_ary, *cell_name_ary;
@end

@implementation ManagePasswordViewController

- (void)init_ui {
    [super init_ui];
    
    _cell_img_ary = @[@"v1_personal_center_lock2",@"v1_personal_center_lock2", @"v1_personal_center_hand"];
    NSString *str = @"";
    if ([CMCore get_user_info_member][@"has_pay_password"]) {
        //有支付密码
        str = @"修改支付密码";
    }else
    {
        //没有支付密码
        str = @"设置支付密码";
    }
    _cell_name_ary = @[@"修改登录密码",str, @"开启手势"];
    _is_open_hand_password_switch = [[UISwitch alloc] init];
    [_is_open_hand_password_switch addTarget:self action:@selector(click_switch_action) forControlEvents:UIControlEventValueChanged];
    
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    if ([CMCore is_open_gesture_password] && [LLLockPassword loadLockPassword]) {
        //手势密码是有的，开启状态
        _is_open_hand_password_switch.on = YES;
    }else
    {
        _is_open_hand_password_switch.on = NO;
    }
    if ([CMCore is_login]) {
        
    }else
    {
        [self go_back:NO viewController:self];
    }
}

#pragma mark 是否开启手势密码
- (void)click_switch_action {
  
    LLLockViewController *llock_vc = [self.storyboard instantiateViewControllerWithIdentifier:@"LLLockViewController"];
    llock_vc.status = 100;//检查密码并关闭手势密码
    if (_is_open_hand_password_switch.on) {
        //开启手势密码，创建手势密码
        //设置手势密码
        llock_vc.nLockViewType = LLLockViewTypeCreate;
        DLog(@"手势密码开启成功");
    }else {
        llock_vc.nLockViewType = LLLockViewTypeCheck;
        llock_vc.status = 100;
        //将关闭手势密码，要重新输入一次设置好的密码
        DLog(@"手势密码关闭成功");
    }
    [self presentViewController:llock_vc animated:YES completion:nil];
}
#pragma mark tableView delegate/dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    }
    return 1;
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
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView load_reuseable_cell_with_style:UITableViewCellStyleValue1 _class:[UITableViewCell class]];
    cell.textLabel.font = [UIFont systemFontOfSize:16];;
    cell.textLabel.textColor = [UIColor colorWithRed:0.52 green:0.52 blue:0.52 alpha:1];
    NSInteger index = indexPath.section * 2 + indexPath.row;
    cell.imageView.image = [UIImage imageNamed:_cell_img_ary[index]];
    cell.textLabel.text = _cell_name_ary[index];
    if (indexPath.section == 1) {
        cell.accessoryView = _is_open_hand_password_switch;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            //修改登录密码
            [self go_forget_password_vc];
        }
        if (indexPath.row == 1) {
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            if ([cell.textLabel.text isEqualToString:@"修改支付密码"]) {
                //有支付密码，修改支付密码
                [self go_check_login_password_vc];
            }else
            {
                //没有支付密码
                [self go_setPayPassword_vc];
            }
            
        }
    }
    
}
#pragma mark 忘记密码
- (void)go_forget_password_vc
{
    ForgetPasswordViewController *update_vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ForgetPasswordViewController"];
    update_vc.setPasswordType = SetPasswordTypeUpdate;
    [self go_next:update_vc animated:YES viewController:self];
}
#pragma mark 验证登录密码
- (void)go_check_login_password_vc
{
    NSDictionary *user_info = [CMCore get_user_info_member];
    if ([[user_info allKeys] containsObject:@"password_md5"] && [NSString stringWithFormat:@"%@",user_info[@"password_md5"]].length > 0) {
        CheckLoginPasswordViewController *check_login_password_vc = [self.storyboard instantiateViewControllerWithIdentifier:@"CheckLoginPasswordViewController"];
        //100 忘记支付密码 200 修改支付密码
        check_login_password_vc.type = 200;
        [self go_next:check_login_password_vc animated:YES viewController:self];
    }else
    {
        [self go_setPayPassword_vc];
    }
}
#pragma mark 设置支付密码
- (void)go_setPayPassword_vc
{
    SetPayPasswordViewController *set_payPassword_vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SetPayPasswordViewController"];
    set_payPassword_vc.title = _cell_name_ary[1];
    [self go_next:set_payPassword_vc animated:YES viewController:self];
}
@end
