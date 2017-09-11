//
//  DetailSimpleCell.h
//  BeeEnrichmentAppiOS
//
//  Created by dll on 16/11/2.
//  Copyright © 2016年 didai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailSimCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *title;
@property (strong, nonatomic) IBOutlet UILabel *content;
//@property (strong, nonatomic) IBOutlet UIView *lineOfDownView;
@property (strong, nonatomic) IBOutlet UIView *downLine;

@end
