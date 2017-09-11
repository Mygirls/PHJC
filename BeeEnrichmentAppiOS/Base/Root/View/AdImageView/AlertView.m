//
//  AlertView.m
//  BeeEnrichmentAppiOS
//
//  Created by dll on 16/6/23.
//  Copyright © 2016年 didai. All rights reserved.
//

#import "AlertView.h"


@interface AlertView ()
@property (strong, nonatomic) IBOutlet UIButton *oneBtn;
@property (strong, nonatomic) IBOutlet UIButton *twoBtn;
@property (strong, nonatomic) IBOutlet UIButton *threeBtn;
@property (strong, nonatomic) IBOutlet UIView *alert;

@end
@implementation AlertView
-(void)awakeFromNib
{
    [super awakeFromNib];
    UIColor *color = [CMCore basic_color];
    _oneBtn.layer.borderColor = color.CGColor;
    _twoBtn.layer.borderColor = color.CGColor;
    _threeBtn.layer.borderColor = color.CGColor;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)showCommentView {
    self.frame = [UIScreen mainScreen].bounds;
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self];
    [keyWindow bringSubviewToFront:self];
    [self bringSubviewToFront:_alert];
    _alert.alpha = 1.0;
    _alert.transform = CGAffineTransformMakeScale(0.01, 0.01);
    [UIView animateWithDuration:0.3 animations:^{
        _alert.transform = CGAffineTransformMakeScale(1.0, 1.0);
        
    } completion:^(BOOL finished) {
    }];
}
- (IBAction)cancelAction:(id)sender {
    [self dismiss];
    [CMCore setEnabledCommentWithNum:0];
}
- (IBAction)oneAction:(id)sender {
    //朕去瞅瞅
    [self dismiss];
    [CMCore setEnabledCommentWithNum:1];
    NSString *str = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@",APP_ID];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}
- (IBAction)twoAction:(id)sender {
    //朕很忙
    [self dismiss];
    [CMCore setEnabledCommentWithNum:2];
}
- (IBAction)threeAction:(id)sender {
    //别再烦朕
    [self dismiss];
    [CMCore setEnabledCommentWithNum:3];
    
}
- (void)dismiss {
    [UIView animateWithDuration:0.3 animations:^{
        _alert.transform = CGAffineTransformMakeScale(0.01, 0.01);
        _alert.alpha = 0.05;
        
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
