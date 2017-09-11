//
//  PayButtonView.h
//  BeeEnrichmentAppiOS
//
//  Created by dll on 16/2/19.
//  Copyright © 2016年 didai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PayButtonView : UIView
@property (strong, nonatomic) IBOutlet UIButton *is_agree_button;
@property (strong, nonatomic) IBOutlet UIButton *property_button;
@property (strong, nonatomic) IBOutlet UIButton *sure_button;
@property (strong, nonatomic) IBOutlet UIButton *change_card_info_button;
@property (strong, nonatomic) IBOutlet UIButton *bank_description;
- (void)setButtonIsenabled:(BOOL)isEnabled;
@end
