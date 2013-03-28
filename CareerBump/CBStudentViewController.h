//
//  CBStudentViewController.h
//  CareerBump
//
//  Created by Joseph Mifsud on 3/20/13.
//  Copyright (c) 2013 Joseph Mifsud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DropboxSDK/DropboxSDK.h>

DBRestClient *restClient;

@interface CBStudentViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *addResumeButton;

@property (strong, nonatomic) IBOutlet UILabel *resumeAlert;


@end
