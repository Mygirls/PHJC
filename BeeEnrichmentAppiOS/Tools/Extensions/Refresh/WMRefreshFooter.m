//
//  WMRefreshFooter.m
//  BeeEnrichmentAppiOS
//
//  Created by hwm on 17/2/16.
//  Copyright © 2017年 didai. All rights reserved.
//

#import "WMRefreshFooter.h"

@implementation WMRefreshFooter

- (void)prepare{
    [super prepare];
    self.automaticallyHidden = YES;
    self.stateLabel.textColor = [CMCore basic_gray1_color];
    self.stateLabel.font = [UIFont fontWithName:FontOfAttributed size:13];
    [self setTitle:@"上拉加载更多" forState:MJRefreshStateIdle];
    [self setTitle:@"撒手加载..." forState:MJRefreshStatePulling];
    [self setTitle:@"正在加载..." forState:MJRefreshStateRefreshing];
}

@end
