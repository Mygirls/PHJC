//
//  CollectionHeadView.m
//  BeeEnrichmentAppiOS
//
//  Created by dll on 16/6/28.
//  Copyright © 2016年 didai. All rights reserved.
//

#import "CollectionHeadView.h"

@interface CollectionHeadView ()
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *top;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bottom;

@end
@implementation CollectionHeadView
- (IBAction)btnClick:(id)sender {
    
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
//    CGFloat f = 1;
//    _top.constant = f;
//    _bottom.constant = f;
    
    // Initialization code
    [self setBtnTitle];
}
- (void)setBtnTitle
{
    
    
    NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc] initWithString:@"去投资" attributes:@{NSForegroundColorAttributeName:[CMCore basic_color]}];
    NSTextAttachment *imgAttachment = [[NSTextAttachment alloc] init];
    imgAttachment.image = [UIImage imageNamed:@"v1_vip_collectionBottomImg"];
    imgAttachment.bounds = CGRectMake(2, 0, 10, 10);
    [str1 appendAttributedString:[NSAttributedString attributedStringWithAttachment:imgAttachment]];
    [_investmentBtn setAttributedTitle:str1 forState:UIControlStateNormal];
}

// 去投资
- (IBAction)clickGoInvestmentBtn:(id)sender {
//    if (self.clickCollectionHeadViewBtnBlock) {
//        self.clickCollectionHeadViewBtnBlock();
//    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"go_investment" object:nil];
}




@end
