//
//  UITableViewCell+JPTableView.h
//  ShiHang
//
//  Created by renpan on 14/10/25.
//  Copyright (c) 2014年 xizhe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableViewCell (JPTableView)
- (void)init_cell;
- (void)reuse_init_cell;
- (void)set_data:(id)data;
+ (CGFloat)my_height_with_data:(id)data;
@end

@interface UITableViewHeaderFooterView (JPTableView)
- (void)init_cell;
- (void)reuse_init_cell;
- (void)set_data:(id)data;
+ (CGFloat)my_height;
@end

@interface JPTableViewCell : UITableViewCell
@property (nonatomic, assign) NSInteger section;
@property (nonatomic, assign) NSInteger row;
@end