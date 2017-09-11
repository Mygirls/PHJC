//
//  SetupViewController.h
//  BeeEnrichmentAppiOS
//
//  Created by dll on 16/8/3.
//  Copyright © 2016年 didai. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^QuitAcion)();
@interface SetupViewController : JPViewController
@property (nonatomic, copy) QuitAcion quitApp;
@end
