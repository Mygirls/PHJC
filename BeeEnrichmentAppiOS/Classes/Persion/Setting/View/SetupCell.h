//
//  SetupCell.h
//  BeeEnrichmentAppiOS
//
//  Created by dll on 16/8/3.
//  Copyright © 2016年 didai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetupCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *headImageView;
@property (strong, nonatomic) IBOutlet UIImageView *hotMarkImageView;
@property (strong, nonatomic) IBOutlet UIImageView *arrowImageView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *detailLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *detailContraint;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageLeftContraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLableLeftContraint;

@end
