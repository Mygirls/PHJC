//
//  JPViewController.m
//  ShiHang
//
//  Created by renpan on 14/10/20.
//  Copyright (c) 2014年 xizhe. All rights reserved.
//

#import "JPViewController.h"
#import "JPPageViewController.h"
#import "UINavigationController+TRVSNavigationControllerTransition.h"

@interface JPViewController ()<UIGestureRecognizerDelegate>

@end

@implementation JPViewController
{
    BOOL is_first_viewWillAppear;
    BOOL is_first_viewWillDisappear;
    BOOL is_first_viewDidAppear;
    BOOL is_first_viewDidDisappear;
    
    BOOL is_init_update_view_constraints;
}

- (void)init_ui
{

    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:FontOfAttributed size:17]}];
}

- (void)fix_ui
{
    
}

- (void)init_data
{
    is_first_viewWillAppear = NO;
    is_first_viewWillDisappear = NO;
    is_first_viewDidAppear = NO;
    is_first_viewDidDisappear = NO;
    is_init_update_view_constraints = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    v.backgroundColor = [UIColor clearColor];
    [self.view addSubview:v];
    
    [self init_data];
    [self init_ui];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self fix_ui];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)init_update_view_constraints
{
    
}

- (void)update_view_constraints
{
    
}

- (void)updateViewConstraints
{
    [super updateViewConstraints];
    if(!is_init_update_view_constraints)
    {
        is_init_update_view_constraints = YES;
        [self init_update_view_constraints];
    }
    [self update_view_constraints];
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
    if (animated) {
        if(self.last_view_controller)
        {
            if([self.last_view_controller respondsToSelector:@selector(will_load_from_go_back)])
            {
                [self.last_view_controller will_load_from_go_back];
            }
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

- (void)set_data_for_go_back:(id)data
{
    if(((JPViewController*)self.last_view_controller).block_go_back_handle)
    {
        ((JPViewController*)self.last_view_controller).block_go_back_handle(data);
    }
}
@end

@implementation UIViewController (JPViewController)

- (void)will_load_from_go_back
{
  
}

- (void)go_next:(id)vc animated:(BOOL)animated viewController:(UIViewController*)view
{
    ((JPViewController*)vc).last_view_controller = self;
    if(((JPViewController*)vc).enable_transition_animation)
    {
        [view.navigationController trvs_pushViewControllerWithNavigationControllerTransition:vc];
    }
    else
    {
        [view.navigationController pushViewController:vc animated:animated];
    }
}

- (void)go_back:(BOOL)animated viewController:(UIViewController*)view
{
    JPViewController* vc = (JPViewController*)self;
    if(vc.enable_transition_animation)
    {
        [view.navigationController trvs_popViewControllerWithNavigationControllerTransition];
    }
    else
    {
        [view.navigationController popViewControllerAnimated:animated];
    }
}

- (void)go_back_to:(id)vc animated:(BOOL)animated 
{
    ((JPViewController*)self).last_view_controller = nil;
    [self.navigationController popToViewController:vc animated:animated];
}

- (void)go_root:(BOOL)animated
{
    [self.navigationController popToRootViewControllerAnimated:animated];
}

- (id)find_last_except_self
{
    NSArray* vc_list = self.navigationController.viewControllers;
    NSInteger index = [vc_list indexOfObject:self];
    if(index == 0)
    {
        return nil;
    }
    return [vc_list objectAtIndex:index-1];
}

- (id)find_with_tag:(NSInteger)tag
{
    NSArray* vc_list = self.navigationController.viewControllers;
    for(JPViewController* vc in vc_list)
    {
        if(vc.tag == tag)
        {
            return vc;
        }
    }
    return nil;
}

- (id)find_with_class:(Class)cls
{
    NSArray* vc_list = self.navigationController.viewControllers;
    for(JPViewController* vc in vc_list)
    {
        if([vc isKindOfClass:cls])
        {
            return vc;
        }
    }
    return nil;
}


@end
