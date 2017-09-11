//
//  ProOfHeadView.h
//  BeeEnrichmentAppiOS
//
//  Created by dll on 16/11/2.
//  Copyright © 2016年 didai. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, headButtonType) {
    ButtonTypeBankCard = 110,//返回
    ButtonTypeRecharge = 111,//计算器
};

@interface ProOfHeadView : UIView
@property (nonatomic, strong) ProductsDetailModel *dic;
@property (strong, nonatomic) IBOutlet UILabel *projectTitle;//标题
@property(nonatomic,copy)void(^headBtnClickCallBack)(headButtonType type);

@end
