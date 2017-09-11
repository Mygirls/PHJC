//
//  SFDynamicViewController.m
//  BeeEnrichmentAppiOS
//
//  Created by MC on 16/9/21.
//  Copyright © 2016年 didai. All rights reserved.
//

#import "SFDynamicViewController.h"
#import "BeeWebViewBridge.h"
#import "WebViewController.h"
#import "DiscoverView.h"
#import "DiscoverCell.h"
#import "MessagesModel.h"

@interface SFDynamicViewController ()<UIScrollViewDelegate, UIWebViewDelegate, UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<MessagesModel *> *messagesM;
@property (nonatomic, strong) BeeWebViewBridge *webBridge;
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) UIScrollView *scrollView;
@end
__weak SFDynamicViewController *discoverSelf1;
@implementation SFDynamicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    discoverSelf1 = self;
    self.messagesM = [NSMutableArray array];
    [self initTab];
    [self set_refresh];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_tableView.mj_header beginRefreshing];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}

- (void)initTab {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped];
    _tableView.contentInset = UIEdgeInsetsMake(0, 0, 64, 0);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = _tableView.backgroundColor = [UIColor colorWithHex:@"#f5f5f5"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

- (void)set_refresh
{
    _tableView.mj_header = [WMRefreshHeader headerWithRefreshingBlock:^{
        [discoverSelf1 get_data];
    }];
    [_tableView.mj_header beginRefreshing];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _messagesM.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 263;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kSectionHeaderHeight;
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
    if (indexPath.row == _messagesM.count - 1) {
        cell.downLineView.hidden = NO;
    }else {
        cell.downLineView.hidden = YES;
    }
    cell.model = _messagesM[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [MobClick event:discover_sfDynamic_infoID];
    MessagesModel *dic = _messagesM[indexPath.row];
    WebViewController *vc = [discoverSelf1.storyboard instantiateViewControllerWithIdentifier:@"WebViewController"];
    vc.share_content = @"点击查看详情";
    [vc load_withRightImageBarUrl:@"v1.6share" title:dic.title url:dic.url canScaling:YES];
    vc.flagStr = @"SFDynamic";
    [discoverSelf1 go_next:vc animated:YES viewController:self];
}

- (void)get_data
{
    [CMCore get_discover_with_home:@"0" is_alert:YES blockResult:^(NSNumber *code, id result, NSString *message) {
        if (result) {
            _messagesM = [MessagesModel mj_objectArrayWithKeyValuesArray:result];
            [_tableView reloadData];
        }
        
        [discoverSelf1.tableView.mj_header endRefreshing];
    } blockRetry:^(NSInteger index) {
        [discoverSelf1.tableView.mj_header endRefreshing];
        if (index == 1) {
            [self get_data];
        }
    }];
}

@end
