//
//  ShareView.h
//  BeeEnrichmentAppiOS
//
//  Created by hwm on 16/11/10.
//  Copyright © 2016年 didai. All rights reserved.
//

#import <UIKit/UIKit.h>



typedef NS_ENUM(NSInteger, ShareViewType){
    ShareViewTypeWeibo,
    ShareViewTypeQQ,
    ShareViewTypeWeChat,
    ShareViewTypeMessage,
    ShareViewTypeCancle
};

typedef void(^shareViewBlock)(ShareViewType);

@interface ShareView : UIView
- (void)show;
- (void)hidden;


@property (nonatomic, strong) shareViewBlock clickShareBlock;


@end
