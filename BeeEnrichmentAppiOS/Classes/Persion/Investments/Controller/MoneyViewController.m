//
//  MoneyViewController.m
//  BeeEnrichmentAppiOS
//
//  Created by dll on 15/12/24.
//  Copyright © 2015年 didai. All rights reserved.
//

#import "MoneyViewController.h"
#import "ControlView.h"
#import "AllViewController.h"
#import "InvestingViewController.h"
#import "ReceivedViewController.h"
#import "PlanViewController.h"


@interface MoneyViewController ()
@property (nonatomic, strong) UITableView *tableViewOfInvesting, *tableViewOfreceived, *tableViewOfAll;
@end

__weak MoneyViewController *_moneySelf;
@implementation MoneyViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self creatUI];
    if (self.navtitle) {
        self.navigationItem.title = self.navtitle;
    }else {
        self.navigationItem.title = @"投资记录";
    }
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"去投资" style:UIBarButtonItemStylePlain target:self action:@selector(go_invest)];
    
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:FontOfAttributed size:14], NSForegroundColorAttributeName:[UIColor colorWithHex:@"#676767"]} forState:UIControlStateNormal];
    
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor colorWithRed:0.40 green:0.40 blue:0.40 alpha:1.00];
    
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"v1_left_item"] style:UIBarButtonItemStylePlain target:self action:@selector(back_up_stept)];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
}

//- (void)back_up_stept
//{
//    self.tabBarController.selectedIndex = 3;
//    [self.navigationController popViewControllerAnimated:YES];
//}


- (void)creatUI{
    
    if (_type == 4) {
        PlanViewController *planVC = [[PlanViewController alloc] init];
        planVC.enterType = 4;
        InvestingViewController *investingVC = [[InvestingViewController alloc] init];
        ReceivedViewController *receivedVC = [[ReceivedViewController alloc] init];
        AllViewController *allVC = [[AllViewController alloc] init];
        allVC.enterType = 4;
        NSArray *controllers = @[planVC,investingVC,receivedVC,allVC];
        NSArray *titleArray =@[@"优选计划",@"投资中",@"已回款",@"全部"];
        ControlView *cView = [[ControlView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 60) controllers:controllers titleArray:titleArray ParentController:self market_type:_market_type];
        cView.backgroundColor = [UIColor whiteColor];
        
        [self.view addSubview:cView];
    }else {
        PlanViewController *planVC = [[PlanViewController alloc] init];
        AllViewController *allVC = [[AllViewController alloc] init];
        NSArray *controllers=@[planVC, allVC];
        NSArray *titleArray =@[@"优选计划", @"散标记录"];
        ControlView *cView = [[ControlView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 60) controllers:controllers titleArray:titleArray ParentController:self market_type:_market_type];
        cView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:cView];
    }
}

- (void)go_invest
{
    self.tabBarController.selectedIndex = 1;
    [self go_root:YES];
}

@end
