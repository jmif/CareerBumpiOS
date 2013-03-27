//
//  CBStudentViewController.h
//  CareerBump
//
//  Created by Joseph Mifsud on 3/20/13.
//  Copyright (c) 2013 Joseph Mifsud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DropboxSDK/DropboxSDK.h>
#import <FPPicker/FPPicker.h>
#import <FPPicker/FPPickerController.h>
#import <FPPicker/FPSaveController.h>
#import <FPPicker/FPExternalHeaders.h>
#import <FPPicker/FPConstants.h>


@interface CBStudentViewController : UIViewController < FPPickerDelegate >

@property (weak, nonatomic) IBOutlet UIButton *addResumeButton;

@property (strong, nonatomic) IBOutlet UILabel *resumeAlert;


@end
