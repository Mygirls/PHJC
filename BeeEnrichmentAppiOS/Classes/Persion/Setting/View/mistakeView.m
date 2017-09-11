//
//  mistakeView.m
//  BeeEnrichmentAppiOS
//
//  Created by MC on 16/10/13.
//  Copyright © 2016年 didai. All rights reserved.
//

#import "mistakeView.h"
#define kAlertWidth kScreenWidth/375*250

@interface mistakeView ()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *buttonImage;

@end

@implementation mistakeView

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
        [self setImage];
    }
    return self;
}

- (void)setTitle {
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.font = [UIFont fontWithName:FontOfAttributedRegular size:17];
    self.titleLabel.textColor = [UIColor blackColor];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.bgView addSubview:self.titleLabel];
}

- (void)setImage {
    _buttonImage = [[UIImageView alloc]init];
    [self.bgView addSubview:_buttonImage];
}

- (void)setView {
    self.bgView = [[UIView alloc]init];
    self.bgView.center = self.center;
    self.bgView.backgroundColor = [UIColor whiteColor];
    self.bgView.layer.cornerRadius = 10;
    self.bgView.layer.masksToBounds = YES;
    [self addSubview:self.bgView];
    
}

- (void)show {
    
    self.bgView.bounds = CGRectMake(0, 0, kAlertWidth, kScreenHeight/667*150);
    self.titleLabel.frame = CGRectMake(0, kScreenHeight/667*103.5, kAlertWidth, 16);
    self.titleLabel.text= self.title;
    _buttonImage.image = _iconImage;
    _buttonImage.frame = CGRectMake(kScreenWidth/375*94, kScreenHeight/667*25,kScreenWidth/375*62, kScreenWidth/375*62);
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    [window addSubview:self];
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
