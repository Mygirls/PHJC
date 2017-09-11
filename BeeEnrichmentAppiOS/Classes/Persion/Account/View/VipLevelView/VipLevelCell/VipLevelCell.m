//
//  VipLevelCell.m
//  BeeEnrichmentAppiOS
//
//  Created by dll on 16/6/24.
//  Copyright © 2016年 didai. All rights reserved.
//

#import "VipLevelCell.h"
//#import "VipProgressView.h"
#import "LevelSlider.h"
@interface VipLevelCell ()
@property (strong, nonatomic) IBOutlet  LevelSlider*slider;
@property (strong, nonatomic) IBOutlet UIView *bottomLine;
@property (strong, nonatomic) IBOutlet UILabel *vipLabel;
@property (nonatomic, assign) NSInteger alreadyNum;
@property (nonatomic, assign) NSInteger selectedNum;
@property (nonatomic, assign) CGFloat pg;
@end
@implementation VipLevelCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _slider.userInteractionEnabled = false;
    //    _sliderHeight.constant = 0.5;
//    _bottomLineHeight.constant = 1.5;
    //    _slider.enabled = false;
    // Initialization code
}
- (void)setVipLevelWithNum:(NSInteger)num alreadyArriveNum:(NSInteger)alreadyArriveNum progress:(CGFloat)progress selectedNum:(NSInteger)selectedNum isLast:(BOOL)isLast {
    
    _pg = progress;
    _alreadyNum = alreadyArriveNum;
    _selectedNum = selectedNum;
    CGFloat alpha = 0, fontSize1 = 0, fontSize2 = 0, theProgress = 0;
    UIColor *color = [UIColor whiteColor];
    _bottomLine.hidden = YES;
    if (num == _selectedNum) {
        // 选中变大的值v1
        fontSize1 = 28;
        fontSize2 = 21;
        _bottomLine.hidden = NO;
    }
    if (alreadyArriveNum == num) {
        //设置当前vip等级
        alpha = 1.00;
        theProgress = progress;
        color = [UIColor colorWithRed:0.99 green:0.93 blue:0.64 alpha:1.00];
    }else
        if (num - 1 == alreadyArriveNum) {
            alpha = 0.55;
        }else if (num < alreadyArriveNum) {
            alpha = 1.0;
            theProgress = 1;
        }else if (num != _alreadyNum)
        {
            alpha = 0.25;
        }
    //默认状态的值 v1
    fontSize1 = fontSize1>0?fontSize1:19;
    fontSize2 = fontSize2>0?fontSize2:16;
    [self setLabelWithFontSize:fontSize1 fontSize2:fontSize2 color:color num:num alpha:alpha];
    [self setLineWithProgress:theProgress];
    if (isLast) {
        _slider.hidden = YES;
    }else
    {
        _slider.hidden = NO;
    }
}
- (void)setLineWithProgress:(CGFloat)progress// alpha:(CGFloat)alpha
{
    if (progress>0 && progress<1) {
        [_slider setThumbImage:[UIImage imageNamed:@"v1_vip_progress_point"] forState:UIControlStateNormal];
    }else
    {
        [_slider setThumbImage:[UIColor image_with_color:[UIColor clearColor]] forState:UIControlStateNormal];
    }
    _slider.value = progress;
    
}
- (void)setLabelWithFontSize:(CGFloat)fontSize1 fontSize2:(CGFloat)fontSize2 color:(UIColor*)color num:(NSInteger)num alpha:(CGFloat)alpha{
    NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc] initWithString:@"V" attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica-BoldOblique" size:fontSize1], NSForegroundColorAttributeName:color}];
    NSMutableAttributedString *str2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld",(long)num] attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica-BoldOblique" size:fontSize2], NSForegroundColorAttributeName:color}];
    [str1 appendAttributedString:str2];
    _vipLabel.alpha = alpha;
    _bottomLine.alpha = alpha;
    _bottomLine.backgroundColor = color;
    _vipLabel.attributedText = str1;
}
@end
