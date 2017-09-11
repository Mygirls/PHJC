//
//  MyWalletHeadCell.h
//  BeeEnrichmentAppiOS
//
//  Created by dll on 15/12/23.
//  Copyright © 2015年 didai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyWalletHeadCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *available_money;
@property (strong, nonatomic) IBOutlet UILabel *all_money;
@property (strong, nonatomic) IBOutlet UILabel *title;
@property (strong, nonatomic) IBOutlet UILabel *accessory_title;

@end
