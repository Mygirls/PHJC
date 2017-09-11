//
//  RegisterButtonView.h
//  BeeEnrichmentAppiOS
//
//  Created by dll on 15/12/21.
//  Copyright © 2015年 didai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterButtonView : UIView
@property (strong, nonatomic) IBOutlet UIButton *is_agree_button;
@property (strong, nonatomic) IBOutlet UIButton *property_button;
@property (strong, nonatomic) IBOutlet UILabel *property_description_label;

@property (strong, nonatomic) IBOutlet UIButton *sure_button;
@property (strong, nonatomic) IBOutlet UIView *bottom_view;
@property (strong, nonatomic) IBOutlet UIButton *accessory_button;
@property (strong, nonatomic) IBOutlet UILabel *description_label;
- (void)setButtonIsenabled:(BOOL)isEnabled;
- (void)setPropertyButtonHidden:(BOOL)hidden;
@end
