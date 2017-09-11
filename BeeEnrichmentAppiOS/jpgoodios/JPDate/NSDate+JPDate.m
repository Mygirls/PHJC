//
//  NSDate+JPDate.m
//  ShiHang
//
//  Created by renpan on 14/10/13.
//  Copyright (c) 2014年 xizhe. All rights reserved.
//

#import "NSDate+JPDate.h"

@implementation NSDate (JPDate)

- (void)test
{
    NSString* d = [self description];
    DLog(@"%@", d);
    
    NSDate* d2 = [NSDate dateWithTimeIntervalSinceReferenceDate:1];
    DLog(@"%@", d2);
}

+ (NSString*)getCurrentTime
{
    NSDateFormatter* fmt = [[NSDateFormatter alloc] init];
    NSDate* today = [NSDate date];
    [fmt setDateFormat:@"yyyyMMddHHmmss"];
    NSString* date = [fmt stringFromDate:today];
    return date;
}

+ (NSInteger)current_year
{
    NSDateFormatter* fmt = [[NSDateFormatter alloc] init];
    NSDate* today = [NSDate date];
    [fmt setDateFormat:@"yyyy"];
    NSString* year = [fmt stringFromDate:today];
    return [year integerValue];
}

+ (BOOL)is_leap_year:(NSInteger)year
{
    BOOL ret = NO;
    if (year%4==0)
    {
        if (year%100==0)
        {
            if (year%400==0) //能被400整除的,是闰年
            {
                ret = YES;
            }
            else //能被100整除,但不能被400整除的,不是闰年
            {
                ret = NO;
            }
        }
        else //能被4整除,但不能被100整除的,不是闰年
        {
            ret = YES;
        }
    }
    else //不能被4整除的,不是闰年
    {
        ret = NO;
    }
    return ret;
}


@end
