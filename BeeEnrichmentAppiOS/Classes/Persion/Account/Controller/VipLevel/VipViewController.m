//
//  VipViewController.m
//  BeeEnrichmentAppiOS
//
//  Created by dll on 2017/6/8.
//  Copyright © 2017年 DuLonglong. All rights reserved.
//

#import "VipViewController.h"
#import "PrivilegeTwoCell.h"
#import "PrivilegeOneCell.h"
#import "VipHeadView.h"
#import "ExplainCell.h"
#import "VipModel.h"

@interface VipViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIImageView * imageViewCopy;
@property (nonatomic, strong) UIButton *judgeBtn;
@property (nonatomic, strong) NSArray *titleArr;

@property (nonatomic, strong) VipModel *vipM;
@end


__weak VipViewController * _VipViewControllerSelf;
@implementation VipViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    _VipViewControllerSelf = self;
    self.vipM = [[VipModel alloc] init];
    _tableView.tableHeaderView = [self setHeadView];
    _titleArr = @[@"会员等级与权益明细", @"等级常见问题"];
    _judgeBtn.selected = NO;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"%@", self.navigationController.childViewControllers);
    if (_flagStr) {
        [self.navigationController setNavigationBarHidden:YES animated:NO];
    } else {
        [self.navigationController setNavigationBarHidden:YES animated:animated];
//        []
    }
    _flagStr = nil;
    [self get_vip_list];
}



- (UIView *)setHeadView
{
    VipHeadView *headView = [[NSBundle mainBundle] loadNibNamed:@"VipHeadView" owner:nil options:nil].firstObject;
    headView.backbtn = ^{
        [_VipViewControllerSelf.navigationController popViewControllerAnimated:NO];
    };
    headView.goInvesting = ^{
        _VipViewControllerSelf.tabBarController.selectedIndex = 1;
        [_VipViewControllerSelf go_root:YES];
    };
    headView.dataDic = _vipM;
    return headView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1) {
        return 1;
    }else if (section == 3){
//        return 2;
        return 1;
    }else {
        return 1;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return kScreenWidth * 275 / 375;
    }
    if (indexPath.section == 1) {
          if (_judgeBtn.selected) {
              return 91;
          }else {
              return kSectionFooterHeight;
          }
    }
    if (indexPath.section == 2) {
        return 274;
    }
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0 || section == 2) {
        return 40;
    }else if (section == 1){
        return 30;
    }else{
        return kSectionFooterHeight;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return kSectionFooterHeight;
    }else if ( section == 3){
        return 40;
    }else {
        return 10;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0 || section == 1 || section == 2) {
        UIView *sectionHeadView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
        sectionHeadView.backgroundColor = [UIColor whiteColor];
        UILabel *rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(15 * kScreenWidth / 375, 13.5, 200, 14.5)];
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 39.5, kScreenWidth, 0.5)];
        lineView.backgroundColor = [UIColor colorWithHex:@"#f5f5f5"];
        rightLabel.font = [UIFont systemFontOfSize:15];
        if (section == 0) {
            rightLabel.text = @"特权一：红包豪礼月月享不停";
        }else if (section == 1){
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(66, 10, 11, 6)];
            
            imageView.image = [UIImage imageNamed:@"v1.7_down"];
            [btn addTarget:self action:@selector(getExplain) forControlEvents:UIControlEventTouchUpInside];
            btn.selected = NO;
            
            _imageViewCopy = imageView;
            _judgeBtn = btn;
            rightLabel.frame = CGRectMake(15 * kScreenWidth / 375, 5, 200, 14.5);
            rightLabel.text = @"领取说明";
            rightLabel.font = [UIFont systemFontOfSize:12];
            rightLabel.textColor = [UIColor colorWithHex:@"#666666"];
            
            [sectionHeadView addSubview:btn];
            [sectionHeadView addSubview:imageView];
        }else {
            rightLabel.text = @"特权二：会员礼包惊喜不断";
        }
        
        if (section == 0 || section == 2) {
            [sectionHeadView addSubview:lineView];
        }
        [sectionHeadView addSubview:rightLabel];
        
        
        return sectionHeadView;
    }else {
        return nil;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 3) {
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
        UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(140 * kScreenWidth / 375, 14.5, 100, 12)];
        titleLable.text = @"更多特权敬请期待";
        titleLable.textColor = [UIColor colorWithHex:@"#949494"];
        titleLable.font = [UIFont systemFontOfSize:12];
        
        [footerView addSubview:titleLable];
        return footerView;
    }
    return nil;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        PrivilegeOneCell *pOCell = [tableView dequeueReusableCellWithIdentifier:@"PrivilegeOneCell"];
        if (!pOCell) {
            pOCell = [[NSBundle mainBundle] loadNibNamed:@"PrivilegeOneCell" owner:nil options:nil].lastObject;
        }
        pOCell.vipDic = _vipM;
        pOCell.pOTableView = tableView;
        
        return pOCell;
    }
    
    if (indexPath.section == 2) {
        PrivilegeTwoCell *pTCell = [tableView dequeueReusableCellWithIdentifier:@"PrivilegeTwoCell"];
        if (!pTCell) {
            pTCell = [[NSBundle mainBundle] loadNibNamed:@"PrivilegeTwoCell" owner:nil options:nil].lastObject;
        }
        pTCell.pTDic = _vipM;
        return pTCell;
    }
    
    if (indexPath.section == 1) {
        ExplainCell *explainCell = [tableView dequeueReusableCellWithIdentifier:@"ExplainCell"];
        if (!explainCell) {
            explainCell = [[NSBundle mainBundle] loadNibNamed:@"ExplainCell" owner:nil options:nil].lastObject;
        }
        
        return explainCell;
    }
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    
    if (indexPath.section == 3) {
        cell.textLabel.text = _titleArr[indexPath.row];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.textColor = [UIColor colorWithHex:@"#444444"];
        cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"v1_icon_right"]];
        if (indexPath.row == 0) {
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 43.5, kScreenWidth, 0.5)];
            lineView.backgroundColor = [UIColor colorWithHex:@"#eeeeee"];
            [cell.contentView addSubview:lineView];
        }
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section == 3) {
        if (indexPath.row == 0) {
            //会员等级
            WebViewController *vc =[self.storyboard instantiateViewControllerWithIdentifier:@"WebViewController"];
            NSString *url = [CMCore getH5AddressWithEnterType:H5EnterTypeMemberLEVEL targeId:nil markType:0];
            [vc load_withUrl:url title:@"会员等级" canScaling:NO];// isShowCloseItem:YES
            [self go_next:vc animated:YES viewController:self];
        }else {
            //常见问题
            WebViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"WebViewController"];
            NSString *url = [CMCore getH5AddressWithEnterType:H5EnterTypeProblems targeId:nil markType:0];
            [vc load_withUrl:url title:@"常见问题" canScaling:NO];// isShowCloseItem:YES
            [self go_next:vc animated:YES viewController:self];
        }
    }
}

- (void)getExplain
{
    
    if (_judgeBtn.selected) {
        _imageViewCopy.image = [UIImage imageNamed:@"v1.7_down"];
        _judgeBtn.selected = NO;
        [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:0 inSection:1],nil]  withRowAnimation:UITableViewRowAnimationNone];
    } else {
        
        _imageViewCopy.image = [UIImage imageNamed:@"v1.7_xuanzejiantou"];
        _judgeBtn.selected = YES;
        [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:0 inSection:1],nil]  withRowAnimation:UITableViewRowAnimationNone];
    }
    
}

- (void)get_vip_list
{
    [SVProgressHUD showWithStatus:@"正在获取特权详情"];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
    [CMCore get_vip_list_with_is_alert:YES blockResult:^(NSNumber *code, id result, NSString *message) {
        [SVProgressHUD dismiss];
//        if ([code integerValue] == 200) {
            _vipM = [VipModel mj_objectWithKeyValues:result];
//        }
        _tableView.tableHeaderView = [self setHeadView];
        [_tableView reloadData];
    } blockRetry:^(NSInteger index) {
        [SVProgressHUD dismiss];
        if (index == 1) {
            [self get_vip_list];
        }
    }];
}




@end
