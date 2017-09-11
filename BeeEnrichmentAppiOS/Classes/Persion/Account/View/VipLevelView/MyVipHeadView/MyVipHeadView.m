//
//  MyVipHeadView.m
//  BeeEnrichmentAppiOS
//
//  Created by dll on 16/6/24.
//  Copyright © 2016年 didai. All rights reserved.
//

#import "MyVipHeadView.h"
#import "VipLevelCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "QRCodeImage.h"

@interface MyVipHeadView ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;

@property (strong, nonatomic) IBOutlet UILabel *vLevel;
@property (strong, nonatomic) IBOutlet UILabel *middleLabel;
@property (strong, nonatomic) IBOutlet UILabel *bottomLabel;

@property (nonatomic, assign) NSInteger numCount, alreadyNum, selectedNum;
@property (nonatomic, assign) CGFloat progress;

@end
@implementation MyVipHeadView
- (void)awakeFromNib
{
    [super awakeFromNib];
  //  [_headImageView.layer setMasksToBounds:YES];

    _vLevel.font = [UIFont fontWithName:@"Helvetica-BoldOblique" size:12];
    [_collectionView registerNib:[UINib nibWithNibName:@"VipLevelCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"VipLevelCell"];
      [self load_my_qrcode_url];
}


//头像
- (void)setHeadImageView
{
    NSString *head_image_url = [CMCore get_user_info_member][@"head_image_url"];
    if (head_image_url && head_image_url.length > 0 ) {
        
        
        _headImageView.layer.cornerRadius = _headImageView.frame.size.width/2;
        _headImageView.layer.masksToBounds = YES;
        _headImageView.layer.borderColor = [UIColor whiteColor].CGColor;
        _headImageView.layer.borderWidth = 2;
        [_headImageView sd_setImageWithURL:[NSURL URLWithString:head_image_url] placeholderImage:[UIImage imageNamed:@"default_personal"]];

    }else
    {
        _headImageView.layer.borderWidth = 0;
        _headImageView.image = [UIImage imageNamed:@"default_personal"];
    }
    
    
}

#pragma mark 网络请求－获得二维码信息
- (void)load_my_qrcode_url
{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD showWithStatus:@"正在加载二维码信息"];
    [CMCore my_qrcode_with_is_alert:YES blockResult:^(NSNumber *code, id result, NSString *message) {
        if ([code integerValue] == 200) {
            [SVProgressHUD setMinimumDismissTimeInterval:1.5];
            [SVProgressHUD showSuccessWithStatus:@"加载成功"];
            _qrcode_image_url = result;
            
            QRCodeImage *qrcodeImage = [QRCodeImage codeImageWithString:result
                                                                   size:kScreenWidth/375*102
                                                                  color:[UIColor colorWithRed:0 green:0 blue:0 alpha:1.00]
                                                                   icon:nil
                                                              iconWidth:0];

//            [UIColor colorWithRed:0.99 green:0.40 blue:0.40 alpha:1.00]
            
            _imgView.image = qrcodeImage;
            
            if (self.imageBlock) {
                self.imageBlock(_imgView.image);
            }

        }else
        {
            [SVProgressHUD dismiss];
        }
        
    } blockRetry:^(NSInteger index) {
        [SVProgressHUD dismiss];
        if (index == 1) {
            [self load_my_qrcode_url];
        }
    }];
    
    [self setHeadImageView];

}

//设置近30天回款label
- (void)setMiddleLabelWithMoney:(NSString *)money bottomLabelWithMoney:(NSString*)bottomMoney
{
    NSArray *ary = [money componentsSeparatedByString:@"."];
    NSTextAttachment *img = [[NSTextAttachment alloc] init];
    img.bounds = CGRectMake(0, -2.5, 10, 12);
    img.image = [UIImage imageNamed:@"v1_vip_money"];
    NSAttributedString *strImg = [NSAttributedString attributedStringWithAttachment:img];
    NSAttributedString *str1 = [[NSAttributedString alloc] initWithString:@"  近30天待收金额: " attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]}];
    NSAttributedString *str2 = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥%@",ary[0]] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]}];
    NSAttributedString *str3 = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@".%@",ary[1]] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10]}];
    NSMutableAttributedString *mStr = [[NSMutableAttributedString alloc] init];
    [mStr appendAttributedString:strImg];
    [mStr appendAttributedString:str1];
    [mStr appendAttributedString:str2];
    [mStr appendAttributedString:str3];
    _middleLabel.attributedText = mStr;
    if (bottomMoney.length == 0) {
        _bottomLabel.text = @"恭喜您！您已成为最高尊享会员";
    }else
    {
        NSString *str = [NSString stringWithFormat:@"距离下一等级还差%@元待收金额，加油哦!",bottomMoney];
        _bottomLabel.text = str;
    }
}
//初始值
- (void)setNumCount:(NSInteger)numCount alreadyNum:(NSInteger)alreadyNum progress:(CGFloat)progress {
    _vLevel.text = [NSString stringWithFormat:@"%ld",(long)alreadyNum];
    _numCount = numCount;
    _alreadyNum = alreadyNum;
    _selectedNum = _alreadyNum;
    _progress = progress;
    [_collectionView reloadData];
    [self setCollectionViewContentOffSetWithIndexPath:[NSIndexPath indexPathForRow:_alreadyNum inSection:0]];
    
}
//collectionView delegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _numCount;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(90, _collectionView.frame.size.height);
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    VipLevelCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"VipLevelCell" forIndexPath:indexPath];
    [cell setVipLevelWithNum:indexPath.row alreadyArriveNum:_alreadyNum progress:_progress selectedNum:_selectedNum isLast:(indexPath.row == _numCount - 1) ? YES : NO];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    VipLevelCell *cell = (VipLevelCell*)[collectionView cellForItemAtIndexPath:indexPath];
    _selectedNum = indexPath.row;
    [cell setVipLevelWithNum:indexPath.row alreadyArriveNum:_alreadyNum progress:_progress selectedNum:_selectedNum isLast:(indexPath.row == _numCount - 1) ? YES : NO];
    [self setCollectionViewContentOffSetWithIndexPath:indexPath];
    if (self.didSelectedNumBlock) {
        self.didSelectedNumBlock(indexPath.row);
    }
}
- (void)setCollectionViewContentOffSetWithIndexPath:(NSIndexPath*)indexPath
{
    CGFloat f = 90*indexPath.row+20-(kScreenWidth/2-30);
    [_collectionView setContentOffset:CGPointMake(f, 0) animated:NO];
    [_collectionView reloadData];

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
