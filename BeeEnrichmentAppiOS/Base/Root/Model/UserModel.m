//
//  UserModel.m
//  BeeEnrichmentAppiOS
//
//  Created by hwm on 2017/6/26.
//  Copyright © 2017年 DuLonglong. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel

@end

@implementation MemberVipModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"ID" : @"id"
             };
}

@end

@implementation LevelModel


@end

@implementation MemberModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"ID" : @"id"
             };
}

@end

@implementation AccountCashModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"ID" : @"id"
             };
}

@end

@implementation BankCardsModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"ID" : @"id"
             };
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"thirdPayList" : [thirdPayListModel class]
             };
}

@end

@implementation thirdPayListModel



@end

@implementation MemberVipEntityModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"ID" : @"id",
             @"Description" : @"description"
             };
}

@end


