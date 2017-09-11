//
//  JPTagViewController.m
//  CallMe
//
//  Created by renpan on 15/5/15.
//  Copyright (c) 2015年 XiZhe. All rights reserved.
//

#import "JPTagViewController.h"

@interface JPTagViewController ()
@property (nonatomic, strong) NSMutableArray* tag_view_list;
@property (nonatomic, strong) UIScrollView* scroll_view;
@end

@implementation JPTagViewController

- (void)loadView
{
    [super loadView];
    
    self.view = [UIView new];
}

- (void)init_ui
{
    [super init_ui];
    
    _tag_height = 40;
    _tag_distance = 10;
    
    if(_tag_view_list == nil)
    {
        _tag_view_list = [NSMutableArray new];
    }
    
    if(_scroll_view == nil)
    {
        _scroll_view = [[UIScrollView alloc] initForAutoLayout];
        [self.view addSubview:_scroll_view];
        _scroll_view.alwaysBounceVertical = YES;
        
        [_scroll_view autoPinEdgeToSuperviewEdge:ALEdgeTop];
        [_scroll_view autoPinEdgeToSuperviewEdge:ALEdgeBottom];
        [_scroll_view autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [_scroll_view autoPinEdgeToSuperviewEdge:ALEdgeRight];
    }
}

- (void)update_view_constraints
{
    [super update_view_constraints];
    
    UIView* last_tag = nil;
    CGFloat width = self.view.frame.size.width;
    CGFloat tag_height = _tag_height;
    CGFloat tag_distance = _tag_distance;
    CGFloat start_y = tag_distance;
    CGFloat start_x = tag_distance;
    if(_tag_view_list.count == 0)
    {
        return;
    }

    for(int i=0;i<_tag_view_list.count;i++)
    {
        UIView* tag_view = [_tag_view_list objectAtIndex:i];
        _NSLogInt(tag_view.tag);
        if(last_tag)
        {
            start_x += last_tag.frame.size.width + tag_distance;
            if(start_x + tag_view.frame.size.width > width)
            {
                start_x = tag_distance;
                start_y += tag_height + tag_distance;
            }
        }
        [tag_view autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:start_x];
        [tag_view autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:start_y];
        last_tag = tag_view;
    }
    
    if(last_tag)
    {
        [last_tag autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:_scroll_view withOffset:-tag_distance];
    }
}

- (void)add_tag_with_view:(UIView*)view
{
    [_tag_view_list addObject:view];
    [_scroll_view addSubview:view];
    [view autoSetDimension:ALDimensionHeight toSize:_tag_height];
    [view autoSetDimension:ALDimensionWidth toSize:30 relation:NSLayoutRelationGreaterThanOrEqual];
    
    [self.view layoutIfNeeded];
    [self.view setNeedsUpdateConstraints];
}

- (void)add_tag_with_views:(NSArray*)views
{
    for(UIView* view in views)
    {
        [_tag_view_list addObject:view];
        [_scroll_view addSubview:view];
        [view autoSetDimension:ALDimensionHeight toSize:_tag_height];
        [view autoSetDimension:ALDimensionWidth toSize:30 relation:NSLayoutRelationGreaterThanOrEqual];
    }
    [self.view layoutIfNeeded];
    [self.view setNeedsUpdateConstraints];
}

@end
