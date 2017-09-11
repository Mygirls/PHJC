//
//  BankCardCell.m
//  BeeEnrichmentAppiOS
//
//  Created by dll on 15/12/27.
//  Copyright © 2015年 didai. All rights reserved.
//

#import "BankCardCell.h"

@implementation BankCardCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}
- (void)setModel:(BankCardsModel *)model
{
    self.title.text = model.title ? model.title : model.bankTitle;
    NSString *card = model.bankCardId;
    self.bank_type.text = @"借记卡";
    card = [card stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *result_str = [NSString stringWithFormat:@"%@",[card substringFromIndex:card.length - 4]];
    self.bank_card.text = result_str;
}
-(void)setBank_basic_info:(BankCardsModel *)bank_basic_info
{
    [self.logo_imgView sd_setImageWithURL:[NSURL URLWithString:bank_basic_info.logoUrl] placeholderImage:[UIImage imageNamed:@"v1_bank_logo"]];
    self.title.text = bank_basic_info.title;
    self.one_money.text = @"";//[NSString stringWithFormat:@"单笔%.02f万",[bank_basic_info.singleLimit doubleValue] / 10000.0];
    self.day_money.text = @"";//[NSString stringWithFormat:@"每日%.02f万",[bank_basic_info.dailyLimit doubleValue] / 10000.0];
    self.month_money.text = @"";//[NSString stringWithFormat:@"每月%.02f万",[bank_basic_info.monthlyLimit doubleValue] / 10000.0];
}

@end
