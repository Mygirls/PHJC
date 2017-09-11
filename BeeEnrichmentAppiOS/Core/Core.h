//
//  Core.h
//  CarMirrorAppiOS
//
//  Created by renpan on 15/9/17.
//  Copyright (c) 2015年 HangZhouShangFu. All rights reserved.
//
//
#import <Foundation/Foundation.h>
#import "JPHttpWrapper.h"
#import <MapKit/MapKit.h>
#import "BankCardInformationViewController.h"
#import "AlertView.h"

#define HTTP_API_GET_BASE_URL     @"https://www.phjucai.com/shangfu_api"// 普汇正式服


#define HTTP_API_DEFAULT        [CMCore get_api_base_url_with_api]
#define HTTP_API_BASIC          [CMCore get_api_base_url_with_mobile]
#define APP_KEY                 @"77d7ysgdfd374677453j5h5h"
#define SERVICE_PHONE           @"400-803-3222"



#define LOAD_COUNT_MAX          20

@protocol CoreDelegate <NSObject>

- (void)get_city;

@end


@interface Core : NSObject
@property (nonatomic, strong, readonly) JPHttpWrapper* http;
@property (nonatomic, strong)id<CoreDelegate>delegate;
@property (nonatomic, assign) BOOL is_first_run, is_open_gesture_password, is_ti_shi_set_gesture;
// is_open_auto_licai,


@property (nonatomic, strong) UIWebView *phoneCallWebView;

@property (nonatomic, copy) NSString *share_key;
@property (nonatomic, strong) JPViewController *theController;
@property (nonatomic, strong) UIView *panelView;
@property (nonatomic, strong) UIActivityIndicatorView *loadingView;
@property (nonatomic, strong) NSDictionary *shareParams;

@property (nonatomic, strong) AlertView *alert;

- (NSString*)get_api_base_url;
- (NSString*)get_api_base_url_with_api;
- (NSString*)get_api_base_url_with_mobile;
//评论弹框
- (void)setEnabledCommentWithNum:(NSInteger)num;
- (NSInteger)enabledComment;
- (NSString *)clearZeroWithString:(NSString *)string;
- (BOOL)isExistenceNetwork;


- (void)get_bankList;

@end

#define CMCore              [Core current]
