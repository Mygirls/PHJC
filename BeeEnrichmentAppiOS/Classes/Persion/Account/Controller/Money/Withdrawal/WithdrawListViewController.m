//
//  WithdrawListViewController.m
//  BeeEnrichmentAppiOS
//
//  Created by dll on 15/12/28.
//  Copyright © 2015年 didai. All rights reserved.
//

#import "WithdrawListViewController.h"
#import "WithdrawListCell.h"
#import "WithdrawalHistoryModel.h"

@interface WithdrawListViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) BOOL is_have_more;
@property (nonatomic, strong) NSMutableArray<WithdrawalHistoryModel *> *withdrawalHistoryM;
@property (nonatomic, strong) NoDataPointView *ti_shi_view;
@end

@implementation WithdrawListViewController
- (void)init_ui
{
    [super init_ui];
    _ti_shi_view = [NoDataPointView load_nib];
    [_ti_shi_view set_title:@"您还没有提现记录" detailTitle:@"" buttonTitle:@"" isShowButton:NO imageName:@"v1_no_data_jilu"];
    _withdrawalHistoryM = [NSMutableArray array];
    [self set_refresh];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [_tableView start_header_refresh];
    [self load_refresh];
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_tableView.mj_header endRefreshing];
    [SVProgressHUD dismiss];
}
- (void)set_refresh
{
    __weak WithdrawListViewController *_self = self;
    _tableView.mj_header = [WMRefreshHeader headerWithRefreshingBlock:^{
        [_self load_refresh];
    }];
    _tableView.mj_footer = [WMRefreshFooter footerWithRefreshingBlock:^{
        if (_self.is_have_more) {
            [_self load_withdraw];
            
        }else
        {
            [_self.tableView.mj_footer endRefreshing];
            [SVProgressHUD showInfoWithStatus:@"没有更多记录啦"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
            });
        }
    }];
    
}
- (void)load_refresh
{
    _page = 1;
    _is_have_more = YES;
    [self load_withdraw];
}
#pragma mark tableView delegate/dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _withdrawalHistoryM.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return kSectionFooterHeight;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kSectionFooterHeight;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WithdrawListCell *cell = [tableView load_reuseable_cell_from_nib_with_class:[WithdrawListCell class]];
        WithdrawalHistoryModel *dic = _withdrawalHistoryM[indexPath.row];
        cell.model = dic;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *info = @"";
    NSInteger stutas = _withdrawalHistoryM[indexPath.row].status;
    if (stutas == 300) {
        info = [NSString stringWithFormat:@"%@",_withdrawalHistoryM[indexPath.row].auditRemark];
        info = info?:@"暂无失败原因";
        [[JPAlert current] showAlertWithTitle:@"失败原因" content:info button:@"确定" block:nil];
    } else if (stutas == 400) {
        info = [NSString stringWithFormat:@"%@",_withdrawalHistoryM[indexPath.row].remark];
        info = info?:@"暂无失败原因";
        [[JPAlert current] showAlertWithTitle:@"失败原因" content:info button:@"确定" block:nil];
    }
    
    
}
#pragma mark 加载提现记录
- (void)load_withdraw
{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD showWithStatus:@"正在加载提现记录"];
    [CMCore withdraw_list_with_page:_page count:LOAD_COUNT_MAX is_alert:YES blockResult:^(NSNumber *code, id result, NSString *message) {
        [SVProgressHUD dismiss];
        [_tableView.mj_header  endRefreshing];
        [_tableView.mj_footer endRefreshing];
        if (result) {
            NSMutableArray<WithdrawalHistoryModel *> *list = [WithdrawalHistoryModel mj_objectArrayWithKeyValuesArray:result];
            if (list.count > 0) {
                if (list.count < LOAD_COUNT_MAX) {
                    _is_have_more = NO;
                }else {
                    _is_have_more = YES;
                }
                if (_page == 1) {
                    [_withdrawalHistoryM removeAllObjects];
                    [_withdrawalHistoryM addObjectsFromArray:list];
                }else {
                    [_withdrawalHistoryM addObjectsFromArray:list];
                }
                
                _page ++;
                
            }else
            {
                _is_have_more = NO;
            }
        }
        if (_withdrawalHistoryM.count == 0) {
            _tableView.tableFooterView = _ti_shi_view;
        }else
        {
            _tableView.tableFooterView = nil;
        }
        [_tableView reloadData];
    } blockRetry:^(NSInteger index) {
        [SVProgressHUD dismiss];
        [_tableView.mj_header  endRefreshing];
        [_tableView.mj_footer endRefreshing];
        if (_withdrawalHistoryM.count == 0) {
            _tableView.tableFooterView = _ti_shi_view;
        }else
        {
            _tableView.tableFooterView = nil;
        }
        [_tableView reloadData];
        if (index == 1) {
            [self load_withdraw];
        }
    }];
}
@end
