//
//  WMSementView.h
//  BeeEnrichmentAppiOS
//
//  Created by hwm on 16/10/12.
//  Copyright © 2016年 didai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WMSementView : UIView <UIScrollViewDelegate>

@property (nonatomic,strong)NSArray *nameArray;
@property (nonatomic,strong)NSArray *controllers;
@property (nonatomic,strong)UIView *segmentView;
@property (nonatomic,strong)UIScrollView *segmentScrollV;
@property (nonatomic,strong)UILabel *line;
@property (nonatomic ,strong)UIButton *seleBtn;
@property (nonatomic,strong)UILabel *down;
- (instancetype)initWithFrame:(CGRect)frame  controllers:(NSArray*)controllers titleArray:(NSArray*)titleArray ParentController:(UIViewController*)parentC index:(NSInteger)index;

@end
