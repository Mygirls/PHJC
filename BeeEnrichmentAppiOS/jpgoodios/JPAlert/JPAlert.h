//
//  JPAlert.h
//  ShiHang
//
//  Created by jacksonpan on 14-9-15.
//  Copyright (c) 2014年 xizhe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSObject+JPNSObjectExtend.h"

typedef void(^buttonCallback)(UIAlertView* alert, NSInteger index);

@interface JPAlert : NSObject
- (UIAlertView*)showAlertWithTitle:(NSString*)title content:(NSString*)content button:(id)button block:(buttonCallback)block;
- (UIAlertView*)showAlertWithTitle:(NSString*)title content:(NSString*)content button:(id)button alertViewStyle:(UIAlertViewStyle)alertViewStyle block:(buttonCallback)block;
- (UIAlertView*)showAlertWithTitle:(NSString *)title button:(id)button;

//- (UIAlertView*)showTipWithContent:(NSString*)content button:(id)button block:(buttonCallback)block;
//- (UIAlertView*)showAlertWithContent:(NSString*)content button:(id)button block:(buttonCallback)block;
@end
