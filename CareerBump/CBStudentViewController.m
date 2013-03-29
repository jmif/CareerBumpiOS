//
//  CBStudentViewController.m
//  CareerBump
//
//  Created by Joseph Mifsud on 3/20/13.
//  Copyright (c) 2013 Joseph Mifsud. All rights reserved.
//

#import "CBStudentViewController.h"
#import "CBReceiveResumeViewController.h"

#import <DropboxSDK/DropboxSDK.h>
#import <AWSiOSSDK/S3/AmazonS3Client.h>
#import "SVProgressHUD.h"

@interface CBStudentViewController () <DBRestClientDelegate>

@property (strong, nonatomic) AmazonS3Client *s3Client;

@end

@implementation CBStudentViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.s3Client = [[AmazonS3Client alloc] initWithAccessKey:AWS_RESUME_UPLOAD_ACCESS_KEY withSecretKey:AWS_RESUME_UPLOAD_SECRET_KEY];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didPressAddResumeButton:(id)sender {
    if (![[DBSession sharedSession] isLinked]) {
        [[DBSession sharedSession] linkFromController:self];
    }
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    
    [[self restClient] loadFile:@"/sampleResume.doc" intoPath:[self getDocumentPath]];

    [_resumeAlert setText:@"File ready"];
    
}

- (DBRestClient *)restClient {
    if (!restClient) {
        restClient =
        [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
        restClient.delegate = self;
    }
    return restClient;
}


- (void)restClient:(DBRestClient*)client loadedFile:(NSString*)localPath {
    
    NSLog(@"File loaded into path: %@", localPath);
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        NSString *key = [NSString stringWithFormat:@"%f.doc", [[NSDate date] timeIntervalSince1970]];
        S3PutObjectRequest *por = [[S3PutObjectRequest alloc] initWithKey:key
                                                                 inBucket:AWS_RESUME_BUCKET];
        por.data = [NSData dataWithContentsOfFile:localPath];
        
        [self.s3Client putObject:por];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
    });
}

- (void)restClient:(DBRestClient*)client loadFileFailedWithError:(NSError*)error {
    [SVProgressHUD dismiss];
    NSLog(@"There was an error loading the file - %@", error);
}

-(NSString *)getDocumentPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *path = [documentDirectory stringByAppendingPathComponent:@"filepathDropbox"];
    return path;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"studentSendResume"]) {
        CBReceiveResumeViewController *vc = [segue destinationViewController];
        vc.student = YES;
    }
}

# pragma  mark - Private methods

- (NSString*)getMimeTypeForFileAtPath:(NSString*) path
{
    NSString* fullPath = [path stringByExpandingTildeInPath];
    NSURL* fileUrl = [NSURL fileURLWithPath:fullPath];
    //NSURLRequest* fileUrlRequest = [[NSURLRequest alloc] initWithURL:fileUrl];
    NSURLRequest* fileUrlRequest = [[NSURLRequest alloc] initWithURL:fileUrl cachePolicy:NSURLCacheStorageNotAllowed timeoutInterval:.1];
    
    NSError* error = nil;
    NSURLResponse* response = nil;
    [NSURLConnection sendSynchronousRequest:fileUrlRequest returningResponse:&response error:&error];

    return response.MIMEType;
}
@end
