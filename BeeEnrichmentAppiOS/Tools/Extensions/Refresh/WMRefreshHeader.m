//
//  WMRefreshHeader.m
//  test
//
//  Created by hwm on 17/2/15.
//  Copyright © 2017年 didai. All rights reserved.
//

#import "WMRefreshHeader.h"

@interface WMRefreshHeader ()

@property (nonatomic, strong) UIImageView *logo;

@end

@implementation WMRefreshHeader

- (void)prepare {
    [super prepare];
    self.ignoredScrollViewContentInsetTop = -5;
    self.lastUpdatedTimeLabel.hidden = NO;
    self.stateLabel.hidden = NO;
    [self setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
    [self setTitle:@"松手立即刷新" forState:MJRefreshStatePulling];
    [self setTitle:@"正在刷新" forState:MJRefreshStateRefreshing];
    [self setTitle:@"刷新完成" forState:MJRefreshStateNoMoreData];

}

@end
