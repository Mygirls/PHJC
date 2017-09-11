//
//  UIView+badge.m
//  BeeEnrichmentAppiOS
//
//  Created by hwm on 16/11/3.
//  Copyright © 2016年 didai. All rights reserved.
//

#import "UIView+badge.h"

#define TabbarItemNums 2.0    //tabbar的数量
@implementation UIView (badge)
- (void)showBadgeOnBtnIndex:(int)index{
    
    //移除之前的小红点
    [self removeBadgeOnItemIndex:index];
    
    //新建小红点
    UIView *badgeView = [[UIView alloc]init];
    badgeView.tag = 888 + index;
    badgeView.layer.cornerRadius = 4;
    badgeView.backgroundColor = [CMCore basic_red1_color];
    CGRect tabFrame = self.frame;
    
    //确定小红点的位置
    float percentX = (index +0.6) / TabbarItemNums;
    CGFloat x = ceilf(percentX * tabFrame.size.width + 16);
    CGFloat y = ceilf(0.1 * tabFrame.size.height + 2);
    badgeView.frame = CGRectMake(x, y, 8, 8);
    [self addSubview:badgeView];
    
}

- (void)hideBadgeOnBtnIndex:(int)index{
    
    //移除小红点
    [self removeBadgeOnItemIndex:index];
    
}

- (void)removeBadgeOnItemIndex:(int)index{
    
    //按照tag值进行移除
    for (UIView *subView in self.subviews) {
        
        if (subView.tag == 888+index) {
            
            [subView removeFromSuperview];
            
        }
    }
}
@end
