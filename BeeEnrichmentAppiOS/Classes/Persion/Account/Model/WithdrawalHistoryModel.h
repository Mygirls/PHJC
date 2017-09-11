//
//  WithdrawalHistoryModel.h
//  BeeEnrichmentAppiOS
//
//  Created by hwm on 2017/6/26.
//  Copyright © 2017年 DuLonglong. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BankCardRecordModel;

@interface WithdrawalHistoryModel : NSObject
@property (nonatomic, assign) double total;
@property (nonatomic, strong) NSString *createTime;
// 0等待审核 100提现中 200提现成功 300失败 400失败
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, strong) NSString *reason;
@property (nonatomic, strong) NSString *auditRemark;
@property (nonatomic, strong) NSString *remark;
@property (nonatomic, strong) BankCardRecordModel *bankCardRecord;
@property (nonatomic, strong) BankCardRecordModel *memberBankCardRecord;

@end

@interface BankCardRecordModel : NSObject

@property (nonatomic, strong) NSString *bankCardId;
@property (nonatomic, strong) NSString *bankTitle;

@end
