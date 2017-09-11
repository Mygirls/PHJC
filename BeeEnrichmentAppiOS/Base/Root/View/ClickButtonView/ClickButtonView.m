//
//  ClickButtonView.m
//  CarMirrorAppiOS
//
//  Created by dll on 15/9/18.
//  Copyright (c) 2015年 HangZhouShangFu. All rights reserved.
//
#define kTopInset 45
#define kButtonHeight 44
#define kSpace 20
#import "ClickButtonView.h"

@implementation ClickButtonView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#pragma mark 设置button可用／不可用
- (void)set_button_disabled
{
    self.click_button.alpha = 0.5;
    self.click_button.enabled = NO;
}
- (void)set_button_enabled
{
    self.click_button.alpha = 1.0;
    self.click_button.enabled = YES;
}

@end
