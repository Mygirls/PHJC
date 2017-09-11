//
//  JPViewController.h
//  ShiHang
//
//  Created by renpan on 14/10/20.
//  Copyright (c) 2014年 xizhe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JPNibLoad.h"

typedef void(^go_back_handle)(id sender);

@interface JPViewController : UIViewController

@property (nonatomic, assign) NSInteger tag;    //for find view controller
@property (nonatomic, assign) id last_view_controller;
@property (nonatomic, strong) go_back_handle block_go_back_handle;

@property (nonatomic, assign) BOOL enable_transition_animation;
- (void)setBlock_go_back_handle:(go_back_handle)block_go_back_handle;

- (void)init_ui;
- (void)fix_ui; //do something ui change without autolayout
- (void)init_update_view_constraints;
- (void)update_view_constraints;
- (void)init_when_view_will_appear;
- (void)init_when_view_will_disappear;
- (void)init_when_view_did_appear;
- (void)init_when_view_did_disappear;
- (void)set_data_for_go_back:(id)data;
@end



@interface UIViewController (JPViewController)

- (void)will_load_from_go_back;
- (void)go_next:(id)vc animated:(BOOL)animated viewController:(UIViewController*)view;
- (void)go_back:(BOOL)animated viewController:(UIViewController*)view;
- (void)go_back_to:(id)vc animated:(BOOL)animated;
- (void)go_root:(BOOL)animated;
- (id)find_last_except_self;
- (id)find_with_tag:(NSInteger)tag;
- (id)find_with_class:(Class)cls;

@end
