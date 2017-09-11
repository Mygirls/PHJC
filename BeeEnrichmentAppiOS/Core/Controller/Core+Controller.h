//
//  Core+Controller.h
//  CallMe
//
//  Created by renpan on 15/3/4.
//  Copyright (c) 2015年 XiZhe. All rights reserved.
//

#import "Core.h"

@interface Core (Controller)

- (void)guide_controller_show_from:(UITabBarController*)controller;
- (void)set_to_main_controller;
- (UIViewController *)getCurrentVC;
@end
