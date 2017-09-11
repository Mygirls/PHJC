//
//  LTimerButton.m
//  BeeEnrichmentAppiOS
//
//  Created by dll on 16/6/30.
//  Copyright © 2016年 didai. All rights reserved.
//

#import "LTimerButton.h"

@interface LTimerButton ()
@property (nonatomic, strong)NSTimer *timerCoder;
@end
static int timeCount=60;

@implementation LTimerButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)startTimerWithCount:(int)count {
    [self stopTimer];
    NSString *title = [NSString stringWithFormat:@"%d秒后重发",count];
    [self setBtnTitle:title];
    [self buttonIsEnabled:NO];
    timeCount = count-1;
    _timerCoder = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeAction) userInfo:nil repeats:YES];
    
}
- (void)stopTimer {
    if (_timerCoder) {
        [_timerCoder invalidate];
        _timerCoder = nil;
        [self buttonIsEnabled:YES];
        NSString *title = @"重新发送";
        self.titleLabel.text = title;
        [self setTitle:title forState:UIControlStateNormal];
    }
}
- (void)timeAction {
    if (timeCount > 0) {
       NSString *title = [NSString stringWithFormat:@"%d秒后重发",timeCount];
        self.titleLabel.text = title;
        [self setTitle:title forState:UIControlStateNormal];
    }else
    {
        
        [self stopTimer];
    }
    timeCount -= 1;
}
- (void)setBtnTitle:(NSString *)title {
   [self setTitle:title forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage imageNamed:@"v1_buttonBackLineRed"] forState:UIControlStateNormal];
}
- (void)buttonIsEnabled:(BOOL)isEnabled {
    if (isEnabled) {
        [self setTitle:@"发送验证码" forState:UIControlStateNormal];
        self.userInteractionEnabled = YES;
        [self setBackgroundImage:[UIImage imageNamed:@"v1_buttonBackLineRed"] forState:UIControlStateNormal];
        [self setTitleColor:[CMCore basic_color] forState:UIControlStateNormal];
    }else
    {
        self.userInteractionEnabled = NO;
        [self setBackgroundImage:[UIImage imageNamed:@"v1_buttonBackLineGray"] forState:UIControlStateNormal];
        [self setTitleColor:[CMCore basic_color] forState:UIControlStateNormal];
    }
}


@end
