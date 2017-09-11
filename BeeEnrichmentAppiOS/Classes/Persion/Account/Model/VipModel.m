//
//  VipModel.m
//  BeeEnrichmentAppiOS
//
//  Created by hwm on 2017/6/27.
//  Copyright © 2017年 DuLonglong. All rights reserved.
//

#import "VipModel.h"

@implementation VipModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"Description" : @"description"
             };
}
+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"couponList" : [CouponListModel class]
             };
}
@end

@implementation CouponListModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"ID" : @"id"
             };
}

@end
