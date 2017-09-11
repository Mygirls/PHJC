//
//  AlertPayViewTwo.m
//  BeeEnrichmentAppiOS
//
//  Created by MC on 2016/11/11.
//  Copyright © 2016年 didai. All rights reserved.
//

#import "AlertPayViewTwo.h"

#define  boxWidth kScreenWidth/375*40 //密码框的宽度

#define kAlertWidth kScreenWidth/375*315

@interface AlertPayViewTwo ()<UITextFieldDelegate>
{
    CGFloat keyboardHeight;
}
@property (nonatomic,assign) CGFloat keyboardOriginY;

@property (nonatomic, strong) UIView    *bgView;
@property (nonatomic, strong) UILabel   *titleLabel;
@property (nonatomic, strong) UIImageView *buttonImage;
@property (strong, nonatomic) UILabel *phoneLabel;

@end

@implementation AlertPayViewTwo
- (void)awakeFromNib
{
    [super awakeFromNib];
    
}

+ (instancetype)alertViewDefault {
    return [[self alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth,kScreenHeight)];
}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = CGRectMake(0, 0,kScreenWidth,kScreenHeight);
        self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
        
        
        [self setView];
        [self setTitle];
    }
    return self;
}

- (void)setTitle {
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.font = [UIFont fontWithName:FontOfAttributedRegular size:19];
    self.titleLabel.textColor = [UIColor colorWithHex:@"#444444"];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.bgView addSubview:self.titleLabel];
    
    
    self.phoneLabel = [[UILabel alloc]init];
    self.phoneLabel.font = [UIFont fontWithName:FontOfAttributed size:14];
    self.phoneLabel.textColor = [UIColor colorWithHex:@"#676767"];
    self.phoneLabel.textAlignment = 2;
    [self.bgView addSubview:self.phoneLabel];
}



- (void)setView {
    
    self.bgView = [[UIView alloc]init];
    self.bgView.backgroundColor = [UIColor whiteColor];
    self.bgView.layer.cornerRadius = 10;
    self.bgView.layer.masksToBounds = YES;
    [self addSubview:self.bgView];
    
    
    UIButton * deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteBtn.frame = CGRectMake(kAlertWidth-40,kScreenHeight/667*15.5 , 40,40);
    [self.bgView addSubview:deleteBtn];
    deleteBtn.tag = 10000;
    [deleteBtn addTarget:self action:@selector(buttonClick1:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView * deleteBtnImage = [[UIImageView alloc]init];
    deleteBtnImage.frame = CGRectMake(0, 0,14, 14);
    deleteBtnImage.image = [UIImage imageNamed:@"v1.6_delegate_tanchuang"];
    [deleteBtn addSubview:deleteBtnImage];
    
    
    
    _forgetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _forgetBtn.frame = CGRectMake(0,kScreenHeight/667*122.5 , kAlertWidth,20);
    [self.bgView addSubview:deleteBtn];
    [_forgetBtn setTitle:@"忘记密码?" forState:0];
    _forgetBtn.titleLabel.font = [UIFont fontWithName:FontOfAttributed size:15];
    [_forgetBtn setTitleColor:[UIColor colorWithHex:@"#949494"] forState:0];
    [self.bgView addSubview:_forgetBtn];
    
    _TF = [[UITextField alloc]init];
    _TF.frame = CGRectMake(0,0, 0, 0 );
    _TF.delegate = self;
    _TF.keyboardType=UIKeyboardTypeNumberPad;
    [_TF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.bgView addSubview:_TF];
    
    _view_box = [[UIView alloc]initWithFrame:CGRectMake(kScreenWidth/375*20, 60, boxWidth, boxWidth)];
    [_view_box.layer setBorderWidth:0.5];
    _view_box.layer.borderColor = [[UIColor colorWithHex:@"#949494"]CGColor];
    _view_box.layer.cornerRadius = 3;
    [self.bgView addSubview:_view_box];
    _view_box2 = [[UIView alloc]initWithFrame:CGRectMake(kScreenWidth/375*27+boxWidth*1, _view_box.frame.origin.y, boxWidth, boxWidth)];
    [_view_box2.layer setBorderWidth:0.5];
    _view_box2.layer.borderColor = [[UIColor colorWithHex:@"#949494"]CGColor];
    _view_box2.layer.cornerRadius = 3;
    [self.bgView addSubview:_view_box2];
    _view_box3 = [[UIView alloc]initWithFrame:CGRectMake(kScreenWidth/375*34+boxWidth*2, _view_box.frame.origin.y, boxWidth, boxWidth)];
    [_view_box3.layer setBorderWidth:0.5];
    _view_box3.layer.borderColor = [[UIColor colorWithHex:@"#949494"]CGColor];
    _view_box3.layer.cornerRadius = 3;
    [self.bgView addSubview:_view_box3];
    _view_box4 = [[UIView alloc]initWithFrame:CGRectMake(kScreenWidth/375*41+boxWidth*3, _view_box.frame.origin.y, boxWidth, boxWidth)];
    [_view_box4.layer setBorderWidth:0.5];
    _view_box4.layer.borderColor = [[UIColor colorWithHex:@"#949494"]CGColor];
    _view_box4.layer.cornerRadius = 3;
    [self.bgView addSubview:_view_box4];
    _view_box5 = [[UIView alloc]initWithFrame:CGRectMake(kScreenWidth/375*48+boxWidth*4, _view_box.frame.origin.y, boxWidth, boxWidth)];
    [_view_box5.layer setBorderWidth:0.5];
    _view_box5.layer.borderColor = [[UIColor colorWithHex:@"#949494"]CGColor];
    _view_box5.layer.cornerRadius = 3;
    [self.bgView addSubview:_view_box5];
    _view_box6 = [[UIView alloc]initWithFrame:CGRectMake(kScreenWidth/375*55+boxWidth*5, _view_box.frame.origin.y, boxWidth, boxWidth)];
    [_view_box6.layer setBorderWidth:0.5];
    _view_box6.layer.borderColor = [[UIColor colorWithHex:@"#949494"]CGColor];
    _view_box6.layer.cornerRadius = 3;
    [self.bgView addSubview:_view_box6];
    
    
    ///   密码点
    _lable_point = [[UILabel alloc]init];
    _lable_point.frame = CGRectMake((_view_box.frame.size.width-10)/2, (_view_box.frame.size.width-10)/2, 10, 10);
    [_lable_point.layer setCornerRadius:5];
    [_lable_point.layer setMasksToBounds:YES];
    _lable_point.backgroundColor = [UIColor blackColor];
    [_view_box addSubview:_lable_point];
    
    _lable_point2 = [[UILabel alloc]init];
    _lable_point2.frame = CGRectMake((_view_box.frame.size.width-10)/2, (_view_box.frame.size.width-10)/2, 10, 10);
    [_lable_point2.layer setCornerRadius:5];
    [_lable_point2.layer setMasksToBounds:YES];
    _lable_point2.backgroundColor = [UIColor blackColor];
    [_view_box2 addSubview:_lable_point2];
    
    
    _lable_point3 = [[UILabel alloc]init];
    _lable_point3.frame = CGRectMake((_view_box.frame.size.width-10)/2, (_view_box.frame.size.width-10)/2, 10, 10);
    [_lable_point3.layer setCornerRadius:5];
    [_lable_point3.layer setMasksToBounds:YES];
    _lable_point3.backgroundColor = [UIColor blackColor];
    [_view_box3 addSubview:_lable_point3];
    
    _lable_point4 = [[UILabel alloc]init];
    _lable_point4.frame = CGRectMake((_view_box.frame.size.width-10)/2, (_view_box.frame.size.width-10)/2, 10, 10);
    [_lable_point4.layer setCornerRadius:5];
    [_lable_point4.layer setMasksToBounds:YES];
    _lable_point4.backgroundColor = [UIColor blackColor];
    [_view_box4 addSubview:_lable_point4];
    
    _lable_point5 = [[UILabel alloc]init];
    _lable_point5.frame = CGRectMake((_view_box.frame.size.width-10)/2, (_view_box.frame.size.width-10)/2, 10, 10);
    [_lable_point5.layer setCornerRadius:5];
    [_lable_point5.layer setMasksToBounds:YES];
    _lable_point5.backgroundColor = [UIColor blackColor];
    [_view_box5 addSubview:_lable_point5];
    
    _lable_point6 = [[UILabel alloc]init];
    _lable_point6.frame = CGRectMake((_view_box.frame.size.width-10)/2, (_view_box.frame.size.width-10)/2, 10, 10);
    [_lable_point6.layer setCornerRadius:5];
    [_lable_point6.layer setMasksToBounds:YES];
    _lable_point6.backgroundColor = [UIColor blackColor];
    [_view_box6 addSubview:_lable_point6];
    
    _lable_point.hidden=YES;
    _lable_point2.hidden=YES;
    _lable_point3.hidden=YES;
    _lable_point4.hidden=YES;
    _lable_point5.hidden=YES;
    _lable_point6.hidden=YES;
    
    
}

- (void)show {
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    [window addSubview:self];
    
    
    [UIView animateKeyframesWithDuration:0.3 delay:0 options:UIViewKeyframeAnimationOptionAutoreverse animations:^{
        
        self.transform = CGAffineTransformMakeScale(1, 1);
        
    } completion:^(BOOL finished) {
        
        
    }];
    
  
    self.bgView.bounds = CGRectMake(0, 0, kAlertWidth, kScreenHeight/667*170);
    self.bgView.center = self.center;

    self.titleLabel.frame = CGRectMake(50, kScreenHeight/667*15.5, kAlertWidth-100, 20);
    self.titleLabel.text= @"请输入支付密码";
    self.titleLabel.font = [UIFont fontWithName:FontOfAttributed size:19];
    
    self.phoneLabel.frame = CGRectMake(0, kScreenHeight/667*90.5, kAlertWidth/2, 12);
    self.phoneLabel.text= _phoneStr;
    
    
}
- (void)buttonClick1:(UIButton *)button {
    
    [self removeFromSuperview];
    
}

- (void) textFieldDidChange:(id) sender
{
    
    UITextField *_field = (UITextField *)sender;
    
    switch (_field.text.length) {
        case 0:
        {
            
            
            
            _lable_point.hidden=YES;
            _lable_point2.hidden=YES;
            _lable_point3.hidden=YES;
            _lable_point4.hidden=YES;
            _lable_point5.hidden=YES;
            _lable_point6.hidden=YES;
        }
            break;
        case 1:
        {
            
            
            _lable_point.hidden=NO;
            _lable_point2.hidden=YES;
            _lable_point3.hidden=YES;
            _lable_point4.hidden=YES;
            _lable_point5.hidden=YES;
            _lable_point6.hidden=YES;
        }
            break;
        case 2:
        {
            
            _lable_point.hidden=NO;
            _lable_point2.hidden=NO;
            _lable_point3.hidden=YES;
            _lable_point4.hidden=YES;
            _lable_point5.hidden=YES;
            _lable_point6.hidden=YES;
        }
            break;
        case 3:
        {
            
            
            _lable_point.hidden=NO;
            _lable_point2.hidden=NO;
            _lable_point3.hidden=NO;
            _lable_point4.hidden=YES;
            _lable_point5.hidden=YES;
            _lable_point6.hidden=YES;
        }
            break;
        case 4:
        {
           
            _lable_point.hidden=NO;
            _lable_point2.hidden=NO;
            _lable_point3.hidden=NO;
            _lable_point4.hidden=NO;
            _lable_point5.hidden=YES;
            _lable_point6.hidden=YES;
        }
            break;
        case 5:
        {
            
            
            _lable_point.hidden=NO;
            _lable_point2.hidden=NO;
            _lable_point3.hidden=NO;
            _lable_point4.hidden=NO;
            _lable_point5.hidden=NO;
            _lable_point6.hidden=YES;
        }
            break;
        case 6:
        {
            
            
            _lable_point.hidden=NO;
            _lable_point2.hidden=NO;
            _lable_point3.hidden=NO;
            _lable_point4.hidden=NO;
            _lable_point5.hidden=NO;
            _lable_point6.hidden=NO;
        }
            break;
            
        default:
            break;
    }
    
    
    if (_field.text.length==6)
    {
        [self.AlertPayMoneyViewDelegate AlertPayMoneyView:self WithPasswordString:_field.text];
        
        
        
    }
}

@end
