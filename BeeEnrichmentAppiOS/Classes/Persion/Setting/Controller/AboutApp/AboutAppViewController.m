//
//  AboutAppViewController.m
//  BeeEnrichmentAppiOS
//
//  Created by dll on 15/12/27.
//  Copyright © 2015年 didai. All rights reserved.
//

#import "AboutAppViewController.h"
//#import "WXApi.h"
#import "SetupCell.h"
#import "MQChatViewManager.h"

@interface AboutAppViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
//@property (nonatomic, strong) NSArray *cell_title_ary, *cell_detail_ary, *titleArrayImage;
@property (nonatomic, strong) NSArray *titleArrayImage;

@end

@implementation AboutAppViewController
- (void)init_ui {
    //self.navigationItem.title = @"关于普汇";
    [super init_ui];
    _titleArrayImage = @[
                         @[@"v1.6_set_min_about", @"v1.6_set_anquan_safety_guarantee"],
                         @[@"v1.6_lianxi_phone"],
                         @[@"v1.6_phone"]];
//    _titleArrayImage = @[
//                         @[@"v1.6_set_me", @"v1.6_set_anquan_safety_guarantee"],
//  @[@"v1.6_weibo",@"v1.6_weixin", @"v1.6_lianxi_phone", @"v1.6_letter"],
//                         @[@"v1.6_phone"]];
//    _cell_title_ary = @[@"新浪微博",@"微信号" ,@"客服邮箱"];
//    _cell_detail_ary = @[ [NSString stringWithFormat:@"微博:%@",_aboutAppM.weiboId],[NSString stringWithFormat:@"微信:%@",_aboutAppM.wechatId],  [NSString stringWithFormat:@"电话:%@",SERVICE_PHONE], [NSString stringWithFormat:@"客服邮箱:%@",_aboutAppM.customerEmail]];
    [_tableView setSeparatorColor:[UIColor colorWithHex:@"#e1e1e1"]];
    [_tableView setSeparatorInset:UIEdgeInsetsZero];
    [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    _tableView.bounces = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    if (![CMCore is_login]) {
        self.tabBarController.selectedIndex = 0;
    }
}

#pragma mark tableView delegate/dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
//    }else if (section == 1) {
//        return 4;
    }else {
        return 1;
    }
    
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
    
    SetupCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SetupCell"];
    
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"SetupCell" owner:nil options:nil].lastObject;
    }
    [cell setPreservesSuperviewLayoutMargins:NO];
    [cell setSeparatorInset:UIEdgeInsetsZero];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            
            cell.titleLabel.text = @"关于我们";
        }else{
           
            cell.titleLabel.text = @"安全承诺";

        }
        
        
//    }else if (indexPath.section == 1) {
//        
//        cell.titleLabel.text  =  _cell_detail_ary[indexPath.row];
//        
//        
//        
    }else  {// if (indexPath.section == 2)
    
//        cell.arrowImageView.image = nil;
        
//        if (indexPath.row == 0) {
        
            cell.titleLabel.text = @"联系客服";
//        }else{
            
//            cell.titleLabel.text = SERVICE_PHONE;
            
//        }
        

    }
    cell.hotMarkImageView.image = [UIImage imageNamed:_titleArrayImage[indexPath.section][indexPath.row]];

    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *strUrl = @"";
    NSString *title = @"";
    if (indexPath.section == 0) {
        WebViewController *webVC = [self.storyboard instantiateViewControllerWithIdentifier:@"WebViewController"];
        if (indexPath.row == 0) {
            //介绍
            
            strUrl = [CMCore getH5AddressWithEnterType:H5EnterTypePlatformIntroduction targeId:nil markType:0];
            //平台介绍platform_is_introduced
            title = @"关于我们";
        }else
        {
            strUrl = [CMCore getH5AddressWithEnterType:H5EnterTypeSecurity targeId:nil markType:0];
            title = @"安全承诺";
        }
        [webVC load_withUrl:strUrl title:title canScaling:NO];// isShowCloseItem:YES
        [self go_next:webVC animated:YES viewController:self];
//
//    }else if (indexPath.section == 1){
//       
//        if (indexPath.row == 0) {
//            
//            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
//            pasteboard.string = _aboutAppM.weiboId;
//            [[JPAlert current] showAlertWithTitle:@"温馨提示" content:@"已复制到剪贴板" button:@[@"取消", @"确定"] block:^(UIAlertView *alert, NSInteger index) {
//                
//            }];
//            
//        }else if (indexPath.row == 1) {
//            
//            
//            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
//            pasteboard.string = _aboutAppM.wechatId;
//            [[JPAlert current] showAlertWithTitle:@"温馨提示" content:[NSString stringWithFormat:@"微信号'%@'已复制到剪贴板，是否前往微信关注？",_cell_detail_ary[1]] button:@[@"取消", @"前往"] block:^(UIAlertView *alert, NSInteger index) {
//                if (index == 1) {
//                    if (![WXApi openWXApp]) {
//                        [SVProgressHUD setMinimumDismissTimeInterval:1.5];
//                        [SVProgressHUD showErrorWithStatus:@"微信打开错误"];
//                        
//                    }
//                    
//                }
//            }];
//            
//            
//            //            WebViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"WebViewController"];
//            //            NSString *url = _aboutUsInfo[@"company_url"];
//            //            [vc load_withUrl:url title:@"公司网站" canScaling:NO];// isShowCloseItem:YES
//            //            [self go_next:vc animated:YES];
//            
//
//
//        
//        
//        }else  {//if (indexPath.row == 2)
    
            
//            //客服热线
//            [CMCore call_service_phone_with_view:self.view phone:SERVICE_PHONE];
//        }else if (indexPath.row == 3) {
//            
//            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
//            pasteboard.string = _aboutAppM.customerEmail;
//            [[JPAlert current] showAlertWithTitle:@"温馨提示" content:@"已复制到剪贴板" button:@[@"取消", @"确定"] block:^(UIAlertView *alert, NSInteger index) {
//            }];
//            
//        }
//
//    
    }else {// if (indexPath.section == 2)

//            [self go_chat];

        [CMCore call_service_phone_with_view:self.view phone:SERVICE_PHONE];
        
        
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

@end
