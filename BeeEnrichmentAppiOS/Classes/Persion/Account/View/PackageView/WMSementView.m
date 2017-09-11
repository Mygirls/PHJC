//
//  WMSementView.m
//  BeeEnrichmentAppiOS
//
//  Created by hwm on 16/10/12.
//  Copyright © 2016年 didai. All rights reserved.
//

#import "WMSementView.h"

@interface WMSementView ()

@property (nonatomic, strong) UIViewController *parentC;

@end

@implementation WMSementView

- (instancetype)initWithFrame:(CGRect)frame controllers:(NSArray *)controllers titleArray:(NSArray *)titleArray ParentController:(UIViewController *)parentC  index:(NSInteger)index
{
    if ( self=[super initWithFrame:frame  ])
    {
        self.parentC = parentC;
        self.controllers=controllers;
        self.nameArray = titleArray;
        self.segmentScrollV=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 40, frame.size.width, frame.size.height + 20000)];
        self.segmentScrollV.contentSize=CGSizeMake(frame.size.width*self.controllers.count, 0);
        self.segmentScrollV.delegate=self;
        self.segmentScrollV.showsHorizontalScrollIndicator=NO;
        self.segmentScrollV.pagingEnabled=YES;
        self.segmentScrollV.bounces=NO;
        [self addSubview:self.segmentScrollV];
        for (int i=0;i<self.controllers.count;i++)
        {
            
            UIViewController * contr=self.controllers[i];
            [self.segmentScrollV addSubview:contr.view];
            contr.view.frame=CGRectMake(i*frame.size.width, 0, frame.size.width,frame.size.height);
            [parentC addChildViewController:contr];
            [contr didMoveToParentViewController:parentC];
            
        }
        // titleView
        self.segmentView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, 40)];
        self.segmentView.backgroundColor = [UIColor whiteColor];
        self.segmentView.tag=50;
        [self addSubview:self.segmentView];
        for (int i=0;i<self.controllers.count;i++)
        {
            UIButton * btn=[UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame=CGRectMake(i*(frame.size.width/self.controllers.count), 0, frame.size.width/self.controllers.count, 40);
            btn.tag=i;
            [btn setTitle:self.nameArray[i] forState:(UIControlStateNormal)];
                       UIColor *color = [UIColor grayColor];
            [btn setTitleColor:color forState:(UIControlStateNormal)];
            [btn setTitleColor:[UIColor colorWithHex:@"#f95f53"] forState:(UIControlStateSelected)];
            [btn addTarget:self action:@selector(Click:) forControlEvents:(UIControlEventTouchUpInside)];
            btn.titleLabel.font=[UIFont systemFontOfSize:15];
            if (index) {
                if (i==index)
                {
                    btn.selected=YES ;
                    self.seleBtn=btn;
                } else {
                    btn.selected=NO;
                }
            }else{
                if (i==0)
                {
                    btn.selected=YES ;
                    self.seleBtn=btn;
                } else {
                    btn.selected=NO;
                }
            }
            [self.segmentView addSubview:btn];
        }
        self.line=[[UILabel alloc]initWithFrame:CGRectMake(30,37, frame.size.width/self.controllers.count- 60, 3)];
        self.line.backgroundColor=[UIColor colorWithHex:@"#f95f53"];
        self.line.tag=100;
        [self.segmentView addSubview:self.line];
        self.down=[[UILabel alloc]initWithFrame:CGRectMake(0, 39.5, frame.size.width, 0.5)];
        self.down.backgroundColor = [UIColor colorWithHex:@"#e1e1e1"];
        [self.segmentView addSubview:self.down];
    }
    if (index) {
        [UIView animateWithDuration:0.2 animations:^{
            CGPoint  frame=self.line.center;
            frame.x=self.frame.size.width/(self.controllers.count*2) +(self.frame.size.width/self.controllers.count)* (index);
            self.line.center=frame;
        }];
        [self.segmentScrollV setContentOffset:CGPointMake((index)*self.frame.size.width, 0) animated:YES ];
    }
    return self;
}

- (void)Click:(UIButton*)sender
{
    if (sender.tag == 0) {
        [MobClick event:me_myPackage_redID];
    }else if (sender.tag == 1) {
        [MobClick event:me_myPackage_rateID];
    }else if (sender.tag == 2) {
        [MobClick event:me_myPackage_goldID];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"packageSementView" object:nil userInfo:@{@"indexVC":@(sender.tag)}];
    self.seleBtn.selected=NO;
    self.seleBtn=sender;
    self.seleBtn.selected=YES;
    [UIView animateWithDuration:0.2 animations:^{
        CGPoint  frame=self.line.center;
        frame.x=self.frame.size.width/(self.controllers.count*2) +(self.frame.size.width/self.controllers.count)* (sender.tag);
        self.line.center=frame;
    }];
    [self.segmentScrollV setContentOffset:CGPointMake((sender.tag)*self.frame.size.width, 0) animated:YES ];
}

#pragma mark 添加 子控制器的view
- (void)addChildVcView {
    NSUInteger index = self.segmentScrollV.contentOffset.x / self.segmentScrollV.frame.size.width;
    UIViewController *childVc = self.controllers[index];
    if ([childVc isViewLoaded]) return;
    childVc.view.frame = self.segmentScrollV.bounds;
    [self.segmentScrollV addSubview:childVc.view];
    [self.parentC addChildViewController:childVc];
    [childVc didMoveToParentViewController:self.parentC];
}

#pragma mark delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSUInteger index = scrollView.contentOffset.x / scrollView.frame.size.width;
    UIButton *titleButton = (UIButton*)[self.segmentView viewWithTag:index];
    [self Click:titleButton];
//    [self addChildVcView];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
//    [self addChildVcView];
}

@end

