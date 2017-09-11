//
//  BankCardCell.h
//  BeeEnrichmentAppiOS
//
//  Created by dll on 15/12/27.
//  Copyright © 2015年 didai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BankCardCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *title;
@property (strong, nonatomic) IBOutlet UIImageView *logo_imgView;
@property (strong, nonatomic) IBOutlet UILabel *bank_card;
@property (strong, nonatomic) IBOutlet UILabel *one_money;
@property (strong, nonatomic) IBOutlet UILabel *day_money;
@property (strong, nonatomic) IBOutlet UILabel *month_money;
@property (strong, nonatomic) IBOutlet UILabel *card_description;
@property (strong, nonatomic) IBOutlet UIView *back_view;
@property (strong, nonatomic) IBOutlet UILabel *bank_type;
@property (nonatomic, strong) BankCardsModel *model, *bank_basic_info;
@end
