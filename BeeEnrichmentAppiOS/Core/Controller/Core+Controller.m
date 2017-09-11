//
//  Core+Controller.m
//  CallMe
//
//  Created by renpan on 15/3/4.
//  Copyright (c) 2015年 XiZhe. All rights reserved.
//

#import "Core+Controller.h"
#import "CMBaseTabBarController.h"
#import "LoginNavigationController.h"
#import "GuideViewController.h"


@implementation Core (Controller)


- (void)guide_controller_show_from:(UITabBarController*)controller
{

        GuideViewController *guide = [[GuideViewController alloc] init];
        [controller presentViewController:guide animated:NO completion:^{
            [CMCore setIs_first_run:NO];
        }];

}

- (void)set_to_main_controller
{
    UIApplication* app = [UIApplication sharedApplication];
    UIWindow* key_window = [JPScreen find_top_window];
    _NSLogObject(app.keyWindow.rootViewController);
    _NSLogObject(key_window.rootViewController);
    CMBaseTabBarController* root_viewcontroller = (CMBaseTabBarController*)key_window.rootViewController;
    JPViewController* top = [root_viewcontroller.viewControllers firstObject];
    if ([top isKindOfClass:[LoginNavigationController class]]) {
        return;
    }
    
    //跳转至根视图
    [[self getCurrentVC].navigationController popToRootViewControllerAnimated:YES];
    
    [root_viewcontroller presentViewController:[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LoginNavigationController"] animated:YES completion:nil];
}



- (UIViewController *)getCurrentVC{
    
    UIViewController *result = nil;
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    //app默认windowLevel是UIWindowLevelNormal，如果不是，找到UIWindowLevelNormal的
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    id  nextResponder = nil;
    UIViewController *appRootVC=window.rootViewController;
    //    如果是present上来的appRootVC.presentedViewController 不为nil
    if (appRootVC.presentedViewController) {
        nextResponder = appRootVC.presentedViewController;
    }else{
        UIView *frontView = [[window subviews] objectAtIndex:0];
        nextResponder = [frontView nextResponder];
//        <span style="font-family: Arial, Helvetica, sans-serif;">//  这方法下面有详解    </span>
    }
    
    if ([nextResponder isKindOfClass:[UITabBarController class]]){
        UITabBarController * tabbar = (UITabBarController *)nextResponder;
        UINavigationController * nav = (UINavigationController *)tabbar.viewControllers[tabbar.selectedIndex];
        //        UINavigationController * nav = tabbar.selectedViewController ; 上下两种写法都行
        result=nav.childViewControllers.lastObject;
        
    }else if ([nextResponder isKindOfClass:[UINavigationController class]]){
        UIViewController * nav = (UIViewController *)nextResponder;
        result = nav.childViewControllers.lastObject;
    }else{
        result = nextResponder;
    }
    
    return result;
}






@end
