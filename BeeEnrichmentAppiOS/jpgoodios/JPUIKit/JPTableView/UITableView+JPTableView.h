//
//  UITableView+JPTableView.h
//  ShiHang
//
//  Created by renpan on 14/10/25.
//  Copyright (c) 2014年 xizhe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (JPTableView)
- (id)load_reuseable_cell_with_class:(Class)_class;
- (id)load_reuseable_cell_from_nib_with_class:(Class)_class;
- (id)load_reuseable_cell_with_style:(UITableViewCellStyle)style _class:(Class)_class;

- (id)load_reuseable_header_footer_view_with_class:(Class)_class;
- (id)load_reuseable_header_footer_view_from_nib_with_class:(Class)_class;

@end
