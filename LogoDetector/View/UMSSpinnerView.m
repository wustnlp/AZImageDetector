//
//  UMSSpinnerView.m
//  ChinaUMS
//
//  Created by ums on 16/2/13.
//  Copyright © 2016年 ChinaUMS. All rights reserved.
//

#import "UMSSpinnerView.h"

static NSString *StrokeAnimationKey = @"spinner.stroke";
static NSString *RotationAnimationKey = @"spinner.rotation";

@interface UMSSpinnerView ()

@property (nonatomic, readonly) CAShapeLayer *progressLayer;
@property (nonatomic, readonly) CAShapeLayer *secondLayer;
@property (nonatomic, readwrite) BOOL isAnimating;

@end

@implementation UMSSpinnerView

@synthesize progressLayer=_progressLayer;
@synthesize secondLayer=_secondLayer;

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    self.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.layer addSublayer:self.progressLayer];
    [self.layer addSublayer:self.secondLayer];
    
    // See comment in resetAnimations on why this notification is used.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetAnimations) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.progressLayer.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
    self.secondLayer.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
    [self updatePath];
}

- (void)tintColorDidChange {
    [super tintColorDidChange];
    
    self.progressLayer.strokeColor = self.tintColor.CGColor;
    self.secondLayer.strokeColor = self.tintColor.CGColor;
}

- (void)resetAnimations {
    // If the app goes to the background, returning it to the foreground causes the animation to stop (even though it's not explicitly stopped by our code). Resetting the animation seems to kick it back into gear.
    if (self.isAnimating) {
        [self stopAnimating];
        [self startAnimating];
    }
}

- (void)setAnimating:(BOOL)animate {
    (animate ? [self startAnimating] : [self stopAnimating]);
}

- (void)startAnimating {
    if (self.isAnimating)
        return;
    
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.keyPath = @"transform.rotation";
    animation.duration = 4.f;
    animation.fromValue = @(0.f);
    animation.toValue = @(2 * M_PI);
    animation.repeatCount = INFINITY;
    [self.progressLayer addAnimation:animation forKey:RotationAnimationKey];
    
    CABasicAnimation *secondAnimation = [CABasicAnimation animation];
    secondAnimation.keyPath = @"transform.rotation";
    secondAnimation.duration = 4.f;
    secondAnimation.fromValue = @(0.f);
    secondAnimation.toValue = @(2 * M_PI);
    secondAnimation.repeatCount = INFINITY;
    [self.secondLayer addAnimation:animation forKey:RotationAnimationKey];
    
    CABasicAnimation *headAnimation = [CABasicAnimation animation];
    headAnimation.keyPath = @"strokeStart";
    headAnimation.duration = 1.f;
    headAnimation.fromValue = @(0.f);
    headAnimation.toValue = @(0.25f);
    headAnimation.timingFunction = self.timingFunction;
    
    
    CABasicAnimation *tailAnimation = [CABasicAnimation animation];
    tailAnimation.keyPath = @"strokeEnd";
    tailAnimation.duration = 1.f;
    tailAnimation.fromValue = @(0.f);
    tailAnimation.toValue = @(1.f);
    tailAnimation.timingFunction = self.timingFunction;
    
    
    CABasicAnimation *endHeadAnimation = [CABasicAnimation animation];
    endHeadAnimation.keyPath = @"strokeStart";
    endHeadAnimation.beginTime = 1.f;
    endHeadAnimation.duration = 0.5f;
    endHeadAnimation.fromValue = @(0.25f);
    endHeadAnimation.toValue = @(1.f);
    endHeadAnimation.timingFunction = self.timingFunction;
    
    CABasicAnimation *endTailAnimation = [CABasicAnimation animation];
    endTailAnimation.keyPath = @"strokeEnd";
    endTailAnimation.beginTime = 1.f;
    endTailAnimation.duration = 0.5f;
    endTailAnimation.fromValue = @(1.f);
    endTailAnimation.toValue = @(1.f);
    endTailAnimation.timingFunction = self.timingFunction;
    
    CABasicAnimation *headAnimation2 = [CABasicAnimation animation];
    headAnimation2.keyPath = @"strokeStart";
    headAnimation2.duration = 1.f;
    headAnimation2.fromValue = @(1.f);
    headAnimation2.toValue = @(0.f);
    headAnimation2.timingFunction = self.timingFunction;
    
    CABasicAnimation *tailAnimation2 = [CABasicAnimation animation];
    tailAnimation2.keyPath = @"strokeEnd";
    tailAnimation2.duration = 1.f;
    tailAnimation2.fromValue = @(1.f);
    tailAnimation2.toValue = @(0.75f);
    tailAnimation2.timingFunction = self.timingFunction;
    
    
    CABasicAnimation *endHeadAnimation2 = [CABasicAnimation animation];
    endHeadAnimation2.keyPath = @"strokeStart";
    endHeadAnimation2.beginTime = 1.f;
    endHeadAnimation2.duration = 0.5f;
    endHeadAnimation2.fromValue = @(0.f);
    endHeadAnimation2.toValue = @(0.f);
    endHeadAnimation2.timingFunction = self.timingFunction;
    
    CABasicAnimation *endTailAnimation2 = [CABasicAnimation animation];
    endTailAnimation2.keyPath = @"strokeEnd";
    endTailAnimation2.beginTime = 1.f;
    endTailAnimation2.duration = 0.5f;
    endTailAnimation2.fromValue = @(0.75f);
    endTailAnimation2.toValue = @(0.f);
    endTailAnimation2.timingFunction = self.timingFunction;
    
    CAAnimationGroup *animations = [CAAnimationGroup animation];
    [animations setDuration:1.5f];
    [animations setAnimations:@[headAnimation, tailAnimation, endHeadAnimation, endTailAnimation]];
    animations.repeatCount = INFINITY;
    
    CAAnimationGroup *seAnimations = [CAAnimationGroup animation];
    [seAnimations setDuration:1.5f];
    [seAnimations setAnimations:@[headAnimation2, tailAnimation2, endHeadAnimation2, endTailAnimation2]];
    seAnimations.repeatCount = INFINITY;
    
    [self.progressLayer addAnimation:animations forKey:StrokeAnimationKey];
    [self.secondLayer addAnimation:seAnimations forKey:StrokeAnimationKey];
    
    
    self.isAnimating = true;
    
    if (self.hidesWhenStopped) {
        self.hidden = NO;
    }
}

- (void)stopAnimating {
    if (!self.isAnimating)
        return;
    
    [self.progressLayer removeAnimationForKey:RotationAnimationKey];
    [self.progressLayer removeAnimationForKey:StrokeAnimationKey];
    [self.secondLayer removeAnimationForKey:RotationAnimationKey];
    [self.secondLayer removeAnimationForKey:StrokeAnimationKey];
    self.isAnimating = false;
    
    if (self.hidesWhenStopped) {
        self.hidden = YES;
    }
}

#pragma mark - Private

- (void)updatePath {
    CGPoint center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    CGFloat radius = MIN(CGRectGetWidth(self.bounds) / 2, CGRectGetHeight(self.bounds) / 2) - self.progressLayer.lineWidth / 2;
    CGFloat secondRadius = radius - 2.f * self.lineWidth;
    CGFloat startAngle = (CGFloat)(0);
    CGFloat endAngle = (CGFloat)(2*M_PI);
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
    UIBezierPath *secondPath = [UIBezierPath bezierPathWithArcCenter:center radius:secondRadius startAngle:startAngle endAngle:endAngle clockwise:YES];
    self.progressLayer.path = path.CGPath;
    self.secondLayer.path = secondPath.CGPath;
    
    self.progressLayer.strokeStart = 0.f;
    self.progressLayer.strokeEnd = 0.f;
    self.secondLayer.strokeStart = 1.f;
    self.secondLayer.strokeEnd = 1.f;
}

#pragma mark - Properties

- (CAShapeLayer *)progressLayer {
    if (!_progressLayer) {
        _progressLayer = [CAShapeLayer layer];
        _progressLayer.strokeColor = self.tintColor.CGColor;
        _progressLayer.fillColor = nil;
        _progressLayer.lineWidth = 1.5f;
    }
    return _progressLayer;
}

- (CAShapeLayer *)secondLayer {
    if (!_secondLayer) {
        _secondLayer = [CAShapeLayer layer];
        _secondLayer.strokeColor = self.tintColor.CGColor;
        _secondLayer.fillColor = nil;
        _secondLayer.lineWidth = 1.5f;
    }
    return _secondLayer;
}

- (BOOL)isAnimating {
    return _isAnimating;
}

- (CGFloat)lineWidth {
    return self.progressLayer.lineWidth;
}

- (void)setLineWidth:(CGFloat)lineWidth {
    self.progressLayer.lineWidth = lineWidth;
    self.secondLayer.lineWidth = lineWidth;
    [self updatePath];
}

- (void)setHidesWhenStopped:(BOOL)hidesWhenStopped {
    _hidesWhenStopped = hidesWhenStopped;
    self.hidden = !self.isAnimating && hidesWhenStopped;
}

@end
