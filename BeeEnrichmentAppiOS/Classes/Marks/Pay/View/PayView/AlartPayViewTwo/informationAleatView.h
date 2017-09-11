//
//  informationAleatView.h
//  BeeEnrichmentAppiOS
//
//  Created by MC on 2016/11/15.
//  Copyright © 2016年 didai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface informationAleatView : UIView

@property (nonatomic, strong) UIImage * iconImage;

@property (nonatomic, copy) NSString    *title;

+ (instancetype)alertViewDefault;
- (void)show;
-(void)remove;
@end
