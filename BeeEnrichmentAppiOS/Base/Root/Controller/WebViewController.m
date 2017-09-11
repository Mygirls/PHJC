//
//  WebViewController.m
//  BeeEnrichmentAppiOS
//
//  Created by dll on 15/12/28.
//  Copyright © 2015年 didai. All rights reserved.
//

#import "WebViewController.h"
#import "BeeWebViewBridge.h"
#import "LoginNavigationController.h"//登录
#import "CMBaseTabBarController.h"//root
#import "ProductViewController.h"//产品详情
#import "MyAccountNavigationController.h"//我的资产
//#import "MyCouponsViewController.h"//我的理财券
#import "SupermarketNavigationController.h"//理财集市
#import <MeiQiaSDK/MQManager.h>//在线客服
#import "MQChatDeviceUtil.h"
#import "MQChatViewManager.h"
#import "MQChatViewController.h"
#import "ShowImage.h"//照片显示
//#import "MyWalletViewController.h"
#import "ShareView.h"//新的分享
#import "TransferProductViewController.h"
#import "VipViewController.h"
#import "AboutAppViewController.h"
#import "DiscoverViewController.h"

#import "JPAlert.h"
#import <JavaScriptCore/JavaScriptCore.h>

@interface WebViewController ()<UIWebViewDelegate>
@property (nonatomic, strong)NSDictionary *params;
@property (nonatomic, copy)NSString* url, *methode, *rightUrl, *rightTitle;//, *params_name
@property (strong, nonatomic) IBOutlet UIWebView *web_view;

@property (nonatomic, strong) BeeWebViewBridge* bridge;
@property (nonatomic, assign) BOOL isScaling, isShowCloseItem;
@property (nonatomic, strong)CMBaseTabBarController *rootTab;
@property (nonatomic, weak) UIActivityIndicatorView * activityView;

@property (nonatomic, weak) UIButton * backItem;
@property (nonatomic, weak) UIButton * closeItem;
@property (nonatomic, strong) UIView *backView;

@property (nonatomic, strong)WebViewController *rightVC;
@end

@implementation WebViewController
- (void)init_ui
{
    [super init_ui];
    _isShowCloseItem = YES;
    
    [self initWebView];
    [self initNaviBar];
    __weak WebViewController* _self = self;
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    _rootTab = (CMBaseTabBarController *)keyWindow.rootViewController;
    
    _bridge = [BeeWebViewBridge bridgeForWebView:_web_view webViewDelegate:self];
    [_bridge setBlock_bridge_callback:^(NSString *method, NSArray *params) {
        [_self bridge_callback_with_method:method params:params];
    }];
    
}

- (void)initWebView{
    
    UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64)];
    webView.delegate = self;
    [self.view addSubview:webView];
    self.web_view = webView;
    
    //activityView
    if (_activityView == nil) {
        UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activityView.center = self.view.center;
        [activityView startAnimating];
        self.activityView = activityView;
        [self.view addSubview:activityView];
    }
    //清除UIWebView的缓存
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    [self.web_view loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30.0]];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"%@", self.navigationController.childViewControllers);
    if (_flagStr || self.navigationController.childViewControllers.count >= 3) {
        [self.tabBarController.tabBar setHidden:YES];
    }
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
    NSLog(@"%@", self.navigationController.childViewControllers);
    if ( [self.navigationController.childViewControllers.lastObject isKindOfClass:[DiscoverViewController class]]) {
        [self.tabBarController.tabBar setHidden:NO];
    }
//    [self.tabBarController.tabBar setHidden:NO];
    
}
- (void)WBclickRightItem
{
    _flagStr = @"HIDDEN";
    [self go_next:_rightVC animated:YES viewController:self];
}
#pragma mark 分享
- (void)WBclickRightItemImage {
    
    if ([CMCore is_login])
    {
        
        //        ShareView *shareV = [ShareView load_nib];
        ShareKindsView *shareV = [ShareKindsView load_nib];
        shareV.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        shareV.clickShareBlock = ^(NSInteger index) {
            
            //            if (type == ShareViewTypeWeibo) {
            //
            //            }else if (type == ShareViewTypeQQ) {
            //
            //            }else if (type == ShareViewTypeWeChat) {
            //                [self share_to_wechat_with_title:self.navigationItem.title content:_share_content? _share_content : self.navigationItem.title  share_url_str:_url share_type:SSDKPlatformSubTypeWechatSession];
            //            }else if (type == ShareViewTypeMessage) {
            //                [self share_to_smstitle:self.navigationItem.title content:_share_content im_url:_url];
            //            }
            switch (index) {
                case 0://微信好友 SSDKPlatformSubTypeWechatSession
                {
                    
                    [self shareWebPageToPlatformType:UMSocialPlatformType_WechatSession title:self.navigationItem.title contenText:@"点击查看详情" share_url:_url image_url:UMS_THUMB_IMAGE];
                }
                    break;
                case 1://微信朋友圈 SSDKPlatformSubTypeWechatTimeline
                {
                    
                    [self shareWebPageToPlatformType:UMSocialPlatformType_WechatTimeLine title:self.navigationItem.title contenText:@"点击查看详情"share_url:_url image_url:UMS_THUMB_IMAGE];
                }
                    break;
                case 2://短信
                {
                    [self shareWebPageToPlatformType:UMSocialPlatformType_Sms title:self.navigationItem.title contenText:@"点击查看详情" share_url:_url image_url:UMS_THUMB_IMAGE];
                    
                    
                }
                    break;
                default:
                {
                    [SVProgressHUD dismiss];
                }
                    break;
            }
        };
        [shareV show];
    }
    else
    {
        [[JPAlert current] showAlertWithTitle:@"先登录后才可以分享哦" button:@"好的"];
        LoginNavigationController* login = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginNavigationController"];
        [self.navigationController presentViewController:login animated:YES completion:nil];
    }
    
}


#pragma mark 友盟,网页分享
//网页分享
- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType title:(NSString *)title contenText:(NSString *)contentText share_url:(NSString *)share_url image_url:(NSString *)image_url
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    NSString* thumbURL = image_url;
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


- (void)load_web
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_url]];
    [_web_view loadRequest:request];
}
- (void)webViewDidStartLoad:(UIWebView *)webView {
    [self.activityView startAnimating];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self.activityView stopAnimating];
    //    self.navigationController.navigationItem.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    if (![[webView stringByEvaluatingJavaScriptFromString:@"document.title"] containsString:@"上上签"]) {
        //        self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    }
    
    if (_isScaling) {
        //放大缩小
        NSString *meta = [NSString stringWithFormat:@"document.getElementsByName(\"viewport\")[0].content = \"width=self.view.frame.size.width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=5.0, user-scalable=yes\""];
        [webView stringByEvaluatingJavaScriptFromString:meta];
        //(initial-scale是初始缩放比,minimum-scale=1.0最小缩放比,maximum-scale=5.0最大缩放比,user-scalable=yes是否支持缩放)
        //    [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '40%'"];//修改百分比即可
    }
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    DLog(@"url: %@", request.URL.absoluteURL.description);
    if (_isShowCloseItem && self.web_view.canGoBack) {
        [self setColseItemIsHidden:NO];
    }else
    {
        [self setColseItemIsHidden:YES];
    }
    return YES;
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self.activityView stopAnimating];
}

- (void)initNaviBar{
    
    UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    UIButton * backItem = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    [backItem setImage:[UIImage imageNamed:@"v1_left_item"] forState:UIControlStateNormal];
    [backItem setImageEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 0)];
    [backItem setTitle:@" 返回" forState:UIControlStateNormal];
    backItem.titleLabel.font = [UIFont systemFontOfSize:16];
    [backItem setTitleEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 0)];
    [backItem setTitleColor:[CMCore basic_black_color] forState:UIControlStateNormal];
    [backItem addTarget:self action:@selector(clickedBackItem:) forControlEvents:UIControlEventTouchUpInside];
    self.backItem = backItem;
    _backView = backView;
    [backView addSubview:backItem];
    
    UIButton * closeItem = [[UIButton alloc]initWithFrame:CGRectMake(44, 0, 44, 44)];
    closeItem.titleLabel.font = [UIFont systemFontOfSize:15];
    [closeItem setTitle:@"关闭" forState:UIControlStateNormal];
    [closeItem setTitleColor:[CMCore basic_black_color] forState:UIControlStateNormal];
    [closeItem addTarget:self action:@selector(clickedCloseItem:) forControlEvents:UIControlEventTouchUpInside];
    self.closeItem = closeItem;
    [self setColseItemIsHidden:YES];
    [backView addSubview:closeItem];
    
    UIBarButtonItem * leftItemBar = [[UIBarButtonItem alloc]initWithCustomView:backView];
    self.navigationItem.leftBarButtonItem = leftItemBar;
    
}

- (void)setColseItemIsHidden:(BOOL)isHidden
{
    if (isHidden) {
        _backView.bounds = CGRectMake(0, 0, 44, 44);
    }else
    {
        _backView.bounds = CGRectMake(0, 0, 100, 44);
    }
    self.closeItem.hidden = isHidden;
}
#pragma mark - clickedBackItem
- (void)clickedBackItem:(UIBarButtonItem *)btn{
    if (_isShowCloseItem && self.web_view.canGoBack) {
        
        [self.web_view goBack];
        //        [self setColseItemIsHidden:NO];
    }else{
        
        [self clickedCloseItem:nil];
    }
}

#pragma mark - clickedCloseItem
- (void)clickedCloseItem:(UIButton *)btn{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)load_subject_detail_with_id:(NSDictionary *)dic
{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD showWithStatus:@"正在加载详情信息"];
    [CMCore get_subject_detail_with_subject_id:[dic objectForKey:@"subject_id"] market_type:[[dic objectForKey:@"market_type"] integerValue] is_alert:YES blockResult:^(NSNumber *code, id result, NSString *message) {
        [SVProgressHUD dismiss];
//        NSInteger status = [result[@"status"] integerValue];
//        if (status != 200 && status != 100) {
//            //300 售完，400 计息中，500 已兑付
//            NSString * title = @"真遗憾，本理财产品已被抢空，理财集市中有更多惊喜哦!";
//            [[JPAlert current] showAlertWithTitle:@"温馨提示" content:title button:@"去看看" block:^(UIAlertView *alert, NSInteger index) {
//                [_rootTab setSelectedIndex:1];
//            }];
//            return;
//        }else {
            if ([[dic objectForKey:@"market_type"] integerValue] == 30) {
                TransferProductViewController *transVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"TransferProductViewController"];
                transVC.productM = [ProductsDetailModel mj_objectWithKeyValues:result];
                if ([dic[@"is_buy"] integerValue] == 0) {
                    transVC.judgeBuy = 999;
                }
                [[CMCore getCurrentVC].navigationController pushViewController:transVC animated:YES];
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    ProductViewController *dingqi_vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ProductViewController"];
                    dingqi_vc.data_dic = result;
                    if ([dic[@"is_buy"] integerValue] == 0) {
                        dingqi_vc.judgeBuy = 999;
                    }
                    [[CMCore getCurrentVC].navigationController pushViewController:dingqi_vc animated:YES];
                });
            }
//        }
    } blockRetry:^(NSInteger index) {
        [SVProgressHUD dismiss];
        if (index == 1) {
            [self load_subject_detail_with_id:dic];
        }
    }];
}
#pragma mark 没有右边跳转的
- (void)load_withUrl:(NSString *)url title:(NSString *)title canScaling:(BOOL)canScaling{
    _isScaling = canScaling;
    self.navigationItem.title = title;
    _url = url;
}
#pragma mark 带右边文字的
- (void)load_withRightBarUrl:(NSString *)rightBarUrl title:(NSString *)title canScaling:(BOOL)canScaling {//isShowCloseItem:(BOOL)isShowCloseItem
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:self action:@selector(WBclickRightItem)];
    _rightVC = [self.storyboard instantiateViewControllerWithIdentifier:@"WebViewController"];
//    _rightVC.flagStr = @"HIDDEN";
    [_rightVC load_withUrl:rightBarUrl title:title canScaling:canScaling];// isShowCloseItem:isShowCloseItem
}
#pragma mark 带右边图片的
- (void)load_withRightImageBarUrl:(NSString *)rightBarImageName title:(NSString *)title url:(NSString *)url canScaling:(BOOL)canScaling {
    _isScaling = canScaling;
    self.navigationItem.title = title;
    _url = url;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:rightBarImageName] style:UIBarButtonItemStylePlain target:self action:@selector(WBclickRightItemImage)];
}
- (void)bridge_callback_with_method:(NSString*)method params:(NSArray*)params
{
    if([method isEqualToString:@"click_register"])
    {//跳转注册
        if([CMCore is_login]){
            [[JPAlert current] showAlertWithTitle:@"您已经注册过啦" button:@"好的"];
        }else{
            LoginNavigationController* login = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginNavigationController"];
            [self.navigationController presentViewController:login animated:YES completion:nil];
        }
    }
    else if ([method isEqualToString:@"go_to_webView"])
    {
        //消息小站
        NSString* params_first = [params firstObject];
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        _rootTab = (CMBaseTabBarController *)keyWindow.rootViewController;
        MyAccountNavigationController *navc = [_rootTab.viewControllers objectAtIndex:2];
        WebViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"WebViewController"];
        [vc load_withUrl:params_first title:@"帮助中心" canScaling:YES];// isShowCloseItem:YES
        [navc pushViewController:vc animated:YES];
    }
    else if ([method isEqualToString:@"click_market_list"])
    { //集市
        [_rootTab setSelectedIndex:1];
    }
    else if ([method isEqualToString:@"click_subject_detail"])
    {//产品详情
        NSString* params_first = [params firstObject];
        NSDictionary* t_params = [params_first JSONValue];
        [self load_subject_detail_with_id:t_params];
    }
    else if ([method isEqualToString:@"click_share"])
    {//分享
        
        //        NSString* params_first = [params firstObject];
        //        NSDictionary* t_params = [params_first JSONValue];
        //
        //
        //        [CMCore share_with_dict:t_params vc:self];
        
        if ([CMCore is_login])
        {
            NSString* params_first = [params firstObject];
            NSDictionary* t_params = [params_first JSONValue];
            
            //        ShareView *shareV = [ShareView load_nib];
            ShareKindsView *shareV = [ShareKindsView load_nib];
            shareV.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
            shareV.clickShareBlock = ^(NSInteger index) {
                
                switch (index) {
                    case 0://微信好友 SSDKPlatformSubTypeWechatSession
                    {
                        DLog(@"%@",t_params);
                        [self shareWebPageToPlatformType:UMSocialPlatformType_WechatSession title:t_params[@"title"] contenText:t_params[@"content"] share_url:t_params[@"share_url"] image_url:UMS_THUMB_IMAGE];
                    }
                        break;
                    case 1://微信朋友圈 SSDKPlatformSubTypeWechatTimeline
                    {
                        
                        [self shareWebPageToPlatformType:UMSocialPlatformType_WechatTimeLine title:t_params[@"title"] contenText:t_params[@"content"] share_url:t_params[@"share_url"] image_url:UMS_THUMB_IMAGE];
                    }
                        break;
                    case 2://短信
                    {
                        [self shareWebPageToPlatformType:UMSocialPlatformType_Sms title:t_params[@"title"] contenText:t_params[@"content"] share_url:t_params[@"share_url"] image_url:UMS_THUMB_IMAGE];
                    }
                        break;
                    default:
                    {
                        [SVProgressHUD dismiss];
                    }
                        break;
                }
            };
            [shareV show];
        }else {
            [[JPAlert current] showAlertWithTitle:@"先登录后才可以分享哦" button:@"好的"];
            LoginNavigationController* login = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginNavigationController"];
            [self.navigationController presentViewController:login animated:YES completion:nil];
        }
//    }
//    else if ([method isEqualToString:@"click_redPacket"])
//    {//红包
//        if ([CMCore is_login]) {
//            MyAccountNavigationController *navc = [_rootTab.viewControllers objectAtIndex:2];
//            MyWalletViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MyWalletViewController"];
//            [navc pushViewController:vc animated:YES];
//            [_rootTab setSelectedIndex:2];
//            
//        }else {
//            [[JPAlert current] showAlertWithTitle:@"您还没有登录，请先登录" button:@"好的"];
//            LoginNavigationController* login = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginNavigationController"];
//            [self.navigationController presentViewController:login animated:YES completion:nil];
//        }
    }else if ([method isEqualToString:@"click_integral"])
    {//积分
        if ([CMCore is_login]) {
            MyAccountNavigationController *navc = [_rootTab.viewControllers objectAtIndex:2];
            WebViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"WebViewController"];
            NSString *url = [NSString stringWithFormat:@"%@/integral/mall?access_token=%@",[CMCore get_api_base_url],[CMCore get_access_token]];
            NSString *rightUrl = [NSString stringWithFormat:@"%@general_infomation?key=mfsm",[CMCore get_api_base_url_with_mobile]];
            [vc load_withUrl:url title:@"我的积分" canScaling:YES];// isShowCloseItem:YES
            [vc load_withRightBarUrl:rightUrl title:@"积分说明" canScaling:YES];// isShowCloseItem:YES
            [navc pushViewController:vc animated:YES];
            [_rootTab setSelectedIndex:2];
        }
        else
        {
            [[JPAlert current] showAlertWithTitle:@"您还没有登录，请先登录" button:@"好的"];
            LoginNavigationController* login = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginNavigationController"];
            [self.navigationController presentViewController:login animated:YES completion:nil];
        }
    }
    else if ([method isEqualToString:@"click_onlineService"])
    {//在线客服
        if ([CMCore is_login]) {
            MyAccountNavigationController *navc = [_rootTab.viewControllers objectAtIndex:3];
            NSString *phone = [CMCore get_user_info_member][@"mobile_phone"];
            NSString *source = [[UIDevice currentDevice] name];
            [MQManager setClientInfo:@{@"name":phone, @"source":source} completion:^(BOOL success, NSError *error) {
            }];
            MQChatViewManager *chatViewManager = [[MQChatViewManager alloc] init];
            chatViewManager.chatViewStyle.enableOutgoingAvatar = false;
            [chatViewManager pushMQChatViewControllerInViewController:[navc.viewControllers objectAtIndex:0]];
            [_rootTab setSelectedIndex:3];
        }
        else
        {
            [[JPAlert current] showAlertWithTitle:@"您还没有登录，请先登录" button:@"好的"];
            LoginNavigationController* login = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginNavigationController"];
            [self.navigationController presentViewController:login animated:YES completion:nil];
        }
//    }
//    else if ([method isEqualToString:@"click_coupon"])
//    {//理财券
//        if ([CMCore is_login]) {
//            MyAccountNavigationController *navc = [_rootTab.viewControllers objectAtIndex:2];
//            MyCouponsViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MyCouponsViewController"];
//            [navc pushViewController:vc animated:YES];
//            [_rootTab setSelectedIndex:2];
//        }
//        else
//        {
//            [[JPAlert current] showAlertWithTitle:@"您还没有登录，请先登录" button:@"好的"];
//            LoginNavigationController* login = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginNavigationController"];
//            [self.navigationController presentViewController:login animated:YES completion:nil];
//            
//        }
    }else if ([method isEqualToString:@"show_image"])
    {
        NSString* params_first = [params firstObject];
        NSDictionary* t_params = [params_first JSONValue];
        ShowImage *showImage = [ShowImage load_nib];
        [showImage showInView:self.view iamge_ulr:t_params[@"image_url"] title:t_params[@"title"]];
    }else if ([method isEqualToString:@"show_phone_dialog"])
    {
        NSString* params_first = [params firstObject];
        //打电话
        [CMCore call_service_phone_with_view:self.view phone:params_first];
    }else if ([method isEqualToString:@"is_show_closeItem"])
    {
        //是否显示“关闭”按钮
        NSString* params_first = [params firstObject];
        NSDictionary* t_params = [params_first JSONValue];
        DLog(@"%@",t_params);
        _isShowCloseItem = [t_params[@"is_show_closeItem"] boolValue];
        
    }else if ([method isEqualToString:@"get_params"])
    {
        NSString* params_first = [params firstObject];
        NSDictionary* t_params = [params_first JSONValue];
        NSString *params_name = [NSString stringWithFormat:@"%@",t_params[@"params_name"]];
        if (params_name.length > 0) {
            [self callByValueWithParamsName:params_name];
        }
    }
}
//通过paramsName，匹配需要传什么值
- (void)callByValueWithParamsName:(NSString *)paramsName
{
    //要传出去的值
    NSString *value = @"";
    if ([paramsName isEqualToString:@"access_token"]) {
        value = [CMCore get_access_token]?:@"";
    }else if ([paramsName isEqualToString:@"member_id"]){
        value = [CMCore get_user_info_member][@"memberId"];
    }
    //方法1
    NSString *jsMethode = [NSString stringWithFormat:@"set_params('%@')",value];
    [_web_view stringByEvaluatingJavaScriptFromString:jsMethode];
    //方法2
    //        NSString *jsMethode = [NSString stringWithFormat:@"set_params('%@')",value];
    //        JSContext *context = [_web_view valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    //        [context evaluateScript:jsMethode];
    //方法3
    //  [_bridge excuteJSWithObj:value function:paramsName];
}



@end
