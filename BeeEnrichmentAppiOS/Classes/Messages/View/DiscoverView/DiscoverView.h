//
//  DiscoverView.h
//  BeeEnrichmentAppiOS
//
//  Created by dll on 16/8/4.
//  Copyright © 2016年 didai. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ClickCellAction)(NSInteger index, NSDictionary *dic);
@interface DiscoverView : UIView
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, copy) ClickCellAction clickActionWithIndex;
@end
