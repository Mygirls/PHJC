//
//  JPSecurity.h
//  ShiHang
//
//  Created by jacksonpan on 14-9-14.
//  Copyright (c) 2014年 xizhe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JPSecurity : NSObject
+ (NSString*)base64Encode:(id)data;
+ (NSData*)base64Decode:(NSString*)data;
+ (NSString*)md5:(NSString*)data;
+ (NSString*)des_encode:(NSString*)data key:(NSString*)key;
+ (NSString*)des_decode:(NSString*)encode_data key:(NSString*)key;
+ (NSString*)des_encode_hex:(NSString*)data key:(NSString*)key;
@end

@interface NSString (JPSecurity)
- (NSString*)base64Encode;
- (NSString*)base64Decode;
- (NSString*)des_encode:(NSString*)key;
- (NSString*)des_decode:(NSString*)key;
- (NSString*)des_decode_hex:(NSString*)key;
- (NSString*)md5;
@end

@interface NSData (JPSecurity)
- (NSString*)base64Encode;
@end
