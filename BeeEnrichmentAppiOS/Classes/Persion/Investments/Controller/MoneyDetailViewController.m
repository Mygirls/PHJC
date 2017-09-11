//
//  MoneyDetailViewController.m
//  BeeEnrichmentAppiOS
//
//  Created by dll on 15/12/28.
//  Copyright © 2015年 didai. All rights reserved.
//

#import "MoneyDetailViewController.h"

#import "DetailSimpleCell.h"
#import "RecordHeadView.h"
#import "MoneyDetailOfSection.h"
#import "SupermarketViewController.h"
#import "ExperienceMoneyView.h"
#import "WebViewController.h"
#import "BeeWebViewBridge.h"

#import "ProductViewController.h"//产品

@interface MoneyDetailViewController ()<UITableViewDataSource, UITableViewDelegate, UIWebViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UILabel *statusLabel;
@property (nonatomic, strong) NSArray *cell_title_ary, *cell_detail_ary;
@property (nonatomic, strong) NSString *urlStr, *experienceTitle, *experienceMoney;
@property (nonatomic, strong) UIWebView *web;
@property (nonatomic, assign) CGFloat backMoney, tbOffSet;
@property (nonatomic, strong) ProductsDetailModel *planDataDic;
@property (nonatomic, strong) NSMutableDictionary *planDataDicOld;
@property (nonatomic, strong) WebViewController *web_vc;
@property (nonatomic, strong) BeeWebViewBridge *webBridge;
@property (nonatomic, strong) MoneyDetailOfSection *secView;

@end
__weak MoneyDetailViewController *_mDetailSelf;
@implementation MoneyDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _mDetailSelf = self;
    if (_enterType == 4) {
        _planDataDicOld = [NSMutableDictionary dictionary];
        [self setOldSomething];
    }else {
        _planDataDic = [ProductsDetailModel new];
        [self setSomething];
    }
    //kvo监听 webview的偏移量
    [_web.scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}

- (BeePlanModel *)data_dic {
    if (!_data_dic) {
        _data_dic = [BeePlanModel new];
    }
    return _data_dic;
}

- (void)dealloc
{
    [_web.scrollView removeObserver:self forKeyPath:@"contentOffset"];
}


#pragma mark 老数据
- (void)setOldSomething {
    if ([_data_dic_old.allKeys containsObject:@"bee_plan"]) {
        _planDataDicOld = _data_dic_old[@"bee_plan"];
    }else {
        _planDataDicOld = _data_dic_old[@"subject"];
    }
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"去投资" style:UIBarButtonItemStylePlain target:self action:@selector(go_invest)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor colorWithHex:@"#676767"];
    self.navigationItem.title = _planDataDicOld[@"title"];
    // web创建
    self.web_vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"WebViewController"];
    _web = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64 - 49 - 44)];
    _urlStr = _planDataDicOld[@"product_description_url"];
    _web.scrollView.scrollEnabled = NO;
    _webBridge = [BeeWebViewBridge bridgeForWebView:self.web webViewDelegate:self];
    
    [_webBridge setBlock_bridge_callback:^(NSString *method, NSArray *params) {
        [_mDetailSelf.web_vc bridge_callback_with_method:method params:params];
    }];
    RecordHeadView *recView = [[NSBundle mainBundle] loadNibNamed:@"RecordHeadView" owner:nil options:nil].lastObject;
    _tableView.tableHeaderView = recView;
    recView.dicOld = _data_dic_old;
    
    // 利息=实际订单利率(百分比)/365*体验金体验期限*体验金金额
    NSString *experienceDay;
    CGFloat lilv;
    experienceDay = _data_dic_old[@"coupon"][@"condition"][@"max_buy_days"];
    if ([_planDataDicOld[@"add_annual_rate"] doubleValue] > 0) {
        lilv = [_planDataDicOld[@"add_annual_rate"] doubleValue] +[_planDataDicOld[@"expected_annual_rate"] doubleValue];
    }else {
        lilv = [_planDataDicOld[@"expected_annual_rate"] doubleValue];
    }
    _experienceMoney = [NSString stringWithFormat:@"%.2f", lilv / 100 / 365 * [experienceDay doubleValue] * [_data_dic_old[@"coupon"][@"value"] doubleValue]];
    //每月还本金和利息=投资总金额／期数+月利息
    //月利息计算公式（按月）：月利息=本金*综合年化收益率*（1+期数）/（期数*24）
    _backMoney = [_data_dic_old[@"total_money"] doubleValue] * lilv / 100 * (1 + [_planDataDicOld[@"month_limit"] doubleValue]) / ([_planDataDicOld[@"month_limit"] doubleValue] * 24)  + ([_data_dic_old[@"total_money"] doubleValue] / [_planDataDicOld[@"month_limit"] doubleValue]);
    NSInteger repayment = [_planDataDicOld[@"repayment"] integerValue];
    NSString *huan_kuan = @"";
    NSString *detail = @"查看详情";
    if ([_planDataDicOld[@"month_limit"] integerValue]) {
        huan_kuan = [NSString stringWithFormat:@"(共%@期)每月等额本息还款%.2f元", _planDataDicOld[@"month_limit"], _backMoney];
    }else {
        if (repayment == 100) {
            
            huan_kuan = @"一次性到期还本付息到账户余额";
            
        }else if (repayment == 200)
        {
            huan_kuan = @"每月还息到期还本";
        }else if (repayment == 300)
        {
            huan_kuan = @"等额每月还本息";
        }
    }
    // 使用了0.5%加息券一张   使用了5元红包抵扣金额
    if (!_data_dic_old[@"coupon"][@"condition"] || _data_dic_old[@"coupon"] == nil) {
        _experienceTitle = @"";
        detail = @"";
    }else {
        NSString *str = [NSString stringWithFormat:@"%.1f", [_data_dic_old[@"coupon"][@"value"] doubleValue]];
        if ([_data_dic_old[@"coupon"][@"type"] intValue] == 40) { // == 20 抵扣券 == 40 体验金
            _experienceTitle = [NSString stringWithFormat:@"体验金%@天收益%@元：", experienceDay, _experienceMoney];
            detail = @"查看详情";
        }else if ([_data_dic_old[@"coupon"][@"type"] intValue] == 10) {// 加息券
            _experienceTitle = [NSString stringWithFormat:@"使用了%@%%加息券一张", str];
            _experienceMoney = str;
            detail = @"";
        }else if ([_data_dic_old[@"coupon"][@"type"] intValue] == 30){//  == 30 红包
            _experienceTitle = [NSString stringWithFormat:@"使用了%@元红包抵扣金额", str];
            _experienceMoney = str;
            detail = @"";
        }else if ([_data_dic_old[@"coupon"][@"type"] intValue] == 20){
            _experienceTitle = @"使用了一张抵扣券";
            _experienceMoney = @"";
        }else {
            _experienceTitle = @"";
            detail = @"";
        }
    }
    _cell_title_ary = @[@"兑换截止日期：", @"还款方式：", _experienceTitle];
    if ([_data_dic_old.allKeys containsObject:@"bee_plan"]) {
        _cell_detail_ary = @[[_data_dic_old[@"regular_end_time"] length] > 6?_data_dic_old[@"regular_end_time"]:@"募集中", huan_kuan, detail];
    }else {
        _cell_detail_ary = @[[_planDataDicOld[@"end_time"] length] > 6?_planDataDicOld[@"end_time"]:@"募集中", huan_kuan, detail];
    }
    
    NSInteger status = [_planDataDicOld[@"status"] integerValue];
    //预告100(此处不会出现) 可购买200 已售完300 计息中400 已兑付500
    if (status == 200) {
        if ([_data_dic_old.allKeys containsObject:@"bee_plan"]) {
            _statusLabel.text = @"投资中";
            _statusLabel.textColor = [UIColor colorWithHex:@"#4ab1fa"];
        }else {
            _statusLabel.text = @"募集中";
            _statusLabel.textColor = [UIColor colorWithHex:@"#f95f53"];
        }
    }else if (status == 300)
    {
        if ([_data_dic_old.allKeys containsObject:@"bee_plan"]) {
            _statusLabel.text = @"已回款";
            _statusLabel.textColor = [UIColor colorWithHex:@"#444444"];
        }else {
            _statusLabel.text = @"已售完";
        }
    }else if (status == 400)
    {
        _statusLabel.text = @"计息中";
        _statusLabel.textColor = [UIColor colorWithHex:@"#ffb54c"];
    }else if (status == 500)
    {
        _statusLabel.text = @"已回款";
        _statusLabel.textColor = [UIColor colorWithHex:@"#444444"];
    }
    
    if (!_data_dic_old[@"coupon"][@"condition"] || _data_dic_old[@"coupon"] == nil) {
        _tbOffSet = 355;
    }else {
        _tbOffSet = 400;
    }
}
// -----------新站---
- (void)setSomething
{
    if (_data_dic.beePlan.title != nil) {
        _planDataDic = _data_dic.beePlan;
    }else {
        _planDataDic = _data_dic.subject;
    }
    self.title = _planDataDic.title;

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"去投资" style:UIBarButtonItemStylePlain target:self action:@selector(go_invest)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor colorWithRed:0.40 green:0.40 blue:0.40 alpha:1.00];
    // web创建
    self.web_vc = [self.storyboard instantiateViewControllerWithIdentifier:@"WebViewController"];
    _web = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64 - 49 - 44)];
    _urlStr = [CMCore getH5AddressWithEnterType:H5EnterTypeDetails targeId:_planDataDic.ID markType:_planDataDic.marketType];
    _web.scrollView.scrollEnabled = NO;
    _webBridge = [BeeWebViewBridge bridgeForWebView:self.web webViewDelegate:self];
    
    [_webBridge setBlock_bridge_callback:^(NSString *method, NSArray *params) {
        [_mDetailSelf.web_vc bridge_callback_with_method:method params:params];
    }];
    
    RecordHeadView *recView = [[NSBundle mainBundle] loadNibNamed:@"RecordHeadView" owner:nil options:nil].lastObject;
    _tableView.tableHeaderView = recView;
    recView.dic = _data_dic;
    
    // 利息=实际订单利率(百分比)/365*体验金体验期限*体验金金额
    NSInteger experienceDay = 0;
    CGFloat lilv;
    NSInteger monthLimit;
    
    if (_planDataDic.addAnnualRate > 0) {
        lilv = _planDataDic.addAnnualRate +_planDataDic.expectedAnnualRate;
    }else {
        lilv = _planDataDic.expectedAnnualRate;
    }
    if (_data_dic.coupon != nil ) {
        
        experienceDay = _data_dic.coupon.condition.maxBuyDays;
       
        _experienceMoney = [NSString stringWithFormat:@"%.2f", lilv / 100 / 365 * experienceDay * _data_dic.coupon.Value];
    }
    
    //每月还本金和利息=投资总金额／期数+月利息
    //月利息计算公式（按月）：月利息=本金*综合年化收益率*（1+期数）/（期数*24）

    NSInteger repaymentId = _planDataDic.repaymentId;
    NSString *huan_kuan = @"每月还息到期还本";// 默认还款方式
    NSString *detail = @"查看详情";
    
    if (repaymentId == 100) {
        huan_kuan = @"一次性到期还本付息到账户余额";
    } else if (repaymentId == 200) {// 等额本息
        //新方式：每⽉还款额=[贷款本⾦×⽉利率×（1+⽉利率）^还款总期数]÷[（1+⽉利率）^还款总期数-1]（期数为次⽅基数）
        monthLimit = _planDataDic.Period;
        
        CGFloat month_lilv = lilv / 100 / 12.0;
        CGFloat month_lilv_add_one  = lilv / 100 / 12.0 + 1;
        CGFloat pre = pow(month_lilv_add_one, monthLimit);
        CGFloat sur = pow(month_lilv_add_one,  monthLimit) -1;
        
        // 每月偿还利息=贷款本金×月利率×〔(1+月利率)^还款月数-(1+月利率)^(还款月序号-1)〕÷〔(1+月利率)^还款月数-1〕
        CGFloat monthInterest = 0.0;
        CGFloat preOfInvest = _data_dic.totalMoney * month_lilv;
        CGFloat temp = monthInterest;
        for (int i = 1; i < monthLimit + 1; i++) {
            monthInterest = preOfInvest * (pre - pow(month_lilv_add_one, i - 1)) / sur ;
            
            monthInterest = temp + floor(monthInterest * 100) / 100;
            temp = monthInterest;
        }
        //每月还本金
        CGFloat monthIncome = preOfInvest * pre / sur;

        _backMoney = floor(monthIncome * 100) / 100;

        huan_kuan = [NSString stringWithFormat:@"(共%zd期)每月等额本息还款%.2f元", monthLimit, _backMoney];
        //            huan_kuan = @"等额每月还本息";
    } else if (repaymentId == 300) {
        huan_kuan = @"每月还息到期还本";
    } else {
        // 默认值
        huan_kuan = @"一次性到期还本付息到账户余额";
    }
    
    
    // 使用了0.5%加息券一张   使用了5元红包抵扣金额
    if (_data_dic.coupon <= 0) {
        _experienceTitle = @"";
        detail = @"";
    }else {
        NSString *str = [NSString stringWithFormat:@"%.1f", _data_dic.coupon.Value];
        if (_data_dic.coupon.type == 40) { // == 20 抵扣券 == 40 体验金
            _experienceTitle = [NSString stringWithFormat:@"体验金%zd天收益%@元：", experienceDay, _experienceMoney];
            detail = @"查看详情";
        }else if (_data_dic.coupon.type == 10) {// 加息券
            _experienceTitle = [NSString stringWithFormat:@"使用了%@%%加息券一张", str];
            _experienceMoney = str;
            detail = @"";
        }else if (_data_dic.coupon.type == 30){//  == 30 红包
            _experienceTitle = [NSString stringWithFormat:@"使用了%@元红包抵扣金额", str];
            _experienceMoney = str;
            detail = @"";
        }else if (_data_dic.coupon.type == 20){
            _experienceTitle = @"使用了一张抵扣券";
            _experienceMoney = @"";
        }else {
            _experienceTitle = @"";
            detail = @"";
        }
    }
    
    
    _cell_title_ary = @[@"兑换截止日期：", @"还款方式：", _experienceTitle];
    if (_data_dic != nil) {
        _cell_detail_ary = @[[[CMCore turnToDate:_data_dic.regularEndTime] length] > 6?[CMCore turnToDate:_data_dic.regularEndTime]:@"募集中", huan_kuan, detail];
    }else {
        if (_planDataDic.endTime != nil) {
            _cell_detail_ary = @[@"募集中", huan_kuan, detail];
        }else {
            NSString *time =[CMCore turnToDate:_planDataDic.endTime];
            _cell_detail_ary = @[[time length] > 6? time:@"募集中", huan_kuan, detail];
        }
    }
    
    NSInteger status = _data_dic.status;
    /*
     标的状态：WAITPUBLISH(0,"待发布"),FORESHOW(100, "预告"), BUYING(200, "可购买"), DOLDOUT(300, "已售完"), INTERESTIN(400, "计息中"), FINISH(500,"已兑付"), MATCHING(600, "匹配中");
     计划状态：WAITPUBLISH(0,"待发布"),FORESHOW(100, "预告"), BUYING(200, "可购买"), FINISH(300,”已兑付”),
     MATCHING(400, "募集中"),SOLDOUT(500,"已售完");
     */
    if (status == 200) {
        if (_data_dic.beePlan.ID) {
            _statusLabel.text = @"投资成功";
            _statusLabel.textColor = [UIColor colorWithHex:@"#4ab1fa"];
        }else {
            _statusLabel.text = @"募集中";
            _statusLabel.textColor = [UIColor colorWithHex:@"#f95f53"];
        }
    } else if (status == 300) {
        if (_data_dic.beePlan.ID) {
            _statusLabel.text = @"已兑付";
            _statusLabel.textColor = [UIColor colorWithHex:@"#444444"];
        }else {
            _statusLabel.text = @"已回款";
        }
    }else if (status == 201) {
//        [self timeCount:model];
        _statusLabel.text = @"计息中";
        _statusLabel.textColor = [UIColor colorWithHex:@"#ff9600"];
    }else if (status == 500) {
        _statusLabel.text = @"已回款";
        _statusLabel.textColor = [UIColor colorWithHex:@"#444444"];
    } else if (status == 399) {
        _statusLabel.text = @"转让中";
        _statusLabel.textColor = [UIColor colorWithHex:@"#ff9600"];
    } else if (status == 400){
        _statusLabel.text = @"已转让";
        _statusLabel.textColor = [UIColor colorWithHex:@"#444444"];
    }
    if (_data_dic.coupon.condition == nil) {
        _tbOffSet = 355;
    }else {
        _tbOffSet = 405;
    }
}

- (void)go_invest
{
    self.tabBarController.selectedIndex = 1;
    [self go_root:YES];
}

- (void)setMarkLable {
    if (_planDataDic.buyPeopleCount) {
        _secView.markLabelM.hidden = NO;
        _secView.markLabelM.text = [NSString stringWithFormat:@"%zd",_planDataDic.buyPeopleCount];
    }else {
        _secView.markLabelM.hidden = YES;
    }
}

#pragma mark setSecView
- (MoneyDetailOfSection *)setSecView {
    _secView = [[NSBundle mainBundle] loadNibNamed:@"MoneyDetailOfSection" owner:nil options:nil].firstObject;
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:3];
    [self setMarkLable];
    _secView.clickMoneyDetailOfSectionBlock = ^(MoneyDetailOfSectionType type) {
        [_mDetailSelf clickNewProductDescrytion:type indexPath:indexPath];
        [_mDetailSelf.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    };
    return _secView;
}

#pragma mark  old老客户 项目详情 合同 记录 安全保障
- (void)clickOldProductDescrytion:(MoneyDetailOfSectionType)type indexPath:(NSIndexPath *)indexPath {
    switch (type) {
        case MoneyDetailOfSectionTypeDetail:
            // 项目详情
            _urlStr = _planDataDicOld[@"product_description_url"];
            break;
        case MoneyDetailOfSectionTypePlatform:
            // 合同详情
            [self click_old_contract_with_indexPath:indexPath];
            break;
        case MoneyDetailOfSectionTypeInvest:
            // 投资记录
            _urlStr = _planDataDicOld[@"buy_people_list_url"];            break;
        case MoneyDetailOfSectionTypeSafe:
            //保障信息
            _urlStr = _planDataDicOld[@"safe_infomation_url"];
            
            break;
            
        default:
            break;
    }
    
}

#pragma mark 项目详情 合同 记录 安全保障 散标and转让
- (void)clickNewProductDescrytion:(MoneyDetailOfSectionType)type indexPath:(NSIndexPath *)indexPath {
    switch (type) {
        case MoneyDetailOfSectionTypeDetail:
            // 项目详情
            [self setMarkLable];
            _urlStr = [CMCore getH5AddressWithEnterType:H5EnterTypeDetails targeId:_planDataDic.ID markType:_planDataDic.marketType];
            break;
        case MoneyDetailOfSectionTypePlatform:
            
            // 合同详情
            [self setMarkLable];
            _urlStr = _data_dic.contractUrl;
            //[self click_look_contract_with_indexPath:indexPath];
            break;
        case MoneyDetailOfSectionTypeInvest:
            // 投资记录
            _urlStr = [CMCore getH5AddressWithEnterType:H5EnterTypeRecord targeId:_planDataDic.ID markType:_planDataDic.marketType];
            break;
        case MoneyDetailOfSectionTypeSafe:
            //保障信息
            [self setMarkLable];
            _urlStr = [CMCore getH5AddressWithEnterType:H5EnterTypeSecurity targeId:_planDataDic.ID markType:_planDataDic.marketType];
            break;
            
        default:
            break;
    }
    
}

#pragma mark 旧合同

- (void)click_old_contract_with_indexPath:(NSIndexPath *)indexPath {
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD showWithStatus:@"获取合同..."];
    [CMCore contract_record_with_old_order_id:_data_dic_old[@"_id"]?:_data_dic_old[@"order"][@"_id"] order_number:_data_dic_old[@"order_no"] is_alert:YES blockResult:^(NSNumber *code, id result, NSString *message) {
        [SVProgressHUD dismiss];
        _urlStr = result;
        [_mDetailSelf.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
        
    } blockRetry:^(NSInteger index) {
        [SVProgressHUD dismiss];
        if (index == 1) {
            [self click_old_contract_with_indexPath:indexPath];
        }
    }];
}

#pragma mark 合同

- (void)click_look_contract_with_indexPath:(NSIndexPath *)indexPath {
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD showWithStatus:@"获取合同..."];
    [CMCore contract_record_with_order_id:_data_dic.ID ? :_data_dic.order.ID order_number:_data_dic.orderNo is_alert:YES blockResult:^(NSNumber *code, id result, NSString *message) {
        [SVProgressHUD dismiss];
        
        if ([code integerValue] == 200) {
            _urlStr = result;
            [_mDetailSelf.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
        }
    } blockRetry:^(NSInteger index) {
        [SVProgressHUD dismiss];
        if (index == 1) {
            [self click_look_contract_with_indexPath:indexPath];
        }
    }];
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

    if (_enterType == 4) {
        if (indexPath.section == 3) {
            return kScreenHeight - 49 - 64 - 44;
        }
        if (indexPath.section == 2 && (!_data_dic_old[@"coupon"][@"condition"] || _data_dic_old[@"coupon"] == nil)) {
            return kSectionFooterHeight;
        }
        return 50;
    }else {
        if (indexPath.section == 3) {
            return kScreenHeight - 45 - 64 - 44;
        }
        if (indexPath.section == 2 && _data_dic.coupon.condition == nil) {
            return kSectionFooterHeight;
        }
        return 50;
    }
    
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
    if (_enterType == 4) {
        if (section == 3) {
            MoneyDetailOfSection *secView = [[NSBundle mainBundle] loadNibNamed:@"MoneyDetailOfSection" owner:nil options:nil].firstObject;
            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:3];
            if ([_planDataDicOld[@"buy_people_count"] integerValue] == 0) {
                [secView.markLabelM removeFromSuperview];
            }else {
                secView.markLabelM.hidden = NO;
                secView.markLabelM.text = [NSString stringWithFormat:@"%zd",[_planDataDicOld[@"buy_people_count"] integerValue]];
            }
            secView.clickMoneyDetailOfSectionBlock = ^(MoneyDetailOfSectionType type) {
                [self clickOldProductDescrytion:type indexPath:indexPath];
                [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
            };
            return secView;
        }else {
            return nil;
        }
    }else {
        if (section == 3) {
            return [self setSecView];
        }else {
            return nil;
        }
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
        
        [_web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_urlStr]]];
        
        
        [cell.contentView addSubview:_web];
        
        return cell;
    }else {
        if (indexPath.section == 2) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (_data_dic.coupon != nil) {
                if (_data_dic.coupon.type == 40) { // == 20 抵扣券 == 40 体验金
                    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:_cell_title_ary[indexPath.section] attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:@"#444444"], NSFontAttributeName:[UIFont fontWithName:FontOfAttributed size:14]}];
                    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:@"#fd5353"] range:NSMakeRange(_experienceTitle.length - 2 - _experienceMoney.length, _experienceMoney.length)];
                    cell.textLabel.attributedText = str;
                    
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                }else if (_data_dic.coupon.type == 10) {// 加息券
                    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:_cell_title_ary[indexPath.section] attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:@"#444444"], NSFontAttributeName:[UIFont fontWithName:FontOfAttributed size:14]}];
                    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:@"#fd5353"] range:NSMakeRange(_experienceTitle.length - 6 - _experienceMoney.length, _experienceMoney.length + 1)];
                    cell.textLabel.attributedText = str;
                }else if(_data_dic.coupon.type  == 30){//  == 30 红包
                    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:_cell_title_ary[indexPath.section] attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:@"#444444"], NSFontAttributeName:[UIFont fontWithName:FontOfAttributed size:14]}];
                    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:@"#fd5353"] range:NSMakeRange(_experienceTitle.length - 7 - _experienceMoney.length, _experienceMoney.length + 1)];
                    cell.textLabel.attributedText = str;
                }else {
                    cell.textLabel.text = _experienceTitle;
                    cell.textLabel.textColor = [UIColor colorWithHex:@"#444444"];
                    cell.textLabel.font = [UIFont systemFontOfSize:14];
                }
                cell.detailTextLabel.text = _cell_detail_ary[indexPath.section];
                cell.detailTextLabel.textColor = [UIColor colorWithHex:@"#444444"];
                cell.detailTextLabel.font = [UIFont fontWithName:FontOfAttributed size:14];
            }
            
            return cell;
        }
        DetailSimpleCell * simpleCell = [[NSBundle mainBundle] loadNibNamed:@"DetailSimpleCell" owner:nil options:nil].lastObject;
        simpleCell.title.text = _cell_title_ary[indexPath.section];
        if (indexPath.section == 1) {
            simpleCell.downLine.hidden = NO;
        }
        BOOL typeID = 0;
        if (_enterType == 4) {
            typeID = indexPath.section == 1 && [_planDataDicOld[@"month_limit"] doubleValue];
        }else {
            typeID = indexPath.section == 1 && _planDataDic.repaymentId == 200;
        }
        if (typeID) {
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:_cell_detail_ary[indexPath.section] attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:@"#444444"], NSFontAttributeName:[UIFont fontWithName:FontOfAttributed size:14]}];
            NSInteger len = [_cell_detail_ary[indexPath.section] length];
            NSString *bMoney = [NSString stringWithFormat:@"%.2f", _backMoney];
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:@"#fd5353"] range:NSMakeRange(len - 1 - bMoney.length, bMoney.length)];
            simpleCell.content.attributedText = str;
        }else {
            simpleCell.content.text = _cell_detail_ary[indexPath.section];
        }
        if (indexPath.section == 1 && indexPath.row == 0) {
            simpleCell.downLine.alpha = 1;
        }
        
        return simpleCell;
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section == 2 && _data_dic.coupon.type) {
        if (_data_dic.coupon.type == 40) {
            ExperienceMoneyView *expView = [[NSBundle mainBundle] loadNibNamed:@"ExperienceMoneyView" owner:nil options:nil].lastObject;
            expView.frame = [UIScreen mainScreen].bounds;
            expView.dic = _data_dic;
            UIWindow *keyWin = [UIApplication sharedApplication].keyWindow;
            [keyWin addSubview:expView];
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    if (scrollView.contentOffset.y > 5 ) {
        [UIView animateWithDuration:0.5 animations:^{
            _tableView.contentOffset = CGPointMake(0, _mDetailSelf.tbOffSet);
        }];
        _web.scrollView.scrollEnabled = YES;
    }
}

// kvo 方法的实现
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if (_web) {
        if ([keyPath isEqualToString:@"contentOffset"])
        {
            CGFloat y = _web.scrollView.contentOffset.y;
            if (y < -3) {
                _web.scrollView.scrollEnabled = NO;
                [UIView animateWithDuration:0.5 animations:^{
                    _tableView.contentOffset = CGPointMake(0, 0);
                }];
                
            }
        }
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    //放大缩小
    NSString *meta = [NSString stringWithFormat:@"document.getElementsByName(\"viewport\")[0].content = \"width=self.view.frame.size.width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=5.0, user-scalable=yes\""];
    [webView stringByEvaluatingJavaScriptFromString:meta];
}

@end
