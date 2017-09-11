//
//  JPPickerController.h
//  CallMe
//
//  Created by renpan on 15/5/28.
//  Copyright (c) 2015年 XiZhe. All rights reserved.
//

#import "JPViewController.h"

typedef NSInteger(^numberOfComponentsInPickerView)(UIPickerView* pickerView);
typedef NSInteger(^numberOfRowsInComponent)(UIPickerView* pickerView, NSInteger component);
typedef void(^didSelectRow)(UIPickerView* pickerView, NSInteger row, NSInteger component);
@interface JPPickerController : JPViewController
@property (nonatomic, strong) numberOfComponentsInPickerView block_numberOfComponentsInPickerView;
@property (nonatomic, strong) numberOfRowsInComponent block_numberOfRowsInComponent;

- (void)setBlock_numberOfComponentsInPickerView:(numberOfComponentsInPickerView)block_numberOfComponentsInPickerView;
- (void)setBlock_numberOfRowsInComponent:(numberOfRowsInComponent)block_numberOfRowsInComponent;

@property (nonatomic, strong) didSelectRow block_didSelectRow;
- (void)setBlock_didSelectRow:(didSelectRow)block_didSelectRow;

@property (nonatomic, assign) BOOL is_show;

+ (CGFloat)height;
+ (id)load_picker;
- (void)reloadData;
//- (void)show_picker:(BOOL)show animated:(BOOL)animated;
//- (void)toggle_picker:(BOOL)animated;
- (void)set_up_constraints;
- (void)do_update_view_constraints;
@end
