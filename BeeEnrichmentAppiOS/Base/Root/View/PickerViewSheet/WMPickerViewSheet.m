//
//  WMPickerViewSheet.m
//  BeeCarLoanClient
//
//  Created by hwm on 16/6/14.
//  Copyright © 2016年 didai. All rights reserved.
//

#import "WMPickerViewSheet.h"

@interface WMPickerViewSheet () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UIPickerView *picker_view;
@property (weak, nonatomic) IBOutlet UIView *title_view;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *ensureBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *choose_view_bottom_constraint;
@property (weak, nonatomic) IBOutlet UILabel *title_lable;
@property (weak, nonatomic) IBOutlet UIView *choose_view;
/* 数据array */
@property (nonatomic, strong) NSArray *array, *englishNameArr;

/* height */
@property (nonatomic, assign) CGFloat height;
/* 选择 */
@property (nonatomic, strong) NSString *choose, *englishName;
/* 第一设置 */
@property (nonatomic, assign) BOOL isInitial;

@end

@implementation WMPickerViewSheet

- (void)awakeFromNib {
    [super awakeFromNib];
    [self changeSpearatorLineColor];
}

- (IBAction)click_cover_btn:(id)sender {
    [self hide];
}
- (IBAction)click_cancelBtn:(id)sender {
    [self hide];
}
- (IBAction)click_ensureBtn:(id)sender {
    if (self.ClickEnsureBtnBlock) {
        self.ClickEnsureBtnBlock(self.choose, self.englishName);

    }
    [self hide];
}
#pragma mark - 改变分割线的颜色
- (void)changeSpearatorLineColor
{
    for(UIView *speartorView in _picker_view.subviews)
    {
        if (speartorView.frame.size.height < 1)//取出分割线view
        {
            speartorView.backgroundColor = [UIColor colorWithHex:@"#e1e1e1"];//隐藏分割线 分割线颜色
        }
    }
}
- (void)showWithTitle:(NSString *)title height:(CGFloat)height array:(NSArray *)array englishNameArr:(NSArray *)englishNameArr {

    self.array = array;
    self.englishNameArr = englishNameArr;
    
    self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    self.choose_view.frame = CGRectMake(0, self.frame.size.height, kScreenWidth, height);
    self.title_lable.text = title;
    self.height = height;
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:0.3f animations:^{
        self.choose_view.frame = CGRectMake(0, self.frame.size.height, kScreenWidth, 0);
    }];
    [self initialText];
    
}

// 初始化文字的方法
- (void)initialText
{
    if (_isInitial == NO) {
        [self pickerView:_picker_view didSelectRow:0 inComponent:0];
        if (self.ClickEnsureBtnBlock) {
            self.ClickEnsureBtnBlock(_choose, _englishName);
          
        }
        _isInitial = YES;
    }
}

- (void)hide {
    // 移除
    for (UIView *childView in [UIApplication sharedApplication].keyWindow.subviews) {
        if ([childView isKindOfClass:self.class]) {
            [UIView animateWithDuration:0.3f animations:^{
                self.choose_view.frame = CGRectMake(0, self.frame.size.height, kScreenWidth, _height);
            } completion:^(BOOL finished) {
                [self removeFromSuperview];
            }];
        }
    }
}

#pragma mark - UIPickerViewDataSource
// 返回 列 number
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
// 返回 行 number
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.array.count;
}

#pragma mark UIPickerViewDelegate
// row title
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
  
    return self.array[row];
        
}

// 返回 component  height
-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 35.0;
}

// 选中某一行的时候调用 choose
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.choose = self.array[row];
    self.englishName = self.englishNameArr[row];
   
}



@end
