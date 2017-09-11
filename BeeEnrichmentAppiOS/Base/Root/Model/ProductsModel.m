//
//  ProductsModel.m
//  BeeEnrichmentAppiOS
//
//  Created by hwm on 2017/6/26.
//  Copyright © 2017年 DuLonglong. All rights reserved.
//

#import "ProductsModel.h"

@implementation ProductsModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"recommendedSubjectList" : [ProductsDetailModel class],
             @"subjectList" : [BeePlanModel class]
             };
}

@end

@implementation ProductsDetailModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"Period" : @"period",
             @"ID" : @"id"
             };
}

@end



@implementation ExtraModel
@end


@implementation BeePlanModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"ID":@"id"
             };
}

@end
