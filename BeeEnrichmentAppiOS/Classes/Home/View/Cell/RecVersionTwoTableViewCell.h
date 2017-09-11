//
//  RecVersionTwoTableViewCell.h
//  BeeEnrichmentAppiOS
//
//  Created by dll on 16/8/1.
//  Copyright © 2016年 didai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecVersionTwoTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *buyImageView;
@property (nonatomic, assign) CGFloat start;
@property (strong, nonatomic) ProductsDetailModel *model;

@end
