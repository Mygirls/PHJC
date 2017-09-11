//
//  BasePageControl.m
//  BeeEnrichmentAppiOS
//
//  Created by dll on 2017/6/21.
//  Copyright © 2017年 DuLonglong. All rights reserved.
//

#import "BasePageControl.h"

@implementation BasePageControl

-(id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    _activeImage = [UIImage imageNamed:@"page_control_icon_red"];
    _inactiveImage = [UIImage imageNamed:@"page_control_icon_gray"] ;
    
    return self;
}

-(void) updateDots
{
    for (int i = 0; i < [self.subviews count]; i++)
    {
        UIImageView *dot = [[UIImageView alloc] init];
        
        
        CGSize size;
        
        size.height = 3;     //自定义圆点的大小
        
        size.width = 10;      //自定义圆点的大小
        [dot setFrame:CGRectMake(dot.frame.origin.x, dot.frame.origin.y, size.width, size.height)];
        
        [[self.subviews objectAtIndex:i] addSubview:dot];
        if (i == self.currentPage) {
            dot.image = _activeImage;
        } else {
            dot.image = _inactiveImage;
        }
    }
}

-(void) setCurrentPage:(NSInteger)page
{
    [super setCurrentPage:page];
//    //修改图标大小
//    for (NSUInteger subviewIndex = 0; subviewIndex < [self.subviews count]; subviewIndex++) {
//        
//        UIImageView* subview = [self.subviews objectAtIndex:subviewIndex];
//        
//        CGSize size;
//        
//        size.height = 3;
//        
//        size.width = 10;
//        
//        [subview setFrame:CGRectMake(subview.frame.origin.x, subview.frame.origin.y,
//                                     
//                                     size.width,size.height)];
//        
//    }
    
    
    [self updateDots];
}

@end
