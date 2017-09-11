//
//  JPNavigationController.m
//  ShiHang
//
//  Created by renpan on 14/10/17.
//  Copyright (c) 2014年 xizhe. All rights reserved.
//

#import "JPNavigationController.h"
#import "MoneyViewController.h"

@interface JPNavigationController ()<UIGestureRecognizerDelegate>

@end

@implementation JPNavigationController

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.interactivePopGestureRecognizer.delegate = self;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.childViewControllers.count > 0) {
//        if (![viewController isKindOfClass:[MoneyViewController class]]) {
           viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"v1_left_item"] style:UIBarButtonItemStyleDone target:self action:@selector(back)];
//        }
        viewController.hidesBottomBarWhenPushed = YES;
    }
    
    [super pushViewController:viewController animated:YES];
}

- (void)back
{
    [self popViewControllerAnimated:YES];
}
#pragma mark - <UIGestureRecognizerDelegate>
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    // 手势何时有效 : 当导航控制器的子控制器个数 > 1就有效
    return self.childViewControllers.count > 1;
}


@end
