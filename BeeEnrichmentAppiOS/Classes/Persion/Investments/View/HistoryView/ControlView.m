//
//  ControlView.m
//  BeeEnrichmentAppiOS
//
//  Created by dll on 16/11/14.
//  Copyright © 2016年 didai. All rights reserved.
//

#import "ControlView.h"
#define Height 44
#define FrameWidth frame.size.width
#define FrameHeight frame.size.height
@interface ControlView ()

@property (nonatomic, strong) UIViewController *parentVC;

@end

@implementation ControlView

- (instancetype)initWithFrame:(CGRect)frame controllers:(NSArray *)controllers titleArray:(NSArray *)titleArray ParentController:(UIViewController *)parentC market_type:(NSInteger)market_type
{
    if ( self=[super initWithFrame:frame  ])
    {
        self.parentVC = parentC;
        self.controllers=controllers;
        self.nameArray=titleArray;
        
        self.segmentView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, FrameWidth, Height)];
        self.segmentView.tag=50;
        [self addSubview:self.segmentView];
        
        self.segmentScrollV=[[UIScrollView alloc]initWithFrame:CGRectMake(0, Height, FrameWidth, FrameHeight - Height)];
        self.segmentScrollV.contentSize=CGSizeMake(FrameWidth*self.controllers.count, 0);
        self.segmentScrollV.delegate=self;
        self.segmentScrollV.showsHorizontalScrollIndicator=NO;
        self.segmentScrollV.pagingEnabled=YES;
        self.segmentScrollV.bounces=NO;
        [self addSubview:self.segmentScrollV];
        [self lazyAddChildVC];

        self.line=[[UILabel alloc]initWithFrame:CGRectMake(0,0, FrameWidth / 375 * 100, controllers.count)];
        self.line.backgroundColor= [CMCore basic_red1_color];//[CMCore basic_red1_color];
        self.line.tag=100;
        [self.segmentView addSubview:self.line];
        self.line.center = CGPointMake(FrameWidth / controllers.count / 2, 42);
        self.down=[[UILabel alloc]initWithFrame:CGRectMake(0, 43.5, FrameWidth, 0.5)];
        self.down.backgroundColor=[UIColor colorWithHex:@"#E1E1E1"];
        
        
        
        for (int i=0;i<self.controllers.count;i++)
        {
            UIButton * btn=[ UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame=CGRectMake(i*(FrameWidth/self.controllers.count), 0, FrameWidth/self.controllers.count, 41);
            btn.tag=i;
            btn.backgroundColor = [UIColor whiteColor];
            [btn setTitle:self.nameArray[i] forState:(UIControlStateNormal)];
            UIColor *color = [CMCore basic_gray1_color];
            [btn setTitleColor:color forState:(UIControlStateNormal)];
            [btn setTitleColor:[CMCore basic_red1_color] forState:(UIControlStateSelected)];
            [btn addTarget:self action:@selector(Click:) forControlEvents:(UIControlEventTouchUpInside)];
            btn.titleLabel.font=[UIFont fontWithName:FontOfAttributed size:14];
            
            [self.segmentView addSubview:btn];
            if (market_type == 10) {
                if (i == 0) {
                    btn.selected = YES;
                    self.seleBtn = btn;
                }else {
                    btn.selected = NO;
                }
            }else {
                if (i == 1) {
                    btn.selected = YES;
                    self.seleBtn = btn;
                    self.line.center = CGPointMake(FrameWidth / controllers.count / 2 * 3, 42);
                    [self.segmentScrollV setContentOffset:CGPointMake(i * self.FrameWidth, 0) animated:YES ];
                }else {
                    btn.selected = NO;
                }
            }
            if (btn.selected) {
                btn.titleLabel.font=[UIFont fontWithName:FontOfAttributed size:16];
            }
        }
        
        
        [self.segmentView addSubview:self.down];
        
    }
    
    return self;
}
- (void)Click:(UIButton*)sender
{
    _typeClass = sender.tag;
    self.seleBtn.selected=NO;
    self.seleBtn.titleLabel.font=[UIFont fontWithName:FontOfAttributed size:14];
    self.seleBtn = sender;
    self.seleBtn.selected=YES;
    self.seleBtn.titleLabel.font=[UIFont fontWithName:FontOfAttributed size:16];
    [UIView animateWithDuration:0.2 animations:^{
        CGPoint frame=self.line.center;
        frame.x=self.FrameWidth/(self.controllers.count*2) +(self.FrameWidth/self.controllers.count)* (sender.tag);
        self.line.center=frame;
    }];
    [self.segmentScrollV setContentOffset:CGPointMake((sender.tag)*self.FrameWidth, 0) animated:YES ];
}

#pragma mark 懒加载子控制器
- (void)lazyAddChildVC {
    NSUInteger index = self.segmentScrollV.contentOffset.x / self.segmentScrollV.FrameWidth;
    UIViewController *childVc = self.controllers[index];
    if ([childVc isViewLoaded]) return;
    childVc.view.frame = self.segmentScrollV.bounds;
    [self.segmentScrollV addSubview:childVc.view];
    [self.parentVC addChildViewController:childVc];
    [childVc didMoveToParentViewController:self.parentVC];
}

#pragma mark scrollview delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSUInteger index = scrollView.contentOffset.x / scrollView.FrameWidth;
    UIButton *titleButton = (UIButton*)[self.segmentView viewWithTag:index];
    [self Click:titleButton];
    [self lazyAddChildVC];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    [self lazyAddChildVC];
}


@end
