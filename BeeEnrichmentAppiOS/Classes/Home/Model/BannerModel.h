//
//  BannerModel.h
//  BeeEnrichmentAppiOS
//
//  Created by hwm on 2017/6/27.
//  Copyright © 2017年 DuLonglong. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CarouselCustomListModel, MainMenuListModel;
@interface BannerModel : NSObject

@property (nonatomic, strong) NSMutableArray<CarouselCustomListModel *> *carouselCustomList;
@property (nonatomic, strong) NSMutableArray<MainMenuListModel *> *mainMenuList;

@end

@interface CarouselCustomListModel : NSObject

@property (nonatomic, assign) NSInteger bannerType;
@property (nonatomic, strong) NSString *createTime;
@property (nonatomic, assign) NSInteger entryType;
@property (nonatomic, strong) NSString *expiredTime;
@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, assign) NSInteger ID;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) NSString *marketType;
@property (nonatomic, strong) NSString *sizeProportion;
@property (nonatomic, strong) NSString *startTime;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *Value;

@end

@interface MainMenuListModel : NSObject

@property (nonatomic, strong) NSString *createTime;
@property (nonatomic, assign) NSInteger entryType;
@property (nonatomic, strong) NSURL *iconUrl;
@property (nonatomic, assign) NSInteger ID;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) NSString *marketType;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *Value;

@end
