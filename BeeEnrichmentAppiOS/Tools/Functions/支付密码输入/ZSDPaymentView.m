//
//  ZSDPaymentView.m
//  demo
//
//  Created by shaw on 15/4/11.
//  Copyright (c) 2015年 shaw. All rights reserved.
//-------------------支付密码弹出输入框-----------------------

#import "ZSDPaymentView.h"
#import "ZSDPaymentForm.h"

#define kDefaultKayboardHeight 216.0f

@interface ZSDPaymentView ()
{
    CGFloat keyboardHeight;
}

@property (nonatomic,strong) ZSDPaymentForm *paymentForm;

@property (nonatomic,strong) NSLayoutConstraint *heightConstraint;
@property (nonatomic,assign) CGFloat keyboardOriginY;
@property (nonatomic, strong) UITapGestureRecognizer *tap;
@end

@implementation ZSDPaymentView

-(instancetype)init
{
    self = [super init];
    if(self)
    {
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3f];
        keyboardHeight = kDefaultKayboardHeight;
        
        [self loadNib];
        __weak ZSDPaymentView *_self = self;
        _paymentForm.completeHandle = ^(NSString *inputPwd)
        {
            NSPredicate *predicate;
            if (_numbers_count == 4) {
                predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",@"^[0-9]{4}$"];
            }else
            {
                predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",@"^[0-9]{6}$"];
            }
            
            if([predicate evaluateWithObject:inputPwd])
            {
                DLog(@"密码是4/6为数字");
                if (self.delegate && [self.delegate respondsToSelector:@selector(get_password_str:)]) {
                    [_self.delegate get_password_str:inputPwd];
                }
            }
            else
            {
                DLog(@"密码错误");
            }
        };
        
        [self addNotification];
    }
    return self;
}

-(void)dealloc
{
    [self removeNotification];
}

-(void)loadNib
{
    if(!_paymentForm)
    {
        UIView *nibView = [[[NSBundle mainBundle] loadNibNamed:@"ZSDPaymentView" owner:nil options:nil] objectAtIndex:0];
        self.paymentForm = (ZSDPaymentForm *)nibView;
        [self addSubview:nibView];
        _bottom_button = self.paymentForm.bottom_button;
        
        _phone_label = self.paymentForm.phone_label;
        _description_label = self.paymentForm.description_label;
        _money_label = self.paymentForm.money_label;
        
        _title_label = self.paymentForm.titleLabel;
        _numbers_count = self.paymentForm.numbers_count;
        
        nibView.translatesAutoresizingMaskIntoConstraints = NO;
        
        NSLayoutConstraint *center_x = [NSLayoutConstraint constraintWithItem:_paymentForm attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
        NSLayoutConstraint *center_y = [NSLayoutConstraint constraintWithItem:_paymentForm attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0];
        CGSize viewSize = [_paymentForm viewSize];
        NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:_paymentForm attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1.0 constant:260.0f];
        NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:_paymentForm attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0 constant:viewSize.height];
        self.heightConstraint = height;
        
        [self addConstraint:center_x];
        [self addConstraint:center_y];
        [self addConstraint:width];
        [self addConstraint:_heightConstraint];
    }
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
    
    if(_paymentForm.frame.origin.y != _keyboardOriginY)
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
    CGFloat bottom = kScreenHeight - CGRectGetMaxY(_paymentForm.frame);
    if(bottom < keyboardHeight)
    {
        CGFloat moveY = keyboardHeight - bottom + 80;
        
        CGRect alertFrame = _paymentForm.frame;
        alertFrame.origin.y -= moveY;
        
        self.keyboardOriginY = alertFrame.origin.y;
        
        [UIView animateWithDuration:0.3f animations:^{
            _paymentForm.frame = alertFrame;
        }];
    }
    else
    {
        CGRect alertFrame = _paymentForm.frame;
        alertFrame.origin.y = (kScreenHeight - alertFrame.size.height) / 2.0f;
        
        [UIView animateWithDuration:0.3f animations:^{
            _paymentForm.frame = alertFrame;
        }];
    }
}

-(void)show
{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self];
    
    self.translatesAutoresizingMaskIntoConstraints = NO;
    NSArray *self_H = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[self]|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(self)];
    NSArray *self_V = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[self]|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(self)];
    [keyWindow addConstraints:self_H];
    [keyWindow addConstraints:self_V];
    
    CGSize size = [_paymentForm systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    _heightConstraint.constant = size.height;
    
    _paymentForm.transform = CGAffineTransformMakeScale(0.01f, 0.01f);
    _paymentForm.alpha = 0;
    
    [UIView animateWithDuration:0.3f animations:^{
        _paymentForm.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
        _paymentForm.alpha = 1.0;
    }completion:^(BOOL finished) {
        [self resetAlertFrame];
        [_paymentForm fieldBecomeFirstResponder];
    }];
    
    __weak ZSDPaymentView* _self = self;
    [_paymentForm setBlock_ZSDPaymentForm_close_view:^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(cancel_payment_handle:)]) {
            [_self.delegate cancel_payment_handle:_self];
        }
    }];
}

-(void)dismiss
{
    [UIView animateWithDuration:0.3f animations:^{
        _paymentForm.transform = CGAffineTransformMakeScale(0.01f, 0.01f);
        _paymentForm.alpha = 0;
    }completion:^(BOOL finished) {
//        if(finished)
//        {
//            if (self.delegate && [self.delegate respondsToSelector:@selector(cancel_payment_handle:)]) {
//                [self.delegate cancel_payment_handle:self];
//            }
            [self removeFromSuperview];
//        }
    }];
}

-(void)setTitle:(NSString *)title
{
    if(_title != title)
    {
        _title = title;
        
        _paymentForm.title = _title;
    }
}
- (void)setNumbers_count:(NSInteger)numbers_count
{
    if (_numbers_count == 0) {
        _numbers_count = numbers_count;
    }
    if (numbers_count == 6) {
        _title_label.text = @"支付密码";
        
        _description_label.hidden = YES;
        _phone_label.hidden = YES;
        _money_label.hidden = NO;
    }else if (numbers_count == 4) {
        _title_label.text = @"手机验证码";
        _money_label.hidden = YES;
        _bottom_button.hidden = NO;
        _description_label.hidden = NO;
        _phone_label.hidden = NO;
    }
    _paymentForm.inputView.numbers_count = numbers_count;
    
}
-(void)setGoodsName:(NSString *)goodsName
{
    if(_goodsName != goodsName)
    {
        _goodsName = goodsName;
        
        _paymentForm.goodsName = _goodsName;
    }
}

-(void)setAmount:(CGFloat)amount
{
    if(_amount != amount)
    {
        _amount = amount;
        
        _paymentForm.amount = _amount;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
