//
//  AllSuperController.m
//  BeeEnrichmentAppiOS
//
//  Created by MC on 2016/11/7.
//  Copyright © 2016年 didai. All rights reserved.
//
#import "NoDataPointView.h"

#import "AllSuperController.h"
#import "ProductCell.h"
#import "ProductListOneCell.h"
#import "ZSDPaymentView.h"//密码
#import "ProductViewController.h"
#import "TransferProductViewController.h"

@interface AllSuperController ()<UITableViewDelegate,UITableViewDataSource,PaymentViewDelegate>


@property (nonatomic, strong) NoDataPointView *noDataView;
@property (strong, nonatomic)  UITableView *tableView;
@property (nonatomic, strong)  NSMutableArray<ProductsDetailModel *> *subject_list;
@property (nonatomic, assign)  NSInteger typeClass;
@property (nonatomic, strong)  ZSDPaymentView *payment;
@property (nonatomic, strong)  NSMutableArray<ProductsDetailModel *> *hlist_list;
@property (nonatomic, strong) ProductsDetailModel *subject_dict;
@property (assign, nonatomic)  NSInteger pageInteger;
@property (strong, nonatomic)  UILabel *noDataLabel;
@property (assign, nonatomic)  CGFloat h;
@property (strong, nonatomic)  UIButton *section_btn, *titleButton;
@property (strong, nonatomic)  UIImageView *section_btn_imageView;
@property (nonatomic, strong)  NSMutableArray *closeArr;
@property (nonatomic, assign)  BOOL isClose;
@property (nonatomic, strong) NSString *historyFlag, *flagStr;
@end

@implementation AllSuperController

-(void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blueColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    _hlist_list = [NSMutableArray array];
    [self load_product_list];
    [self creatTableView];
    [self set_refresh];
    _closeArr = [[NSMutableArray alloc] init];
    for (int i = 0; i <2; i++) {
        [_closeArr addObject:[NSNumber numberWithBool:YES]];
    }
    
    [self creatNoDataview];
    
}

- (NSMutableArray<ProductsDetailModel *> *)subject_list {
    if (!_subject_list) {
        _subject_list = [NSMutableArray array];
    }
    return  _subject_list;
}

-(void)creatTableView{
    self.automaticallyAdjustsScrollViewInsets = false;
    self.view.backgroundColor = [UIColor colorWithHex:@"#F1F1F1"];
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [self.view addSubview:_tableView];
    _tableView.backgroundColor = [UIColor colorWithHex:@"#F1F1F1"];//
    _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    _tableView.contentInset = UIEdgeInsetsMake(0, 0, 69+40, 0);
    [_tableView registerNib:[UINib nibWithNibName:@"ProductListOneCell" bundle:nil] forCellReuseIdentifier:@"ProductListOneCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"ProductCell" bundle:nil] forCellReuseIdentifier:@"ProductCell"];
    _tableView.sectionFooterHeight = 5;
    _tableView.sectionHeaderHeight = 5;
    _section_btn = [UIButton buttonWithType:UIButtonTypeSystem];
    _section_btn.backgroundColor = [UIColor clearColor];
    _section_btn.frame = CGRectMake(0, 0, kScreenWidth, 44);
    _section_btn.titleLabel.font = [UIFont fontWithName:FontOfAttributed size:14];
    [_section_btn setTitleColor:[UIColor colorWithHex:@"#676767"] forState:UIControlStateNormal];
    [_section_btn addTarget:self action:@selector(btnClick1:) forControlEvents:UIControlEventTouchUpInside];

   
 }

#pragma mark 刷新
- (void)set_refresh {
    __weak AllSuperController *_self = self;
    _tableView.mj_header = [WMRefreshHeader headerWithRefreshingBlock:^{
        [_self load_product_list];
    }];
//    _tableView.mj_footer = [WMRefreshFooter footerWithRefreshingBlock:^{
//        [_self load_product_list];
//    }];
}

- (void)viewWillAppear:(BOOL)animated {
   
    [super viewWillAppear:animated];
    [self.tableView.mj_header beginRefreshing];
    _historyFlag = @"无对应值";
    _titleButton = (UIButton*)[_mart.segmentView viewWithTag:1];
    [_tableView deselectRowAtIndexPath:[_tableView indexPathForSelectedRow] animated:YES];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [_tableView.mj_header beginRefreshing];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
    [_tableView.mj_header  endRefreshing];
}
-(void)btnClick1:(UIButton *)sender{
    
    //找到对应的折叠状态
    _isClose = [[_closeArr objectAtIndex:sender.tag-100] boolValue];
    //修改折叠状态
    [_closeArr replaceObjectAtIndex:sender.tag-100 withObject:[NSNumber numberWithBool:!_isClose]];
    //刷新对应的分段
    if ([[_closeArr objectAtIndex:1] boolValue]) {
        _h = 175 * _subject_list.count + 44 + 20;
    }else {
        _h = 175 * _subject_list.count + 44 + 20 + 120 * _hlist_list.count;
    }
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:sender.tag-100] withRowAnimation:UITableViewRowAnimationFade];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
     CGFloat  titleLabelWidth ;
    if (section == 1) {
        if(_isClose){
            [_section_btn setTitle:@"以下为近期已满额计划" forState:UIControlStateNormal];
            [_section_btn.titleLabel sizeToFit];
            titleLabelWidth = _section_btn.titleLabel.bounds.size.width;
            
            [_section_btn setImage:[UIImage imageNamed:@"v1.7_xuanzejiantou"] forState:UIControlStateNormal];
            [_section_btn setTitleEdgeInsets:UIEdgeInsetsMake(-12,-26,0,0)];
            [_section_btn setImageEdgeInsets:UIEdgeInsetsMake(-12,-26,0,-titleLabelWidth*2-28)];
            
        }else{
            
            [_section_btn setTitle:@"查看更多满额计划" forState:UIControlStateNormal];
            [_section_btn.titleLabel sizeToFit];
            titleLabelWidth = _section_btn.titleLabel.bounds.size.width;
            
            [_section_btn setImage:[UIImage imageNamed:@"v1.7_down"] forState:UIControlStateNormal];
            [_section_btn setTitleEdgeInsets:UIEdgeInsetsMake(-12,-26,0,0)];
            [_section_btn setImageEdgeInsets:UIEdgeInsetsMake(-12,-26,0,-titleLabelWidth*2-28)];
        }
        
        _section_btn.tag = section +100;
        return _section_btn;
    }else{
        
        if (_subject_list.count) {
            UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
            return v;
        }else {
            return _noDataView;
        }
       
        
        
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
    v.backgroundColor = [UIColor clearColor];
    return v;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        if (_subject_list != nil || _subject_list.count ) {
            return 10;
        }else {
            return 200;
        }
    }else {
        return 44;
    }
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return kSectionFooterHeight;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (_subject_list.count) {
            NSString * string = @"ProductListOneCell";
            ProductListOneCell *cell = [tableView dequeueReusableCellWithIdentifier:string];
            if(cell == nil){
                cell = [[ProductListOneCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:string];
            }
            if (_subject_list.count) {
                ProductsDetailModel *dic = _subject_list[indexPath.row];
                cell.model = dic;
            }
            return cell;
        }else {
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"123"];
            cell.backgroundColor = [UIColor clearColor];
            cell.contentView.backgroundColor = [UIColor clearColor];
            return cell;
        }
        
        
    } else {
        NSString * string = @"ProductCell";
        ProductCell *cell = [tableView dequeueReusableCellWithIdentifier:string];
        if(cell == nil){
            cell = [[ProductCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:string];
        }
        if (_hlist_list.count !=0) {
            ProductsDetailModel *dic = _hlist_list[indexPath.row];
            cell.model = dic;
            _historyFlag = cell.starsType.text;

        }else{
            [self creatNoDataLabel: cell.contentView];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        return cell;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 1) {
        if ([[_closeArr objectAtIndex:section] boolValue]) {
            return 0;
        }
        if (_hlist_list.count != 0) {
            return _hlist_list.count;
        }else{
            return 0;
        }
    }else{
        
        return _subject_list.count ? : 1;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        return 110+10;
    }else{
        if (_subject_list.count) {
            return 165+10;
        }else {
            return 300;
        }
        
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath

{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ProductsDetailModel * dict = nil;
    if (indexPath.section== 1) {
        if (_hlist_list.count != 0) {
            _flagStr = @"true";
            dict =  _hlist_list[indexPath.row];
        }else{
            return;
        }
    }else{
        _flagStr = @"false";
        if (_subject_list.count) {
            dict = _subject_list[indexPath.row];
        }
    }
    
    if ((indexPath.section == 0 && _subject_list.count) || (indexPath.section == 1 && _hlist_list.count)) {
        
        NSInteger status = dict.status;
        NSInteger subject_type = dict.subjectType;
        switch (status) {
            case 200://定期理财
                
                switch (subject_type) {
                    case 100://新人专享
                        [self go_product_vc_with_dic:dict flag:@[_flagStr, _historyFlag]];
                        break;
                    case 200://普通标
                        [self go_product_vc_with_dic:dict flag:@[_flagStr, _historyFlag]];
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
                        [self go_product_vc_with_dic:dict flag:@[_flagStr, _historyFlag]];
                        break;
                    default:
                        [self go_product_vc_with_dic:dict flag:@[_flagStr, _historyFlag]];
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
                    [self go_product_vc_with_dic:dict flag:@[_flagStr, _historyFlag]];
                }
                break;
        }
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_h < self.view.frame.size.height &&
        [[_closeArr objectAtIndex:1] boolValue] &&
        scrollView.contentOffset.y > 50 ) {
        
        [_mart Click:_titleButton];
    }
    
    if (_h >= self.view.frame.size.height &&
        scrollView.contentOffset.y >
        _h - self.view.frame.size.height  + 50 &&
        [[_closeArr objectAtIndex:1] boolValue] ) {
        
        //TODO: 滑动的时候不切换vc
        //[_mart Click:_titleButton];
    }
}

#pragma mark 密码

- (void)get_password_str:(NSString *)string
{
    [_payment dismiss];
    if ([string isEqualToString:[NSString stringWithFormat:@"%@",_subject_dict.subjectCustomerPassword]]) {
        [self go_product_vc_with_dic:_subject_dict flag:@[_flagStr, _historyFlag]];
    }else
    {
        [[JPAlert current] showAlertWithTitle:@"抱歉，密码输入错误" button:@"好的"];
    }
    
}
- (void)cancel_payment_handle:(ZSDPaymentView*)payment
{
    self.tabBarController.tabBar.hidden = NO;
}

- (void)go_product_vc_with_dic:(ProductsDetailModel *)dic flag:(NSArray *)flag{

    ProductViewController *ding_vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ProductViewController"];
    ding_vc.data_dic = dic;
    ding_vc.flagOfHistory = flag;
    [self.tabBarController hidesBottomBarWhenPushed];
    [self go_next:ding_vc animated:YES viewController:self];
}


#pragma mark 网络请求－理财超市列表
- (void)load_product_list {
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD showWithStatus:@"努力加载中..."];
    [CMCore get_subject_list_with_subject_status:10 page:self.pageInteger count:30 is_alert:YES blockResult:^(NSNumber *code, id result, NSString *message) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (result) {
            _subject_list = [ProductsDetailModel mj_objectArrayWithKeyValuesArray:result[@"ing"]];
            _hlist_list = [ProductsDetailModel mj_objectArrayWithKeyValuesArray:result[@"history"][@"hlist"]];
                _h = 175 * _subject_list.count + 44 + 20 ;
            [SVProgressHUD dismiss];
        }
        [_tableView reloadData];
    } blockRetry:^(NSInteger index) {
        [_tableView reloadData];
        [SVProgressHUD dismiss];
        if (index == 1) {
            [self load_product_list];
        }
    }];
}
-(void)creatNoDataview {
    
    _noDataView = [[NSBundle mainBundle] loadNibNamed:@"NoDataPointView" owner:nil options:nil].firstObject;
    _noDataView.frame = CGRectMake(0, 0, kScreenWidth, 200);
    _noDataView.clickButton.hidden = YES;
    _noDataView.lineView.hidden = YES;

}


-(void)creatNoDataLabel :(UIView *)view{
    if (_noDataLabel == nil) {
        _noDataLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth , 15)];
        _noDataLabel.text = @"暂无数据";
        _noDataLabel.textColor = [UIColor  colorWithHex:@"#676767"];
        _noDataLabel.backgroundColor = [UIColor colorWithHex:@"#F1F1F1"];
        _noDataLabel.font = [UIFont fontWithName:FontOfAttributed size:14];
        _noDataLabel.textAlignment = 1;
        
        [view addSubview:_noDataLabel];
        UIView * view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 15, kScreenWidth, 105)];
        view1.backgroundColor = [UIColor colorWithHex:@"#F1F1F1"];
        [view addSubview:view1];
    }
}

@end
