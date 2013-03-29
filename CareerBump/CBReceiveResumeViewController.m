//
//  CBReceiveResumeViewController.m
//  CareerBump
//
//  Created by Joseph Mifsud on 3/20/13.
//  Copyright (c) 2013 Joseph Mifsud. All rights reserved.
//

#import "CBReceiveResumeViewController.h"
#import "CBCircularLoadingView.h"

#import "BumpClient.h"
#import <QuartzCore/QuartzCore.h>

@interface CBReceiveResumeViewController ()

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIImageView *bumpLogo;

@property (weak, nonatomic) IBOutlet UIView *errorMessageView;
@property (weak, nonatomic) IBOutlet UILabel *tryAgainLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *errorMessageWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *errorMessageHeightConstraint;
@property CGFloat originalErrorMessageWidthConstraint;
@property CGFloat originalErrorMessageHeightConstraint;

@property (weak, nonatomic) IBOutlet CBCircularLoadingView *loadingView;
@property BOOL once;

@end

@implementation CBReceiveResumeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
    self.errorMessageView.alpha = 0.0;
    self.loadingView.baseColor = [UIColor colorWithRed:136/255.0 green:229/255.0 blue:252/255.0 alpha:1.0];
    self.loadingView.hidden = YES;
    self.errorMessageView.hidden = YES;
    
    [[BumpClient sharedClient] setBumpable:YES];
    
    [[BumpClient sharedClient] setBumpEventBlock:^(bump_event event) {
        switch (event) {
            case BUMP_EVENT_BUMP:
                self.errorMessageView.alpha = 0.0;
                self.loadingView.hidden = NO;
                [self.loadingView startAnimating];
                
                break;
            case BUMP_EVENT_NO_MATCH:
                [self.loadingView stopAnimating];
                self.loadingView.hidden = YES;
                
                self.originalErrorMessageWidthConstraint = self.errorMessageWidthConstraint.constant;
                self.originalErrorMessageHeightConstraint = self.errorMessageHeightConstraint.constant;
                self.errorMessageHeightConstraint.constant = 0;
                self.errorMessageWidthConstraint.constant = 0;
                [self.view layoutIfNeeded];
                
                self.errorMessageHeightConstraint.constant = self.originalErrorMessageHeightConstraint;
                self.errorMessageWidthConstraint.constant = self.originalErrorMessageWidthConstraint;
                [UIView animateWithDuration:0.18 animations:^{
                    self.errorMessageView.alpha = 1.0;
                    [self.view layoutIfNeeded];
                } completion:^(BOOL finished) {
                    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
                    animation.beginTime = CACurrentMediaTime() + 0.3;
                    animation.duration          = 0.15;
                    animation.repeatCount       = 2;
                    animation.autoreverses      = YES;
                    animation.fromValue         = [NSNumber numberWithFloat:1.0];
                    animation.toValue           = [NSNumber numberWithFloat:0.2];
                    
                    
                    [self.tryAgainLabel.layer addAnimation:animation forKey:@"pulsateText"];
                }];
                
                
                if (self.once == NO) {
                    self.once = YES;
                    [PubNub sendMessage:@"Neil Sood|University of Michigan|Sophomore|50 million"
                              toChannel:[PNChannel channelWithName:@"resume-send"]];
                }
                
                break;
        }
    }];
    
    [[BumpClient sharedClient] setMatchBlock:^(BumpChannelID channel) {
        self.loadingView.hidden = YES;
        NSLog(@"Matched with user: %@", [[BumpClient sharedClient] userIDForChannel:channel]);
        [[BumpClient sharedClient] confirmMatch:YES onChannel:channel];
        
        if (self.student) {
            [[BumpClient sharedClient] sendData:[[NSString stringWithFormat:@"Neil Sood|University of Michigan|Sophomore|50 million"] dataUsingEncoding:NSUTF8StringEncoding]
                                      toChannel:channel];
        }
    }];
    
    [[BumpClient sharedClient] setDataReceivedBlock:^(BumpChannelID channel, NSData *data) {
        NSLog(@"Data received from %@: %@",
              [[BumpClient sharedClient] userIDForChannel:channel],
              [NSString stringWithCString:[data bytes] encoding:NSUTF8StringEncoding]);
        if (self.once == NO) {
            self.once = YES;
            [PubNub sendMessage:@"Neil Sood|University of Michigan|Sophomore|50 million"
                  toChannel:[PNChannel channelWithName:@"resume-send"]];
        }

    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [PubNub subscribeOnChannel:[PNChannel channelWithName:@"resume-send"]];
    self.once = NO;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    CGRect frame = self.containerView.frame;
    frame.origin.y = 25;
    self.containerView.frame = frame;
    
    [UIView animateWithDuration:0.2 animations:^{
        CGRect newFrame = self.view.frame;
        newFrame.origin.y = 0;
        
        self.containerView.frame = newFrame;
    }];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[BumpClient sharedClient] setBumpable:NO];
}



- (IBAction)didPressCancelButton:(id)sender {
    [UIView animateWithDuration:0.75
                     animations:^{
                         CATransition* transition = [CATransition animation];
                         transition.duration = 0.2;
                         transition.type = kCATransitionFade;
                         
                         [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
                     }];
    
    [self.navigationController popViewControllerAnimated:NO];
}

@end
