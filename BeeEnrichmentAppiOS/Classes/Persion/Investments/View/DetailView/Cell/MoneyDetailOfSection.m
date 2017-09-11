//
//  MoneyDetailOfSection.m
//  BeeEnrichmentAppiOS
//
//  Created by dll on 16/11/14.
//  Copyright © 2016年 didai. All rights reserved.
//

#import "MoneyDetailOfSection.h"

@implementation MoneyDetailOfSection

- (void)awakeFromNib {
    [super awakeFromNib];
    self.markLabelM.clipsToBounds = YES;
}

- (IBAction)clickDetailM:(id)sender {
    if (self.clickMoneyDetailOfSectionBlock) {
        self.clickMoneyDetailOfSectionBlock(MoneyDetailOfSectionTypeDetail);
    }
    self.detailPGM.hidden = NO;
    self.recordPGM.hidden = YES;
    self.safePGM.hidden = YES;
    self.contractPGM.hidden = YES;
    self.detailBtnM.selected = YES;
    self.recordBtnM.selected = NO;
    self.safeBtnM.selected = NO;
    self.contractBtnM.selected = NO;
    
}

- (IBAction)clickRecordM:(id)sender {
    
    if (self.clickMoneyDetailOfSectionBlock) {
        self.clickMoneyDetailOfSectionBlock(MoneyDetailOfSectionTypeInvest);
    }
    self.detailPGM.hidden = YES;
    self.recordPGM.hidden = NO;
    self.safePGM.hidden = YES;
    self.contractPGM.hidden = YES;
    
    self.detailBtnM.selected = NO;
    self.recordBtnM.selected = YES;
    self.safeBtnM.selected = NO;
    self.contractBtnM.selected = NO;
    self.markLabelM.hidden = YES;
    
    
}

- (IBAction)clickSafeM:(id)sender {
    if (self.clickMoneyDetailOfSectionBlock) {
        self.clickMoneyDetailOfSectionBlock(MoneyDetailOfSectionTypeSafe);
    }
    self.detailPGM.hidden = YES;
    self.recordPGM.hidden = YES;
    self.safePGM.hidden = NO;
    self.contractPGM.hidden = YES;
    
    self.detailBtnM.selected = NO;
    self.recordBtnM.selected = NO;
    self.safeBtnM.selected = YES;
    self.contractBtnM.selected = NO;
        
}
- (IBAction)clickContractM:(id)sender {
    
    if (self.clickMoneyDetailOfSectionBlock) {
        self.clickMoneyDetailOfSectionBlock(MoneyDetailOfSectionTypePlatform);
    }
    self.detailPGM.hidden = YES;
    self.recordPGM.hidden = YES;
    self.safePGM.hidden = YES;
    self.contractPGM.hidden = NO;
    
    
    self.detailBtnM.selected = NO;
    self.recordBtnM.selected = NO;
    self.safeBtnM.selected = NO;
    self.contractBtnM.selected = YES;
    
    
}

@end
