//
//  JPJson.m
//  ShiHang
//
//  Created by jacksonpan on 14-9-14.
//  Copyright (c) 2014年 xizhe. All rights reserved.
//

#import "JPJson.h"
#import "SBJson5.h"

@interface JPJson ()
@property (nonatomic, strong) id sbjson4_json_value;
@end

@implementation JPJson
@synthesize stringEncoding;
ShareInstanceDefine
- (void)_init
{
    stringEncoding = NSUTF8StringEncoding;
}

- (id)sbjson4_json_value_with_string:(NSString*)string
{
    SBJson5Parser* jsonParser = [SBJson5Parser parserWithBlock:^(id item, BOOL *stop) {
        self.sbjson4_json_value = item;
    } allowMultiRoot:NO unwrapRootArray:NO maxDepth:3 errorHandler:^(NSError *error) {
        _NSLog(@"%@", error);
    }];
    SBJson5ParserStatus status = [jsonParser parse:[string dataUsingEncoding:NSUTF8StringEncoding]];
    
    
//    SBJson4Parser *jsonParser = [SBJson4Parser parserWithBlock:^(id item, BOOL *stop) {
//        self.sbjson4_json_value = item;
//    } allowMultiRoot:NO unwrapRootArray:NO errorHandler:^(NSError *error) {
//        _NSLog(@"%@", error);
//    }];
//    SBJson4ParserStatus status = [jsonParser parse:[string dataUsingEncoding:NSUTF8StringEncoding]];
//    if(status == SBJson4ParserError)
    if(status == SBJson5ParserError)
    {
        _NSLog(@"SBJson5ParserError");
    }
    return self.sbjson4_json_value;
}
@end

@implementation NSObject (JPJson)
- (NSString *)JSONRepresentation
{
    SBJson5Writer* jsonWriter = [SBJson5Writer new];
    NSString* json = [jsonWriter stringWithObject:self];
    
//    SBJson4Writer *jsonWriter = [SBJson4Writer new];
//    NSString *json = [jsonWriter stringWithObject:self];
    if (!json)
        NSLog(@"-JSONRepresentation failed. Error trace is: %@", [jsonWriter error]);
    return json;
}
@end

@implementation NSString (JPJson)
- (id)json
{
    NSError* err = nil;
    id ret = [NSJSONSerialization JSONObjectWithData:[self dataUsingEncoding:[[JPJson current] stringEncoding]] options:NSJSONReadingAllowFragments error:&err];
    if(err)
    {
        NSLog(@"json error: %@", err);
    }
    return ret;
}

- (id)JSONValue
{
    return [[JPJson current] sbjson4_json_value_with_string:self];
}
@end

@implementation NSData (JPJson)
- (id)json
{
    NSError* err = nil;
    id ret = [NSJSONSerialization JSONObjectWithData:self options:NSJSONReadingAllowFragments error:&err];
    if(err)
    {
        NSLog(@"json error: %@", err);
    }
    return ret;
}
@end

@implementation NSDictionary (JPJson)
- (NSData*)to_json_data
{
    if([NSJSONSerialization isValidJSONObject:self] == NO)
    {
        return nil;
    }
    NSError* err = nil;
    NSData* data = [NSJSONSerialization dataWithJSONObject:self options:0 error:&err];
    if(err)
    {
        NSLog(@"to_json_string error: %@", err);
    }
    return data;
}

- (NSString*)to_json_string
{
    NSString* ret = nil;
    NSData* data = [self to_json_data];
    if(data)
    {
        ret = [[NSString alloc] initWithData:data encoding:[[JPJson current] stringEncoding]];
    }
    return ret;
}
@end

@implementation NSArray (JPJson)
- (NSData*)to_json_data
{
    if([NSJSONSerialization isValidJSONObject:self] == NO)
    {
        return nil;
    }
    NSError* err = nil;
    NSData* data = [NSJSONSerialization dataWithJSONObject:self options:0 error:&err];
    if(err)
    {
        NSLog(@"to_json_string error: %@", err);
    }
    return data;
}

- (NSString*)to_json_string
{
    NSString* ret = nil;
    NSData* data = [self to_json_data];
    if(data)
    {
        ret = [[NSString alloc] initWithData:data encoding:[[JPJson current] stringEncoding]];
    }
    return ret;
}
@end

@implementation NSNull (JPJson)
- (NSData*)to_json_data
{
    if([NSJSONSerialization isValidJSONObject:self] == NO)
    {
        return nil;
    }
    NSError* err = nil;
    NSData* data = [NSJSONSerialization dataWithJSONObject:self options:0 error:&err];
    if(err)
    {
        NSLog(@"to_json_string error: %@", err);
    }
    return data;
}

- (NSString*)to_json_string
{
    NSString* ret = nil;
    NSData* data = [self to_json_data];
    if(data)
    {
        ret = [[NSString alloc] initWithData:data encoding:[[JPJson current] stringEncoding]];
    }
    return ret;
}

- (id)json
{
    return self;
}
@end
