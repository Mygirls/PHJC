//
//  JPAlert.m
//  ShiHang
//
//  Created by jacksonpan on 14-9-15.
//  Copyright (c) 2014年 xizhe. All rights reserved.
//

#import "JPAlert.h"

@interface JPAlert () <UIAlertViewDelegate>
{
   
}
@property (nonatomic, strong) buttonCallback blockbuttonCallback;

@end

@implementation JPAlert
ShareInstanceDefine

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(_blockbuttonCallback)
    {
        _blockbuttonCallback(alertView, buttonIndex);
    }
}

- (UIAlertView*)showAlertWithTitle:(NSString*)title content:(NSString*)content button:(id)button block:(buttonCallback)block
{
    _blockbuttonCallback = block;
//    NSNumber *number = [[[NSNumberFormatter alloc] init] numberFromString:[[UIDevice currentDevice] systemVersion]];
//    NSComparisonResult result = [number compare:@(9.0)];
//    _blockbuttonCallback = block;
//    if (result == NSOrderedSame || result == NSOrderedDescending) {
//        //>=9.0版本
//        UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:content preferredStyle:UIAlertControllerStyleAlert];
//        if([button isKindOfClass:[NSString class]])
//        {
//            [alert addAction:[UIAlertAction actionWithTitle:button style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                _blockbuttonCallback(nil, 0);
//            }]];
//        }
//        else if([button isKindOfClass:[NSArray class]])
//        {
//            NSArray *buttons = button;
//            for (int i = 0; i < buttons.count; i++ ) {
//                [alert addAction:[UIAlertAction actionWithTitle:buttons[i] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                    _blockbuttonCallback(nil, i);
//                }]];
//            }
//        }
//        else
//        {
//            return nil;
//        }
//    }else
//    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title message:content delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
        if([button isKindOfClass:[NSString class]])
        {
            [alert addButtonWithTitle:button];
        }
        else if([button isKindOfClass:[NSArray class]])
        {
            for(NSString* t in button)
            {
                [alert addButtonWithTitle:t];
            }
        }
        else
        {
            return nil;
        }
        
        [alert show];
        return alert;
//    }
 
}

- (UIAlertView*)showAlertWithTitle:(NSString*)title content:(NSString*)content button:(id)button alertViewStyle:(UIAlertViewStyle)alertViewStyle block:(buttonCallback)block
{
    _blockbuttonCallback = block;
    
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title message:content delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
    if([button isKindOfClass:[NSString class]])
    {
        [alert addButtonWithTitle:button];
    }
    else if([button isKindOfClass:[NSArray class]])
    {
        for(NSString* t in button)
        {
            [alert addButtonWithTitle:t];
        }
    }
    else
    {
        return nil;
    }
    alert.alertViewStyle = alertViewStyle;
    [alert show];
    return alert;
}

- (UIAlertView*)showTipWithContent:(NSString*)content button:(id)button block:(buttonCallback)block
{
    return [self showAlertWithTitle:NSLocalizedString(@"Tip", @"提示") content:content button:button block:block];
}

- (UIAlertView*)showAlertWithContent:(NSString*)content button:(id)button block:(buttonCallback)block
{
    return [self showAlertWithTitle:NSLocalizedString(@"Alert", @"警告") content:content button:button block:block];
}

- (UIAlertView*)showAlertWithTitle:(NSString *)title button:(id)button
{
    return [self showAlertWithTitle:title content:nil button:button block:nil];
}

@end
