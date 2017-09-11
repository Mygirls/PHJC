//
//  JPLog.h
//  ShiHang
//
//  Created by jacksonpan on 14-9-17.
//  Copyright (c) 2014年 xizhe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+JPNSObjectExtend.h"

#define JPLogEnableDefault                  (YES)
#define JPLogEnable( enable )               [[JPLogger current] setEnable_log:enable]
#define JPLogLevelDefault                   (JPLogLevelAll)
#define JPLogLevel( level )                 [[JPLogger current] setLevel:level]

#define JPLogBasic( level, format, ... )    [[JPLogger current] log_with_level:level file_name:nil file_line:nil cmd:nil args_format:format, ##__VA_ARGS__]
#define JPDLogBasic( level, format, ... )   [[JPLogger current] log_with_level:level file_name:[[NSString stringWithUTF8String:__FILE__] lastPathComponent] \
                                                                                file_line:[NSNumber numberWithInt:__LINE__] cmd:NSStringFromSelector(_cmd) args_format:format, ##__VA_ARGS__]

#define JPLog( format, ... )                JPLogBasic( JPLogLevelAll, format, ##__VA_ARGS__ )
#define JPDLog( format, ... )               JPDLogBasic( JPLogLevelAll, format, ##__VA_ARGS__ )

#define JPLogDebug( format, ... )           JPLogBasic( JPLogLevelDebug, format, ##__VA_ARGS__ )
#define JPLogHttp( format, ... )            JPLogBasic( JPLogLevelHttp, format, ##__VA_ARGS__ )
#define JPLogOther( format, ... )           JPLogBasic( JPLogLevelOther, format, ##__VA_ARGS__ )
#define JPLogError( format, ... )           JPLogBasic( JPLogLevelError, format, ##__VA_ARGS__ )

#define JPDLogDebug( format, ... )           JPDLogBasic( JPLogLevelDebug, format, ##__VA_ARGS__ )
#define JPDLogHttp( format, ... )            JPDLogBasic( JPLogLevelHttp, format, ##__VA_ARGS__ )
#define JPDLogOther( format, ... )           JPDLogBasic( JPLogLevelOther, format, ##__VA_ARGS__ )
#define JPDLogError( format, ... )           JPDLogBasic( JPLogLevelError, format, ##__VA_ARGS__ )

#define _NSLog(format, ...)                     JPDLog( format, ##__VA_ARGS__ )

typedef enum _JPLogLevel
{
    JPLogLevelDebug,    //基本的调试信息
    JPLogLevelHttp,     //联网相关的信息
    JPLogLevelOther,    //其他的调试信息
    JPLogLevelError,    //错误信息
    JPLogLevelAll,      //所有信息
}JPLogLevel;

@interface JPLogger : NSObject
@property (nonatomic, assign) BOOL enable_log;
@property (nonatomic, assign) JPLogLevel level;
@property (nonatomic, strong) NSString* cache_path;
@property (nonatomic, strong) NSString* developer_email;//default nil

- (void)log_with_level:(JPLogLevel)level file_name:(NSString*)name file_line:(NSNumber*)line cmd:(NSString*)cmd args_format:(NSString*)format, ...;
- (void)clear_all;
- (void)clear_with_name:(NSString*)name;
- (NSArray*)find_log_file_name_by_day;

- (NSString*)get_latest_log_name;

- (NSString*)get_log_with_file_name:(NSString*)name;
- (NSString*)get_latest_log;

- (void)zip_all_logs:(void(^)(BOOL success, NSString* zip_path, NSError* error))block;
- (void)zip_log_with_name:(NSString*)name block:(void(^)(BOOL success, NSString* zip_path, NSError* error))block;
- (void)clear_zips_all;
- (void)clear_zip_with_name:(NSString*)name;

@end

@interface JPLogger (Extend)
@end

#define _NSLogFrame(frame)            _NSLog(@"frame: x=%.2f, y=%.2f, width=%.2f, height=%.2f", frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);
#define _NSLogSize(size)              _NSLog(@"size: width=%.2f, height=%.2f", size.width, size.height);
#define _NSLogPoint(point)            _NSLog(@"point: x=%.2f, y=%.2f", point.x, point.y);
#define _NSLogObject(object)          _NSLog(@"object: %@", object);
#define _NSLogInt(integer)            _NSLog(@"integer: %@", @(integer));
#define _NSLogFloat(float)            _NSLog(@"float: %@", @(float));
