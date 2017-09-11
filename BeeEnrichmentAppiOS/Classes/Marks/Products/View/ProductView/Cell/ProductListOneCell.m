//
//  ProductListOneCell.m
//  BeeEnrichmentAppiOS
//
//  Created by MC on 2016/11/4.
//  Copyright © 2016年 didai. All rights reserved.
//

#import "ProductListOneCell.h"
#import "DottedLineView.h"

@interface ProductListOneCell ()
@property (weak, nonatomic) IBOutlet UILabel *dayTitle;
@property (weak, nonatomic) IBOutlet UIImageView *classImageView;

@end


@implementation ProductListOneCell

- (void)awakeFromNib {
    [super awakeFromNib];
    DottedLineView * vieww = [[DottedLineView alloc]initWithFrame:CGRectMake(15, 45, kScreenWidth - 30,  1)];
    [self addSubview:vieww];
    vieww.backgroundColor = [UIColor whiteColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
- (void)setModel:(ProductsDetailModel *)model
{
    _model = model;
    self.title.text = model.title;
    CGFloat rate = 0.0;
    if (model.marketType == 30) {
        self.dayTitle.text =[NSString stringWithFormat:@"天"];
        self.time_limit.text = [NSString stringWithFormat:@"%zd",model.extra.daysRemaining];
        rate = (1.0 - model.currentMoney / model.parentMoney);
    }else {
        self.time_limit.text = [NSString stringWithFormat:@"%zd",model.Period];
        if (model.financingAmount) {
            rate = (1.0 - model.remainingAmount / model.financingAmount);
        }
        if (model.units == 1) {
            self.dayTitle.text =[NSString stringWithFormat:@"天"];
        }else {
            self.dayTitle.text =[NSString stringWithFormat:@"月"];
        }
    }
    
    _classImageView.contentMode = UIViewContentModeCenter;
    
    _baifenbi = [[NSString stringWithFormat:@"%.2f", rate] doubleValue];
    _percentage.text = [NSString stringWithFormat:@"%d%%",(int)(rate *100)];
    [_ProgressView setProgress:_baifenbi animated:NO];
    NSString *lilvStr = [NSString stringWithFormat:@"%.2f",model.expectedAnnualRate];
    NSString *addLilvStr = [NSString stringWithFormat:@"%.2f",model.addAnnualRate];
    NSString *cusLilvStr = [NSString stringWithFormat:@"%.2f",model.actualAnnualRate];
    if (model.marketType == 30) {
        _remaining.text = [NSString stringWithFormat:@"剩余可承接债权:￥%.2f/￥%.2f", floor(model.currentMoney * 100) / 100 , floor(model.parentMoney * 100) / 100];
        NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", [CMCore clearZeroWithString: cusLilvStr]] attributes:@{NSFontAttributeName:[UIFont fontWithName:FontOfAttributed size:32]}];
        NSMutableAttributedString *str2 = [[NSMutableAttributedString alloc] initWithString:@"%" attributes:@{NSFontAttributeName:[UIFont fontWithName:FontOfAttributed size:19]}];
        
        [str1 appendAttributedString:str2];
        self.lilv_year.attributedText = str1;
        
        /////////     转让不用
        //        NSInteger subjectType = [model[@"subjectType"] integerValue];
        //        NSInteger status = [model[@"status"] integerValue];
        //        switch (status) {
        //            case 300:
        //            case 400:
        //            case 500:
        //                //已售完300//计息中400//已兑付500
        //                break;
        //            case 100:
        //                //预告100
        //               // _classImageView.image = [UIImage imageNamed:@"v1.7_trailer"];
        //                break;
        //            default:
        //                //定期200
        //                switch (subjectType) {
        //                    case 100:
        //                        //新人专享
        //                        _classImageView.image = [UIImage imageNamed:@"v1.7_newExclusive"];
        //                        _classImageView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-(_classImageView.frame.size.width+8.5),_classImageView.frame.origin.y, _classImageView.frame.size.width,_classImageView.frame.size.height);
        //                        break;
        //                    case 200:
        //                        //手机专享
        //                        _classImageView.image = [UIImage imageNamed:@"v1.7_phoneExclusive"];
        //                        _classImageView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-(_classImageView.frame.size.width+8.5),_classImageView.frame.origin.y, _classImageView.frame.size.width,_classImageView.frame.size.height);
        //                        break;
        //                    case 300:
        //                        //定向标
        //                        _classImageView.image = [UIImage imageNamed:@"V1.7_vipExclusive"];
        //                        _classImageView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-(_classImageView.frame.size.width+6),_classImageView.frame.origin.y, _classImageView.frame.size.width,_classImageView.frame.size.height);
        //                        break;
        //                    case 400:
        //
        //                        //普通标
        //                        _classImageView.image = [UIImage imageNamed:@""];
        //
        //                        break;
        //                    default:
        //                        _classImageView.image = [UIImage imageNamed:@""];
        //
        //                        break;
        //                }
        //        }
        
    }else{
        _remaining.text = [NSString stringWithFormat:@"剩余可投:￥%.2f/￥%.2f",model.remainingAmount ,model.financingAmount];
        NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",[CMCore clearZeroWithString: lilvStr] ] attributes:@{NSFontAttributeName:[UIFont fontWithName:FontOfAttributed size:32]}];
        NSMutableAttributedString *str2 = [[NSMutableAttributedString alloc] initWithString:@"%" attributes:@{NSFontAttributeName:[UIFont fontWithName:FontOfAttributed size:19]}];
        if (model.addAnnualRate > 0) {
            NSMutableAttributedString *str3 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"+%@%%", [CMCore clearZeroWithString: addLilvStr]] attributes:@{NSFontAttributeName:[UIFont fontWithName:FontOfAttributed size:19]}];
            [str2 appendAttributedString:str3];
        }
        [str1 appendAttributedString:str2];
        self.lilv_year.attributedText = str1;
        
        NSInteger subjectType = model.subjectType;
        NSInteger status = model.status;
        switch (status) {
            case 300:
            case 400:
            case 500:
                //已售完300//计息中400//已兑付500
                break;
            case 100:
                //预告100
                _classImageView.image = [UIImage imageNamed:@"v1.7_trailer"];
                _classImageView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-(_classImageView.frame.size.width-3),_classImageView.frame.origin.y, _classImageView.frame.size.width,_classImageView.frame.size.height);
                break;
            default:
                //定期200
                switch (subjectType) {
                    case 100:
                        //新人专享
                        _classImageView.image = [UIImage imageNamed:@"v1.7_newExclusive"];
                        _classImageView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-(_classImageView.frame.size.width+8.5),_classImageView.frame.origin.y, _classImageView.frame.size.width,_classImageView.frame.size.height);
                        break;
                    case 200:
                        //手机专享
                        _classImageView.image = [UIImage imageNamed:@"v1.7_phoneExclusive"];
                        _classImageView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-(_classImageView.frame.size.width+8.5),_classImageView.frame.origin.y, _classImageView.frame.size.width,_classImageView.frame.size.height);
                        break;
                    case 300:
                        //定向标
                        _classImageView.image = [UIImage imageNamed:@""];
                        break;
                    case 400:
                        
                        //普通标
                        _classImageView.image = [UIImage imageNamed:@""];
                        
                        break;
                    case 700:
                        
                        //VIP标
                        _classImageView.image = [UIImage imageNamed:@"V1.7_vipExclusive"];
                        _classImageView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-(_classImageView.frame.size.width+6),_classImageView.frame.origin.y, _classImageView.frame.size.width,_classImageView.frame.size.height);
                        
                        break;
                    case 800:
                        
                        //SVIP标
                        _classImageView.image = [UIImage imageNamed:@"SVIP_list_icon"];
                        _classImageView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-(_classImageView.frame.size.width-3),_classImageView.frame.origin.y, _classImageView.frame.size.width,_classImageView.frame.size.height);
                        
                        break;
                    case 900:
                        
                        _classImageView.image = [UIImage imageNamed:@""];
                        
                        break;
                        
                    default:
                        _classImageView.image = [UIImage imageNamed:@""];
                        
                        break;
                }
        }
        self.rightTopLabel.text = @"";
        if (model.marketType == 10 && status == 200) {
            if (model.isNewer == 1 && status != 100) {
                //新人专享
                _classImageView.image = [UIImage imageNamed:@"v1.7_newExclusive"];
                _classImageView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-(_classImageView.frame.size.width+8.5),_classImageView.frame.origin.y, _classImageView.frame.size.width,_classImageView.frame.size.height);
            }else {
                self.rightTopLabel.text = model.rightTopTitle;
                _classImageView.image = [UIImage imageNamed:@"market_bee_plan_free"];
                _classImageView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-(_classImageView.frame.size.width+8.5),_classImageView.frame.origin.y, _classImageView.frame.size.width,_classImageView.frame.size.height);
            }

        }
    }
}

@end
