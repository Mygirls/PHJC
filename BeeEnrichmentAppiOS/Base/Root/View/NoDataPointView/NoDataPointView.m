//
//  NoDataPointView.m
//  JuCaiEmployee
//
//  Created by dll on 16/3/20.
//  Copyright © 2016年 HangZhouShangFu. All rights reserved.
//

#import "NoDataPointView.h"

@interface NoDataPointView ()

@property (strong, nonatomic) IBOutlet UIImageView *noDataImageView;
@property (strong, nonatomic) IBOutlet UILabel *detailLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topContraints;

@end



@implementation NoDataPointView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)awakeFromNib
{    [super awakeFromNib];

    _clickButton.layer.borderColor = [CMCore basic_color].CGColor;
    _topContraints.constant = (kScreenHeight - 64 - 44) *59 / 559;
}

- (void)set_title:(NSString *)title detailTitle:(NSString *)detailTitle buttonTitle:(NSString *)buttonTitle isShowButton:(BOOL)isShowButton imageName:(NSString *)imageName
{
    _label.text = title;
    _detailLabel.text = detailTitle;
    if (imageName.length > 0) {
       _noDataImageView.image = [UIImage imageNamed:imageName];
    }else
    {
        _noDataImageView.hidden = YES;
    }
    
    if (isShowButton) {
        _clickButton.hidden = NO;
        [_clickButton setTitle:buttonTitle forState:UIControlStateNormal];
    }else
    {
        _clickButton.hidden = YES;
        
    }
    
}
- (IBAction)clickButtonAction:(id)sender {
    if (self.clickButtonBlock) {
        self.clickButtonBlock();
    }
}
@end
