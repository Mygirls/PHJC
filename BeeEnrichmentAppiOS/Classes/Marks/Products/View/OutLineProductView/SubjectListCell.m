//
//  SubjectListCell.m
//  BeeEnrichmentAppiOS
//
//  Created by dll on 16/12/6.
//  Copyright © 2016年 didai. All rights reserved.
//

#import "SubjectListCell.h"

@interface SubjectListCell ()
@property (strong, nonatomic) IBOutlet UILabel *all_money;
@property (strong, nonatomic) IBOutlet UILabel *benjin_money;
@property (strong, nonatomic) IBOutlet UILabel *shouyi_money;
@property (strong, nonatomic) IBOutlet UILabel *time_label;
@property (strong, nonatomic) IBOutlet UIImageView *status_pag_imgView;
@property (strong, nonatomic) IBOutlet UILabel *title;
@property (strong, nonatomic) IBOutlet UILabel *buy_time;
@property (strong, nonatomic) IBOutlet UIImageView *finishImageView;
@end
@implementation SubjectListCell


- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
-(void)setModel:(NSDictionary *)model
{
//    double total_money=0;
    double expected_income=0,total_money_actual=0;
    if (model[@"total_money"]) {
//        total_money = [model[@"total_money"] doubleValue];
        total_money_actual = [model[@"total_money_actual"] doubleValue];
        expected_income = [model[@"expected_income"] doubleValue];
    }else
    {
//        total_money = [model[@"order"][@"total_money"] doubleValue];
        total_money_actual = [model[@"order"][@"total_money_actual"] doubleValue];
        expected_income = [model[@"order"][@"expected_income"] doubleValue];
    }
    self.all_money.text = [NSString stringWithFormat:@"%.2f",total_money_actual + expected_income];
    self.benjin_money.text = [NSString stringWithFormat:@"%.2f",total_money_actual];
    self.shouyi_money.text = [NSString stringWithFormat:@"%.2f",expected_income];
    self.buy_time.text = [NSString stringWithFormat:@"%@",model[@"create_time"]];
    self.title.text = [NSString stringWithFormat:@"%@",model[@"subject"][@"title"]];
    NSString *begin_time = [NSString stringWithFormat:@"%@",model[@"subject"][@"begin_time"]];
    NSString *end_time = [NSString stringWithFormat:@"%@",model[@"subject"][@"end_time"]];
    if(model[@"subject"][@"end_time"])
    {
        self.time_label.text = [NSString stringWithFormat:@"%@",[begin_time substringToIndex:10]];
    }
    else
    {
        self.time_label.text = [NSString stringWithFormat:@"%@至%@",[begin_time substringToIndex:10],[end_time substringToIndex:10]];
    }
    NSInteger status = [model[@"subject"][@"status"] integerValue];
    NSString * image_name = @"";
    //预告100(此处不会出现) 可购买200 已售完300 计息中400 已兑付500
    if (status == 200) {
        image_name = @"v1_pag_mojizhong";
    }else if (status == 300)
    {
        image_name = @"v1_pag_yishouwan";
    }else if (status == 400)
    {
        image_name = @"v1_pag_jixizhong";
    }else if (status == 500)
    {
        image_name = @"v1_pag_yiduifu";
    }
    if (image_name.length > 0) {
        self.status_pag_imgView.image = [UIImage imageNamed:image_name];
        self.status_pag_imgView.hidden = NO;
    }else
    {
        self.status_pag_imgView.hidden = YES;
    }
    
}

@end
