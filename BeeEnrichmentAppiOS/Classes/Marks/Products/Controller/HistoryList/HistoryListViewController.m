//
//  HistoryListViewController.m
//  BeeEnrichmentAppiOS
//
//  Created by dll on 16/4/1.
//  Copyright © 2016年 didai. All rights reserved.
//

#import "HistoryListViewController.h"
#import "OutLineProductListViewController.h"// 线下产品
#import "MoneyViewController.h"// 投资记录
#import "OldHistoryListCell.h"
@interface HistoryListViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation HistoryListViewController


- (void)init_ui {
    [super init_ui];
    [self.navigationController.navigationBar setTranslucent:NO];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

#pragma mark 线下产品
- (void)goOutLine
{
    OutLineProductListViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"OutLineProductListViewController"];
    [self go_next:vc animated:YES viewController:self];
}

#pragma mark 老客户投资记录
- (void)goHistory {
    MoneyViewController *dingqi_vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MoneyViewController"];
    dingqi_vc.type = 4;
    dingqi_vc.market_type = 9090;
    dingqi_vc.navtitle = @"投资记录";
    [self.navigationController pushViewController:dingqi_vc animated:YES];
}

#pragma mark tableView delegate/dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return kSectionFooterHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 54.5;
    }else {
        return 14;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OldHistoryListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OldHistoryListCell"];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"OldHistoryListCell" owner:self options:nil].firstObject;
    }
    NSArray *iconTitle = @[@"v1.6_mine_invest_record", @"v1.6_mine_product"];
    NSArray *titleName = @[@"历史投资记录", @"历史理财产品"];
    cell.iconImageView.image = [UIImage imageNamed:iconTitle[indexPath.section]];
    cell.titleLable.text = titleName[indexPath.section];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        [self goHistory];
    }else if (indexPath.section == 1){
        [self goOutLine];
    }
}


@end
