//
//  JPNavigationBar.m
//  ShiHang
//
//  Created by renpan on 14/10/17.
//  Copyright (c) 2014年 xizhe. All rights reserved.
//

#import "JPNavigationBar.h"

@interface JPNavigationBar ()
@property (nonatomic, strong) UIView *overlay;
@end

@implementation JPNavigationBar

- (void)lt_setBackgroundColor:(UIColor *)backgroundColor
{
    if (!self.overlay) {
        [self setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        self.overlay = [[UIView alloc] initWithFrame:CGRectMake(0, -20, kScreenWidth, CGRectGetHeight(self.bounds) + 20)];
        self.overlay.userInteractionEnabled = NO;
        self.overlay.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [self insertSubview:self.overlay atIndex:0];
    }
    self.overlay.backgroundColor = backgroundColor;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self lt_setBackgroundColor:[[UINavigationBar appearance] barTintColor]];
}


@end
