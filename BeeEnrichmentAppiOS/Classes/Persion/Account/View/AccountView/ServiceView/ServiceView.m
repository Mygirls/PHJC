//
//  ServiceView.m
//  BeeEnrichmentAppiOS
//
//  Created by MC on 16/10/11.
//  Copyright © 2016年 didai. All rights reserved.
//
#define KWidth [[UIScreen mainScreen]bounds].size.width
#define KHeight [[UIScreen mainScreen]bounds].size.height
#define kAlertWidth 295
#define kAlertHeight 250

#import "MQChatViewManager.h"
#import "UIColor+Addition.h"
#import "ServiceView.h"
@interface ServiceView ()

@property (nonatomic, strong) UIView    *bgView;
@property (nonatomic, strong) UILabel   *titleLabel;
@property (nonatomic, strong) UILabel   *contentLabel;
@property (nonatomic, strong) UIView    *grayHLine;
@property (nonatomic, strong) UIButton  *button;

@property (nonatomic, strong) UIImageView *buttonImage;
/** 按钮名字数组 */
@property (nonatomic, strong)NSArray    *buttonArray;
@end

@implementation ServiceView
+ (instancetype)alertViewDefault {
    return [[self alloc]initWithFrame:CGRectMake(0, 0, KWidth, KHeight)];
}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = CGRectMake(0, 0, KWidth, KHeight);
        self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
        
        //背景视图(300,150)
        self.bgView = [[UIView alloc]init];
        self.bgView.center = self.center;
        self.bgView.backgroundColor = [UIColor whiteColor];
        self.bgView.layer.cornerRadius = 10;
        self.bgView.layer.masksToBounds = YES;
        [self addSubview:self.bgView];
        
        
       
        //标题
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 42, kAlertWidth, 20)];
        self.titleLabel.font = [UIFont systemFontOfSize:25];
        self.titleLabel.textColor = [UIColor colorWithHex:@"#333333"];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.text= @"联系客服";
        [self.bgView addSubview:self.titleLabel];
        
        
        
        //内容
        self.contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,80,kAlertWidth , 21)];
        self.contentLabel.numberOfLines = 0;
        self.contentLabel.textAlignment = NSTextAlignmentCenter;
        self.contentLabel.textColor = [UIColor colorWithRed:148/255.0 green:148/255.0 blue:148/255.0 alpha:1.0];
        self.contentLabel.font = [UIFont systemFontOfSize:13];

        [self.bgView addSubview:self.contentLabel];

        
        //水平灰线
//        self.grayHLine = [[UIView alloc]init];
//        self.grayHLine.bounds = CGRectMake(0, 0, kAlertWidth, 1);
//        self.grayHLine.backgroundColor = [UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:1];
//        [self.bgView addSubview:self.grayHLine];
        
        
        
    }
    return self;
}

- (void)show {
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    [window addSubview:self];
    
    
   
//    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc]init];
//    NSAttributedString *string1 = [[NSAttributedString alloc]initWithString:@"服务时间:周一至周五(09:00-17:30)" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]}];
//    [attribute appendAttributedString:string1];
    
//    self.contentLabel.frame = CGRectMake(0, kAlertHeight/70.0, kAlertWidth, kAlertHeight/37.0);
    
    
    UIButton * deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteBtn.frame = CGRectMake(kAlertWidth-30,16 , 14,14);
    [self.bgView addSubview:deleteBtn];
    deleteBtn.tag = 10000;
    [deleteBtn addTarget:self action:@selector(buttonClick1:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView * deleteBtnImage = [[UIImageView alloc]init];
    deleteBtnImage.frame = CGRectMake(0, 0,14, 14);
    deleteBtnImage.image = [UIImage imageNamed:@"v1.6_delegate_tanchuang"];
    [deleteBtn addSubview:deleteBtnImage];
    self.contentLabel.text = @"服务时间: 周一至周五 (09:00-17:30)";
    
    //self.contentLabel.attributedText = attribute;
   // self.bgView.bounds = CGRectMake(0, 0, kAlertWidth, kAlertHeight);
    self.grayHLine.center = CGPointMake(kAlertWidth/2, kAlertHeight/250*121.5);
//    self.buttonArray = @[SERVICE_PHONE,@"咨询在线客服"];
//    NSArray *buttonArrayImage = @[@"v1.5_lianxi_phone",@"v1.5_consult"];
    self.buttonArray = @[SERVICE_PHONE];
    NSArray *buttonArrayImage = @[@"v1.5_lianxi_phone"];
    //处理按钮
    if (self.buttonArray.count==0) {
        return;
    }  else if (self.buttonArray.count >= 1) {
        
        for (int i=0; i<self.buttonArray.count; i++) {
            
            self.button = [UIButton buttonWithType:UIButtonTypeCustom];
            self.button.frame = CGRectMake(0, 112+54*i, kAlertWidth,  64);
            [self.bgView addSubview:self.button];
            self.button.tag = i;
            [self.button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            _buttonImage = [[UIImageView alloc]init];
            _buttonImage.frame = CGRectMake(70, 21,22, 22);
            _buttonImage.image = [UIImage imageNamed:buttonArrayImage[i]];
            [self.button addSubview:_buttonImage];
            UILabel * btnLbl = [[UILabel alloc]initWithFrame:CGRectMake(72+25,0, kAlertWidth-80,64)];
            btnLbl.textAlignment = 0;
            btnLbl.font = [UIFont systemFontOfSize:20];
            btnLbl.text =_buttonArray[i];
            if (i == 0) {
                btnLbl.textColor = [UIColor colorWithRed:114/255.0 green:179/255.0 blue:1 alpha:1.0];
//                btnLbl.font = [UIFont fontWithName:@"SourceHanSansCN-Regular" size:20];
            }else{
                
                btnLbl.textColor = [UIColor colorWithHex:@"#69DB3A"];

            }
            [self.button addSubview:btnLbl];
            
            self.bgView.bounds = CGRectMake(0, 0, kAlertWidth, kAlertHeight);
            
//            self.grayHLine = [[UIView alloc]init];
//            self.grayHLine.frame = CGRectMake(30, self.button.frame.origin.y+kAlertHeight/250*64, kAlertWidth-60, 1);
//            self.grayHLine.backgroundColor = [UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:1];
//            [self.bgView addSubview:self.grayHLine];
//            if (i==self.buttonArray.count-1) {
//                self.grayHLine.hidden = YES;
//            }
        }
        
        
        
    }
    
    UITapGestureRecognizer *shareTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(go_share)];
    [self addGestureRecognizer:shareTap];
}
- (void)go_share
{
    [self removeFromSuperview];
    
    
    
}
- (void)buttonClick:(UIButton *)button {
    if (self.delegate)
    {
        [self.delegate alertView:self clickedCustomButtonAtIndex:button.tag];
    }
    [self removeFromSuperview];
    
    
}
- (void)buttonClick1:(UIButton *)button {
    
    [self removeFromSuperview];
    
    
}

@end
