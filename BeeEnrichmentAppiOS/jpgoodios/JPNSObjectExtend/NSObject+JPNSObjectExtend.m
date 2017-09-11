//
//  NSObject+JPNSObjectExtend.m
//  ShiHang
//
//  Created by jacksonpan on 14-9-14.
//  Copyright (c) 2014年 xizhe. All rights reserved.
//

#import "NSObject+JPNSObjectExtend.h"


@implementation NSObject (JPNSObjectExtend)
ShareInstanceDefine

- (void)init_data
{
}

+ (NSString*)class_name
{
    return [NSString stringWithUTF8String:object_getClassName(self)];
}

+ (id)new_object
{
    assert(@"if you want to use it, please override it.");
    return nil;
}
@end


