//
//  PlanDetailHeaderView.m
//  BeeEnrichmentAppiOS
//
//  Created by dll on 2017/5/19.
//  Copyright © 2017年 DuLonglong. All rights reserved.
//

#import "PlanDetailCustomView.h"

@implementation PlanDetailCustomView

- (IBAction)leftClickAction:(id)sender {
    if (_clickLeftBtn) {
        self.clickLeftBtn();
    }
}

- (IBAction)rightClickAction:(id)sender {
    if (_clickRightBtn) {
        self.clickRightBtn();
    }
}

@end
