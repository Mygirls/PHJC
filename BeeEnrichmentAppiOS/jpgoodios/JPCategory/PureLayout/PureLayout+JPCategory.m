//
//  PureLayout+JPCategory.m
//  shihang_ipad
//
//  Created by renpan on 14/11/8.
//  Copyright (c) 2014年 renpan. All rights reserved.
//

#import "PureLayout+JPCategory.h"

@implementation UIView (PureLayout_JPCategory)
- (void)disable_auto_resize
{
    self.translatesAutoresizingMaskIntoConstraints = NO;
}

- (void)remove_all_constraints
{
    NSArray* constraints = [self constraints];
    [self removeConstraints:constraints];
    
//    [NSLayoutConstraint deactivateConstraints:constraints];
}

@end
