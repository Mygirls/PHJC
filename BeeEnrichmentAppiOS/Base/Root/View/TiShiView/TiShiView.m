//
//  TiShiView.m
//  BeeCarLoan
//
//  Created by dll on 15/10/10.
//  Copyright © 2015年 didai. All rights reserved.
//

#import "TiShiView.h"

@implementation TiShiView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self set_subViews];
        
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame {
    self  = [super initWithFrame:frame];
    if (self) {
        [self set_subViews];
    }
    return self;
}
- (void)set_subViews {
    self.line_view = [[UIImageView alloc] initWithFrame:CGRectMake(20, self.frame.size.height / 2 - 7, 3, 14)];
    self.line_view.image = [UIImage imageNamed:@"v1_line_blue"];
    self.ti_shi_info_label = [[UILabel alloc] initWithFrame:CGRectMake(30, 5, self.frame.size.width - 10, self.frame.size.height - 10)];
    self.ti_shi_info_label.textColor = [UIColor lightGrayColor];
    self.ti_shi_info_label.font = [UIFont systemFontOfSize:13];
    [self addSubview:self.line_view];
    [self addSubview:self.ti_shi_info_label];
}
@end
