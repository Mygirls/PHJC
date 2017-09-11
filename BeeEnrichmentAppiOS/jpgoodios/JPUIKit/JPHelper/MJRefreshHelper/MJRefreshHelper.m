//
//  MJRefreshHelper.m
//  CallMe
//
//  Created by renpan on 15/3/10.
//  Copyright (c) 2015年 XiZhe. All rights reserved.
//




#import "MJRefreshHelper.h"

@implementation UIScrollView (MJRefreshHelper)

- (void)add_header_refresh_with_callback:(void (^)())block
{
    [self setMj_header:[MJRefreshNormalHeader headerWithRefreshingBlock:block] ];
}

- (void)add_footer_refresh_with_callback:(void (^)())block
{
    [self setMj_footer:[MJRefreshAutoNormalFooter footerWithRefreshingBlock:block] ];
}

- (void)stop_all_refresh
{
    [self.mj_header endRefreshing];
    [self.mj_footer endRefreshing];
}

- (void)stop_header_refresh
{
    [self.mj_header endRefreshing];
}

- (void)stop_footer_refresh
{
    [self.mj_footer endRefreshing];
}

- (void)start_header_refresh
{
    [self.mj_header beginRefreshing];
}

- (void)start_footer_refresh
{
    [self.mj_footer beginRefreshing];
}

- (void)hide_footer_refresh:(BOOL)hidden
{
    [self.mj_footer setHidden:hidden];
}

//- (void)config_header_refresh_with_pull_down_string:(NSString*)pull_down_string release_to_refresh_string:(NSString*)release_to_refresh_string loading_string:(NSString*)loading_string
//{
//    self.mj_header.updatedTimeHidden = YES;
//    [self.mj_header setTitle:pull_down_string forState:MJRefreshHeaderStateIdle];
//    [self.mj_header setTitle:release_to_refresh_string forState:MJRefreshHeaderStatePulling];
//    [self.mj_header setTitle:loading_string forState:MJRefreshHeaderStateRefreshing];
//}
//
//- (void)config_footer_refresh_with_pull_up_string:(NSString*)pull_up_string loading_more:(NSString*)loading_more no_more_data:(NSString*)no_more_data
//{
//    self.mj_footer.automaticallyRefresh = NO;
//    [self.mj_footer setTitle:pull_up_string forState:MJRefreshFooterStateIdle];
//    [self.mj_footer setTitle:loading_more forState:MJRefreshFooterStateRefreshing];
//    [self.mj_footer setTitle:no_more_data forState:MJRefreshFooterStateNoMoreData];
//}
@end
