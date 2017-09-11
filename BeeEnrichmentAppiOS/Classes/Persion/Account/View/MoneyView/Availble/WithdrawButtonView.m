//
//  WithdrawButtonView.m
//  BeeEnrichmentAppiOS
//
//  Created by dll on 15/12/24.
//  Copyright © 2015年 didai. All rights reserved.
//

#import "WithdrawButtonView.h"

@implementation WithdrawButtonView

// 投资记录
- (IBAction)clickInvestmentRecordBtn:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"InvestmentRecord" object:nil];
}

@end
