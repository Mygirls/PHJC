//
//  ProductCell.m
//  BeeEnrichmentAppiOS
//
//  Created by dll on 15/12/23.
//  Copyright © 2015年 didai. All rights reserved.
//

#import "ProductCell.h"
#import "DottedLineView.h"
#define kEnabledColor [CMCore basic_color]
#define kDisabledColor [UIColor colorWithRed:0.63 green:0.63 blue:0.63 alpha:1]
@interface ProductCell ()


@end


@implementation ProductCell

- (void)setModel:(ProductsDetailModel *)model

{
    _model = model;
    if (model) {
        DottedLineView * vieww = [[DottedLineView alloc]initWithFrame:CGRectMake(15, 45,kScreenWidth - 30,  1)];
        [self addSubview:vieww];
        vieww.backgroundColor = [UIColor whiteColor];
    }
    self.title.text = model.title;
    if (model.marketType == 30) {
        self.qixian.text =[NSString stringWithFormat:@"天期限"];
        if (model.repaymentId == 300){
            self.time_limit.text = [NSString stringWithFormat: @"%@", model.extra.restTerms];
        }else{
            self.time_limit.text = [NSString stringWithFormat: @"%zd", model.extra.daysRemaining];
        }
    }else {
        self.time_limit.text = [NSString stringWithFormat:@"%zd",model.Period];
        if (model.units == 1) {
            self.qixian.text =[NSString stringWithFormat:@"天期限"];
        }else {
            self.qixian.text =[NSString stringWithFormat:@"月期限"];
        }
    }
    _starsType.text = [NSString stringWithFormat:@""];
    
    if (model.marketType == 30) {
        NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc] initWithString:[CMCore clearZeroWithString:[NSString stringWithFormat:@"%.2f",model.actualAnnualRate]] attributes:@{NSFontAttributeName:[UIFont fontWithName:FontOfAttributed size:32]}];
        NSMutableAttributedString *str2 = [[NSMutableAttributedString alloc] initWithString:@"%" attributes:@{NSFontAttributeName:[UIFont fontWithName:FontOfAttributed size:19]}];
        
        [str1 appendAttributedString:str2];
        self.lilv_year.attributedText = str1;
        NSInteger status = model.status;

        switch (status) {
            case 100:
                _starsType.text = [NSString stringWithFormat:@"进行中"];
                _starsType.textColor = [UIColor colorWithHex:@"#ffb54c"];
                break;
            case 200:
                _starsType.text = [NSString stringWithFormat:@"已完成"];
                _starsType.textColor = [UIColor colorWithHex:@"#949494"];
                break;
            default:
                break;
                
        }

        
    }else{
        NSString *expectedRateStr = [NSString stringWithFormat:@"%.2f",model.expectedAnnualRate];
        NSString *addRateStr = [NSString stringWithFormat:@"+%.2f",model.addAnnualRate];
        NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc] initWithString:[CMCore clearZeroWithString:expectedRateStr] attributes:@{NSFontAttributeName:[UIFont fontWithName:FontOfAttributed size:32]}];
        NSMutableAttributedString *str2 = [[NSMutableAttributedString alloc] initWithString:@"%" attributes:@{NSFontAttributeName:[UIFont fontWithName:FontOfAttributed size:19]}];
        if (model.addAnnualRate > 0) {
            NSMutableAttributedString *str3 = [[NSMutableAttributedString alloc] initWithString:[CMCore clearZeroWithString:addRateStr] attributes:@{NSFontAttributeName:[UIFont fontWithName:FontOfAttributed size:19]}];
            [str2 appendAttributedString:str3];
        }
        [str1 appendAttributedString:str2];
        self.lilv_year.attributedText = str1;
     
        NSInteger status = model.status;
        if (model.marketType == 10) {
            switch (status) {
                case 100:
                    //预告100
                    _starsType.text = [NSString stringWithFormat:@""];
                    break;
                case 300:
                    _starsType.text = [NSString stringWithFormat:@"已兑付"];
                    _starsType.textColor = [UIColor colorWithHex:@"#676767"];
                    break;
                    
                case 400:
                    _starsType.text = [NSString stringWithFormat:@"募集中"];
                    _starsType.textColor = [UIColor colorWithHex:@"#ffb54c"];
                    break;
                    
                case 500:
                    _starsType.text = [NSString stringWithFormat:@"已售完"];
                    _starsType.textColor = [UIColor colorWithHex:@"#676767"];
                    break;
                default:
                    break;
            }
        }else {
            switch (status) {
                case 100:
                    //预告100
                    _starsType.text = [NSString stringWithFormat:@""];
                    break;
                case 300:
                    _starsType.text = [NSString stringWithFormat:@"已售完"];
                    _starsType.textColor = [UIColor colorWithHex:@"#676767"];
                    break;
                    
                case 400:
                    _starsType.text = [NSString stringWithFormat:@"计息中"];
                    _starsType.textColor = [UIColor colorWithHex:@"#ffb54c"];
                    break;
                    
                case 500:
                    _starsType.text = [NSString stringWithFormat:@"已兑付"];
                    _starsType.textColor = [UIColor colorWithHex:@"#676767"];
                    //已售完300//计息中400//已兑付500
                    break;
                default:
                    _starsType.text = [NSString stringWithFormat:@"匹配中"];
                    break;
            }
        }
        
        
    }
  
    
}
- (BOOL)modelContainsRightIconWithModel:(NSDictionary*)model
{
    //服务器端自定义右边的icon
    NSString *right_tag_icon = model[@"rightTagIcon"];
    if (right_tag_icon && right_tag_icon.length > 0) {
//        [self.status_imgView sd_setImageWithURL:[NSURL URLWithString:right_tag_icon] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//            self.status_imgView.image = image;
//        }];
        return YES;
    }else
    {
        return NO;
    }
}
- (void)setLilvYearWithColor:(UIColor*)color model:(NSDictionary*)model
{
   }

@end
