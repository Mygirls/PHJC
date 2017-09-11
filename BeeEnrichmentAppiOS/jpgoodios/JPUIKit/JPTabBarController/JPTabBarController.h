//
//  JPTabBarController.h
//  JennyFood
//
//  Created by renpan on 15/2/6.
//  Copyright (c) 2015年 JennyFood. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JPTabBarController : UITabBarController
- (void)init_ui;
- (void)fix_ui; //do something ui change without autolayout
- (void)init_when_view_will_appear;
- (void)init_when_view_will_disappear;
- (void)init_when_view_did_appear;
- (void)init_when_view_did_disappear;
@end
