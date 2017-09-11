//
//  Tpye_PayCellTableViewCell.h
//  BeeEnrichmentAppiOS
//
//  Created by dll on 17/3/6.
//  Copyright © 2017年 DuLonglong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Tpye_PayCellTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIButton *isChoicedButton;
@property (nonatomic, strong) UIButton *isSelectedButton, *controlButton;
@property (strong, nonatomic) IBOutlet UILabel *titileLabel;
@property (strong, nonatomic) IBOutlet UILabel *moneyLabel;

@end
