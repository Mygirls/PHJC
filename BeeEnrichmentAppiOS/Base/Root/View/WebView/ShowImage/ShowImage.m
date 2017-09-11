//
//  ShowImage.m
//  BeeEnrichmentAppiOS
//
//  Created by dll on 16/5/9.
//  Copyright © 2016年 didai. All rights reserved.
//

#import "ShowImage.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface ShowImage ()
@property (strong, nonatomic) IBOutlet UILabel *title;
@property (strong, nonatomic) IBOutlet UIImageView *showImageView;
@property (nonatomic, assign) CGPoint beginPoint;
@property (nonatomic, copy) NSString *image_url;
@end
@implementation ShowImage

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)awakeFromNib
{    [super awakeFromNib];

    self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(scale_imageView:)];
    [self.showImageView addGestureRecognizer:pinchGesture];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [self.showImageView addGestureRecognizer:tap];
}
- (void)showInView:(UIView*)view iamge_ulr:(NSString *)image_url title:(NSString *)title;
{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self];
    self.title.text = title;
    _image_url = image_url;
    self.transform = CGAffineTransformMakeScale(0.01f, 0.01f);
    self.alpha = 0.0;
    [UIView animateWithDuration:0.25f animations:^{
        self.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
        self.alpha = 1.0;
    }completion:^(BOOL finished) {
        if (_image_url.length > 0) {
            [_showImageView sd_setImageWithURL:[NSURL URLWithString:_image_url] placeholderImage:[UIImage imageNamed:@""] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                if (!error) {
                    _showImageView.image = image;
                }
            }];
        }
    }];
}
- (void)dismiss {
    [UIView animateWithDuration:0.25f animations:^{
        self.transform = CGAffineTransformMakeScale(0.01f, 0.01f);
        self.alpha = 0;
    }completion:^(BOOL finished) {
        if(finished)
        {
            [self removeFromSuperview];
        }
    }];
}

- (void)scale_imageView:(UIPinchGestureRecognizer *)pinchGesture {
    if (pinchGesture.scale > 1 || _showImageView.frame.size.width > kScreenWidth) {
        pinchGesture.view.transform = CGAffineTransformScale(pinchGesture.view.transform, pinchGesture.scale, pinchGesture.scale);
    }
    pinchGesture.scale = 1;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSArray *touchesary = [[event allTouches] allObjects];
    if (touchesary.count == 1) {
        //单指移动
        self.beginPoint = [touchesary[0] locationInView:_showImageView];
    }
}
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSArray *touchesary = [[event allTouches] allObjects];
    if (touchesary.count == 1) {
        //单指移动
        CGPoint temPoint = [touchesary[0] locationInView:_showImageView];
        float dx = temPoint.x - self.beginPoint.x;
        float dy = temPoint.y - self.beginPoint.y;
        CGPoint newCenter = CGPointMake(_showImageView.center.x + dx, _showImageView.center.y + dy);
        _showImageView.center = newCenter;
    }
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSArray *touchesary = [[event allTouches] allObjects];
    CGFloat x = _showImageView.frame.origin.x;
    CGFloat y = _showImageView.frame.origin.y;
    CGFloat width = _showImageView.frame.size.width;
    CGFloat height = _showImageView.frame.size.height;
    if (touchesary.count == 1) {
        if (x > 0) {
            x = 0;
        }else
            if (x + width < kScreenWidth) {
                x = -(width - kScreenWidth);
            }
        if (y > 64) {
            y = 64;
        }else
            if (y + height < (kScreenHeight)) {
                y = -(height - (kScreenHeight));
            }
        _showImageView.frame = CGRectMake(x, y, width, height);
        
    }
}
@end
