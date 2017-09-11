//
//  DetailOfSectionView.m
//  BeeEnrichmentAppiOS
//
//  Created by dll on 16/11/2.
//  Copyright © 2016年 didai. All rights reserved.
//

#import "DetailOfSectionView.h"

@implementation DetailOfSectionView

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.markLabel.clipsToBounds = YES;
}

- (IBAction)clickDetail:(id)sender {

    self.detailPG.hidden = NO;
    self.recordPG.hidden = YES;
    self.safePG.hidden = YES;
    
    self.detailBtn.selected = YES;
    self.recordBtn.selected = NO;
    self.safeBtn.selected = NO;
    

    self.DetailOfSectionViewBlockClick(DetailOfSectionViewTypeDetail);
}

- (IBAction)clickRecord:(id)sender {

    self.detailPG.hidden = YES;
    self.recordPG.hidden = NO;
    self.safePG.hidden = YES;
    
    self.detailBtn.selected = NO;
    self.recordBtn.selected = YES;
    self.safeBtn.selected = NO;
    self.markLabel.hidden = YES;
   
    self.DetailOfSectionViewBlockClick(DetailOfSectionViewTypeRecord);
}

- (IBAction)clickSafe:(id)sender {

    self.detailPG.hidden = YES;
    self.recordPG.hidden = YES;
    self.safePG.hidden = NO;
    
    self.detailBtn.selected = NO;
    self.recordBtn.selected = NO;
    self.safeBtn.selected = YES;
    
    self.DetailOfSectionViewBlockClick(DetailOfSectionViewTypeSafe);
}


@end
