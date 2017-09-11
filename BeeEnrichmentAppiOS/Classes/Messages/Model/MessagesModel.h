//
//  MessagesModel.h
//  BeeEnrichmentAppiOS
//
//  Created by hwm on 2017/6/27.
//  Copyright © 2017年 DuLonglong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessagesModel : NSObject

@property (nonatomic, assign) NSInteger articleTypeId;
@property (nonatomic, strong) NSString *author;
@property (nonatomic, strong) NSString *body;
@property (nonatomic, strong) NSString *Description;
@property (nonatomic, strong) NSString *disabled;
@property (nonatomic, strong) NSString *ID;
@property (nonatomic, assign) NSInteger sortIndex;
@property (nonatomic, assign) NSInteger source;
@property (nonatomic, strong) NSString *updateTime;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, strong) NSString *createTime;
@property (nonatomic, assign) NSInteger entryType;
// 内容
@property (nonatomic, strong) NSString *detail;


@end
