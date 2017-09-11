//
//  JPTabBarController.m
//  JennyFood
//
//  Created by renpan on 15/2/6.
//  Copyright (c) 2015年 JennyFood. All rights reserved.
//

#import "JPTabBarController.h"

@interface JPTabBarController ()

@end

@implementation JPTabBarController
{
    BOOL is_first_viewWillAppear;
    BOOL is_first_viewWillDisappear;
    BOOL is_first_viewDidAppear;
    BOOL is_first_viewDidDisappear;
}

- (void)init_ui
{
    //    _NSLogObject(self);
    //    _NSLogObject(self.view);
}

- (void)fix_ui
{
    
}

- (void)init_data
{
    is_first_viewWillAppear = NO;
    is_first_viewWillDisappear = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self init_data];
    [self init_ui];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self fix_ui];
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

- (void)viewWillDisappear:(BOOL)animated
{
    if(!is_first_viewWillDisappear)
    {
        [self init_when_view_will_disappear];
        is_first_viewWillDisappear = YES;
    }
    [super viewWillDisappear:animated];
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

- (void)viewDidDisappear:(BOOL)animated
{
    if(!is_first_viewDidDisappear)
    {
        [self init_when_view_did_disappear];
        is_first_viewDidDisappear = YES;
    }
    [super viewDidDisappear:animated];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
