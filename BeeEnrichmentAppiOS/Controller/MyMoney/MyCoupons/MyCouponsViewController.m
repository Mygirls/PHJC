//
//  MyCouponsViewController.m
//  BeeEnrichmentAppiOS
//
//  Created by LiuXiaoMin on 15/12/23.
//  Copyright © 2015年 LiuXiaoMin. All rights reserved.
//

#import "MyCouponsViewController.h"

#import "MyCouponsCell.h"
#import "MyCouponsFooterView.h"
#import "SearchView.h"
@interface MyCouponsViewController ()<UITableViewDelegate, UITableViewDataSource,UISearchBarDelegate, UIGestureRecognizerDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *available_list, *not_available_list, *show_list;
@property (nonatomic, strong) MyCouponsFooterView *licaiquan_view;
@property (nonatomic, strong) NoDataPointView *ti_shi_view;
@property (nonatomic, strong) UIAlertView *alert;

@property (nonatomic, strong) SearchView *search_view;
@end
__weak MyCouponsViewController *myLiCaiQuanWeakSelf;
@implementation MyCouponsViewController
- (void)init_ui {
    [super init_ui];
    [self set_close_keyboard];
    myLiCaiQuanWeakSelf = self;
    [self set_refresh];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"兑换" style:UIBarButtonItemStylePlain target:self action:@selector(click_right_item)];
    
    _ti_shi_view = [NoDataPointView load_nib];
    [_ti_shi_view set_title:@"您还没有理财券哦" detailTitle:@"" buttonTitle:@"去看看" isShowButton:NO imageName:@"v1_no_data_licai"];
    _ti_shi_view.clickButtonBlock = ^(){
        [myLiCaiQuanWeakSelf click_other_button];
    };
    
    _licaiquan_view = [MyCouponsFooterView load_nib];
    [_licaiquan_view.label.text isEqualToString:@"没有更多可用券"];
    [_licaiquan_view.button setTitle:@"查看过期券》" forState:UIControlStateNormal];
    [_licaiquan_view.button addTarget:self action:@selector(click_change_data_button:) forControlEvents:UIControlEventTouchUpInside];
    
    _search_view = [SearchView load_nib];
    _search_view.search_bar.delegate = self;
    self.navigationItem.titleView = _search_view;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
//    [_tableView start_header_refresh];
    [self load_licai_list];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self close_key_board];
    [_tableView.mj_header  endRefreshing];
}
- (void)set_refresh
{
    __weak MyCouponsViewController *_self = self;
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
    [self dui_huan_licaiquan_with_text:searchBar.text];
    
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
- (void)click_other_button
{
    [self.tabBarController setSelectedIndex:1];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self go_back:YES viewController:self];
}
- (IBAction)click_description_button:(id)sender {
    WebViewController *web_vc = [self.storyboard instantiateViewControllerWithIdentifier:@"WebViewController"];
    //理财券说明ticket_instructions
    NSString *url = [NSString stringWithFormat:@"%@ticket_instructions",HTTP_API_BASIC];
    [web_vc load_withUrl:url title:@"理财券说明" canScaling:NO];// isShowCloseItem:YES
    [self go_next:web_vc animated:YES viewController:self];
}

- (void)click_change_data_button:(UIButton*)button{
    
    if ([_licaiquan_view.label.text isEqualToString:@"没有更多可用券"]) {
            _show_list = _not_available_list;
            _tableView.tableFooterView = _licaiquan_view;
            _licaiquan_view.label.text = @"没有更多过期券";
            [button setTitle:@"查看可用券》" forState:UIControlStateNormal];
    }else
    {
        
        _show_list = _available_list;
            _tableView.tableFooterView = _licaiquan_view;
            _licaiquan_view.label.text = @"没有更多可用券";
            [button setTitle:@"查看过期券》" forState:UIControlStateNormal];
    }
    [_tableView reloadData];
//    [SVProgressHUD dismiss];

}
- (void)click_left_item {
    [self go_back:YES viewController:self];
}
- (void)click_right_item
{
    [self close_key_board];
    [self dui_huan_licaiquan_with_text:_search_view.search_bar.text];
}

#pragma mark tableView delegate/dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   return _show_list.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return kSectionFooterHeight;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kSectionFooterHeight;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyCouponsCell *cell = [tableView load_reuseable_cell_from_nib_with_class:[MyCouponsCell class]];
    NSDictionary *dic = _show_list[indexPath.row];
    if ([_show_list isEqual:_available_list]) {
        [cell setCellIsAvailable:YES isChooseEnabled:NO];
    }else
    {
        [cell setCellIsAvailable:NO isChooseEnabled:NO];
    }
    cell.model = dic;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self close_key_board];
    
}

#pragma mark 兑换优惠券
- (void)dui_huan_licaiquan_with_text:(NSString*)text
{
    [CMCore exchange_coupon_with_get_passwd:text is_alert:YES blockResult:^(NSNumber *code, id result, NSString *message) {
        if (result) {
            [SVProgressHUD showSuccessWithStatus:@"兑换成功"];
            [SVProgressHUD setMinimumDismissTimeInterval:1.5];
        }
        [_tableView.mj_header beginRefreshing];
    } blockRetry:^(NSInteger index) {
        if (index == 1) {
            [self dui_huan_licaiquan_with_text:text];
        }
    }];
 
}

- (void)load_licai_list
{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD showWithStatus:@"加载中..."];
    [CMCore get_member_coupon_list_with_is_alert:YES blockResult:^(NSNumber *code, id result, NSString *message) {
        [SVProgressHUD dismiss];
        if (result) {
            [_tableView.mj_header  endRefreshing];
            _not_available_list = result[@"Expired"];
            _available_list = result[@"Unexpired"];
            _show_list = _available_list;
            if (_available_list.count == 0 && _not_available_list.count == 0) {
                _tableView.tableFooterView = _ti_shi_view;
            }else
            {
                _tableView.tableFooterView = _licaiquan_view;
                _licaiquan_view.label.text = @"没有更多可用券";
                [_licaiquan_view.button setTitle:@"查看过期券》" forState:UIControlStateNormal];
                
            }
            
            [_tableView reloadData];
        }
    } blockRetry:^(NSInteger index) {
        [_tableView.mj_header  endRefreshing];
        [SVProgressHUD dismiss];
        if (_show_list.count == 0) {
            _tableView.tableFooterView = _ti_shi_view;
        }else
        {
            _licaiquan_view.label.text = @"没有更多可用券啦";
            [_licaiquan_view.button setTitle:@"查看过期券》" forState:UIControlStateNormal];
        }
        
        [_tableView reloadData];
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
