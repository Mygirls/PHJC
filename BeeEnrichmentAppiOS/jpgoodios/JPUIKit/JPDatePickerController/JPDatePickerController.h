//
//  JPDatePickerController.h
//  CallMe
//
//  Created by renpan on 15/3/27.
//  Copyright (c) 2015年 XiZhe. All rights reserved.
//

#import "JPViewController.h"

@class JPDatePickerController;

typedef void(^date_picker_cancel)(JPDatePickerController* date_picker);
typedef void(^date_picker_current_date)(JPDatePickerController* date_picker, NSDate* current_date);
typedef void(^date_picker_finish)(JPDatePickerController* date_picker);

@interface JPDatePickerController : JPViewController
@property (nonatomic, strong) date_picker_cancel block_date_picker_cancel;
@property (nonatomic, strong) date_picker_current_date block_date_picker_current_date;
@property (nonatomic, strong) date_picker_finish block_date_picker_finish;

- (void)setBlock_date_picker_cancel:(date_picker_cancel)block_date_picker_cancel;
- (void)setBlock_date_picker_current_date:(date_picker_current_date)block_date_picker_current_date;
- (void)setBlock_date_picker_finish:(date_picker_finish)block_date_picker_finish;

@property (nonatomic, assign) NSDate* current_date;
@property (nonatomic, strong) IBOutlet UIDatePicker* dp;

+ (CGFloat)height;  //default 206px;
+ (id)load_date_picker;

- (NSString*)current_date_with_format:(NSString*)format;
- (void)set_current_date_with_date_string:(NSString*)date_string format:(NSString*)format;
+ (NSDate*)date_with_string:(NSString*)date_string format:(NSString*)format;
+ (NSString*)date_string_from_date:(NSDate*)date format:(NSString*)format;
@end
