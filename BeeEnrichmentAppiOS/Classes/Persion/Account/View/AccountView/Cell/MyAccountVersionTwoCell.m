//
//  MyAccountVersionTwoCell.m
//  BeeEnrichmentAppiOS
//
//  Created by dll on 16/8/3.
//  Copyright © 2016年 didai. All rights reserved.
//

#import "MyAccountVersionTwoCell.h"
#import "MyAccountCollectionViewCell.h"
#define Spc 0.5
#define ItemSize ((kScreenWidth - 0.7 - 0.01) / 3)

@interface MyAccountVersionTwoCell ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) NSMutableArray *iconArray, *nameOfIconArray;
@end

@implementation MyAccountVersionTwoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setSomething];
}

- (void)setSomething
{
    self.iconArray = @[@"v1.6_mine_bank_card",@"v1.6_mine_deal_record", @"v1.6_min_package",  @"vip_center", @"v1.6_mine_back_money", @"v1.6_mine_invest_record", @"v1.6_mine_wenti",@"v1.6_set_min_about"].mutableCopy;
    self.nameOfIconArray = @[@"我的银行卡",@"资金明细", @"我的礼包", @"会员等级", @"邀请有礼", @"投资记录", @"帮助中心", @"关于普汇"].mutableCopy;
    NSDictionary *dic = [CMCore get_user_info_member];
    // 判断是否有业务员手机号码
    NSString *str = dic[@"salesman_mobile_phone"];
    if (str.length == 11) {
        [self.iconArray insertObject:@"v1.6_mine_product" atIndex:7];
        [self.nameOfIconArray insertObject:@"理财产品" atIndex:7];
    }else {
        
        [self.iconArray insertObject:@"v1.6_phone" atIndex:7];
        [self.nameOfIconArray insertObject:@"联系客服" atIndex:7];
    }
    //注册（xib）
    [self.collectionView registerNib:[UINib nibWithNibName:@"MyAccountCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"MyAccountCollectionViewCell"];
}

#pragma mark FlowLayoutDelegate 布局
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    if (kScreenWidth == 320) {
        return UIEdgeInsetsMake(0.5, 0.5, 0.5, 0.5);
    }else {
        return UIEdgeInsetsMake(0, 0, 0, 0);
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (kScreenWidth == 320) {
        return CGSizeMake((kScreenWidth - 2) / 3, 286 / 3);
    }else {
        return CGSizeMake(ItemSize, 286/3);
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0.5;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    if (kScreenWidth == 320) {
        return 0.5;
    }else {
        return 0.3;
    }
}

#pragma mark ColletionViewDelegate 设置
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.iconArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MyAccountCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MyAccountCollectionViewCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    cell.nameOfIconLabel.text = self.nameOfIconArray[indexPath.row];
    cell.iconImageView.image = [UIImage imageNamed:self.iconArray[indexPath.row]];
    if (indexPath.row == 3 || indexPath.row == 4) {
        cell.cornerMarkImageView.image = [UIImage imageNamed:@"v1.2_mine_hot_icon"];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    self.clickItem(indexPath.row);// 0,1 2,3 4 5 6 7 8
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
