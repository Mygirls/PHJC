//
//  JPLog.m
//  ShiHang
//
//  Created by jacksonpan on 14-9-17.
//  Copyright (c) 2014年 xizhe. All rights reserved.
//

#import "JPLog.h"
#import <zipzap/ZipZap.h>

@interface JPLogger ()
@property (nonatomic, strong) NSString* bundle_name;
@end

@implementation JPLogger
ShareInstanceDefine

@synthesize enable_log = _enable_log;
@synthesize level = _level;
@synthesize cache_path = _cache_path;
@synthesize bundle_name = _bundle_name;
@synthesize developer_email = _developer_email;

- (NSString*)log_cache_current_path
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* doc_dir = [paths objectAtIndex:0];
    
    NSFileManager* fm = [NSFileManager defaultManager];
    NSString* jp_log_path = [doc_dir stringByAppendingPathComponent:@"jplog/cache"];
    BOOL is_directory;
    if([fm fileExistsAtPath:jp_log_path isDirectory:&is_directory])
    {
        if(!is_directory)
        {
            [fm removeItemAtPath:jp_log_path error:nil];
            [fm createDirectoryAtPath:jp_log_path withIntermediateDirectories:YES attributes:nil error:nil];
        }
    }
    else
    {
        [fm createDirectoryAtPath:jp_log_path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return jp_log_path;
}

- (NSString*)get_zip_tmp_path
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* doc_dir = [paths objectAtIndex:0];
    
    NSFileManager* fm = [NSFileManager defaultManager];
    NSString* jp_zip_path = [doc_dir stringByAppendingPathComponent:@"jplog/zip"];
    BOOL is_directory;
    if([fm fileExistsAtPath:jp_zip_path isDirectory:&is_directory])
    {
        if(!is_directory)
        {
            [fm removeItemAtPath:jp_zip_path error:nil];
            [fm createDirectoryAtPath:jp_zip_path withIntermediateDirectories:YES attributes:nil error:nil];
        }
    }
    else
    {
        [fm createDirectoryAtPath:jp_zip_path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return jp_zip_path;
}

- (NSString*)get_current_cache_file_path
{
    return [NSString stringWithFormat:@"%@/%@.log", _cache_path, [self get_latest_date]];
}

- (void)clear_all
{
    NSFileManager* fm = [NSFileManager defaultManager];
    [fm removeItemAtPath:_cache_path error:nil];
    [self log_cache_current_path];
}

- (void)clear_with_name:(NSString*)name
{
    NSFileManager* fm = [NSFileManager defaultManager];
    [fm removeItemAtPath:[NSString stringWithFormat:@"%@/%@", _cache_path, name] error:nil];
}

- (void)init_data
{
    _cache_path = [self log_cache_current_path];
    [self read_from_user_default];
}

- (void)read_from_user_default
{
    NSUserDefaults* user = [NSUserDefaults standardUserDefaults];
    id has_enable_log = [user objectForKey:@"jplog_enable_log"];
    if(has_enable_log == nil)
    {
        self.enable_log = JPLogEnableDefault;
    }
    else
    {
        _enable_log = [user boolForKey:@"jplog_enable_log"];
    }
    id has_level = [user objectForKey:@"jplog_level"];
    if(has_level == nil)
    {
        self.level = JPLogLevelDefault;
    }
    else
    {
        _level = (JPLogLevel)[user integerForKey:@"jplog_level"];
    }
}

- (void)setEnable_log:(BOOL)enable_log
{
    _enable_log = enable_log;
    NSUserDefaults* user = [NSUserDefaults standardUserDefaults];
    [user setBool:enable_log forKey:@"jplog_enable_log"];
    [user synchronize];
}

- (void)setLevel:(JPLogLevel)level
{
    _level = level;
    NSUserDefaults* user = [NSUserDefaults standardUserDefaults];
    [user setBool:level forKey:@"jplog_level"];
    [user synchronize];
}

- (void)cache_add:(NSString*)file_path log:(NSString*)log
{
    NSMutableData *data = [NSMutableData dataWithContentsOfFile:file_path];
    if(data == nil)
    {
        data = [[NSMutableData alloc] init];
    }
    [data appendData:[[log stringByAppendingString:@"\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [data writeToFile:file_path atomically:NO];
}

- (NSString*)label_for_level:(JPLogLevel)level
{
    NSString* ret = nil;
    switch (level) {
        case JPLogLevelDebug:
            ret = @"DEBUG";
            break;
        case JPLogLevelHttp:
            ret = @"HTTP";
            break;
        case JPLogLevelOther:
            ret = @"OTHER";
            break;
        case JPLogLevelError:
            ret = @"ERROR";
            break;
        case JPLogLevelAll:
            break;
        default:
            break;
    }
    return ret;
}

- (void)log_with_level:(JPLogLevel)level file_name:(NSString*)name file_line:(NSNumber*)line cmd:(NSString*)cmd args_format:(NSString*)format, ...
{
    if(!_enable_log)
    {
        return;
    }
    va_list args, args_copy;
    va_start(args, format);
    va_copy(args_copy, args);
    va_end(args);
    if(_level == JPLogLevelAll)
    {
        NSString* log_text = [[NSString alloc] initWithFormat:format arguments:args_copy];
        if(name && line && cmd)
        {
            log_text = [NSString stringWithFormat:@"<%@:%@(%@)> %@", name, line, cmd, log_text];
        }
        NSString* datetime = [self get_datetime];
        NSString* label = [self label_for_level:JPLogLevelDebug];
        [self log_out_with_label:label datetime:datetime log_text:log_text];
    }
    else if(_level == level)
    {
        NSString *log_text = [[NSString alloc] initWithFormat:format arguments:args_copy];
        if(name && line && cmd)
        {
            log_text = [NSString stringWithFormat:@"<%@:%@(%@)> %@", name, line, cmd, log_text];
        }
        NSString* datetime = [self get_datetime];
        NSString* label = [self label_for_level:level];
        [self log_out_with_label:label datetime:datetime log_text:log_text];
    }
    va_end(args_copy);
}

- (void)log_out_with_label:(NSString*)label datetime:(NSString*)datetime log_text:(NSString*)log_text
{
    NSString* data = nil;
    if(label)
    {
        data = [NSString stringWithFormat:@"[%@] %@[%@] %@", label, [self bundleName], datetime, log_text];
    }
    else
    {
        data = [NSString stringWithFormat:@"%@[%@] %@", [self bundleName], datetime, log_text];
    }
    [self cache_add:[self get_current_cache_file_path] log:data];
#ifdef TARGET_IPHONE_SIMULATOR
    NSLog(@"%@", log_text);
#endif
}

- (NSString*)get_datetime
{
    NSDate *now = [NSDate date];//[CMCore getNowDateFromAnyDate:[NSDate date]]
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
    NSString *dateString = [formatter stringFromDate:now];
    return dateString;
}

- (NSString *)bundleName
{
	if (!_bundle_name)
        _bundle_name = (NSString *)[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"];
	return _bundle_name;
}

- (NSArray*)find_log_file_name_by_day
{
    NSFileManager* fm = [NSFileManager defaultManager];
    NSArray* files_list = [fm contentsOfDirectoryAtPath:_cache_path error:nil];
    return files_list;
}

- (NSString*)get_log_with_file_name:(NSString*)name
{
    NSString* file_path = [NSString stringWithFormat:@"%@/%@", _cache_path, name];
    NSData* data = [NSData dataWithContentsOfFile:file_path];
    NSString* log = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return log;
}

- (NSString*)get_latest_date
{
    NSDate *now = [NSDate date];//[CMCore getNowDateFromAnyDate:[NSDate date]]
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [formatter stringFromDate:now];
    return dateString;
}

- (NSString*)get_latest_log_name
{
    return [[self get_latest_date] stringByAppendingString:@".log"];
}

- (NSString*)get_latest_log
{
    NSData* data = [NSData dataWithContentsOfFile:[self get_current_cache_file_path]];
    NSString* log = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return log;
}

- (void)zip_all_logs:(void(^)(BOOL success, NSString* zip_path, NSError* error))block
{
    NSString* file_path = [NSString stringWithFormat:@"%@/%@", [self get_zip_tmp_path], @"all.zip"];
    dispatch_async(dispatch_get_main_queue(), ^{
        NSMutableArray* zip_entry_list = [NSMutableArray new];
        NSArray* log_name_list = [self find_log_file_name_by_day];
        for(NSString* name in log_name_list)
        {
            [zip_entry_list addObject:[ZZArchiveEntry archiveEntryWithFileName:name
                                            compress:YES
                                           dataBlock:^(NSError** error)
             {
                 NSString* data = [self get_log_with_file_name:name];
                 return [data dataUsingEncoding:NSUTF8StringEncoding];
             }
            ]];
        }
        NSError* err = nil;
        ZZArchive* newArchive = [[ZZArchive alloc] initWithURL:[NSURL fileURLWithPath:file_path] options:@{ZZOpenOptionsCreateIfMissingKey:@(YES)} error:&err];
        if(block && err)
        {
            block(NO, file_path, err);
        }
        if(err)
        {
            return;
        }
        [newArchive updateEntries:zip_entry_list error:&err];
        if(block && err)
        {
            block(NO, file_path, err);
        }
        if(err)
        {
            return;
        }
        if(block)
        {
            block(YES, file_path, err);
        }
    });
}

- (void)zip_log_with_name:(NSString*)name block:(void(^)(BOOL success, NSString* zip_path, NSError* error))block
{
    NSArray* names = [name componentsSeparatedByString:@"."];
    NSString* file_path = [NSString stringWithFormat:@"%@/%@.zip", [self get_zip_tmp_path], [names firstObject]];
    dispatch_async(dispatch_get_main_queue(), ^{
        NSMutableArray* zip_entry_list = [NSMutableArray new];
        [zip_entry_list addObject:[ZZArchiveEntry archiveEntryWithFileName:name
                                                                  compress:YES
                                                                 dataBlock:^(NSError** error)
                                   {
                                       NSString* data = [self get_log_with_file_name:name];
                                       return [data dataUsingEncoding:NSUTF8StringEncoding];
                                   }
                                   ]];
        NSError* err = nil;
        ZZArchive* newArchive = [[ZZArchive alloc] initWithURL:[NSURL fileURLWithPath:file_path] options:@{ZZOpenOptionsCreateIfMissingKey:@(YES)} error:&err];
        if(block && err)
        {
            block(NO, file_path, err);
        }
        if(err)
        {
            return;
        }
        [newArchive updateEntries:zip_entry_list error:&err];
        if(block && err)
        {
            block(NO, file_path, err);
        }
        if(err)
        {
            return;
        }
        if(block)
        {
            block(YES, file_path, err);
        }
    });
}

- (void)clear_zips_all
{
    NSFileManager* fm = [NSFileManager defaultManager];
    [fm removeItemAtPath:[self get_zip_tmp_path] error:nil];
    [self get_zip_tmp_path];
}

- (void)clear_zip_with_name:(NSString*)name
{
    NSFileManager* fm = [NSFileManager defaultManager];
    [fm removeItemAtPath:[NSString stringWithFormat:@"%@/%@", [self get_zip_tmp_path], name] error:nil];
}
@end

@implementation JPLogger (Extend)

@end
