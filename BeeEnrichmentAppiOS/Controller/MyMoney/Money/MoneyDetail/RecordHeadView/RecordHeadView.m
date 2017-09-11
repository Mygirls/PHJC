//
//  RecordHeadView.m
//  BeeEnrichmentAppiOS
//
//  Created by 杜龙龙 on 16/11/11.
//  Copyright © 2016年 LiuXiaoMin. All rights reserved.
//

#import "RecordHeadView.h"

@interface RecordHeadView()
@property (strong, nonatomic) IBOutlet UILabel *income;
@property (strong, nonatomic) IBOutlet UILabel *rate;
@property (strong, nonatomic) IBOutlet UILabel *principal;
@property (strong, nonatomic) IBOutlet UIImageView *markImageView;

@end

@implementation RecordHeadView

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

- (void)setDic:(NSDictionary *)dic
{
//    NSDictionary *dicData = [NSDictionary dictionary];
    NSDictionary *dicData = nil;
    if ([dic.allKeys containsObject:@"bpOrder"]) {
        _markImageView.image = [UIImage imageNamed:@"v1.7_beePlan_mark"];
    }
    if ([dic.allKeys containsObject:@"beePlan"] && [dic[@"beePlan"] allKeys].count > 0) {
        dicData = dic[@"beePlan"];
    }else {
        dicData = dic[@"subject"];
    }
    
    
    self.income.text = [NSString stringWithFormat:@"%.2f", [dic[@"expectedIncome"] doubleValue]];
    self.principal.text = [NSString stringWithFormat:@"%.2f", [dic[@"totalMoney"] doubleValue]];
    
    NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",dicData[@"expectedAnnualRate"]] attributes:@{NSFontAttributeName:[UIFont fontWithName:FontOfAttributed size:19]}];
    if ([dicData[@"addAnnualRate"] doubleValue] > 0) {
        NSMutableAttributedString *str3 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"+%@",dicData[@"addAnnualRate"] ] attributes:@{NSFontAttributeName:[UIFont fontWithName:FontOfAttributed size:14]}];
        [str1 appendAttributedString:str3];
    }
    self.rate.attributedText = str1;
}

@end
