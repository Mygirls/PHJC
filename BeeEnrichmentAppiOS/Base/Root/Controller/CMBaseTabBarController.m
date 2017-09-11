    //
//  CMBaseTabBarController.m
//  CallMe
//
//  Created by renpan on 15/3/4.
//  Copyright (c) 2015年 XiZhe. All rights reserved.
//

#import "CMBaseTabBarController.h"
#import "LLLockViewController.h"
#import "LoginNavigationController.h"
#import "RCSegmentView.h"

#import "SupermarketViewController.h"
#import "DiscoverViewController.h"
#import "StationViewController.h"

#import "MyAccountVersionTwoViewController.h"
#import "isSetPaswordView.h"

//#import "SuperViewControllerTwo.h"
//#import "SuperViewControllerThree.h"
//
//#import "AllSuperController.h"
#import "RecommendVersionTwoViewController.h"

@interface CMBaseTabBarController ()<UITabBarControllerDelegate>
@property (nonatomic, strong) RCSegmentView *segmentView;
@property (nonatomic,strong)UIView * down;
@end

@implementation CMBaseTabBarController
- (void)awakeFromNib
{
    [super awakeFromNib];

    for (UITabBarItem *item in self.tabBar.items) {
        item.image = [item.image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        item.selectedImage = [item.selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tabBar setBackgroundImage:[[UIImage alloc] init]];
    self.down = [[UIView alloc]initWithFrame:CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width, 0.5)];
    self.down.backgroundColor = [UIColor colorWithHex:@"#e1e1e1"];
    [self.tabBar  addSubview:self.down];

    [self.tabBar setShadowImage:[[UIImage alloc] init]];
    self.delegate = self;
    [self performSelector:@selector(show_gesture_passowrd_vc) withObject:nil afterDelay:0.3];
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [CMCore check_version];
    if ([UIApplication sharedApplication].applicationIconBadgeNumber > 0) {
        [self.tabBar showBadgeOnItemIndex:2];
        [self.segmentView showBadgeOnBtnIndex:1];
    }
    
    if ([CMCore is_login]) {
        NSInteger isset = [CMCore is_ti_shi_set_gesture] ? 1 : 0;
        if (isset) {
            isSetPaswordView *v = [[NSBundle mainBundle] loadNibNamed:@"isSetPaswordView" owner:self options:0].lastObject;
            v.isSetPaswordViewBlockClick = ^(isSetPaswordViewType type) {
                [self isSetPassword];
            };
            [v show];
        }else {
            [CMCore setIs_ti_shi_set_gesture:NO];
        }
    }
}


- (void)show_gesture_passowrd_vc
{
    if ([CMCore is_login]) {
        if ([CMCore is_open_gesture_password] && [LLLockPassword loadLockPassword]) {
            //手势密码是开启状态
            LLLockViewController *llock_vc = [self.storyboard instantiateViewControllerWithIdentifier:@"LLLockViewController"];
            llock_vc.nLockViewType = LLLockViewTypeCheck;
            [self presentViewController:llock_vc animated:YES completion:nil];
        }
    }
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    UINavigationController * nav = (UINavigationController *)viewController;
    
    if (viewController == [self.viewControllers objectAtIndex:0]) {
        if (tabBarController.selectedIndex != 0) {
            
            return YES;
        }else{
            RecommendVersionTwoViewController * view = (RecommendVersionTwoViewController *) nav.topViewController;
            if (view.tableView.contentOffset.y==-20) {
                if ([CMCore isExistenceNetwork]) {
                    [view.tableView.mj_header beginRefreshing];
                }
                
                return NO;
            }else{
                [view.tableView scrollRectToVisible:CGRectMake(0, 0, 0.5, 0.5) animated:YES];
                return NO;
            }
        }
        
    }
    if (viewController == [self.viewControllers objectAtIndex:1]) {
        
        if (tabBarController.selectedIndex != 1) {
            [MobClick event:tabBar_supermarketID];
        }else{
            UITableViewController * view ;
            SupermarketViewController * VC = (SupermarketViewController *)nav.topViewController ;
            
            if (VC.selectedItem == 0) {
                view = nav.topViewController.childViewControllers.firstObject;
            }else if (VC.selectedItem == 1) {
                view = nav.topViewController.childViewControllers[1];
            }else if (VC.selectedItem == 2){
                view = nav.topViewController.childViewControllers.lastObject;
            }
            
            if (view.tableView.contentOffset.y==0) {
                [view.tableView.mj_header beginRefreshing];
                return NO;
            }else{
                [view.tableView scrollRectToVisible:CGRectMake(0, 0, 0.5, 0.5) animated:YES];
                return NO;
            }
        }
        
    }
    if (viewController == [self.viewControllers objectAtIndex:2]) {
        
        if (tabBarController.selectedIndex != 2) {
            
            [MobClick event:tabBar_findButtonID];
            
        }else{
            UITableViewController * view ;
            DiscoverViewController * VC = (DiscoverViewController *)nav.topViewController ;
            
            if (VC.selectedItem == 0) {
                view = nav.topViewController.childViewControllers.firstObject;
            }else if (VC.selectedItem == 1) {
                view = nav.topViewController.childViewControllers[1];
                StationViewController * vc = (StationViewController *)view;
                if (vc.dataList.count == 0) {
                    return NO;
                }
            }
            if (view.tableView.contentOffset.y == 0) {
                [view.tableView.mj_header beginRefreshing];
                return NO;
            }else{
                [view.tableView scrollRectToVisible:CGRectMake(0, 0, 0.5, 0.5) animated:YES];
                return NO;
            }
        }
        
        
    }
    if (viewController == [self.viewControllers objectAtIndex:3]) {
        
        
        BOOL islogin = [CMCore is_login];
        if (islogin == YES) {
            //已登录
            
            if (tabBarController.selectedIndex != 3) {
                
                return YES;
            }else{
                MyAccountVersionTwoViewController * view = (MyAccountVersionTwoViewController *) nav.topViewController;
                if (view.tableView.contentOffset.y == 0 ) {
                    [view.tableView.mj_header beginRefreshing];
                    return NO;
                }else{
                    [view.tableView scrollRectToVisible:CGRectMake(0, 0, 0.5, 0.5) animated:YES];
                    return NO;
                }
            }
            
            
        }else
        {
            //未登录 
            LoginNavigationController *login_navc = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginNavigationController"];
            [self presentViewController:login_navc animated:YES completion:nil];
            return NO;
        }
    }
   
        return YES;
}

#pragma mark 设置手势密码
- (void)isSetPassword {
    //设置手势密码
    LLLockViewController *llock_vc = [self.storyboard instantiateViewControllerWithIdentifier:@"LLLockViewController"];
    
    llock_vc.nLockViewType = LLLockViewTypeCreate;
    [self presentViewController:llock_vc animated:YES completion:nil];
    
}

@end
