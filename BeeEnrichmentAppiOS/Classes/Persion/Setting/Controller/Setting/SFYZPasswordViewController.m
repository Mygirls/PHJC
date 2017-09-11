//
//  SFYZPasswordViewController.m
//  BeeEnrichmentAppiOS
//
//  Created by yanfa-mac on 2017/3/7.
//  Copyright © 2017年 DuLonglong. All rights reserved.
//

#import "SFYZPasswordViewController.h"
#import "LTimerButton.h"
@interface SFYZPasswordViewController ()
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (nonatomic,assign) BOOL  isSuccess;
@property (weak, nonatomic) IBOutlet LTimerButton *sendButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@end

@implementation SFYZPasswordViewController
- (IBAction)requestMessage:(LTimerButton *)sender {
    [sender startTimerWithCount:60];

    [CMCore sendCheckMessageWithIs_alert:YES blockResult:^(NSNumber *code, id result, NSString *message) {
        
        if ([result isKindOfClass:[NSDictionary class]]) {
            
            NSDictionary * dict = result;
            if ([dict[@"tag"] boolValue] == YES) {
                
            }
        }
        
        
    } blockRetry:^(NSInteger index) {
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"身份验证";
    self.nextButton.layer.cornerRadius = 2;
    self.nextButton.layer.borderWidth = 0;
    self.nextButton.layer.masksToBounds = YES;
    
}



- (IBAction)done:(UIButton *)sender {
    [SVProgressHUD show];
    
    NSUUID *uuid = [UIDevice currentDevice].identifierForVendor;

    NSString *Fingerprint_token = [uuid.UUIDString stringByAppendingString:self.password.text];
    
    
    if (self.password.text.length >0) {
        
        [CMCore checkMessageWithFingerprint_token:Fingerprint_token andCode:self.password.text is_alert:YES blockResult:^(NSNumber *code, id result, NSString *message) {
            
            
            if ([result isKindOfClass:[NSDictionary class]]) {
                NSDictionary * dict = result;
                if ([dict[@"tag"] boolValue] == YES) {
                    
                    [SVProgressHUD showSuccessWithStatus:@"验证成功"];
                    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
                    [defaults setObject:Fingerprint_token forKey:@"Fingerprint_token"];
                    [defaults synchronize];
                    self.isSuccess = YES;
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [SVProgressHUD dismiss];
                        [self go_back:YES viewController:self];
                    });
                    
                    
                }else{
                    [SVProgressHUD dismiss];
                    UIAlertController * alertC = [UIAlertController alertControllerWithTitle:@"验证码不正确" message:@"请重新输入" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction * action = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleCancel handler:nil];
                    [alertC addAction:action];
                    [self presentViewController:alertC animated:YES completion:nil];
                }
            }else{
                [SVProgressHUD dismiss];
            }
            
            
            
        } blockRetry:^(NSInteger index) {
            if ([SVProgressHUD isVisible]) {
                
                [SVProgressHUD dismiss];
            }
        }];
        
        
    }else{
        
        UIAlertController * alertC = [UIAlertController alertControllerWithTitle:@"请输入验证码" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * action = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleCancel handler:nil];
        [alertC addAction:action];
        [self presentViewController:alertC animated:YES completion:nil];
        self.isSuccess = NO;
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewDidDisappear:(BOOL)animated{
    
    if ([SVProgressHUD isVisible]) {
    
        [SVProgressHUD dismiss];
    }
    if (self.isSuccess == NO) {
        self.isSuccessBlock();
    }
}


@end
