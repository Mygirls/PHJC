//
//  StationViewCell.m
//  BeeEnrichmentAppiOS
//
//  Created by hwm on 16/11/2.
//  Copyright © 2016年 didai. All rights reserved.
//

#import "StationViewCell.h"

@interface StationViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *contentText_lable;
@property (weak, nonatomic) IBOutlet UILabel *timeLable;
@property (weak, nonatomic) IBOutlet UILabel *titleLable;

@end

@implementation StationViewCell

- (void)setModel:(MessagesModel *)model {
    _model = model;
    if (model != nil) {
        _titleLable.text = model.title == nil ? @"" :  model.title;
        NSString *text = model.detail == nil ? @"" :  model.detail;
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:text];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        [paragraphStyle setLineSpacing:8.5];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, text.length)];
        self.contentText_lable.attributedText = attributedString;
        _timeLable.text = [CMCore turnToDate:model.createTime];
        
    }
}

@end
