//
//  mistakeView.h
//  BeeEnrichmentAppiOS
//
//  Created by MC on 16/10/13.
//  Copyright © 2016年 didai. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface mistakeView : UIView

@property (nonatomic, strong) UIImage * iconImage;
@property (nonatomic, copy) NSString *title;
+ (instancetype)alertViewDefault;
- (void)show;
- (void)remove;

@end
