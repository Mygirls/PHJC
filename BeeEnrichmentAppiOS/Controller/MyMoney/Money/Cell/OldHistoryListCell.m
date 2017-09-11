//
//  OldHistoryListCell.m
//  BeeEnrichmentAppiOS
//
//  Created by hwm on 2017/7/6.
//  Copyright © 2017年 DuLonglong. All rights reserved.
//

#import "OldHistoryListCell.h"

@implementation OldHistoryListCell


- (void)setFrame:(CGRect)frame {
    
    frame.origin.x += 15;
    frame.size.width -= 30;
    
    [super setFrame:frame];
    
}

@end
