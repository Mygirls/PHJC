//
//  ZSDPaymentForm.m
//  demo
//
//  Created by shaw on 15/4/11.
//  Copyright (c) 2015年 shaw. All rights reserved.
//

#import "ZSDPaymentForm.h"


//#define UIColorFromRGB(rgbValue) [UIColor \
//colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
//green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
//blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface ZSDPaymentForm ()<ZSDSetPasswordViewDelegate>




@property (weak, nonatomic) IBOutlet UILabel *amountLabel;

@property (nonatomic,copy) NSString *textString;

@end

@implementation ZSDPaymentForm

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 10.0f;
    
    _inputView.delegate = self;
    _inputView.layer.borderWidth = 0.5f;
    _inputView.layer.cornerRadius = 4.0f;
    [_inputView.layer setMasksToBounds:YES];
    _inputView.layer.borderColor = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1.0].CGColor;
    
}

#pragma mark -
#pragma mark -ZSDSetPasswordViewDelegate
-(void)passwordView:(ZSDSetPasswordView *)passwordView inputPassword:(NSString *)password
{
//    //密码检测，必须是6位数字
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",@"^[0-9]{6}$"];
//    if(![predicate evaluateWithObject:password])
//    {
//        self.inputPassword = nil;
//    }
//    else
//    {
    
        self.inputPassword = password;
    
    if(_completeHandle)
    {
        _completeHandle(_inputPassword);
    }
    if (password.length == _numbers_count) {
//        objc_msgSend(self.superview,@selector(dismiss));
        [self.superview removeFromSuperview];
        
        
    }
//    }
}

-(CGSize)viewSize
{
    CGSize size = [self systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size;
}

//关闭
-(IBAction)closeView:(id)sender
{
    if (_block_ZSDPaymentForm_close_view) {
        _block_ZSDPaymentForm_close_view();
    }
//    objc_msgSend(self.superview,@selector(dismiss));
    [self.superview removeFromSuperview];
    
}

-(void)setTitle:(NSString *)title
{
    if(_title != title)
    {
        _title = title;
        
        _titleLabel.text = _title;
    }
}
- (void)setNumbers_count:(NSInteger)numbers_count
{
    if (_numbers_count == 0) {
        _numbers_count = numbers_count;
    }
    
    
}

-(void)setGoodsName:(NSString *)goodsName
{
    if(_goodsName != goodsName)
    {
        _goodsName = goodsName;
        
//        _goodsNameLabel.text = _goodsName;
    }
}

-(void)setAmount:(CGFloat)amount
{
    if(_amount != amount)
    {
        _amount = amount;
        
        _amountLabel.text = [NSString stringWithFormat:@"¥%.2f",amount];
    }
}

-(void)fieldBecomeFirstResponder
{
    [_inputView fieldBecomeFirstResponder];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
