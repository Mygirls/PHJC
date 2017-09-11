//
//  isSetPaswordView.h
//  BeeEnrichmentAppiOS
//
//  Created by hwm on 17/1/12.
//  Copyright © 2017年 didai. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, isSetPaswordViewType) {
    isSetPaswordViewTypeCancle,
    isSetPaswordViewTypeSet
};

typedef void(^isSetPaswordViewBlock)(isSetPaswordViewType);

@interface isSetPaswordView : UIView

- (void)show;


@property (nonatomic, copy) isSetPaswordViewBlock isSetPaswordViewBlockClick;

@end
