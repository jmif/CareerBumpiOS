//
//  CBCircularLoadingView.m
//  CareerBump
//
//  Created by Joseph Mifsud on 3/21/13.
//  Copyright (c) 2013 Joseph Mifsud. All rights reserved.
//

static const CGFloat kBigCircleDiameter = 20.0;
static const CGFloat kSmallCircleDiameter = 10.0;
static const CGFloat kBigCircleRadius = kBigCircleDiameter / 2;
static const CGFloat kSmallCircleRadius = kSmallCircleDiameter / 2;

#import "CBCircularLoadingView.h"

#import <QuartzCore/QuartzCore.h>
#import <math.h>

@interface CBCircularLoadingView()

@property CGFloat borderCircleDiameter;
@property NSUInteger numberOfCircles;

@property NSMutableArray *circleLayers;
@property NSInteger activeCircle;
@property BOOL animating;

@end

@implementation CBCircularLoadingView

- (void)layoutSubviews
{
    self.activeCircle = 0;
    self.animating = NO;
    
    for (CAShapeLayer *layer in self.circleLayers)
        [layer removeFromSuperlayer];
    [self.circleLayers removeAllObjects];
    
    if (self.frame.size.height > self.frame.size.width) {
        self.borderCircleDiameter = self.frame.size.width;
    } else {
        self.borderCircleDiameter = self.frame.size.height;
    }
    
    self.borderCircleDiameter = self.borderCircleDiameter - kBigCircleDiameter;
    CGFloat circumference = M_PI * self.borderCircleDiameter;
    CGFloat radius = self.borderCircleDiameter / 2;
    self.numberOfCircles = circumference / kBigCircleDiameter;
    self.circleLayers = [NSMutableArray array];
    
    CGFloat radiansPerSlice = 2 * M_PI / self.numberOfCircles;
    for (int cir = 0; cir < self.numberOfCircles; cir++) {
        if (cir % 2 != 0)
            continue;
        
        CGFloat radians = cir * radiansPerSlice;
        CGFloat xCenter = self.frame.size.width / 2 + cos(radians) * radius;
        CGFloat yCenter = self.frame.size.height / 2 + sin(radians) * radius;
        
        UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, kBigCircleDiameter, kBigCircleDiameter)];
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.frame = CGRectMake(xCenter - kBigCircleRadius, yCenter - kBigCircleRadius, kBigCircleDiameter, kBigCircleDiameter);
        layer.path = [path CGPath];
        layer.fillColor = [self.baseColor CGColor];
        
        [self.layer addSublayer:layer];
        [self.circleLayers addObject:layer];
    }
}

- (void)startAnimating
{
    if (self.animating == NO) {
        self.animating = YES;
        [self animateNextStep];
    }
}

- (void)stopAnimating
{
    self.animating = NO;
}

- (void)animateNextStep
{
    CAShapeLayer *currentCircle = [self.circleLayers objectAtIndex:self.activeCircle];
    
    self.activeCircle += 1;
    if (self.activeCircle == self.circleLayers.count) {
        self.activeCircle = 0;
    }
    
    CAShapeLayer *nextCircle = [self.circleLayers objectAtIndex:self.activeCircle];
    
    CABasicAnimation *curAnimation = [CABasicAnimation animationWithKeyPath:@"fillColor"]; // I changed the animation pointer name, but don't worry.
    curAnimation.toValue = (id) [UIColor clearColor].CGColor;
    curAnimation.duration = 0.35;
    curAnimation.removedOnCompletion = YES;
    [currentCircle addAnimation:curAnimation forKey:@"currentStrokeColor"];

    CABasicAnimation *nextAnimation = [CABasicAnimation animationWithKeyPath:@"fillColor"]; // I changed the animation pointer name, but don't worry.
    nextAnimation.toValue = (id) self.baseColor.CGColor;
    nextAnimation.duration = 0.12;
    nextAnimation.delegate = self;
    nextAnimation.removedOnCompletion = YES;
    [nextCircle addAnimation:nextAnimation forKey:@"nextStrokeColor"];
    
    
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (self.animating)
        [self animateNextStep];
}

@end
