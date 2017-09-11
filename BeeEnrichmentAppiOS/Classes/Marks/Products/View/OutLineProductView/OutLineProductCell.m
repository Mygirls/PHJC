//
//  OutLineProductCell.m
//  BeeEnrichmentAppiOS
//
//  Created by dll on 16/2/25.
//  Copyright © 2016年 didai. All rights reserved.
//

#import "OutLineProductCell.h"

@interface OutLineProductCell ()
@property (strong, nonatomic) IBOutlet UIView *backViewA;
@property (strong, nonatomic) IBOutlet UIView *backViewB;
@property (strong, nonatomic) IBOutlet UIView *backViewC;
@property (strong, nonatomic) IBOutlet UILabel *day;
@property (strong, nonatomic) IBOutlet UILabel *benjin_money;
@property (strong, nonatomic) IBOutlet UILabel *shouyi_money;
@property (strong, nonatomic) IBOutlet UILabel *time_label;
@property (strong, nonatomic) IBOutlet UIImageView *status_pag_imgView;
@property (strong, nonatomic) IBOutlet UILabel *title;
@property (strong, nonatomic) IBOutlet UILabel *buy_time;
@property (strong, nonatomic) IBOutlet UILabel *finishLabel;
@end



@implementation OutLineProductCell

- (void)awakeFromNib {
    [super awakeFromNib];
    UIColor *color = [UIColor colorWithRed:0.89 green:0.89 blue:0.89 alpha:1.0];
    _backViewA.layer.borderColor = color.CGColor;
    _backViewB.layer.borderColor = color.CGColor;
    _backViewC.layer.borderColor = color.CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setModel:(NSDictionary *)model
{
    self.time_label.text = [NSString stringWithFormat:@"%@至%@",[model[@"order"][@"regular_start_time"] substringToIndex:10], [model[@"order"][@"regular_end_time"] substringToIndex:10]];
    self.buy_time.text = [NSString stringWithFormat:@"%@",model[@"order"][@"create_time"]];
    if (model[@"order"][@"interest"] == nil  || [model[@"order"][@"interest"] doubleValue] == 0) {
        self.shouyi_money.text =  [NSString stringWithFormat:@"%.02f",[model[@"order"][@"expected_income"] doubleValue]];
    }else {
        self.shouyi_money.text =  [NSString stringWithFormat:@"%.02f+%.02f",[model[@"order"][@"expected_income"] doubleValue], [model[@"order"][@"interest"] doubleValue]];
    }
//    self.shouyi_money.text =  [NSString stringWithFormat:@"%.02f",[model[@"order"][@"expected_income"] doubleValue]];
    self.benjin_money.text = [NSString stringWithFormat:@"%.02f",[model[@"order"][@"investment_amount"] doubleValue]];
    self.title.text = model[@"product"][@"title"];
    NSInteger status = [model[@"order"][@"status"] integerValue];
    NSString * image_name = @"";
    //预告100(此处不会出现) 可购买200 已售完300 计息中400 已兑付500
    if (status == 200) {
        image_name = @"v1_pag_jixizhong";
    }else if (status == 300)
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
    UIColor *color;
    if (!_isFinish) {
        //已购买
        NSInteger day = 0;
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *lastDate1 = [formatter dateFromString:[NSString stringWithFormat:@"%@",model[@"order"][@"regular_end_time"]]];
        NSTimeInterval count1 = [lastDate1 timeIntervalSince1970];
        NSTimeInterval count2 = [[NSDate date] timeIntervalSince1970];
        day = (count1 - count2) / (60 * 60 * 24);
        if (day >= 0) {
            if ((int)(count1 - count2) % (60 * 60 * 24) > 0) {
                day += 1;
            }
        }else
        {
            day = 0;
            //            cell.day.text = @"";
            //            cell.finishLabel.text = @"回款中";
        }
        self.day.text = [NSString stringWithFormat:@"%ld天后",(long)day];
        self.finishLabel.text = @"到期";
        color = [CMCore basic_color];
        self.title.textColor = [UIColor blackColor];
        
    }else
    {
        color = [UIColor grayColor];
        self.title.textColor = color;
        self.day.text = @"";
        self.finishLabel.text = @"已到期";
    }
    self.shouyi_money.textColor = color;
    self.benjin_money.textColor = color;
    self.day.textColor = color;
}

@end
