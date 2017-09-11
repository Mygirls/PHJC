//
//  PlanDetailHeaderView.h
//  BeeEnrichmentAppiOS
//
//  Created by dll on 2017/5/19.
//  Copyright © 2017年 DuLonglong. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^ClickActionBlock)();

@interface PlanDetailCustomView : UIView
@property (strong, nonatomic) IBOutlet UILabel *leftLabel;
@property (strong, nonatomic) IBOutlet UILabel *rightLabel;
@property (strong, nonatomic) IBOutlet UIView *LineView;

@property (nonatomic, copy) ClickActionBlock clickLeftBtn;

@property (nonatomic, copy) ClickActionBlock clickRightBtn;
@end
