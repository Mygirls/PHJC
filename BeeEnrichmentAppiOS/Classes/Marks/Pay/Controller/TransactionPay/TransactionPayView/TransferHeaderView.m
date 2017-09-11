//
//  TransferHeaderView.m
//  BeeEnrichmentAppiOS
//
//  Created by dll on 16/12/13.
//  Copyright © 2016年 didai. All rights reserved.
//

#import "TransferHeaderView.h"

@interface TransferHeaderView()
//@property (nonatomic, strong) NSDictionary *dataDic;
@property (strong, nonatomic) IBOutlet UIProgressView *pgView;
@property (strong, nonatomic) IBOutlet UILabel *restTimeLimit;
@property (strong, nonatomic) IBOutlet UILabel *timeLimit;//周期
@property (strong, nonatomic) IBOutlet UILabel *minOfMoney;//起购金额
@property (strong, nonatomic) IBOutlet UILabel *investOfMoney;//可投金额
@property (strong, nonatomic) IBOutlet UILabel *lilv_year;//利率
@property (strong, nonatomic) IBOutlet UILabel *rate;
@property (nonatomic, strong) NSTimer  *timer;
@property (nonatomic, assign) CGFloat f;
@property (nonatomic, assign) int day;
@property (strong, nonatomic) IBOutlet UILabel *titleName;
@property (nonatomic, strong) CAGradientLayer *gradientLayer;
@end

@implementation TransferHeaderView

- (void)awakeFromNib
{
    [super awakeFromNib];
    _pgView.layer.masksToBounds = YES;
    _pgView.layer.cornerRadius = 3;
//    _pgView.layer.borderColor = [UIColor colorWithHex:@"#e1e1e1"].CGColor;
//    _pgView.layer.borderWidth = 0.5;
    //实现背景渐变
    //初始化CAGradientlayer对象，使它的大小为UIView的大小
    self.gradientLayer = [CAGradientLayer layer];
    self.gradientLayer.frame = self.redBackView.bounds;
    //将CAGradientlayer对象添加在我们要设置背景色的视图的layer层
    [self.redBackView.layer insertSublayer:self.gradientLayer atIndex:0];
    
    //设置渐变区域的起始和终止位置（范围为0-1）
    self.gradientLayer.startPoint = CGPointMake(0, 0);
    self.gradientLayer.endPoint = CGPointMake(1, 1);
    
    //设置颜色数组
    self.gradientLayer.colors = @[(__bridge id)[UIColor colorWithHex:@"#f95f53"].CGColor,
                                  (__bridge id)[UIColor colorWithHex:@"#ff7357"].CGColor];
    
    //设置颜色分割点（范围：0-1）
    self.gradientLayer.locations = @[@(0.5f), @(1.0f)];
    
    
}

- (void)setDic:(ProductsDetailModel *)dic
{
    _dic = dic;
    self.titleName.text = dic.title;
    
    if (dic.repaymentId ==100) {
        //  一次性到期还本付息到账户余额, 暂时只支持这个, 其他的还没做好
        self.restTimeLimit.text = [NSString stringWithFormat:@"%zd", dic.extra.daysRemaining];
        
    }else if (dic.repaymentId ==200){
        self.restTimeLimit.text = [NSString stringWithFormat:@"%zd", dic.extra.daysRemaining];
        // 每月还息到期还本
    }else if (dic.repaymentId ==300){
        //等额每月还本息, 暂不支持这个
        self.restTimeLimit.text = [NSString stringWithFormat:@"%@", dic.extra.restTerms];
    }else{
        // 特殊处理, 以 package 为准
        self.restTimeLimit.text = [NSString stringWithFormat:@"%zd", dic.extra.daysRemaining];
    }
    [self setRestDaysWithText:self.restTimeLimit.text];

    
    NSInteger units = dic.units;
    
    if (units == 1) {
        self.timeLimit.text = [NSString stringWithFormat:@"%zd天投资周期",dic.Period];
    }else {
        self.timeLimit.text = [NSString stringWithFormat:@"%zd月投资周期",dic.Period];
    }
    
    double parentMoney = floor(dic.parentMoney * 100) / 100;
    double currentMoney = floor(dic.currentMoney * 100) / 100;
    
    self.minOfMoney.text = [NSString stringWithFormat:@"%ld元起投", (long)dic.purchaseMinAmount];
    self.inputTF.placeholder = self.minOfMoney.text;
    self.investOfMoney.text = [NSString stringWithFormat:@"￥%.2f/￥%.2f", currentMoney, parentMoney];
    
    _f = (parentMoney - currentMoney) / parentMoney;
    [_pgView layoutIfNeeded];
    [_pgView setProgress:_f animated:YES];
    self.rate.text = [NSString stringWithFormat:@"%.0f%%", _f * 100];
    [self setAnnualRateWithDic:dic];
}

#pragma mark 产品年化利率
- (void)setAnnualRateWithDic:(ProductsDetailModel *)dic
{
    NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc] initWithString:[CMCore clearZeroWithString:[NSString stringWithFormat:@"%.2f",dic.actualAnnualRate]] attributes:@{NSFontAttributeName:[UIFont fontWithName:FontOfAttributed size:32]}];
    NSMutableAttributedString *str2 = [[NSMutableAttributedString alloc] initWithString:@"%" attributes:@{NSFontAttributeName:[UIFont fontWithName:FontOfAttributed size:19]}];
    [str1 appendAttributedString:str2];
    self.lilv_year.attributedText = str1;
}

- (void)setRestDaysWithText:(NSString *)text
{
    NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",text] attributes:@{NSFontAttributeName:[UIFont fontWithName:FontOfAttributed size:32]}];
    if (_dic.repaymentId == 300){
        NSMutableAttributedString *str2 = [[NSMutableAttributedString alloc] initWithString:@"期" attributes:@{NSFontAttributeName:[UIFont fontWithName:FontOfAttributed size:19]}];
        [str1 appendAttributedString:str2];
    }else {
        NSMutableAttributedString *str2 = [[NSMutableAttributedString alloc] initWithString:@"天" attributes:@{NSFontAttributeName:[UIFont fontWithName:FontOfAttributed size:19]}];
        [str1 appendAttributedString:str2];
    }
    self.restTimeLimit.attributedText = str1;
}

- (IBAction)selectAll:(id)sender {
    /** 转让标的利息计算
     * 收益计算方式：
     * 单位：天
     * 年化 / 365 * 剩余天数（包含今天）* 购买金额 / 100
     * 单位：月
     * 年化 / 12 * 月(period) * 承接金额 / 周期（天）* 剩余天数 / 100*/
    
    _inputTF.text = [NSString stringWithFormat:@"%.2f", _dic.remainingAmount];
    _actualMoney.text = _inputTF.text;
    
    _expectMoney.text = [NSString stringWithFormat:@"%.2lf", [_inputTF.text doubleValue] * (_dic.expectedAnnualRate + _dic.addAnnualRate) / 100 / 365.0 * _dic.timeLimit];
}



@end
