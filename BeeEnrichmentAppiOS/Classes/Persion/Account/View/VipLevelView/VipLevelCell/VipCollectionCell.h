//
//  VipCollectionCell.h
//  BeeEnrichmentAppiOS
//
//  Created by dll on 16/6/28.
//  Copyright © 2016年 didai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VipCollectionCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIView *contentCellView;
- (void)setCellWithImgUrl:(NSString*)imgUrl title:(NSString*)title ;
@end
