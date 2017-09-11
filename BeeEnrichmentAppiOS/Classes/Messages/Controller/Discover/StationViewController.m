//
//  StationViewController.m
//  BeeEnrichmentAppiOS
//
//  Created by MC on 16/9/21.
//  Copyright © 2016年 didai. All rights reserved.
//

#import "StationViewController.h"
#import "BeeWebViewBridge.h"
#import "WebViewController.h"
#import "StationViewCell.h"
#import "MyPackageViewController.h"//我的礼包
#import "MoneyViewController.h"// 投资记录
#import "MyAccountVersionTwoViewController.h"//个人中心

@interface StationViewController ()<UITableViewDelegate, UITableViewDataSource,UIScrollViewDelegate, UIWebViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (strong, nonatomic)  UIView *noLoginView, *backView;

@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) BOOL isHaveMore;

@end
__weak StationViewController *discoverSelf2;
@implementation StationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    discoverSelf2 = self;
    _page = 1;
    self.view.backgroundColor = [UIColor colorWithHex:@"#f5f5f5"];
    _dataList = [NSMutableArray array];
    [self setTab];
    [self initNoLoginView];
    [self set_refresh];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeBadege) name:@"RCSegmentViewClick" object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([CMCore is_login]) {
        self.noLoginView.hidden = YES;
        [self.view layoutIfNeeded];
        [self set_refresh];
    }else {
        self.noLoginView.hidden = NO;
        [self.view layoutIfNeeded];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}

- (void)setTab {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64 - 45) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor colorWithHex:@"#f5f5f5"];
    [_tableView registerNib:[UINib nibWithNibName:@"StationViewCell" bundle:nil] forCellReuseIdentifier:@"StationViewCell"];
    
    self.tableView.estimatedRowHeight = 100 ;
    self.tableView.rowHeight  =   UITableViewAutomaticDimension ;
    [self.view addSubview:_tableView];
}

#pragma mark 刷新，加载
- (void)set_refresh
{
    if ([CMCore is_login]) {
        __weak typeof(self) weakSelf = self;
        _tableView.mj_header = [WMRefreshHeader headerWithRefreshingBlock:^{
            [self load_refresh];
        }];
        [_tableView.mj_header beginRefreshing];
        _tableView.mj_footer = [WMRefreshFooter footerWithRefreshingBlock:^{
            if (weakSelf.isHaveMore) {
                [weakSelf loadList];
            }else
            {
                [weakSelf.tableView.mj_footer endRefreshing];
                [SVProgressHUD showInfoWithStatus:@"没有更多记录啦"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [SVProgressHUD dismiss];
                });
            }
        }];
    }
}
- (void)load_refresh
{
    _page = 1;
    _isHaveMore = YES;
    [self loadList];
}

#pragma mark 去掉小红点
- (void)removeBadege {
    [self.tabBarController.tabBar hideBadgeOnItemIndex:2];
    [self.segmentView hideBadgeOnBtnIndex:1];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

- (void)initNoLoginView {
    UIButton *btu = [UIButton buttonWithType:UIButtonTypeCustom];
//    [btu setImage:[UIImage imageNamed:@"v1.2_discover_nothing"] forState:UIControlStateNormal];
    [btu setTitleColor:[CMCore basic_red1_color] forState:UIControlStateNormal];
    btu.titleLabel.textAlignment = NSTextAlignmentCenter;
    [btu setTitle:@"先请登录" forState:UIControlStateNormal];
    [btu addTarget:self action:@selector(clickLongBtn:) forControlEvents:UIControlEventTouchUpInside];
    btu.frame = CGRectMake(0, 0, 120, 44);
    btu.center = CGPointMake(kScreenWidth / 2, kScreenHeight / 2 - 60);
    btu.layer.borderColor = [CMCore basic_red1_color].CGColor;
    btu.layer.borderWidth = 1;
    btu.layer.masksToBounds = YES;
    btu.layer.cornerRadius = 3;
    self.noLoginView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    self.noLoginView.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.00];
    [self.noLoginView addSubview:btu];
    [self.view addSubview:self.noLoginView];
}

- (void)clickLongBtn:(UIButton *)btn {
    [self go_login];
}

- (void)go_login {
    LoginNavigationController *login_navc = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginNavigationController"];
    [self presentViewController:login_navc animated:YES completion:nil];
}

#pragma mark 跳转消息详情 ： 投资记录 个人中心 我的礼包
- (void)go_detail:(NSInteger)index url_str:(NSString *)url_str title:(NSString *)title viewController:(UIViewController*)selfview {
    UINavigationController *nav = self.tabBarController.viewControllers[3];
    
    if (index == 0) {// h5
        WebViewController *web_vc = [self.storyboard instantiateViewControllerWithIdentifier:@"WebViewController"];
        [web_vc load_withUrl:url_str title:title canScaling:NO];// isShowCloseItem:YES
        [self go_next:web_vc animated:YES viewController:selfview];
    }else if (index == 1) {//标底id
    }else if (index == 2) {// 文章
    }else if (index == 3) {// 签到
    }else if (index == 4) {//       投资记录
        MoneyViewController *dingqi_vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MoneyViewController"];
        dingqi_vc.navtitle = @"投资记录";
        [nav pushViewController:dingqi_vc animated:YES];
        self.tabBarController.selectedIndex = 3;
        [self.navigationController popToRootViewControllerAnimated:YES];
//        [self go_next:dingqi_vc animated:YES viewController:selfview];
    }else if (index == 5) {//       我的礼包
        MyPackageViewController *vc = [[MyPackageViewController alloc] init];
        vc.type = @"package";
        [self.navigationController popToRootViewControllerAnimated:YES];
        self.tabBarController.selectedIndex = 3;
        [nav pushViewController:vc animated:YES];
    }else if (index == 6) {//       个人中心
        self.tabBarController.selectedIndex = 3;
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else if (index == -1) {// 禁止点击
    }
}

#pragma mark 请求数据
- (void)loadList {
    [CMCore get_stationBee_list_with_page:_page count:LOAD_COUNT_MAX is_alert:YES blockResult:^(NSNumber *code, id result, NSString *message) {
        [_tableView.mj_header  endRefreshing];
        [_tableView.mj_footer endRefreshing];
        [SVProgressHUD dismiss];
        if (result) {
            NSArray<MessagesModel *> *list = [MessagesModel mj_objectArrayWithKeyValuesArray:result];
            if (list.count > 0) {
                if (list.count < LOAD_COUNT_MAX) {
                    _isHaveMore = NO;
                }else {
                    _isHaveMore = YES;
                }
                if (_page == 1) {
                    [_dataList removeAllObjects];
                    [_dataList addObjectsFromArray:list];
                }else {
                    [_dataList addObjectsFromArray:list];
                }
                _page++;
            }else {
                _isHaveMore = NO;
            }
            [_tableView reloadData];
        }
        if (_dataList.count == 0) {
        }
        [_tableView reloadData];
    } blockRetry:^(NSInteger index) {
        [SVProgressHUD dismiss];
        [_tableView.mj_footer endRefreshing];
        [_tableView reloadData];
        if(index == 1){
            [self loadList];
        }
    }];
}

#pragma mark tableView delegate datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    StationViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StationViewCell"];
    cell.model = _dataList[indexPath.section];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    NSString *text = _dataList[indexPath.section].title;

    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setLineSpacing:8.5];
    CGRect rect =  [text boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13 weight:UIFontWeightLight],NSParagraphStyleAttributeName:paragraphStyle} context:nil] ;
    if (rect.size.height > 62.5) {
        return 39 + 1.5 + rect.size.height +23;
    }else{
        
        return 39 + 62.5 + 1.5;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kSectionHeaderHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return kSectionFooterHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [MobClick event:discover_sfBeeSmallStation_infoID];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    StationViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *urlSTr = cell.model.url;
    if (urlSTr == nil) {
        urlSTr = @"";
    }
    [self go_detail:cell.model.entryType  url_str:urlSTr title:cell.model.title viewController:self];
}

@end
