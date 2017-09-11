//
//  LevelSlider.m
//  BeeEnrichmentAppiOS
//
//  Created by dll on 16/6/29.
//  Copyright © 2016年 didai. All rights reserved.
//

#import "LevelSlider.h"

@implementation LevelSlider

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (CGRect)trackRectForBounds:(CGRect)bounds
{
    return CGRectMake(0, 0, self.bounds.size.width, 1);
}
- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setMinimumTrackImage:[UIColor image_with_color:[UIColor whiteColor]] forState:UIControlStateNormal];
    [self setMaximumTrackImage:[UIColor image_with_color:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.3]] forState:UIControlStateNormal];
}
@end
