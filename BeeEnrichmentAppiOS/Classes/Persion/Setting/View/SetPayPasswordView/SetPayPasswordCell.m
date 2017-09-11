//
//  SetPayPasswordCell.m
//  BeeEnrichmentAppiOS
//
//  Created by hwm on 16/11/14.
//  Copyright © 2016年 didai. All rights reserved.
//

#import "SetPayPasswordCell.h"

@implementation SetPayPasswordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (IBAction)clickBtn:(id)sender {
    if (self.SetPayPasswordCellClickBtn) {
        _SetPayPasswordCellClickBtn();
    }
}


@end
