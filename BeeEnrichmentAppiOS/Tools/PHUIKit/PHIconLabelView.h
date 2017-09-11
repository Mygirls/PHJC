//
//  PHIconLabelView.h
//  MajqFramework
//
//  Created by JQ on 2017/9/6.
//  Copyright © 2017年 majq. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    labelUp,
    lableRight,
    
} PHIconLabelViewType;

@interface PHIconLabelView : UIView

@property(nonatomic,copy) NSString *imgName;    //icon imgName
@property(nonatomic,copy) NSString *labelTitle; //label text
@property(nonatomic,strong) UIFont *font;   //label font


/**
 显示iconLabelView
 *
 *  @param type 类型
 *  @param iconSize 图标的size
 *  @param labelSize label 的size
 *  @param y 当type = labelUp时，icon 距离顶部的距离，当type= lableRight 无效
 *  @param m icon 与 label 的间距
 */

- (void)viewShow:(PHIconLabelViewType)type
        iconSize:(CGSize)iconSize
       labelSize:(CGSize)labelSize
              up:(CGFloat)y
          middle:(CGFloat)m;

@end
