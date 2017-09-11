//
//  CalculatorView.m
//  BeeEnrichmentAppiOS
//
//  Created by dll on 16/11/7.
//  Copyright © 2016年 didai. All rights reserved.
//

#import "CalculatorView.h"


@interface CalculatorView ()<UITextFieldDelegate>
{
    CGFloat keyboardHeight;
}
@property (nonatomic,assign) CGFloat keyboardOriginY;

@property (weak, nonatomic) IBOutlet UIView *backView;
@property (strong, nonatomic) IBOutlet UIView *shadowView;
@property (weak, nonatomic) IBOutlet UILabel *time_limit;
@property (weak, nonatomic) IBOutlet UILabel *lilv_year;
@property (weak, nonatomic) IBOutlet UILabel *income;
@property (weak, nonatomic) IBOutlet UILabel *interest;
@property (weak, nonatomic) IBOutlet UITextField *money_textField;
@property (nonatomic, assign) long double value_lilv;
@property (nonatomic, strong) NSString *moneyStr;
@property (weak, nonatomic) IBOutlet UILabel *unitsLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *verticalOfUpView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *verticalOfDownView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hegihtOfUpView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightOfDownView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textFieldOfTrailing;

@end

@implementation CalculatorView
- (void)awakeFromNib
{
    [super awakeFromNib];
    _money_textField.layer.borderColor = [UIColor redColor].CGColor;
    _money_textField.layer.borderWidth = 0.5;
    _money_textField.layer.cornerRadius = 2;
    _money_textField.delegate = self;
    [self performSelector:@selector(becomeFirst) withObject:nil afterDelay:0.3];
    
    _moneyStr = [NSString new];
    self.frame = [UIScreen mainScreen].bounds;

    [self addNotification];
    if ([[CMCore iphoneType] isEqualToString:@"iPhone 5"] || [[CMCore iphoneType] isEqualToString:@"iPhone 5s"]) {

        self.verticalOfUpView.constant = (kScreenWidth - 60) * 12 / kScreenWidth;
        self.verticalOfDownView.constant = (kScreenWidth - 60) * 12 / kScreenWidth;
        self.hegihtOfUpView.constant = (kScreenWidth - 60) * 60 / 315;
        self.heightOfDownView.constant = (kScreenWidth - 60) * 68 / 315;
        self.textFieldOfTrailing.constant = 15;
    }
}

- (void)becomeFirst
{
    [_money_textField becomeFirstResponder];
}

- (void)setDic:(ProductsDetailModel *)dic
{
    _dic = dic;
    
    _value_lilv = (dic.expectedAnnualRate + dic.addAnnualRate) / 100;
    

    if (dic.repaymentId == 200) {
//        NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",dic[@"expected_annual_rate"]] attributes:@{NSFontAttributeName:[UIFont fontWithName:FontOfAttributed size:24]}];
//        if ([dic[@"add_annual_rate"] doubleValue] > 0) {
//            NSMutableAttributedString *str3 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"+%@",dic[@"add_annual_rate"]] attributes:@{NSFontAttributeName:[UIFont fontWithName:FontOfAttributed size:16]}];
//            [str1 appendAttributedString:str3];
//        }
//        _lilv_year.attributedText = str1;

        _lilv_year.text = [NSString stringWithFormat:@"%.2Lf", _value_lilv * 100];
        if (dic.marketType == 30) {
            self.time_limit.text = [NSString stringWithFormat:@"%@", dic.extra.restTerms];
        }else {
            self.time_limit.text = [NSString stringWithFormat:@"%zd",dic.Period];
        }
        

    }else{

        _lilv_year.text = [NSString stringWithFormat:@"预期年化:%.2Lf%%", _value_lilv * 100];
        if (dic.marketType == 30) {
            self.time_limit.text = [NSString stringWithFormat:@"%zd", dic.extra.daysRemaining];
        }else {            
            self.time_limit.text = [NSString stringWithFormat:@"%zd",dic.Period];
        }
    }
    if (dic.units == 1) {
        _unitsLabel.text = @"投资周期(天)";
    }else {
        if (dic.marketType == 30){
            _unitsLabel.text = @"投资周期(天)";
        }else {
            _unitsLabel.text = @"投资周期(月)";
        }
    }
    
 
}

- (IBAction)removeFromSuperView:(id)sender {
    [self removeFromSuperview];
//    [_back_view removeFromSuperview];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (![CMCore checkNumberValid:string]) {
        if ([string isEqualToString:@""]) {
            return YES;
        }
        return NO;
    }
    if ([string isEqualToString:@""]) {
        //当前是删除操作
        if (textField.text.length > 0) {
            _moneyStr = [_moneyStr substringToIndex:_moneyStr.length-1];
        }else
        {
            [_money_textField resignFirstResponder];
            _income.text = @"0.00";
            _interest.text = @"0.00";
        }
    }else{
        _moneyStr = [_moneyStr stringByAppendingString:string];
    }
    
    //每月还本金和利息=投资总金额／期数+月利息
    //月利息计算公式（按月）：月利息=本金*综合年化收益率*（1+期数）/（期数*24）
    // *****************************
    //新方式：每⽉还款额=[贷款本⾦×⽉利率×（1+⽉利率）^还款总期数]÷[（1+⽉利率）^还款总期数-1]（期数为次⽅基数）
    
    // 每月偿还利息=贷款本金×月利率×〔(1+月利率)^还款月数-(1+月利率)^(还款月序号-1)〕÷〔(1+月利率)^还款月数-1〕
    if (_dic.repaymentId == 200) {
        //等额本息
        CGFloat term = [self.time_limit.text doubleValue];
        CGFloat month_lilv = _value_lilv / 12.0;
        CGFloat month_lilv_add_one  = _value_lilv / 12.0 + 1;
        CGFloat pre = pow(month_lilv_add_one, term);
        CGFloat sur = pow(month_lilv_add_one,  term) -1;
        
        // 每月偿还利息=贷款本金×月利率×〔(1+月利率)^还款月数-(1+月利率)^(还款月序号-1)〕÷〔(1+月利率)^还款月数-1〕
        CGFloat monthInterest = 0.0;
        CGFloat preOfInvest = [_moneyStr doubleValue] * month_lilv;
        CGFloat temp = monthInterest;
        for (int i = 1; i < [self.time_limit.text intValue] + 1; i++) {
            monthInterest = preOfInvest * (pre - pow(month_lilv_add_one, i - 1)) / sur ;
            
            monthInterest = temp + floor(monthInterest * 100) / 100;
            temp = monthInterest;
        }
        //每月还本金
        CGFloat monthIncome = preOfInvest * pre / sur;
        
        _interest.text = [CalculatorView countNumAndChangeformat:[NSString stringWithFormat:@"%.2f", floor(monthIncome * 100) / 100]];
        
        _income.text = [CalculatorView countNumAndChangeformat:[NSString stringWithFormat:@"%.2f", monthInterest]];
        
    }else{
        ExtraModel * dayDic =_dic.extra;
        /*
         * 转让标的利息计算
         * 收益计算方式：
         * 单位：天
         * 年化 / 365 * 剩余天数（包含今天）* 购买金额 / 100
         * 单位：月
         * 年化 / 12 * 月(period) * 承接金额(购买金额) / 周期（总天数）* 剩余天数 / 100
         */
        double income;
        if (_dic.marketType == 30) {
            double rate =  _dic.actualAnnualRate;
            NSInteger period = _dic.Period;
            NSString *moneySt = [NSString stringWithFormat:@"%@", _moneyStr];
            double daysRemaining = dayDic.daysRemaining;
            NSInteger totalDay = dayDic.totalDay;
            
            if (_dic.units == 1) {
                _unitsLabel.text = @"投资周期(天)";
                income = floor(rate / 365.0 * daysRemaining * [_moneyStr doubleValue] / 100 * 100) / 100;
                _income.text = [CalculatorView countNumAndChangeformat:[NSString stringWithFormat:@"%.2lf", income]];
            } else {// 转让只有天
                
                _unitsLabel.text = @"投资周期(天)";
                income = rate / 12.0 * _dic.Period * [_moneyStr doubleValue] / dayDic.totalDay * daysRemaining / 100 ;
                _income.text = [CalculatorView countNumAndChangeformat:[CMCore calculateForExpectedMoneyWithRate:rate period:period money:[moneySt doubleValue] totalDay:totalDay daysRemaining:daysRemaining]];
            }
        } else {
            if (_dic.units == 1) {
                _unitsLabel.text = @"投资周期(天)";
                _income.text = [CalculatorView countNumAndChangeformat:[NSString stringWithFormat:@"%.2Lf",[_moneyStr doubleValue] * [_time_limit.text doubleValue] * _value_lilv / 365.0]];
            }else {
                _unitsLabel.text = @"投资周期(月)";
                _income.text = [CalculatorView countNumAndChangeformat:[NSString stringWithFormat:@"%.2Lf",[_moneyStr doubleValue] * [_time_limit.text doubleValue] * _value_lilv / 12.0]];
            }
        }
        
    }
    
    return YES;
    
}

#pragma mark - 动态改变弹出框位置
-(void)dealloc
{
    [self removeNotification];
}

-(void)addNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)removeNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
-(void)keyboardWillShow:(NSNotification *)notificaiton
{
    CGRect keyboardFrame = [[notificaiton.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    keyboardHeight = keyboardFrame.size.height;
    
    if((kScreenHeight - _backView.frame.origin.y - _backView.frame.size.height - 64) != _keyboardOriginY)
    {
        [self resetAlertFrame];
    }
}

-(void)keyboardWillHide:(NSNotification *)notificaiton
{
    keyboardHeight = 0;
    [self resetAlertFrame];
}

//改变alert的位置，防止阻挡键盘
-(void)resetAlertFrame
{
    CGFloat bottom = kScreenHeight - CGRectGetMaxY(_backView.frame);
    if(bottom < keyboardHeight)
    {
        CGFloat moveY = keyboardHeight - bottom + 70;
        
        CGRect alertFrame = _backView.frame;
        alertFrame.origin.y -= moveY;
        
        self.keyboardOriginY = alertFrame.origin.y;
        
        [UIView animateWithDuration:0.3f animations:^{
            _backView.frame = alertFrame;
        }];
    }
    else
    {
        CGRect alertFrame = _backView.frame;
        alertFrame.origin.y = (kScreenHeight - alertFrame.size.height) / 2.0f;
        
        [UIView animateWithDuration:0.3f animations:^{
            _backView.frame = alertFrame;
        }];
    }
}

#pragma mark - 添加分割逗号

+(NSString *)countNumAndChangeformat:(NSString *)num
{
    NSMutableString *tempStr = num.mutableCopy;
    NSRange range = [num rangeOfString:@"."];
    NSInteger index = 0;
    if (range.length > 0) {
        index = range.location;
    }else {
        index = num.length;
    }
    while ((index - 3) > 0) {
        index-=3;
        [tempStr insertString:@"," atIndex:index];
    }
    return tempStr;
}


@end
