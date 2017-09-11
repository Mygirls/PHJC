//
//  RecVersionTwoTableViewCell.m
//  BeeEnrichmentAppiOS
//
//  Created by dll on 16/8/1.
//  Copyright © 2016年 didai. All rights reserved.
//
#define kDegreesToRadians(degress) ((M_PI *degress)/180)


#import "RecVersionTwoTableViewCell.h"
//#import "LXWaveProgressView.h"
@interface RecVersionTwoTableViewCell()<CAAnimationDelegate>{
   
    UILabel * earningsLabel;

}
@property (weak, nonatomic) IBOutlet UILabel *rightStatusLable;
@property (weak, nonatomic) IBOutlet UIView *viewcont;
@property (strong, nonatomic) IBOutlet UILabel *yearRate;
@property (strong, nonatomic) IBOutlet UILabel *rateValue;
@property (strong, nonatomic) IBOutlet UILabel *addRate;
@property (strong, nonatomic) IBOutlet UILabel *minMoneyLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *classImageView;
@property (weak, nonatomic) IBOutlet UILabel *exclusiveLbl;
@property (weak, nonatomic) IBOutlet UIButton *shopButton;
@property (strong, nonatomic) IBOutlet UIView *waveView;
@property (weak, nonatomic) IBOutlet UIImageView *backimage;

@property (nonatomic,assign) CGFloat baifenbi;
@property (nonatomic,strong) NSMutableAttributedString * stringReta;

@end

@implementation RecVersionTwoTableViewCell

- (void)setWaveOfViewWithModel:(NSDictionary *)model
{
//    CGFloat rate = (1 - [model[@"remaining_amount"] doubleValue] / [model[@"financing_amount"]doubleValue]);
//    self.progressView.progress = [[NSString stringWithFormat:@"%.2f", rate] doubleValue];
//    _baifenbi = [[NSString stringWithFormat:@"%.2f", rate] doubleValue];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    self.shopButton.layer.cornerRadius = 2;
    self.shopButton.layer.borderWidth = 0;
    self.shopButton.layer.shadowOffset =  CGSizeMake(0, 1.5);
    self.shopButton.layer.shadowOpacity = 1;
    self.shopButton.layer.shadowColor =  [UIColor colorWithRed:249/255.0 green:95/255.0 blue:83/255.0 alpha:0.3].CGColor;

    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    float width = self.shopButton.bounds.size.width;
    float height = self.shopButton.bounds.size.height;
    float x = self.shopButton.bounds.origin.x;
    float y = self.shopButton.bounds.origin.y;
    float addWH = 5.3;
    
    CGPoint topLeft      = self.shopButton.bounds.origin;
    CGPoint topMiddle = CGPointMake(x+(width/2),y-addWH);
    CGPoint topRight     = CGPointMake(x+width,y);
    
    CGPoint rightMiddle = CGPointMake(x+width+addWH,y+(height/2));
    
    CGPoint bottomRight  = CGPointMake(x+width,y+height);
    CGPoint bottomMiddle = CGPointMake(x+(width/2),y+height+addWH);
    CGPoint bottomLeft   = CGPointMake(x,y+height);
    
    
    CGPoint leftMiddle = CGPointMake(x-addWH,y+(height/2));
    
    [path moveToPoint:topLeft];
    //添加四个二元曲线
    [path addQuadCurveToPoint:topRight
                 controlPoint:topMiddle];
    [path addQuadCurveToPoint:bottomRight
                 controlPoint:rightMiddle];
    [path addQuadCurveToPoint:bottomLeft
                 controlPoint:bottomMiddle];
    [path addQuadCurveToPoint:topLeft
                 controlPoint:leftMiddle];  
    //设置阴影路径  
    self.shopButton.layer.shadowPath = path.CGPath;
    
    
}
- (void)setModel:(ProductsDetailModel *)model
{
    _model = model;
    if (model != nil) {
        [self setWaveOfViewWithModel:(NSDictionary *)model];
        self.titleLabel.text = model.title;
        if (model.repaymentId == 200) {
            if (model.units == 1) {
                self.timeLabel.text = [NSString stringWithFormat:@"%zd天",model.Period];
            }else {
                self.timeLabel.text = [NSString stringWithFormat:@"%zd月",model.Period];
            }
        }else {
             if (model.units == 1) {
                 self.timeLabel.text = [NSString stringWithFormat:@"%zd天",model.Period];
             }else {
                 self.timeLabel.text = [NSString stringWithFormat:@"%zd月", model.Period];
             }
        }
        self.minMoneyLabel.text = [NSString stringWithFormat:@"%zd元",model.purchaseMinAmount];
        NSString *rate = [NSString stringWithFormat:@"%.2f",model.expectedAnnualRate];
        _stringReta = [[NSMutableAttributedString alloc]init];
        NSString *addLilvStr = [NSString stringWithFormat:@"%.2f",model.addAnnualRate];
        if (model.addAnnualRate == 0 || model.addAnnualRate) {
            if (kScreenWidth <=320) {
                NSMutableAttributedString *stringReta1 = [[NSMutableAttributedString alloc] initWithString:[CMCore clearZeroWithString:rate] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:40 weight:UIFontWeightThin]}];
                NSMutableAttributedString *stringReta2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%%"]  attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15 weight:UIFontWeightThin]}];
                [stringReta1 appendAttributedString:stringReta2];
                _stringReta =stringReta1 ;
            }else{
                NSMutableAttributedString *stringReta1 = [[NSMutableAttributedString alloc] initWithString:[CMCore clearZeroWithString:rate] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:61 weight:UIFontWeightThin]}];
                 NSMutableAttributedString *stringReta2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%%"]  attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19 weight:UIFontWeightThin]}];
                [stringReta1 appendAttributedString:stringReta2];

                _stringReta = stringReta1;
            }
        }else {
            if (kScreenWidth <=320) {
                NSMutableAttributedString *stringReta1 = [[NSMutableAttributedString alloc] initWithString:[CMCore clearZeroWithString:rate] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:40 weight:UIFontWeightThin]}];
                NSMutableAttributedString *stringReta2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%%+%@%%", [CMCore clearZeroWithString:addLilvStr]] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15 weight:UIFontWeightThin]}];
                [stringReta1 appendAttributedString:stringReta2];
                
                _stringReta=stringReta1;

            }else{
                NSMutableAttributedString *stringReta1 = [[NSMutableAttributedString alloc] initWithString:[CMCore clearZeroWithString:rate] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:61 weight:UIFontWeightThin]}];
                NSMutableAttributedString *stringReta2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%%+%@%%", [CMCore clearZeroWithString:addLilvStr]] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19 weight:UIFontWeightThin]}];
                [stringReta1 appendAttributedString:stringReta2];
                
                _stringReta=stringReta1;
                
            }

            
        }
        if (model.marketType == 30) {
            if (kScreenWidth <=320) {
                NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.2f",
                                                                                                     model.actualAnnualRate] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:40 weight:UIFontWeightThin]}];
                NSMutableAttributedString *str2 = [[NSMutableAttributedString alloc] initWithString:@"%" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15 weight:UIFontWeightThin]}];
                
                [str1 appendAttributedString:str2];
                _stringReta = str1;
                
            }else{
                NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",[CMCore clearZeroWithString:[NSString stringWithFormat:@"%.2f", model.actualAnnualRate]]] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:40 weight:UIFontWeightThin]}];
                NSMutableAttributedString *str2 = [[NSMutableAttributedString alloc] initWithString:@"%" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15 weight:UIFontWeightThin]}];
                
                [str1 appendAttributedString:str2];
                _stringReta = str1;
            }
            NSInteger subjectType = model.subjectType;
            NSInteger status = model.status;
            switch (status) {
                case 300:
                case 400:
                case 500:
                    //已售完300//计息中400//已兑付500
                    break;
                case 200:
                    
                    break;
                default:
                    //定期200
                    switch (subjectType) {
                        case 100:
                            //新人专享
                            _classImageView.image = [UIImage imageNamed:@"v1.7_newExclusive"];
                            _classImageView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-(_classImageView.frame.size.width+8.5),_classImageView.frame.origin.y, _classImageView.frame.size.width,_classImageView.frame.size.height);
                            break;
                        case 200:
                            //手机专享
                            _classImageView.image = [UIImage imageNamed:@"v1.7_phoneExclusive"];
                            _classImageView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-(_classImageView.frame.size.width+8.5),_classImageView.frame.origin.y, _classImageView.frame.size.width,_classImageView.frame.size.height);
                            break;
                        case 300:
                            //定向标
                            _classImageView.image = [UIImage imageNamed:@"V1.7_vipExclusive"];
                            _classImageView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-(_classImageView.frame.size.width+6),_classImageView.frame.origin.y, _classImageView.frame.size.width,_classImageView.frame.size.height);
                            break;
                        case 400:
                            
                            //普通标
                           
                            
                            break;
                        case 900:
                            if (status == 100) {
                                //预告标
                                _classImageView.image = [UIImage imageNamed:@"v1.7_trailer"];
                                _classImageView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-(_classImageView.frame.size.width-3),_classImageView.frame.origin.y, _classImageView.frame.size.width,_classImageView.frame.size.height);
                            }else {
                                _classImageView.image = [UIImage imageNamed:@"v1.7_newExclusive"];
                            }
                            
                            break;
                        default:
                           
                            break;
                    }
            }
            if (model.status != 100 && (model.marketType == 10 && model.isNewer)) {
                _classImageView.image = [UIImage imageNamed:@"v1.7_newExclusive"];
                _classImageView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-(_classImageView.frame.size.width+8.5),_classImageView.frame.origin.y, _classImageView.frame.size.width,_classImageView.frame.size.height);
            }
        
        }else{
        
            NSInteger subjectType = model.subjectType;
            NSInteger status = model.status;
            switch (status) {
                case 300:
                case 400:
                case 500:
                    //已售完300//计息中400//已兑付500
                    break;
                case 100:
                    //预告100

                    break;
                default:
                    //定期200
                    switch (subjectType) {
                        case 100:
                            //新人专享
                            _classImageView.image = [UIImage imageNamed:@"v1.7_newExclusive"];
                            _classImageView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-(_classImageView.frame.size.width+8.5),_classImageView.frame.origin.y, _classImageView.frame.size.width,_classImageView.frame.size.height);
                            break;
                        case 200:
                            //手机专享
                            _classImageView.image = [UIImage imageNamed:@"v1.7_phoneExclusive"];
                            _classImageView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-(_classImageView.frame.size.width+8.5),_classImageView.frame.origin.y, _classImageView.frame.size.width,_classImageView.frame.size.height);
                            break;
                        case 300:
                            //定向标
                            _classImageView.image = [UIImage imageNamed:@"V1.7_vipExclusive"];
                            _classImageView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-(_classImageView.frame.size.width+6),_classImageView.frame.origin.y, _classImageView.frame.size.width,_classImageView.frame.size.height);

                            break;
                        case 400:
                            
                            //普通标
                            
                            
                            break;
                        case 900:
                            if (status == 100) {
                                //预告标
                                _classImageView.image = [UIImage imageNamed:@"v1.7_trailer"];
                                _classImageView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-(_classImageView.frame.size.width-3),_classImageView.frame.origin.y, _classImageView.frame.size.width,_classImageView.frame.size.height);
                            }else {
                                _classImageView.image = [UIImage imageNamed:@"market_bee_plan_free"];
                            }
                            
                            break;
                        default:
                            
                            break;
                    }
            }
            if (model.status != 100 && (model.marketType == 10 && model.isNewer)) {
                _classImageView.image = [UIImage imageNamed:@"v1.7_newExclusive"];
                _classImageView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-(_classImageView.frame.size.width+8.5),_classImageView.frame.origin.y, _classImageView.frame.size.width,_classImageView.frame.size.height);
            }
            
            self.rightStatusLable.text = @"";
            if (model.marketType == 10 && status == 200) {
                if (model.isNewer == 1 && status != 100) {
                    //新人专享
                    _classImageView.image = [UIImage imageNamed:@"v1.7_newExclusive"];
                    _classImageView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-(_classImageView.frame.size.width+8.5),_classImageView.frame.origin.y, _classImageView.frame.size.width,_classImageView.frame.size.height);
                }else {
                    self.rightStatusLable.text = model.rightTopTitle;
                    _classImageView.image = [UIImage imageNamed:@"market_bee_plan_free"];
                    _classImageView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-(_classImageView.frame.size.width+8.5),_classImageView.frame.origin.y, _classImageView.frame.size.width,_classImageView.frame.size.height);
                }
            }
            
            

        }
    }

}

- (void)drawRect:(CGRect)rect {
    [self drawLine1];
}

- (void)drawLine1 {
    
//    CGFloat radius = kScreenWidth/375 * 100;// 半径
//        if (_baifenbi == 1) {
//     
//        _start = M_PI/100*0.001;
//
//    }else if((100-100*_baifenbi) == 100){
//        _start = M_PI/100*99.99;
//    
//    }else{
//     
//        _start =M_PI/100*(100-100*_baifenbi);
//    
//    }
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 100, kScreenWidth, kScreenHeight/667* 85)];
    [self addSubview:view];
//
//    
//    CGPoint center = CGPointMake(view.frame.size.width / 2, view.frame.size.height);
//    //半圆
//    UIBezierPath *bgpath2 = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:0 endAngle:kDegreesToRadians(180) clockwise:YES];
//    [[UIColor colorWithRed:225/255.0 green:225/255.0 blue:225/255.0 alpha:1] set];
//    [bgpath2 setLineWidth:1.5f];// 线宽
//    [bgpath2 setLineCapStyle:kCGLineCapRound];// line的圆角
//    [bgpath2 stroke];
//    
//    UIBezierPath *bgpath4 = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:0 endAngle:kDegreesToRadians(180) clockwise:YES];
//    [[UIColor colorWithRed:225/255.0 green:225/255.0 blue:225/255.0 alpha:0.1] set];
//    [bgpath4 setLineWidth:4.0f];// 线宽
//    [bgpath4 setLineCapStyle:kCGLineCapRound];// line的圆角
//    [bgpath4 stroke];
//    
//    
//    UIBezierPath * bgpath = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:kDegreesToRadians(180) endAngle:_start clockwise:NO];
//
//    CAShapeLayer* arcLayer = [CAShapeLayer layer];
//    arcLayer.path = bgpath.CGPath;
//    arcLayer.lineWidth = 1.5f;
//    arcLayer.frame = self.bounds;
//    arcLayer.lineCap = kCALineCapRound;
//    arcLayer.strokeColor = [UIColor colorWithHex:@"#F95F53"].CGColor;//可设置画笔颜色
//    arcLayer.fillColor = [UIColor clearColor].CGColor;
//    [self.layer addSublayer:arcLayer];
//   // [arcLayer addAnimation:[self keyframeAnimation:bgpath.CGPath] forKey:nil];
//
//    [self drawLineAnimation:arcLayer];
//    
//   
//    UIBezierPath *bgpath3 = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:_start endAngle:kDegreesToRadians(180) clockwise:YES];
//    [[UIColor colorWithRed:249/255.0 green:95/255.0 blue:83/255.0 alpha:0.1] set];
//    [bgpath3 setLineWidth:4.0f];// 线宽
//    [bgpath3 setLineCapStyle:kCGLineCapRound];// line的圆角
//    [bgpath3 stroke];
////小圆圈
//    if ((100-100*_baifenbi) >= 50) {
//        
//        CGFloat x = bgpath3.bounds.origin.x+ bgpath3.bounds.size.width-5;
//        CGFloat y = bgpath3.bounds.origin.y+bgpath3.bounds.size.height-5;
//        
//        UIView * view1 = [[UIView alloc]initWithFrame:CGRectMake(x, y, 10, 10)];
//        view1.backgroundColor = [UIColor colorWithRed:249/255.0 green:95/255.0 blue:83/255.0 alpha:0.3];
//        view1.layer.masksToBounds=YES;
//        view1.layer.cornerRadius=5;
//        [self addSubview:view1];
//        [view1.layer addAnimation:[self keyframeAnimation:bgpath.CGPath] forKey:nil];
//
//        CGFloat xx = bgpath3.bounds.origin.x+ bgpath3.bounds.size.width-2.5;
//        CGFloat yy = bgpath3.bounds.origin.y+bgpath3.bounds.size.height-2.5;
//        UIView * view2 = [[UIView alloc]initWithFrame:CGRectMake(xx, yy, 5, 5)];
//        view2.backgroundColor = [UIColor  colorWithRed:249/255.0 green:95/255.0 blue:83/255.0 alpha:1];
//        view2.layer.masksToBounds=YES;
//        view2.layer.cornerRadius=2.5;
//        [self addSubview:view2];
//        [view2.layer addAnimation:[self keyframeAnimation:bgpath.CGPath] forKey:nil];
//
//
//
//    }else if ((100-100*_baifenbi) < 50){
// 
//     
//        
//        if(_baifenbi == 1){
//            _start = M_PI/100*99.99;
//            
//        }else{
//            
//            _start =M_PI/100*(100*_baifenbi);
//            
//        }
//
//        UIBezierPath *bgpath10 = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:kDegreesToRadians(180) endAngle:_start clockwise:NO];
//        [[UIColor clearColor] set];
//        [bgpath10 setLineWidth:8.0f];// 线宽
//        [bgpath10 setLineCapStyle:kCGLineCapRound];// line的圆角
//        [bgpath10 stroke];
//
//        CGFloat x = bgpath3.bounds.origin.x+ bgpath3.bounds.size.width-5;
//        CGFloat y = bgpath10.bounds.origin.y+bgpath10.bounds.size.height-5;
//        
//        UIView * view1 = [[UIView alloc]initWithFrame:CGRectMake(x, y, 10, 10)];
//        view1.backgroundColor = [UIColor  colorWithRed:249/255.0 green:95/255.0 blue:83/255.0 alpha:0.3];
//        view1.layer.masksToBounds=YES;
//        view1.layer.cornerRadius=5.0;
//        [self addSubview:view1];
//       
//        [view1.layer addAnimation:[self keyframeAnimation:bgpath.CGPath] forKey:nil];
//        
//        CGFloat xx = bgpath3.bounds.origin.x+ bgpath3.bounds.size.width-2.5;
//        CGFloat yy = bgpath10.bounds.origin.y+bgpath10.bounds.size.height-2.5;
//        UIView * view2 = [[UIView alloc]initWithFrame:CGRectMake(xx, yy, 5, 5)];
//        view2.backgroundColor = [UIColor  colorWithRed:249/255.0 green:95/255.0 blue:83/255.0 alpha:1];
//        view2.layer.masksToBounds=YES;
//        view2.layer.cornerRadius=2.5;
//        [self addSubview:view2];
//        [view2.layer addAnimation:[self keyframeAnimation:bgpath.CGPath] forKey:nil];
//
//       
//
//    }
  
    
    
    earningsLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, -1, kScreenWidth, kScreenHeight/667* 50)];
    earningsLabel.attributedText = _stringReta;
    earningsLabel.textColor = [UIColor colorWithHex:@"#FD5353"];
  
    earningsLabel.textAlignment = 1;
    [view addSubview:earningsLabel];
    
   //阴影
//    _exclusiveLbl.layer.cornerRadius = 2;
//    _exclusiveLbl.clipsToBounds = YES;
    
    
    
    
//    CALayer *layer = [_investmentLbl layer];
//    layer.shadowOffset = CGSizeMake(0, 1.5);
//    layer.shadowRadius = 0.2;
//    layer.shadowColor = [UIColor colorWithHex:@"#F95F53"].CGColor;
//    layer.shadowOpacity = 0.3;
}
//动画
//-(CAKeyframeAnimation *)keyframeAnimation:(CGPathRef)path
//{
//    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
//    animation.path = path;
//    animation.delegate = self;
//    animation.duration = 0.5;
//    animation.repeatCount = 1;
//    return animation;
//}
//- (void)drawLineAnimation:(CALayer*)layer {
//
//    CABasicAnimation *bas = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
//    bas.duration = 0.5;
//    bas.delegate = self;
//    bas.fromValue = [NSNumber numberWithInteger:0];
//    bas.toValue = [NSNumber numberWithInteger:1];
//    bas.speed = 1.5;
//
//    bas.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
//    [layer addAnimation:bas forKey:@"key"];
//}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
