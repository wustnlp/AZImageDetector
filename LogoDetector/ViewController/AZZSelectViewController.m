//
//  AZZSelectViewController.m
//  LogoDetector
//
//  Created by 朱安智 on 2017/2/6.
//  Copyright © 2017年 Andrew. All rights reserved.
//

#import "AZZSelectViewController.h"

@interface AZZSelectViewController ()

@end

@implementation AZZSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.hidesBackButton = YES;
    self.navigationController.viewControllers = @[self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
