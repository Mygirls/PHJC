//
//  WebViewController.h
//  BeeEnrichmentAppiOS
//
//  Created by dll on 15/12/28.
//  Copyright © 2015年 didai. All rights reserved.
//

#import "JPViewController.h"

@interface WebViewController : JPViewController
- (void)load_withUrl:(NSString*)url title:(NSString*)title canScaling:(BOOL)canScaling;// isShowCloseItem:(BOOL)isShowCloseItem

- (void)load_withRightBarUrl:(NSString*)rightBarUrl title:(NSString *)title canScaling:(BOOL)canScaling;// isShowCloseItem:(BOOL)isShowCloseItem

- (void)load_withRightImageBarUrl:(NSString *)rightBarImageName title:(NSString *)title url:(NSString *)url canScaling:(BOOL)canScaling;

- (void)bridge_callback_with_method:(NSString*)method params:(NSArray*)params;


@property (nonatomic, strong) NSString *share_content;
@property (nonatomic, strong) NSString *flagStr;


// 入口类型 1 轮播图
//@property (nonatomic, assign) NSInteger entranceType;


@end
