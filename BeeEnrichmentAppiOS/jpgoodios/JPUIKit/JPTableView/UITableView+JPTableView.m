//
//  UITableView+JPTableView.m
//  ShiHang
//
//  Created by renpan on 14/10/25.
//  Copyright (c) 2014年 xizhe. All rights reserved.
//

#import "UITableView+JPTableView.h"
#import "NSObject+JPNSObjectExtend.h"
#import "UITableViewCell+JPTableView.h"

@implementation UITableView (JPTableView)

- (id)load_reuseable_cell_with_class:(Class)_class
{
    NSString* name = [_class class_name];
    id cell = [self dequeueReusableCellWithIdentifier:name];
    if(!cell)
    {
        [self registerClass:_class forCellReuseIdentifier:name];
        cell = [self dequeueReusableCellWithIdentifier:name];
        if ([cell respondsToSelector:@selector(init_cell)])
        {
            [cell performSelector:@selector(init_cell) withObject:nil];
        }
    }
    if ([cell respondsToSelector:@selector(reuse_init_cell)])
    {
        [cell performSelector:@selector(reuse_init_cell) withObject:nil];
    }
    return cell;
}

- (id)load_reuseable_cell_from_nib_with_class:(Class)_class
{
    NSString* name = [_class class_name];
    id cell = [self dequeueReusableCellWithIdentifier:name];
    if(!cell)
    {
        UINib *nib = [UINib nibWithNibName:name bundle:nil];
        [self registerNib:nib forCellReuseIdentifier:name];
        cell = [self dequeueReusableCellWithIdentifier:name];
        if ([cell respondsToSelector:@selector(init_cell)])
        {
            [cell performSelector:@selector(init_cell) withObject:nil];
        }
    }
    if ([cell respondsToSelector:@selector(reuse_init_cell)])
    {
        [cell performSelector:@selector(reuse_init_cell) withObject:nil];
    }
    return cell;
}

- (id)load_reuseable_cell_with_style:(UITableViewCellStyle)style _class:(Class)_class
{
    NSString* name = [_class class_name];
    id cell = [self dequeueReusableCellWithIdentifier:name];
    if(!cell)
    {
        cell = [[_class alloc] initWithStyle:style reuseIdentifier:name];
        if ([cell respondsToSelector:@selector(init_cell)])
        {
            [cell performSelector:@selector(init_cell) withObject:nil];
        }
    }
    if ([cell respondsToSelector:@selector(reuse_init_cell)])
    {
        [cell performSelector:@selector(reuse_init_cell) withObject:nil];
    }
    return cell;
}

- (id)load_reuseable_header_footer_view_with_class:(Class)_class
{
    NSString* name = [_class class_name];
    id cell = [self dequeueReusableHeaderFooterViewWithIdentifier:name];
    if(!cell)
    {
        [self registerClass:_class forHeaderFooterViewReuseIdentifier:name];
        cell = [self dequeueReusableHeaderFooterViewWithIdentifier:name];
        if ([cell respondsToSelector:@selector(init_cell)])
        {
            [cell performSelector:@selector(init_cell) withObject:nil];
        }
    }
    if ([cell respondsToSelector:@selector(reuse_init_cell)])
    {
        [cell performSelector:@selector(reuse_init_cell) withObject:nil];
    }
    return cell;
}

- (id)load_reuseable_header_footer_view_from_nib_with_class:(Class)_class
{
    NSString* name = [_class class_name];
    id cell = [self dequeueReusableHeaderFooterViewWithIdentifier:name];
    if(!cell)
    {
        UINib *nib = [UINib nibWithNibName:name bundle:nil];
        [self registerNib:nib forHeaderFooterViewReuseIdentifier:name];
        cell = [self dequeueReusableHeaderFooterViewWithIdentifier:name];
        if ([cell respondsToSelector:@selector(init_cell)])
        {
            [cell performSelector:@selector(init_cell) withObject:nil];
        }
    }
    if ([cell respondsToSelector:@selector(reuse_init_cell)])
    {
        [cell performSelector:@selector(reuse_init_cell) withObject:nil];
    }
    return cell;
}

@end
