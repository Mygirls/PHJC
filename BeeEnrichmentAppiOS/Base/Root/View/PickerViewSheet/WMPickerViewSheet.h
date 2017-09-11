//
//  WMPickerViewSheet.h
//  BeeCarLoanClient
//
//  Created by hwm on 16/6/14.
//  Copyright © 2016年 didai. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^block_chooseBranch)(NSString * _Nullable, NSString *_Nullable);

@interface WMPickerViewSheet : UIView

/* clickBtn */
@property (nonatomic, strong,nullable) block_chooseBranch ClickEnsureBtnBlock;

- (void)showWithTitle:(NSString * _Nullable)title height:(CGFloat)height array:(NSArray * _Nullable)array englishNameArr:(NSArray *_Nullable)englishNameArr;
- (void)hide;

@end
