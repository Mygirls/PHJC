//
//  JPHUD.h
//  shihang_ipad
//
//  Created by renpan on 14/11/10.
//  Copyright (c) 2014年 renpan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSObject+JPNSObjectExtend.h"

@interface JPHUD : NSObject
- (void)show_with_text:(NSString*)text delay:(NSTimeInterval)delay view:(UIView*)view animated:(BOOL)animated;

@end

#define JPHUDCurrent    [JPHUD current]