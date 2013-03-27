//
//  CBStudentViewController.m
//  CareerBump
//
//  Created by Joseph Mifsud on 3/20/13.
//  Copyright (c) 2013 Joseph Mifsud. All rights reserved.
//

#import "CBStudentViewController.h"

#import <DropboxSDK/DropboxSDK.h>
#import <FPPicker/FPPicker.h>
#import <FPPicker/FPPickerController.h>
#import <FPPicker/FPSaveController.h>
#import <FPPicker/FPExternalHeaders.h>
#import <FPPicker/FPConstants.h>

@interface CBStudentViewController ()

@end

@implementation CBStudentViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didPressAddResumeButton:(id)sender {
    if (![[DBSession sharedSession] isLinked]) {
        [[DBSession sharedSession] linkFromController:self];
    }
    
    [_resumeAlert setText:@"You're Awesome!"];

    
    // To create the object
    FPPickerController *fpController = [[FPPickerController alloc] init];
    
    // Set the delegate
    fpController.fpdelegate = self;
    
    // Ask for specific data types. (Optional) Default is all files.
    fpController.dataTypes = [NSArray arrayWithObjects:@"text/plain", nil];
    
    // Select and order the sources (Optional) Default is all sources
    fpController.sourceNames = [[NSArray alloc] initWithObjects: FPSourceImagesearch, FPSourceDropbox, nil];
    
    // You can set some of the in built Camera properties as you would with UIImagePicker
    fpController.allowsEditing = NO;
    
    // Display it.
    [self presentViewController:fpController animated:YES completion:nil];
    
}

- (void)FPPickerController:(FPPickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSLog(@"FILE CHOSEN: %@", info);
}

- (void)FPPickerController:(FPPickerController *)picker didPickMediaWithInfo:(NSDictionary *)info{}

- (void)FPPickerControllerDidCancel:(FPPickerController *)picker{
    NSLog(@"FP Cancelled Open");
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
