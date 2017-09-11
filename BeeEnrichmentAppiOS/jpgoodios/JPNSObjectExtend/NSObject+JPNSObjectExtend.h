//
//  NSObject+JPNSObjectExtend.h
//  ShiHang
//
//  Created by jacksonpan on 14-9-14.
//  Copyright (c) 2014年 xizhe. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef ShareInstanceDefine
#define ShareInstanceDefine     + (id)current\
{\
static id static_shareInstance = nil;\
static dispatch_once_t onceToken;\
dispatch_once(&onceToken, ^{\
static_shareInstance = [[[self class] alloc] init];\
[static_shareInstance init_data];\
});\
return static_shareInstance;\
}
#endif

@interface NSObject (JPNSObjectExtend)
+ (id)current;
- (void)init_data;

+ (NSString*)class_name;
+ (id)new_object;
@end
