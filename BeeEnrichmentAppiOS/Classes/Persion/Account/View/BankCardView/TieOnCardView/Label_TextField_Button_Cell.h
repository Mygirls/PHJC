//
//  Label_TextField_Button_Cell.h
//  BeeEnrichmentAppiOS
//
//  Created by dll on 15/12/24.
//  Copyright © 2015年 didai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Label_TextField_Button_Cell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *title_label;
@property (strong, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic) IBOutlet UIButton *send_message_button;

@end
