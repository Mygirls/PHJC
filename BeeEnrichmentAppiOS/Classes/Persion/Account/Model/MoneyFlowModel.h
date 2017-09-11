//
//  MoneyFlowModel.h
//  BeeEnrichmentAppiOS
//
//  Created by hwm on 2017/6/26.
//  Copyright © 2017年 DuLonglong. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SubjectCouponModel;
@interface MoneyFlowModel : NSObject

/*
 createTime = 1498629394164;
 isAutoBid = 0;
 orderNo = BPSU201706280000075143;
 reason = "\U8ba1\U5212\U5339\U914d\U6807\U7684";
 remark = "";
 status = 200;
 subjectCoupon =     {
 };
 title = SVIP;
 totalMoney = 16800;
 totalMoneyActual = 16800;
 */
@property (nonatomic, strong) NSString *createTime;
@property (nonatomic, assign) NSInteger isAutoBid;
@property (nonatomic, strong) NSString *orderNo;
@property (nonatomic, strong) NSString *reason;
@property (nonatomic, strong) NSString *remark;
//
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) SubjectCouponModel *subjectCoupon;
@property (nonatomic, assign) double totalMoney;
@property (nonatomic, assign) double totalMoneyActual;
@property (nonatomic, assign) NSInteger type;

@end

@interface SubjectCouponModel : NSObject

@property (nonatomic, assign) double value;
@property (nonatomic, assign) NSInteger type;

@end
