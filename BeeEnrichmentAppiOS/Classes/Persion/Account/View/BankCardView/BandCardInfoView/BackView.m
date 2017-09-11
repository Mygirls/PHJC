//
//  BackView.m
//  BeeEnrichmentAppiOS
//
//  Created by dll on 16/1/4.
//  Copyright © 2016年 didai. All rights reserved.
//

#import "BackView.h"
//static BOOL is_first_set = YES;
@implementation BackView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self set_bank_backView];
    
}

- (void)get_bankList
{
    //获取银行卡列表
    [CMCore get_bank_list_with_is_alert:YES blockResult:^(NSNumber *code, id result, NSString *message) {
        if (result) {
            [CMCore save_bank_list_info:result];
            [self set_bank_backView];
        }
    } blockRetry:^(NSInteger index) {
        
        if (index == 1) {
            [self get_bankList];
        }
    }];
}

- (void)set_bank_backView
{
//    BOOL isHaveColors = NO;
    NSString *bank_title = [CMCore get_bank_card_info][@"bankTitle"];
    CAGradientLayer *lay = [CAGradientLayer layer];
    if (![CMCore get_bank_list]) {
        [self get_bankList];
    }else
    {
       

        for (NSDictionary *dic in [CMCore get_bank_list]) {
            
            if ([dic[@"title"] rangeOfString:bank_title].location != NSNotFound) {
                NSString *top_color =[NSString stringWithFormat:@"%@",dic[@"gradientTop"]];
                NSArray *top_ary = [top_color componentsSeparatedByString:@","];
                NSString *bottom_color = [NSString stringWithFormat:@"%@",dic[@"gradient_bottom"]];
                NSArray *bottom_ary = [bottom_color componentsSeparatedByString:@","];
                if (top_ary.count == 4 && bottom_ary.count == 4) {
                    
                    lay.colors = @[(id)[UIColor colorWithRed:[top_ary[1] doubleValue] / 255.0 green:[top_ary[2] doubleValue] / 255.0 blue:[top_ary[3] doubleValue] / 255.0 alpha:[top_ary[0] doubleValue]].CGColor,(id)[UIColor colorWithRed:[bottom_ary[1] doubleValue] / 255.0 green:[bottom_ary[2] doubleValue] / 255.0 blue:[bottom_ary[3] doubleValue] / 255.0 alpha:[bottom_ary[0] doubleValue]].CGColor];
                }
//                isHaveColors = YES;
                break;
            }
        }
    }
  //  if (!isHaveColors) {
        UIColor *color1 = [UIColor colorWithRed:0.98 green:0.44 blue:0.36 alpha:1.00];
        UIColor *color2 = [UIColor colorWithRed:0.96 green:0.28 blue:0.15 alpha:1.00];
        lay.colors = @[(id)color1.CGColor,(id)color2.CGColor];
 //   }
    lay.startPoint = CGPointMake(0, 0);
    lay.endPoint = CGPointMake(1.0, 1.0);
    lay.frame = self.bounds;
    lay.cornerRadius = 5;
    [self.layer insertSublayer:lay atIndex:0];
}






@end
