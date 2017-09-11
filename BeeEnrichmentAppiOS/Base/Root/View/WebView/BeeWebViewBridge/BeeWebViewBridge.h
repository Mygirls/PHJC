//
//  BeeWebViewBridge.h
//  BeeEnrichmentAppiOS
//
//  Created by renpan on 16/4/7.
//  Copyright © 2016年 didai. All rights reserved.
//

#import "WebViewJsBridge.h"

typedef void(^bridge_callback)(NSString* method, NSArray* params);

@interface BeeWebViewBridge : WebViewJsBridge
@property (nonatomic, strong) bridge_callback block_bridge_callback;
- (void)setBlock_bridge_callback:(bridge_callback)block_bridge_callback;
- (void)check_exist;
@end
