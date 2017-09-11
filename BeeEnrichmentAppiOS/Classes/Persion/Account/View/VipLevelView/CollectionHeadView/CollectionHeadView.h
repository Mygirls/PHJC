//
//  CollectionHeadView.h
//  BeeEnrichmentAppiOS
//
//  Created by dll on 16/6/28.
//  Copyright © 2016年 didai. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CollectionHeadViewBlock)();
@interface CollectionHeadView : UICollectionReusableView
@property (strong, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIButton *investmentBtn;
@property (nonatomic, assign) CollectionHeadViewBlock clickCollectionHeadViewBtnBlock;
@end
