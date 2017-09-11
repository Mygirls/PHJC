//
//  JPPath.m
//  ShiHang
//
//  Created by renpan on 14/10/30.
//  Copyright (c) 2014年 xizhe. All rights reserved.
//

#import "JPPath.h"

@interface JPPath ()
@property (nonatomic, strong) NSMutableDictionary* custom_path_list;
@end

@implementation JPPath
ShareInstanceDefine

- (void)init_data
{
    self.custom_path_list = [NSMutableDictionary new];
}

+ (NSString*)path_for_document
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* path = [paths firstObject];
//    _NSLogObject(path);
    return path;
}

+ (NSString*)path_for_document_with_append:(NSString*)append
{
    NSString* path = [self path_for_document];
    path = [path stringByAppendingPathComponent:append];
//    _NSLogObject(path);
    return path;
}

+ (NSString*)path_for_cache
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString* path = [paths firstObject];
//    _NSLogObject(path);
    return path;
}

+ (NSString*)path_for_cache_with_append:(NSString*)append
{
    NSString* path = [self path_for_cache];
    path = [path stringByAppendingPathComponent:append];
//    _NSLogObject(path);
    return path;
}

+ (NSString*)path_for_tmp
{
    NSString *path = NSTemporaryDirectory();
//    _NSLogObject(path);
    return path;
}

+ (NSString*)path_for_tmp_with_append:(NSString*)append
{
    NSString* path = [self path_for_tmp];
    path = [path stringByAppendingPathComponent:append];
//    _NSLogObject(path);
    return path;
}

+ (NSString*)path_for_home
{
    NSString *path = NSHomeDirectory();
//    _NSLogObject(path);
    return path;
}

+ (NSString*)path_for_home_with_append:(NSString*)append
{
    NSString* path = [self path_for_home];
    path = [path stringByAppendingPathComponent:append];
//    _NSLogObject(path);
    return path;
}

+ (NSString*)path_for_bundle_with_fullname:(NSString*)fullname
{
    NSString* path = nil;
    NSArray* names = [fullname componentsSeparatedByString:@"."];
    if(names.count == 1)
    {
        path = [[NSBundle mainBundle] pathForResource:[names firstObject] ofType:nil];
    }
    else if(names.count == 2)
    {
        path = [[NSBundle mainBundle] pathForResource:[names firstObject] ofType:[names lastObject]];
    }
//    _NSLogObject(path);
    return path;
}

- (void)set_custom_path:(NSString*)path for_key:(NSString*)key
{
    [self.custom_path_list setObject:path forKey:key];
}

- (NSString*)read_custom_path_with_key:(NSString*)key
{
    NSString* path = [self.custom_path_list objectForKey:key];
//    _NSLogObject(path);
    return path;
}

@end
