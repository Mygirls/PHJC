//
//  VipCollectionCell.m
//  BeeEnrichmentAppiOS
//
//  Created by dll on 16/6/28.
//  Copyright © 2016年 didai. All rights reserved.
//

#import "VipCollectionCell.h"


@interface VipCollectionCell ()
@property (strong, nonatomic) IBOutlet UIImageView *imgView;
@property (strong, nonatomic) IBOutlet UILabel *label;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bottom;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *trailing;


@end
@implementation VipCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    CGFloat f = 0.0;
    _trailing.constant = f;
    _bottom.constant = f;
    if (kScreenHeight<=568) {
        _label.font = [UIFont systemFontOfSize:12];
    }
    
    // Initialization code
}
- (void)setCellWithImgUrl:(NSString*)imgUrl title:(NSString*)title {
    [_imgView sd_setImageWithURL:[NSURL URLWithString:imgUrl]];
    _label.text = title;
}

@end
