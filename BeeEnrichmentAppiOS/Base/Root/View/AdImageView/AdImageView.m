//
//  AdImageView.m
//  BeeEnrichmentAppiOS
//
//  Created by dll on 16/6/23.
//  Copyright © 2016年 didai. All rights reserved.
//

#import "AdImageView.h"
#import "CMBaseTabBarController.h"
#import "WebViewController.h"
#import "ProductViewController.h"
#import "LoginNavigationController.h"

@interface AdImageView ()
@property (strong, nonatomic) IBOutlet UIButton *btn;
@property (nonatomic, copy) NSString *filePath;
@property (nonatomic, assign) int timeCount;
@property (nonatomic, strong) NSTimer * timerCoder;
@property (nonatomic, strong) UIWindow *window;
@end
@implementation AdImageView

- (IBAction)btnAction:(id)sender {
    [self stopTimer];
}
-(void)awakeFromNib
{
    [super awakeFromNib];
}
- (void)showImgViewInWindow:(UIWindow *)keyWindow {
    self.frame = [UIScreen mainScreen].bounds;
    _window = keyWindow;
    [keyWindow addSubview:self];
    [keyWindow bringSubviewToFront:self];
    [_btn setBackgroundImage:[UIColor image_with_color:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.2]] forState:UIControlStateNormal];
    
    
    //[NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(loadImage) userInfo:nil repeats:YES];
    [self loadImage];
}
- (void)loadImage{
    UIImage *currentImage = [UIImage imageNamed:@"v1_launchImage_1242*2208"];
    _timeCount = 3;
    _imageView.image = currentImage;
    NSDictionary *dic = [CMCore get_launch_image_info];
     NSString *time = [NSString stringWithFormat:@"%.2f", [[NSDate date] timeIntervalSince1970] * 1000];
    if ([dic[@"launchImage"][@"expiredTime"]  integerValue]> [time integerValue]) {
        
        NSDictionary *dict = [CMCore get_launch_image_info];
        NSDictionary *info = dict[@"launchImage"];
        if ([[info allKeys] containsObject:@"url"] && [NSString stringWithFormat:@"%@",info[@"url"]].length > 0) {
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushToWebVC)];
            [_imageView addGestureRecognizer:tap];
        }
        _timeCount = [info[@"delayTime"] intValue];
        NSURL *url = [NSURL URLWithString:info[@"imageUrl"]];
        [_imageView sd_setImageWithURL:url placeholderImage:currentImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (!error) {
            }
        }];
    }
    [self startTimer];
}
- (void)startTimer {
    if (_timeCount > 0) {
        NSString *title = [NSString stringWithFormat:@"%d秒 跳过", _timeCount];
        [_btn setTitle:title forState:UIControlStateNormal];
        _timeCount -= 1;
        if (_timerCoder == nil) {
            _timerCoder = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
        }
    }else
    {
        [self stopTimer];
    }
    
    
}
- (void)stopTimer {
    _btn.hidden = YES;
    if (_timerCoder != nil) {
        [_timerCoder invalidate];
        _timerCoder = nil;
    }
    [UIView animateWithDuration:0.7 animations:^{
        _imageView.transform = CGAffineTransformMakeScale(1.2, 1.2);
        _imageView.alpha = 0.05;
        
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
- (void)timerAction {
    if (_timeCount > 0) {
        NSString *title = [NSString stringWithFormat:@"%d秒 跳过", _timeCount];
        _btn.titleLabel.text = title;
        [_btn setTitle:title forState:UIControlStateNormal];
        
    }else
    {
        [self stopTimer];
        
    }
    _timeCount -= 1;
}
- (void)pushToWebVC {
    [self removeFromSuperview];
    NSDictionary *dict = [CMCore get_launch_image_info][@"launchImage"];
    //    NSString *url = dict[@"url"];
    //    NSString *title = dict[@"title"]?:@"详情";
    //    WebViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"WebViewController"];
    //    //平台介绍platform_is_introduced
    //    [vc load_withUrl:url title:title canScaling:NO];// isShowCloseItem:YES
    //    CMBaseTabBarController *base = (CMBaseTabBarController *)[_window rootViewController];
    //    [(UINavigationController *)base.childViewControllers.firstObject pushViewController:vc animated:true];
    
    
    NSInteger type = [dict[@"entryType"] integerValue];
    if (type == 30) {
        // h5
        WebViewController *web_vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"WebViewController"];
        [web_vc load_withUrl:dict[@"url"] title:dict[@"title"] canScaling:NO];// isShowCloseItem:YES
        CMBaseTabBarController *base = (CMBaseTabBarController *)[_window rootViewController];
        [(UINavigationController *)base.childViewControllers.firstObject pushViewController:web_vc animated:true];
        
    }else if (type == 10) {
        // 标
        __block NSDictionary * rlt = [NSDictionary dictionary];
        ProductViewController *dingqi_vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ProductViewController"];
//        TransferPayViewController *transVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"TransferPayViewController"];
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
        [SVProgressHUD showWithStatus:@"数据加载中..."];
        [CMCore get_subject_detail_with_subject_id:dict[@"url"] market_type:20 is_alert:YES blockResult:^(NSNumber *code, id result, NSString *message) {
            [SVProgressHUD dismiss];
            if (result) {
                rlt = result;
                dingqi_vc.data_dic = result;
                CMBaseTabBarController *base = (CMBaseTabBarController *)[_window rootViewController];
                
                    [(UINavigationController *)base.childViewControllers.firstObject pushViewController:dingqi_vc animated:true];
            }
        } blockRetry:^(NSInteger index) {
            [SVProgressHUD dismiss];
            if (index == 1) {
                [self pushToWebVC];
            }
        }];
    }else if (type == 20) {
        // 文章
        WebViewController *web_vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"WebViewController"];
        [web_vc load_withUrl:dict[@"url"] title:dict[@"title"] canScaling:NO];// isShowCloseItem:YES
        CMBaseTabBarController *base = (CMBaseTabBarController *)[_window rootViewController];
        [(UINavigationController *)base.childViewControllers.firstObject pushViewController:web_vc animated:true];
    }else if (type == 40) {
        if ([CMCore is_login]) {
            //已登录
            WebViewController *web_vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"WebViewController"];
            NSString *url_str = [NSString stringWithFormat:@"%@sign_in?params=%@",HTTP_API_BASIC,[CMCore get_access_token]];
            [web_vc load_withUrl:url_str title:@"签到" canScaling:NO];// isShowCloseItem:NO
            CMBaseTabBarController *base = (CMBaseTabBarController *)[_window rootViewController];
            [(UINavigationController *)base.childViewControllers.firstObject pushViewController:web_vc animated:true];
        }else{
            //未登录
            LoginNavigationController *login_navc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LoginNavigationController"];
            CMBaseTabBarController *base = (CMBaseTabBarController *)[_window rootViewController];
            [(UINavigationController *)base.childViewControllers.firstObject presentViewController:login_navc animated:YES completion:nil];
        }
        
    }else if (type == 60) {
        // 标
        __block NSDictionary * rlt = [NSDictionary dictionary];
        ProductViewController *dingqi_vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ProductViewController"];
        //        TransferPayViewController *transVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"TransferPayViewController"];
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
        [SVProgressHUD showWithStatus:@"数据加载中..."];
        [CMCore get_subject_detail_with_subject_id:dict[@"url"] market_type:10 is_alert:YES blockResult:^(NSNumber *code, id result, NSString *message) {
            [SVProgressHUD dismiss];
            if (result) {
                rlt = result;
                dingqi_vc.data_dic = result;
                CMBaseTabBarController *base = (CMBaseTabBarController *)[_window rootViewController];
                
                [(UINavigationController *)base.childViewControllers.firstObject pushViewController:dingqi_vc animated:true];
            }
        } blockRetry:^(NSInteger index) {
            [SVProgressHUD dismiss];
            if (index == 1) {
                [self pushToWebVC];
            }
        }];
    }else {
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
