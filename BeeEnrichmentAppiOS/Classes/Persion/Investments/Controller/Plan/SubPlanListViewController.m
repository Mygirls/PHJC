//
//  SubPlanListViewController.m
//  BeeEnrichmentAppiOS
//
//  Created by dll on 2017/5/25.
//  Copyright © 2017年 DuLonglong. All rights reserved.
//

#import "SubPlanListViewController.h"
#import "SubPlanListCell.h"
#import "SubPlanDetailViewController.h"
#import "PlanDetailCustomView.h"

@interface SubPlanListViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation SubPlanListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"具体投资项目";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:FontOfAttributed size:17]}];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 65;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return kSectionFooterHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    PlanDetailCustomView *planDaileCustomView = [[NSBundle mainBundle] loadNibNamed:@"PlanDetailCustomView" owner:nil options:nil].lastObject;
    planDaileCustomView.leftLabel.text = _subPlanListTitle;
    
    return planDaileCustomView;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SubPlanListCell *sCell = [SubPlanListCell cellWithTableView:tableView];
    
    sCell.subjectTitleLable.text = _dataArr[indexPath.row].subject.title;
    [sCell.checkDetailBtn addTarget:self action:@selector(jumpToDetail:) forControlEvents:UIControlEventTouchUpInside];
    
    return sCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld -- %ld", indexPath.section, indexPath.row);
    
    [self jumpToDetail:_dataArr[indexPath.row]];
}

- (void)jumpToDetail:(BeePlanModel *)dic
{
    SubPlanDetailViewController *sVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SubPlanDetailViewController"];
    sVC.dataDic = dic; //数据dic
    [self.navigationController pushViewController:sVC animated:YES];
}

@end
