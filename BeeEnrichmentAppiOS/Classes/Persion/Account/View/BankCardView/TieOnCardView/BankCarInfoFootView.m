//
//  BankCarInfoFootView.m
//  BeeEnrichmentAppiOS
//
//  Created by hwm on 16/11/15.
//  Copyright © 2016年 didai. All rights reserved.
//

#import "BankCarInfoFootView.h"

@implementation BankCarInfoFootView

- (void)awakeFromNib {
    [super awakeFromNib];
    _isAgreeBtn.selected = YES;
}

// click是否同意
- (IBAction)isAgreeBtn:(id)sender {
    if (_BankCarInfoFootViewClick) {
        _BankCarInfoFootViewClick(1);
    }
}
// click注册
- (IBAction)clickRegisterBtn:(id)sender {
    if (_BankCarInfoFootViewClick) {
        _BankCarInfoFootViewClick(3);
    }
}
// click协议
- (IBAction)clickProtocolBtn:(id)sender {
    if (_BankCarInfoFootViewClick) {
        _BankCarInfoFootViewClick(2);
    }
}
#pragma mark 设置按钮 可用／不可用
- (void)setButtonIsenabled:(BOOL)isEnabled {
    if (isEnabled) {
        self.registerBtn.enabled = YES;
        [self.registerBtn setBackgroundColor:[UIColor colorWithHex:@"#f95f53"]];
    }else
    {
        self.registerBtn.enabled = NO;
        [self.registerBtn setBackgroundColor:[UIColor colorWithHex:@"#cccccc"]];
    }
}

@end
