//
//  MyTransactionViewController.m
//  BeeEnrichmentAppiOS
//
//  Created by dll on 15/12/24.
//  Copyright © 2015年 didai. All rights reserved.
//

#import "MyTransactionViewController.h"
#import "TransactionCell.h"
#import "MoneyFlowModel.h"

@interface MyTransactionViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) BOOL is_have_more;
@property (nonatomic, strong) NSMutableArray<MoneyFlowModel *> *moneyFlowInfoM;
@property (nonatomic, strong) NoDataPointView *ti_shi_view;
@end

@implementation MyTransactionViewController
- (void)init_ui {
    [super init_ui];
    _moneyFlowInfoM = [NSMutableArray array];
    self.navigationItem.title = @"资金明细";
    __weak MyTransactionViewController *_self = self;
    _ti_shi_view = [NoDataPointView load_nib];
    [_ti_shi_view set_title:@"您还没有交易记录哦" detailTitle:@"" buttonTitle:@"去看看" isShowButton:YES imageName:@"v1_no_data_jilu"];
    _ti_shi_view.clickButtonBlock = ^(){
        [_self click_other_button];
    };
    [self set_refresh];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [_tableView.mj_header beginRefreshing];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
    [_tableView.mj_header  endRefreshing];
}

- (void)set_refresh
{
    __weak MyTransactionViewController *_self = self;
    _tableView.mj_header = [WMRefreshHeader headerWithRefreshingBlock:^{
        [_self load_refresh];
    }];
    _tableView.mj_footer = [WMRefreshFooter footerWithRefreshingBlock:^{
        if (_self.is_have_more) {
            [_self load_transaction];
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
    [self load_transaction];
}

- (void)click_other_button {
    [self.tabBarController setSelectedIndex:1];
//    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [self go_back:YES viewController:self];
}
- (void)click_left_item {
    [self go_back:YES viewController:self];
}
#pragma mark tableView delegate/dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _moneyFlowInfoM.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return kSectionFooterHeight;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kSectionFooterHeight;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TransactionCell *cell = [tableView load_reuseable_cell_from_nib_with_class:[TransactionCell class]];
    MoneyFlowModel *dic = _moneyFlowInfoM[indexPath.row];
    cell.model = dic;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    NSLog(@"内容：%@", _result_list[indexPath.row]);
    
}

- (void)load_transaction
{
    [CMCore transaction_record_with_page:_page count:LOAD_COUNT_MAX is_alert:YES blockResult:^(NSNumber *code, id result, NSString *message) {
        [_tableView.mj_header  endRefreshing];
        [_tableView.mj_footer endRefreshing];
        if (result) {
            NSMutableArray<MoneyFlowModel *> *list = [MoneyFlowModel mj_objectArrayWithKeyValuesArray:result];
            if (list.count > 0) {
                _tableView.tableFooterView = nil;
                if (list.count < LOAD_COUNT_MAX) {
                    _is_have_more = NO;
                }else {
                    _is_have_more = YES;
                }
                if (_page == 1) {
                    [_moneyFlowInfoM removeAllObjects];
                    [_moneyFlowInfoM addObjectsFromArray:list];
                }else {
                    [_moneyFlowInfoM addObjectsFromArray:list];
                }
                
                _page ++;
            }else
            {
                _is_have_more = NO;
            }
        }
        if (_moneyFlowInfoM.count > 0) {
            _tableView.tableFooterView = nil;
        }else
        {
            _tableView.tableFooterView = _ti_shi_view;
        }
        [_tableView reloadData];
    } blockRetry:^(NSInteger index) {
        [_tableView.mj_header  endRefreshing];
        [_tableView.mj_footer endRefreshing];
        if (_moneyFlowInfoM.count > 0) {
            _tableView.tableFooterView = nil;
        }else
        {
            _tableView.tableFooterView = _ti_shi_view;
        }
        [_tableView reloadData];
        if (index == 1) {
            [self load_transaction];
        }
        
    }];
    
}
@end
