//
//  MartPagingView.h
//  BeeEnrichmentAppiOS
//
//  Created by MC on 2016/11/8.
//  Copyright © 2016年 didai. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface MartPagingView : UIView <UIScrollViewDelegate>

@property (nonatomic,strong)NSArray * nameArray;
@property (nonatomic,strong)NSArray *controllers;
@property (nonatomic,strong)UIView * segmentView;
@property (nonatomic,strong)UIScrollView * segmentScrollV;
@property (nonatomic,strong)UILabel * line;
@property (nonatomic ,strong)UIButton * seleBtn;
@property (nonatomic,strong)UILabel * down;
@property (nonatomic,assign)NSInteger typeClass;
- (void)Click:(UIButton*)sender;
- (instancetype)initWithFrame:(CGRect)frame  controllers:(NSArray*)controllers titleArray:(NSArray*)titleArray ParentController:(UIViewController*)parentC;
@end
