//
//  AZZRegisterViewController.m
//  LogoDetector
//
//  Created by 朱安智 on 2017/2/4.
//  Copyright © 2017年 Andrew. All rights reserved.
//

#import "AZZRegisterViewController.h"
#import "AZZClient.h"

@interface AZZRegisterViewController ()

@property (nonatomic, weak) IBOutlet UITextField *tfUsername;
@property (nonatomic, weak) IBOutlet UITextField *tfPassword;
@property (nonatomic, weak) IBOutlet UIButton *btnConfirm;

@end

@implementation AZZRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.btnConfirm.layer.cornerRadius = 5.f;
    self.btnConfirm.layer.backgroundColor = [UIColor colorWithRed:0.986 green:0.090 blue:0.168 alpha:1.000].CGColor;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)registerClicked:(id)sender {
    [self showHudWithTitle:nil detail:nil];
    [AZZClientInstance requestRegisterWithUsername:self.tfUsername.text password:self.tfPassword.text success:^(NSString * _Nullable msg, id  _Nullable userid) {
        [self showHudWithTitle:nil detail:msg];
        [self login];
    } fail:^(NSString * _Nullable msg, NSError * _Nullable error) {
        [self showHudWithTitle:msg detail:[NSString stringWithFormat:@"domain:%@ code:%@ description:%@", error.domain, @(error.code), error.localizedDescription] hideAfterDelay:3.f];
    }];
}

- (void)login {
    [AZZClientInstance requestLoginWithUsername:self.tfUsername.text password:self.tfPassword.text success:^(NSString * _Nullable msg, id  _Nullable userid) {
        [self showHudWithTitle:nil detail:msg];
        UIStoryboard *st = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *vc = [st instantiateViewControllerWithIdentifier:@"selectvc"];
        [self.navigationController pushViewController:vc animated:YES];
    } fail:^(NSString * _Nullable msg, NSError * _Nullable error) {
        [self showHudWithTitle:msg detail:[NSString stringWithFormat:@"domain:%@ code:%@ description:%@", error.domain, @(error.code), error.localizedDescription] hideAfterDelay:3.f];
    }];
}

@end
