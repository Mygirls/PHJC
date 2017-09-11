//
//  TableHeaderView.h
//  BeeEnrichmentAppiOS
//
//  Created by dll on 16/8/1.
//  Copyright © 2016年 didai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDCycleScrollView.h"
#import "CCPScrollView.h"
@interface TableHeaderView : UIView
@property (strong, nonatomic) IBOutlet SDCycleScrollView *cycleView;
@property (strong, nonatomic) IBOutlet UIView *btnBackView;
@property (strong, nonatomic) IBOutlet UIView *headerViewZero;
@property (strong, nonatomic) IBOutlet UIView *headerViewOne;
@property (strong, nonatomic) IBOutlet UIView *headerViewTwo;
@property (strong, nonatomic) IBOutlet UIView *headerViewThree;
@property (strong, nonatomic) IBOutlet UIImageView *viewZero_of_imageZero;
@property (strong, nonatomic) IBOutlet UILabel *viewZero_of_labelZero;
@property (strong, nonatomic) IBOutlet UIImageView *viewOne_of_imageOne;
@property (strong, nonatomic) IBOutlet UILabel *viewOne_of_labelOne;
@property (strong, nonatomic) IBOutlet UIImageView *viewTwo_of_imageTwo;
@property (strong, nonatomic) IBOutlet UILabel *viewTwo_of_labelTwo;
@property (strong, nonatomic) IBOutlet UIImageView *viewThree_of_imageThree;
@property (strong, nonatomic) IBOutlet UILabel *viewThree_of_labelThree;
@property (strong, nonatomic) IBOutlet UIImageView *everydayRecImageView;
@property (weak, nonatomic) IBOutlet UIButton *twoBtn;
@property (weak, nonatomic) IBOutlet UIButton *zeroBtn;
@property (weak, nonatomic) IBOutlet UIButton *OneBtn;
@property (weak, nonatomic) IBOutlet UIButton *threeBtn;
@property (weak, nonatomic) IBOutlet UIButton *moreBtn;
@property (weak, nonatomic) IBOutlet UIView *backView;

@end
