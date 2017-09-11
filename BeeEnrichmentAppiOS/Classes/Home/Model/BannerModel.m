//
//  BannerModel.m
//  BeeEnrichmentAppiOS
//
//  Created by hwm on 2017/6/27.
//  Copyright © 2017年 DuLonglong. All rights reserved.
//

#import "BannerModel.h"

@implementation BannerModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"carouselCustomList" : [CarouselCustomListModel class],
             @"mainMenuList" : [MainMenuListModel class]
             };
}
@end

@implementation CarouselCustomListModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"ID" : @"id",
             @"Value" : @"value"
             };
}

@end

@implementation MainMenuListModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"ID" : @"id",
             @"Value" : @"value"
             };
}
@end
