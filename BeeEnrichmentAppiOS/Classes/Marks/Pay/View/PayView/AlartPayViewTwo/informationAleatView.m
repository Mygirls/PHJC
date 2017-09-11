//
//  mistakeView.m
//  BeeEnrichmentAppiOS
//
//  Created by MC on 16/10/13.
//  Copyright © 2016年 didai. All rights reserved.
//

#import "informationAleatView.h"
#define kAlertWidth kScreenWidth/375*100


@interface informationAleatView ()

@property (nonatomic, strong) UIView    *bgView;
@property (nonatomic, strong) UILabel   *titleLabel;
@property (nonatomic, strong) UIImageView *buttonImage;

@end

@implementation informationAleatView


+ (instancetype)alertViewDefault {
    return [[self alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth,kScreenHeight)];
}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = CGRectMake(0, 0,kScreenWidth,kScreenHeight);
        self.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0.1];
        
        
      
        
        self.bgView = [[UIView alloc]init];
        self.bgView.center = self.center;
        self.bgView.backgroundColor =  [[UIColor blackColor]colorWithAlphaComponent:0.8];
        self.bgView.layer.cornerRadius = 5;
        self.bgView.layer.masksToBounds = YES;
        [self addSubview:self.bgView];

        
        self.titleLabel = [[UILabel alloc]init];
        self.titleLabel.font = [UIFont fontWithName:FontOfAttributedRegular size:16];
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        //self.titleLabel.text = self.title;
        [self.bgView addSubview:self.titleLabel];

        _buttonImage = [[UIImageView alloc]init];
        [self.bgView addSubview:_buttonImage];
        
        
        
    }
    return self;
}

- (void)show {
    
   
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    [window addSubview:self];
    
    self.bgView.bounds = CGRectMake(0, 0, kAlertWidth, kAlertWidth);
    self.titleLabel.frame = CGRectMake(0, kAlertWidth/100*68, kAlertWidth, 16);
    self.titleLabel.text= _title;
    _buttonImage.image = _iconImage;
    _buttonImage.frame = CGRectMake(kAlertWidth/100*33.5, kAlertWidth/100*18.5,kAlertWidth/100*33, kAlertWidth/100*33);
    

    [UIView animateKeyframesWithDuration:0.3 delay:0 options:UIViewKeyframeAnimationOptionAutoreverse animations:^{
        
        self.transform = CGAffineTransformMakeScale(1, 1);
        
        
    } completion:^(BOOL finished) {
        [self performSelector:@selector(remove) withObject:nil afterDelay:1.0];
    }];
    
}
-(void)remove {
    [self removeFromSuperview];
}
@end
