//
//  MoneyDetailOfSection.h
//  BeeEnrichmentAppiOS
//
//  Created by dll on 16/11/14.
//  Copyright © 2016年 didai. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MoneyDetailOfSectionType){
    MoneyDetailOfSectionTypeDetail = 0, // 项目详情
    MoneyDetailOfSectionTypePlatform = 1, // 合同详情
    MoneyDetailOfSectionTypeInvest = 2, // 投资记录
    MoneyDetailOfSectionTypeSafe = 3// 安全保障
    
};

typedef void(^MoneyDetailOfSectionBlock)(MoneyDetailOfSectionType type);

@interface MoneyDetailOfSection : UIView

@property (strong, nonatomic) IBOutlet UIView *detailPGM;
@property (strong, nonatomic) IBOutlet UIView *safePGM;
@property (strong, nonatomic) IBOutlet UIView *recordPGM;
@property (strong, nonatomic) IBOutlet UIView *contractPGM;
@property (strong, nonatomic) IBOutlet UILabel *markLabelM;
@property (strong, nonatomic) IBOutlet UIButton *detailBtnM;
@property (strong, nonatomic) IBOutlet UIButton *recordBtnM;
@property (strong, nonatomic) IBOutlet UIButton *safeBtnM;
@property (strong, nonatomic) IBOutlet UIButton *contractBtnM;
@property (nonatomic, copy) MoneyDetailOfSectionBlock clickMoneyDetailOfSectionBlock;

@end
