//
//  Icon_TextField_Button_Cell.h
//  CarMirrorAppiOS
//
//  Created by dll on 15/9/18.
//  Copyright (c) 2015年 HangZhouShangFu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Icon_TextField_Button_Cell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *icon_imageView;
@property (strong, nonatomic) IBOutlet UITextField *myTextField;
@property (strong, nonatomic) IBOutlet LTimerButton *send_message_button;

@end
