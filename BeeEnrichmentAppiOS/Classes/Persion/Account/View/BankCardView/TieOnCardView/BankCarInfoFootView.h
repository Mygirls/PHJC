//
//  BankCarInfoFootView.h
//  BeeEnrichmentAppiOS
//
//  Created by hwm on 16/11/15.
//  Copyright © 2016年 didai. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BankCarInfoFootViewBlock)(NSInteger index);
@interface BankCarInfoFootView : UIView
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@property (weak, nonatomic) IBOutlet UIButton *isAgreeBtn;

@property (nonatomic, strong) BankCarInfoFootViewBlock BankCarInfoFootViewClick;
- (void)setButtonIsenabled:(BOOL)isEnabled;
@end
