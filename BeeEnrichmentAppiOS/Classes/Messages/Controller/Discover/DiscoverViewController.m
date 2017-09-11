//
//  DiscoverViewController.m
//  BeeEnrichmentAppiOS
//
//  Created by dll on 16/8/4.
//  Copyright © 2016年 didai. All rights reserved.
//

#import "DiscoverViewController.h"
#import "SFDynamicViewController.h"
#import "StationViewController.h"
#import "RCSegmentView.h"

@interface DiscoverViewController ()
@property (nonatomic, strong) RCSegmentView * rcs;
@end
__weak DiscoverViewController *discoverSelf;
@implementation DiscoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    discoverSelf = self;
    UIStoryboard *stor = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SFDynamicViewController *vc1 = [stor instantiateViewControllerWithIdentifier:@"SFDynamicViewController"];
    StationViewController *vc2 = [stor instantiateViewControllerWithIdentifier:@"StationViewController"];
    NSArray *controllers=@[vc1,vc2];
    NSArray *titleArray =@[@"普汇动态",@"消息小站"];
    _rcs = [[RCSegmentView alloc]initWithFrame:CGRectMake(0, 20, kScreenWidth, kScreenHeight) controllers:controllers titleArray:titleArray ParentController:self];
    vc2.segmentView = _rcs.segmentView;
    [self.view addSubview:_rcs];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

@end
