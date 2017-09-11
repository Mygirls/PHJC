//
//  MyQrcodeViewController.m
//  BeeEnrichmentAppiOS
//
//  Created by LiuXiaoMin on 16/4/6.
//  Copyright © 2016年 LiuXiaoMin. All rights reserved.
//

#import "MyQrcodeViewController.h"
#import "QRCodeImage.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface MyQrcodeViewController ()

@property (strong, nonatomic) IBOutlet UIImageView *headImageView;
@property (strong, nonatomic) IBOutlet UILabel *phone;
@property (strong, nonatomic) IBOutlet UIImageView *myqrcodeView;
@property (copy, nonatomic) NSString *qrcode_image_url;

@end

@implementation MyQrcodeViewController

- (void)init_ui
{
    [super init_ui];
    [_headImageView.layer setMasksToBounds:YES];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"分享" style:UIBarButtonItemStylePlain target:self action:@selector(clickRightItem)];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    NSString *phone = [CMCore get_user_info_member][@"mobile_phone"];
    _phone.text = [NSString stringWithFormat:@"%@****%@",[phone substringToIndex:3],[phone substringFromIndex:7]];
    NSString *head_image_url = [CMCore get_user_info_member][@"head_image_url"];
    if (head_image_url && head_image_url.length > 0 ) {
        
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:head_image_url] placeholderImage:[UIImage imageNamed:@"v1_personal_center_head"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        _headImageView.layer.borderColor =[UIColor whiteColor].CGColor;
        _headImageView.layer.borderWidth = 3;
        _headImageView.image = image;
    }];
    }
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [self load_my_qrcode_url];
}
#pragma mark 分享
- (void)clickRightItem
{
    //分享
    if (_qrcode_image_url && _qrcode_image_url.length > 0) {
        [self shareWebPageToPlatformType:UMSocialPlatformType_WechatSession title:@"我的名片－我用蜜蜂聚财，赚钱到high爆，数钱到手软！！" contenText:@"点我、点我、快点我，注册马上送大礼!" share_url:_qrcode_image_url];
        
//        [CMCore share_with_key:@"二维码分享" params:@{@"title":@"我的名片－我用蜜蜂聚财，赚钱到high爆，数钱到手软！！",@"content":@"点我、点我、快点我，注册马上送大礼!",@"share_url":_qrcode_image_url,@"image_url":_headImageView.image} vc:self];
        
    }else
    {
        [[JPAlert current] showAlertWithTitle:@"暂不可分享您的二维码信息" button:@"好的"];
    }
    
    
}

#pragma mark 友盟,网页分享
//网页分享
- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType title:(NSString *)title contenText:(NSString *)contentText share_url:(NSString *)share_url
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    NSString* thumbURL = UMS_THUMB_IMAGE;
    //    [NSString stringWithFormat:@"%@",__self.headView.imgView.image];
    //创建网页内容对象
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title descr:contentText thumImage:thumbURL];
    //设置网页地址
    
    if (platformType == UMSocialPlatformType_Sms) {
        shareObject.webpageUrl = [NSString stringWithFormat:@"%@: %@",title,share_url];
    }else {
        shareObject.webpageUrl = share_url;
    }
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                UMSocialLogInfo(@"response message is %@",resp.message);
                //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                
            }else{
                UMSocialLogInfo(@"response data is %@",data);
            }
        }
        [CMCore alertWithError:error];
    }];
}
#pragma mark 网络请求－获得二维码信息
- (void)load_my_qrcode_url
{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD showWithStatus:@"正在加载二维码信息"];
    [CMCore my_qrcode_with_is_alert:YES blockResult:^(NSNumber *code, id result, NSString *message) {
        if ([code integerValue] == 200) {
            [SVProgressHUD setMinimumDismissTimeInterval:1.5];
            [SVProgressHUD showSuccessWithStatus:@"加载成功"];
            _qrcode_image_url = result;
            QRCodeImage *qrcodeImage = [QRCodeImage codeImageWithString:result                                                                    size:kScreenWidth - 220
                                                                  color:[UIColor colorWithRed:41/255.0 green:41/255.0 blue:41/255.0 alpha:1.0]
                                                                   icon:nil
                                                              iconWidth:0];
            
            _myqrcodeView.image = qrcodeImage;
        }else
        {
            [SVProgressHUD dismiss];
        }
        
    } blockRetry:^(NSInteger index) {
        [SVProgressHUD dismiss];
        if (index == 1) {
            [self load_my_qrcode_url];
        }
    }];
}

@end
