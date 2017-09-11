//
//  MyAccountVersionTwoCell.h
//  BeeEnrichmentAppiOS
//
//  Created by dll on 16/8/3.
//  Copyright © 2016年 didai. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ClickCollectionItem)(NSInteger index);

@interface MyAccountVersionTwoCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIView *backOfCollectionView;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, copy) ClickCollectionItem clickItem;
@end
