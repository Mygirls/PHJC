//
//  PayButtonView.m
//  BeeEnrichmentAppiOS
//
//  Created by dll on 16/2/19.
//  Copyright © 2016年 didai. All rights reserved.
//

#import "PayButtonView.h"

@implementation PayButtonView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)setButtonIsenabled:(BOOL)isEnabled {
    if (isEnabled) {
        self.sure_button.alpha = 1.0;
        self.sure_button.backgroundColor = [UIColor colorWithHex:@"#F95F53"];
        self.sure_button.enabled = YES;
    }else
    {
        self.sure_button.alpha = 1;
        self.sure_button.backgroundColor = [UIColor colorWithHex:@"#cccccc"];
        self.sure_button.enabled = NO;
    }
}
- (IBAction)c:(id)sender {
    
    NSLog(@"zhifu");
}
@end
