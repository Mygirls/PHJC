//
//  CollectionFootView.m
//  BeeEnrichmentAppiOS
//
//  Created by dll on 16/6/28.
//  Copyright © 2016年 didai. All rights reserved.
//

#import "CollectionFootView.h"
#import "QRCodeImage.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface CollectionFootView ()
@property (copy, nonatomic) NSString *qrcode_image_url;
@property (copy,nonatomic) UIImage *_headImage;
@end
@implementation CollectionFootView

- (void)awakeFromNib {
    [super awakeFromNib];
    //[self setBtnTitle];
    // Initialization code
}
- (void)setBtnTitle
{
    
//    
//    NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc] initWithString:@"去投资赚取更多特权" attributes:@{NSForegroundColorAttributeName:[CMCore basic_color]}];
//    NSTextAttachment *imgAttachment = [[NSTextAttachment alloc] init];
//    imgAttachment.image = [UIImage imageNamed:@"v1_vip_collectionBottomImg"];
//    imgAttachment.bounds = CGRectMake(2, 0, 10, 10);
//    [str1 appendAttributedString:[NSAttributedString attributedStringWithAttachment:imgAttachment]];
//    [_btn setAttributedTitle:str1 forState:UIControlStateNormal];
}
- (IBAction)clickBtnWeiXin:(id)sender {
    
    if (self.myBlock) {
        self.myBlock();
    }
    

}
- (IBAction)shareWeixinTwo:(id)sender {
    
    if (self.weixinBlock) {
        self.weixinBlock();
    }

}
- (IBAction)shareSms:(id)sender {
    
    if (self.smsBlock) {
        self.smsBlock();
    }
}

@end
