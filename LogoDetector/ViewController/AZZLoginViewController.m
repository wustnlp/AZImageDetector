//
//  AZZLoginViewController.m
//  LogoDetector
//
//  Created by 朱安智 on 2017/2/4.
//  Copyright © 2017年 Andrew. All rights reserved.
//

#import "AZZLoginViewController.h"
#import "AZZClient.h"

#import <Masonry/Masonry.h>

@interface AZZLoginViewController ()

@property (nonatomic, weak) IBOutlet UITextField *tfUsername;
@property (nonatomic, weak) IBOutlet UITextField *tfPassword;
@property (nonatomic, weak) IBOutlet UIButton *btnLogin;
@property (nonatomic, weak) IBOutlet UIButton *btnRegister;

@end

@implementation AZZLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.btnLogin.layer.cornerRadius = 5.f;
    self.btnLogin.layer.backgroundColor = [UIColor colorWithRed:0.507 green:0.703 blue:0.999 alpha:1.000].CGColor;
    self.btnRegister.layer.cornerRadius = 5.f;
    self.btnRegister.layer.backgroundColor = [UIColor colorWithRed:0.986 green:0.090 blue:0.168 alpha:1.000].CGColor;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action

- (IBAction)btnLoginClicked:(UIButton *)button {
    [self showHudWithTitle:nil detail:nil];
    [AZZClientInstance requestLoginWithUsername:self.tfUsername.text password:self.tfPassword.text success:^(NSString * _Nullable msg, id  _Nullable userid) {
        [self showHudWithTitle:nil detail:msg];
        UIStoryboard *st = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *vc = [st instantiateViewControllerWithIdentifier:@"selectvc"];
        [self.navigationController pushViewController:vc animated:YES];
    } fail:^(NSString * _Nullable msg, NSError * _Nullable error) {
        [self showHudWithTitle:msg detail:[NSString stringWithFormat:@"domain:%@ code:%@ description:%@", error.domain, @(error.code), error.localizedDescription] hideAfterDelay:10.f];
    }];
}

@end
