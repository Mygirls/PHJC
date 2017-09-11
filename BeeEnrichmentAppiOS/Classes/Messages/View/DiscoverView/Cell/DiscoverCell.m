//
//  DiscoverCell.m
//  BeeEnrichmentAppiOS
//
//  Created by dll on 16/8/4.
//  Copyright © 2016年 didai. All rights reserved.
//

#import "DiscoverCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "MessagesModel.h"

@implementation DiscoverCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.bgView.layer.borderColor = [CMCore basic_gray2_line_color].CGColor;
    self.contentImageView.layer.masksToBounds = YES;
}

- (void)setModel:(MessagesModel *)model
{
    if (model) {
//        self.aspect.constant = [model[@"size_proportion"] doubleValue];
        self.titleLabel.text = model.title;
        self.timeLabel.text = [[CMCore turnToDate:model.createTime] substringToIndex:10];
        [self.contentImageView sd_setImageWithURL:[NSURL URLWithString:model.imageUrl] placeholderImage:[UIImage imageNamed:@""]];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
