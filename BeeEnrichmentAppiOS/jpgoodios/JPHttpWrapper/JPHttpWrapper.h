//
//  JPHttpWrapper.h
//  ShiHang
//
//  Created by jacksonpan on 14-9-14.
//  Copyright (c) 2014年 xizhe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+JPNSObjectExtend.h"
#if __has_include("AFHTTPRequestOperationManager.h")
#import "AFHTTPRequestOperationManager.h"
#define _AFNETWORKING_VERSION_      (2)
#endif
#if __has_include("AFHTTPClient.h")
#import "AFHTTPClient.h"
#define _AFNETWORKING_VERSION_      (1)
#endif
//#import <AFNetworking/AFNetworking.h>

#define HTTP_CODE_SUCCESS                            200
#define HTTP_CODE_FAILER                             400
#define HTTP_CODE_EXPIRED                            401
#define HTTP_CODE_SERVER_ERROR                       500

typedef void(^httpResponse)(BOOL success, id responseObject, NSError* error, AFHTTPRequestOperation* operation);
typedef void(^uploadProgess)(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite);
typedef void(^resultBlock)(NSNumber* code, id result, NSString* message);
typedef void(^retryBlock)(NSInteger index);
typedef void(^expiredBlock)();

@interface JPHttpWrapper : NSObject
@property (nonatomic, strong) NSString* base_url;
@property (nonatomic, assign) BOOL debug_mode;//default:NO
@property (nonatomic, assign) NSInteger time_out;//default:120s, here wait to support for setting timeout

- (AFHTTPRequestOperation*)requestWithMethod:(NSString*)method
                                   urlString:(NSString*)method_path
                                      params:(NSDictionary*)params
                                    response:(httpResponse)block;
- (AFHTTPRequestOperation*)get:(NSString*)method_path
                         params:(NSDictionary*)params
                      response:(httpResponse)block;
- (AFHTTPRequestOperation*)post:(NSString*)method_path
                          params:(NSDictionary*)params
                       response:(httpResponse)block;
- (AFHTTPRequestOperation*)post:(NSString*)method_path
                          params:(NSDictionary*)params
                           data:(NSData*)data
                   dataFileName:(NSString*)dataFileName
                    dataKeyName:(NSString*)dataKeyName
                       mimeType:(NSString*)mimeType
                       response:(httpResponse)block
                       progress:(uploadProgess)progress_block;
- (AFHTTPRequestOperation*)post:(NSString*)method_path
                         params:(NSDictionary*)params
                      file_list:(NSArray*)file_list
                       response:(httpResponse)block
                       progress:(uploadProgess)progress_block;
- (void)soap;
@end
