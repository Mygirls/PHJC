//
//  StationViewController.h
//  BeeEnrichmentAppiOS
//
//  Created by MC on 16/9/21.
//  Copyright © 2016年 didai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StationViewController : UIViewController

@property (nonatomic, strong) UIView *segmentView;
@property (nonatomic, strong) NSMutableArray<MessagesModel *> *dataList;
@end
