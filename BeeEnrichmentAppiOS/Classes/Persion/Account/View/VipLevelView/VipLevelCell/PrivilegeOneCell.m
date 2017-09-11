//
//  PrivilegeOneCell.m
//  BeeEnrichmentAppiOS
//
//  Created by dll on 2017/6/8.
//  Copyright © 2017年 DuLonglong. All rights reserved.
//

#define ScrollW 375 * kScreenWidth / 375
#define ScrollH kScreenWidth * 260 / 375

#define imageW 170 * kScreenWidth / 375
#define imageH imageW * 123 / 170


#import "PrivilegeOneCell.h"
#import "RedBagView.h"
#import "BasePageControl.h"
#import "VipModel.h"

@interface PrivilegeOneCell()<UIScrollViewDelegate>
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) BasePageControl *basePageControl;
@property (strong, nonatomic) IBOutlet UILabel *noDataLabel;

@end

@implementation PrivilegeOneCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 15, kScreenWidth, ScrollH)];
    [self.contentView addSubview:_scrollView];
    
    _index = 0;
}

- (void)setVipDic:(VipModel *)vipDic
{
    _vipDic = vipDic;
    if (vipDic == nil || vipDic.couponList.count <= 0) {
        _noDataLabel.text = @"暂无红包";
        return;
    } else {
        _noDataLabel.text = @"";
    }
    
    NSArray<CouponListModel *> *couponListM = vipDic.couponList;
    
    NSInteger num = couponListM.count;
    if (couponListM.count <= 0) {
        num = 0;
    }
    int count = (int)num, longLocation = 1;//(int)[vipDic[@"couponList"] count]
    if (count % 4 || count <= 0) {
        longLocation = count / 4 + 1;
    }else {
        longLocation = count / 4;
    }
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width * longLocation, _scrollView.frame.size.height);
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = false;
//    _scrollView.backgroundColor = [UIColor blueColor];
    
    
    for (int m = 0; m < longLocation; m++) {
        int value = count % 4, iFainal = 2, jFainal = 2;
        
        if (m == longLocation - 1) {
            if (value == 0 || value == 3) {
                iFainal = 2;
            }else {
                iFainal = 1;
            }
        }
        for (int i = 0; i < iFainal; i++) {
            if (m == longLocation - 1) {
                if (value == 1 || value == 3) {
                    if (i == 0 && value == 3) {
                        jFainal = 2;
                    }else {
                        jFainal = 1;
                    }
                }else {
                    jFainal = 2;
                }
            }
            for (int j = 0; j < jFainal; j++) {
                int w = imageW, h = imageH + 4, space = 15;
                if (j % 2 != 0) {
                    w = w + 20;
                    space = 0;
                }
                RedBagView *redView = [[NSBundle mainBundle] loadNibNamed:@"RedBagView" owner:nil options:nil].lastObject;
                redView.frame = CGRectMake((j * w + space) + (m * kScreenWidth), i * h, imageW, imageH);
                redView.availableBtn.selected = YES;
                if (!couponListM[_index].available) {
                    // 1 可领  0 不能
                    redView.availableBtn.selected = NO;
                    redView.availableBtn.enabled = NO;
                }else {
                    redView.availableBtn.tag = _index;
                    [redView.availableBtn addTarget:self action:@selector(getGiftBag:) forControlEvents:UIControlEventTouchUpInside];
                }
                if (couponListM != nil) {
                    NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc] initWithString:couponListM[_index].title attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:32]}];
                    NSAttributedString *str2 = [[NSAttributedString alloc] initWithString:@"元" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}];
                    [str1 appendAttributedString:str2];
                    redView.conditionLabel.text = [NSString stringWithFormat:@"满%@元可用", couponListM[_index].minBuyMoney];
                    
                    
                    redView.valueLabel.attributedText = str1;
                    [_scrollView addSubview:redView];
                }
                
                
                _index++;
            }
        }
    }
    
    //创建UIPageControl
    _basePageControl = [[BasePageControl alloc] initWithFrame:CGRectMake(kScreenWidth / 2, ScrollH + 11, 10, 3)];  //创建UIPageControl，位置在屏幕最下方。

    _basePageControl.numberOfPages = longLocation;//总的图片页数
    _basePageControl.currentPage = 0; //当前页
    _basePageControl.currentPageIndicatorTintColor = [UIColor clearColor];
    _basePageControl.pageIndicatorTintColor = [UIColor clearColor];
    
    [self.contentView addSubview:_basePageControl];  //将UIPageControl添加到主界面上。
}

//pagecontroll的委托方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int page = scrollView.contentOffset.x / scrollView.frame.size.width;
    //    NSLog(@"%d", page);
    
    // 设置页码
    _basePageControl.currentPage = page;
}


- (void)getGiftBag:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    
    [SVProgressHUD showWithStatus:@"正在获取中..."];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
    [CMCore getVipGiftBagWithCoupon_id:_vipDic.couponList[btn.tag].ID is_alert:YES blockResult:^(NSNumber *code, id result, NSString *message) {
        [SVProgressHUD dismiss];
        if ([code integerValue] == 200) {
            [[JPAlert current] showAlertWithTitle:@"领取成功" button:@[@"确定"]];
            btn.selected = NO;
            btn.enabled = NO;
        }
    } blockRetry:^(NSInteger index) {
        [SVProgressHUD dismiss];
    }];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
