//
//  JPPath.h
//  ShiHang
//
//  Created by renpan on 14/10/30.
//  Copyright (c) 2014年 xizhe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+JPNSObjectExtend.h"

@interface JPPath : NSObject
+ (NSString*)path_for_document;
+ (NSString*)path_for_document_with_append:(NSString*)append;
+ (NSString*)path_for_cache;
+ (NSString*)path_for_cache_with_append:(NSString*)append;
+ (NSString*)path_for_tmp;
+ (NSString*)path_for_tmp_with_append:(NSString*)append;
+ (NSString*)path_for_home;
+ (NSString*)path_for_home_with_append:(NSString*)append;
+ (NSString*)path_for_bundle_with_fullname:(NSString*)fullname;

- (void)set_custom_path:(NSString*)path for_key:(NSString*)key;
- (NSString*)read_custom_path_with_key:(NSString*)key;

@end
