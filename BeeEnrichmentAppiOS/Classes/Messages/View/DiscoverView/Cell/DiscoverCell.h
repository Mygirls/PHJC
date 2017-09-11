//
//  DiscoverCell.h
//  BeeEnrichmentAppiOS
//
//  Created by dll on 16/8/4.
//  Copyright © 2016年 didai. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MessagesModel;
@interface DiscoverCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *contentImageView;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UIView *bgView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *aspect;
@property (nonatomic, strong) MessagesModel *model;
@property (weak, nonatomic) IBOutlet UIView *downLineView;


@end
