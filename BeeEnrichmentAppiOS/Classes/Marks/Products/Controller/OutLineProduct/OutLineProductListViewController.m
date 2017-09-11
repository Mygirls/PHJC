//
//  OutLineProductListViewController.m
//  BeeEnrichmentAppiOS
//
//  Created by dll on 16/2/25.
//  Copyright © 2016年 didai. All rights reserved.
//

#import "OutLineProductListViewController.h"
#import "OutLineProductCell.h"
#import "NoDataPointView.h"
#import "SubjectListViewController.h"


@interface OutLineProductListViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong)NSArray *already_list, *processing_list;
@property (nonatomic, strong) NoDataPointView * ti_shi_view;
@end

@implementation OutLineProductListViewController

- (void)init_ui {
    [super init_ui];
    self.title = @"理财产品";
    __weak OutLineProductListViewController *_self = self;
    _ti_shi_view = [NoDataPointView load_nib];
    [_ti_shi_view set_title:@"积累财富从现在开始" detailTitle:@"让钱为你赚钱!" buttonTitle:@"看看其他产品" isShowButton:YES imageName:@"v1_no_data_pig"];
    _ti_shi_view.clickButtonBlock = ^()
    {
        [_self click_other_button];
    };

    [self set_refresh];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    //每当界面出来的时候，先刷新一次数据
    [self load_product_list];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_tableView.mj_header  endRefreshing];
    [SVProgressHUD dismiss];
}
//去看看理财集市
- (void)click_other_button{
    [self.tabBarController setSelectedIndex:1];
//    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [self go_back:YES viewController:self];
}

//设置下拉刷新
- (void)set_refresh {
    __weak OutLineProductListViewController *_self = self;
    _tableView.mj_header = [WMRefreshHeader headerWithRefreshingBlock:^{
        [_self load_product_list];
    }];
    
}
#pragma mark tableView delegate/dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        //计息中
        return _processing_list.count;
    }else {
        //已兑付
        return _already_list.count;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 150;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return kSectionFooterHeight;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if ((section == 0 && _processing_list.count == 0)||(section == 1 && _already_list.count == 0)) {
        return kSectionFooterHeight;
    }else
    {
        return 16;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(16, 5, kScreenWidth - 16, 16)];
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = [UIColor darkGrayColor];
    [view addSubview: label];
    if (section == 0) {
        label.text = @"已购买";
    }else if (section == 1) {
        label.text = @"已兑付";
    }
    if ((section == 1 && _already_list.count == 0)||(section == 0 && _processing_list.count == 0)) {
        view.hidden = YES;
    }else
    {
        view.hidden = NO;
    }
    return view;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OutLineProductCell *cell = [tableView load_reuseable_cell_from_nib_with_class:[OutLineProductCell class]];
    NSDictionary *dic;
    if (indexPath.section == 0) {
        dic = _processing_list[indexPath.row];
    }else
    {
        dic = _already_list[indexPath.row];
    }
    if (indexPath.section == 0) {
        cell.isFinish = NO;
    }else
    {
        cell.isFinish = YES;
    }
    cell.model = dic;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SubjectListViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SubjectListViewController"];
    NSDictionary *dic;
    if (indexPath.section == 0) {
        dic = _processing_list[indexPath.row];
    }else
    {
        dic = _already_list[indexPath.row];
    }
    [vc set_subject_id:dic[@"order"][@"_id"] investment_amount:[NSString stringWithFormat:@"%.02f",[dic[@"order"][@"investment_amount"] doubleValue]] expected_income:[NSString stringWithFormat:@"%.02f",[dic[@"order"][@"expected_income"] doubleValue]]];
    [self go_next:vc animated:YES viewController:self];
    
}
#pragma mark 网络请求－线下理财产品列表
- (void)load_product_list {
    [CMCore old_customer_product_list_with_is_alert:YES blockResult:^(NSNumber *code, id result, NSString *message) {
        [_tableView.mj_header  endRefreshing];
        
        _processing_list = result[@"success"];
        _already_list = result[@"close"];
        if (_processing_list.count == 0 && _already_list.count == 0) {
            _tableView.tableFooterView = _ti_shi_view;
        }else
        {
            _tableView.tableFooterView = nil;
        }
        [_tableView reloadData];
    } blockRetry:^(NSInteger index) {
        [_tableView.mj_header  endRefreshing];
        if (index == 1) {
            [self load_product_list];
        }
        if (_processing_list.count == 0 && _already_list.count == 0) {
            _tableView.tableFooterView = _ti_shi_view;
        }else
        {
            _tableView.tableFooterView = nil;
        }
        [_tableView reloadData];
    }];
}

// old_customer_product_list_with_is_alert

@end
