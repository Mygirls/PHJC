//
//  ShareKindsView.m
//  BeeEnrichmentAppiOS
//
//  Created by dll on 16/3/2.
//  Copyright © 2016年 didai. All rights reserved.
//

#import "ShareKindsView.h"

@interface ShareKindsView ()
@property (weak, nonatomic) IBOutlet UIView *popView;

@end


@implementation ShareKindsView

- (IBAction)click_button_one:(id)sender {
    if (self.clickShareBlock) {
        self.clickShareBlock(0);
    }
}
- (IBAction)click_button_two:(id)sender {
    if (self.clickShareBlock) {
        self.clickShareBlock(1);
    }
}
- (IBAction)click_button_three:(id)sender {
    if (self.clickShareBlock) {
        self.clickShareBlock(2);
    }
}
- (IBAction)click_button_four:(id)sender {
}
- (IBAction)click_button_cancel:(id)sender {
    [self hidden];
}

- (void)show {
    self.frame = [UIScreen mainScreen].bounds;
    _popView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 0);
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        _popView.frame = CGRectMake(0, kScreenHeight - 164.5, kScreenWidth, 164.5);
    }];
}

- (void)hidden {
    [UIView animateWithDuration:0.3 animations:^{
        _popView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 164.5);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self hidden];
    
}

@end
