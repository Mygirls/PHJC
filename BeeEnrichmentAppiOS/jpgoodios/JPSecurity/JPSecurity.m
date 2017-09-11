//
//  JPSecurity.m
//  ShiHang
//
//  Created by jacksonpan on 14-9-14.
//  Copyright (c) 2014年 xizhe. All rights reserved.
//

#import "JPSecurity.h"
#import "CocoaSecurity.h"
#import "Cryptor.h"

@implementation JPSecurity

+ (NSString*)base64Encode:(id)data
{
    NSData* d = nil;
    if([data isKindOfClass:[NSString class]])
    {
        d = [data dataUsingEncoding:NSUTF8StringEncoding];
    }
    else if([data isKindOfClass:[NSData class]])
    {
        d = data;
    }
    else
    {
        return nil;
    }
    CocoaSecurityEncoder* e = [[CocoaSecurityEncoder alloc] init];
    return [e base64:d];
}

+ (NSData*)base64Decode:(NSString*)data
{
    CocoaSecurityDecoder* d = [[CocoaSecurityDecoder alloc] init];
    return [d base64:data];
}

+ (NSString*)md5:(NSString*)data
{
    CocoaSecurityResult* ret = [CocoaSecurity md5:data];
    return ret.hexLower;
}

+ (NSString*)des_encode:(NSString*)data key:(NSString*)key
{
    return [Cryptor encodeDES:data key:key];
}

+ (NSString*)des_decode:(NSString*)encode_data key:(NSString*)key
{
    return [Cryptor decodeDES:encode_data key:key];
}

+ (NSString*)des_encode_hex:(NSString*)data key:(NSString*)key
{
    return [Cryptor encodeDES_Hex:data key:key];
}
@end

@implementation NSString (TSecurity)

- (NSString*)base64Encode
{
    return [JPSecurity base64Encode:self];
}

- (NSString*)base64Decode
{
    NSString* s = [[NSString alloc] initWithData:[JPSecurity base64Decode:self] encoding:NSUTF8StringEncoding];
    return s;
}

- (NSString*)des_encode:(NSString*)key
{
    return [JPSecurity des_encode:self key:key];
}

- (NSString*)des_decode:(NSString*)key
{
    return [JPSecurity des_decode:self key:key];
}

- (NSString*)des_decode_hex:(NSString*)key
{
    return [JPSecurity des_encode_hex:self key:key];
}

- (NSString*)md5
{
    return [JPSecurity md5:self];
}
@end

@implementation NSData (JPSecurity)
- (NSString*)base64Encode
{
    return [JPSecurity base64Encode:self];
}
@end