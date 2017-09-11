//
//  JPHttpWrapper.m
//  ShiHang
//
//  Created by jacksonpan on 14-9-14.
//  Copyright (c) 2014年 xizhe. All rights reserved.
//

#import "JPHttpWrapper.h"
#import "JPJson.h"

#if _AFNETWORKING_VERSION_ == (1)
@interface AFHTTPRequestOperationManager : AFHTTPClient
- (AFHTTPRequestOperation *)GET:(NSString *)URLString
                     parameters:(id)parameters
                        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
- (AFHTTPRequestOperation *)POST:(NSString *)URLString
                      parameters:(id)parameters
                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
- (AFHTTPRequestOperation *)POST:(NSString *)URLString
                      parameters:(id)parameters
       constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
@end

@implementation AFHTTPRequestOperationManager

+ (id)manager
{
    return [self clientWithBaseURL:[NSURL URLWithString:@""]];
}

- (AFHTTPRequestOperation *)GET:(NSString *)URLString
                     parameters:(id)parameters
                        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSURLRequest *request = [self requestWithMethod:@"GET" path:URLString parameters:parameters];
    request.timeoutInterval = time_out;
    AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request success:success failure:failure];
    [self enqueueHTTPRequestOperation:operation];
    return operation;
}

- (AFHTTPRequestOperation *)POST:(NSString *)URLString
                      parameters:(id)parameters
                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSURLRequest *request = [self requestWithMethod:@"POST" path:URLString parameters:parameters];
     request.timeoutInterval = time_out;
    AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request success:success failure:failure];
    
    [self enqueueHTTPRequestOperation:operation];
    return operation;
}

- (AFHTTPRequestOperation *)POST:(NSString *)URLString
                      parameters:(id)parameters
       constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSMutableURLRequest *request = [self multipartFormRequestWithMethod:@"POST" path:@"/upload" parameters:nil constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
        if(block)
        {
            block(formData);
        }
    }];
    request.timeoutInterval = time_out;
    AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request success:success failure:failure];
    [self enqueueHTTPRequestOperation:operation];
    return operation;
}
@end
#endif

@interface JPHttpWrapper ()

@end

@implementation JPHttpWrapper
ShareInstanceDefine

@synthesize base_url = _base_url;
@synthesize debug_mode = _debug_mode;
@synthesize time_out = _time_out;

- (void)init_data
{
    _debug_mode = NO;
    _time_out = 150;
}

- (NSString*)url_process:(NSString*)method_path
{
    NSString* whole_url = nil;
    
    if(_base_url == nil)
    {
        whole_url = method_path;
    }
    else if(method_path == nil)
    {
        whole_url = _base_url;
    }
    else
    {
        NSLog(@"%@", [_base_url stringByAppendingPathComponent:method_path]);
        whole_url = [_base_url stringByAppendingPathComponent:method_path];
        
    }
    if(_debug_mode)
    {
        NSLog(@"%@", whole_url);
    }
    
    if ([method_path isEqualToString:@"orderOld"]) {
        whole_url = @"http://beejc.com/api/order";
//        whole_url = @"http://192.168.10.32:17811/api/order";
    }else if ([method_path isEqualToString:@"memberOld"]) {
        whole_url = @"http://beejc.com/api/member";
//        whole_url = @"http://192.168.10.32:17811/api/member";
    }else if ([method_path isEqualToString:@"market"]) {
        whole_url = [@"http://beejc.com/api/" stringByAppendingPathComponent:method_path];
//        whole_url = [@"http://192.168.10.32:17811/api/" stringByAppendingPathComponent:method_path];
    }else if ([method_path isEqualToString:@"fp_orderOld"]) {
        whole_url = @"http://beejc.com/api/fp_order";
//        whole_url = @"http://192.168.10.32:17811/api/fp_order";
    }
    
    
    return whole_url;
}

- (AFHTTPRequestOperation*)requestWithMethod:(NSString*)method
                                   urlString:(NSString*)method_path
                                      params:(NSDictionary*)params
                                    response:(httpResponse)block
{
    if([method.lowercaseString isEqualToString:@"get"])
    {
        return [self get:method_path params:params response:block];
    }
    else if([method.lowercaseString isEqualToString:@"post"])
    {
        return [self post:method_path params:params response:block];
    }
    else
    {
        return nil;
    }
}

- (AFHTTPRequestOperation*)get:(NSString*)method_path
                        params:(NSDictionary*)params
                      response:(httpResponse)block
{
    
    //    if ([AFNetworkReachabilityManager sharedManager].reachable) {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableSet *newSet = [NSMutableSet set];
    // 添加我们需要的类型
    newSet.set = manager.responseSerializer.acceptableContentTypes;
    [newSet addObject:@"text/plain"];
    
    // 重写给 acceptableContentTypes赋值
    manager.responseSerializer.acceptableContentTypes = newSet;
    return [manager GET:[self url_process:method_path] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
#if _AFNETWORKING_VERSION_ == (1)
        responseObject = [responseObject json];
#endif
        if(_debug_mode)
        {
            NSLog(@"%@", [responseObject JSONRepresentation]);
        }
        if(block)
        {
            block(YES, responseObject, nil, operation);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(_debug_mode)
        {
            NSLog(@"%@", error);
        }
        if(block)
        {
            block(NO, nil, error, operation);
        }
    }];
    //    }else
    //    {
    //        [self alertForNotReachable];
    //        return nil;
    //    }
}

- (AFHTTPRequestOperation*)post:(NSString*)method_path
                         params:(NSDictionary*)params
                       response:(httpResponse)block
{
    if ([method_path isEqualToString:@"market"] || [method_path isEqualToString:@"orderOld"] || [method_path isEqualToString:@"memberOld"] || [method_path isEqualToString:@"fp_orderOld"]) {

        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        return [manager POST:[self url_process:method_path] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
#if _AFNETWORKING_VERSION_ == (1)
            responseObject = [responseObject json];
#endif
            if(_debug_mode)
            {
                NSLog(@"%@", [responseObject JSONRepresentation]);
            }
            if(block)
            {
                block(YES, responseObject, nil, operation);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if(_debug_mode)
            {
                NSLog(@"%@", error);
            }
            if(block)
            {
                block(NO, nil, error, operation);
            }
        }];

    }else {
        //    if ([AFNetworkReachabilityManager sharedManager].reachable) {
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSMutableSet *newSet = [NSMutableSet set];
        // 添加我们需要的类型
        newSet.set = manager.responseSerializer.acceptableContentTypes;
        [newSet addObject:@"text/plain"];
        
        // 重写给 acceptableContentTypes赋值
        manager.responseSerializer.acceptableContentTypes = newSet;
        
        return [manager POST:[self url_process:method_path] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
#if _AFNETWORKING_VERSION_ == (1)
            responseObject = [responseObject json];
#endif
            if(_debug_mode)
            {
                NSLog(@"%@", [responseObject JSONRepresentation]);
            }
            if(block)
            {
                block(YES, responseObject, nil, operation);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if(_debug_mode)
            {
            }
            if(block)
            {
                block(NO, nil, error, operation);
            }
        }];

    }
}


- (AFHTTPRequestOperation*)post:(NSString*)method_path
                         params:(NSDictionary*)params
                           data:(NSData*)data
                   dataFileName:(NSString*)dataFileName
                    dataKeyName:(NSString*)dataKeyName
                       mimeType:(NSString*)mimeType
                       response:(httpResponse)block
                       progress:(uploadProgess)progress_block
{
    //    if ([AFNetworkReachabilityManager sharedManager].reachable) {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableSet *newSet = [NSMutableSet set];
    // 添加我们需要的类型
    newSet.set = manager.responseSerializer.acceptableContentTypes;
    [newSet addObject:@"text/plain"];
    
    // 重写给 acceptableContentTypes赋值
    manager.responseSerializer.acceptableContentTypes = newSet;
    AFHTTPRequestOperation* operation = [manager POST:[self url_process:method_path] parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:data name:dataKeyName fileName:dataFileName mimeType:mimeType];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
#if _AFNETWORKING_VERSION_ == (1)
        responseObject = [responseObject json];
#endif
        if(_debug_mode)
        {
            NSLog(@"%@", [responseObject JSONRepresentation]);
        }
        if(block)
        {
            block(YES, responseObject, nil, operation);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(_debug_mode)
        {
            NSLog(@"%@", error);
        }
        if(block)
        {
            block(NO, nil, error, operation);
        }
    }];
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        if(progress_block)
        {
            progress_block(bytesWritten, totalBytesWritten, totalBytesExpectedToWrite);
        }
    }];
    return operation;
    //    }else
    //    {
    //        [self alertForNotReachable];
    //        return nil;
    //    }
}

- (AFHTTPRequestOperation*)post:(NSString*)method_path
                         params:(NSDictionary*)params
                      file_list:(NSArray*)file_list
                       response:(httpResponse)block
                       progress:(uploadProgess)progress_block
{
    //    if ([AFNetworkReachabilityManager sharedManager].reachable) {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableSet *newSet = [NSMutableSet set];
    // 添加我们需要的类型
    newSet.set = manager.responseSerializer.acceptableContentTypes;
    [newSet addObject:@"text/plain"];
    
    // 重写给 acceptableContentTypes赋值
    manager.responseSerializer.acceptableContentTypes = newSet;
    AFHTTPRequestOperation* operation = [manager POST:[self url_process:method_path] parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        for(NSDictionary* file in file_list)
        {
            NSData* data = [file objectForKey:@"data"];
            NSString* name = [file objectForKey:@"name"];
            NSString* file_name = [file objectForKey:@"file_name"];
            NSString* mime_type = [file objectForKey:@"mime_type"];
            [formData appendPartWithFileData:data name:name fileName:file_name mimeType:mime_type];
        }
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
#if _AFNETWORKING_VERSION_ == (1)
        responseObject = [responseObject json];
#endif
        if(_debug_mode)
        {
            NSLog(@"%@", [responseObject JSONRepresentation]);
        }
        if(block)
        {
            block(YES, responseObject, nil, operation);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(_debug_mode)
        {
            NSLog(@"%@", error);
            NSLog(@"%@", operation.responseString);
        }
        if(block)
        {
            block(NO, nil, error, operation);
        }
    }];
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        if(progress_block)
        {
            progress_block(bytesWritten, totalBytesWritten, totalBytesExpectedToWrite);
        }
    }];
    return operation;
    //    }else
    //    {
    //        [self alertForNotReachable];
    //        return nil;
    //    }
    
}

- (void)soap
{
    //    NSString *soapMessage =
    //    @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\
    //    <soap12:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap12=\"http://www.w3.org/2003/05/soap-envelope\">\
    //    <soap12:Body>\
    //    <GetLoginUserInfo xmlns=\"http://KM/\">\
    //    <strUserName>adc\\licnbxz</strUserName>\
    //    <strPassword>0721Today</strPassword>\
    //    </GetLoginUserInfo>\
    //    </soap12:Body>\
    //    </soap12:Envelope>";
    //    NSString *soapLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
    
    //    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //    manager.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
    //    [manager.requestSerializer setValue:@"application/soap+xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    //    [manager.requestSerializer setValue:soapLength forHTTPHeaderField:@"Content-Length"];
    //    NSError* err = nil;
    //    NSMutableURLRequest* request = [manager.requestSerializer requestWithMethod:@"POST" URLString:@"http://mobile.rpc-asia.com:8081/kmwebservice.asmx" parameters:nil error:&err];
    //    NSLog(@"%@", err);
    //    [request setHTTPBody:[soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    //    AFHTTPRequestOperation *operation = [manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
    //        NSString *response = [[NSString alloc] initWithData:(NSData *)responseObject encoding:NSUTF8StringEncoding];
    //        NSLog(@"%@, %@", operation, response);
    //    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    //        NSLog(@"%@, %@", operation, error);
    //    }];
    //    [manager.operationQueue addOperation:operation];
}
- (void) alertForNotReachable {
    [[JPAlert current] showAlertWithTitle:@"提示" content:@"当前网络不可用，请检查网络连接" button:@"去设置" block:^(UIAlertView* alertView, NSInteger index) {
    
            NSURL *url = [NSURL URLWithString:@"prefs:root=SBUsesNetwork"];
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                [[UIApplication sharedApplication] openURL:url];
            }
            //            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            //            [UIView animateWithDuration:0.3 animations:^{
            //                window.alpha = 0.0;
            //                window.frame = CGRectMake(0, window.bounds.size.width, 0, 0);
            //            } completion:^(BOOL finished) {
            exit(0);
            //            }];
        
        
    }];
}
@end
