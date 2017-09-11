//
//  NoBankCardView.h
//  BeeEnrichmentAppiOS
//
//  Created by dll on 16/5/16.
//  Copyright © 2016年 didai. All rights reserved.
//

#import <UIKit/UIKit.h>



typedef void(^clickAddBankCard)();
@interface NoBankCardView : UIView
@property (nonatomic, copy)clickButtonBlock clickButtonBlock;
@end
