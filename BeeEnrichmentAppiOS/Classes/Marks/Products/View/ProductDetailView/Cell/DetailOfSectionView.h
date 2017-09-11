//
//  DetailOfSectionView.h
//  BeeEnrichmentAppiOS
//
//  Created by dll on 16/11/2.
//  Copyright © 2016年 didai. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, DetailOfSectionViewType) {
    DetailOfSectionViewTypeDetail = 0, // 项目详情
    DetailOfSectionViewTypeRecord = 1, // 投资记录
    DetailOfSectionViewTypeSafe // 安全保障
};
typedef void(^DetailOfSectionViewBlock)(DetailOfSectionViewType);
@interface DetailOfSectionView : UIView
@property (strong, nonatomic) IBOutlet UIView *detailPG;
@property (strong, nonatomic) IBOutlet UIView *safePG;
@property (strong, nonatomic) IBOutlet UIView *recordPG;
@property (strong, nonatomic) IBOutlet UILabel *markLabel;
@property (nonatomic, copy) DetailOfSectionViewBlock DetailOfSectionViewBlockClick;
@property (strong, nonatomic) IBOutlet UIButton *detailBtn;
@property (strong, nonatomic) IBOutlet UIButton *recordBtn;
@property (strong, nonatomic) IBOutlet UIButton *safeBtn;


@end
