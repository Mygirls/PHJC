//
//  HeaderView.h
//  BeeEnrichmentAppiOS
//
//  Created by hwm on 16/10/11.
//  Copyright © 2016年 didai. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, HeaderViewButtonType) {
    HeaderViewButtonTypeIcon = 0,
    HeaderViewButtonTypeVIP = 1, // vip
    HeaderViewButtonTypeSetting = 2,// 设置
    HeaderViewButtonTypeTotalMoney = 3, // 累计收益
    HeaderViewButtonTypePrinMoney = 4, // 投资本金
    HeaderViewButtonTypeRestMoney = 5, //提现
    HeaderViewButtonTypeRestJiuzhan // 旧站数据
};

typedef void(^HeaderViewBlock)(HeaderViewButtonType index);
@interface HeaderView : UIView
@property (nonatomic, strong) UserModel *model;
@property (nonatomic, strong) HeaderViewBlock clickHeaderViewBlock;
@property (strong, nonatomic) IBOutlet UILabel *vipImageLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;// 头像
@end
