//
//  ExperienceMoneyView.m
//  BeeEnrichmentAppiOS
//
//  Created by dll on 16/11/15.
//  Copyright © 2016年 didai. All rights reserved.
//

#import "ExperienceMoneyView.h"

@interface ExperienceMoneyView()
@property (strong, nonatomic) IBOutlet UILabel *expMoneyLabel;
@property (strong, nonatomic) IBOutlet UILabel *rateLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *incomeLabel;
@property (strong, nonatomic) IBOutlet UILabel *statusLabel;



@end

@implementation ExperienceMoneyView

-(void)awakeFromNib
{
    [super awakeFromNib];
    
}

-(void)setDic:(BeePlanModel *)dic
{
    _dic = dic;
    ProductsDetailModel *dicData = [ProductsDetailModel new];
    if (dic.beePlan.fullTime != nil) {
        dicData = dic.beePlan;
    }else {
        dicData = dic.subject;
    }
    
    _expMoneyLabel.text = [NSString stringWithFormat:@"%zd", dic.coupon.Value];
    
    NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.2f",dicData.expectedAnnualRate] attributes:@{NSFontAttributeName:[UIFont fontWithName:FontOfAttributed size:19]}];
    if (dicData.addAnnualRate > 0) {
        NSMutableAttributedString *str3 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"+%.2f",dicData.addAnnualRate] attributes:@{NSFontAttributeName:[UIFont fontWithName:FontOfAttributed size:14]}];
        [str1 appendAttributedString:str3];
    }
    self.rateLabel.attributedText = str1;
    NSString *begin, *end, *_experienceMoney, *_experienceTitle;
    NSInteger experienceDay = 0;
    CGFloat lilv;
    experienceDay = dic.coupon.condition.maxBuyDays;
    
    begin = dicData.fullTime;
    NSDateFormatter *dateFomatter = [[NSDateFormatter alloc] init];
    dateFomatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSTimeInterval poor = experienceDay *24 *60 *60;
    NSDate *date = [[dateFomatter dateFromString:begin] dateByAddingTimeInterval:poor];
    end = [dateFomatter stringFromDate:date];
    
    begin = [begin stringByReplacingOccurrencesOfString:@"-" withString:@"."];
    end = [end stringByReplacingOccurrencesOfString:@"-" withString:@"."];
    _timeLabel.text = [NSString stringWithFormat:@"%@-%@", [begin substringToIndex:10], [end substringToIndex:10]];
    
    
    if (dicData.addAnnualRate > 0) {
        lilv = dicData.addAnnualRate + dicData.expectedAnnualRate;
    }else {
        lilv = dicData.expectedAnnualRate;
    }
    _experienceMoney = [NSString stringWithFormat:@"%.2f", lilv / 100 / 365 * experienceDay * dic.coupon.Value];
    
    _experienceTitle = [NSString stringWithFormat:@"%zd天收益%@元", experienceDay, _experienceMoney];
    
    NSMutableAttributedString *str0 = [[NSMutableAttributedString alloc] initWithString:_experienceTitle attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:@"#444444"], NSFontAttributeName:[UIFont fontWithName:FontOfAttributed size:14]}];
    NSInteger len = [_experienceTitle length];
    [str0 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:@"#fd5353"] range:NSMakeRange(len - 1 - _experienceMoney.length, _experienceMoney.length)];
    _incomeLabel.attributedText = str0;
    
    NSInteger status = dicData.status;
    //预告100(此处不会出现) 可购买200 已售完300 计息中400 已兑付500
    if (status == 200) {
        _statusLabel.text = @"募集中";
        _statusLabel.textColor = [UIColor colorWithHex:@"#f95f53"];
        _timeLabel.text = @"募集中";
    }else if (status == 300)
    {
        _statusLabel.text = @"已售完";
    }else if (status == 400)
    {
        _statusLabel.text = @"计息中";
        _statusLabel.textColor = [UIColor colorWithHex:@"#ffb54c"];
    }else if (status == 500)
    {
        _statusLabel.text = @"已回款";
        _statusLabel.textColor = [UIColor colorWithHex:@"#444444"];
    }
    
}

- (IBAction)click_cancel:(id)sender {
    [self removeFromSuperview];
}

@end
