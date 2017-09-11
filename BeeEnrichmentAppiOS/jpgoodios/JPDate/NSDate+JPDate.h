//
//  NSDate+JPDate.h
//  ShiHang
//
//  Created by renpan on 14/10/13.
//  Copyright (c) 2014年 xizhe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (JPDate)
- (void)test;
+ (NSString*)getCurrentTime;

+ (NSInteger)current_year;
+ (BOOL)is_leap_year:(NSInteger)year;
@end
