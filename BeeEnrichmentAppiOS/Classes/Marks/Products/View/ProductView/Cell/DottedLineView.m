//
//  DottedLineView.m
//  BeeEnrichmentAppiOS
//
//  Created by MC on 2016/11/4.
//  Copyright © 2016年 didai. All rights reserved.
//

#import "DottedLineView.h"

@implementation DottedLineView

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(currentContext, [UIColor colorWithHex:@"#E1E1E1"].CGColor);
    CGContextSetLineWidth(currentContext, 1);
    CGContextMoveToPoint(currentContext, 0, 0);
    CGContextAddLineToPoint(currentContext, self.frame.origin.x + self.frame.size.width, 0);
    CGFloat arr[] = {3,1};
    CGContextSetLineDash(currentContext, 0, arr, 2);
    CGContextDrawPath(currentContext, kCGPathStroke);
}



@end
