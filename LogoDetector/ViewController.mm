//
//  ViewController.m
//  LogoDetector
//
//  Created by 朱安智 on 2017/1/6.
//  Copyright © 2017年 Andrew. All rights reserved.
//

#import "ViewController.h"

#import "AZZImageDetector.h"

@interface ViewController ()

@property (nonatomic, weak) IBOutlet UIImageView *imageView;

@property (nonatomic, strong) AZZImageDetector *detector;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.detector setPatterns:@[[UIImage imageNamed:@"2000"], [UIImage imageNamed:@"2001"]]];
    self.detector.successBlock = ^(int index) {
        switch (index) {
            case 0:
            {
                NSLog(@"detect 2000");
                break;
            }
            case 1:
            {
                NSLog(@"detect 2001");
                break;
            }
                
            default:
                break;
        }
    };
    self.detector.failBlock = ^(int index) {
        switch (index) {
            case 0:
            {
                NSLog(@"lose 2000");
                break;
            }
            case 1:
            {
                NSLog(@"lose 2001");
                break;
            }
                
            default:
                break;
        }
    };
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.detector startProcess];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (AZZImageDetector *)detector {
    if (!_detector) {
        _detector = [AZZImageDetector detectorWithImageView:self.imageView];
    }
    return _detector;
}

@end
