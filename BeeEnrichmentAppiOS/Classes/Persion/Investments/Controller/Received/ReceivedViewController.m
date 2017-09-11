//
//  ReceivedViewController.m
//  BeeEnrichmentAppiOS
//
//  Created by dll on 16/11/14.
//  Copyright © 2016年 didai. All rights reserved.
//

#import "ReceivedViewController.h"
#import "MyProductCell.h"
#import "MoneyDetailViewController.h"
#import "NoDataPointView.h"

@interface ReceivedViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic ,strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *product_list;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) BOOL is_have_more;
@property (nonatomic,strong) NoDataPointView *noDataView;
@end

__weak ReceivedViewController *_recSelf;
@implementation ReceivedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _recSelf = self;
    
    _page = 1;
    _product_list = [NSMutableArray array];
    [self setSomething];
    [self setRefresh];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (![CMCore is_login]) {
        self.tabBarController.selectedIndex = 0;
        [self go_back:YES viewController:self];
        return;
    }
    [self load_dingqi_product];
}

- (void)load_refresh
{
    _page = 1;
    _is_have_more = YES;
    [self load_dingqi_product];
}

- (void)setSomething
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"去投资" style:UIBarButtonItemStylePlain target:self action:@selector(go_invest)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor colorWithRed:0.40 green:0.40 blue:0.40 alpha:1.00];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64 - 44) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor colorWithHex:@"#F1F1F1"];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    _noDataView = [[NSBundle mainBundle] loadNibNamed:@"NoDataPointView" owner:nil options:nil].firstObject;
    _noDataView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64 - 44);
    _noDataView.clickButtonBlock = ^(){
        [_recSelf go_invest];
    };
    
   
}

- (void)setRefresh {
    _tableView.mj_header = [WMRefreshHeader headerWithRefreshingBlock:^{
        [_recSelf load_refresh];
    }];
    _tableView.mj_footer = [WMRefreshFooter footerWithRefreshingBlock:^{
        if (_recSelf.is_have_more) {
            [_recSelf load_dingqi_product];
        }else {
            [_recSelf.tableView.mj_footer endRefreshing];
            [SVProgressHUD showInfoWithStatus:@"没有更多记录啦"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
            });
        }
    }];
}

- (void)go_invest
{
    self.tabBarController.selectedIndex = 1;
    [self go_root:YES];
}

#pragma mark - UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _product_list.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([_product_list[indexPath.row][@"subject"][@"status"] integerValue] == 400) {
        return 194;
    }
    return 172;
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
    if ([_product_list[indexPath.row][@"subject"][@"status"] integerValue] == 400) {
        MyProductCell *myProCell = [[NSBundle mainBundle] loadNibNamed:@"MyProductCell" owner:nil options:nil].firstObject;
        NSDictionary *dic = _product_list[indexPath.row];
        myProCell.modelOld = dic;
        return myProCell;
    }else {
        MyProductCell *myProCell = [[NSBundle mainBundle] loadNibNamed:@"MyProductCell" owner:nil options:nil].lastObject;
        NSDictionary *dic = _product_list[indexPath.row];
        myProCell.modelOld = dic;
        return myProCell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    MoneyDetailViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MoneyDetailViewController"];
    vc.enterType = 4;
    vc.data_dic_old = _product_list[indexPath.row];
    [self go_next:vc animated:YES viewController:self];
}


#pragma mark 网络请求－定期资产列表
- (void)load_dingqi_product
{
    
    //200成功
    [CMCore invest_record_with_status:300 market_type:20 page:_page count:LOAD_COUNT_MAX is_alert:YES blockResult:^(NSNumber *code, id result, NSString *message) {
        [_tableView.mj_header  endRefreshing];
        [_tableView.mj_footer endRefreshing];
        //99e929c1113f80054933022578634840
        if (result) {
            NSArray *list = result[@"value"];
            if (list.count > 0) {
                if (list.count < LOAD_COUNT_MAX) {
                    _is_have_more = NO;
                }else {
                    _is_have_more = YES;
                }
                if (_page == 1) {
                    [_product_list removeAllObjects];
                    [_product_list addObjectsFromArray:list];
                }else {
                    [_product_list addObjectsFromArray:list];
                }
                _page ++;
            }else {
                _is_have_more = NO;
            }
        }
        if (_product_list.count == 0) {
            _tableView.tableFooterView = _noDataView;
        }else
        {
            _tableView.tableFooterView = nil;
        }
        [_tableView reloadData];
    } blockRetry:^(NSInteger index) {
        [_tableView.mj_footer endRefreshing];
        [_tableView.mj_header  endRefreshing];
        if (_product_list.count == 0) {
            _tableView.tableFooterView = _noDataView;
        }else
        {
            _tableView.tableFooterView = nil;
        }
        [_tableView reloadData];
        if (index == 1) {
            [self load_dingqi_product];
        }
    }];
}

@end
