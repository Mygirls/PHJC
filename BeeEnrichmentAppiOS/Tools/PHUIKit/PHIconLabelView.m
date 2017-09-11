//
//  PHIconLabelView.m
//  MajqFramework
//
//  Created by JQ on 2017/9/6.
//  Copyright © 2017年 majq. All rights reserved.
//

#import "PHIconLabelView.h"
#import "UIViewExt.h"
@interface PHIconLabelView ()

@property(nonatomic,strong)UILabel *label;
@property(nonatomic,strong)UIImageView *imgView;

@property(nonatomic,assign)CGSize imgSize;
@end


@implementation PHIconLabelView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.label];
        [self addSubview:self.imgView];
        
    }
    return self;
}

- (void)viewShow:(PHIconLabelViewType)type
        iconSize:(CGSize)iconSize
       labelSize:(CGSize)labelSize
              up:(CGFloat)y
          middle:(CGFloat)m
{
    
    
    switch (type) {
        case labelUp:
            if (iconSize.width >= self.width || labelSize.width >= self.width) {
                if (iconSize.width >= self.width) {
                    iconSize.width = self.width;
                }
                
                if (labelSize.width >= self.width) {
                    labelSize.width = self.width;
                }
            }
            
            if (y + iconSize.height + m + labelSize.height >= self.height) {
                
                CGFloat t = y + iconSize.height + m + labelSize.height;
                iconSize.height = iconSize.height / t * self.height;
                y = y / t * self.height;
                m = m / t * self.height;

            }
            
            self.imgView.frame = CGRectMake((self.width - iconSize.width) * 0.5, y, iconSize.width, iconSize.height);
            self.imgView.image = [UIImage imageNamed: self.imgName];
            
            self.label.frame = CGRectMake((self.width - labelSize.width) * 0.5, self.imgView.bottom + m, labelSize.width, labelSize.height);
            self.label.textAlignment = NSTextAlignmentCenter;
            
            break;
        
        case lableRight:
            if (iconSize.width + m + labelSize.width  >= self.width) {
                CGFloat t = iconSize.width + m + labelSize.width;
                CGFloat temIconWidth = iconSize.width;
                
                iconSize.width = iconSize.width/t * self.width;
                if (temIconWidth > iconSize.width) {
                    iconSize.height = iconSize.height * (iconSize.width / temIconWidth );
                }
                
                m = m/t * self.width;
                labelSize.width = labelSize.width/t * self.width;
            }
            
            if (iconSize.height >= self.height || labelSize.height >= self.height) {
                
                if (iconSize.height >= self.height) {
                    iconSize.height = self.height;
                }
                
                if (labelSize.height >= self.height) {
                    labelSize.height = self.height;
                }
            }
            
            self.imgView.frame = CGRectMake(0, (self.height - iconSize.height) * 0.5, iconSize.width  , iconSize.height);
            self.imgView.image = [UIImage imageNamed: self.imgName];
            
            self.label.frame = CGRectMake(self.imgView.right + m, (self.height - labelSize.height) * 0.5, labelSize.width, labelSize.height);
            self.label.textAlignment = NSTextAlignmentLeft;
            break;
    }
    
    self.label.text = self.labelTitle;

}



//MARK: - setUp Views
- (UILabel *)label
{
    if (_label == nil) {
        _label = [[UILabel alloc]initWithFrame:CGRectZero];
        _label.backgroundColor = [UIColor whiteColor];
    }
    
    return _label;
}


- (UIImageView *)imgView
{
    if (_imgView == nil) {
        _imgView = [[UIImageView alloc]initWithFrame:CGRectZero];
        _imgView.backgroundColor = [UIColor whiteColor];
    }
    
    return _imgView;
}

//MARK: - set 方法
- (void)setImgName:(NSString *)imgName
{
    _imgName = imgName;
    
    CGSize size = [UIImage imageNamed:imgName].size;
    self.imgSize = size;
    
}

- (void)setLabelTitle:(NSString *)labelTitle
{
    _labelTitle = labelTitle;
}

@end
