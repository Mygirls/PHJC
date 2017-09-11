    //
//  MyPackageViewController.m
//  BeeEnrichmentAppiOS
//
//  Created by hwm on 16/10/12.
//  Copyright © 2016年 didai. All rights reserved.
//

#import "MyPackageViewController.h"
#import "WMSementView.h"//中转
#import "MyRedPacketsViewController.h"//我的红包
#import "KeyExchangeViewController.h"//口令兑换
#import "HistroyViewController.h"
#import "PackageModel.h"

@interface MyPackageViewController () <UISearchBarDelegate, UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) MyRedPacketsViewController *redVC, *rateVC, *goldVC;
@property (nonatomic, strong) NSArray<PackageModel *> *redData,*rateData,*goldData;

@end

@implementation MyPackageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNav];
    self.view.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.00];
    [self addChildViewControllers];
     _redData = [NSArray array];
     _rateData = [NSArray array];
     _goldData = [NSArray array];
    [self setRefresh];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(select:) name:@"packageSementView" object:nil];
}

#pragma mark 设置下表VC
- (void)select:(NSNotification *)info {
    NSDictionary *dic = info.userInfo;
    _selectVC = [dic[@"indexVC"] integerValue];
    [_tableView reloadData];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark 刷新
- (void)setRefresh {
    __weak MyPackageViewController *_self = self;
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD showWithStatus:@"数据加载中..."];
    _tableView.mj_header = [WMRefreshHeader headerWithRefreshingBlock:^{
        [_self load_package_list];
    }];
}

#pragma mark 加载子控制器
- (void)addChildViewControllers {
    _redVC = [[MyRedPacketsViewController alloc] init];
    _redVC.type = _type;
    _redVC.money = [_moneyD doubleValue];
    _redVC.index = 0;
    _redVC.totalPackages = _totalPackagess;
    _rateVC = [[MyRedPacketsViewController alloc] init];
    _rateVC.type = _type;
    _rateVC.money = [_moneyD doubleValue];
    _rateVC.index = 1;
    _rateVC.totalPackages = _totalPackagess;
//    _goldVC = [[MyRedPacketsViewController alloc] init];
//    _goldVC.type = _type;
//    _goldVC.money = [_moneyD doubleValue];
//    _goldVC.index = 2;
//    _goldVC.totalPackages = _totalPackagess;
    
    if (_dataDic.units == 2) {// 等额本息标
        _rateVC.time = _dataDic.Period * 30;
        _redVC.time = _dataDic.Period * 30;
//        _goldVC.time = _dataDic.Period * 30;
    }else {
        _rateVC.time = _dataDic.Period;
        _redVC.time = _dataDic.Period;
//        _goldVC.time = _dataDic.Period;
    }
    NSArray *controllers=@[_redVC,_rateVC];
    NSArray *titleArray =@[@"红包",@"加息券"];
    WMSementView *wms =[[WMSementView alloc] initWithFrame:self.view.bounds controllers:controllers titleArray:titleArray ParentController:self index:_indexVC];
    [self.tableView addSubview:wms];
}

#pragma mark 加载视图
- (void)loadView {
    [super loadView];
    [self setTab];
}

#pragma mark 设置tableview
- (void)setTab {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight + 30000000000) style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.00];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 100)];
    v.backgroundColor = [UIColor clearColor];
    _tableView.tableFooterView = v;
    _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.view = self.tableView;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
      if (![CMCore is_login]) {
        self.tabBarController.selectedIndex = 0;
        [self go_back:YES viewController:self];
        return;
    }
    [self load_package_list];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}

- (void)setNav {
    self.navigationItem.title = @"我的礼包";
    if (![_type isEqualToString:@"pay"]) {//支付进来的
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"口令兑换" style:UIBarButtonItemStylePlain target:self action:@selector(go_duihuan)];
    }
}

#pragma mark 去口令兑换
- (void)go_duihuan {
    [MobClick event:me_myPackage_keyExchangeID];
    KeyExchangeViewController *vc = [[KeyExchangeViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark 请求礼包数据
- (void)load_package_list
{
    if ([_type isEqualToString:@"pay"]) {//支付进来的
        [_tableView.mj_header  endRefreshing];
        [CMCore get_order_couold_use_coupon_list_with_product_id:_dataDic.ID is_alert:YES market_type:_market_type_interger blockResult:^(NSNumber *code, id result, NSString *message) {
            if (result)
            {
                [SVProgressHUD dismiss];
                _redVC.dataArray = [PackageModel mj_objectArrayWithKeyValuesArray:result[@"redPacket"]];
                _rateVC.dataArray = [PackageModel mj_objectArrayWithKeyValuesArray:result[@"increaseRates"]];
                _goldVC.dataArray = [PackageModel mj_objectArrayWithKeyValuesArray:result[@"experienceGold"]];
                _redData = [PackageModel mj_objectArrayWithKeyValuesArray:result[@"redPacket"]];
                _rateData = [PackageModel mj_objectArrayWithKeyValuesArray:result[@"increaseRates"]];
                _goldData = [PackageModel mj_objectArrayWithKeyValuesArray:result[@"experienceGold"]];
                [_redVC.tableView reloadData];
                [_rateVC.tableView reloadData];
                [_goldVC.tableView reloadData];
                [_tableView reloadData];
            }else {
                [SVProgressHUD dismiss];
            }
        } blockRetry:^(NSInteger index) {
            [SVProgressHUD dismiss];
            if (index == 1) {
                [self load_package_list];
            }
        }];
    }else {
        _market_type_array = @[@10,@20,@30];
        [_tableView.mj_header  endRefreshing];
        [CMCore get_red_packet_lis_with_is_alert:YES market_type:_market_type_array blockResult:^(NSNumber *code, id result, NSString *message) {
            if (result) {
                [SVProgressHUD dismiss];
                [_tableView.mj_header  endRefreshing];
                _redVC.dataArray = [PackageModel mj_objectArrayWithKeyValuesArray:result[@"redPacket"]];
                _rateVC.dataArray = [PackageModel mj_objectArrayWithKeyValuesArray:result[@"increaseRates"]];
                _goldVC.dataArray = [PackageModel mj_objectArrayWithKeyValuesArray:result[@"experienceGold"]];
                _redData = [PackageModel mj_objectArrayWithKeyValuesArray:result[@"redPacket"]];
                _rateData = [PackageModel mj_objectArrayWithKeyValuesArray:result[@"increaseRates"]];
                _goldData = [PackageModel mj_objectArrayWithKeyValuesArray:result[@"experienceGold"]];
                [_redVC.tableView reloadData];
                [_rateVC.tableView reloadData];
                [_goldVC.tableView reloadData];
                [_tableView reloadData];
            }else {
               [SVProgressHUD dismiss];
            }
        } blockRetry:^(NSInteger index) {
            [SVProgressHUD dismiss];
            if (index == 1) {
                [self load_package_list];
            }
        }];
    }
}

#pragma mark 
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (_selectVC == 0) {
        return _redData.count;
    }else if (_selectVC == 1) {
        return _rateData.count;
    }else if (_selectVC == 2) {
        return _goldData.count;
    }else {
        return 0;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"default"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"default"];
    }
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_selectVC == 1) {
        return 91;
    }else {
        return 110;
    }
    
}

@end
