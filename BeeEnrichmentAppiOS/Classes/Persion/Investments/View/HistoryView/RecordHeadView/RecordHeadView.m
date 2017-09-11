//
//  RecordHeadView.m
//  BeeEnrichmentAppiOS
//
//  Created by dll on 16/11/11.
//  Copyright © 2016年 didai. All rights reserved.
//

#import "RecordHeadView.h"

@interface RecordHeadView()
@property (strong, nonatomic) IBOutlet UILabel *income;
@property (strong, nonatomic) IBOutlet UILabel *rate;
@property (strong, nonatomic) IBOutlet UILabel *principal;
@property (strong, nonatomic) IBOutlet UIImageView *markImageView;

@end

@implementation RecordHeadView

- (void)setDic:(BeePlanModel *)dic
{
    _dic = dic;
    ProductsDetailModel *dicData = nil;
    if (dic.bpOrder != nil) {
        _markImageView.image = [UIImage imageNamed:@"v1.7_beePlan_mark"];
    }
    if (dic.beePlan.expectedAnnualRate) {
        dicData = dic.beePlan;
    }else {
        dicData = dic.subject;
    }
    double expectedIncome = 0,totalMoneyActual = 0;
    if (dic.totalMoney) {
        totalMoneyActual = dic.totalMoney;
        expectedIncome = floor(dic.expectedIncome * 100) / 100;
    } else {
        totalMoneyActual = dic.order.totalMoney;
        expectedIncome = floor(dic.order.expectedIncome *100) / 100;
    }
    
    self.income.text = [NSString stringWithFormat:@"%.2f", expectedIncome];
    self.principal.text = [NSString stringWithFormat:@"%.2f", totalMoneyActual];
    
    NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.1f",dicData.expectedAnnualRate] attributes:@{NSFontAttributeName:[UIFont fontWithName:FontOfAttributed size:19]}];
    if (dicData.addAnnualRate > 0) {
        NSMutableAttributedString *str3 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"+%.2f",dicData.addAnnualRate] attributes:@{NSFontAttributeName:[UIFont fontWithName:FontOfAttributed size:14]}];
        [str1 appendAttributedString:str3];
    }
    self.rate.attributedText = str1;
}

- (void)setDicOld:(NSDictionary *)dicOld {
    _dicOld = dicOld;
    NSDictionary *dicData = nil;
    if ([dicOld.allKeys containsObject:@"bp_order"] && [dicOld[@"bp_order"] allKeys].count > 0) {
        _markImageView.image = [UIImage imageNamed:@"v1.7_bee_plan_mark"];
    }
    if ([dicOld.allKeys containsObject:@"bee_plan"]) {
        dicData = dicOld[@"bee_plan"];
    }else {
        dicData = dicOld[@"subject"];
    }
    self.income.text = [NSString stringWithFormat:@"%.2f", [dicOld[@"expected_income"] doubleValue]?:[dicOld[@"order"][@"expected_income"] doubleValue]];
    self.principal.text = [NSString stringWithFormat:@"%.2f", [dicOld[@"total_money"] doubleValue]?:[dicOld[@"order"][@"total_money"] doubleValue]];
    
    NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",dicData[@"expected_annual_rate"]] attributes:@{NSFontAttributeName:[UIFont fontWithName:FontOfAttributed size:19]}];
    if ([dicData[@"add_annual_rate"] doubleValue] > 0) {
        NSMutableAttributedString *str3 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"+%@",dicData[@"add_annual_rate"]] attributes:@{NSFontAttributeName:[UIFont fontWithName:FontOfAttributed size:14]}];
        [str1 appendAttributedString:str3];
    }
    self.rate.attributedText = str1;
}

@end
