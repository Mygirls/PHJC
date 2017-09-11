//
//  JPView.h
//  ShiHang
//
//  Created by renpan on 14/10/20.
//  Copyright (c) 2014年 xizhe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JPView : UIView
- (void)init_ui;
- (void)init_customize;
@end

@interface UIView (JPView)
- (CGFloat)my_width;
- (CGFloat)my_height;
- (id)copy_view;
@end

