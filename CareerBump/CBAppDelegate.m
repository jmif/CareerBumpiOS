//
//  CBAppDelegate.m
//  CareerBump
//
//  Created by Joseph Mifsud on 3/20/13.
//  Copyright (c) 2013 Joseph Mifsud. All rights reserved.
//

#import "CBAppDelegate.h"
#import "PNDefaultConfiguration.h"

#import "BumpClient.h"
#import <DropboxSDK/DropboxSDK.h>
#import <AWSiOSSDK/AmazonErrorHandler.h>

@implementation CBAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [AmazonErrorHandler shouldNotThrowExceptions];
    
    // Dropbox
    DBSession* dbSession = [[DBSession alloc] initWithAppKey:@"q29fuzqzncr6t8w"
                                                   appSecret:@"btyqk4cyev3jzj9"
                                                        root:kDBRootDropbox];
    [DBSession setSharedSession:dbSession];
    
    // PubNub
    [PubNub setConfiguration:[PNConfiguration configurationWithPublishKey:@"pub-c-f825e8b0-06be-468f-b087-604263304043"
                                    subscribeKey:@"sub-c-b6a806d8-9746-11e2-8cf1-12313f022c90"
                                       secretKey:@"sec-c-NDc5OGIwMDYtOWIwOC00NTdjLThjZjctNjYwZWMyZDJhNjA1"]];
    
    // userID is a string that you could use as the user's name, or an ID that is semantic within your environment
    [BumpClient configureWithAPIKey:@"43c2ce3f407d49f18a09a80e2d95e77c" andUserID:[[UIDevice currentDevice] name]];
    [[BumpClient sharedClient] setBumpable:NO];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    if ([[DBSession sharedSession] handleOpenURL:url]) {
        if ([[DBSession sharedSession] isLinked]) {
            NSLog(@"App linked successfully!");
            // At this point you can start making API calls
        }
        return YES;
    }
    // Add whatever other url handling code your app requires here
    return NO;
}

@end
