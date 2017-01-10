//
//  ViewController.m
//  LogoDetector
//
//  Created by 朱安智 on 2017/1/6.
//  Copyright © 2017年 Andrew. All rights reserved.
//

#import "ViewController.h"

#import "AZZImageDetector.h"
#import "AZZLocationManager.h"

#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width

@interface ViewController ()

@property (nonatomic, weak) IBOutlet UIImageView *imageView;

@property (nonatomic, strong) AZZImageDetector *detector;
@property (nonatomic, strong) UILabel *lbLocation;
@property (nonatomic, strong) UILabel *lbPlace;

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
    
    [[AZZLocationManager sharedInstance] startUpdatingLocationWithBlock:^(NSArray<CLLocation *> *locations) {
        self.lbLocation.text = locations.debugDescription;
    } placeCallback:^(NSArray<CLPlacemark *> *placeMarks) {
        self.lbPlace.text = placeMarks.debugDescription;
    }];
    
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

- (UILabel *)lbLocation {
    if (!_lbLocation) {
        _lbLocation = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, SCREENWIDTH - 20, 300)];
        _lbLocation.backgroundColor = [UIColor clearColor];
        _lbLocation.font = [UIFont systemFontOfSize:15.f];
        _lbLocation.numberOfLines = 0;
        [self.view addSubview:_lbLocation];
    }
    return _lbLocation;
}

- (UILabel *)lbPlace {
    if (!_lbPlace) {
        _lbPlace = [[UILabel alloc] initWithFrame:CGRectMake(10, 320, SCREENWIDTH - 20, 300)];
        _lbPlace.backgroundColor = [UIColor clearColor];
        _lbPlace.font = [UIFont systemFontOfSize:15.f];
        _lbPlace.numberOfLines = 0;
        [self.view addSubview:_lbPlace];
    }
    return _lbPlace;
}

@end
