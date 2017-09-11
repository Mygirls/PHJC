//
//  isSetPaswordView.m
//  BeeEnrichmentAppiOS
//
//  Created by hwm on 17/1/12.
//  Copyright © 2017年 didai. All rights reserved.
//

#import "isSetPaswordView.h"
#define kAlertWidth kScreenWidth/375*100
@interface isSetPaswordView ()

@property (weak, nonatomic) IBOutlet UIView *popView;
@property (weak, nonatomic) IBOutlet UILabel *titleLable;


@end

@implementation isSetPaswordView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.popView.layer.cornerRadius = 12.0;

}

- (IBAction)clickCancleBtn:(id)sender {
    [CMCore setIs_ti_shi_set_gesture:NO];
    [self hide];
}

- (IBAction)clickSetBtn:(id)sender {
    if (self.isSetPaswordViewBlockClick) {
        self.isSetPaswordViewBlockClick(isSetPaswordViewTypeSet);
        [self hide];
    }
}

- (void)show {
    self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    self.popView.transform = CGAffineTransformMakeScale(0.01, 0.01);
    self.titleLable.transform = CGAffineTransformMakeScale(0.01, 0.01);
    self.titleLable.alpha = 0.01;
    self.popView.alpha = 0.01;
    [[UIApplication sharedApplication].keyWindow insertSubview:self atIndex:1];
    [UIView animateWithDuration:0.3 animations:^{
        self.popView.transform = CGAffineTransformMakeScale(1.0, 1.0);
        self.titleLable.transform = CGAffineTransformMakeScale(1.0, 1.0);
        self.popView.alpha = 1.0;
        self.titleLable.alpha = 1.0;
    }];
}

- (void)hide {
    [UIView animateWithDuration:0.3 animations:^{
        self.popView.transform = CGAffineTransformMakeScale(0.1, 0.1);
        self.titleLable.transform = CGAffineTransformMakeScale(0.1, 0.1);
        self.popView.alpha = 0.1;
        self.titleLable.alpha = 0.1;
    } completion:^(BOOL finished) {
        [self.popView removeFromSuperview];
        [self removeFromSuperview];
    }];
}



@end
