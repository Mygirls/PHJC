//
//  SettingModel.h
//  BeeEnrichmentAppiOS
//
//  Created by hwm on 2017/6/27.
//  Copyright © 2017年 DuLonglong. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AboutAppModel;
@interface SettingModel : NSObject



@end

@interface AboutAppModel : NSObject

@property (nonatomic, strong) NSString *companyUrl;
@property (nonatomic, strong) NSString *customerEmail;
@property (nonatomic, strong) NSString *introUrl;
@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *version;
@property (nonatomic, strong) NSString *wechatId;
@property (nonatomic, strong) NSString *weiboId;

@end
