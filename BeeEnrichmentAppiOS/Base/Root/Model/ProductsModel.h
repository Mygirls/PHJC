//
//  ProductsModel.h
//  BeeEnrichmentAppiOS
//
//  Created by hwm on 2017/6/26.
//  Copyright © 2017年 DuLonglong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PackageModel.h"


@class  ProductsDetailModel, ExtraModel, BeePlanModel;

//MARK: - 1.ProductsDetailModel
@interface ProductsModel : NSObject

@property (nonatomic, strong) NSMutableArray<ProductsDetailModel *> *recommendedSubjectList;
@property (nonatomic, strong) ProductsDetailModel *qiangGou;
@property (nonatomic, strong) BeePlanModel *beePlan;
@property (nonatomic, strong) NSMutableArray<BeePlanModel *> *subjectList;


@end

//MARK: - 2.ProductsDetailModel
@interface ProductsDetailModel : NSObject

@property (nonatomic, strong) NSString *title;
// 200   100  300
@property (nonatomic, assign) NSInteger repaymentId;
// 单位  2 :月  1: 天
@property (nonatomic, assign) NSInteger units;
@property (nonatomic, strong) NSString *finishTime;//到期时间

// 期限
@property (nonatomic, assign) NSInteger Period;
@property (nonatomic, assign) NSInteger purchaseMinAmount;
@property (nonatomic, assign) double expectedAnnualRate;
@property (nonatomic, assign) double addAnnualRate;

// 10: 优选计划标的 20: 散标 30: 转让标的
@property (nonatomic, assign) NSInteger marketType;
@property (nonatomic, assign) double actualAnnualRate;

// 右上角标签: 100 新人专享 200手机专享  300定向标 400普通标 900预告标 
@property (nonatomic, assign) NSInteger subjectType;

// 100预告 300已售完 400计息中 500已兑付
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, assign) NSInteger isNewer;
@property (nonatomic, assign) double currentMoney;
@property (nonatomic, assign) double parentMoney;
@property (nonatomic, assign) double remainingAmount;
@property (nonatomic, assign) double financingAmount;
@property (nonatomic, strong) NSString *subjectCustomerPassword;
@property (nonatomic, assign) NSInteger enableCoupon;
@property (nonatomic, assign) NSInteger purchaseMaxAmount;
@property (nonatomic, strong) NSURL *productDescriptionUrl;
@property (nonatomic, assign) NSInteger bearingTheWay;
@property (nonatomic, assign) NSInteger monthLimit;
@property (nonatomic, assign) NSInteger repaymentIdId;
@property (nonatomic, strong) ExtraModel *extra;
@property (nonatomic, assign) NSInteger buyPeopleCount;
@property (nonatomic, strong) NSString *beginTime;
@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *rightTopTitle;
@property (nonatomic, assign) double timeLimit;
@property (nonatomic, assign) NSInteger productType;
@property (nonatomic, strong) NSString *endTime;
@property (nonatomic, strong) NSString *fullTime;
@property (nonatomic, strong) NSString *safeInfomationUrl;

@property (nonatomic, assign) double totalMoney;
@property (nonatomic, assign) double expectedIncome;



@end

//MARK: - 3.BeePlanModel
@interface BeePlanModel : NSObject

// 创建时间
@property (nonatomic, strong) NSString *createTime;
@property (nonatomic, strong) NSString *customAnnualRate;
@property (nonatomic, strong) ProductsDetailModel *beePlan;
@property (nonatomic, assign) double totalMoney;
@property (nonatomic, assign) double expectedIncome;
@property (nonatomic, strong) NSString *regularEndTime;
@property (nonatomic, strong) NSString *regularStartTime;
// 201 计息中
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, strong) NSString *contractUrl;
@property (nonatomic, strong) ProductsDetailModel *subject;
@property (nonatomic, strong) NSString *bpOrder;
@property (nonatomic, strong) CouponModel *coupon;
@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) ProductsDetailModel *order;
@property (nonatomic, strong) NSString *orderNo;
@property (nonatomic, strong) NSString *restMonthDescription;
@property (nonatomic, assign) NSInteger restMonthLimits;
@property (nonatomic, strong) NSString *restDaysDescription;
@property (nonatomic, assign) NSInteger restDays;
@property (nonatomic, assign) NSInteger dayTotal;


@end


//MARK: - 4. ExtraModel
@interface ExtraModel : NSObject

@property (nonatomic, strong) NSString *recentlyBackMoneyTime;
@property (nonatomic, strong) NSString *restTerms;
@property (nonatomic, assign) NSInteger daysRemaining;
@property (nonatomic, assign) double money;
@property (nonatomic, assign) double moneyAndInterest;
@property (nonatomic, assign) NSInteger totalDay;

@end
