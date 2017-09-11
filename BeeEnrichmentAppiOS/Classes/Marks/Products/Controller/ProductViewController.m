//
//  ProductViewController.m
//  BeeEnrichmentAppiOS
//
//  Created by dll on 15/12/22.
//  Copyright © 2015年 didai. All rights reserved.
//

#import "ProductViewController.h"

#import "DetailSimpleCell.h"
#import "DetailOfSectionView.h"
#import "ASProgressPopUpView.h"
#import "CalculatorView.h"
#import "ProOfHeadView.h"
#import "WebViewController.h"
#import "BeeWebViewBridge.h"
#import "LoginNavigationController.h"//登录／注册

#import "PHColorConfigure.h"

@interface ProductViewController ()<UITableViewDataSource, UITableViewDelegate, UIWebViewDelegate, UITextFieldDelegate>
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIButton *qianggou_button;
@property (weak, nonatomic) IBOutlet UIView *calculatorView;
@property (nonatomic, assign) NSInteger timer_count;
@property (nonatomic, strong) NSTimer* timer_for_code;
@property (nonatomic, strong) NSArray *title_arr, *content_arr;
@property (nonatomic, strong) NSString *urlStr;
@property (nonatomic, strong) UIWebView *web;
@property (nonatomic, strong) WebViewController *web_vc;
@property (nonatomic, strong) BeeWebViewBridge *webBridge;
@property (nonatomic, assign) float livi_year;
@property (nonatomic, assign) NSInteger num;
@property (nonatomic, strong) ProOfHeadView *proView;
@property (nonatomic, strong) DetailOfSectionView *secView;
@property (nonatomic, strong) UIView *exchangeView;
@property (nonatomic, strong) UILabel *exchangeLabel, *down;
@property (nonatomic, assign) CGFloat heightOfsection;

@property(nonatomic,strong)UIButton *backNavBtn;
@property(nonatomic,strong)UIButton *calculatorBtn;
@property(nonatomic,strong)UILabel *navTitleLabel;
@property(nonatomic,strong)UIImageView *investBtnBgView;
@property(nonatomic,strong)UIView *sepLineView;

@end

__weak ProductViewController *_proVCSelf;
@implementation ProductViewController

- (UIView *)sepLineView
{
    if (_sepLineView == nil) {
        _sepLineView = [[UIView alloc] initWithFrame:CGRectMake(0, PHScreenHeight  - 70, PHScreenWidth, 0.5)];
        _sepLineView.backgroundColor = PHDefalutBlack_color;
        _sepLineView.alpha = 0.15;
    }
    return _sepLineView;

}

- (UIImageView *)investBtnBgView
{
    if (_investBtnBgView == nil) {
        _investBtnBgView = [[UIImageView alloc] initWithFrame: CGRectZero];

    }
    return _investBtnBgView;
}

- (UILabel *)navTitleLabel
{
    if (_navTitleLabel == nil) {
        _navTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        _navTitleLabel.backgroundColor = [UIColor clearColor];
        _navTitleLabel.textAlignment = NSTextAlignmentCenter;
        _navTitleLabel.textColor = [UIColor whiteColor];
    }

    return _navTitleLabel;
}


- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
    }
    return _tableView;
}

- (UIButton *)backNavBtn
{
    if (_backNavBtn == nil) {
        _backNavBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 20, 40, 44)];
        _backNavBtn.backgroundColor = [UIColor clearColor];
        [_backNavBtn setImage:[UIImage imageNamed:@"back_button"] forState:UIControlStateNormal];
        [_backNavBtn addTarget:self action:@selector(backNavAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _backNavBtn;
}

- (void)backNavAction:(UIButton *)backItem {
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIButton *)calculatorBtn
{
    if (_calculatorBtn == nil) {
        _calculatorBtn = [[UIButton alloc]initWithFrame:CGRectMake(PHScreenWidth - 75, 20, 75, 44)];
        _calculatorBtn.backgroundColor = [UIColor clearColor];
        [_calculatorBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_calculatorBtn setTitle:@"计算器" forState:UIControlStateNormal];
        _calculatorBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_calculatorBtn addTarget:self action:@selector(calAction:) forControlEvents:UIControlEventTouchUpInside];

    }
    
    return _calculatorBtn;
}

- (void)calAction:(UIButton *)calItem {
    if (_enterType == 1) {
        [MobClick event:financeProduct_computerID];
    }
    CalculatorView *calculator = nil;
    if (_data_dic.repaymentId == 200) {
        calculator = [[NSBundle mainBundle] loadNibNamed:@"CalculatorView" owner:nil options:nil].firstObject;
    } else{
        calculator = [[NSBundle mainBundle] loadNibNamed:@"CalculatorView" owner:nil options:nil].lastObject;
    }
    calculator.dic = _data_dic;
    UIWindow *keyWin = [UIApplication sharedApplication].keyWindow;
    [keyWin addSubview:calculator];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setUpViews];
    
    _proVCSelf = self;
    _heightOfsection = 430;

    [self set_refresh];
    [self setupSomething];
    _num = 0;

}

- (void)setUpViews
{
    UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, PHScreenWidth, 64)];
    v.backgroundColor = PHDefalutRed_color;
    [self.view addSubview:v];
    
    [v addSubview:self.navTitleLabel];
    self.navTitleLabel.frame = CGRectMake(50, 20, PHScreenWidth- 75 - 40, 44);
    [v addSubview:self.backNavBtn];
    [v addSubview:self.calculatorBtn];
    
    [self.view insertSubview:self.tableView belowSubview:_calculatorView];
    
    [self.calculatorView insertSubview:self.investBtnBgView belowSubview:_qianggou_button];
    self.investBtnBgView.frame = CGRectMake(16, 12, PHScreenWidth - 32, 62);
    [self.view addSubview:self.sepLineView];
    
    _tableView.frame = CGRectMake(0, 64, PHScreenWidth, PHScreenHeight - 64);
    
    _qianggou_button.layer.masksToBounds = YES;
    _qianggou_button.layer.cornerRadius = 23;

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self.navigationController setNavigationBarHidden:YES animated:YES];

    if ([CMCore is_login]) {
        [self get_user_info];
        [self load_judge_isNewer];
    }
    NSInteger status = _data_dic.status;
    if (status == 200) {
        [self button_is_enabled];
    }else{
        [self set_button_disabled];
    }
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.tabBarController setHidesBottomBarWhenPushed:NO];
    [self.navigationController setNavigationBarHidden:NO animated:YES];

}

- (void)setMark {
    if (_data_dic.buyPeopleCount) {
        self.secView.markLabel.hidden = NO;
        self.secView.markLabel.text = [NSString stringWithFormat:@"%zd", _data_dic.buyPeopleCount];
    }else {
        self.secView.markLabel.hidden = YES;
    }
}

#pragma mark H5设置
- (DetailOfSectionView *)setHeaderView {
    [self setMark];
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:4];
    __weak typeof(self) weakSelf = self;
    _secView.DetailOfSectionViewBlockClick = ^(DetailOfSectionViewType type) {
        switch (type) {
                // 标的详情_项目详情
            case DetailOfSectionViewTypeDetail: {
            
                [_proVCSelf setMark];
                _urlStr = [CMCore getH5AddressWithEnterType:H5EnterTypeDetails targeId:weakSelf.data_dic.ID markType:weakSelf.data_dic.marketType];
                
                //TODO: 拼接
                NSString *paramString = [weakSelf paramsString];
                _urlStr = [NSString stringWithFormat:@"%@&%@",_urlStr,paramString];

                break;

            }
                 break;
                
            case DetailOfSectionViewTypeRecord:     // 标的详情_投资记录
                
                _urlStr = [CMCore getH5AddressWithEnterType:H5EnterTypeRecord targeId:weakSelf.data_dic.ID markType:weakSelf.data_dic.marketType];
                break;
                
            case DetailOfSectionViewTypeSafe:   // 标的详情_安全承诺
                
                [_proVCSelf setMark];
                _urlStr = [CMCore getH5AddressWithEnterType:H5EnterTypeSecurity targeId:weakSelf.data_dic.ID markType:weakSelf.data_dic.marketType];
                break;
                
            default:
                break;
        }
        
        [_proVCSelf.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    };
    return _secView;
}

/**
 mobile_phone //手机号码
 access_token  //密钥
 memberId //用户ID
 beePlanId //标的ID
 
 */
- (NSString *)paramsString {
    
    //   https://www.phjucai.com/web/bee/BeePlan/index.html?target_id=122&access_token=d3d62694-7375-4d2f-ab82-0ff832542534&mobile_phone=17620435351&memberId=27868
    NSDictionary * memberParam = [CMCore get_user_info_member];
    NSString *access_token = [CMCore get_access_token];
    NSString *mobile_phone = [memberParam objectForKey:@"mobilePhone"];
    NSDictionary *accountCash = [memberParam objectForKey:@"accountCash"];
    NSString *memberId = [accountCash objectForKey:@"memberId"];

    NSDictionary *params = @{@"access_token": access_token,@"mobile_phone": mobile_phone,@"memberId": memberId };
    
    NSMutableString *paramsString = [NSMutableString string];
    NSArray *allKeys = params.allKeys;
    
    for (int i=0; i<params.count; i++) {
        NSString *key = allKeys[i];
        NSString *value = params[key];
        
        [paramsString appendFormat:@"%@=%@",key,value];
        
        if (i < params.count-1) {
            [paramsString appendString:@"&"];
        }
    }
    
    return [paramsString copy];
}

#pragma mark 下拉刷新
- (void)set_refresh
{
    _tableView.mj_header = [WMRefreshHeader headerWithRefreshingBlock:^{
        _proVCSelf = self;
        [_proVCSelf load_product_detail];
        if ([CMCore is_login]) {
            [_proVCSelf load_judge_isNewer];
            [_proVCSelf judgeForNewer];
        }
    }];
    
}

- (void)setupSomething
{
    self.title = _data_dic.title;
    self.navTitleLabel.text = _data_dic.title;
    //sectionView设置
    // web创建
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
    _urlStr = [CMCore getH5AddressWithEnterType:H5EnterTypeDetails targeId:self.data_dic.ID markType:self.data_dic.marketType];
    NSString *paramString = [self paramsString];
    _urlStr = [NSString stringWithFormat:@"%@&%@",_urlStr,paramString];

    
    _webBridge = [BeeWebViewBridge bridgeForWebView:self.web webViewDelegate:self];
    [_webBridge setBlock_bridge_callback:^(NSString *method, NSArray *params) {
        [_proVCSelf.web_vc bridge_callback_with_method:method params:params];
    }];
    //tableView设置
    self.proView = [[NSBundle mainBundle] loadNibNamed:@"ProOfHeadView" owner:nil options:nil].lastObject;
    self.tableView.tableHeaderView = self.proView;
    _proView.dic = _data_dic;
    NSString *jixi = @"";
    NSInteger mark = _data_dic.marketType;
    NSString *huan_kuan = @"一次性到期，还本付息到账户余额";
    if (_data_dic.bearingTheWay == 100) {
        jixi = @"满标后次日计息";
    } else if (self.data_dic.bearingTheWay == 300){
        jixi = @"满标后计息";
    } else {
        jixi = @"满标后次日计息"; // 默认
    }
    NSInteger repayment = self.data_dic.repaymentId;
    if (repayment == 100) { //一次性还本还息到账户余额
        if (mark == 10) {
            huan_kuan = @"计划到期一次性还本还息到账户余额";
        } else {
            huan_kuan = @"标的到期一次性还本还息到账户余额";
        }
    } else if (repayment == 200) { // 等额本息
        huan_kuan = [NSString stringWithFormat:@"(%zd期)每月等额本息还款", _data_dic.Period];
    } else if (repayment == 300) {
        huan_kuan = @"每月还息到期还本";
    } else {
        //默认
        huan_kuan = @"每月还息到期还本";
    }
    self.title_arr = @[@"计息方式:", @"还款方式:", @"到期时间"];
    //self.content_arr = @[jixi, huan_kuan, _data_dic.finishTime];
    
    //TODO: - 修改的地方
    self.content_arr = @[jixi, huan_kuan, @"到期时间等接口部署好，用上面的方法替代"];
}

- (void)judgeForNewer
{
    if (_data_dic.remainingAmount <= 0) {
         [self set_button_disabled];
        [_qianggou_button setTitle:@"已售完" forState:UIControlStateNormal];
        return;
    }
    if (_data_dic.marketType == 10) {
        if (_data_dic.isNewer && !_num) {
            [self set_button_disabled];
            [_qianggou_button setTitle:@"仅限新手投资" forState:UIControlStateNormal];
        }
    }else {
        if (_data_dic.subjectType == 100 && !_num) {
            [self set_button_disabled];
            [_qianggou_button setTitle:@"仅限新手投资" forState:UIControlStateNormal];
        }
    }
    
    if ([_flagOfHistory[0] isEqualToString:@"true"]) {
        [self set_button_disabled];
        if (_data_dic.marketType == 10) {
            [_qianggou_button setTitle:@"已售完" forState:UIControlStateNormal];
        } else {
            [_qianggou_button setTitle:_flagOfHistory[1] forState:UIControlStateNormal];
        }
    }
}


#pragma mark - tableviewdelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 4) {
        if (_judgeBuy == 999) {
            return kScreenHeight;
            
        }else{
            return kScreenHeight - 64 - 44;
        }
    }else if (indexPath.section == 3){
        return 68;
    }else{
        return 128;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section != 4) {
        return kSectionFooterHeight;
    }else if (section == 2){
        return kSectionFooterHeight;
    }else {
        return 44;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 4) {
        return [self setHeaderView];
    }else {
        return nil;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0 || section == 1) {
        return 4;
    }else {
        return 0;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 4 && indexPath.row == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        
        [_web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_urlStr]]];
        //        kvo监听 webview的偏移量
        [_web.scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
        
        [cell.contentView addSubview:_web];
        
        
        if (_judgeBuy == 999) {
            if (cell.frame.origin.y != 0) {
                _heightOfsection = cell.frame.origin.y - 64;
            } else {
                _heightOfsection = 732;
            }
        }else{
            
            if (cell.frame.origin.y != 0) {
                _heightOfsection = cell.frame.origin.y - 64;
            } else {
                _heightOfsection = 732;
            }
        }
        
        
        return cell;
    }else if (indexPath.section == 3){
        NSString *str = [NSString stringWithFormat:@"%ld%ld%ld",(long)indexPath.section,(long)indexPath.row, (long)arc4random() % 1000];
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
        }
        cell.backgroundColor = [UIColor colorWithHex:@"#f3f7fa"];
        UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 68)];
        lable.text = @"—— 上拉查看项目详情 ——";
        lable.textAlignment = NSTextAlignmentCenter;
        lable.font = [UIFont systemFontOfSize:14];
        lable.textColor = [UIColor colorWithHex:@"#cbcfd0"];
        [cell.contentView addSubview:lable];
        return cell;
    }else {
        DetailSimpleCell * simpleCell = [[NSBundle mainBundle] loadNibNamed:@"DetailSimpleCell" owner:nil options:nil].lastObject;
        
        simpleCell.title.text = _title_arr[indexPath.section];
        simpleCell.content.text = _content_arr[indexPath.section];
        return simpleCell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    DLog(@"%.2f", scrollView.contentOffset.y);
    if (scrollView.contentOffset.y > 462  ) {
        
        [UIView animateWithDuration:0.5 animations:^{
            _tableView.contentOffset = CGPointMake(0, 792);
        }];
        _web.scrollView.scrollEnabled = YES;
    }
}

// kvo 方法的实现
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    if ([keyPath isEqualToString:@"contentOffset"]){
        CGFloat y = _web.scrollView.contentOffset.y;
        NSLog(@"%f ----------",y);
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
    [self.investBtnBgView setImage:[UIImage imageNamed:@"investGrayBgViewImg"]];

}

- (void)set_button_enabled
{
    _qianggou_button.alpha = 1.0;
    _qianggou_button.enabled = YES;
    [self.investBtnBgView setImage:[UIImage imageNamed:@"investRedBgViewImg"]];

}

- (void)button_is_enabled
{
    //登录状态
    //预告100 可购买200 已售完300 计息中400 已兑付500
    NSInteger num = _data_dic.status;
    NSString *title = @"";
    if (num == 200) {
        [self set_button_enabled];
        title = @"立即抢购";
    }else {
        if (num == 100) {
            [self start_timer:_qianggou_button];
            return;
            //倒计时
        }else if (num == 300) {
            title = @"已售完";
        }else if (num == 400) {
            title = @"计息中" ;
        }else if (num == 500) {
            title = @"已兑付";
        }
    }
    [_qianggou_button setTitle:title forState:UIControlStateNormal];
}

#pragma mark 开始抢购倒计时
- (void)start_timer:(UIButton *)button {
    [self stop_timer:button];
    NSString *start_time_str = [NSString stringWithFormat:@"%@",_data_dic.beginTime];
//    NSDateFormatter *date_formatter = [[NSDateFormatter alloc] init];
//    [date_formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
//    NSDate *start_date = [date_formatter dateFromString:start_time_str];
//    NSTimeInterval interval = [start_date timeIntervalSinceNow];
    NSTimeInterval value = [start_time_str doubleValue] / 1000.0;
    NSTimeInterval endValue = [[NSDate date] timeIntervalSince1970];
    _timer_count = [[NSString stringWithFormat:@"%.0Lf",fabsl(value - endValue)] integerValue];
    NSString *str = [NSString stringWithFormat:@"距开抢还剩%d天%d小时%d分钟%d秒", (int)_timer_count / 86400,(int)_timer_count % 86400 / 3600, (int)_timer_count  % 3600 / 60, (int)_timer_count  % 60];
    [button setTitle:str forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    _timer_count -= 1;
    _timer_for_code = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(timer_action:) userInfo:nil repeats:YES];
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
        NSString *str = [NSString stringWithFormat:@"距开抢剩%d天%d小时%d分钟%d秒", (int)_timer_count / 86400,(int)_timer_count % 86400 / 3600, (int)_timer_count  % 3600 / 60, (int)_timer_count  % 60];
        _qianggou_button.titleLabel.text = str;
        [_qianggou_button setTitle:str forState:UIControlStateNormal];
        _qianggou_button.titleLabel.font = [UIFont systemFontOfSize:15];
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
    if (_enterType == 1) {
        [MobClick event:financeProduct_computerID];
    }
    CalculatorView *calculator = nil;
    if (_data_dic.repaymentId == 200) {
        calculator = [[NSBundle mainBundle] loadNibNamed:@"CalculatorView" owner:nil options:nil].firstObject;
    } else{
        calculator = [[NSBundle mainBundle] loadNibNamed:@"CalculatorView" owner:nil options:nil].lastObject;
    }
    calculator.dic = _data_dic;
    UIWindow *keyWin = [UIApplication sharedApplication].keyWindow;
    [keyWin addSubview:calculator];
}

#pragma mark 抢购
- (IBAction)click_qianggou_button:(id)sender {
    // 标详情_立即购买
    if (_enterType == 0) {
        [MobClick event:beePlan_goBuyID];
    }else if (_enterType == 1) {
        [MobClick event:financeProduct_goBuyID];
    }
    // 判断VIP，svip是否可买
    NSString *level = [CMCore get_user_info_member][@"memberVipEntity"][@"level"];
    if ([level doubleValue] == 300) {// vip
        if (_data_dic.subjectType == 800) {
            [[JPAlert current] showAlertWithTitle:@"不可购买高等级的标的哦" button:@[@"确定"]];
            return;
        }
    } else if ([level doubleValue] == 200) {// 普通会员
        if (_data_dic.subjectType == 800 || _data_dic.subjectType == 700) {
            [[JPAlert current] showAlertWithTitle:@"不可购买高等级的标的哦" button:@[@"确定"]];
            return;
        }
    }
    [CMCore check_isLogin_isHavePaypassword_isHaveBankCard_with_vc:self data_dic:_data_dic alertString:@"为保证资金安全，请绑定银行卡，绑卡时需扣款2元，完成后将全额退还至账户余额" judgeStr:@"normal"];
}


#pragma mark 网络请求－定期资产详情
- (void)load_product_detail {
    NSInteger marketType = _data_dic.marketType;
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD showWithStatus:@"努力加载中..."];
    [CMCore get_subject_detail_with_subject_id:_data_dic.ID market_type:marketType is_alert:YES blockResult:^(NSNumber *code, id result, NSString *message) {
        [_tableView.mj_header  endRefreshing];
        [SVProgressHUD dismiss];
        if (result) {
            _data_dic = [ProductsDetailModel mj_objectWithKeyValues:result];
            [self setupSomething];
            _proView.dic = _data_dic;
            [self button_is_enabled];
            [_tableView reloadData];
        }
    } blockRetry:^(NSInteger index) {
        [_proVCSelf.tableView.mj_header endRefreshing];
        [SVProgressHUD dismiss];
        if (index == 1) {
            [_tableView.mj_header endRefreshing];
        }
    }];
}

- (void)load_judge_isNewer
{
    [CMCore judge_is_new_client_is_alert:YES blockResult:^(NSNumber *code, id result, NSString *message) {
        if ([code integerValue] == 200) {
            _num = [result[@"canBuy"] integerValue];
            [self judgeForNewer];
            [_tableView reloadData];
        }
    } blockRetry:^(NSInteger index) {
        if (index == 1) {
            [self load_judge_isNewer];
        }
    }];
}

- (void) dealloc
{
    if(_web){
        [_web stopLoading];
        _web.delegate = nil;
    }
}

#pragma mark 网络请求－获取用户信息
- (void)get_user_info
{
    [CMCore get_user_info_with_is_alert:YES blockResult:^(NSNumber *code, id result, NSString *message) {
        [SVProgressHUD dismiss];
        if ([code integerValue] == 200) {
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
