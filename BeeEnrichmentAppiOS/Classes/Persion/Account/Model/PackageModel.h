//
//  PackageModel.h
//  BeeEnrichmentAppiOS
//
//  Created by hwm on 2017/6/26.
//  Copyright © 2017年 DuLonglong. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ConditionModel, CouponModel;

@interface PackageModel : NSObject

//// 历史加息券
//@property (nonatomic, strong) HistoryPackageModel *increaseRates;
//// 历史红包
//@property (nonatomic, strong) HistoryPackageModel *redPacket;
//// 历史体验金
//@property (nonatomic, strong) HistoryPackageModel *experienceGold;

@property (nonatomic, strong) NSString *autoSend;
@property (nonatomic, strong) NSString *createTime;
@property (nonatomic, strong) NSString *Description;
@property (nonatomic, strong) NSString *detail;
@property (nonatomic, assign) NSInteger disabled;
@property (nonatomic, assign) NSInteger everyCount;
@property (nonatomic, assign) NSInteger ID;
@property (nonatomic, assign) NSInteger leftCount;
@property (nonatomic, assign) NSInteger marketType;
@property (nonatomic, assign) NSInteger outCount;
@property (nonatomic, strong) NSString *title;
// 10加息 20抵扣券 30红包 40体验金
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) NSInteger used;
// 加息券
@property (nonatomic, strong) NSString *value;
@property (nonatomic, strong) ConditionModel *condition;
@property (nonatomic, strong) NSString *memberCouponId;
@property (nonatomic, strong) CouponModel *coupon;
@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, strong) NSString *url;

@end


@interface ConditionModel : NSObject

@property (nonatomic, strong) NSString *beginTime;
@property (nonatomic, strong) NSString *endTime;
@property (nonatomic, assign) NSInteger maxBuyDays;
@property (nonatomic, assign) double minBuyMoney;

@end

@interface CouponModel : NSObject

@property (nonatomic, assign) double Value;
@property (nonatomic, strong) ConditionModel *condition;
@property (nonatomic, assign) NSInteger type;
@end
