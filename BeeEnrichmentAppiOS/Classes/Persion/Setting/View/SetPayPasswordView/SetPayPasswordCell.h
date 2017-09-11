//
//  SetPayPasswordCell.h
//  BeeEnrichmentAppiOS
//
//  Created by hwm on 16/11/14.
//  Copyright © 2016年 didai. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SetPayPasswordCellBlock)();
@interface SetPayPasswordCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *contentTextFile;
@property (weak, nonatomic) IBOutlet UILabel *titleLable;

@property (nonatomic, strong) SetPayPasswordCellBlock SetPayPasswordCellClickBtn;

@property (weak, nonatomic) IBOutlet UIButton *is_showmima_btn;

@end
