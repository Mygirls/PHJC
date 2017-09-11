//
//  JPView.m
//  ShiHang
//
//  Created by renpan on 14/10/20.
//  Copyright (c) 2014年 xizhe. All rights reserved.
//

#import "JPView.h"

@interface JPView ()
@end

@implementation JPView
- (id)init
{
    self = [super init];
    if(self)
    {
        [self init_ui];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];

    [self init_ui];
}

- (void)init_ui
{
    
}

- (void)init_customize
{
    
}

@end

@implementation UIView (JPView)

- (CGFloat)my_width
{
    return self.frame.size.width;
}

- (CGFloat)my_height
{
    return self.frame.size.height;
}

// Duplicate UIView
- (id)copy_view
{
    NSData * tempArchive = [NSKeyedArchiver archivedDataWithRootObject:self];
    return [NSKeyedUnarchiver unarchiveObjectWithData:tempArchive];
}

@end
