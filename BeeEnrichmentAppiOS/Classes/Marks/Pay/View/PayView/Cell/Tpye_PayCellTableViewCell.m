//
//  Tpye_PayCellTableViewCell.m
//  BeeEnrichmentAppiOS
//
//  Created by dll on 17/3/6.
//  Copyright © 2017年 DuLonglong. All rights reserved.
//

#import "Tpye_PayCellTableViewCell.h"

@interface Tpye_PayCellTableViewCell()
@property (nonatomic, strong) UIButton *button;
@end

@implementation Tpye_PayCellTableViewCell
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)clickButton:(id)sender {
//    UIButton *btn = (UIButton *)sender;
//    if (btn.selected) {
//        _button = btn;
//        
//    }else {
//        _button.selected = NO;
//        btn.selected = YES;
//        _button = btn;
//    }
}

@end
