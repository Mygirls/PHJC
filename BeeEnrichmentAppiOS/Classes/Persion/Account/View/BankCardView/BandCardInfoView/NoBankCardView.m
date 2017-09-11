//
//  NoBankCardView.m
//  BeeEnrichmentAppiOS
//
//  Created by dll on 16/5/16.
//  Copyright © 2016年 didai. All rights reserved.
//

#import "NoBankCardView.h"

@interface NoBankCardView ()
//@property (strong, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIButton *BackBtn;
@property (weak, nonatomic) IBOutlet UIImageView *addImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@end
@implementation NoBankCardView
-(void)awakeFromNib
{
    [super awakeFromNib];
    _BackBtn.layer.borderColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1.0].CGColor;
    _BackBtn.layer.borderWidth = 0.3;
    _BackBtn.layer.cornerRadius = 4;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goAddBanCard)];
    [_addImageView addGestureRecognizer:tap];
}
- (IBAction)clickAddBankCardAction:(id)sender {
    if (self.clickButtonBlock) {
        self.clickButtonBlock();
    }
}
- (void)goAddBanCard {
    if (self.clickButtonBlock) {
        self.clickButtonBlock();
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight * 0.28);
    _addImageView.frame = CGRectMake(self.wm_width / 2 - self.addImageView.wm_width/2, self.wm_height / 6, 0, 0);
    [_addImageView sizeToFit];
    _titleLable.center = CGPointMake(_addImageView.wm_centerX, _addImageView.wm_bottom + _titleLable.wm_height);
    
}

@end
