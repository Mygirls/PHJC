//
//  PlanDetailViewController.m
//  BeeEnrichmentAppiOS
//
//  Created by dll on 2017/5/19.
//  Copyright © 2017年 DuLonglong. All rights reserved.
//

#import "PlanDetailViewController.h"
#import "PlanDetailCell.h"
#import "PlanDetailCustomView.h"
#import "SubPlanListViewController.h"

@interface PlanDetailViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSArray *titleArr, *valueArr;
@property (strong, nonatomic) IBOutlet UILabel *subjectStatus;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) ProductsModel *pDicData;

@end
__weak PlanDetailViewController *_planDetailSelf;
@implementation PlanDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _planDetailSelf = self;
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:FontOfAttributed size:19]}];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"去投资" style:UIBarButtonItemStylePlain target:self action:@selector(go_invest)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor colorWithRed:0.40 green:0.40 blue:0.40 alpha:1.00];
    
    _pDicData = [ProductsModel new];
    
    [self refreshPlanDetail];
    [self getDataWithRequest];
//        [self dealWithData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _planDetailSelf = self;
    [_tableView.mj_header beginRefreshing];
}

- (NSArray *)titleArr
{
    if (!_titleArr) {
        _titleArr = [[NSArray alloc] init];
    }
    return _titleArr;
}

- (NSArray *)valueArr
{
    if (!_valueArr) {
        _valueArr = [[NSArray alloc] init];
    }
    return _valueArr;
}

- (void)refreshPlanDetail
{
    _tableView.mj_header = [WMRefreshHeader headerWithRefreshingBlock:^{
        [_planDetailSelf getDataWithRequest];
    }];
}

- (void)dealWithData
{
    BeePlanModel *inPlanDic = _pDicData.beePlan;
    NSString *units = @"";
    NSString *buyTime = [CMCore turnToDate:inPlanDic.createTime];
    NSString *expectedAnnualRate = [NSString stringWithFormat:@"%@%%",inPlanDic.customAnnualRate] ;
    if (inPlanDic.beePlan.units == 1) {//  内层beePlan
        units = @"天";
    } else {
        units = @"月";
    }
    NSString *timeLimit = [NSString stringWithFormat:@"%ld%@", (long)inPlanDic.beePlan.Period, units];//  内层beePlan
    NSString *repaymentStyle = [[NSString alloc] init];
    NSInteger repaymentStatus = inPlanDic.beePlan.repaymentId;//  内层beePlan
    //100一次性到期还本付息到余额，200每月还息到期还本，300等额每月还本息
    switch (repaymentStatus) {
        case 100:
            repaymentStyle = @"一次性到期还本付息到余额";
            break;
        case 200:
            repaymentStyle = @"等额每月还本息";
            break;
        case 300:
            repaymentStyle = @"等额每月还息,到期还本";
            break;
        default:
            repaymentStyle = @"状态码不匹配";
            break;
    }
    NSString *investMoney = [NSString stringWithFormat:@"%.2f元", floor(inPlanDic.totalMoney * 100) / 100];
    NSString *expectedIncome = [NSString stringWithFormat:@"%.2f元", floor(inPlanDic.expectedIncome * 100) / 100];
    NSString *regularEndTime = [[CMCore turnToDate:inPlanDic.regularEndTime] substringToIndex:10];
    NSString *createTime = [[CMCore turnToDate:inPlanDic.regularStartTime] substringToIndex:10];
    NSInteger status = inPlanDic.status;
    switch (status) {
        case 200:
            _subjectStatus.text = @"投资中";
            break;
        case 300:
            _subjectStatus.text = @"已兑付";
            break;
        case 201:
            _subjectStatus.text = @"计息中";
            break;
        case 399:
            _subjectStatus.text = @"转让中";
            break;
        case 400:
            _subjectStatus.text = @"已转让";
            break;
        default:
            _subjectStatus.text = @"暂无状态";
            break;
    }
    
    _valueArr = @[buyTime, expectedAnnualRate, timeLimit, repaymentStyle, investMoney, expectedIncome, regularEndTime, createTime];
    _titleArr = @[@"购买时间", @"预期年化收益", @"项目期限", @"还款方式", @"投资本金", @"预期收益", @"到期时间", @"计息时间"];
    
}

- (void)go_invest
{
    self.tabBarController.selectedIndex = 1;
    [self go_root:YES];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titleArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 65;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 65;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    PlanDetailCustomView *planDaileCustomView = [[NSBundle mainBundle] loadNibNamed:@"PlanDetailCustomView" owner:nil options:nil].lastObject;
    planDaileCustomView.leftLabel.text = @"计划名称";
    if (_pDicData != nil) {
        planDaileCustomView.rightLabel.text = _pDicData.beePlan.beePlan.title;
    }
   
    
    return planDaileCustomView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    PlanDetailCustomView *planDaileCustomView = [[NSBundle mainBundle] loadNibNamed:@"PlanDetailCustomView" owner:nil options:nil].lastObject;
    planDaileCustomView.LineView.hidden = YES;
    planDaileCustomView.rightLabel.text = @"查看合同协议";
    if (_pDicData != nil) {
        if (_pDicData.subjectList.count > 0) {
            planDaileCustomView.leftLabel.text = @"查看具体投资项目";
            planDaileCustomView.clickLeftBtn = ^{
                SubPlanListViewController *sVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SubPlanListViewController"];
                sVC.dataArr = _pDicData.subjectList;  //数据数组
                sVC.subPlanListTitle = _pDicData.beePlan.beePlan.title;
                [self.navigationController pushViewController:sVC animated:YES];
            };
        }
        planDaileCustomView.clickRightBtn = ^{
            WebViewController *web_vc = [self.storyboard instantiateViewControllerWithIdentifier:@"WebViewController"];
            [web_vc load_withUrl:_pDicData.beePlan.contractUrl title:@"计划合同协议" canScaling:YES];// isShowCloseItem:YES
            [self go_next:web_vc animated:YES viewController:self];
        };
    }
    
    return planDaileCustomView;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PlanDetailCell *pCell = [PlanDetailCell cellWithTableView:tableView];
    
    pCell.titleLable.text = _titleArr[indexPath.row];
    pCell.valueLabel.text = _valueArr[indexPath.row];
    
    return pCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)getDataWithRequest
{
    [CMCore invest_record_for_plan_with_beePlanId:_dataDic.ID is_alert:YES blockResult:^(NSNumber *code, id result, NSString *message) {
        [_tableView.mj_header  endRefreshing];
        if ([code doubleValue] == 200) {
            _pDicData = [ProductsModel mj_objectWithKeyValues:result];
        }
        [self dealWithData];
        [_tableView reloadData];
    } blockRetry:^(NSInteger index) {
        [_tableView.mj_header  endRefreshing];
        
    }];
}


@end
