//
//  AllViewController.m
//  BeeEnrichmentAppiOS
//
//  Created by dll on 16/11/14.
//  Copyright © 2016年 didai. All rights reserved.
//

#import "AllViewController.h"
#import "MyProductCell.h"
#import "MoneyDetailViewController.h"
#import "NoDataPointView.h"

@interface AllViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic ,strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<BeePlanModel *> *productList, *historyList;
@property (nonatomic, strong) NSMutableArray *productListOld;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) BOOL is_have_more;
@property (nonatomic, strong) NoDataPointView *noDataView;
@property (nonatomic, strong) UIImageView *imageViewCopy;
@property (nonatomic, strong) UIButton *judgeBtn;
@property (nonatomic, strong) UIView *headView;

@end

__weak AllViewController *_allSelf;
@implementation AllViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    _enterType = 0;
    _allSelf = self;
    _page = 1;
        _judgeBtn.selected = NO;
    _productList = [NSMutableArray array];
    _historyList = [NSMutableArray array];
    _productListOld = [NSMutableArray array];

    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(backToPersional)];
    [self setSomething];
    [self setRefresh];
    
}

- (void)backToPersional{
    self.tabBarController.selectedIndex = 3;
    [self go_root:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (![CMCore is_login]) {
        self.tabBarController.selectedIndex = 0;
        [self go_back:YES viewController:self];
        return;
    }
    _page = 1;
    [self load_dingqi_product];
//    [_tableView.mj_header beginRefreshing];
}

- (void)setRefresh {
    _tableView.mj_header = [WMRefreshHeader headerWithRefreshingBlock:^{
        [_allSelf load_refresh];
    }];
//    _tableView.mj_footer = [WMRefreshFooter footerWithRefreshingBlock:^{
//        if (_allSelf.is_have_more) {
//            [_allSelf load_dingqi_product];
//        }else {
//            [_allSelf.tableView.mj_footer endRefreshing];
//            [SVProgressHUD showInfoWithStatus:@"没有更多记录啦"];
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [SVProgressHUD dismiss];
//            });
//        }
//    }];
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
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64 - 44) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor colorWithHex:@"#F1F1F1"];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    _noDataView = [[NSBundle mainBundle] loadNibNamed:@"NoDataPointView" owner:nil options:nil].firstObject;
    _noDataView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64 - 44);
    _noDataView.clickButtonBlock = ^(){
        [_allSelf go_invest];
    };
    // 设置headview
    _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 70)];
    _headView.backgroundColor = [UIColor colorWithHex:@"#f1f1f1"];
    
    UILabel *markLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 140, 14)];
    markLabel.text = @"查看更多已回款散标";
    markLabel.textColor = [UIColor colorWithHex:@"#999999"];
    markLabel.font = [UIFont systemFontOfSize:14];
    markLabel.center = _headView.center;
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 70)];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(_headView.center.x + 68, markLabel.frame.origin.y + 2, 13, 7.5)];
    
    if (_judgeBtn.selected) {
        imageView.image = [UIImage imageNamed:@"v1.7_xuanzejiantou"];
    }else {
        imageView.image = [UIImage imageNamed:@"v1.7_down"];
    }
    
    [btn addTarget:self action:@selector(getExplain) forControlEvents:UIControlEventTouchUpInside];
    btn.selected = NO;
    
    _imageViewCopy = imageView;
    _judgeBtn = btn;
    
    [_headView addSubview:btn];
    [_headView addSubview: imageView];
    [_headView addSubview:markLabel];
}

- (void)go_invest
{
    self.tabBarController.selectedIndex = 1;
    [self go_root:YES];
}

#pragma mark - UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_enterType == 4) {
        return 1;
    }else {
        return 2;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_enterType == 4) {
        return _productListOld.count;
        
    }else {
        if (section == 0) {
            return _productList.count;
        }else {
            if (_judgeBtn.selected) {
                return _historyList.count;
            }else {
                return 0;
            }
        }
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_enterType == 4) {
        if (_productListOld.count > 0 && [_productListOld[indexPath.row][@"status"] integerValue] == 201) {
            return 194;
        }
        return 172;
    }else {
        if (indexPath.section == 0) {
            if (_productList.count > 0 && _productList[indexPath.row].status == 201) {
                return 194;
            }
            return 172;
        }else {
            return 172;
        }
        
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return 70;
    }
    return kSectionFooterHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return kSectionFooterHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return _headView;
    }else {
        return nil;
    }
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_enterType == 4) {
        if ([_productListOld[indexPath.row][@"status"] integerValue] == 201) {
            MyProductCell *myProCell = [[NSBundle mainBundle] loadNibNamed:@"MyProductCell" owner:nil options:nil].firstObject;
            NSDictionary *dic = _productListOld[indexPath.row];
            myProCell.modelOld = dic;
            return myProCell;
        }else {
            MyProductCell *myProCell = [[NSBundle mainBundle] loadNibNamed:@"MyProductCell" owner:nil options:nil].lastObject  ;
            NSDictionary *dic = _productListOld[indexPath.row];
            myProCell.modelOld = dic;
            return myProCell;
        }
    }else {

        if (indexPath.section == 0) {
            if (_productList[indexPath.row].status == 201) {
                MyProductCell *myProCell = [[NSBundle mainBundle] loadNibNamed:@"MyProductCell" owner:nil options:nil].firstObject;
                BeePlanModel *dic = _productList[indexPath.row];
                myProCell.model = dic;
                return myProCell;
            }else {
                MyProductCell *myProCell = [[NSBundle mainBundle] loadNibNamed:@"MyProductCell" owner:nil options:nil].lastObject  ;
                BeePlanModel *dic = _productList[indexPath.row];
                myProCell.model = dic;
                return myProCell;
            }
        }else {
            if (_historyList[indexPath.row].status == 201) {
                MyProductCell *myProCell = [[NSBundle mainBundle] loadNibNamed:@"MyProductCell" owner:nil options:nil].firstObject;
                BeePlanModel *dic = _historyList[indexPath.row];
                myProCell.model = dic;
                return myProCell;
            }else {
                MyProductCell *myProCell = [[NSBundle mainBundle] loadNibNamed:@"MyProductCell" owner:nil options:nil].lastObject  ;
                BeePlanModel *dic = _historyList[indexPath.row];
                myProCell.model = dic;
                return myProCell;
            }
        }

    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    MoneyDetailViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MoneyDetailViewController"];
    if (_enterType == 4) {
        vc.enterType = _enterType;
        vc.data_dic_old = _productListOld[indexPath.row];
    }else {
        if (indexPath.section == 0) {
            vc.data_dic = _productList[indexPath.row];
        }else {
            vc.data_dic = _historyList[indexPath.row];
        }
    }
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)getExplain
{
    
    if (_judgeBtn.selected) {
        _imageViewCopy.image = [UIImage imageNamed:@"v1.7_down"];
        _judgeBtn.selected = NO;
        [_tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
    } else {
        
        _imageViewCopy.image = [UIImage imageNamed:@"v1.7_xuanzejiantou"];
        _judgeBtn.selected = YES;
        [_tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
    }
    
}


#pragma mark 网络请求－定期资产列表
- (void)load_dingqi_product
{
    if (_enterType == 4) {
        [self oldAllData];
    }else {
        [self newAllData];
    }
}

- (void)oldAllData {
    //200成功
    [CMCore invest_record_with_status:0 market_type:20 page:_page count:LOAD_COUNT_MAX is_alert:YES blockResult:^(NSNumber *code, id result, NSString *message) {
        [_tableView.mj_header  endRefreshing];
        [_tableView.mj_footer endRefreshing];
        if (result) {
            NSArray *list = result[@"value"];
            if (list.count > 0) {
                if (list.count < LOAD_COUNT_MAX) {
                    _is_have_more = NO;
                }else {
                    _is_have_more = YES;
                }
                if (_page == 1) {
                    [_productListOld removeAllObjects];
                    [_productListOld addObjectsFromArray:list];
                }else {
                    [_productListOld addObjectsFromArray:list];
                }
                _page ++;
            }else {
                _is_have_more = NO;
            }
        }
        if (_productListOld.count == 0) {
            _tableView.tableFooterView = _noDataView;
        }else
        {
            _tableView.tableFooterView = nil;
        }
        [_tableView reloadData];
    } blockRetry:^(NSInteger index) {
        [_tableView.mj_footer endRefreshing];
        [_tableView.mj_header  endRefreshing];
        if (_productListOld.count == 0) {
            _tableView.tableFooterView = _noDataView;
        }else
        {
            _tableView.tableFooterView = nil;
        }
        [_tableView reloadData];
        if (index == 1) {
            [self oldAllData];
        }
    }];
}

- (void)newAllData {
    //200成功
    [CMCore invest_record_for_plan_with_status:0 market_type:20 page:_page count:LOAD_COUNT_MAX is_alert:YES blockResult:^(NSNumber *code, id result, NSString *message) {
        [_tableView.mj_header  endRefreshing];
        [_tableView.mj_footer endRefreshing];
        //99e929c1113f80054933022578634840
        if (result) {
            NSMutableArray<BeePlanModel *> *list = [BeePlanModel mj_objectArrayWithKeyValuesArray: result[@"ing"]];
            _historyList = [BeePlanModel mj_objectArrayWithKeyValuesArray: result[@"history"]];
            if (list.count > 0) {
                if (list.count < LOAD_COUNT_MAX) {
                    _is_have_more = NO;
                }else {
                    _is_have_more = YES;
                }
                if (_page == 1) {
                    [_productList removeAllObjects];
                    [_productList addObjectsFromArray:list];
                }else {
                    [_productList addObjectsFromArray:list];
                }
//                _page ++;
            }else {
                _is_have_more = NO;
                //                [_tableView hide_footer_refresh:YES];
            }
        }
        if (_productList.count == 0 &&  _historyList.count == 0) {
            _tableView.tableFooterView = _noDataView;
        } else {
            _tableView.tableFooterView = nil;
        }
        [_tableView reloadData];
    } blockRetry:^(NSInteger index) {
        [_tableView.mj_footer endRefreshing];
        [_tableView.mj_header  endRefreshing];
        if (_productList.count == 0) {
            _tableView.tableFooterView = _noDataView;
        }else
        {
            _tableView.tableFooterView = nil;
        }
        [_tableView reloadData];
        if (index == 1) {
            [self newAllData];
        }
    }];
}






@end
