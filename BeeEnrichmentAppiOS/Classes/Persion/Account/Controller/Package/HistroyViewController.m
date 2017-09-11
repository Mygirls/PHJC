//
//  HistroyViewController.m
//  BeeEnrichmentAppiOS
//
//  Created by hwm on 16/10/12.
//  Copyright © 2016年 didai. All rights reserved.
//

#import "HistroyViewController.h"
#import "MyRedPacketsCell.h"
#import "PackageModel.h"

@interface HistroyViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (strong, nonatomic) NoDataPointView *tishiView;
@property (nonatomic, strong) NSArray<PackageModel *> *packageHistoryM;

@end

@implementation HistroyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.00];
    if (_index == 0) {
        self.navigationItem.title = @"历史红包";
    }else if (_index == 1) {
        self.navigationItem.title = @"历史加息券";
    }else if (_index == 2) {
        self.navigationItem.title = @"历史体验金";
    }
    self.view.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.00];
    _packageHistoryM = [NSArray array];
    [self setTab];
    [self set_refresh];
    
    if (_packageHistoryM.count) {
        _tableView.tableFooterView = [[UIView alloc] init];
    }else {
        [self set_nothing_view];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self load_historyPackage_list];
}

#pragma mark 刷新
- (void)set_refresh {
    __weak typeof(self) weakSelf = self;
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD showWithStatus:@"正在加载"];
    _tableView.mj_header = [WMRefreshHeader headerWithRefreshingBlock:^{
        [weakSelf load_historyPackage_list];
    }];
    
}

#pragma mark 请求历史红包数据
- (void)load_historyPackage_list {
    int type;
    if (_index == 0) {
        type = 30;
    }else if (_index == 1){
        type = 10;
    }else {
        type = 40;
    }
    [_tableView.mj_header  endRefreshing];
    [CMCore get_historyPacket_lis_with_is_alert:YES type:type blockResult:^(NSNumber *code, id result, NSString *message) {
        if (result) {
            if (_index == 0) {
                _packageHistoryM = [PackageModel mj_objectArrayWithKeyValuesArray:result[@"redPacket"]];// @"历史红包";
            }else if (_index == 1) {
                _packageHistoryM = [PackageModel mj_objectArrayWithKeyValuesArray:result[@"increaseRates"]]; //@"历史加息券";
            }else if (_index == 2) {
                _packageHistoryM = [PackageModel mj_objectArrayWithKeyValuesArray:result[@"experienceGold"]];// @"历史体验金";
            }
            
            [SVProgressHUD dismiss];
            [_tableView reloadData];
        }else {
            [JPConfigCurrent showAlertWithTitle:[NSString stringWithFormat:@"%@",message] button:@[@"好的"]];
            [SVProgressHUD dismiss];
        }
        
    } blockRetry:^(NSInteger index) {
        [SVProgressHUD dismiss];
        if (index == 1) {
            [self load_historyPackage_list];
        }
    }];
}

- (void) set_nothing_view {
    
    _tishiView = [NoDataPointView load_nib];
    NSString *str = [NSString string];
    
    if (_index == 0) {
        str = @"v1.5_min-noRedPackets";
    }else if (_index == 1) {
        str = @"v1.5_package_noRate";
    }else if (_index == 2) {
        str = @"v1.5_package_noGold";
    }
    _tishiView.label.font = [UIFont systemFontOfSize:17];
    _tishiView.label.textColor = [UIColor colorWithHex:@"#999999"];
    [_tishiView set_title:[NSString stringWithFormat:@"您还没有%@", self.navigationItem.title] detailTitle:@"" buttonTitle:@"" isShowButton:NO imageName:str];
    self.tableView.tableFooterView = _tishiView;
}

- (void)setTab {
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"MyRedPacketsCell" bundle:nil] forCellReuseIdentifier:@"MyRedPacketsCell"];
    [self.view addSubview:self.tableView];
    _tableView.contentInset = UIEdgeInsetsMake(0, 0, 64, 0);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [[UIView alloc]init];
}

#pragma mark tableview delegate / datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _packageHistoryM.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MyRedPacketsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyRedPacketsCell"];
    cell.outDataImageView.hidden = NO;
    cell.contentTextLable.textColor = [UIColor colorWithHex:@"#999999"];
    cell.timeLable.textColor = [UIColor colorWithHex:@"#999999"];
    cell.title_lable.textColor = [UIColor colorWithHex:@"#666666"];
    PackageModel *dict = _packageHistoryM[indexPath.section];
    NSInteger market_type = dict.marketType;
    if (_index == 0) {
        if (market_type == 10) {
            cell.backgroupImageView.image = [UIImage imageNamed:@"disabled_red_plan"];
        }else if (market_type == 30) {
            cell.backgroupImageView.image = [UIImage imageNamed:@"disabled_red_transfer"];
        }else if (market_type == 20) {
            cell.backgroupImageView.image = [UIImage imageNamed:@"v1.5_disabled_red"];
        }else {
            cell.backgroupImageView.image = [UIImage imageNamed:@"v1.5_disabled_red"];
        }
        
    }else if (_index == 1) {
        if (market_type == 10) {
            cell.backgroupImageView.image = [UIImage imageNamed:@"disable_rate_plan"];
        }else if (market_type == 30) {
            cell.backgroupImageView.image = [UIImage imageNamed:@"disable_rate_transfer"];
        }else if (market_type == 20) {
            cell.backgroupImageView.image = [UIImage imageNamed:@"v1.5_disabled_rate"];
        }else {
             cell.backgroupImageView.image = [UIImage imageNamed:@"v1.5_disabled_rate"];
        }
        
    }else if (_index == 2) {
        if (market_type == 10) {
            cell.backgroupImageView.image = [UIImage imageNamed:@"disable_gold_plan"];
        }else if (market_type == 30) {
            cell.backgroupImageView.image = [UIImage imageNamed:@"disable_gold_transfer"];
        }else if (market_type == 20) {
            cell.backgroupImageView.image = [UIImage imageNamed:@"v1.5_disabled_gold"];
        }else{
            cell.backgroupImageView.image = [UIImage imageNamed:@"v1.5_disabled_gold"];
        }
        
    }
    cell.model = dict;
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.index == 1) {
        return 91;
    }else if (self.index == 2) {
        return 110;
    } else {
        return 110;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_packageHistoryM.count) {
        _tableView.tableFooterView = [[UIView alloc] init];
    }else {
        [self set_nothing_view];
    }
}

@end
