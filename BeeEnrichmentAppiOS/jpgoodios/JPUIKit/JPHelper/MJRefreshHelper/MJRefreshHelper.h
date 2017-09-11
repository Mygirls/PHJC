//
//  MJRefreshHelper.h
//  CallMe
//
//  Created by renpan on 15/3/10.
//  Copyright (c) 2015年 XiZhe. All rights reserved.
//

#import "NSObject+JPNSObjectExtend.h"
#import <MJRefresh/MJRefresh.h>
#import <MJRefresh/UIView+MJExtension.h>

@interface UIScrollView (MJRefreshHelper)
- (void)add_header_refresh_with_callback:(void (^)())block;
- (void)add_footer_refresh_with_callback:(void (^)())block;
- (void)stop_all_refresh;
- (void)stop_header_refresh;
- (void)stop_footer_refresh;
- (void)start_header_refresh;
- (void)start_footer_refresh;
- (void)hide_footer_refresh:(BOOL)hidden;

//- (void)config_header_refresh_with_pull_down_string:(NSString*)pull_down_string release_to_refresh_string:(NSString*)release_to_refresh_string loading_string:(NSString*)loading_string;
//- (void)config_footer_refresh_with_pull_up_string:(NSString*)pull_up_string loading_more:(NSString*)loading_more no_more_data:(NSString*)no_more_data;
@end
