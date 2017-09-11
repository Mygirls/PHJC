//
//  AlertPayMoneyView.m
//  BeeEnrichmentAppiOS
//
//  Created by dll on 16/8/17.
//  Copyright © 2016年 didai. All rights reserved.
//


#define kDefaultKayboardHeight 260.0f
#import "AlertPayMoneyView.h"
#import "LTimerButton.h"

@interface AlertPayMoneyView ()<UITextFieldDelegate>
{
    CGFloat keyboardHeight;
}
@property (nonatomic,assign) CGFloat keyboardOriginY;


@end

@implementation AlertPayMoneyView
- (void)awakeFromNib
{
    [super awakeFromNib];
    
//    self.commitB.enabled = NO;
    self.contentTextField.delegate = self;
    self.contentTextField.layer.borderColor = [UIColor whiteColor].CGColor;
    self.obtainBtn.layer.borderWidth = 0.5;
    self.obtainBtn.layer.borderColor = [UIColor colorWithHex:@"#f95f53"].CGColor;
    self.obtainBtn.layer.cornerRadius = 2;
    self.obtainBtn.clipsToBounds = YES;
    keyboardHeight = kDefaultKayboardHeight;
//    _bottom_button = self.obtainBtn;

    [self addNotification];
}

-(void)dealloc
{
    [self removeNotification];
}
-(void)addNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)removeNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
-(void)keyboardWillShow:(NSNotification *)notificaiton
{
    CGRect keyboardFrame = [[notificaiton.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    keyboardHeight = keyboardFrame.size.height;
    
    if(self.frame.origin.y != _keyboardOriginY)
    {
        [self resetAlertFrame];
    }
}
-(void)keyboardWillHide:(NSNotification *)notificaiton
{
    keyboardHeight = 0;
    [self resetAlertFrame];
}
//改变alert的位置，防止阻挡键盘
-(void)resetAlertFrame
{
    CGFloat bottom = kScreenHeight - CGRectGetMaxY(self.frame);
    if(bottom < keyboardHeight)
    {
        CGFloat moveY = keyboardHeight - bottom + 70;
        
        CGRect alertFrame = self.frame;
        alertFrame.origin.y -= moveY;
        
        self.keyboardOriginY = alertFrame.origin.y;
        
        [UIView animateWithDuration:0.3f animations:^{
            self.frame = alertFrame;
        }];
    }
    else
    {
        CGRect alertFrame = self.frame;
        alertFrame.origin.y = (kScreenHeight - alertFrame.size.height) / 2.0f;
        
        [UIView animateWithDuration:0.3f animations:^{
            self.frame = alertFrame;
        }];
    }
}
- (void)show_view
{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    self.layer.cornerRadius = 10;
    _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    _backView.backgroundColor = [UIColor blackColor];
    _backView.alpha = 0.3;
    self.frame = CGRectMake(30, (kScreenHeight - 200) / 2.0, kScreenWidth - 60, 260);
    [keyWindow addSubview:_backView];
    [keyWindow addSubview:self];
    // 第一次弹窗-自动发送一次验证码
    [self.obtainBtn startTimerWithCount:60];
}
-(void)removeFromSuperviewS{
    [self removeFromSuperview];
    [_backView removeFromSuperview];
}
#pragma mark 取消
- (IBAction)cancelAction:(id)sender {
    [[JPAlert current] showAlertWithTitle:@"确认关闭窗口" content:nil button:@[@"取消", @"确定"] block:^(UIAlertView *alert, NSInteger index) {
        if (index == 1) {
            [self removeFromSuperview];
            [_backView removeFromSuperview];
        }
    }];
}
#pragma mark 提交
- (IBAction)commitBtnClick:(id)sender {
    if (_commitBtn) {
        self.commitBtn(_backView);
    }
}
#pragma mark 发送验证码
- (IBAction)clickSendCode:(LTimerButton *)sender {
    [sender startTimerWithCount:60];
}



#pragma mark textField-delegate-datasource
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSMutableString *str = [NSMutableString stringWithFormat:@"%@%@",textField.text,string];
    if ([string isEqualToString:@""]) {
        [str deleteCharactersInRange:range];
        self.commitB.enabled = NO;
        [self.commitB setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    if (str.length > 8) {
        return NO;
    }
    if (str.length >= 4 && str.length <= 8 && [CMCore checkNumberValid:str]) {
        self.commitB.enabled = YES;

        [self.commitB setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.commitB.backgroundColor = [UIColor colorWithHex:@"#f95f53"];

    }else {
        self.commitB.enabled = NO;
        [self.commitB setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.commitB.backgroundColor = [UIColor colorWithHex:@"#cccccc"];

    }
    
    return YES;
}

@end
