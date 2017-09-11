//
//  MyWalletViewController.m
//  BeeEnrichmentAppiOS
//
//  Created by LiuXiaoMin on 15/12/23.
//  Copyright © 2015年 LiuXiaoMin. All rights reserved.
//

#import "MyWalletViewController.h"

#import "WalletCell.h"
#import "MyWalletHeadCell.h"
#import "MyCouponsFooterView.h"
#import "SearchView.h"
#import "GetRedPacketView.h"

#import "WebViewController.h"

@interface MyWalletViewController ()<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UIGestureRecognizerDelegate>
@property (strong, nonatomic) NoDataPointView *wallet_tishi_view;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
//@property (nonatomic, strong) NSArray *wallet_list;
@property (nonatomic, strong) NSArray *available_list, *not_available_list, *show_list;
@property (nonatomic, strong) MyCouponsFooterView *licaiquan_view;

@property (nonatomic, strong) SearchView *search_view;


@property (nonatomic, strong) UIView *success_view;


@end

@implementation MyWalletViewController

- (void)init_ui {
    [super init_ui];
    [self set_refresh];
    [self set_close_keyboard];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"兑换" style:UIBarButtonItemStylePlain target:self action:@selector(click_right_item)];
    
    _search_view = [SearchView load_nib];
    _search_view.search_bar.delegate = self;
    self.navigationItem.titleView = _search_view;
    
    _licaiquan_view = [MyCouponsFooterView load_nib];
    [_licaiquan_view.button addTarget:self action:@selector(click_change_data_button:) forControlEvents:UIControlEventTouchUpInside];
    _licaiquan_view.label.text = @"没有更多红包啦";
    [_licaiquan_view.button setTitle:@"查看过期红包》" forState:UIControlStateNormal];
    
//    __weak MyWalletViewController *_self = self;
    _wallet_tishi_view = [NoDataPointView load_nib];
    [_wallet_tishi_view set_title:@"您还木有红包" detailTitle:@"" buttonTitle:@"" isShowButton:NO imageName:@"v1.5_min-noRedPackets"];
//    _wallet_tishi_view.clickButtonBlock = ^(){
////        [_self click_other_button];
//    };
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    if (![CMCore is_login]) {
        self.tabBarController.selectedIndex = 0;
        [self go_back:YES viewController:self];
        return;
    }
//    [_tableView start_header_refresh];
    [self load_licai_list];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_tableView.mj_header  endRefreshing];
    [self close_key_board];
}
- (void)set_refresh
{
    __weak MyWalletViewController *_self = self;
    _tableView.mj_header = [WMRefreshHeader headerWithRefreshingBlock:^{
        [_self load_licai_list];
    }];
    
}
//文字开始编辑时
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    
}
//文字改变或清除时
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    
}
//点击搜索按钮
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    [self dui_huan_redPacket_with_text:searchBar.text];
}
//
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    return YES;
}
//结束编辑时
-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    
}

- (void)close_key_board
{
    [_search_view.search_bar resignFirstResponder];
}
- (IBAction)click_description:(id)sender {
    WebViewController *web_vc = [self.storyboard instantiateViewControllerWithIdentifier:@"WebViewController"];
    //红包说明red_envelope_instructions
    NSString *url = [NSString stringWithFormat:@"%@red_envelope_instructions",HTTP_API_BASIC];
    [web_vc load_withUrl:url title:@"红包说明" canScaling:NO];// isShowCloseItem:YES
    [self go_next:web_vc animated:YES viewController:self];
}
- (void)click_other_button
{
    [self.tabBarController setSelectedIndex:1];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self go_back:YES viewController:self];
}
- (void)click_change_data_button:(UIButton*)button{
    
    if ([_licaiquan_view.label.text isEqualToString:@"没有过期红包啦"]) {
        _show_list = _available_list;
            _licaiquan_view.label.text = @"没有更多红包啦";
            [button setTitle:@"查看过期红包》" forState:UIControlStateNormal];
    }else
    {
        _show_list = _not_available_list;
            _licaiquan_view.label.text = @"没有过期红包啦";
            [button setTitle:@"查看未过期红包》" forState:UIControlStateNormal];
    }
    [_tableView reloadData];
    
}

- (void)click_right_item
{

    [self close_key_board];
    [self dui_huan_redPacket_with_text:_search_view.search_bar.text
     ];
}















#pragma mark tableView delegate/dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _show_list.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kScreenWidth * 0.44;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return kSectionFooterHeight;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kSectionFooterHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    WalletCell *cell = [tableView load_reuseable_cell_from_nib_with_class:[WalletCell class]];
    WalletCell *cell = [[NSBundle mainBundle] loadNibNamed:@"WalletCell" owner:nil options:nil].lastObject;
    if (_available_list.count > 0) {
        cell.boolNum = YES;
    }
    NSDictionary *dic = _show_list[indexPath.row];
    cell.model = dic;
//    __weak MyWalletViewController *_self = self;
//    cell.walletCellClickBlock = ^(){
//        [_self open_red_packet_with_dic:dic];
//    };
    cell.click_button.tag = indexPath.row + 100;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self close_key_board];
    
}



- (void)show_success_view_with_dictionary:(NSDictionary*)dictionary
{   CGFloat x = 30;
    CGFloat width = kScreenWidth - x * 2;
    CGFloat height = width * 0.676;
    CGFloat y = (kScreenHeight - height - 64) / 2.0;
    _success_view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    
    UIView *back_view = [[UIView alloc] initWithFrame:_success_view.frame];
    back_view.backgroundColor = [UIColor blackColor];
    back_view.alpha = 0.3;
    [back_view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(success_view_dismiss)]];
    GetRedPacketView *red_view = [GetRedPacketView load_nib];
    red_view.frame = CGRectMake(x, y, width, height);
    red_view.model = dictionary;
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [_success_view addSubview:back_view];
    [_success_view addSubview:red_view];
    [keyWindow addSubview:_success_view];
    [self performSelector:@selector(success_view_dismiss) withObject:nil afterDelay:2.5];
    
}
- (void)success_view_dismiss
{
    if (_success_view) {
        [_success_view removeFromSuperview];
    }
}









//- (void)open_red_packet_with_dic:(NSDictionary *)dictionary
//{
//    [CMCore open_red_packet_with_id:dictionary[@"member_red_packet"][@"_id"] is_alert:YES blockResult:^(NSNumber *code, id result, NSString *message) {
//        if (result) {
//            [self show_success_view_with_dictionary:dictionary];
//            [CMCore save_user_info_with_member:result[@"member"]];
//            [_tableView start_header_refresh];
//        }
//    } blockRetry:^(NSInteger index) {
//        if (index == 1) {
//            [self open_red_packet_with_dic:dictionary];
//        }
//    }];
//    
//}
- (void)load_licai_list
{
    [CMCore get_red_packet_lis_with_is_alert:YES market_type:@[@10, @20, @30] blockResult:^(NSNumber *code, id result, NSString *message) {
        if (result) {
            //            [SVProgressHUD dismiss];
            [_tableView.mj_header  endRefreshing];
            _not_available_list = result[@"Expired"];
            _available_list = result[@"Unexpired"];
            _show_list = _available_list;
            
            if (_available_list.count == 0 && _not_available_list.count == 0) {
                _tableView.tableFooterView = _wallet_tishi_view;
            }else
            {
                _tableView.tableFooterView = _licaiquan_view;
                _licaiquan_view.label.text = @"没有更多红包啦";
                [_licaiquan_view.button setTitle:@"查看过期红包》" forState:UIControlStateNormal];
            }
            [_tableView reloadData];
        }
        
    } blockRetry:^(NSInteger index) {
        //        [SVProgressHUD dismiss];
        [_tableView.mj_header  endRefreshing];
        if (_available_list.count == 0 && _not_available_list.count == 0) {
            _tableView.tableFooterView = _wallet_tishi_view;
        }else
        {
            _licaiquan_view.label.text = @"没有更多红包啦";
            [_licaiquan_view.button setTitle:@"查看过期红包》" forState:UIControlStateNormal];
        }
        [_tableView reloadData];
        
    }];
}
- (void)dui_huan_redPacket_with_text:(NSString*)text
{
    [CMCore exchange_red_packet_with_get_passwd:text is_alert:YES blockResult:^(NSNumber *code, id result, NSString *message) {
        if (result) {
            [_tableView.mj_header beginRefreshing];
            NSString *string = [NSString stringWithFormat:@"%@\n%@\n%@",result[@"title"],result[@"detail"],result[@"description"]];
            [[JPAlert current] showAlertWithTitle:string button:@"好的"];
        }
        
    } blockRetry:^(NSInteger index) {
        if (index == 1) {
            [self dui_huan_redPacket_with_text:text];
        }
    }];
}
#pragma mark 设置轻拍手势，点击空白区域键盘消失
- (void)set_close_keyboard {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(close_key_board)];
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
}
#pragma mark tap delegate
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return YES;
}
@end
