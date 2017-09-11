//
//  CollectionFootView.h
//  BeeEnrichmentAppiOS
//
//  Created by dll on 16/6/28.
//  Copyright © 2016年 didai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyVipHeadView.h"

typedef void(^ShareBlock)();
typedef void(^ShareBlockweixin)();


@interface CollectionFootView : UICollectionReusableView
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (strong, nonatomic) IBOutlet UIButton *btn;
@property (strong, nonatomic) IBOutlet UILabel *tishiLabel;

@property (nonatomic, strong)ShareBlock myBlock;
@property (nonatomic, strong)ShareBlockweixin weixinBlock;
@property (nonatomic, strong)ShareBlock smsBlock;

@end
