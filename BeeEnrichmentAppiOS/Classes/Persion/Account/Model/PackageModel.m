//
//  PackageModel.m
//  BeeEnrichmentAppiOS
//
//  Created by hwm on 2017/6/26.
//  Copyright © 2017年 DuLonglong. All rights reserved.
//

#import "PackageModel.h"

@implementation PackageModel

+(NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"Description" : @"description",
             @"ID" : @"id"
             };
}

@end


@implementation ConditionModel


@end

@implementation CouponModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"Value" : @"value"
             };
}

@end
