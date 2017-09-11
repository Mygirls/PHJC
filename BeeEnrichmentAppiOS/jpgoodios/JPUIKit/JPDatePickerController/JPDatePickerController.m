//
//  JPDatePickerController.m
//  CallMe
//
//  Created by renpan on 15/3/27.
//  Copyright (c) 2015年 XiZhe. All rights reserved.
//

#import "JPDatePickerController.h"

@interface JPDatePickerController ()
@property (nonatomic, strong) NSString* min_date;
@property (nonatomic, strong) NSString* max_date;
@property (nonatomic, strong) NSString* date_format;
@end

@implementation JPDatePickerController

+ (CGFloat)height
{
    return 206.0f;
}

+ (id)load_date_picker
{
    JPDatePickerController* dp = [[JPDatePickerController alloc] init_with_own_name_nib];
    return dp;
}

- (NSDate*)current_date
{
    return _dp.date;
}

- (void)setCurrent_date:(NSDate *)current_date
{
    _dp.date = current_date;
}

- (void)set_with_date_format:(NSString*)date_format min_date:(NSString*)min_date max_date:(NSString*)max_date
{
    _date_format = date_format;
    _min_date = min_date;
    _max_date = max_date;
}

- (IBAction)btn_event:(UIBarButtonItem*)item
{
    NSInteger tag = item.tag;
    if(tag == 100)
    {
        if(_block_date_picker_cancel)
        {
            _block_date_picker_cancel(self);
        }
    }
    else if(tag == 101)
    {
        if(_block_date_picker_finish)
        {
            _block_date_picker_finish(self);
        }
    }
}

- (IBAction)btn_changed:(id)sender
{
    if(_block_date_picker_current_date)
    {
        _block_date_picker_current_date(self, [self current_date]);
    }
}

- (void)init_ui
{
    [super init_ui];
    
    [_dp setMinimumDate:[JPDatePickerController date_with_string:_min_date format:_date_format]];
    [_dp setMaximumDate:[JPDatePickerController date_with_string:_max_date format:_date_format]];
}

- (NSString*)current_date_with_format:(NSString*)format
{
    NSDateFormatter* fmt = [[NSDateFormatter alloc] init];
    [fmt setDateFormat:format];
    NSString* date_string = [fmt stringFromDate:[self current_date]];
    return date_string;
}

- (void)set_current_date_with_date_string:(NSString*)date_string format:(NSString*)format
{
    NSDateFormatter* fmt = [[NSDateFormatter alloc] init];
    [fmt setDateFormat:format];
    NSDate* date = [fmt dateFromString:date_string];
    [self setCurrent_date:date];
}

+ (NSDate*)date_with_string:(NSString*)date_string format:(NSString*)format
{
    NSDateFormatter* fmt = [[NSDateFormatter alloc] init];
    [fmt setDateFormat:format];
    NSDate* date = [fmt dateFromString:date_string];
    return date;
}

+ (NSString*)date_string_from_date:(NSDate*)date format:(NSString*)format
{
    NSDateFormatter* fmt = [[NSDateFormatter alloc] init];
    [fmt setDateFormat:format];
    NSString* date_string = [fmt stringFromDate:date];
    return date_string;
}
@end
