//
//  SubPlanDetailViewController.m
//  BeeEnrichmentAppiOS
//
//  Created by dll on 2017/5/25.
//  Copyright © 2017年 DuLonglong. All rights reserved.
//

#import "SubPlanDetailViewController.h"
#import "PlanDetailCustomView.h"
#import "PlanDetailCell.h"

@interface SubPlanDetailViewController ()
@property (nonatomic, strong) NSArray *titleArr, *valueArr;
@end

@implementation SubPlanDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"具体投资项目详情";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:FontOfAttributed size:17]}];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"去投资" style:UIBarButtonItemStylePlain target:self action:@selector(go_invest)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor colorWithRed:0.40 green:0.40 blue:0.40 alpha:1.00];
    
    [self dealWithData];
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


- (void)dealWithData
{
    ProductsDetailModel *inSubPlanDetailDic = _dataDic.subject;
    NSString *units = @"";
    NSString *expectedAnnualRate = [NSString stringWithFormat:@"%.2f%%",inSubPlanDetailDic.actualAnnualRate] ;
    if (inSubPlanDetailDic.units == 1) {//  内层beePlan
        units = @"天";
    } else {
        units = @"月";
    }
    NSString *timeLimit = [NSString stringWithFormat:@"%ld%@", (long)inSubPlanDetailDic.Period, units];
    NSString *repaymentStyle = [[NSString alloc] init];
    NSInteger repaymentStatus = inSubPlanDetailDic.repaymentId;
    switch (repaymentStatus) {
        case 100:
            repaymentStyle = @"一次性到期还本付息到余额";
            break;
        case 200:
            repaymentStyle = @"等额每月还本息";
            break;
        case 300:
            repaymentStyle = @"每月还息到期还本";
            break;
        default:
            repaymentStyle = @"状态码不匹配";
            break;
    }
    NSString *investMoney = [NSString stringWithFormat:@"%.2f元", floor(_dataDic.totalMoney * 100) / 100];
    NSString *expectedIncome = [NSString stringWithFormat:@"%.2f元", floor(_dataDic.expectedIncome * 100) / 100];

    
    _valueArr = @[expectedAnnualRate, timeLimit, repaymentStyle, investMoney, expectedIncome];
    _titleArr = @[@"预期年化收益", @"项目期限", @"还款方式", @"投资本金", @"预期收益"];
    
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
    planDaileCustomView.leftLabel.text = @"项目名称";
    planDaileCustomView.rightLabel.text = _dataDic.subject.title;
    
    return planDaileCustomView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    PlanDetailCustomView *planDaileCustomView = [[NSBundle mainBundle] loadNibNamed:@"PlanDetailCustomView" owner:nil options:nil].lastObject;
    planDaileCustomView.LineView.hidden = YES;
    planDaileCustomView.leftLabel.text = @"";
    planDaileCustomView.rightLabel.text = @"查看合同协议";
    planDaileCustomView.clickRightBtn = ^{
        WebViewController *web_vc = [self.storyboard instantiateViewControllerWithIdentifier:@"WebViewController"];
        [web_vc load_withUrl:_dataDic.contractUrl title:@"" canScaling:NO];// isShowCloseItem:YES
        [self go_next:web_vc animated:YES viewController:self];
    };
    
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
    NSLog(@"%ld -- %ld", indexPath.section, indexPath.row);
}





@end
