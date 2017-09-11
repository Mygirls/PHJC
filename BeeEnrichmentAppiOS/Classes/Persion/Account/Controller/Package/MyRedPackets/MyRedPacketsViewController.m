//
//  MyRedPacketsViewController.m
//  BeeEnrichmentAppiOS
//
//  Created by hwm on 16/10/12.
//  Copyright © 2016年 didai. All rights reserved.
//

#import "MyRedPacketsViewController.h"
#import "MyRedPacketsCell.h"
#import "MyRedHistoryView.h"
#import "HistroyViewController.h"
#import "PackageModel.h"

@interface MyRedPacketsViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NoDataPointView *tishiView;
@property (nonatomic, strong) NSString *titleName;
@property (nonatomic, strong) UIButton *selectBtn;
@property (nonatomic, strong) PackageModel *selectedCouponsDict;

@end

@implementation MyRedPacketsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTab];
    if (self.index == 0) {
        _titleName = @"红包";
    }else if (self.index == 1) {
        _titleName = @"加息券";
    }else if (self.index == 2) {
        _titleName = @"体验金";
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(go_history_red) name:@"MyRedHistoryView" object:nil];
    self.dataArray = [NSMutableArray array];
    if (self.dataArray.count) {
        if (![_type isEqualToString: @"pay" ]) {
            [self set_history];
        }
    }else {
        [self set_nothing_view];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) set_nothing_view {
    
    _tishiView = [NoDataPointView load_nib];
    _tishiView.label.font = [UIFont systemFontOfSize:17];
    _tishiView.label.textColor = [UIColor colorWithHex:@"#999999"];
    if (_index == 0) {
        [_tishiView set_title:@"您还没有红包" detailTitle:@"" buttonTitle:@"" isShowButton:NO imageName:@"v1.5_min-noRedPackets"];
    }else if (_index == 1) {
        [_tishiView set_title:@"您还没有加息券" detailTitle:@"" buttonTitle:@"" isShowButton:NO imageName:@"v1.5_package_noRate"];
    }else if (_index == 2) {
        [_tishiView set_title:@"您还没有体验金" detailTitle:@"" buttonTitle:@"" isShowButton:NO imageName:@"v1.5_package_noGold"];
    }
    MyRedHistoryView *v = [MyRedHistoryView load_nib];
    NSString *str = [NSString stringWithFormat:@"查看历史%@", _titleName];
    [v.historyBtn setTitle:str forState:UIControlStateNormal];
    [v.historyBtn addTarget:self action:@selector(go_history_red) forControlEvents:UIControlEventTouchUpInside];
    v.frame = CGRectMake(0, 0, kScreenWidth, 30);
    v.center = CGPointMake(_tishiView.frame.size.width / 2 + 1, _tishiView.frame.size.height / 2 + 100 );
    [_tishiView addSubview:v];
    self.tableView.tableFooterView = _tishiView;
}

- (void)set_history {
    MyRedHistoryView *v = [MyRedHistoryView load_nib];
    NSString *str = [NSString stringWithFormat:@"查看历史%@", _titleName];
    [v.historyBtn setTitle:str forState:UIControlStateNormal];
    [v.historyBtn addTarget:self action:@selector(go_history_red) forControlEvents:UIControlEventTouchUpInside];
    v.frame = CGRectMake(0, 0, kScreenWidth, 50);
    self.tableView.tableFooterView = v;
}

- (void)setTab {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight+6000000000) style:UITableViewStylePlain];
    if ([[CMCore iphoneType] isEqualToString:@"iPhone 5"]) {
        _tableView.contentInset = UIEdgeInsetsMake(40, 0, 0, 0);
    }else {
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    self.tableView.bounces = NO;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"MyRedPacketsCell" bundle:nil] forCellReuseIdentifier:@"MyRedPacketsCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
}

#pragma mark 查看历史
- (void)go_history_red {
    HistroyViewController *vc = [[HistroyViewController alloc] init];
    vc.index = _index;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark 选择理财券 选中cell
- (void)choiceBtn:(UIButton *)btn {
    
    self.selectBtn.selected = NO;
    btn.selected = YES;
    self.selectBtn = btn;
    BOOL bools =  [[NSUserDefaults standardUserDefaults] boolForKey:@"isBool_selecteBtn"];
    NSInteger btn_index = [[[NSUserDefaults standardUserDefaults] objectForKey:@"btn_index"] integerValue];
    NSInteger indexVC = [[[NSUserDefaults standardUserDefaults] objectForKey:@"index_VC"] integerValue];
    if (bools == YES && (btn.tag == btn_index) && (_index == indexVC)) { // 点击了同一个item，就取消选中
        self.selectBtn = nil;
        btn.selected = NO;
        NSDictionary *dict = @{@"count":@(_totalPackages)};
        // 发送通知, 并传模型数据
        [[NSNotificationCenter defaultCenter] postNotificationName:@"packageSelecteNo" object:nil userInfo:dict];
    }else {
        self.selectedCouponsDict = _dataArray[btn.tag];
        // 发送通知, 并传模型数据
        [[NSNotificationCenter defaultCenter] postNotificationName:@"packageSelecte" object:nil userInfo:(NSDictionary *)_selectedCouponsDict];
    }
    [[NSUserDefaults standardUserDefaults] setBool:btn.selected forKey: @"isBool_selecteBtn"];
    [[NSUserDefaults standardUserDefaults] setInteger:btn.tag forKey: @"btn_index"];
    [[NSUserDefaults standardUserDefaults] setInteger:_index forKey:@"index_VC"];
    [self.navigationController popViewControllerAnimated:YES];
    [_tableView reloadData];
}

#pragma mark tableview delegate / datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyRedPacketsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyRedPacketsCell"];
    cell.outDataImageView.hidden = YES;
    cell.choiceBtn.selected = NO;
    PackageModel *dic = self.dataArray[indexPath.section];
    NSInteger market_type = dic.marketType;
    if (_index == 0) {
        if (market_type == 10) {
            cell.backgroupImageView.image = [UIImage imageNamed:@"able_red_plan"];
        }else if (market_type == 30) {
            cell.backgroupImageView.image = [UIImage imageNamed:@"able_red_tranfer"];
        }else if (market_type == 20) {
            cell.backgroupImageView.image = [UIImage imageNamed:@"v1.5_abled_red"];
        }else {
            cell.backgroupImageView.image = [UIImage imageNamed:@"v1.5_abled_red"];
        }
    }else if (_index == 1) {
        if (market_type == 10) {
            cell.backgroupImageView.image = [UIImage imageNamed:@"able_rate_plan"];
        }else if (market_type == 30) {
            cell.backgroupImageView.image = [UIImage imageNamed:@"able_rate_transfer"];
        }else if (market_type == 20) {
            cell.backgroupImageView.image = [UIImage imageNamed:@"v1.5_abled_rate"];
        }else {
            cell.backgroupImageView.image = [UIImage imageNamed:@"v1.5_abled_rate"];
        }
        
    }else if (_index == 2) {
        if (market_type == 10) {
            cell.backgroupImageView.image = [UIImage imageNamed:@"able_gold_plan"];
        }else if (market_type == 30) {
            cell.backgroupImageView.image = [UIImage imageNamed:@"able_gold_transfer"];
        }else if (market_type == 20) {
            cell.backgroupImageView.image = [UIImage imageNamed:@"v1.5_abled_gold"];
        }else {
            cell.backgroupImageView.image = [UIImage imageNamed:@"v1.5_abled_gold"];
        }
        
    }
    
    cell.model = dic;
    cell.choiceBtn.tag = indexPath.section;
    if ([_type isEqualToString:@"pay"]) {//理财券
        cell.choiceBtn.hidden = NO;
    }else if ([_type isEqualToString:@"package"]) {//我的礼包
        cell.choiceBtn.hidden = YES;
    }
    if ([_type isEqualToString:@"pay"]) {
        BOOL bools =  [[NSUserDefaults standardUserDefaults] boolForKey:@"isBool_selecteBtn"];
        NSInteger btn_index = [[[NSUserDefaults standardUserDefaults] objectForKey:@"btn_index"] integerValue];
        NSInteger indexVC = [[[NSUserDefaults standardUserDefaults] objectForKey:@"index_VC"] integerValue];
        if (_index == indexVC) {
            if (indexPath.section == btn_index) {
                if ( bools == YES ) {
                    cell.choiceBtn.selected = YES;
                    _selectBtn = cell.choiceBtn;
                }
            }
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.index == 1) {
        return 91;
    }else  if (self.index == 0) {
        return 110;
    }else {
        return 110;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.dataArray.count) {
        if ([_type isEqualToString:@"pay"]) {
            UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
            _tableView.tableFooterView = v;
        }else {
            [self set_history];
        }
    }else {
        [self set_nothing_view];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MyRedPacketsCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([_type isEqualToString:@"pay"]) {
        PackageModel *dict = _dataArray[indexPath.section];
        double limite_money = dict.condition.minBuyMoney;
        double max_time = dict.condition.maxBuyDays;
        NSInteger types = dict.type;
        BOOL isInpuMoney_ = [[NSUserDefaults standardUserDefaults] boolForKey:@"isInpuMoney" ] ? NO : YES;
        if (isInpuMoney_ == NO) { // yes 已输入金额  no没输入金额
            if (types == 10) {// 加息券
                [self choiceBtn:cell.choiceBtn];// 选中按钮
            }else if (types == 20){// 抵扣券 判断金额>=
                if (_money >=  limite_money) {
                    [self choiceBtn:cell.choiceBtn];// 选中按钮
                    if (_selectedCouponsDict.ID == dict.ID) {
                        //这个cell当前是选中状态
                        _selectedCouponsDict = nil;
                    }else
                    {
                        _selectedCouponsDict = dict;
                    }
                    [_tableView reloadData];
                }else {
                    NSString *str = [NSString stringWithFormat:@"购买金额满%ld元以上可用",(long)limite_money];
                    [[JPAlert current] showAlertWithTitle:str button:@"好的"];
                }
            }else if (types == 40){ // 体验金
                // 体验金的时间和最小金额
                if (_time >= max_time && _money >= limite_money) {
                    [self choiceBtn:cell.choiceBtn];// 选中按钮
                    if (_selectedCouponsDict.ID == dict.ID) {
                        //这个cell当前是选中状态
                        _selectedCouponsDict = nil;
                    }else
                    {
                        _selectedCouponsDict = dict;
                    }
                    [_tableView reloadData];
                }else {
                    [[JPAlert current] showAlertWithTitle:@"不符合使用要求" button:@"好的"];
                }
            }else  if (types == 30) { // 红包
                if (_money >=  limite_money) {
                    if (_time >= max_time) {
                        [self choiceBtn:cell.choiceBtn];// 选中按钮
                        if (_selectedCouponsDict.ID == dict.ID) {
                            //这个cell当前是选中状态
                            _selectedCouponsDict = nil;
                        }else
                        {
                            _selectedCouponsDict = dict;
                        }
                        [_tableView reloadData];
                    }else {
                        NSString *str = [NSString stringWithFormat:@"融资期限满%ld天以上可用",(long)max_time];
                        [[JPAlert current] showAlertWithTitle:str button:@"好的"];
                    }
                }else {
                    NSString *str = [NSString stringWithFormat:@"购买金额满%ld元以上可用",(long)limite_money];
                    [[JPAlert current] showAlertWithTitle:str button:@"好的"];
                }
            }
        }else {
            NSString *str = @"请先输入购买金额后再选择优惠券";
            [[JPAlert current] showAlertWithTitle:str button:@"好的"];
        }
    }
}

@end
