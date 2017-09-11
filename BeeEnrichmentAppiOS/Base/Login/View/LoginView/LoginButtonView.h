//
//  LoginButtonView.h
//  BeeEnrichmentAppiOS
//
//  Created by dll on 15/12/21.
//  Copyright © 2015年 didai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginButtonView : UIView
@property (strong, nonatomic) IBOutlet UIButton *forget_password_btn;
@property (strong, nonatomic) IBOutlet UIButton *login_btn;
- (void)setButtonIsenabled:(BOOL)isEnabled;
- (void)setButtonTitle:(NSString *)title isShowAccessoryBtn:(BOOL)isShowAccessoryBtn;
@end
