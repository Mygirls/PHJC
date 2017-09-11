//
//  JPJson.h
//  ShiHang
//
//  Created by jacksonpan on 14-9-14.
//  Copyright (c) 2014年 xizhe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+JPNSObjectExtend.h"

@interface JPJson : NSObject
@property (nonatomic, assign) NSStringEncoding stringEncoding;
@end

@interface NSObject (JPJson)
- (NSString *)JSONRepresentation;
@end

@interface NSString (JPJson)
- (id)json;
- (id)JSONValue;
@end

@interface NSData (JPJson)
- (id)json;
@end

@interface NSDictionary (JPJson)
- (NSData*)to_json_data;
- (NSString*)to_json_string;
@end

@interface NSArray (JPJson)
- (NSData*)to_json_data;
- (NSString*)to_json_string;
@end

@interface NSNull (JPJson)
- (NSData*)to_json_data;
- (NSString*)to_json_string;
- (id)json;
@end