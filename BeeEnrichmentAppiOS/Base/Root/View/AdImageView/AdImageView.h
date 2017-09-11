//
//  AdImageView.h
//  BeeEnrichmentAppiOS
//
//  Created by dll on 16/6/23.
//  Copyright © 2016年 didai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AdImageView : UIView
@property (strong, nonatomic) IBOutlet UIImageView *imageView;

- (void)showImgViewInWindow:(UIWindow *)keyWindow;
@end
