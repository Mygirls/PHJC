//
//  UITabBar+badge.h
//  BeeEnrichmentAppiOS
//
//  Created by hwm on 16/11/2.
//  Copyright © 2016年 didai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBar (badge)
- (void)showBadgeOnItemIndex:(int)index;

- (void)hideBadgeOnItemIndex:(int)index;
@end
