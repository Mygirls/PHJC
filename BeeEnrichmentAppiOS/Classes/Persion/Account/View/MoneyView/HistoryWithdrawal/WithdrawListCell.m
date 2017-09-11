//
//  WithdrawListCell.m
//  BeeEnrichmentAppiOS
//
//  Created by dll on 16/6/14.
//  Copyright © 2016年 didai. All rights reserved.
//

#import "WithdrawListCell.h"
#import "WithdrawalHistoryModel.h"

@interface WithdrawListCell()
@property (strong, nonatomic) IBOutlet UILabel *title;
@property (strong, nonatomic) IBOutlet UILabel *time;
@property (strong, nonatomic) IBOutlet UILabel *money;
@property (strong, nonatomic) IBOutlet UILabel *status;
//@property (strong, nonatomic) IBOutlet UIImageView *myImageView;
@end
@implementation WithdrawListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setModel:(WithdrawalHistoryModel *)model
{
    //WAIT(0,"待审核"),WITHDRAW(100, "提现中"), SUCCESS(200, "提现成功"), AUDIT_FAIL(300, "审核失败"),WITHDRAW_FAIL(400,"提现失败");
    self.money.text = [NSString stringWithFormat:@"%.2f",model.total];
//    self.time.text = [[NSString stringWithFormat:@"%@",model[@"create_time"]] substringToIndex:10];
    self.time.text = [NSString stringWithFormat:@"%@",[CMCore turnToDate:model.createTime]];
    NSInteger status = model.status;
    if (status == 0) {
        self.status.text = @"等待审核";
        self.status.textColor = [UIColor colorWithRed:0.98 green:0.78 blue:0.43 alpha:1.00];
    }else if (status == 100) {
        self.status.text = @"提现中";
        self.status.textColor = [UIColor colorWithRed:0.98 green:0.78 blue:0.43 alpha:1.00];
    }else if (status == 200) {
        self.status.text = @"提现成功";
        self.status.textColor = [CMCore basic_color];
    }else if(status == 300) {

        self.status.text = @"审核失败";
//        NSString *info = [NSString stringWithFormat:@"%@",model[@"reason"]];
//        self.status.text = (info.length > 0 && ![info isEqualToString:@""]) ? [@"失败原因:" stringByAppendingString:info] :@"暂无失败原因,如有疑问请联系客服";
        self.status.textColor = [UIColor grayColor];
    }else if(status == 400) {
        self.status.text = @"提现失败";
//        NSString *info = [NSString stringWithFormat:@"%@",model[@"reason"]];
//        self.status.text = (info.length > 0 && ![info isEqualToString:@""]) ? [@"失败原因:" stringByAppendingString:info] :@"暂无失败原因,如有疑问请联系客服";
        self.status.textColor = [UIColor grayColor];
    }
    self.accessoryType = UITableViewCellAccessoryNone;
    BankCardRecordModel *bank_card_info = model.memberBankCardRecord;
    NSString *card = [bank_card_info.bankCardId stringByReplacingOccurrencesOfString:@" " withString:@""];
    self.title.text = [NSString stringWithFormat:@"%@(尾号%@)", bank_card_info.bankTitle, [card substringFromIndex:card.length - 4]];
            NSString *bank_title = [CMCore get_bank_card_info][@"bank_title"];
            for (NSDictionary *dic in [CMCore get_bank_list]) {
                if ([dic[@"title"] isEqualToString:bank_title]) {
                    [self.imageView sd_setImageWithURL:[NSURL URLWithString:dic[@"logo_url"]] placeholderImage:[UIImage imageNamed:@"v1_bank_logo"]];
                    break;
                }
            }
}


@end
