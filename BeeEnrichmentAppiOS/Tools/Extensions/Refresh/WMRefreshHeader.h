//
//  WMRefreshHeader.h
//  test
//
//  Created by hwm on 17/2/15.
//  Copyright © 2017年 hwm. All rights reserved.
//

#import <MJRefresh/MJRefresh.h>

@interface WMRefreshHeader : MJRefreshNormalHeader
@property (nonatomic, assign) CGFloat insetTopStateIdle;
@property (nonatomic, assign) CGFloat insetTopStateRefreshing;
@end
