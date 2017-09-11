//
//  JPTagViewController.h
//  CallMe
//
//  Created by renpan on 15/5/15.
//  Copyright (c) 2015年 XiZhe. All rights reserved.
//

#import "JPViewController.h"

@interface JPTagViewController : JPViewController
@property (nonatomic, assign) CGFloat tag_height;   //default 40
@property (nonatomic, assign) CGFloat tag_distance; //default 10
- (void)add_tag_with_view:(UIView*)view;
- (void)add_tag_with_views:(NSArray*)views;

@end
