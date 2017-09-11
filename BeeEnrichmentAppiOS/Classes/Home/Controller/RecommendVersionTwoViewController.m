//
//  RecommendVersionTwoViewController.m
//  BeeEnrichmentAppiOS
//
//  Created by dll on 16/8/1.
//  Copyright © 2016年 didai. All rights reserved.
//

#import "RecommendVersionTwoViewController.h"
#import "RecVersionTwoTableViewCell.h"
#import "NothingCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "TableHeaderView.h"
#import "ProductListOneCell.h"
#import "GuideViewController.h"
#import "LoginNavigationController.h"//登录／注册
#import "ProductViewController.h"//资产
#import "ZSDPaymentView.h"//密码
#import "DiscoverViewController.h"
#import "CCPScrollView.h"
#import "TransferProductViewController.h"
#import "MessagesModel.h"
#import "BannerModel.h"

__weak RecommendVersionTwoViewController *_self;

@interface RecommendVersionTwoViewController ()<UITableViewDelegate, UITableViewDataSource, SDCycleScrollViewDelegate, PaymentViewDelegate>

@property (nonatomic, strong) NSArray<ProductsDetailModel *> *recommendedSubjectListM;
@property (nonatomic, strong) NSMutableArray<CarouselCustomListModel *> *carouselCustomListM;
@property (nonatomic, strong) NSMutableArray<MainMenuListModel *> *mainMenuListM;
@property (nonatomic, strong) ProductsDetailModel *subject_dict;
@property (nonatomic, strong) NSMutableArray<MessagesModel *>  * advertisingListM;
@property (nonatomic, strong) ProductsDetailModel *qianggouMD;
@property (nonatomic, strong) MessagesModel *dic2;
@property (nonatomic, strong) NSString *access;
@property (nonatomic, strong) ZSDPaymentView *payment;
@end

@implementation RecommendVersionTwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _advertisingListM = [NSMutableArray array];
    [self set_refresh];
    self.tableView.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1.0];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    if ([CMCore is_first_run]) {
        GuideViewController *guide = [self.storyboard instantiateViewControllerWithIdentifier:@"GuideViewController"];
        [self presentViewController:guide animated:NO completion:^{
            [CMCore setIs_first_run:NO];
        }];
        return;
    }
    if ([CMCore isExistenceNetwork]) {
        [CMCore get_bankList];
        [self load_recommend_list];
        [self load_recommend_carousel];
        [self load_recommend_advertising];
    }
    self.tabBarController.tabBar.hidden = NO;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.access = [NSString string];
    if ([CMCore get_access_token]) {
        _access = [NSString stringWithFormat:@"?access_token=%@", [CMCore get_access_token]] ;
    }else {
        _access = @"";
    }
    
    [CMCore showComment];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
    
    [_tableView.mj_header endRefreshing];
}
- (void)set_refresh
{
    __weak RecommendVersionTwoViewController *_self = self;
    _tableView.mj_header = [WMRefreshHeader headerWithRefreshingBlock:^{
        if ([CMCore isExistenceNetwork]) {
            [CMCore get_bankList];
            [_self load_recommend_list];
            [_self load_recommend_carousel];
            [_self load_recommend_advertising];
        }else {
            [_tableView.mj_header endRefreshing];
        }
        
    }];
    if ([CMCore isExistenceNetwork]) {
        [_tableView.mj_header beginRefreshing];
    }
}



- (UIView *)setHeaderView
{
    TableHeaderView *hView = [[NSBundle mainBundle] loadNibNamed:@"TableHeaderView" owner:nil options:nil].lastObject;
    hView.frame = CGRectMake(0, 0, kScreenWidth, 330);
    hView.cycleView.delegate = self;
    hView.cycleView.imageURLStringsGroup = [self dealWithData];
    hView.cycleView.bannerImageViewContentMode = UIViewContentModeScaleToFill;
    hView.cycleView.showPageControl = true;
    hView.cycleView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    //hView.cycleView.pageDotColor = [UIColor groupTableViewBackgroundColor];
    hView.cycleView.pageControlDotSize = CGSizeMake(10, 2);
    hView.cycleView.pageDotImage = [UIImage imageNamed:@"v1.6_home_pagecontrol_point"];
    hView.cycleView.currentPageDotImage = [UIImage imageNamed:@"v1.6_home_pagecontrol_white"];
    hView.cycleView.autoScrollTimeInterval = 2.5f;
    hView.cycleView.clickItemOperationBlock = ^(NSInteger currentIndex){
        [self go_web_vc_with_index:currentIndex];
    };
    
    
    [hView setNeedsLayout];
    [hView layoutIfNeeded];
    
    [hView.moreBtn addTarget:self action:@selector(toggleButton) forControlEvents: UIControlEventTouchUpInside];
    
    CCPScrollView *ccpView = [[CCPScrollView alloc] initWithFrame:CGRectMake(30+4, 0,kScreenWidth/375*270, hView.backView.frame.size.height)];
    ccpView.backgroundColor = [UIColor clearColor];
    if (_advertisingListM.count != 0) {
        NSMutableArray * titleArr = [NSMutableArray array];
        for (MessagesModel * dic in _advertisingListM) {
            [titleArr addObject:dic.title];
        }
        ccpView.titleArray = titleArr;
        
    }else{
        
        //[self load_recommend_advertising];
    }
    
    ccpView.titleFont = 13;
    
    ccpView.titleColor = [UIColor colorWithHex:@"#676767"];
    
    //    ccpView.BGColor = [UIColor whiteColor];
    
    [ccpView clickTitleLabel:^(NSInteger index,NSString *titleString) {
        
        if (_advertisingListM.count != 0) {
            
            NSInteger inter = index-100;
            //        NSDictionary *dic2 =[NSDictionary dictionary];
            
            _dic2 = _advertisingListM[inter];
            NSString * str = [NSString stringWithFormat:@"%@",_dic2.url];
            WebViewController *web_vc = [self.storyboard instantiateViewControllerWithIdentifier:@"WebViewController"];
            [web_vc load_withUrl:str title:_dic2.title canScaling:NO];// isShowCloseItem:YES
            [self go_next:web_vc animated:YES viewController:self];
            
            //UIStoryboard *stor = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            
        }else{
            
            //  [self load_recommend_advertising];
        }
        
    }];
    
    [hView.backView addSubview:ccpView];
    
    if (!_qianggouMD) {
        hView.everydayRecImageView.image = [UIImage imageNamed:@""];
    }
    
    for (int i = 0; i < _mainMenuListM.count; i++) {
        //        UIView *aView = [[UIView alloc] init];
        //        UIView *aView = nil;
        switch (i) {
            case 0:
                [hView.viewZero_of_imageZero sd_setImageWithURL:_mainMenuListM[i].iconUrl placeholderImage:nil];
                hView.viewZero_of_labelZero.text = _mainMenuListM[i].title;
                hView.zeroBtn.tag = i;
                [hView.zeroBtn addTarget:self action:@selector(go_someone:) forControlEvents:UIControlEventTouchUpInside];
                [hView.zeroBtn addSubview:hView.viewZero_of_imageZero];
                [hView.zeroBtn addSubview:hView.viewZero_of_labelZero];
                //                aView = hView.headerViewZero;
                break;
            case 1:
                [hView.viewOne_of_imageOne sd_setImageWithURL:_mainMenuListM[i].iconUrl placeholderImage:nil];
                hView.viewOne_of_labelOne.text = _mainMenuListM[i].title;
                hView.OneBtn.tag = i;
                [hView.OneBtn addTarget:self action:@selector(go_someone:) forControlEvents:UIControlEventTouchUpInside];
                [hView.OneBtn addSubview:hView.viewOne_of_imageOne];
                [hView.OneBtn addSubview:hView.viewOne_of_labelOne];
                //                aView = hView.headerViewOne;
                
                break;
            case 2:
                [hView.viewThree_of_imageThree sd_setImageWithURL:_mainMenuListM[i].iconUrl placeholderImage:nil];
                hView.viewThree_of_labelThree.text = _mainMenuListM[i].title;
                hView.threeBtn.tag = i;
                [hView.threeBtn addTarget:self action:@selector(go_someone:) forControlEvents:UIControlEventTouchUpInside];
                [hView.threeBtn addSubview:hView.viewThree_of_imageThree];
                [hView.threeBtn addSubview:hView.viewThree_of_labelThree];
                //                aView = hView.headerViewThree;
                
                break;
            case 3:
                
                [hView.viewTwo_of_imageTwo sd_setImageWithURL:_mainMenuListM[i].iconUrl placeholderImage:nil];
                hView.viewTwo_of_labelTwo.text = _mainMenuListM[i].title;
                hView.twoBtn.tag = i;
                [hView.twoBtn addTarget:self action:@selector(go_someone:) forControlEvents:UIControlEventTouchUpInside];
                [hView.twoBtn addSubview:hView.viewTwo_of_imageTwo];
                [hView.twoBtn addSubview:hView.viewTwo_of_labelTwo];
                //                aView = hView.headerViewTwo;
                
                break;
            default:
                break;
        }
    }
    
    return hView;
}

- (void)go_someone:(UIButton *)sender
{
    [MobClick event:home_menuID];
    NSInteger type = _mainMenuListM[sender.tag].entryType ;
    if (type == 30) {//30 H5页面
        // h5
        WebViewController *web_vc = [self.storyboard instantiateViewControllerWithIdentifier:@"WebViewController"];
        [web_vc load_withUrl:_mainMenuListM[sender.tag].Value title:_mainMenuListM[sender.tag].title canScaling:NO];// isShowCloseItem:YES
        [web_vc.tabBarController setHidesBottomBarWhenPushed:YES];
        [self go_next:web_vc animated:YES viewController:self];
        
    }else if (type == 10) {// 10 标的界面
        // 散标
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
        [SVProgressHUD showWithStatus:@"数据加载中..."];
        [CMCore get_subject_detail_with_subject_id:_mainMenuListM[sender.tag].Value market_type:20 is_alert:YES blockResult:^(NSNumber *code, id result, NSString *message) {
            [SVProgressHUD dismiss];
            if (result) {
                ProductViewController *dingqi_vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ProductViewController"];
                dingqi_vc.data_dic = [ProductsDetailModel mj_objectWithKeyValues:result];
                [self go_next:dingqi_vc animated:YES viewController:self];
                
            }
        } blockRetry:^(NSInteger index) {
            [SVProgressHUD dismiss];
            if (index == 1) {
                [self go_someone:sender];
            }
        }];
    }else if (type == 20) { // 20 文章
        // 文章
        DLog(@"跳文章");
        WebViewController *web_vc = [self.storyboard instantiateViewControllerWithIdentifier:@"WebViewController"];
        [web_vc load_withUrl:_mainMenuListM[sender.tag].Value title:_mainMenuListM[sender.tag].title canScaling:NO];// isShowCloseItem:YES
        [web_vc.tabBarController setHidesBottomBarWhenPushed:YES];
        [self go_next:web_vc animated:YES viewController:self];
    }else if (type == 40) { //签到
        if ([CMCore is_login]) {
            //已登录
            WebViewController *web_vc = [self.storyboard instantiateViewControllerWithIdentifier:@"WebViewController"];
            NSString *url_str = [NSString stringWithFormat:@"%@sign_in?params=%@",HTTP_API_BASIC,[CMCore get_access_token]];
            [web_vc load_withUrl:url_str title:@"签到" canScaling:NO];// isShowCloseItem:NO
            [web_vc.tabBarController setHidesBottomBarWhenPushed:YES];
            [self go_next:web_vc animated:YES viewController:self];
        }else{
            //未登录
            LoginNavigationController *login_navc = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginNavigationController"];
            [self presentViewController:login_navc animated:YES completion:nil];
        }
    }else if (type == 60){// 计划标
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
        [SVProgressHUD showWithStatus:@"数据加载中..."];
        [CMCore get_subject_detail_with_subject_id:_mainMenuListM[sender.tag].Value market_type:10 is_alert:YES blockResult:^(NSNumber *code, id result, NSString *message) {
            [SVProgressHUD dismiss];
            if (result) {
                ProductViewController *dingqi_vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ProductViewController"];
                dingqi_vc.data_dic = [ProductsDetailModel mj_objectWithKeyValues:result];
                [self go_next:dingqi_vc animated:YES viewController:self];
                
            }
        } blockRetry:^(NSInteger index) {
            [SVProgressHUD dismiss];
            if (index == 1) {
                [self go_web_vc_with_index:index];
            }
        }];
    }else {
        DLog(@"type值无对应跳转界面");
    }
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.recommendedSubjectListM != nil && self.recommendedSubjectListM.count != 0) {
        
        return 2;
    }else {
        return  1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.recommendedSubjectListM != nil && self.recommendedSubjectListM.count != 0) {
        
        return section == 0 ? 1 : self.recommendedSubjectListM.count ;
    }else{
        return 1 ;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        if (!_qianggouMD) {
            return kScreenHeight - 276 - 64 - 44;
        }else {
            return   260;
        }
    }else{
        return 176.5;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        
        return  kSectionFooterHeight;
    }else{
        return 36;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (self.recommendedSubjectListM != nil && self.recommendedSubjectListM.count != 0 ) {
        
        return  section == 0 ? kSectionFooterHeight : 40;
    }else{
        return 40;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 1) {
        UIView * footView = [[UIView alloc] init];
        footView.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1.0];
        
        UILabel * lable = [[UILabel alloc] initWithFrame:CGRectMake(18, 1.5, 190, 12)];
        lable.text = @"个人资产由银行级别风控体系保障";
        lable.font = [UIFont systemFontOfSize:12 weight:UIFontWeightLight];
        lable.textColor = [UIColor colorWithRed:148/255.0 green:148/255.0 blue:148/255.0 alpha:1.0];
        [lable sizeToFit];
        
        UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width - (18+lable.frame.size.width))*0.5, 8, 18+lable.frame.size.width, 15)];
        UIImageView * imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
        imageV.image = [UIImage imageNamed:@"v1.6.0_mine_security"];
        [lineView addSubview:imageV];
        
        
        [lineView addSubview:lable];
        
        
        [footView addSubview:lineView];
        
        return  footView;
    }else{
        
        
        if (self.recommendedSubjectListM == nil || self.recommendedSubjectListM.count == 0 ) {
            UIView * footView = [[UIView alloc] init];
            footView.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1.0];
            
            UILabel * lable = [[UILabel alloc] initWithFrame:CGRectMake(18, 1.5, 190, 12)];
            
            
            UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width - (18+lable.frame.size.width))*0.5, 12.5, 18+lable.frame.size.width, 15)];
            UIImageView * imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
            if ([CMCore isExistenceNetwork]) {
                lable.text = @"个人资产由银行级别风控体系保障";
                lable.font = [UIFont systemFontOfSize:12 weight:UIFontWeightLight];
                lable.textColor = [UIColor colorWithRed:148/255.0 green:148/255.0 blue:148/255.0 alpha:1.0];
                [lable sizeToFit];
                
                imageV.image = [UIImage imageNamed:@"v1.6.0_mine_security"];
            }else {
                lable.text = @"暂无往网络，请重新加载";
                lable.font = [UIFont systemFontOfSize:14];
//                imageV.image = [UIImage imageNamed:@""];
            }
            
            
            [lineView addSubview:imageV];
            
            
            [lineView addSubview:lable];
            
            
            [footView addSubview:lineView];
            
            return  footView;
        }else{
            
            return nil;
        }
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        UIView * headView = [[UIView alloc] init];
        headView.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1.0];
        
        UIView * red = [[UIView alloc] initWithFrame:CGRectMake(15, (36 - 15)*0.5, 2, 15)];
        red.backgroundColor = [UIColor colorWithRed:249/255.0 green:95/255.0 blue:83/255.0 alpha:1.0];
        [headView addSubview:red];
        
        UILabel * lable = [[UILabel alloc] initWithFrame:CGRectMake(23, (36 - 15)*0.5, [UIScreen mainScreen].bounds.size.width-30, 15)];
        lable.text = @"快速投资";
        lable.font = [UIFont systemFontOfSize:14 weight:UIFontWeightLight];
        lable.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
        [headView addSubview:lable];
        return  headView;
    }else{
        return nil;
    }
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        if (!_qianggouMD) {
            NothingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NothingCell"];
            if (!cell) {
                cell = [[NSBundle mainBundle] loadNibNamed:@"NothingCell" owner:nil options:nil].lastObject;
            }
            return cell;
        }else {
            RecVersionTwoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RecVersionTwoTableViewCell"];
            if (!cell) {
                cell = [[NSBundle mainBundle] loadNibNamed:@"RecVersionTwoTableViewCell" owner:nil options:nil].lastObject;
                
            }
            UITapGestureRecognizer *clickBuyTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click_qianggou)];
            [cell.buyImageView addGestureRecognizer:clickBuyTap];
            
            cell.model = _qianggouMD;
            
            return cell;
        }
    }else{
        
        if (self.recommendedSubjectListM != nil) {
            
            ProductListOneCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProductListOneCell"];
            if (!cell) {
                cell = [[NSBundle mainBundle] loadNibNamed:@"ProductListOneCell" owner:nil options:nil].lastObject;
                
            }
            ProductsDetailModel *dic = self.recommendedSubjectListM[indexPath.row];
            cell.model = dic;
            return cell;
        }else{
            return nil;
        }
    }
    
    
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    NSLog(@"%ld -- %ld", (long)indexPath.section, (long)indexPath.row);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_qianggouMD) {
        if (indexPath.section == 0) {
            
            NSInteger num = _qianggouMD.status;
            if (num != 200 && num != 100) {
                //300 售完，400 计息中，500 已兑付
                NSString *title = @"真遗憾，本理财产品已被抢空，理财集市中有更多惊喜哦!";
                [[JPAlert current] showAlertWithTitle:@"温馨提示" content:title button:@"去看看" block:^(UIAlertView *alert, NSInteger index) {
                    [self.tabBarController setSelectedIndex:1];
                }];
                return;
            }
            if (_qianggouMD.subjectType == 300) {
                //定向标
                _payment = [[ZSDPaymentView alloc] init];
                _payment.tag = 100;
                _payment.delegate = self;
                _payment.numbers_count = 6;
                _payment.title_label.text = @"定向标密码";
                _payment.money_label.hidden = YES;
                _payment.bottom_button.hidden = YES;
                [_payment show];
            } else{
                [self go_product_vc];
            }
            return;
        }
    }
    if (self.recommendedSubjectListM != nil) {
        if (indexPath.section == 1) {
            ProductsDetailModel *dict = self.recommendedSubjectListM[indexPath.row];
            NSInteger status = dict.status;
            NSInteger subject_type = dict.subjectType;
            switch (status) {
                case 200://定期理财
                    
                    switch (subject_type) {
                        case 100://新人专享
                            [self go_product_vc_with_dic:dict];
                            break;
                        case 200://普通标
                            [self go_product_vc_with_dic:dict];
                            break;
                        case 300://定向标
                            //定向标
                            _payment = [[ZSDPaymentView alloc] init];
                            _payment.delegate = self;
                            _payment.numbers_count = 6;
                            _payment.title_label.text = @"定向标密码";
                            _payment.money_label.hidden = YES;
                            _payment.bottom_button.hidden = YES;
                            [_payment show];
                            _subject_dict = dict;
                            break;
                        case 400://手机专享
                            [MobClick event:market_exclusiveMobileID];
                            [self go_product_vc_with_dic:dict];
                            break;
                        default:
                            [self go_product_vc_with_dic:dict];
                            break;
                    }
                    break;
                case 300:// 已售完
                case 400://计息中
                case 500://已兑付
                default:
                    if (dict.subjectType == 300) {
                        //定向标
                        _payment = [[ZSDPaymentView alloc] init];
                        _payment.delegate = self;
                        _payment.numbers_count = 6;
                        _payment.title_label.text = @"定向标密码";
                        _payment.money_label.hidden = YES;
                        _payment.bottom_button.hidden = YES;
                        [_payment show];
                        _subject_dict = dict;
                    }
                    else
                    {
                        [self go_product_vc_with_dic:dict];
                    }
                    break;
                    
                    
            }
        }
    }
    
    //    [self go_web_vc_with_index:indexPath.row];
}

- (void)go_product_vc_with_dic:(ProductsDetailModel *)dic {
    ProductViewController *ding_vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ProductViewController"];
    
    ding_vc.data_dic = dic;
    [self.tabBarController hidesBottomBarWhenPushed];
    [self go_next:ding_vc animated:YES viewController:self];
}

//密码
- (void)get_password_str:(NSString *)string
{
    
    [_payment dismiss];
    if ([string isEqualToString:[NSString stringWithFormat:@"%@",_qianggouMD.subjectCustomerPassword]]) {
        if (_payment.tag == 100) {
            //产品详情
            [self go_product_vc];
        } else {
            //抢购
            [CMCore check_isLogin_isHavePaypassword_isHaveBankCard_with_vc:self data_dic:_qianggouMD alertString:@"为保证资金安全，请绑定银行卡，绑卡时需扣款2元，完成后将全额退还至账户余额" judgeStr:@"normal"];
        }
    } else {
        [[JPAlert current] showAlertWithTitle:@"抱歉，密码输入错误" button:@"好的"];
    }
}

- (void)click_qianggou {
    // 立即抢购埋点
    [MobClick event:home_FastBuyingID];
    if (_qianggouMD) {
        NSInteger num = _qianggouMD.status;
        if (num != 200 && num != 100) {
            //300 售完，400 计息中，500 已兑付
            NSString *title = @"真遗憾，本理财产品已被抢空，理财集市中有更多惊喜哦!";
            [[JPAlert current] showAlertWithTitle:@"温馨提示" content:title button:@"去看看" block:^(UIAlertView *alert, NSInteger index) {
                [self.tabBarController setSelectedIndex:1];
            }];
            return;
        }
        if (_qianggouMD.subjectType == 300) {
            //定向标
            _payment = [[ZSDPaymentView alloc] init];
            _payment.tag = 100;
            _payment.delegate = self;
            _payment.numbers_count = 6;
            _payment.title_label.text = @"定向标密码";
            _payment.money_label.hidden = YES;
            _payment.bottom_button.hidden = YES;
            [_payment show];
        } else{
            [self go_product_vc];
        }
        //            return;
        //        }
    }
    
    //    NSInteger num = [_qianggou_dic[@"status"] integerValue];
    //    if (num != 200) {
    //        NSString *title = @"";
    //        if (num == 100) {
    //            title = @"本理财产品还未开始抢购，理财集市中有更多惊喜哦!";
    //        }else {
    //            //300 售完，400 计息中，500 已兑付
    //            title = @"真遗憾，本理财产品已被抢空，理财集市中有更多惊喜哦!";
    //        }
    //        [[JPAlert current] showAlertWithTitle:@"温馨提示" content:title button:@"去看看" block:^(UIAlertView *alert, NSInteger index) {
    //            [self.tabBarController setSelectedIndex:1];
    //        }];
    //        return;
    //    }
    //
    //    if ([_qianggou_dic[@"subject_type"] integerValue] == 300) {
    //        //定向标
    //        _payment = [[ZSDPaymentView alloc] init];
    //        _payment.tag = 200;
    //        _payment.delegate = self;
    //        _payment.numbers_count = 6;
    //        _payment.title_label.text = @"定向标密码";
    //        _payment.money_label.hidden = YES;
    //        _payment.bottom_button.hidden = YES;
    //        [_payment show];
    //    } else{
    //        [CMCore check_isLogin_isHavePaypassword_isHaveBankCard_with_vc:self data_dic:_qianggou_dic alertString:@"为保证资金安全，请绑定银行卡，绑卡时需扣款2元，完成后将全额退还至账户余额"];
    //    }
}

- (void)go_product_vc
{
    //定期详情
    if (_qianggouMD.marketType == 30) {
        TransferProductViewController *ding_vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"TransferProductViewController"];
        ding_vc.productM = _qianggouMD;
        [self.tabBarController hidesBottomBarWhenPushed];
        [self go_next:ding_vc animated:YES viewController:self];
    }else {
        ProductViewController *dingqi_vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ProductViewController"];
        dingqi_vc.data_dic = _qianggouMD;
        [self go_next:dingqi_vc animated:YES viewController:self];
    }
}

#pragma mark 轮播图点击跳转
- (void)go_web_vc_with_index:(NSInteger)index
{
    // 轮播图埋点
    [MobClick event:home_bannerID];
    // type 确定跳转的界面
    /*
     class EntryType(object):
     # h5页面
     h5 = 0
     # 标的ID
     subject = 1
     # 文章ID
     article = 2
     # 签到页面
     signin = 3
     */
    CarouselCustomListModel *dic = _carouselCustomListM[index];
    NSInteger type = dic.entryType;
    if (type == 30) {
        // h5
        WebViewController *web_vc = [self.storyboard instantiateViewControllerWithIdentifier:@"WebViewController"];
        [web_vc load_withUrl:dic.Value title:dic.title canScaling:NO];// isShowCloseItem:YES
        [web_vc.tabBarController setHidesBottomBarWhenPushed:YES];
        [self go_next:web_vc animated:YES viewController:self];
    }else if (type == 10) {
        // 散标
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
        [SVProgressHUD showWithStatus:@"数据加载中..."];
        [CMCore get_subject_detail_with_subject_id:dic.Value market_type:20 is_alert:YES blockResult:^(NSNumber *code, id result, NSString *message) {
            [SVProgressHUD dismiss];
            if (result) {
                ProductViewController *dingqi_vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ProductViewController"];
                dingqi_vc.data_dic = [ProductsDetailModel mj_objectWithKeyValues:result];
                [self go_next:dingqi_vc animated:YES viewController:self];
            }
        } blockRetry:^(NSInteger index) {
            [SVProgressHUD dismiss];
            if (index == 1) {
                [self go_web_vc_with_index:index];
            }
        }];
    }else if (type == 20) {
        // 文章
        WebViewController *web_vc = [self.storyboard instantiateViewControllerWithIdentifier:@"WebViewController"];
        [web_vc load_withUrl:dic.Value title:dic.title canScaling:NO];// isShowCloseItem:YES
        [web_vc.tabBarController setHidesBottomBarWhenPushed:YES];
        [self go_next:web_vc animated:YES viewController:self];
    }else if (type == 40) {
        // 签到
        if ([CMCore is_login]) {
            //已登录
            WebViewController *web_vc = [self.storyboard instantiateViewControllerWithIdentifier:@"WebViewController"];
            NSString *url_str = [NSString stringWithFormat:@"%@sign_in?params=%@",HTTP_API_BASIC,[CMCore get_access_token]];
            [web_vc load_withUrl:url_str title:@"签到" canScaling:NO];// isShowCloseItem:NO
            [web_vc.tabBarController setHidesBottomBarWhenPushed:YES];
            [self go_next:web_vc animated:YES viewController:self];
        }else{
            //未登录
            LoginNavigationController *login_navc = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginNavigationController"];
            [self presentViewController:login_navc animated:YES completion:nil];
        }
    }else if (type == 60){// 计划标
        [self toPlanBid:dic];
    }else {
        DLog(@"type值无对应跳转界面");
    }
}

#pragma mark 计划标
- (void)toPlanBid:(CarouselCustomListModel *)dic {
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
    [SVProgressHUD showWithStatus:@"数据加载中..."];
    [CMCore get_subject_detail_with_subject_id:dic.Value market_type:10 is_alert:YES blockResult:^(NSNumber *code, id result, NSString *message) {
        [SVProgressHUD dismiss];
        if (result) {
            ProductViewController *dingqi_vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ProductViewController"];
            dingqi_vc.data_dic = [ProductsDetailModel mj_objectWithKeyValues:result];
            [self go_next:dingqi_vc animated:YES viewController:self];
        }
    } blockRetry:^(NSInteger index) {
        [SVProgressHUD dismiss];
        if (index == 1) {
            [self go_web_vc_with_index:index];
        }
    }];
}

#pragma mark 网络请求－首页数据
- (void)load_recommend_list
{
    [CMCore get_recommend_is_alert:YES blockResult:^(NSNumber *code, id result, NSString *message) {
        [_tableView.mj_header endRefreshing];
        if (result) {
            NSDictionary *dic = result;
            if (![dic[@"qiangGou"] isKindOfClass:[NSNull class]] && dic[@"qiangGou"]) {
                _qianggouMD = [ProductsDetailModel mj_objectWithKeyValues:dic[@"qiangGou"]];
            }else {
                _qianggouMD = nil;
            }
            if (![dic[@"recommendedSubjectList"] isKindOfClass:[NSNull class]]) {
                _recommendedSubjectListM = [ProductsDetailModel mj_objectArrayWithKeyValuesArray:dic[@"recommendedSubjectList"]];
            }else{
                _recommendedSubjectListM  = nil;
            }
            
            
            _tableView.tableHeaderView = [self setHeaderView];
            [_tableView reloadData];
        }
    } blockRetry:^(NSInteger index) {
        [_tableView.mj_header endRefreshing];
        if (index == 1) {
            [self load_recommend_list];
        }
    }];
    
    
}

#pragma mark 轮播图
- (void)load_recommend_carousel
{
    [CMCore get_recommend_carousel_is_alert:YES blockResult:^(NSNumber *code, id result, NSString *message) {
        [_tableView.mj_header endRefreshing];
        if (result) {
            _carouselCustomListM = [CarouselCustomListModel mj_objectArrayWithKeyValuesArray:result[@"carouselCustomList"]];
            _mainMenuListM = [MainMenuListModel mj_objectArrayWithKeyValuesArray:result[@"mainMenuList"]];
            _tableView.tableHeaderView = [self setHeaderView];
            [_tableView reloadData];
        }
    } blockRetry:^(NSInteger index) {
        [_tableView.mj_header  endRefreshing];
        if (index == 1) {
            [self load_recommend_carousel];
        }
    }];
    
}
#pragma mark 小喇叭广告

-(void)load_recommend_advertising{
    
    //小喇叭广告 // home 1 首页， 0 发现
    [CMCore get_discover_with_home:@"1" is_alert:YES blockResult:^(NSNumber *code, id result, NSString *message) {
        if (result) {
            _advertisingListM = [MessagesModel mj_objectArrayWithKeyValuesArray:result];
            
            [_tableView reloadData];
        }
        [_tableView.mj_header  endRefreshing];
    } blockRetry:^(NSInteger index) {
        [_tableView.mj_header  endRefreshing];
        
        if (index == 1) {
            [self load_recommend_advertising ];
            
        }
    }];
    
}
//更多跳转
-(void)toggleButton{
    self.tabBarController.selectedIndex = 2;
}

- (NSMutableArray *)dealWithData
{
    NSMutableArray *imageArray = [NSMutableArray array];
    for (CarouselCustomListModel *dic in _carouselCustomListM) {
        if (dic.imageUrl) {
            [imageArray addObject:dic.imageUrl];
        }
    }
    
    return imageArray;
}

@end
