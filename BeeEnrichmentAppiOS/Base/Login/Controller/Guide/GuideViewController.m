//
//  GuideViewController.m
//  CallMe
//
//  Created by renpan on 15/3/4.
//  Copyright (c) 2015年 XiZhe. All rights reserved.
//

#import "GuideViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <JSQFlatButton/JSQFlatButton.h>

#define WINDOWHEIGHT [UIScreen mainScreen].bounds.size.height
#define WINDOWWIDTH [UIScreen mainScreen].bounds.size.width

@interface GuideViewController () <UIScrollViewDelegate, CLLocationManagerDelegate>
@property(strong,nonatomic)UIScrollView *scrollview;
@property(strong,nonatomic)UIPageControl *pageControl;
@property(strong,nonatomic)UIButton *entryBut;
@property(strong,nonatomic)CLLocationManager *currentLocation;
@property (nonatomic, strong) UIColor *grayColor, *yellowColor, *blueColor;
@end

@implementation GuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _grayColor = [UIColor colorWithRed:219/255.0 green:219/255.0 blue:219/255.0 alpha:1];
    _yellowColor = [UIColor colorWithRed:255/255.0 green:175/255.0 blue:7/255.0 alpha:1];
    _blueColor = [UIColor colorWithRed:108/255.0 green:191/255.0 blue:255/255.0 alpha:1];
    self.scrollview =
    [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    self.scrollview.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width*3, [UIScreen mainScreen].bounds.size.height);
    self.scrollview.delegate = self;
    self.scrollview.bounces = NO;
    NSArray *imgNames = @[@"guild1", @"guild2", @"guild3"];
    for (int i = 0; i < imgNames.count; i ++) {
        UIImageView *img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imgNames[i]]];
        img.frame = CGRectMake(kScreenWidth*i, 0, kScreenWidth, kScreenHeight);
        img.contentMode = UIViewContentModeScaleAspectFill;
        [self.scrollview addSubview:img];
    }
    self.pageControl = [[UIPageControl alloc]init];
    self.pageControl.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height*536./568, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height*15./568);
    self.pageControl.numberOfPages = 3;
    self.pageControl.currentPage= 0;
    self.pageControl.userInteractionEnabled = NO;
    
    [self.pageControl setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    self.pageControl.pageIndicatorTintColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.5];;
//    self.pageControl.currentPageIndicatorTintColor = _yellowColor;
    self.scrollview.showsHorizontalScrollIndicator = NO;
    self.scrollview.showsVerticalScrollIndicator = NO;
    self.scrollview.pagingEnabled = YES;
    self.scrollview.scrollEnabled = YES;
    [self.view addSubview:self.scrollview];
    [self.view addSubview:self.pageControl];
    
    self.entryBut = [[UIButton alloc] init];
    CGFloat height = 40, f = 0;
    if (kScreenHeight==480) {
        // 4
        height=36;
        f = 20;
    }else if (kScreenHeight == 568)
    {
        //5
        height=36;
    }else if (kScreenHeight == 667)
    {
        //6
    }else if (kScreenHeight > 667)
    {
        //6 p
        height=44;
    }
    
    self.entryBut.frame = CGRectMake(kScreenWidth/2 -  height/2.0/0.25,WINDOWHEIGHT*(1-212.0/1122.0)+f, height / 0.25, height);
    [self.entryBut setBackgroundImage:[UIImage imageNamed:@"first_start_btn"] forState:UIControlStateNormal];
    [self.entryBut addTarget:self action:@selector(enter:) forControlEvents:UIControlEventTouchUpInside];

    self.entryBut.highlighted = NO;
    // Do any additional setup after loading the view.
}

-(void)enter:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint point = scrollView.contentOffset;
    
    if ((int)point.x % (int)[UIScreen mainScreen].bounds.size.width == 0)
    {
        int page = (int)point.x/kScreenWidth;
        self.pageControl.currentPage= page;
//        if (page == 0) {
//            self.pageControl.currentPageIndicatorTintColor = _yellowColor;
//        }else if (page == 1) {
//            self.pageControl.currentPageIndicatorTintColor = _blueColor;
//        }
        if (page == 2) {
            [self.view addSubview:self.entryBut];
            self.pageControl.hidden = YES;
            self.entryBut.alpha = 0;
            [UIView beginAnimations:nil context:nil];
            //设定动画持续时间
            [UIView setAnimationDuration:1];
            //动画的内容
            self.entryBut.alpha = 1;
            //动画结束
            [UIView commitAnimations];
        }
    }else
    {
        self.pageControl.hidden = NO;
        [self.entryBut removeFromSuperview];
    }
    
}


@end
