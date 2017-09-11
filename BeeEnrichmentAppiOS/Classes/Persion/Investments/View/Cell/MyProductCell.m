//
//  MyProductCell.m
//  BeeEnrichmentAppiOS
//
//  Created by dll on 15/12/24.
//  Copyright © 2015年 didai. All rights reserved.
//

#import "MyProductCell.h"

@interface MyProductCell ()
@property (strong, nonatomic) IBOutlet UILabel *all_money;
@property (strong, nonatomic) IBOutlet UILabel *benjin_money;
@property (strong, nonatomic) IBOutlet UILabel *shouyi_money;
@property (strong, nonatomic) IBOutlet UILabel *title;
@property (strong, nonatomic) IBOutlet UILabel *buy_time;
@property (strong, nonatomic) IBOutlet UIProgressView *progressView;
@property (strong, nonatomic) IBOutlet UILabel *restOfDayLabel;
@property (strong, nonatomic) IBOutlet UILabel *statusLabel;


@end
@implementation MyProductCell


- (void)awakeFromNib {
    [super awakeFromNib];
    _progressView.layer.cornerRadius = 3;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

- (void)setModelOld:(NSDictionary *)modelOld {
    _modelOld = modelOld;
    NSDictionary *dic = nil;
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
            total_money_actual = [modelOld[@"total_money"] doubleValue];//[modelOld[@"total_money_actual"] doubleValue];
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

-(void)setModel:(BeePlanModel *)model
{
    _model = model;
    ProductsDetailModel *dic =  nil;
    NSInteger status;
    if (model.beePlan.title != nil) {
        dic = model.beePlan;
    }else {
        dic = model.subject;
    }
    status = model.status;
    double expectedIncome = 0,totalMoneyActual = 0;
    if (model.totalMoney) {
        totalMoneyActual = model.totalMoney;
        expectedIncome = model.expectedIncome;
    } else {
        totalMoneyActual = model.order.totalMoney;
        expectedIncome = floor(model.order.expectedIncome * 100) / 100;
    }
    int allMoney = (totalMoneyActual * 100  + expectedIncome * 100);
    
    self.all_money.text = [NSString stringWithFormat:@"%.2f", floor(allMoney) / 100];
    self.benjin_money.text = [NSString stringWithFormat:@"%.2f", floor(totalMoneyActual * 100) / 100];
    self.shouyi_money.text = [NSString stringWithFormat:@"%.2f", floor(expectedIncome * 100) / 100];
    self.buy_time.text = [NSString stringWithFormat:@"%@", [CMCore turnToDate:model.createTime]];
    self.title.text = [NSString stringWithFormat:@"%@", dic.title];
    // WAITING(-1, "等待"), CANCEL(0, "取消或作废"), FAIL(100, "下单失败"), SUCCESS(200, “募集中”), BEARING(201, "计息中"), CLOSE(300, “已兑付”), TRANSFERRING(399, "转让中"), TRANSFERRD(400, "已转让");
    if (status == 200) {
        if (model.beePlan.title != nil) {
            _statusLabel.text = @"投资成功";
            _statusLabel.textColor = [UIColor colorWithHex:@"#4ab1fa"];
        }else {
            _statusLabel.text = @"募集中";
            _statusLabel.textColor = [UIColor colorWithHex:@"#f95f53"];
        }
    } else if (status == 300) {
        if (model.beePlan.title != nil) {
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

- (void)timeCount:(BeePlanModel* )model
{
    ProductsDetailModel *dic =  nil;
    if (model.beePlan.title != nil) {
        dic = model.beePlan;
    } else {
        dic = model.subject;
    }
    CGFloat rete;
    self.restOfDayLabel.text = model.restDaysDescription;
    if (model.dayTotal) {
        rete = 1 - (double)model.restDays / (double)model.dayTotal;
    }else {
        rete = 1.0;
    }
    [_progressView layoutIfNeeded];
    [_progressView setProgress:rete animated:YES];
}


@end
