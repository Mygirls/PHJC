//
//  VipModel.h
//  BeeEnrichmentAppiOS
//
//  Created by hwm on 2017/6/27.
//  Copyright © 2017年 DuLonglong. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CouponListModel;
@interface VipModel : NSObject

@property (nonatomic, strong) NSArray<CouponListModel *> *couponList;
@property (nonatomic, strong) NSString *Description;
@property (nonatomic, assign) double difference;
@property (nonatomic, strong) NSURL *headImageUrl;
@property (nonatomic, strong) NSString *mobilePhone;
@property (nonatomic, assign) NSInteger total;
@property (nonatomic, assign) NSInteger vipLevel;
@end

@interface CouponListModel : NSObject

@property (nonatomic, assign) NSInteger available;
@property (nonatomic, strong) NSString *ID;
@property (nonatomic, assign) NSInteger maxBuyDays;
@property (nonatomic, strong) NSString *minBuyMoney;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *beginTime;
@property (nonatomic, strong) NSString *endTime;
@end
