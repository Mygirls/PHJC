//
//  MessagesModel.m
//  BeeEnrichmentAppiOS
//
//  Created by hwm on 2017/6/27.
//  Copyright © 2017年 DuLonglong. All rights reserved.
//

#import "MessagesModel.h"

@implementation MessagesModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"Description" : @"description",
             @"ID" : @"id"
             };
}
@end
