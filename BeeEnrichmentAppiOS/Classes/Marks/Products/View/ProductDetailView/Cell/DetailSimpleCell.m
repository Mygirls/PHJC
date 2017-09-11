//
//  DetailSimpleCell.m
//  BeeEnrichmentAppiOS
//
//  Created by dll on 16/11/2.
//  Copyright © 2016年 didai. All rights reserved.
//

#import "DetailSimpleCell.h"
#import "PHColorConfigure.h"
@implementation DetailSimpleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
   

}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.title.textColor = PHDefalutBlack_color;
    self.content.textColor = PHDefalutBlack_color;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
