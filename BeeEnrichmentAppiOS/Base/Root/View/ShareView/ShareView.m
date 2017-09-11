//
//  ShareView.m
//  BeeEnrichmentAppiOS
//
//  Created by hwm on 16/11/10.
//  Copyright © 2016年 didai. All rights reserved.
//

#import "ShareView.h"

@interface ShareView ()

@property (weak, nonatomic) IBOutlet UIView *popView;


@end

@implementation ShareView

- (void)awakeFromNib {
    [super awakeFromNib];
    
}
// 微博
- (IBAction)clickWeiboBtn:(id)sender {
    if (self.clickShareBlock) {
        _clickShareBlock(ShareViewTypeWeibo);
    }
    [self hidden];
}
// QQ
- (IBAction)clickQQBtn:(id)sender {
    if (self.clickShareBlock) {
       _clickShareBlock(ShareViewTypeQQ);
    }
    [self hidden];
}
// 微信
- (IBAction)clickWeChatBtn:(id)sender {
    if (self.clickShareBlock) {
        _clickShareBlock(ShareViewTypeWeChat);
    }
    [self hidden];
}
// 短信
- (IBAction)clickMessageBtn:(id)sender {
    if (self.clickShareBlock) {
        _clickShareBlock(ShareViewTypeMessage);
    }
    [self hidden];
}
// 取消
- (IBAction)clickCancle:(id)sender {
    [self hidden];
}


- (void)show {
    
    self.frame = [UIScreen mainScreen].bounds;
    _popView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 0);
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        _popView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 164.5, [UIScreen mainScreen].bounds.size.width, 164.5);
    }];
    
}

- (void)hidden {
    
    [UIView animateWithDuration:0.3 animations:^{
        _popView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 164.5);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self hidden];
    
}


@end
