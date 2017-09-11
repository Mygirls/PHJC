//
//  ProductListOneCell.h
//  BeeEnrichmentAppiOS
//
//  Created by MC on 2016/11/4.
//  Copyright © 2016年 didai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductListOneCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *title;
@property (strong, nonatomic) IBOutlet UILabel *lilv_year;
@property (strong, nonatomic) IBOutlet UILabel *time_limit;
@property (weak, nonatomic) IBOutlet UIProgressView *ProgressView;
@property (weak, nonatomic) IBOutlet UILabel *remaining;
@property (weak, nonatomic) IBOutlet UILabel *percentage;

@property (strong,nonatomic) ProductsDetailModel *model;
@property (nonatomic,assign) float baifenbi;
@property (strong, nonatomic) IBOutlet UILabel *rightTopLabel;

@end
