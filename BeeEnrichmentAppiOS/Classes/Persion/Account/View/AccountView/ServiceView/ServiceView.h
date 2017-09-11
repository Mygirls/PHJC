//
//  ServiceView.h
//  BeeEnrichmentAppiOS
//
//  Created by MC on 16/10/11.
//  Copyright © 2016年 didai. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ServiceView;

@protocol ServiceViewDelegate <NSObject>
@optional

- (void)alertView:(ServiceView *)alertView clickedCustomButtonAtIndex:(NSInteger)buttonIndex;


@end

@interface ServiceView : UIView
@property (weak, nonatomic) id <ServiceViewDelegate> delegate;

+ (instancetype)alertViewDefault;
- (void)show;
@end
