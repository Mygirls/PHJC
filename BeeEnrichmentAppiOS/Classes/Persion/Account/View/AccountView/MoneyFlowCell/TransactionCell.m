//
//  TransactionCell.m
//  BeeEnrichmentAppiOS
//
//  Created by dll on 15/12/24.
//  Copyright © 2015年 didai. All rights reserved.
//

#import "TransactionCell.h"
#import "MoneyFlowModel.h"

@interface TransactionCell ()
@property (strong, nonatomic) IBOutlet UILabel *orderNoLable;
@property (strong, nonatomic) IBOutlet UILabel *money;
@property (strong, nonatomic) IBOutlet UILabel *time_label;
@property (strong, nonatomic) IBOutlet UILabel *status;
@property (weak, nonatomic) IBOutlet UILabel *titleLable;


@end


@implementation TransactionCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
-(void)setModel:(MoneyFlowModel *)model
{
    _model = model;
    double totalMoney = floor( model.totalMoney * 100) / 100;
    double totalMoneyActual = floor(model.totalMoneyActual * 100) / 100;
    SubjectCouponModel * dic = model.subjectCoupon;
    
    /*
     * type_label: 标的名称
     * title: 订单号
     * status: 状态
     */
    self.titleLable.text = model.title == nil ? @"" : model.title;;
    self.time_label.text = [NSString stringWithFormat:@"%@",[CMCore turnToDate:model.createTime]];
    self.status.text = model.remark;
    if (model.isAutoBid) {
        self.money.text = [NSString stringWithFormat:@"%.2f",totalMoney];
        self.status.text = [NSString stringWithFormat:@"(债权匹配)%@",model.remark];
    }
    
    NSInteger status = model.status;
    //status 100 waiting 200 success 300 fail 400 pos_waiting 500 passbook_waiting
    if (status == 100 || status == 400 || status == 500) {
        //审核
        self.status.textColor = [UIColor colorWithRed:0.98 green:0.78 blue:0.43 alpha:1.00];
    } else if (status == 300) {
        //失败
        self.status.textColor = [UIColor grayColor];
        NSString *info = [NSString stringWithFormat:@"%@",model.reason];
        self.status.text = (info.length > 0 && (info.length > 8) && ![info isKindOfClass:[NSNull class]]) ? [@"失败,原因:" stringByAppendingString:info] :@"暂无失败原因,如有疑问请联系客服";
    } else {// 200 成功
        self.status.textColor = [CMCore basic_color];
    }
    self.status.text = model.reason;
    
    NSString *orderNo = model.orderNo;
    if (orderNo.length > 8) {
        self.orderNoLable.text = [NSString stringWithFormat:@"%@",model.orderNo];
    }else {
        self.orderNoLable.text = @"此订单没有订单号";
    }
    
    
    NSInteger type = model.type;
    if (dic.type) {
        double hongbao_money = dic.value;
        
        NSString *strZero  = [NSString string];
        NSString *strOne  = [NSString string];
        
        if (dic.type == 10) {
            
            NSString * restr = [NSString stringWithFormat:@"%.2f",hongbao_money];
            strZero = [NSString stringWithFormat:@"加息券加息%@%%",restr];
            strOne =[NSString stringWithFormat:@"-(实际支付%.2f+",totalMoney];
            
            
        }else if(dic.type == 20) {
            
            strZero = [NSString stringWithFormat:@"体验金%.2f",hongbao_money];
            strOne =[NSString stringWithFormat:@"-(实际支付%.2f+",totalMoney];
            
            
        }else if(dic.type == 30) {
            
            strZero = [NSString stringWithFormat:@"红包优惠%.2f",hongbao_money];
            strOne =[NSString stringWithFormat:@"-(实际支付%.2f+",(totalMoney - hongbao_money)];
            
        }else if (dic.type == 40) {
            
            strZero = [NSString stringWithFormat:@"体验金%.2f",hongbao_money];
            strOne =[NSString stringWithFormat:@"-(实际支付%.2f+",totalMoney];
            
        }
        
        NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc] initWithString:strOne];
        NSMutableAttributedString *str2 = [[NSMutableAttributedString alloc] initWithString:strZero attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12]}];
        
        NSMutableAttributedString *str3 = [[NSMutableAttributedString alloc] initWithString:@")"];
        [str2 appendAttributedString:str3];
        [str1 appendAttributedString:str2];
        self.money.attributedText = str1;
    } else {
        // 100 支付-， 300 赎回， 400 返还+，500 绑定银行卡- 700 提现-
        if (type == 100 || type == 500 || type == 700) {
            NSString * string = [_orderNoLable.text substringToIndex:4];
            if (type == 100 && ([string isEqualToString:@"BPTS"] || [string isEqualToString:@"BPSU"])) {
                self.money.text = [NSString stringWithFormat:@"%.2f",totalMoneyActual];
            } else {
                self.money.text = [NSString stringWithFormat:@"-%.2f",totalMoneyActual];
            }
        } else {
            self.money.text = [NSString stringWithFormat:@"+%.2f",totalMoneyActual];
        }
        
    }
}

@end
