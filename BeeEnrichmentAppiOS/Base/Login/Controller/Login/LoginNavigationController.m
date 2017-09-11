//
//  LoginNavigationController.m
//  BeeEnrichmentAppiOS
//
//  Created by dll on 15/12/21.
//  Copyright © 2015年 didai. All rights reserved.
//

#import "LoginNavigationController.h"

@interface LoginNavigationController ()
@property (nonatomic,strong)UILabel * down;
@end

@implementation LoginNavigationController

-(void)viewDidLoad{
    [super viewDidLoad];
    self.down = [[UILabel alloc]initWithFrame:CGRectMake(0, self.navigationBar.frame.size.height,[UIScreen mainScreen].bounds.size.width, 0.5)];
    self.down.backgroundColor = [UIColor colorWithHex:@"#e1e1e1"];
    [self.navigationBar  addSubview:self.down];
    
    
    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"Navigation Image"]
                       forBarPosition:UIBarPositionAny
                           barMetrics:UIBarMetricsDefault];
    [self.navigationBar setShadowImage:[UIImage new]];
}

@end
