//
//  JPPageViewController.h
//  CallMe
//
//  Created by renpan on 15/3/13.
//  Copyright (c) 2015年 XiZhe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JPViewController.h"

@interface JPPageViewController : UIPageViewController
@property (nonatomic, assign) NSInteger tag;    //for find view controller
@property (nonatomic, assign) id last_view_controller;

- (void)init_ui;
- (void)fix_ui; //do something ui change without autolayout
- (void)init_when_view_will_appear;
- (void)init_when_view_will_disappear;
- (void)init_when_view_did_appear;
- (void)init_when_view_did_disappear;
@end
