//
//  RegisterButtonView.m
//  BeeEnrichmentAppiOS
//
//  Created by dll on 15/12/21.
//  Copyright © 2015年 didai. All rights reserved.
//

#import "RegisterButtonView.h"

@implementation RegisterButtonView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#pragma mark 设置按钮 可用／不可用
- (void)setButtonIsenabled:(BOOL)isEnabled {
    if (isEnabled) {
        self.sure_button.alpha = 1.0;
        self.sure_button.enabled = YES;
    }else
    {
        self.sure_button.alpha = 0.5;
        self.sure_button.enabled = NO;
    }
}
- (void)setPropertyButtonHidden:(BOOL)hidden {
    if (hidden) {
        self.property_description_label.hidden = YES;
        self.property_button.hidden = YES;
        self.is_agree_button.hidden = YES;
    }
}

@end
