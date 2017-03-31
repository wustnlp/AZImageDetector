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
#import "UMSSpinnerView.h"
#import "AZZLocationView.h"

@interface ViewController () <CvPhotoCameraDelegate, UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet UIImageView *vInputs;
@property (nonatomic, weak) IBOutlet UIView *vLeft;
@property (nonatomic, weak) IBOutlet UIView *vRight;
@property (nonatomic, weak) IBOutlet UIView *vTop;
@property (nonatomic, weak) IBOutlet UIView *vBottom;

@property (weak, nonatomic) IBOutlet UITextField *tfCost;
@property (weak, nonatomic) IBOutlet UITextField *tfAmount;
@property (nonatomic, weak) IBOutlet UITextField *tfMessage;

@property (nonatomic, weak) IBOutlet UIButton *btnSendFirst;
@property (nonatomic, weak) IBOutlet UIButton *btnSendSecond;
@property (nonatomic, weak) IBOutlet UIButton *btnShot;
@property (nonatomic, weak) IBOutlet UIButton *btnReshot;
@property (nonatomic, weak) IBOutlet UIButton *btnCancel;

@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, weak) IBOutlet UMSSpinnerView *imgViewResult;

@property (nonatomic, weak) IBOutlet AZZLocationView *locationView;

@property (nonatomic, strong) UIImage *imgResult;

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
    
    [self setupAnimatedImage];
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

- (void)setupAnimatedImage {
    self.vInputs.image = [UIImage imageNamed:@"u134"];
    self.vInputs.contentMode = UIViewContentModeScaleToFill;
    self.imgViewResult.tintColor = [UIColor redColor];
    self.imgViewResult.lineWidth = 2;
    self.imgViewResult.translatesAutoresizingMaskIntoConstraints = NO;
    self.imgViewResult.userInteractionEnabled = NO;
    self.imgViewResult.hidesWhenStopped = YES;
    [self.imgViewResult startAnimating];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.tfAmount) {
        [self.tfCost becomeFirstResponder];
    } else if (textField == self.tfCost) {
        [self.tfMessage becomeFirstResponder];
    } else {
        [self.tfMessage resignFirstResponder];
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.tfCost) {
        NSArray *costArray = @[@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"0", @".", @""];
        return [costArray containsObject:string];
    } else if (textField == self.tfAmount) {
        NSArray *amoutArray = @[@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"0", @""];
        return [amoutArray containsObject:string];
    } else {
        NSString *result = [textField.text stringByReplacingCharactersInRange:range withString:string];
        return [result lengthOfBytesUsingEncoding:NSUTF8StringEncoding] <= 256;
    }
}

- (void)photoCamera:(CvPhotoCamera *)photoCamera capturedImage:(UIImage *)image {
    NSLog(@"captured");
    [self.camera stop];
    [self dealWithImage:image];
}

- (void)photoCameraCancel:(CvPhotoCamera *)photoCamera {
    NSLog(@"cancel");
}

- (IBAction)btnSendHongBao:(id)sender {
    self.btnSendFirst.hidden = YES;
    self.btnReshot.hidden = YES;
    [self showInputs:YES];
    [self showBackground:NO];
}

- (IBAction)btnCancelClicked:(id)sender {
    [self showInputs:NO];
    self.btnSendFirst.hidden = NO;
    self.btnReshot.hidden = NO;
    [self showBackground:YES];
}

- (IBAction)btnSecondClicked:(id)sender {
    if (!self.imgResult) {
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
        NSData *imageData = UIImagePNGRepresentation(self.imgResult);
        [AZZClientInstance requestUploadHongBaoWith:imageData cost:cost amount:amout latitude:lati longitude:longi message:self.tfMessage.text success:^(NSString * _Nullable msg) {
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
    self.btnShot.hidden = YES;
    self.btnReshot.hidden = NO;
    self.btnSendFirst.hidden = NO;
    [self showBackground:YES];
    [self.imgViewResult stopAnimating];
}

- (IBAction)btnReTakePhoto:(id)sender {
    [self.camera start];
    self.btnShot.hidden = NO;
    self.btnReshot.hidden = YES;
    self.btnSendFirst.hidden = YES;
    [self showBackground:NO];
    [self.imgViewResult startAnimating];
}

- (void)showBackground:(BOOL)show {
    self.vLeft.hidden = !show;
    self.vRight.hidden = !show;
    self.vTop.hidden = !show;
    self.vBottom.hidden = !show;
}

- (void)showInputs:(BOOL)show {
    self.vInputs.hidden = !show;
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
//    self.imgViewResult.image = result;
    self.imgResult = result;
    self.imageView.image = image;
}

@end
