//
//  AZZImageDetector.m
//  LogoDetector
//
//  Created by 朱安智 on 2017/1/6.
//  Copyright © 2017年 Andrew. All rights reserved.
//

#import "AZZImageDetector.h"

#import <opencv2/highgui/cap_ios.h>
#import "AZZImageUtils.h"

using namespace cv;

@interface AZZImageDetector () <CvVideoCameraDelegate>
{
    std::vector<Mat> triggers, triggers_descs;
    std::vector< std::vector<KeyPoint> > triggers_kps;
    BOOL processFrames, save_files, thread_over, debug, called_failed_detection, called_success_detection;
    int detected_index;
    NSMutableArray *detection;
    CFTimeInterval last_time, ease_last_time, timeout_started;
    CFTimeInterval timeout, full_timeout, ease_time;
    NSUInteger triggers_size;
}

@property (nonatomic, strong) CvVideoCamera *camera;

@end

@implementation AZZImageDetector

+ (instancetype)detectorWithImageView:(UIImageView *)imageView {
    AZZImageDetector *instance = [AZZImageDetector new];
    [instance initializeWithImageView:imageView];
    return instance;
}

- (void)initializeWithImageView:(UIImageView *)imageView {
    self.camera = [[CvVideoCamera alloc] initWithParentView:imageView];
    self.camera.defaultAVCaptureDevicePosition = AVCaptureDevicePositionBack;
    self.camera.defaultAVCaptureSessionPreset = AVCaptureSessionPresetMedium;
    self.camera.defaultAVCaptureVideoOrientation = AVCaptureVideoOrientationPortrait;
    self.camera.rotateVideo = YES;
    self.camera.defaultFPS = 30;
    self.camera.grayscaleMode = NO;
    self.camera.delegate = self;
    
    processFrames = NO;
    save_files = NO;
    thread_over = YES;
    debug = NO;
    called_success_detection = NO;
    called_failed_detection = YES;
    
    timeout = 0.0;
    full_timeout = 6.0;
    ease_time = 0.0;
    last_time = CACurrentMediaTime();
    timeout_started = last_time;
    ease_last_time = last_time;
    
    detection = [NSMutableArray array];
    triggers_size = -1;
    detected_index = -1;
}

- (void)dealloc {
    triggers.clear();
    triggers_descs.clear();
    triggers_kps.clear();
}

#pragma mark - Public Methods

- (void)setPatterns:(NSArray<UIImage *> *)patterns {
    if (patterns && patterns.count > 0) {
        triggers_size = patterns.count;
        triggers.clear();
        triggers_kps.clear();
        triggers_descs.clear();
        ORB orb = ORB::ORB();
        
        [detection removeAllObjects];
        for (UIImage *image in patterns) {
            [detection addObject:@0];
            int width_limit = 400, height_limit = 400;
            UIImage *scaled = image;
            // scale image to improve detection
            if(image.size.width > width_limit) {
                scaled = [UIImage imageWithCGImage:[image CGImage] scale:(image.size.width/width_limit) orientation:(image.imageOrientation)];
                if(scaled.size.height > height_limit) {
                    scaled = [UIImage imageWithCGImage:[scaled CGImage] scale:(scaled.size.height/height_limit) orientation:(scaled.imageOrientation)];
                }
            }
            
            Mat patt, desc1;
            std::vector<KeyPoint> kp1;
            
            patt = [AZZImageUtils cvMatFromUIImage: scaled];
            
            patt = [AZZImageUtils cvMatFromUIImage: scaled];
            cvtColor(patt, patt, CV_BGRA2GRAY);
            //equalizeHist(patt, patt);
            
            //save mat as image
            if (save_files)
            {
                UIImageWriteToSavedPhotosAlbum([AZZImageUtils UIImageFromCVMat:patt], nil, nil, nil);
            }
            orb.detect(patt, kp1);
            orb.compute(patt, kp1, desc1);
            
            triggers.push_back(patt);
            triggers_kps.push_back(kp1);
            triggers_descs.push_back(desc1);
        }
        if ((int)triggers.size() == triggers_size) {
            if (debug) {
                NSLog(@"setPatterns_OK");
            }
        } else {
            if (debug) {
                NSLog(@"setPatterns_ERROR");
            }
        }
    } else {
        if (debug) {
            NSLog(@"setPatterns_ERROR");
        }
    }
}

- (void)startProcess {
    processFrames = YES;
    [self.camera start];
}

- (void)stopProcess {
    processFrames = NO;
    [self.camera stop];
}

#pragma mark - CvVideoCameraDelegate

- (void)processImage:(cv::Mat &)image {
    //get current time and calculate time passed since last time update
    CFTimeInterval current_time = CACurrentMediaTime();
    CFTimeInterval time_passed = current_time - last_time;
    CFTimeInterval time_diff_passed = current_time - timeout_started;
    CFTimeInterval passed_ease = current_time - ease_last_time;
    
    //NSLog(@"time passed %f, time full %f, passed ease %f", time_passed, time_diff_passed, passed_ease);
    
    //process frames if option is true and timeout passed
    BOOL hasTriggerSet = NO;
    if(!triggers.empty()){
        hasTriggerSet = triggers.size() == triggers_size;
    }
    if (processFrames && time_passed > timeout && hasTriggerSet) {
        //check if time passed full timout time
        if(time_diff_passed > full_timeout) {
            ease_time = 0.0;
        }
        // ease detection after timeout
        if (passed_ease > ease_time) {
            // process each image in new thread
            if(!image.empty() && thread_over){
                for (int i = 0; i < triggers.size(); i++) {
                    Mat patt = triggers.at(i);
                    std::vector<KeyPoint> kp1 = triggers_kps.at(i);
                    Mat desc1 = triggers_descs.at(i);
                    thread_over = NO;
                    Mat image_copy = image.clone();
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        [self backgroundImageProcessing: image_copy pattern:patt keypoints:kp1 descriptor:desc1 index:i];
                        dispatch_sync(dispatch_get_main_queue(), ^{
                            if(i == (triggers.size() - 1)) {
                                thread_over = YES;
                            }
                        });
                    });
                }
            }
            ease_last_time = current_time;
        }
        
        //update time and reset timeout
        last_time = current_time;
        timeout = 0.0;
    }
}

- (void)backgroundImageProcessing:(const Mat &)image pattern:(const Mat &)patt keypoints:(const std::vector<KeyPoint> &)kp1 descriptor:(const Mat &)desc1 index:(const int &)idx {
    if(!image.empty() && !patt.empty()) {
        Mat gray = image;
        //        Mat image_copy = image;
        Mat desc2;
        std::vector<KeyPoint> kp2;
        
        cvtColor(image, gray, CV_BGRA2GRAY);
        //equalizeHist(gray, gray);
        
        ORB orb = ORB::ORB();
        orb.detect(gray, kp2);
        orb.compute(gray, kp2, desc2);
        
        BFMatcher bf = BFMatcher::BFMatcher(NORM_HAMMING2, true);
        std::vector<DMatch> matches;
        std::vector<DMatch> good_matches;
        
        if(!desc1.empty() && !desc2.empty())
        {
            bf.match(desc1, desc2, matches);
            
            int size = 0;
            double min_dist = 1000;
            if(desc1.rows < matches.size())
                size = desc1.rows;
            else
                size = (int)matches.size();
            
            for(int i = 0; i < size; i++) {
                double dist = matches[i].distance;
                if(dist < min_dist) {
                    min_dist = dist;
                }
            }
            
            std::vector<DMatch> good_matches_reduced;
            
            for(int i = 0; i < size; i++) {
                if(matches[i].distance <=  2 * min_dist && good_matches.size() < 500) {
                    good_matches.push_back(matches[i]);
                    if(i < 10 && debug) {
                        good_matches_reduced.push_back(matches[i]);
                    }
                }
            }
            
            if(good_matches.size() >= 8) {
                if(debug) {
                    Mat imageMatches;
                    drawMatches(patt, kp1, gray, kp2, good_matches_reduced, imageMatches, Scalar::all(-1), Scalar::all(-1), std::vector<char>(), DrawMatchesFlags::NOT_DRAW_SINGLE_POINTS);
                    //image_copy = imageMatches;
                }
                
                Mat img_matches = image;
                //-- Localize the object
                std::vector<Point2f> obj;
                std::vector<Point2f> scene;
                
                for( int i = 0; i < good_matches.size(); i++ ) {
                    //-- Get the keypoints from the good matches
                    obj.push_back( kp1[ good_matches[i].queryIdx ].pt );
                    scene.push_back( kp2[ good_matches[i].trainIdx ].pt );
                }
                
                Mat H = findHomography( obj, scene, CV_RANSAC);
                
                bool result = true;
                
                if (!H.empty()) {
                    const double p1 = H.at<double>(0, 0);
                    const double p2 = H.at<double>(1, 1);
                    const double p3 = H.at<double>(1, 0);
                    const double p4 = H.at<double>(0, 1);
                    const double p5 = H.at<double>(2, 0);
                    const double p6 = H.at<double>(2, 1);
                    double det = 0, N1 = 0, N2 = 0, N3 = 0;
                    
                    if (p1 && p2 && p3 && p4) {
                        det = p1 * p2 - p3 * p4;
                        if (det < 0)
                            result = false;
                    } else {
                        result = false;
                    }
                    
                    if (p1 && p3) {
                        N1 = sqrt(p1 * p1 + p3 * p3);
                        if (N1 > 4 || N1 < 0.1)
                            result =  false;
                    } else {
                        result = false;
                    }
                    
                    if (p2 && p4) {
                        N2 = sqrt(p4 * p4 + p2 * p2);
                        if (N2 > 4 || N2 < 0.1)
                            result = false;
                    } else {
                        result = false;
                    }
                    
                    if (p5 && p6) {
                        N3 = sqrt(p5 * p5 + p6 * p6);
                        if (N3 > 0.002)
                            result = false;
                    } else {
                        result = false;
                    }
                    
                    //NSLog(@"det %f, N1 %f, N2 %f, N3 %f, result %i", det, N1, N2, N3, result);
                } else {
                    result = false;
                }
                
                if(result) {
                    if (debug) {
                        NSLog(@"detecting for index - %d", (int)idx);
                    }
                    [self updateState:YES index:(int)idx];
                    if(save_files) {
                        UIImageWriteToSavedPhotosAlbum([AZZImageUtils UIImageFromCVMat:gray], nil, nil, nil);
                    }
                    if(debug) {
                        //-- Get the corners from the image_1 ( the object to be "detected" )
                        std::vector<Point2f> obj_corners(4);
                        obj_corners[0] = cvPoint(0,0); obj_corners[1] = cvPoint( patt.cols, 0 );
                        obj_corners[2] = cvPoint( patt.cols, patt.rows ); obj_corners[3] = cvPoint( 0, patt.rows );
                        std::vector<Point2f> scene_corners(4);
                        
                        perspectiveTransform( obj_corners, scene_corners, H);
                        
                        //-- Draw lines between the corners (the mapped object in the scene - image_2 )
                        line( img_matches, scene_corners[0] + Point2f( patt.cols, 0), scene_corners[1] + Point2f( patt.cols, 0), Scalar(0, 255, 0), 4 );
                        line( img_matches, scene_corners[1] + Point2f( patt.cols, 0), scene_corners[2] + Point2f( patt.cols, 0), Scalar( 0, 255, 0), 4 );
                        line( img_matches, scene_corners[2] + Point2f( patt.cols, 0), scene_corners[3] + Point2f( patt.cols, 0), Scalar( 0, 255, 0), 4 );
                        line( img_matches, scene_corners[3] + Point2f( patt.cols, 0), scene_corners[0] + Point2f( patt.cols, 0), Scalar( 0, 255, 0), 4 );
                        
                        //image_copy = img_matches;
                    }
                } else {
                    [self updateState:NO index:(int)idx];
                }
                H.release();
                img_matches.release();
            }
            matches.clear();
            good_matches.clear();
            good_matches_reduced.clear();
        }
        gray.release();
        desc2.release();
        kp2.clear();
        //image = image_copy;
    }
}

- (void)updateState:(BOOL)state index:(const int &)idx {
    int detection_limit = 6;
    
    //    NSLog(@"updating state for index - %d", (int)idx);
    
    if(state) {
        int result = [[detection objectAtIndex:(int)idx] intValue] + 1;
        if(result < detection_limit) {
            [detection replaceObjectAtIndex:idx withObject:[NSNumber numberWithInt:result]];
        }
    } else {
        for (int i = 0; i < triggers.size(); i++) {
            int result = [[detection objectAtIndex:(int)i] intValue] - 1;
            if(result < 0) {
                result = 0;
            }
            [detection replaceObjectAtIndex:idx withObject:[NSNumber numberWithInt:result]];
        }
    }
    
    if([self getState:(int)idx] && called_failed_detection && !called_success_detection) {
        // Call Success Here
        if (self.successBlock) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                self.successBlock(idx);
            });
        }
        called_success_detection = true;
        called_failed_detection = false;
        detected_index = (int)idx;
    }
    
    bool valid_index = detected_index == (int)idx;
    
    if(![self getState:(int)idx] && !called_failed_detection && called_success_detection && valid_index) {
        // Call Fail Here
        if (self.failBlock) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                self.failBlock(idx);
            });
        }
        called_success_detection = false;
        called_failed_detection = true;
    }
}

- (BOOL)getState:(const int &)index {
    int detection_thresh = 3;
    NSNumber *total = 0;
    total = [detection objectAtIndex:index];
    
    if ([total intValue] >= detection_thresh) {
        return YES;
    } else {
        return NO;
    }
}

@end
