//
//  SubjectListViewController.m
//  BeeEnrichmentAppiOS
//
//  Created by dll on 16/5/3.
//  Copyright © 2016年 didai. All rights reserved.
//

#import "SubjectListViewController.h"
#import "MyProductCell.h"
#import "OutLineProductCell.h"
#import "SubjectListCell.h"
#import "MoneyDetailViewController.h"//资产详情
@interface SubjectListViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *processing_list, *already_list;
@property (nonatomic, strong) NSDictionary *result_dic;

@property (nonatomic, copy) NSString *subject_id, *investment_amount, *expected_income;
@property (nonatomic, strong) NoDataPointView * ti_shi_view;
@end

@implementation SubjectListViewController
- (void)init_ui
{
    [super init_ui];
    __weak SubjectListViewController *_self = self;
    [self setRefresh];
    _ti_shi_view = [NoDataPointView load_nib];
    [_ti_shi_view set_title:@"暂无购买的标的列表" detailTitle:@"如有疑问，请联系客服" buttonTitle:SERVICE_PHONE isShowButton:YES imageName:nil];
    _ti_shi_view.clickButtonBlock = ^()
    {
        [_self click_other_button];
    };
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self load_subject_list];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_tableView.mj_header  endRefreshing];
    
}

- (void)setRefresh {
    __weak typeof(self) weakSelf = self;
    _tableView.mj_header = [WMRefreshHeader headerWithRefreshingBlock:^{
       [weakSelf load_subject_list];
    }];
    
}
- (void)set_subject_id:(NSString *)subject_id investment_amount:(NSString *)investment_amount expected_income:(NSString *)expected_income
{
    _subject_id = subject_id;
    _investment_amount = investment_amount;
    _expected_income = expected_income;
}
#pragma mark tableView delegate/dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _processing_list.count + _already_list.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 140;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return kSectionFooterHeight;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
   if (section == 0 || section == _processing_list.count) {
        return 30;
    }
    return kSectionHeaderHeight;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0 || section == _processing_list.count) {
        UIView *view = [UIView new];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, kScreenWidth - 32, 30)];
        label.textColor = [UIColor darkGrayColor];
        label.font = [UIFont systemFontOfSize:14];
        if (section == 0) {
            label.text = @"进行中";
        }else
        {
            label.text = @"已结束";
        }
        [view addSubview:label];
        return view;
    }
    return nil;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SubjectListCell *cell = [tableView load_reuseable_cell_from_nib_with_class:[SubjectListCell class]];
    NSDictionary *dic;
    if (indexPath.section < _processing_list.count) {
        dic = _processing_list[indexPath.section];
    }else
    {
        dic = _already_list[indexPath.section - _processing_list.count];
    }
    cell.model = dic;
    
        return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSMutableDictionary *dic;
    if (indexPath.section < _processing_list.count) {
        dic = _processing_list[indexPath.section];
    }else
    {
        dic = _already_list[indexPath.section - _processing_list.count];
    }
    MoneyDetailViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MoneyDetailViewController"];
    vc.data_dic_old = dic;
    vc.enterType = 4;
    [self go_next:vc animated:YES viewController:self];
}
#pragma mark 网络请求－load_subject_list
- (void)load_subject_list
{
    [CMCore get_subject_order_list_with_fp_order_id:_subject_id is_alert:YES blockResult:^(NSNumber *code, id result, NSString *message) {
        [_tableView.mj_header  endRefreshing];
        if ([code integerValue] == 200) {
            _processing_list = result[@"interest_in"];
            _already_list = result[@"finish"];
            [_tableView reloadData];
        }
        if (_processing_list.count == 0 && _already_list.count == 0) {
            _tableView.tableFooterView = _ti_shi_view;
        }else
        {
            _tableView.tableFooterView = nil;
        }
    } blockRetry:^(NSInteger index) {
        [_tableView.mj_header  endRefreshing];
        if (index == 1) {
            [_tableView.mj_header beginRefreshing];
        }
        if (_processing_list.count == 0 && _already_list.count == 0) {
            _tableView.tableFooterView = _ti_shi_view;
        }else
        {
            _tableView.tableFooterView = nil;
        }
        
    }];
}
#pragma mark 客服
- (void)click_other_button {
    [CMCore call_service_phone_with_view:self.view phone:SERVICE_PHONE];
}


@end
