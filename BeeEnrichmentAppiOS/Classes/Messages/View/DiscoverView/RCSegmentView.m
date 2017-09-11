//
//  RCSegmentView.m
//  ProjectOne
//
//  Created by RongCheng on 16/3/31.
//  Copyright © 2016年 . All rights reserved.
//

#import "RCSegmentView.h"
#import "DiscoverViewController.h"
@interface RCSegmentView ()

@property (nonatomic, strong) UIViewController *parentC;

@end

@implementation RCSegmentView
- (instancetype)initWithFrame:(CGRect)frame controllers:(NSArray *)controllers titleArray:(NSArray *)titleArray ParentController:(UIViewController *)parentC
{
    if ( self=[super initWithFrame:frame  ])
    {
        self.parentC = parentC;
        self.controllers=controllers;
        self.nameArray=titleArray;
        self.segmentView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, 40)];
        self.segmentView.tag=50;
        [self addSubview:self.segmentView];
        self.segmentScrollV=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 40, frame.size.width, frame.size.height -40)];
        self.segmentScrollV.backgroundColor = [UIColor colorWithHex:@"f5f5f5"];
        self.segmentScrollV.contentSize=CGSizeMake(frame.size.width*self.controllers.count, 0);
        self.segmentScrollV.delegate=self;
        self.segmentScrollV.showsHorizontalScrollIndicator=NO;
        self.segmentScrollV.pagingEnabled=YES;
        self.segmentScrollV.bounces=NO;
        [self addSubview:self.segmentScrollV];
        
        [self addChildVcView];
        
        for (int i=0;i<self.controllers.count;i++)
        {
            UIButton * btn=[ UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame=CGRectMake(i*(frame.size.width/self.controllers.count), 0, frame.size.width/self.controllers.count, 40);
            btn.tag=i;
            [btn setTitle:self.nameArray[i] forState:(UIControlStateNormal)];
            UIColor *color = [CMCore basic_gray1_color];
            [btn setTitleColor:color forState:(UIControlStateNormal)];
            [btn setTitleColor:[CMCore basic_red1_color] forState:(UIControlStateSelected)];
            [btn addTarget:self action:@selector(Click:) forControlEvents:(UIControlEventTouchUpInside)];
            btn.titleLabel.font=[UIFont systemFontOfSize:16];
            if (i==0)
            {btn.selected=YES ;self.seleBtn=btn;
                btn.titleLabel.font=[UIFont systemFontOfSize:19];
            } else { btn.selected=NO; }
            [self.segmentView addSubview:btn];
        }
        self.line=[[UILabel alloc]initWithFrame:CGRectMake(30,37, frame.size.width/self.controllers.count- 60, 3)];
        self.line.backgroundColor= [CMCore basic_red1_color];
        self.line.tag=100;
        [self.segmentView addSubview:self.line];
        self.down=[[UILabel alloc]initWithFrame:CGRectMake(0, 39.5, frame.size.width, 1)];
        self.down.backgroundColor= [UIColor colorWithHex:@"#e1e1e1"];
        [self.segmentView addSubview:self.down];
    }
    return self;
}

- (void)Click:(UIButton*)sender
{
    _typeClass = sender.tag;
    if (sender.tag == 0) {
        // 普汇动态
        [MobClick event:discover_sfDynamicID];
    }else if (sender.tag == 1) {
        // 消息小站
        [MobClick event:discover_sfBeeSmallStationID];
        // 去掉小红点
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RCSegmentViewClick" object:nil];
    }
    self.seleBtn.titleLabel.font=[UIFont systemFontOfSize:16];
    self.seleBtn.selected=NO;
    self.seleBtn = sender;
    self.seleBtn.selected=YES;
    self.seleBtn.titleLabel.font=[UIFont systemFontOfSize:19];
    _typeClass = self.seleBtn.tag;
   
    [UIView animateWithDuration:0.2 animations:^{
        CGPoint  frame=self.line.center;
        frame.x=self.frame.size.width/(self.controllers.count*2) +(self.frame.size.width/self.controllers.count)* (sender.tag);
        self.line.center=frame;
    }];
    [self.segmentScrollV setContentOffset:CGPointMake((sender.tag)*self.frame.size.width, 0) animated:YES ];
    DiscoverViewController * view = (DiscoverViewController *)self.parentC ;
    view.selectedItem = sender.tag ;
}

#pragma mark 添加 子控制器的view
- (void)addChildVcView {
    NSUInteger index = self.segmentScrollV.contentOffset.x / self.segmentScrollV.frame.size.width;
    UIViewController *childVc = self.controllers[index];
    if ([childVc isViewLoaded]) return;
    childVc.view.frame = self.segmentScrollV.bounds;
    childVc.view.backgroundColor = [UIColor colorWithHex:@"f5f5f5"];
    [self.segmentScrollV addSubview:childVc.view];
    [self.parentC addChildViewController:childVc];
    [childVc didMoveToParentViewController:self.parentC];
}

#pragma mark delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSUInteger index = scrollView.contentOffset.x / scrollView.frame.size.width;
    UIButton *titleButton = (UIButton*)[self.segmentView viewWithTag:index];
    [self Click:titleButton];
    [self addChildVcView];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    [self addChildVcView];
}

@end
