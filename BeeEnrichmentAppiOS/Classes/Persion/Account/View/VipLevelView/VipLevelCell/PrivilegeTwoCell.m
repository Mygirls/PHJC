//
//  PrivilegeTwoCell.m
//  BeeEnrichmentAppiOS
//
//  Created by dll on 2017/6/8.
//  Copyright © 2017年 DuLonglong. All rights reserved.
//

#import "PrivilegeTwoCell.h"
#import "VipModel.h"

@implementation PrivilegeTwoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setPTDic:(VipModel *)pTDic
{
    _pTDic = pTDic;
    if (pTDic == nil || [pTDic isEqual:[NSNull null]] ) {
        return;
    }
    switch (pTDic.vipLevel) {
        case 100:
            // 什么都不用点亮
            break;
        case 200:
            _commonBirthdayBtn.selected = YES;
            //                [_commonBirthdayBtn ]
            break;
        case 300:
            _commonBirthdayBtn.selected = YES;
            _vipHolidayBtn.selected = YES;
            _vipUpgradeBtn.selected = YES;
            _vipBirthdayBtn.selected = YES;
            _vipSurpriseBtn.selected = YES;
            break;
        case 400:
            _commonBirthdayBtn.selected = YES;
            _vipHolidayBtn.selected = YES;
            _vipUpgradeBtn.selected = YES;
            _vipBirthdayBtn.selected = YES;
            _vipSurpriseBtn.selected = YES;
            _svipHolidayBtn.selected = YES;
            _svipUpgradeBtn.selected = YES;
            _svipBirthdayBtn.selected = YES;
            _svipSurpriseBtn.selected = YES;
            break;
        default:
            break;
    }

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
