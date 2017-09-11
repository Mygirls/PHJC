//
//  JPPageViewController.m
//  CallMe
//
//  Created by renpan on 15/3/13.
//  Copyright (c) 2015年 XiZhe. All rights reserved.
//

#import "JPPageViewController.h"

@interface JPPageViewController () <UINavigationControllerDelegate>

@end

@implementation JPPageViewController
{
    BOOL is_first_viewWillAppear;
    BOOL is_first_viewWillDisappear;
    BOOL is_first_viewDidAppear;
    BOOL is_first_viewDidDisappear;
}

- (void)init_ui
{

}

- (void)fix_ui
{
    
}

- (void)init_data
{
    is_first_viewWillAppear = NO;
    is_first_viewWillDisappear = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.delegate = self;
    [self init_data];
    [self init_ui];
}

//- (void)viewWillLayoutSubviews
//{
//    [super viewWillLayoutSubviews];
//    [self fix_ui];
//}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self fix_ui];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)init_when_view_will_appear
{
    
}

- (void)init_when_view_will_disappear
{
    
}

- (void)init_when_view_did_appear
{
    
}

- (void)init_when_view_did_disappear
{
    
}

- (void)viewWillAppear:(BOOL)animated
{
    if(!is_first_viewWillAppear)
    {
        [self init_when_view_will_appear];
        is_first_viewWillAppear = YES;
    }
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    if(!is_first_viewDidAppear)
    {
        [self init_when_view_did_appear];
        is_first_viewDidAppear = YES;
    }
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    if(!is_first_viewWillDisappear)
    {
        [self init_when_view_will_disappear];
        is_first_viewWillDisappear = YES;
    }
    [super viewWillDisappear:animated];
    if(self.last_view_controller)
    {
        if([self.last_view_controller respondsToSelector:@selector(will_load_from_go_back)])
        {
            [self.last_view_controller will_load_from_go_back];
        }
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    if(!is_first_viewDidDisappear)
    {
        [self init_when_view_did_disappear];
        is_first_viewDidDisappear = YES;
    }
    [super viewDidDisappear:animated];
}


- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
