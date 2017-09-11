//
//  AppDelegate.m
//  BeeEnrichmentAppiOS
//
//  Created by dll on 15/12/18.
//  Copyright © 2015年 didai. All rights reserved.
//

#import "AppDelegate.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import "LLLockViewController.h"
#import "CMBaseTabBarController.h"
#import "AdImageView.h"//广告图
#import <mach/mach_time.h>
#import "UMessage.h"//友盟
#import <UserNotifications/UserNotifications.h>
#import "CMBaseTabBarController.h"
#import "Reachability.h"
@interface AppDelegate ()<UNUserNotificationCenterDelegate>
@property (nonatomic, strong) UIImageView *start_view, *blurredView;

@property (nonatomic, strong) CMBaseTabBarController *tabvc;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    UINavigationBar *navigationBar = [UINavigationBar appearance];
    UITabBar *tabBar = [UITabBar appearance];
    [CMCore set_theme_with_navigationBar_tabBar:navigationBar tabBar:tabBar navBarColor:[UIColor colorWithHex:@"#e1e1e1"]];
    // AFN请求
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    if (![CMCore isExistenceNetwork]) {
        [[JPAlert current] showAlertWithTitle:@"提示" content:@"当前网络不可用，请检查网络连接" button:@[@"取消", @"去检查"] block:^(UIAlertView* alertView, NSInteger index) {
            if (index) {
                NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if ([[UIApplication sharedApplication] canOpenURL:url]) {
                    [[UIApplication sharedApplication] openURL:url];
                }
                exit(0);
            }
        }];
        
    }else {
        //启动页动画
        [self set_start_view];
    }
    // 强制更新
    uint64_t start = mach_absolute_time ();
//    [CMCore is_mandatoryUpdate];
    uint64_t end = mach_absolute_time ();
    uint64_t elapsed = end - start;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(elapsed / NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 注册推送
        [CMCore register_push_with_application:application launchOptions:launchOptions];
        // 美洽SDK
        [self mqSDK];
        // 友盟分享
        [self register_UMShare];
        // 友盟统计
        [self setUM];
        // 友盟推送
        [self pushUMWithlaunchOptions:launchOptions];
    });
    
    return YES;
    
    
}

#pragma mark 友盟分享
- (void)register_UMShare {
    
    //打开调试日志
    [[UMSocialManager defaultManager] openLog:NO];
    //设置友盟appkey
    [[UMSocialManager defaultManager] setUmSocialAppkey:UMAPPKEY];
    // 获取友盟social版本号
    //    NSLog(@"UMeng social version: %@", [UMSocialGlobal umSocialSDKVersion]);
    //设置微信的appKey和appSecret
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wx425e8ff191fa2bb9" appSecret:@"a28a10adbe972390f0f144f997861f2e" redirectURL:@"https://mobile.umeng.com/social"];//https://itunes.apple.com/cn/app/mi-feng-ju-cai/id1100846351?mt=8
    
}

#pragma mark 初始化美洽SDK
- (void)mqSDK {
    [MQManager initWithAppkey:@"dc706261c48aa82d5281d8793004fef4" completion:^(NSString *clientId, NSError *error) {
        if (!error) {
            
        }
    }];
}

#pragma mark 友盟推送
- (void)pushUMWithlaunchOptions:(NSDictionary *)launchOptions
{
    //初始化方法,也可以使用(void)startWithAppkey:(NSString *)appKey launchOptions:(NSDictionary * )launchOptions httpsenable:(BOOL)value;这个方法，方便设置https请求。
    [UMessage startWithAppkey:UMAPPKEY launchOptions:launchOptions];
    
    
    //注册通知，如果要使用category的自定义策略，可以参考demo中的代码。
    [UMessage registerForRemoteNotifications];
    
    //iOS10必须加下面这段代码。
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate=self;
    UNAuthorizationOptions types10=UNAuthorizationOptionBadge|  UNAuthorizationOptionAlert|UNAuthorizationOptionSound;
    [center requestAuthorizationWithOptions:types10     completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            //点击允许
            //这里可以添加一些自己的逻辑
        } else {
            //点击不允许
            //这里可以添加一些自己的逻辑
        }
    }];
//    //打开日志，方便调试
//    [UMessage setLogEnabled:NO];
}



#pragma mark 友盟统计
- (void)setUM {
    // UMeng统计
    UMConfigInstance.appKey = UMAPPKEY;
    UMConfigInstance.channelId = @"App Store mfjczsb";
    [MobClick startWithConfigure:UMConfigInstance];//初始化SDK！
    [MobClick setLogEnabled:NO];//
    [MobClick setCrashReportEnabled:YES];
}
#pragma mark 蒲公英
- (void)setPGY {
    //启动基本SDK
    //    [[PgyManager sharedPgyManager] startManagerWithAppId:@"7a88e7de2e3f1458a05d2df413f9bd8c"];
    //启动更新检查SDK
    //    [[PgyUpdateManager sharedPgyManager] startManagerWithAppId:@"7a88e7de2e3f1458a05d2df413f9bd8c"];
    //    [[PgyManager sharedPgyManager] setFeedbackActiveType:kPGYFeedbackActiveTypeShake];
    //    [[PgyUpdateManager sharedPgyManager] checkUpdate];
}
- (void)initCore
{
    CMCore;
}
- (void)set_start_view
{
    [self.window makeKeyAndVisible];
    _start_view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    
    _start_view.image = [UIImage imageNamed:@"v1_launchImage_1242*2208"];
    _start_view.contentMode = UIViewContentModeScaleAspectFit;
    _start_view.backgroundColor = [UIColor whiteColor];
    
    [self.window addSubview:_start_view];
    
    [self.window bringSubviewToFront:_start_view];
    [self performSelector:@selector(getImageFromRequest) withObject:nil afterDelay:0.05f];

}
- (void)showImageAnimacation
{

    CGFloat width = kScreenWidth - 120;
    UIImageView *circelImageView = [[UIImageView alloc] initWithFrame:CGRectMake(60, (kScreenHeight - kScreenWidth) * 0.5 - 20, width, width)];
    circelImageView.image = [UIImage imageNamed:@""];
    [_start_view addSubview:circelImageView];
    circelImageView.alpha = 0.0f;
    [UIView animateWithDuration:1.0f animations:^{
        circelImageView.alpha = 1.0f;
    } completion:^(BOOL finished) {
        [NSThread sleepForTimeInterval:2.0f];
        [_start_view removeFromSuperview];
    }];
}

- (void)addBlurredView {
    if (_blurredView == nil) {
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
        effectView.frame = [UIScreen mainScreen].bounds;
        effectView.alpha = 0.96;
        _blurredView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [_blurredView addSubview:effectView];
        
    }
    [[UIApplication sharedApplication].keyWindow addSubview:_blurredView];
}
- (void)removeBlurredView {
    [_blurredView removeFromSuperview];
}

// 欢迎页
- (void)getImageFromRequest {
    [CMCore get_basic_config_is_alert:YES blockResult:^(NSNumber *code, id result, NSString *message) {
        if ([code integerValue]== 200) {
            //检查版本
            [CMCore save_launch_image_info:result];
            
            [CMCore check_version];

            [_start_view removeFromSuperview];
            NSDictionary *dic = [CMCore get_launch_image_info];
            NSString *time = [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970] * 1000];
            
            if (dic != nil && [dic[@"launchImage"][@"expiredTime"] integerValue] > [time integerValue]) {
                AdImageView *adImageView = [[NSBundle mainBundle] loadNibNamed:@"AdImageView" owner:nil options:nil].lastObject;
                
                [adImageView showImgViewInWindow:self.window];
            }
        }
    } blockRetry:^(NSInteger index) {
        
        [self getImageFromRequest];
    }];
}

#pragma mark delegate / datasour
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    DLog(@"注册推送服务时，发生以下错误： %@",error);
}
#pragma 注册,接收推送触发方法
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    //register to receive notifications
    [application registerForRemoteNotifications];
}
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    //保存 deviceToken
    NSString *str = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    NSString *deviceTokenStr = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    [CMCore save_device_token:deviceTokenStr];
    [MQManager registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    
    [UMessage setAutoAlert:NO];
    [UMessage didReceiveRemoteNotification:userInfo];
    //    if (application.applicationState == UIApplicationStateActive) {

//    if (application.applicationState == UIApplicationStateActive) {
        //        [CMCore push_process:userInfo from_app_run:NO vc:_main_vc];
//    }else
//    {
        //        [CMCore push_process:userInfo from_app_run:YES vc:_main_vc];
//    }
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler
{
    if (application.applicationState == UIApplicationStateActive) {
        //接收到推送消息的时候，app在前台，将推送转为本地推送
        //                [CMCore push_process:userInfo from_app_run:NO vc:_main_vc];
    }else
    {
        //接收到推送消息的时候，app在后台，将点击推送消息的时候，跳转到活动详情界面
        //        [CMCore push_process:userInfo from_app_run:YES vc:_main_vc];
    }
}

//iOS10新增：处理前台收到通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于前台时的远程推送接受
        //关闭友盟自带的弹出框
        [UMessage setAutoAlert:NO];
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        
    }else{
        //应用处于前台时的本地推送接受
    }
    //当应用处于前台时提示设置，需要哪个可以设置哪一个
    completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionAlert);
}

//iOS10新增：处理后台点击通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler{
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于后台时的远程推送接受
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        
    }else{
        //应用处于后台时的本地推送接受
    }
    
}

// 即将失去焦点
- (void)applicationWillResignActive:(UIApplication *)application {
    [self addBlurredView];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"isBool_selecteBtn"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"btn_index"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"index_VC"];
}
//进入后台
- (void)applicationDidEnterBackground:(UIApplication *)application {
    [MQManager closeMeiqiaService];
}
// 即将进入前台
- (void)applicationWillEnterForeground:(UIApplication *)application {
    // 是否强更
    [CMCore check_version];
    [self removeBlurredView];
    [MQManager openMeiqiaService];
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [self removeBlurredView];
   
}

- (void)applicationWillTerminate:(UIApplication *)application {
   
}


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(nullable NSString *)sourceApplication annotation:(id)annotation
{
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
    }
    return result;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    return TRUE;
}

@end
