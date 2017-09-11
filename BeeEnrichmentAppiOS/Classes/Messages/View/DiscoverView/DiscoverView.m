//
//  DiscoverView.m
//  BeeEnrichmentAppiOS
//
//  Created by dll on 16/8/4.
//  Copyright © 2016年 didai. All rights reserved.
//

#import "DiscoverView.h"
#import "DiscoverCell.h"

@interface DiscoverView ()
@property (nonatomic, strong) NSArray *dataArray;
@end
__weak DiscoverView *discoverViewSelf;

@implementation DiscoverView

-(void)awakeFromNib
{
    [super awakeFromNib];
    discoverViewSelf = self;
    self.dataArray = [NSArray array];
    [self set_refresh];
}

- (void)set_refresh
{
    _tableView.mj_header = [WMRefreshHeader headerWithRefreshingBlock:^{
        [discoverViewSelf get_data];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 230;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kSectionFooterHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return kSectionFooterHeight;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DiscoverCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DiscoverCell"];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"DiscoverCell" owner:nil options:nil].lastObject;
    }
    cell.model = _dataArray[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dic = _dataArray[indexPath.row];
    self.clickActionWithIndex(indexPath.row, dic);
}

- (void)get_data
{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
    [SVProgressHUD showWithStatus:@"努力加载中..."];
    [CMCore get_discover_with_home:@"0" is_alert:YES blockResult:^(NSNumber *code, id result, NSString *message) {
        if (result) {
            [SVProgressHUD dismiss];
            _dataArray = result;
            [_tableView reloadData];
            [discoverViewSelf.tableView.mj_header endRefreshing];
        }
    } blockRetry:^(NSInteger index) {
        if (index == 1) {
            [self get_data];
        }
    }];
}

@end
