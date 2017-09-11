//
//  ProOfHeadView.m
//  BeeEnrichmentAppiOS
//
//  Created by dll on 16/11/2.
//  Copyright © 2016年 didai. All rights reserved.
//

#import "ProOfHeadView.h"
#import "PHProgressView.h"
#import "PHColorConfigure.h"
@interface ProOfHeadView()
@property (strong, nonatomic) IBOutlet UIProgressView *pgView;

@property (strong, nonatomic) IBOutlet UILabel *time_limit;//周期
@property (strong, nonatomic) IBOutlet UILabel *minOfMoney;//起购金额
@property (strong, nonatomic) IBOutlet UILabel *investOfMoney;//可投金额
@property (strong, nonatomic) IBOutlet UILabel *lilv_year;//利率
@property (strong, nonatomic) IBOutlet UILabel *days_remaining;
@property (strong, nonatomic) IBOutlet UILabel *money;
@property (strong, nonatomic) IBOutlet UILabel *money_and_interest;
@property (strong, nonatomic) IBOutlet UILabel *total_count;//项目总额
@property (strong, nonatomic) IBOutlet UILabel *invest_lable;//投资期限标题

@property (strong, nonatomic) IBOutlet UILabel *rate;
@property (nonatomic, strong) NSTimer  *timer;

@property (nonatomic, assign) CGFloat f;
@end

@implementation ProOfHeadView

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)setDic:(ProductsDetailModel *)dic
{
    _dic = dic;
//    DLog(@"%ld", (long)dic.repaymentId);
    if (dic.repaymentId == 200) {
        if (dic.marketType == 30) {
            self.time_limit.text = @"";
        }else {
            if (dic.units == 1) {
                self.time_limit.text = [NSString stringWithFormat:@"%zd",dic.Period];
                self.invest_lable.text = @"投资期限(天)";
            }else {
                self.time_limit.text = [NSString stringWithFormat:@"%zd", dic.Period];
                self.invest_lable.text = @"投资期限(月)";
            }
        }
    }else {
        if (dic.marketType == 30) {
            self.time_limit.text = @"";
        }else {
            if (dic.units == 1) {
                self.time_limit.text = [NSString stringWithFormat:@"%zd", dic.Period];
                self.invest_lable.text = @"投资期限(天)";
            }else {
                self.time_limit.text = [NSString stringWithFormat:@"%zd", dic.Period];
                self.invest_lable.text = @"投资期限(月)";
            }
            
        }
    }
    if (dic.marketType == 30) {
        double parentMoney = floor(dic.parentMoney * 100) / 100;
        double currentMoney = floor(dic.currentMoney * 100) / 100;
        self.minOfMoney.text = [NSString stringWithFormat:@"%zd元起投", dic.purchaseMinAmount];
        self.investOfMoney.text = [NSString stringWithFormat:@"￥%.2f/￥%.2f", currentMoney, parentMoney];
        _f = (parentMoney - currentMoney) / parentMoney;
    }else {
        double financingAmount = floor(dic.financingAmount * 100) / 100;
        double remainingAmount = floor(dic.remainingAmount * 100) / 100;
        self.minOfMoney.text = [NSString stringWithFormat:@"%zd", dic.purchaseMinAmount];
        self.investOfMoney.text = [NSString stringWithFormat:@"剩余可投金额 %.f", remainingAmount];
        self.total_count.text = [NSString stringWithFormat:@"%.f",financingAmount];
        _f = (financingAmount - remainingAmount) / financingAmount;
        
        PHProgressView *progressLineView = [[PHProgressView alloc]initWithFrame:CGRectMake(0, 268  - 64 - 5, kScreenWidth, 20)];
        [self addSubview: progressLineView];
        progressLineView.progressPercentage = _f;
        progressLineView.progressHeight = 4;
        progressLineView.progressViewType = ProgressViewNotAllGradient;
        [progressLineView progressShow];
        
    }
    self.rate.text = [NSString stringWithFormat:@"%d%%", (int)(_f * 100)];
    [self setAnnualRateWithDic:dic];
    
    //转让标：
    if (dic.marketType == 30) {
        if (dic.repaymentId ==100) {
            //  一次性到期还本付息到账户余额, 暂时只支持这个, 其他的还没做好
            _days_remaining.text = [NSString stringWithFormat: @"%zd天",dic.extra.daysRemaining];
        }else if (dic.repaymentId == 200){
            _days_remaining.text = [NSString stringWithFormat: @"%zd天", dic.extra.daysRemaining];
            // 每月还息到期还本
        }else if (dic.repaymentId ==300){
            //等额每月还本息, 暂不支持这个
            _days_remaining.text = [NSString stringWithFormat: @"%@月", dic.extra.restTerms];
        }else{
            // 特殊处理, 以 package 为准
            _days_remaining.text = [NSString stringWithFormat: @"%zd天", dic.extra.daysRemaining];
        }
        
        _money.text = [self countNumAndChangeformat:[NSString stringWithFormat: @"%.2f元", floor(dic.extra.money * 100) / 100]];
        _money_and_interest.text = [self countNumAndChangeformat:[NSString stringWithFormat:@"%.2f元", floor(dic.extra.moneyAndInterest * 100) / 100]];
    }
    
    
}

#pragma mark 产品年化利率
- (void)setAnnualRateWithDic:(ProductsDetailModel *)dic
{
    NSString *expectedRateStr = [NSString stringWithFormat:@"%.2f",dic.expectedAnnualRate];
    NSString *addRateStr = [NSString stringWithFormat:@"+%.2f",dic.addAnnualRate];
    if (dic.marketType == 30) {
         NSString *cusRateStr = [NSString stringWithFormat:@"%.2f",dic.actualAnnualRate];
        NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc] initWithString:[CMCore clearZeroWithString:cusRateStr] attributes:@{NSFontAttributeName:[UIFont fontWithName:FontOfAttributed size:32]}];
        NSMutableAttributedString *str2 = [[NSMutableAttributedString alloc] initWithString:@"%" attributes:@{NSFontAttributeName:[UIFont fontWithName:FontOfAttributed size:19]}];
        
        [str1 appendAttributedString:str2];
//        self.lilv_year.adjustsFontSizeToFitWidth = YES;
        self.lilv_year.attributedText = str1;
    }else{
        NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc] initWithString:[CMCore clearZeroWithString:expectedRateStr] attributes:@{NSFontAttributeName:[UIFont fontWithName:FontOfAttributed size:60]}];
        NSMutableAttributedString *str2 = [[NSMutableAttributedString alloc] initWithString:@"%" attributes:@{NSFontAttributeName:[UIFont fontWithName:FontOfAttributed size:32]}];
        if (dic.addAnnualRate > 0) {
            NSMutableAttributedString *str3 = [[NSMutableAttributedString alloc] initWithString:[CMCore clearZeroWithString:addRateStr] attributes:@{NSFontAttributeName:[UIFont fontWithName:FontOfAttributed size:32]}];
            NSMutableAttributedString *str4 = [[NSMutableAttributedString alloc] initWithString:@"%" attributes:@{NSFontAttributeName:[UIFont fontWithName:FontOfAttributed size:32]}];
            [str2 appendAttributedString:str3];
            [str2 appendAttributedString:str4];
        }
        [str1 appendAttributedString:str2];
        self.lilv_year.attributedText = str1;
    }
}

- (IBAction)headBtnClickAction:(UIButton *)sender {
    if (self.headBtnClickCallBack) {
        self.headBtnClickCallBack(sender.tag);
    }
}

- (IBAction)showAlertOfQuestion:(id)sender {
    [[JPAlert current] showAlertWithTitle:@"承接价格是指原债权持有人根据个人意愿自行设置的价格，差价出让本金±5‰之间" button:@[@"我知道了"]];
}

#pragma mark - 添加分割逗号

-(NSString *)countNumAndChangeformat:(NSString *)num
{
    NSMutableString *tempStr = num.mutableCopy;
    NSRange range = [num rangeOfString:@"."];
    NSInteger index = 0;
    if (range.length > 0) {
        index = range.location;
    }else {
        index = num.length;
    }
    while ((index - 3) > 0) {
        index-=3;
        [tempStr insertString:@"," atIndex:index];
    }
    return tempStr;
}

@end
