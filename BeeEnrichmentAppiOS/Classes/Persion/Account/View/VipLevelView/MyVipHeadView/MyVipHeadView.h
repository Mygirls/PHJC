//
//  MyVipHeadView.h
//  BeeEnrichmentAppiOS
//
//  Created by dll on 16/6/24.
//  Copyright © 2016年 didai. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^DidSelectedNumBlock)(NSInteger didSelectNum);
typedef void(^ImageBlock)(UIImage * image);

@interface MyVipHeadView : UIView

- (void)setNumCount:(NSInteger)numCount alreadyNum:(NSInteger)alreadyNum progress:(CGFloat)progress;
@property (nonatomic, copy)DidSelectedNumBlock didSelectedNumBlock;
@property (strong, nonatomic) IBOutlet UIImageView *imgView;
@property (nonatomic, copy)ImageBlock imageBlock;
@property (copy, nonatomic) NSString *qrcode_image_url;

- (void)setMiddleLabelWithMoney:(NSString *)money bottomLabelWithMoney:(NSString*)bottomMoney;
@end
