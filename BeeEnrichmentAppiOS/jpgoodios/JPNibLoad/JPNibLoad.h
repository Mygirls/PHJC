//
//  JPNibLoad.h
//  ShiHang
//
//  Created by renpan on 14/10/20.
//  Copyright (c) 2014年 xizhe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSObject+JPNSObjectExtend.h"


@interface JPNibLoad : NSObject
+ (id)load_with_name:(NSString*)name index:(NSInteger)index;
+ (id)load_first_with_name:(NSString *)name;
+ (id)load_from_storyboard_with_storyboard_name:(NSString*)name storyboard_id:(NSString*)sb_id;
@end

@interface UIViewController (JPNibLoad)
+ (id)load_nib;
- (id)init_with_own_name_nib;
- (id)load_from_own_storyboard_with_storyboard_id:(NSString*)sb_id;
@end

@interface UIView (JPNibLoad)
+ (id)load_nib;
@end