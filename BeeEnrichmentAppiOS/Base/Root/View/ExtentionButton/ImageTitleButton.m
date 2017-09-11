//
//  ImageTitleButton.m
//  BeeEnrichmentAppiOS
//
//  Created by hwm on 16/11/10.
//  Copyright © 2016年 didai. All rights reserved.
//

#import "ImageTitleButton.h"

@implementation ImageTitleButton

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame: frame]) {
        self.titleLabel.textColor = [UIColor colorWithHex:@"#818181"];
        self.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:14];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.imageView.wm_centerX = self.wm_width / 2;
    self.imageView.wm_width = 50;
    self.imageView.wm_height = 50;
    
    self.titleLabel.wm_x = 0;
    self.titleLabel.wm_y = self.imageView.wm_bottom;
    self.titleLabel.wm_width = self.wm_width;
    self.titleLabel.wm_height = self.wm_height - self.imageView.wm_y;
}


@end
