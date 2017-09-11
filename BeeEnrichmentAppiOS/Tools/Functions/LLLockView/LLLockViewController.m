//
//  LLLockViewController.m
//  LockSample
//
//  Created by Lugede on 14/11/11.
//  Copyright (c) 2014年 lugede.cn. All rights reserved.
//

#import "LLLockViewController.h"
#import "LLLockIndicator.h"
#import "LoginNavigationController.h"
#define kTipColorNormal [UIColor colorWithHex:@"#949494"]
#define kTipColorError [UIColor colorWithHex:@"#f95f53"]


@interface LLLockViewController () <CAAnimationDelegate>
{
    int nRetryTimesRemain; // 剩余几次输入机会
    
}

@property (weak, nonatomic) IBOutlet UIImageView *preSnapImageView; // 上一界面截图
@property (weak, nonatomic) IBOutlet UIImageView *currentSnapImageView; // 当前界面截图
@property (nonatomic, strong) IBOutlet LLLockIndicator* indecator; // 九点指示图
@property (nonatomic, strong) IBOutlet LLLockView* lockview; // 触摸田字控件

@property (strong, nonatomic) IBOutlet UILabel *tipLable;
@property (strong, nonatomic) IBOutlet UIButton *tipButton; // 重设/(取消)的提示按钮
@property (strong, nonatomic) IBOutlet UIButton *left_button;
@property (weak, nonatomic) IBOutlet UILabel *xingqi_lable;// 星期几
@property (weak, nonatomic) IBOutlet UILabel *timeNew_lable;// 时间new阳历
@property (weak, nonatomic) IBOutlet UILabel *timeOld_lable;//时间old阴历
@property (weak, nonatomic) IBOutlet UILabel *phoneNume_lable;// 欢迎 153****4050

@property (nonatomic, strong) NSString* savedPassword; // 本地存储的密码
@property (nonatomic, strong) NSString* passwordOld; // 旧密码
@property (nonatomic, strong) NSString* passwordNew; // 新密码
@property (nonatomic, strong) NSString* passwordconfirm; // 确认密码
@property (nonatomic, strong) NSString* tip1; // 三步提示语
@property (nonatomic, strong) NSString* tip2;
@property (nonatomic, strong) NSString* tip3;

@end


#define chineseYears @[@"甲子", @"乙丑", @"丙寅", @"丁卯",  @"戊辰",  @"己巳",  @"庚午",  @"辛未",  @"壬申",  @"癸酉",@"甲戌",   @"乙亥",  @"丙子",  @"丁丑", @"戊寅",   @"己卯",  @"庚辰",  @"辛己",  @"壬午",  @"癸未",@"甲申",   @"乙酉",  @"丙戌",  @"丁亥",  @"戊子",  @"己丑",  @"庚寅",  @"辛卯",  @"壬辰",  @"癸巳",@"甲午",   @"乙未",  @"丙申",  @"丁酉",  @"戊戌",  @"己亥",  @"庚子",  @"辛丑",  @"壬寅",  @"癸丑", @"甲辰",   @"乙巳",  @"丙午",  @"丁未",  @"戊申",  @"己酉",  @"庚戌",  @"辛亥",  @"壬子",  @"癸丑",@"甲寅",   @"乙卯",  @"丙辰",  @"丁巳",  @"戊午",  @"己未",  @"庚申",  @"辛酉",  @"壬戌",  @"癸亥"]
#define ChineseMonths @[@"正月", @"二月", @"三月", @"四月", @"五月", @"六月", @"七月", @"八月",@"九月", @"十月", @"冬月", @"腊月"]
#define ChineseDays @[@"初一", @"初二", @"初三", @"初四", @"初五", @"初六", @"初七", @"初八", @"初九", @"初十",@"十一", @"十二", @"十三", @"十四", @"十五", @"十六", @"十七", @"十八", @"十九", @"二十", @"廿一", @"廿二", @"廿三", @"廿四", @"廿五", @"廿六", @"廿七", @"廿八", @"廿九", @"三十"]
#define ChineseWeatherFestival @[@"立春",@"雨水",@"惊蛰",@"春分",@"清明",@"谷雨",@"立夏",@"小满",@"忙种",@"夏至",@"小暑",@"大暑",@"立秋",@"处暑",@"寒露",@"霜降",@"白露",@"秋分",@"立冬",@"小雪",@"大雪",@"冬至",@"小寒",@"大寒"]

@implementation LLLockViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (id)initWithType:(LLLockViewType)type
{
    self = [super init];
    if (self) {
        _nLockViewType = type;
    }
    return self;
}
- (IBAction)click_left_item:(id)sender {
    [CMCore setIs_ti_shi_set_gesture:NO];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //    self.view.backgroundColor = [UIColor whiteColor];
    self.indecator.backgroundColor = [UIColor clearColor];
    //    self.lockview.backgroundColor = [UIColor clearColor];
    
    //    self.horiScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 100, 320, 320)];
    
    self.lockview.delegate = self;
    
    NSString *str = [CMCore get_user_info_member][@"mobilePhone"];
    self.phoneNume_lable.text = [NSString stringWithFormat:@"欢迎  %@", [str stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"]];
    
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    [fmt setDateFormat:@"yyyy-MM-dd"];
    [fmt setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
    NSDate *date = [NSDate current];
    self.timeNew_lable.text = [fmt stringFromDate:date];
    
    _timeOld_lable.text = [self getChineseCalendarWithDate:date];
    
    _xingqi_lable.text = [self weekStringFromDate:date];
    
    LLLog(@"实例化了一个LockVC");
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)viewWillAppear:(BOOL)animated
{
#ifdef LLLockAnimationOn
    [self capturePreSnap];
#endif
    
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    // 初始化内容
    switch (_nLockViewType) {
        case LLLockViewTypeCheck:
        {
            [self.tipButton setTitle:@"忘记密码?" forState:UIControlStateNormal];
            [self.tipButton setAlpha:1.0];
            _tipLable.text = @"请输入解锁密码";
            _left_button.hidden = YES;
        }
            break;
        case LLLockViewTypeCreate:
        {
            _tipLable.text = @"设置手势密码";
        }
            break;
        case LLLockViewTypeModify:
        {
            [self.tipButton setTitle:@"忘记密码?" forState:UIControlStateNormal];
            [self.tipButton setAlpha:1.0];
            _tipLable.text = @"请输入原来的密码";
        }
            break;
        case LLLockViewTypeClean:
        default:
        {
            _tipLable.text = @"请输入密码以清除密码";
        }
    }
    
    // 尝试机会
    nRetryTimesRemain = LLLockRetryTimes;
    self.passwordOld = @"";
    self.passwordNew = @"";
    self.passwordconfirm = @"";
    
    // 本地保存的手势密码
    self.savedPassword = [LLLockPassword loadLockPassword];
    LLLog(@"本地保存的密码是%@", self.savedPassword);
    
    [self updateTipButtonStatus];
}
#pragma mark 当前东八区时间
- (void)getCurrentTime {
    
}


#pragma mark 获取星期
-(NSString * )weekStringFromDate:(NSDate *)date{
    
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    [fmt setDateFormat:@"EEEE"];
    [fmt setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
    NSString *str = [fmt stringFromDate:date];
    return [str substringWithRange:NSMakeRange(2, 1)];
}


#pragma mark 获取阴历
- (NSString*)getChineseCalendarWithDate:(NSDate *)date{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_CN"]];
    [inputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate* inputDate = [inputFormatter dateFromString:[formatter stringFromDate:[NSDate date]]];
    
    NSCalendar *localeCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
    
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond ;
    
    NSDateComponents *localeComp = [localeCalendar components:unitFlags fromDate:inputDate];
    
    NSLog(@"%ld_%ld_%ld  %@",(long)localeComp.year,(long)localeComp.month,(long)localeComp.day, localeComp.date);
    NSString *y_str = [chineseYears objectAtIndex:localeComp.year-1];
    NSString *m_str = [ChineseMonths objectAtIndex:localeComp.month-1];
    NSString *d_str = [ChineseDays objectAtIndex:localeComp.day-1];
    NSString *chineseCal_str =[NSString stringWithFormat: @"%@年%@%@",y_str,m_str,d_str];
    
    
    return chineseCal_str;
}

#pragma mark - 显示节日节气信息
// 获取date当天的农历
- (NSString *)chineseCalendarOfDate:(NSDate *)date {
    
    NSCalendar *chineseCalendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierChinese];
    NSDateComponents *components = [chineseCalendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];
    NSString *_day = @"";
    if (components.day ==1 ) {
        _day = ChineseMonths[components.month - 1];
    } else {
        _day = ChineseDays[components.day - 1];
    }
    //除夕另外提出放在所有节日的末尾执行，除夕是在春节前一天，即把components当天时间前移一天，放在所有节日末尾，避免其他节日全部前移一天
    NSTimeInterval timeInterval_day = 60 *60 * 24;
    NSDate *nextDay_date = [NSDate dateWithTimeInterval:timeInterval_day sinceDate:date];
    NSCalendar *localeCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |NSCalendarUnitDay;
    components = [localeCalendar components:unitFlags fromDate:nextDay_date];
    if ( 1 == components.month && 1 == components.day ) {
        return@"除夕";
    }
    return _day;
}


#pragma mark - 检查/更新密码
- (void)checkPassword:(NSString*)string
{
    // 验证密码正确
    if ([string isEqualToString:self.savedPassword]) {
        
        if (_nLockViewType == LLLockViewTypeModify) { // 验证旧密码
            [self.tipButton setTitle:@"忘记密码?" forState:UIControlStateNormal];
            [self.tipButton setAlpha:1.0];
            self.passwordOld = string; // 设置旧密码，说明是在修改
            
            [self setTip:@"请输入新的密码"]; // 这里和下面的delegate不一致，有空重构
            
        } else if (_nLockViewType == LLLockViewTypeClean) { // 清除密码
            
            [LLLockPassword saveLockPassword:nil];
            [self hide];
            
            [self showAlert:self.tip2];
            
        } else { // 验证成功
            
            [self hide];
        }
        
    }
    // 验证密码错误
    else if (string.length > 0) {
        
        nRetryTimesRemain--;
        
        if (nRetryTimesRemain > 0) {
            
            if (1 == nRetryTimesRemain) {
                [self setErrorTip:[NSString stringWithFormat:@"最后的机会咯-_-!"]
                        errorPswd:string];
            } else {
                [self setErrorTip:[NSString stringWithFormat:@"密码输入错误，还可以再输入%d次", nRetryTimesRemain]
                        errorPswd:string];
            }
            
        }
        else {
            
            // 强制注销该账户，并清除手势密码，以便重设
            [CMCore setIs_open_gesture_password:NO];
            [LLLockPassword saveLockPassword:nil];
            [CMCore logout];
            [self captureCurrentSnap];
            // 隐藏控件
            for (UIView* v in self.view.subviews) {
                if (v.tag > 10000) continue;
                v.hidden = YES;
            }
            //
            [self dismissViewControllerAnimated:NO completion:nil];
            
            // 由于是强制登录，这里必须以NO ani的方式才可
            
            
        }
        
    } else {
        NSAssert(YES, @"意外情况");
    }
}

- (void)createPassword:(NSString*)string
{
    // 输入密码
    if ([self.passwordNew isEqualToString:@""] && [self.passwordconfirm isEqualToString:@""]) {
        
        self.passwordNew = string;
        [self setTip:self.tip2];
    }
    // 确认输入密码
    else if (![self.passwordNew isEqualToString:@""] && [self.passwordconfirm isEqualToString:@""]) {
        
        self.passwordconfirm = string;
        
        if ([self.passwordNew isEqualToString:self.passwordconfirm]) {
            // 成功
            LLLog(@"两次密码一致");
            
            [LLLockPassword saveLockPassword:string];
            
            [self showAlert:self.tip3];
            // 解锁密码设置成功,就不再弹出设置手势密码的提示
            [CMCore setIs_ti_shi_set_gesture:NO];
            [self hide];
            
        } else {
            
            self.passwordconfirm = @"";
            [self setTip:self.tip2];
            [self setErrorTip:@"与上一次绘制不一致，请重新绘制" errorPswd:string];
            
        }
    } else {
        NSAssert(1, @"设置密码意外");
    }
}

#pragma mark - 显示提示
- (void)setTip:(NSString*)tip
{
    [_tipLable setText:tip];
    [_tipLable setTextColor:kTipColorNormal];
    
    _tipLable.alpha = 0;
    [UIView animateWithDuration:0.8
                     animations:^{
                         _tipLable.alpha = 1;
                     }completion:^(BOOL finished){
                     }
     ];
}

// 错误
- (void)setErrorTip:(NSString*)tip errorPswd:(NSString*)string
{
    // 显示错误点点
    [self.lockview showErrorCircles:string];
    
    // 直接_变量的坏处是
    [_tipLable setText:tip];
    [_tipLable setTextColor:kTipColorError];
    
    [self shakeAnimationForView:_tipLable];
}

#pragma mark 新建/修改后保存
- (void)updateTipButtonStatus
{
    LLLog(@"重设TipButton");
    if ((_nLockViewType == LLLockViewTypeCreate) &&
        ![self.passwordNew isEqualToString:@""]) // 新建或修改 & 确认时 才显示按钮 || _nLockViewType == LLLockViewTypeModify [更改需求:修改的时候要显示按钮]
    {
        [self.tipButton setTitle:@"点击此处以重新开始" forState:UIControlStateNormal];
        [self.tipButton setAlpha:1.0];
        
    } else {
        [self.tipButton setAlpha:0.0];
    }
    if (_nLockViewType == LLLockViewTypeCheck  || _nLockViewType == LLLockViewTypeModify) {
        [self.tipButton setTitle:@"忘记密码?" forState:UIControlStateNormal];
        [self.tipButton setAlpha:1.0];
    }
    // 更新指示圆点
    if (![self.passwordNew isEqualToString:@""] && [self.passwordconfirm isEqualToString:@""]){
        //        self.indecator.hidden = NO;
        [self.indecator setPasswordString:self.passwordNew];
    } else {
        //        self.indecator.hidden = YES;
    }
}

#pragma mark - 点击了按钮
- (IBAction)tipButtonPressed:(id)sender {
    if (_nLockViewType == LLLockViewTypeCheck || _nLockViewType == LLLockViewTypeModify) {
        // 强制注销该账户，并清除手势密码，以便重设
        [self.tipButton setTitle:@"忘记密码?" forState:UIControlStateNormal];
        [self.tipButton setAlpha:1.0];
        [CMCore setIs_open_gesture_password:NO];
        [LLLockPassword saveLockPassword:nil];
        
        [CMCore logout];
        [self dismissViewControllerAnimated:NO completion:nil]; // 由于是强制登录，这里必须以NO ani的方式才可
        return;
    }
    self.passwordNew = @"";
    self.passwordconfirm = @"";
    [self setTip:self.tip1];
    [self updateTipButtonStatus];
}

#pragma mark - 成功后返回
- (void)hide
{
    switch (_nLockViewType) {
        case LLLockViewTypeCheck:
        {
            [self.tipButton setTitle:@"忘记密码?" forState:UIControlStateNormal];
            [self.tipButton setAlpha:1.0];
            if (_status == 100) {//100 check 密码以关闭密码
                [CMCore setIs_open_gesture_password:NO];
            }
            //            if (_status == 200) {//200 check 密码以验证用户身份
            //
            //            }
        }
            break;
        case LLLockViewTypeCreate:
        case LLLockViewTypeModify:
        {
            [self.tipButton setTitle:@"忘记密码?" forState:UIControlStateNormal];
            [self.tipButton setAlpha:1.0];
            [LLLockPassword saveLockPassword:self.passwordNew];
            [CMCore setIs_open_gesture_password:YES];
        }
            break;
        case LLLockViewTypeClean:
        default:
        {
            [LLLockPassword saveLockPassword:nil];
        }
    }
    // 在这里可能需要回调上个页面做一些刷新什么的动作
#ifdef LLLockAnimationOn
    [self captureCurrentSnap];
    // 隐藏控件
    for (UIView* v in self.view.subviews) {
        if (v.tag > 10000) continue;
        v.hidden = YES;
    }
    // 动画解锁
    //    [self animateUnlock];
    [self dismissViewControllerAnimated:NO completion:nil];
#else
    [self dismissViewControllerAnimated:NO completion:nil];
#endif
    
}

#pragma mark - delegate 每次划完手势后
- (void)lockString:(NSString *)string
{
    LLLog(@"这次的密码=--->%@<---", string) ;
    
    if ((_nLockViewType == LLLockViewTypeCreate) && (string.length < 4)) {
        [self setErrorTip:@"最少连接四个点" errorPswd:string];
    }else {
        switch (_nLockViewType) {
            case LLLockViewTypeCheck:
            {
                [self.tipButton setTitle:@"忘记密码?" forState:UIControlStateNormal];
                [self.tipButton setAlpha:1.0];
                self.tip1 = @"请输入解锁密码";
                [self checkPassword:string];
            }
                break;
            case LLLockViewTypeCreate:
            {
                self.tip1 = @"设置解锁密码";
                self.tip2 = @"请再次绘制解锁密码";
                self.tip3 = @"解锁密码设置成功";
                [self createPassword:string];
            }
                break;
            case LLLockViewTypeModify:
            {
                [self.tipButton setTitle:@"忘记密码?" forState:UIControlStateNormal];
                [self.tipButton setAlpha:1.0];
                if ([self.passwordOld isEqualToString:@""]) {
                    self.tip1 = @"请输入原来的密码";
                    [self checkPassword:string];
                } else {
                    self.tip1 = @"请输入新的密码";
                    self.tip2 = @"请再次输入密码";
                    self.tip3 = @"密码修改成功";
                    [self createPassword:string];
                }
            }
                break;
            case LLLockViewTypeClean:
            default:
            {
                self.tip1 = @"请输入密码以清除密码";
                self.tip2 = @"清除密码成功";
                [self checkPassword:string];
            }
        }
        
        [self updateTipButtonStatus];
    }
    
}

#pragma mark - 解锁动画
// 截屏，用于动画
#ifdef LLLockAnimationOn
- (UIImage *)imageFromView:(UIView *)theView
{
    UIGraphicsBeginImageContext(theView.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [theView.layer renderInContext:context];
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

// 上一界面截图
- (void)capturePreSnap
{
    self.preSnapImageView.hidden = YES; // 默认是隐藏的
    self.preSnapImageView.image = [self imageFromView:self.presentingViewController.view];
}

// 当前界面截图
- (void)captureCurrentSnap
{
    self.currentSnapImageView.hidden = YES; // 默认是隐藏的
    self.currentSnapImageView.image = [self imageFromView:self.view];
}

- (void)animateUnlock{
    
    self.currentSnapImageView.hidden = NO;
    self.preSnapImageView.hidden = NO;
    
    static NSTimeInterval duration = 0.5;
    
    // currentSnap
    CABasicAnimation* scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.fromValue = [NSNumber numberWithFloat:1.0];
    scaleAnimation.toValue = [NSNumber numberWithFloat:2.0];
    
    CABasicAnimation *opacityAnimation;
    opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.fromValue=[NSNumber numberWithFloat:1];
    opacityAnimation.toValue=[NSNumber numberWithFloat:0];
    
    CAAnimationGroup* animationGroup =[CAAnimationGroup animation];
    animationGroup.animations = @[scaleAnimation, opacityAnimation];
    animationGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animationGroup.duration = duration;
    animationGroup.delegate = self;
    animationGroup.autoreverses = NO; // 防止最后显现
    animationGroup.fillMode = kCAFillModeForwards;
    animationGroup.removedOnCompletion = NO;
    [self.currentSnapImageView.layer addAnimation:animationGroup forKey:nil];
    
    // preSnap
    scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.fromValue = [NSNumber numberWithFloat:1.5];
    scaleAnimation.toValue = [NSNumber numberWithFloat:1.0];
    
    opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.fromValue = [NSNumber numberWithFloat:0];
    opacityAnimation.toValue = [NSNumber numberWithFloat:1];
    
    animationGroup = [CAAnimationGroup animation];
    animationGroup.animations = @[scaleAnimation, opacityAnimation];
    animationGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animationGroup.duration = duration;
    //
    [self.preSnapImageView.layer addAnimation:animationGroup forKey:nil];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    self.currentSnapImageView.hidden = YES;
    [self dismissViewControllerAnimated:NO completion:nil];
}
#endif

#pragma mark 抖动动画
- (void)shakeAnimationForView:(UIView *)view
{
    CALayer *viewLayer = view.layer;
    CGPoint position = viewLayer.position;
    CGPoint left = CGPointMake(position.x - 10, position.y);
    CGPoint right = CGPointMake(position.x + 10, position.y);
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [animation setFromValue:[NSValue valueWithCGPoint:left]];
    [animation setToValue:[NSValue valueWithCGPoint:right]];
    [animation setAutoreverses:YES]; // 平滑结束
    [animation setDuration:0.08];
    [animation setRepeatCount:3];
    
    [viewLayer addAnimation:animation forKey:nil];
}


#pragma mark - 提示信息
- (void)showAlert:(NSString*)string
{
    //    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil
    //                                                    message:string
    //                                                   delegate:nil
    //                                          cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    //    [alert show];
    [[JPAlert current] showAlertWithTitle:string button:@"确定"];
    
}

@end
