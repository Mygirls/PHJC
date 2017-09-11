//
//  MyProductCell.m
//  BeeEnrichmentAppiOS
//
//  Created by LiuXiaoMin on 15/12/24.
//  Copyright © 2015年 LiuXiaoMin. All rights reserved.
//

#import "MyProductCell.h"

@interface MyProductCell ()
@property (strong, nonatomic) IBOutlet UILabel *all_money;
@property (strong, nonatomic) IBOutlet UILabel *benjin_money;
@property (strong, nonatomic) IBOutlet UILabel *shouyi_money;
@property (strong, nonatomic) IBOutlet UILabel *time_label;
@property (strong, nonatomic) IBOutlet UIImageView *status_pag_imgView;
@property (strong, nonatomic) IBOutlet UILabel *title;
@property (strong, nonatomic) IBOutlet UILabel *buy_time;
@property (strong, nonatomic) IBOutlet UIImageView *finishImageView;

@property (strong, nonatomic) IBOutlet UIProgressView *progressView;
@property (strong, nonatomic) IBOutlet UILabel *restOfDayLabel;

@property (strong, nonatomic) IBOutlet UILabel *statusLabel;


@end
@implementation MyProductCell


- (void)awakeFromNib {
    [super awakeFromNib];
    _progressView.layer.cornerRadius = 3;
    //    _progressView.layer.borderColor = [UIColor colorWithHex:@"#e1e1e1"].CGColor;
    //    _progressView.layer.borderWidth = 0.5;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

-(void)setModel:(NSDictionary *)model
{
    NSDictionary *dic =  nil;
    NSInteger status;
            if ([model.allKeys containsObject:@"beePlan"] && [model[@"beePlan"] allKeys].count > 0) {
            dic = model[@"beePlan"];
        }else {
            dic = model[@"subject"];
        }
        status = [model[@"status"] integerValue];
        if (model) {
            double expectedIncome = 0,totalMoneyActual = 0;
            if (model[@"totalMoney"]) {
                totalMoneyActual = [model[@"totalMoney"] doubleValue];
                expectedIncome = [model[@"expectedIncome"] doubleValue];
            } else {
                totalMoneyActual = [model[@"order"][@"totalMoney"] doubleValue];
                expectedIncome = [model[@"order"][@"expectedIncome"] doubleValue];
            }
            int allMoney = (totalMoneyActual *100  + expectedIncome *100);
            
            self.all_money.text = [NSString stringWithFormat:@"%.2f", floor(allMoney) / 100];
            self.benjin_money.text = [NSString stringWithFormat:@"%.2f", floor(totalMoneyActual * 100) / 100];
            self.shouyi_money.text = [NSString stringWithFormat:@"%.2f", floor(expectedIncome * 100) / 100];
            self.buy_time.text = [NSString stringWithFormat:@"%@", [CMCore turnToDate:model[@"createTime"]]];
            self.title.text = [NSString stringWithFormat:@"%@", dic[@"title"]];
            // WAITING(-1, "等待"), CANCEL(0, "取消或作废"), FAIL(100, "下单失败"), SUCCESS(200, “募集中”), BEARING(201, "计息中"), CLOSE(300, “已兑付”), TRANSFERRING(399, "转让中"), TRANSFERRD(400, "已转让");
            if (status == 200) {
                if ([model.allKeys containsObject:@"beePlan"] && [model[@"beePlan"] allKeys].count > 0) {
                    _statusLabel.text = @"投资成功";
                    _statusLabel.textColor = [UIColor colorWithHex:@"#4ab1fa"];
                }else {
                    _statusLabel.text = @"募集中";
                    _statusLabel.textColor = [UIColor colorWithHex:@"#f95f53"];
                }
            } else if (status == 300) {
                if ([model.allKeys containsObject:@"beePlan"] && [model[@"beePlan"] allKeys].count > 0) {
                    _statusLabel.text = @"已兑付";
                    _statusLabel.textColor = [UIColor colorWithHex:@"#444444"];
                }else {
                    _statusLabel.text = @"已回款";
                }
            }else if (status == 201) {
                [self timeCount:model];
                _statusLabel.text = @"计息中";
                _statusLabel.textColor = [UIColor colorWithHex:@"#ff9600"];
            }else if (status == 500) {
                _statusLabel.text = @"已回款";
                _statusLabel.textColor = [UIColor colorWithHex:@"#444444"];
            } else if (status == 399) {
                _statusLabel.text = @"转让中";
                _statusLabel.textColor = [UIColor colorWithHex:@"#ff9600"];
            } else if (status == 400){
                _statusLabel.text = @"已转让";
                _statusLabel.textColor = [UIColor colorWithHex:@"#444444"];
            }
        }

    
}

- (void)timeCount:(NSDictionary* )model
{
    NSDictionary *dic =  nil;
    if ([model.allKeys containsObject:@"beePlan"] && [model[@"beePlan"] allKeys].count > 0) {
        dic = model[@"beePlan"];
    } else {
        dic = model[@"subject"];
    }
    
    CGFloat rete;
    double units = [dic[@"units"] doubleValue];
    
    if ([dic[@"repaymentId"] doubleValue] == 200) {
        self.restOfDayLabel.text = [NSString stringWithFormat:@"%@", model[@"restMonthDescription"]];
        
        rete = 1 - [model[@"restMonthLimits"] doubleValue] / [dic[@"period"] doubleValue];
    } else {
        if (units == 2) {
            
            self.restOfDayLabel.text = [NSString stringWithFormat:@"%@", model[@"restMonthDescription"]];
            rete = 1 - [model[@"restMonthLimits"] doubleValue] / [dic[@"period"] doubleValue];

        }else {
            self.restOfDayLabel.text = [NSString stringWithFormat:@"%@", model[@"restDaysDescription"]];
            rete = 1 - [model[@"restDays"] doubleValue] / [dic[@"period"] doubleValue];
        }
    
    }
    [_progressView layoutIfNeeded];
    [_progressView setProgress:rete animated:YES];
}

-(void)setModelOld:(NSDictionary *)modelOld
{
    //    NSDictionary *dic = [NSDictionary dictionary];
    _modelOld = modelOld;
    NSDictionary *dic =  nil;
    NSInteger status;
    if ([modelOld.allKeys containsObject:@"bee_plan"]) {
        dic = modelOld[@"bee_plan"];
        status = [modelOld[@"status"] integerValue];
    }else {
        dic = modelOld[@"subject"];
        status = [dic[@"status"] integerValue];
    }
    if (modelOld) {
        //        double total_money=0;
        double expected_income=0,total_money_actual=0;
        if (modelOld[@"total_money"]) {
            //            total_money = [model[@"total_money"] doubleValue];
            total_money_actual = [modelOld[@"total_money_actual"] doubleValue];
            expected_income = [modelOld[@"expected_income"] doubleValue];
        }else
        {
            //            total_money = [model[@"order"][@"total_money"] doubleValue];
            total_money_actual = [modelOld[@"order"][@"total_money_actual"] doubleValue];
            expected_income = [modelOld[@"order"][@"expected_income"] doubleValue];
        }
        self.all_money.text = [NSString stringWithFormat:@"%.2f",total_money_actual + expected_income];
        self.benjin_money.text = [NSString stringWithFormat:@"%.2f",total_money_actual];
        self.shouyi_money.text = [NSString stringWithFormat:@"%.2f",expected_income];
        self.buy_time.text = [NSString stringWithFormat:@"%@",modelOld[@"create_time"]];
        self.title.text = [NSString stringWithFormat:@"%@",dic[@"title"]];
        
        
        //预告100(此处不会出现) 可购买200 已售完300 计息中400 已兑付500
        if (status == 200) {
            if ([modelOld.allKeys containsObject:@"bee_plan"]) {
                _statusLabel.text = @"投资中";
                _statusLabel.textColor = [UIColor colorWithHex:@"#4ab1fa"];
            }else {
                _statusLabel.text = @"募集中";
                _statusLabel.textColor = [UIColor colorWithHex:@"#f95f53"];
            }
        }else if (status == 300)
        {
            if ([modelOld.allKeys containsObject:@"bee_plan"]) {
                _statusLabel.text = @"已回款";
                _statusLabel.textColor = [UIColor colorWithHex:@"#444444"];
            }else {
                _statusLabel.text = @"已售完";
            }
        }else if (status == 400)
        {
            [self timeCountOld:modelOld];
            _statusLabel.text = @"计息中";
            _statusLabel.textColor = [UIColor colorWithHex:@"#ff9600"];
        }else if (status == 500)
        {
            _statusLabel.text = @"已回款";
            _statusLabel.textColor = [UIColor colorWithHex:@"#444444"];
        }
        if ([modelOld[@"status"] doubleValue] == 399) {
            _statusLabel.text = @"转让中";
            _statusLabel.textColor = [UIColor colorWithHex:@"#ff9600"];
        } else if ([modelOld[@"status"] doubleValue] == 400) {
            _statusLabel.text = @"已转让";
            _statusLabel.textColor = [UIColor colorWithHex:@"#444444"];
        }
    }
}

- (void)timeCountOld:(NSDictionary* )model
{
    
    NSDictionary *dic =  nil;
    if ([model.allKeys containsObject:@"bee_plan"]) {
        dic = model[@"bee_plan"];
    }else{
        dic = model[@"subject"];
    }
    
    CGFloat f;
    if ([dic[@"month_limit"] intValue]) {
        self.restOfDayLabel.text = [NSString stringWithFormat:@"还剩%@期", model[@"rest_month_limits"]];
        f = 1 - [model[@"rest_month_limits"] doubleValue] / [dic[@"month_limit"] doubleValue];
    }else {
        self.restOfDayLabel.text = model[@"rest_days_description"];
        f = 1 - [model[@"rest_days"] doubleValue] / [dic[@"time_limit"] doubleValue];
    }
    [_progressView layoutIfNeeded];
    [_progressView setProgress:f animated:YES];
}



@end
