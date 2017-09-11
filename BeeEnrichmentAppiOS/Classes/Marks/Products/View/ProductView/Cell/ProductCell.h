//
//  ProductCell.h
//  BeeEnrichmentAppiOS
//
//  Created by dll on 15/12/23.
//  Copyright © 2015年 didai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *title;
@property (strong, nonatomic) IBOutlet UILabel *lilv_year;
@property (strong, nonatomic) IBOutlet UILabel *time_limit;
@property (strong, nonatomic) IBOutlet UILabel *qixian;
@property (strong,nonatomic) ProductsDetailModel *model;
@property (weak, nonatomic) IBOutlet UILabel *starsType;


@end
