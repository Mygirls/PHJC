//
//  SubPlanListViewController.h
//  BeeEnrichmentAppiOS
//
//  Created by dll on 2017/5/25.
//  Copyright © 2017年 DuLonglong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SubPlanListViewController : UIViewController
@property (nonatomic, strong) NSArray<BeePlanModel *> *dataArr;
@property (nonatomic, strong) NSString *subPlanListTitle;
@end
