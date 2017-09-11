//
//  MyRedPacketsCell.m
//  BeeEnrichmentAppiOS
//
//  Created by hwm on 16/10/13.
//  Copyright © 2016年 didai. All rights reserved.
//

#import "MyRedPacketsCell.h"
#import "PackageModel.h"

@interface MyRedPacketsCell ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *moneyLeadingConstraint;

@end

@implementation MyRedPacketsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _renMinBiLable.text = @"￥";
}

- (void)setModel:(PackageModel *)model {
    _model = model;
    if (model) {
        NSInteger type = model.type;
        if (type == 10) {// 加息券
            self.contentTextLable.hidden = YES;
            self.titleTopConstrant.constant = 20;
            self.outdataTopConstraint.constant = 5;
            _moneyLeadingConstraint.constant = -17;
            _renMinBiLable.hidden = YES;
            
            _moneyLable.attributedText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%%",  model.value] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:31]}];

        }else {// 其他券
            _moneyLeadingConstraint.constant = -5;
            self.contentTextLable.hidden = NO;
            self.titleTopConstrant.constant = 14;
            self.outdataTopConstraint.constant = 16;
           
            NSString *BottomText = [[NSString alloc] init];
            if (type == 40) {// 体验金
                BottomText = [NSString stringWithFormat:@"购买金额满%.2f元以上可用\n%ld天体验期限",model.condition.minBuyMoney, (long)model.condition.maxBuyDays];
                NSMutableAttributedString *stringReta1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", model.value] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:32]}];
                
                NSMutableAttributedString *stringReta2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥"]  attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19]}];
                [stringReta2 appendAttributedString:stringReta1];
                _moneyLable.attributedText = stringReta2;
            }else  if (type == 20) {//抵扣券
                BottomText = [NSString stringWithFormat:@"购买金额满%.2f元以上可用",model.condition.minBuyMoney];
                NSMutableAttributedString *stringReta1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", model.value] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:32]}];
                
                NSMutableAttributedString *stringReta2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥"]  attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19]}];
                [stringReta2 appendAttributedString:stringReta1];
                _moneyLable.attributedText = stringReta2;
            }else  if (type == 30) {// 红包
                BottomText = [NSString stringWithFormat:@"购买金额满%.2f元以上\n并且融资期限满%zd天以上可用",model.condition.minBuyMoney,model.condition.maxBuyDays];
                NSMutableAttributedString *stringReta1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", model.value] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:40]}];
                
                NSMutableAttributedString *stringReta2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥"]  attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:25]}];
                [stringReta2 appendAttributedString:stringReta1];
                _moneyLable.attributedText = stringReta2;
            }
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:BottomText];;
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
            [paragraphStyle setLineSpacing:2];
            [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, BottomText.length)];
            self.contentTextLable.attributedText = attributedString;
        }
        
        if (kScreenWidth <=320) {
            _moneyLable.font = [UIFont systemFontOfSize:27];
        }
        
        self.timeLable.text = [NSString stringWithFormat:@"有效期至 %@", [CMCore turnToDate:model.condition.endTime]];
        NSString *str = model.title;
        if (str.length) {
            _title_lable.text = model.title;
        }else {
            _title_lable.text = @"  ";
        }
        if (!_model.used) {
            _outDataImageView.image = [UIImage imageNamed:@"v1.5_package_outdate"];
        }else {
            _outDataImageView.image = [UIImage imageNamed:@"v1.5_package_used"];
        }
    }
}

@end
