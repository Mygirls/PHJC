//
//  VerifyViewController.h
//  BeeEnrichmentAppiOS
//
//  Created by dll on 2017/7/9.
//  Copyright © 2017年 DuLonglong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JPViewController.h"

@interface VerifyViewController : JPViewController
@property (nonatomic, strong) NSDictionary *memberDic;
@property (nonatomic, strong) NSString *memberName;
@property (strong, nonatomic) IBOutlet UILabel *contentLabel;

@end
