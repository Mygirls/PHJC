//
//  TransferProductViewController.m
//  BeeEnrichmentAppiOS
//
//  Created by dll on 16/12/12.
//  Copyright © 2016年 didai. All rights reserved.
//

#import "TransferProductViewController.h"
#import "DetailSimpleCell.h"
#import "DetailOfSectionView.h"
#import "ASProgressPopUpView.h"
#import "CalculatorView.h"
#import "ProOfHeadView.h"
#import "WebViewController.h"
#import "BeeWebViewBridge.h"
#import "LoginNavigationController.h"//登录／注册

@interface TransferProductViewController ()<UITableViewDataSource, UITableViewDelegate, UIWebViewDelegate, UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIButton *qianggou_button;
@property (weak, nonatomic) IBOutlet UIView *calculatorView;


@property (nonatomic, assign) NSInteger timer_count;
@property (nonatomic, strong) NSTimer* timer_for_code;
@property (nonatomic, strong) NSArray *title_arr, *content_arr;
@property (nonatomic, strong) NSURL *urlStr;
@property (nonatomic, strong) UIWebView *web;
@property (nonatomic, strong) WebViewController *web_vc;
@property (nonatomic, strong) BeeWebViewBridge *webBridge;
@property (nonatomic, assign) float livi_year;
@property (nonatomic, strong) NSNumber *num;
@property (nonatomic, strong) ProOfHeadView *proView;
@property (nonatomic, strong) DetailOfSectionView *secView;
@property (nonatomic, strong) UIView *exchangeView;
@property (nonatomic, strong) UILabel *exchangeLabel;
@property (nonatomic, assign) CGFloat heightOfsection;
@property (nonatomic,strong)UILabel * down;
@end

__weak TransferProductViewController *_tProVCSelf;
@implementation TransferProductViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.down = [[UILabel alloc]initWithFrame:CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width, 0.5)];
    self.down.backgroundColor = [UIColor colorWithHex:@"#e1e1e1"];
    [self.view  addSubview:self.down];
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    [navigationBar setBackgroundImage:[UIImage imageNamed:@"Navigation Image"]
                       forBarPosition:UIBarPositionAny
                           barMetrics:UIBarMetricsDefault];
    [navigationBar setShadowImage:[UIImage new]];
    
    _tProVCSelf = self;
    _heightOfsection =  465;
    [self set_refresh];
    [self setupSomething];
    [self load_product_detail];
}

- (ProductsDetailModel *)productM {
    if (!_productM) {
        _productM = [ProductsDetailModel new];
    }
    return _productM;
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
    if ([CMCore is_login]) {
        [self get_user_info];
        [self load_judge_is_newer];
    }
    NSInteger status = self.productM.status;
    if (status == 100) {
        //倒计时
        [self button_is_enabled];
    }else{
        [self set_button_disabled];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.tabBarController setHidesBottomBarWhenPushed:NO];
}

#pragma mark 下拉刷新
- (void)set_refresh
{
    _tableView.mj_header = [WMRefreshHeader headerWithRefreshingBlock:^{
        [_tProVCSelf load_product_detail];
        if ([CMCore is_login]) {
            [_tProVCSelf load_judge_is_newer];
        }
    }];
}

- (void)setupSomething
{
    self.title = _productM.title;
    
    
    if (self.web == nil) {
        //sectionView设置
        self.secView = [[NSBundle mainBundle] loadNibNamed:@"DetailOfSectionView" owner:nil options:nil].lastObject;
        
        // web创建
        self.web_vc = [self.storyboard instantiateViewControllerWithIdentifier:@"WebViewController"];
        self.web_vc = [self.storyboard instantiateViewControllerWithIdentifier:@"WebViewController"];
        if (_judgeBuy == 999) {
            _calculatorView.translatesAutoresizingMaskIntoConstraints = NO;
            _calculatorView.hidden = YES;
            NSLayoutConstraint *myConstraint;
            myConstraint = [NSLayoutConstraint constraintWithItem:_tableView attribute:NSLayoutAttributeHeight
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:nil attribute:NSLayoutAttributeNotAnAttribute
                                                       multiplier:1.0f constant:kScreenHeight-64];
            [self.view addConstraint:myConstraint];
            self.web = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64  )];
            
        }else{
            
            self.web = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64 -64-44 )];
            
        }
        
        self.web.scrollView.scrollEnabled = NO;
    
    }

    _urlStr = [NSURL URLWithString:[CMCore getH5AddressWithEnterType:H5EnterTypeDetails targeId:_productM.ID markType:_productM.marketType]];
    //tableView设置
    self.proView = [[NSBundle mainBundle] loadNibNamed:@"ProOfHeadView" owner:nil options:nil].firstObject;
    self.tableView.tableHeaderView = self.proView;
    _proView.dic = _productM;
    NSString *jixi = @"";
    NSInteger mark = _productM.marketType;
    NSString *huan_kuan = @"一次性到期，还本付息到账户余额";
    if (mark == 30) {
        jixi = @"满标后计息";
        huan_kuan = @"标的到期一次性还本还息到账户余额";
    }
    

    self.title_arr = @[@"计息方式:", @"还款方式:", @"下次回款:"];
    NSString *recentlyTime = [CMCore turnToDate:_productM.endTime];
    self.content_arr = @[jixi, huan_kuan, recentlyTime];
}

- (void)setMark {
    if (_productM.buyPeopleCount) {
        self.secView.markLabel.hidden = NO;
        self.secView.markLabel.text = [NSString stringWithFormat:@"%zd", _productM.buyPeopleCount];
    }else {
        self.secView.markLabel.hidden = YES;
    }
}

- (DetailOfSectionView *)setHeaderView {
    [self setMark];
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:3];
    _secView.DetailOfSectionViewBlockClick = ^(DetailOfSectionViewType type) {
        switch (type) {
            case DetailOfSectionViewTypeDetail:
                // 标的详情_项目详情
                [_tProVCSelf setMark];
                _urlStr = [NSURL URLWithString:[CMCore getH5AddressWithEnterType:H5EnterTypeDetails targeId:_tProVCSelf.productM.ID markType:_tProVCSelf.productM.marketType]];
                break;
            case DetailOfSectionViewTypeRecord:
                // 标的详情_投资记录
                _urlStr = [NSURL URLWithString:[CMCore getH5AddressWithEnterType:H5EnterTypeRecord targeId:_tProVCSelf.productM.ID markType:_tProVCSelf.productM.marketType]];
                break;
            case DetailOfSectionViewTypeSafe:
                // 标的详情_安全承诺
                [_tProVCSelf setMark];
                _urlStr = [NSURL URLWithString:[CMCore getH5AddressWithEnterType:H5EnterTypeSecurity targeId:_tProVCSelf.productM.ID markType:_tProVCSelf.productM.marketType]];
                break;
            default:
                break;
        }
        [_tProVCSelf.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    };
    return _secView;

}

#pragma mark - tableviewdelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 3) {
        if (_judgeBuy == 999) {
            return kScreenHeight - 64  ;
            
        }else{
            return kScreenHeight - 64.5  - 64 -44;
            
        }
    }
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section != 3) {
        return kSectionFooterHeight;
    }else {
        return 44;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 3) {
        
            return [self setHeaderView];
    }else {
        return nil;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 2) {
        return  10;
    }
    return kSectionFooterHeight;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 3 && indexPath.row == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        
        [_web loadRequest:[NSURLRequest requestWithURL:_urlStr]];
        //        kvo监听 webview的偏移量
        [_web.scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
        
        [cell.contentView addSubview:_web];
        
        _webBridge = [BeeWebViewBridge bridgeForWebView:self.web webViewDelegate:self];
        
        [_webBridge setBlock_bridge_callback:^(NSString *method, NSArray *params) {
            [_tProVCSelf.web_vc bridge_callback_with_method:method params:params];
        }];
        if (_judgeBuy == 999) {
            if (cell.frame.origin.y != 0) {
                _heightOfsection = 474 - 50;//cell.frame.origin.y - 44;
            } else {
                _heightOfsection = 515 - 50;
            }
        }else{
            
            if (cell.frame.origin.y != 0) {
                _heightOfsection = cell.frame.origin.y - 44;
            } else {
                _heightOfsection = 515 - 50;
            }
        }
    
        
        return cell;
    }else {
        DetailSimpleCell * simpleCell = [[NSBundle mainBundle] loadNibNamed:@"DetailSimpleCell" owner:nil options:nil].lastObject;
        
        simpleCell.title.text = _title_arr[indexPath.section];
        simpleCell.content.text = _content_arr[indexPath.section];
        if (indexPath.section == 2) {
            simpleCell.downLine.hidden = YES;
        }
        return simpleCell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{

    if (scrollView.contentOffset.y > 3 ) {
        [UIView animateWithDuration:0.5 animations:^{
            _tableView.contentOffset = CGPointMake(0, _heightOfsection);
        }];
        _web.scrollView.scrollEnabled = YES;
    }
}

// kvo 方法的实现
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"contentOffset"])
    {
        CGFloat y = _web.scrollView.contentOffset.y;
        DLog(@"web == %.2f", y);
        if (y < -3) {
            _web.scrollView.scrollEnabled = NO;
            [UIView animateWithDuration:0.5 animations:^{
                _tableView.contentOffset = CGPointMake(0, 0);
            }];
        }
    }
}

#pragma mark 设置按钮 可用／不可用
- (void)set_button_disabled
{
    _qianggou_button.alpha = 0.5;
    _qianggou_button.enabled = NO;
}

- (void)set_button_enabled
{
    _qianggou_button.alpha = 1.0;
    _qianggou_button.enabled = YES;
}

- (void)button_is_enabled
{
    //登录状态
    //预告100 可购买200 已售完300 计息中400 已兑付500
    if (_productM.currentMoney <= 0) {
        [self set_button_disabled];
        [_qianggou_button setTitle:@"已售完" forState:UIControlStateNormal];
        return;
    }
    NSInteger num = _productM.status;
    NSString *title = @"";
    if (num == 200) {
        title = @"已结束";
        [self set_button_disabled];
    }else
    {
        [self set_button_disabled];
        if (num == 100) {
            [self set_button_enabled];
            title = @"立即抢购";
            //倒计时
//            return;
        }else if (num == 300) {
            title = @"已售完";
        }else if (num == 400) {
            [self set_button_enabled];
            title = @"立即抢购";

//            title = @"计息中" ;
        }else if (num == 500) {
            title = @"已兑付";
        }
    }
    [_qianggou_button setTitle:title forState:UIControlStateNormal];
}

#pragma mark 开始抢购倒计时
- (void)start_timer:(UIButton *)button {
    [self stop_timer:button];
    NSString *start_time_str = [NSString stringWithFormat:@"%@",_productM.beginTime];
    NSDateFormatter *date_formatter = [[NSDateFormatter alloc] init];
    [date_formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *start_date = [date_formatter dateFromString:start_time_str];
    NSTimeInterval interval = [start_date timeIntervalSinceNow];
    _timer_count = [[NSString stringWithFormat:@"%.0Lf",fabsl(interval)] integerValue];
    NSString *str = [NSString stringWithFormat:@"距开抢还剩%d天%d小时%d分钟%d秒", (int)_timer_count / 86400,(int)_timer_count % 86400 / 3600, (int)_timer_count  % 3600 / 60, (int)_timer_count  % 60];
    [button setTitle:str forState:UIControlStateNormal];
    _timer_count -= 1;
    _timer_for_code = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(start_timer:) userInfo:nil repeats:YES];
}

- (void)stop_timer:(UIButton *)button {
    if(_timer_for_code)
    {
        [_timer_for_code invalidate];
        _timer_for_code = nil;
    }
}

- (void)timer_action:(id)sender {
    if(_timer_count > 0)
    {
        NSString *str = [NSString stringWithFormat:@"距开抢还剩%d天%d小时%d分钟%d秒", (int)_timer_count / 86400,(int)_timer_count % 86400 / 3600, (int)_timer_count  % 3600 / 60, (int)_timer_count  % 60];
        _qianggou_button.titleLabel.text = str;
        [_qianggou_button setTitle:str forState:UIControlStateNormal];
    }
    else
    {
        [self stop_timer:_qianggou_button];
        [_qianggou_button setTitle:@"立即抢购" forState:UIControlStateNormal];
        [self set_button_enabled];
        
    }
    _timer_count--;
}

#pragma mark 计算器
- (IBAction)click_jisuan_button:(id)sender {
    // 标详情_计算器
    [MobClick event:transferProduct_computerID];
//    CalculatorView *calculator = [CalculatorView new];
    CalculatorView *calculator =  nil;
    if (_productM.repaymentId == 200) {
        calculator = [[NSBundle mainBundle] loadNibNamed:@"CalculatorView" owner:nil options:nil].firstObject;
    } else{
        calculator = [[NSBundle mainBundle] loadNibNamed:@"CalculatorView" owner:nil options:nil].lastObject;
    }
    calculator.dic = _productM;
    UIWindow *keyWin = [UIApplication sharedApplication].keyWindow;
    [keyWin addSubview:calculator];
}

#pragma mark 抢购
- (IBAction)click_qianggou_button:(id)sender {
    // 标详情_立即购买
    [MobClick event:transferProduct_goBuyID];
    [CMCore check_isLogin_isHavePaypassword_isHaveBankCard_with_vc:self data_dic:_productM alertString:@"为保证资金安全，请绑定银行卡，绑卡时需扣款2元，完成后将全额退还至账户余额" judgeStr:@"transfer"];
}


#pragma mark 网络请求－定期资产详情
- (void)load_product_detail {

    NSInteger marketType = _productM.marketType;
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD showWithStatus:@"努力加载中..."];
    [CMCore get_subject_detail_with_subject_id: _productM.ID market_type:marketType is_alert:YES blockResult:^(NSNumber *code, id result, NSString *message) {
        [_tableView.mj_header  endRefreshing];
        [SVProgressHUD dismiss];
        if (result) {
            _productM = [ProductsDetailModel mj_objectWithKeyValues:result];
            [self setupSomething];
            _proView.dic = _productM;
            [self button_is_enabled];
            [_tableView reloadData];
        }
    } blockRetry:^(NSInteger index) {
        [_tProVCSelf.tableView.mj_header endRefreshing];
        [SVProgressHUD dismiss];
        if (index == 1) {
            [_tableView.mj_header beginRefreshing];
        }
    }];
}

- (void)load_judge_is_newer
{
    [CMCore judge_is_new_client_is_alert:YES blockResult:^(NSNumber *code, id result, NSString *message) {
        if ([code integerValue] == 200) {
            _num = result[@"canBuy"];
            [_tableView reloadData];
        }
    } blockRetry:^(NSInteger index) {
        if (index == 1) {
            [self load_judge_is_newer];
        }
    }];
    
}


#pragma mark 网络请求－获取用户信息
- (void)get_user_info
{
    [CMCore get_user_info_with_is_alert:YES blockResult:^(NSNumber *code, id result, NSString *message) {
        [SVProgressHUD dismiss];
        if ([code integerValue] == 200) {
            //成功获取用户信息
            //保存user_info
            [CMCore save_user_info_with_member:result[@"member"]];

        }
    } blockRetry:^(NSInteger index) {
        [SVProgressHUD dismiss];
        if (index == 1) {
            [self get_user_info];
        }
    }];
}

@end
