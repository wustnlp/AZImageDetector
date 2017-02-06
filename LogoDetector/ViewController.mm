//
//  ViewController.m
//  LogoDetector
//
//  Created by 朱安智 on 2017/1/6.
//  Copyright © 2017年 Andrew. All rights reserved.
//

#import "ViewController.h"
#import <opencv2/highgui/cap_ios.h>
#import "AZZImageUtils.h"
#import "AZZClient.h"
#import "AZZLocationManager.h"

@interface ViewController () <CvPhotoCameraDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *tfCost;
@property (weak, nonatomic) IBOutlet UITextField *tfAmount;
@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, weak) IBOutlet UIImageView *imgViewResult;

@property (nonatomic, strong) CvPhotoCamera *camera;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.camera = [[CvPhotoCamera alloc] initWithParentView:self.imageView];
    self.camera.defaultAVCaptureDevicePosition = AVCaptureDevicePositionBack;
    self.camera.defaultAVCaptureSessionPreset = AVCaptureSessionPresetHigh;
    self.camera.defaultAVCaptureVideoOrientation = AVCaptureVideoOrientationPortrait;
    self.camera.defaultFPS = 30;
    self.camera.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.camera start];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self.camera stop];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.tfCost) {
        [self.tfAmount becomeFirstResponder];
    } else {
        [self.tfAmount resignFirstResponder];
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.tfCost) {
        NSArray *costArray = @[@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"0", @".", @""];
        return [costArray containsObject:string];
    } else{
        NSArray *amoutArray = @[@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"0", @""];
        return [amoutArray containsObject:string];
    }
}

- (void)photoCamera:(CvPhotoCamera *)photoCamera capturedImage:(UIImage *)image {
    NSLog(@"captured");
    [self dealWithImage:image];
}

- (void)photoCameraCancel:(CvPhotoCamera *)photoCamera {
    NSLog(@"cancel");
}

- (IBAction)btnSendHongBao:(id)sender {
    if (!self.imgViewResult.image) {
        [self showHudWithTitle:@"Error" detail:@"图片为空"];
        [self hideHudAfterDelay:3.f];
        return;
    }
    if ([self.tfCost.text floatValue] == 0.0) {
        [self showHudWithTitle:@"Error" detail:@"金额有误"];
        [self hideHudAfterDelay:3.f];
        return;
    }
    if ([self.tfAmount.text integerValue] == 0) {
        [self showHudWithTitle:@"Error" detail:@"人数有误"];
        [self hideHudAfterDelay:3.f];
        return;
    }
    
    [self showHudWithTitle:nil detail:nil];
    [AZZLocationManagerInstance getCurrentGCJCoordinateWithBlock:^(CLLocationCoordinate2D location) {
        NSString *lati = [@(location.latitude) stringValue];
        NSString *longi = [@(location.longitude) stringValue];
        NSString *cost = self.tfCost.text;
        NSString *amout = self.tfAmount.text;
        NSData *imageData = UIImagePNGRepresentation(self.imgViewResult.image);
        [AZZClientInstance requestUploadHongBaoWith:imageData cost:cost amount:amout latitude:lati longitude:longi success:^(NSString * _Nullable msg) {
            [self showHudWithTitle:nil detail:msg];
            [self hideHudAfterDelay:3.f];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        } fail:^(NSString * _Nullable msg, NSError * _Nullable error) {
            [self showHudWithTitle:msg detail:[NSString stringWithFormat:@"domain:%@ code:%@ description:%@", error.domain, @(error.code), error.localizedDescription]];
            [self hideHudAfterDelay:10.f];
        }];
    }];
}

- (IBAction)btnTakePhoto:(id)sender {
    [self.camera takePicture];
}

- (IBAction)btnReTakePhoto:(id)sender {
    self.imgViewResult.hidden = YES;
}

- (void)dealWithImage:(UIImage *)image {
    CGRect rect = [self.imageView convertRect:self.imgViewResult.frame fromView:self.imgViewResult.superview];
    CGFloat imgFactor = image.size.width / image.size.height;
    CGFloat viewFactor = CGRectGetWidth(self.imageView.frame) / CGRectGetHeight(self.imageView.frame);
    CGFloat x, y, width, height;
    if (viewFactor > imgFactor) {
        CGFloat origHeight = CGRectGetWidth(self.imageView.frame) / imgFactor;
        CGFloat offset = origHeight - CGRectGetHeight(self.imageView.frame);
        CGFloat widFactor = image.size.width / CGRectGetWidth(self.imageView.frame);
        x = CGRectGetMinX(rect) * widFactor;
        y = (CGRectGetMinY(rect) + offset / 2.f) * widFactor;
        width = CGRectGetWidth(rect) * widFactor;
        height = CGRectGetHeight(rect) * widFactor;
    } else {
        CGFloat origWidth = CGRectGetHeight(self.imageView.frame) * imgFactor;
        CGFloat offset = origWidth - CGRectGetWidth(self.imageView.frame);
        CGFloat heightFactor = image.size.height / CGRectGetHeight(self.imageView.frame);
        x = (CGRectGetMinX(rect) + offset / 2.f) * heightFactor;
        y = CGRectGetMinY(rect) * heightFactor;
        width = CGRectGetWidth(rect) * heightFactor;
        height = CGRectGetHeight(rect) * heightFactor;
    }
    UIImage *result = [AZZImageUtils croppedImage:image InRect:CGRectMake(x, y, width, height)];
    self.imgViewResult.image = result;
    self.imgViewResult.hidden = NO;
}

@end
