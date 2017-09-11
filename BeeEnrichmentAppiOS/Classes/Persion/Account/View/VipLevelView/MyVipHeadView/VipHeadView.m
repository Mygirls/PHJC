//
//  VipHeadView.m
//  BeeEnrichmentAppiOS
//
//  Created by dll on 2017/6/8.
//  Copyright © 2017年 DuLonglong. All rights reserved.
//

#import "VipHeadView.h"
#import "VipModel.h"


@implementation VipHeadView

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)setDataDic:(VipModel *)dataDic
{
    _dataDic = dataDic;
    if (_dataDic == nil || [_dataDic isEqual:[NSNull null]]) {
        return;
    }
    NSString *mobilePhone = dataDic.mobilePhone;
    if (mobilePhone == nil) {
        _mobilePhoneLabel.text = @"";
    }else {
        _mobilePhoneLabel.text = [NSString stringWithFormat:@"Hi,%@****%@",[dataDic.mobilePhone substringToIndex:3],[dataDic.mobilePhone substringFromIndex:7]];
    }
    
    
    NSMutableAttributedString *pStr = [[NSMutableAttributedString alloc] initWithString:@"我的资产：" attributes:@{NSFontAttributeName:[UIFont fontWithName:FontOfAttributedRegular size:12], NSForegroundColorAttributeName: [UIColor colorWithHex:@"#ffffff"]}];
    
    NSMutableAttributedString *sStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.2f元",  floor(dataDic.total * 100)/100] attributes:@{NSFontAttributeName:[UIFont fontWithName:FontOfAttributedRegular size:15], NSForegroundColorAttributeName: [UIColor colorWithHex:@"#f95f53"]}];
    [pStr appendAttributedString:sStr];
    _myTotalMoneyLabel.attributedText = pStr;
    
    
    NSString *vipDescription = @"普通用户";
    NSString *restVip = @"";
    
    switch (dataDic.vipLevel) {
        case 100:
            vipDescription = @"普通会员";
            restVip = @"VIP会员";
            break;
        case 200:
            vipDescription = @"普通会员";
            restVip = @"VIP会员";
            break;
        case 300:
            vipDescription = @"VIP会员";
            restVip = @"SVIP会员";
            break;
        case 400:
            vipDescription = @"SVIP会员";
            restVip = @"SVIP会员";
            break;
        default:
            break;
    }
    
    // 下划线
    NSMutableAttributedString *prefixStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"距%@还差%.2f元，", restVip, floor(dataDic.difference * 100) /100] attributes:@{NSFontAttributeName:[UIFont fontWithName:FontOfAttributed size:12], NSForegroundColorAttributeName: [UIColor colorWithHex:@"#676767"]}];
    NSMutableAttributedString *suffixStr = [[NSMutableAttributedString alloc]initWithString:@"马上去升级" attributes:@{NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle], NSForegroundColorAttributeName: [UIColor colorWithHex:@"#ff7357"], NSFontAttributeName:[UIFont fontWithName:FontOfAttributed size:12],}];
    [prefixStr appendAttributedString:suffixStr];
    if (dataDic.vipLevel == 400) {
        _contentLabel.text = @"您已经是最高等级了，一定要保持哦。";
    } else {
        _contentLabel.attributedText = prefixStr;
    }
    _vipLevelLabel.text = vipDescription;

    [_headImageView sd_setImageWithURL:dataDic.headImageUrl placeholderImage:[UIImage imageNamed:@"default_personal"]];
    _headImageView.layer.cornerRadius = 75 * kScreenWidth / 375 / 2;
    [_headImageView.layer setMasksToBounds:YES];
    
}

- (IBAction)backBtnAction:(id)sender {
    if (_backbtn) {
        self.backbtn();
    }
    
}
- (IBAction)goInvesting:(id)sender {
    if (_goInvesting) {
        self.goInvesting();
    }
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

- (id)valueForUndefinedKey:(NSString *)key
{
    return nil;
}

@end
