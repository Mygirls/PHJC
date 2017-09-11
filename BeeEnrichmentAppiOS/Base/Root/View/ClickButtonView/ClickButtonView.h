//
//  ClickButtonView.h
//  CarMirrorAppiOS
//
//  Created by dll on 15/9/18.
//  Copyright (c) 2015年 HangZhouShangFu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClickButtonView : UIView
@property (strong, nonatomic) IBOutlet UIButton *click_button;
- (void)set_button_disabled;
- (void)set_button_enabled;
@end
