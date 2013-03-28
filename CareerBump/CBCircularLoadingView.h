//
//  CBCircularLoadingView.h
//  CareerBump
//
//  Created by Joseph Mifsud on 3/21/13.
//  Copyright (c) 2013 Joseph Mifsud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBCircularLoadingView : UIView

@property (strong, nonatomic) UIColor *baseColor;
@property (strong, nonatomic) UIColor *activeColor;

- (void)startAnimating;
- (void)stopAnimating;

@end
