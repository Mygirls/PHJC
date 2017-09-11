//
//  BeeWebViewBridge.m
//  BeeEnrichmentAppiOS
//
//  Created by renpan on 16/4/7.
//  Copyright © 2016年 didai. All rights reserved.
//

#import "BeeWebViewBridge.h"

@implementation BeeWebViewBridge
- (void)check_exist
{
//    DLog(@"check_exist");
}

//注册
- (void)click_register
{
    if(_block_bridge_callback)
    {
        _block_bridge_callback(@"click_register", nil);
    }
}

//- (void)click_register:(NSArray*)params
//{
//    NSLog(@"params:%@", params);
//}
//小站
- (void)go_to_webView:(NSArray *)params
{
    if(_block_bridge_callback)
    {
        _block_bridge_callback(@"go_to_webView", params);
    }
}

//集市
- (void)click_market_list
{
    if(_block_bridge_callback)
    {
        _block_bridge_callback(@"click_market_list", nil);
    }
}
//产品详情
- (void)click_subject_detail:(NSArray *)params
{
    if(_block_bridge_callback)
    {
        _block_bridge_callback(@"click_subject_detail", params);
    }
}
- (void)click_share:(NSArray *)params
{
    if(_block_bridge_callback)
    {
        _block_bridge_callback(@"click_share", params);
    }
}
//红包
- (void)click_redPacket
{
    if(_block_bridge_callback)
    {
        _block_bridge_callback(@"click_redPacket", nil);
    }
}
//积分
- (void)click_integral
{
    if(_block_bridge_callback)
    {
        _block_bridge_callback(@"click_integral", nil);
    }
}
//理财券
- (void)click_coupon
{
    if(_block_bridge_callback)
    {
        _block_bridge_callback(@"click_coupon", nil);
    }
}
//跳转到对话普汇
- (void)click_onlineService
{
    if(_block_bridge_callback)
    {
        _block_bridge_callback(@"click_onlineService", nil);
    }
}
//图片展示
- (void)show_image:(NSArray *)params
{
    if(_block_bridge_callback)
    {
        _block_bridge_callback(@"show_image", params);
    }
}
- (void)show_phone_dialog:(NSArray *)params
{
    if (_block_bridge_callback) {
        _block_bridge_callback(@"show_phone_dialog", params);
    }
}
//web是否显示closeItem
- (void)is_show_closeItem:(NSArray *)params
{
    if (_block_bridge_callback) {
        _block_bridge_callback(@"is_show_closeItem", params);
    }
}
//web需要get_params
- (void)get_params:(NSArray *)params {
    if (_block_bridge_callback) {
        _block_bridge_callback(@"get_params", params);
    }
}



@end
