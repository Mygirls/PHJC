//
//  JPNibLoad.m
//  ShiHang
//
//  Created by renpan on 14/10/20.
//  Copyright (c) 2014年 xizhe. All rights reserved.
//

#import "JPNibLoad.h"

@implementation JPNibLoad

+ (id)load_with_name:(NSString*)name index:(NSInteger)index
{
    NSArray* objects = [[NSBundle mainBundle] loadNibNamed:name owner:self options:nil];
    return [objects objectAtIndex:index];
}

+ (id)load_first_with_name:(NSString *)name
{
    NSArray* objects = [[NSBundle mainBundle] loadNibNamed:name owner:self options:nil];
    return [objects lastObject];
}

+ (id)load_from_storyboard_with_storyboard_name:(NSString*)name storyboard_id:(NSString*)sb_id
{
    id controller = [[UIStoryboard storyboardWithName:name bundle:nil]instantiateViewControllerWithIdentifier:sb_id];
    return controller;
}
@end

@implementation UIViewController (JPNibLoad)
+ (id)load_nib
{
    NSString* selfName = [NSString stringWithUTF8String:object_getClassName(self)];
    NSLog(@"%@",selfName);
    id object = [JPNibLoad load_first_with_name:selfName];
    return object;
}

- (id)init_with_own_name_nib
{
    NSString* selfName = [NSString stringWithUTF8String:object_getClassName(self)];
    NSLog(@"%@",selfName);
    self = [self initWithNibName:selfName bundle:[NSBundle mainBundle]];
    if(self)
    {
        
    }
    return self;
}

- (id)load_from_own_storyboard_with_storyboard_id:(NSString*)sb_id
{
    return [self.storyboard instantiateViewControllerWithIdentifier:sb_id];
}

@end

@implementation UIView (JPNibLoad)
+ (id)load_nib
{
    NSString* selfName = [NSString stringWithUTF8String:object_getClassName(self)];
    id object = [JPNibLoad load_first_with_name:selfName];
    return object;
}
@end
