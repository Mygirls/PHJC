//
//  HeaderView.m
//  BeeEnrichmentAppiOS
//
//  Created by hwm on 16/10/11.
//  Copyright © 2016年 didai. All rights reserved.
//

#import "HeaderView.h"

@interface HeaderView ()

@property (weak, nonatomic) IBOutlet UIView *bottonView;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UILabel *nameLable;// 名字
@property (weak, nonatomic) IBOutlet UILabel *phoneLable;// 电话
// 累计收益
@property (weak, nonatomic) IBOutlet UILabel *totalMoney;
// 投资本金
@property (weak, nonatomic) IBOutlet UILabel *principalMoneyLable;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hgImageLeadContraint;
// 可用余额
@property (weak, nonatomic) IBOutlet UILabel *restMoneyLable;
// 提现
@property (weak, nonatomic) IBOutlet UIButton *restMoneyButton;

// vip  view
//@property (weak, nonatomic) IBOutlet UIView *vipView;
//@property (weak, nonatomic) IBOutlet UILabel *vipLbale;
@property (weak, nonatomic) IBOutlet UIImageView *jiuzhanImageView;


@end

@implementation HeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.iconImageView.layer.cornerRadius = 32;
    self.iconImageView.layer.borderWidth = 3;
    self.iconImageView.layer.borderColor = [UIColor colorWithRed:0.98 green:0.56 blue:0.54 alpha:1.00].CGColor;
    self.iconImageView.layer.masksToBounds = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickIconBtn)];
    [self.iconImageView addGestureRecognizer:tap];
    self.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.00];
    self.restMoneyButton.layer.cornerRadius = 2;
    self.restMoneyButton.layer.masksToBounds = YES;
//    _vipView.layer.borderColor = [UIColor colorWithRed:0.98 green:0.69 blue:0.67 alpha:1.00].CGColor;
//    _vipView.layer.borderWidth = 1;
//    _vipView.layer.cornerRadius = 9;
//    _vipView.clipsToBounds = YES;
    
//    UITapGestureRecognizer *pan = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickJiuzhanBtn)];
//    [_jiuzhanImageView addGestureRecognizer:pan];
    
}

// 点击旧站
- (void)clickJiuzhanBtn {
    if (self.clickHeaderViewBlock) {
        self.clickHeaderViewBlock(HeaderViewButtonTypeRestJiuzhan);
    }
}

// 点击头像
- (void)clickIconBtn {
    self.clickHeaderViewBlock(HeaderViewButtonTypeIcon);
}

// vip
- (IBAction)clickVipBtn:(id)sender {
    self.clickHeaderViewBlock(HeaderViewButtonTypeVIP);
}

// 可用余额
- (IBAction)clickRestMoneyBtn:(id)sender {
    if (self.clickHeaderViewBlock) {
        self.clickHeaderViewBlock(HeaderViewButtonTypeRestMoney);
    }
}

// 累计收益
- (IBAction)clickTotalMoneyBtn:(id)sender {
    self.clickHeaderViewBlock(HeaderViewButtonTypeTotalMoney);
}

// 投资本金
- (IBAction)clickPrincipalMoneyBtn:(id)sender {
    self.clickHeaderViewBlock(HeaderViewButtonTypePrinMoney);
}

// 设置
- (IBAction)clickSettingBtn:(id)sender {
    self.clickHeaderViewBlock(HeaderViewButtonTypeSetting);
}

- (void)setModel:(UserModel *)model {
    _model = model;
    if (model) {
        self.totalMoney.text = [NSString stringWithFormat:@"%.2f", floor(model.depositIncome * 100)/100] ;
        self.principalMoneyLable.text = [NSString stringWithFormat:@"%.2f", floor(model.investingMoney *100) / 100];
        double moneyRestMoney = floor(model.member.accountCash.useMoney * 100)/100;
        self.restMoneyLable.text = [NSString stringWithFormat:@"%.2f", moneyRestMoney];
        if (floor(model.member.accountCash.useMoney * 100)/100 >= 1000000.00) {// >100万，字体24，否字体32
            _restMoneyLable.font = [UIFont fontWithName:FontOfAttributed size:24];
        }else {
            _restMoneyLable.font = [UIFont fontWithName:FontOfAttributed size:32];
        }
        if ([_restMoneyLable.text isEqualToString:@"0.00"]) { // 可用余额为0，不能提现
            _restMoneyButton.enabled = YES;
            [_restMoneyButton setBackgroundColor:[UIColor colorWithRed:0.89 green:0.89 blue:0.89 alpha:1.00]];
        }else  {
            _restMoneyButton.enabled = YES;
            [_restMoneyButton setBackgroundColor:[CMCore basic_red1_color]];
        }
        NSString *headImageUrl = model.member.headImageUrl;
        [_iconImageView sd_setImageWithURL:[NSURL URLWithString:headImageUrl] placeholderImage:[UIImage imageNamed:@"default_personal"]];
//        [_iconImageView sd_setImageWithURL:[NSURL URLWithString:headImageUrl]  placeholderImage:[UIImage imageNamed:@"default_personal"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//            if (image == nil) {
//                _iconImageView.image = [UIImage imageNamed:@"default_personal"];
//            }else {
//                _iconImageView.image = image;
//            }
//        }];
        NSString *vipNum = @"";
        vipNum = [NSString stringWithFormat:@"%@", model.memberVip.level.rank];
        if (vipNum.length == 1) {
//            _vipLbale.text = @"";// [@"Lv" stringByAppendingString:vipNum];
        }else {
//            _vipLbale.text = @"";//@"Lv0";
        }
        NSString *str = model.member.mobilePhone;
        NSString *first = [str stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
        self.phoneLable.text = first;
        NSString *userName = model.member.realname;
        if (userName.length > 1) {
           userName = [userName stringByReplacingCharactersInRange:NSMakeRange(1, 1) withString:@"*"];
            _hgImageLeadContraint.constant = 12;
        }else {
            _hgImageLeadContraint.constant = 0;
        }
        self.nameLable.text = userName;
        
        
        NSString *vipDescription = @"普通会员";
        switch (model.member.memberVipEntity.level) {
            case 100:
                vipDescription = @"普通会员";
                break;
            case 200:
                vipDescription = @"普通会员";
                break;
            case 300:
                vipDescription = @"VIP会员";
                break;
            case 400:
                vipDescription = @"SVIP会员";
                break;
            default:
                break;
        }
        
        self.vipImageLabel.text = vipDescription;
    }
}

@end




