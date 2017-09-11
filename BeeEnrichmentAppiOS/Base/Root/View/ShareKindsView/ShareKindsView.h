//
//  ShareKindsView.h
//  BeeEnrichmentAppiOS
//
//  Created by dll on 16/3/2.
//  Copyright © 2016年 didai. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^clickShareBlock)(NSInteger num);
typedef void(^clickCancelBlock)();


@interface ShareKindsView : UIView
@property (nonatomic, copy)clickCancelBlock clickCancelBlock;
@property (nonatomic, copy)clickShareBlock clickShareBlock;
- (void)show;
@end
