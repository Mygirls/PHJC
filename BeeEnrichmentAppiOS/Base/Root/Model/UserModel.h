//
//  UserModel.h
//  BeeEnrichmentAppiOS
//
//  Created by hwm on 2017/6/26.
//  Copyright © 2017年 DuLonglong. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MemberModel, MemberVipModel, LevelModel, AccountCashModel, BankCardsModel, MemberVipEntityModel, thirdPayListModel;

@interface UserModel : NSObject

@property (nonatomic, strong) MemberModel *member;
@property (nonatomic, strong) MemberVipModel *memberVip;
@property (nonatomic, assign) double depositIncome;
@property (nonatomic, strong) NSString *depositMoney;
@property (nonatomic, assign) double investingMoney;
// 可提现金额
@property (nonatomic, assign) double doingWithdrawMoney;

@end

@interface MemberVipModel : NSObject

@property (nonatomic, strong) LevelModel *level;

@end

@interface LevelModel : NSObject

@property (nonatomic, strong) NSString *rank;

@end

@interface MemberModel : NSObject

@property (nonatomic, strong) AccountCashModel *accountCash;
@property (nonatomic, strong) BankCardsModel *bankCards;
@property (nonatomic, strong) MemberVipEntityModel *memberVipEntity;
@property (nonatomic, assign) NSInteger accountCashId;
@property (nonatomic, assign) NSInteger age;
@property (nonatomic, assign) NSInteger accessId;
@property (nonatomic, strong) NSString *createTime;
@property (nonatomic, assign) NSInteger disabled;
@property (nonatomic, assign) NSInteger enableAutoBid;
@property (nonatomic, assign) NSInteger enableAutoWithdrawalApply;
@property (nonatomic, strong) NSString *esReason;
@property (nonatomic, strong) NSString *fromWhere;
@property (nonatomic, assign) NSInteger hadBindCard;
@property (nonatomic, assign) NSInteger hasEs;
@property (nonatomic, assign) NSInteger hasPayPassword;
@property (nonatomic, strong) NSString *headImageUrl;
@property (nonatomic, strong) NSString *idCard;
@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *inviteIncomePercentLevel2;
@property (nonatomic, strong) NSString *inviteIncomePercentLevel3;
@property (nonatomic, strong) NSString *invitedMobilePhone;
@property (nonatomic, assign) NSInteger isFirst;
@property (nonatomic, strong) NSString *mail;
@property (nonatomic, strong) NSString *memberVipExpiredTime;
@property (nonatomic, strong) NSString *memberVipId;
@property (nonatomic, strong) NSString *mobilePhone;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *payPassword;
@property (nonatomic, strong) NSString *points;
@property (nonatomic, strong) NSString *realname;
@property (nonatomic, strong) NSString *remainingSum;
@property (nonatomic, strong) NSString *salesmanMobilePhone;
@property (nonatomic, strong) NSString *sex;
@property (nonatomic, strong) NSString *statusDescription;
@property (nonatomic, strong) NSString *system;
// 客户来源: 1 老用户
@property (nonatomic, assign) NSInteger sourceFrom;
// 是否绑定银行卡: 1 没有绑定
@property (nonatomic, assign) NSInteger isBindMobilePhone;

@end


@interface AccountCashModel : NSObject

@property (nonatomic, strong) NSString *collection;
@property (nonatomic, strong) NSString *collectionRate;
@property (nonatomic, assign) NSInteger deleted;
@property (nonatomic, strong) NSString *historyInvestMoney;
@property (nonatomic, strong) NSString *historyRate;
@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *investTotalMoney;
@property (nonatomic, strong) NSString *memberId;
@property (nonatomic, strong) NSString *noUseMoney;
@property (nonatomic, assign) double total;
@property (nonatomic, assign) double useMoney;
@property (nonatomic, strong) NSString *useRecharge;


@end

@interface BankCardsModel : NSObject

@property (nonatomic, strong) NSString *bankCardId;
@property (nonatomic, strong) NSString *bankCode;
@property (nonatomic, strong) NSString *bankId;
@property (nonatomic, strong) NSString *bankTitle;
@property (nonatomic, strong) NSString *cardType;
@property (nonatomic, strong) NSString *createTime;
@property (nonatomic, strong) NSString *deleted;
@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *idCard;
@property (nonatomic, strong) NSString *memberId;
@property (nonatomic, strong) NSString *mobilePhone;
@property (nonatomic, strong) NSString *realname;
@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *dailyLimit;
@property (nonatomic, strong) NSString *gradientBottom;
@property (nonatomic, strong) NSString *gradientTop;
@property (nonatomic, strong) NSString *hot;
@property (nonatomic, strong) NSString *logoUrl;
@property (nonatomic, strong) NSString *monthlyLimit;
@property (nonatomic, strong) NSString *singleLimit;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSMutableArray<thirdPayListModel *> *thirdPayList;

@end

#pragma mark 银行卡支持的支付通道
@interface thirdPayListModel : NSObject

@property (nonatomic, strong) NSString *platform;
@property (nonatomic, assign) double dailyLimit;
@property (nonatomic, strong) NSString *payKey;

@end

@interface MemberVipEntityModel : NSObject

@property (nonatomic, strong) NSString *createTime;
@property (nonatomic, strong) NSString *Description;
@property (nonatomic, assign) NSInteger level;
@property (nonatomic, strong) NSString *ID;

@end



