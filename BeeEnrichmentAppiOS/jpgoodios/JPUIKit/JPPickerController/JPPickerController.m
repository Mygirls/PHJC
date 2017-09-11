//
//  JPPickerController.m
//  CallMe
//
//  Created by renpan on 15/5/28.
//  Copyright (c) 2015年 XiZhe. All rights reserved.
//

#import "JPPickerController.h"

@interface JPPickerController () <UIPickerViewDataSource, UIPickerViewDelegate>
@property (nonatomic, strong) IBOutlet UIPickerView* picker_view;
@property (nonatomic, strong) NSLayoutConstraint* constraint_picker;
@end

@implementation JPPickerController

+ (id)load_picker
{
    JPPickerController* dp = [[JPPickerController alloc] init_with_own_name_nib];
    return dp;
}

+ (CGFloat)height
{
    return 206.0f;
}

- (void)reloadData
{
    [_picker_view reloadAllComponents];
}

- (void)init_ui
{
    [super init_ui];
    
    _is_show = NO;
    
}

- (void)set_up_constraints
{
    [self.view autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [self.view autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.view.superview];
    [self.view autoSetDimension:ALDimensionHeight toSize:[JPPickerController height]];
}

- (void)do_update_view_constraints
{
    [_constraint_picker autoRemove];
    if(_is_show)
    {
        _constraint_picker = [self.view autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    }
    else
    {
        _constraint_picker = [self.view autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.view.superview];
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if(_block_numberOfComponentsInPickerView)
    {
        return _block_numberOfComponentsInPickerView(pickerView);
    }
    return 0;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(_block_numberOfRowsInComponent)
    {
        return _block_numberOfRowsInComponent(pickerView, component);
    }
    return 0;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if(_block_didSelectRow)
    {
        _block_didSelectRow(pickerView, row, component);
    }
}
@end
