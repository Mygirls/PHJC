//
//  LoginButtonView.m
//  BeeEnrichmentAppiOS
//
//  Created by dll on 15/12/21.
//  Copyright © 2015年 didai. All rights reserved.
//

#import "LoginButtonView.h"

@implementation LoginButtonView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)setButtonIsenabled:(BOOL)isEnabled {
    if (isEnabled) {
        self.login_btn.alpha = 1.0;
        self.login_btn.enabled = YES;
    }else
    {
        self.login_btn.alpha = 0.5;
        self.login_btn.enabled = NO;
    }
}
- (void)setButtonTitle:(NSString *)title isShowAccessoryBtn:(BOOL)isShowAccessoryBtn {
    if (isShowAccessoryBtn) {
        _forget_password_btn.hidden = NO;
    }else
    {
        _forget_password_btn.hidden = YES;
    }
    [_login_btn setTitle:title forState:UIControlStateNormal];
}
@end
