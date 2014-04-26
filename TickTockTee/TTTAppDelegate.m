//
//  TTTAppDelegate.m
//  Ticktocktee
//
//  Created by Iphone_2 on 17/02/14.
//  Copyright (c) 2014 com.esolz.Ticktocktee. All rights reserved.
//

#import "TTTAppDelegate.h"

#import "TTTViewController.h"

@implementation TTTAppDelegate
@synthesize Navigation = _Navigation;
@synthesize deviceTokenString;

<<<<<<< HEAD
// Abdur   Rahim
// from    souvik
// jayati  saha
=======

// Abdur Rahim
// from  souvik
// jayati saha
>>>>>>> FETCH_HEAD


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
   
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        self.viewController = [[TTTViewController alloc] initWithNibName:@"TTTViewController_iPhone" bundle:nil];
      
        
    } else {
        self.viewController = [[TTTViewController alloc] initWithNibName:@"TTTViewController_iPad" bundle:nil];
    }
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];

    _Navigation = [[UINavigationController alloc] initWithRootViewController:self.viewController];
     [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    self.window.rootViewController = _Navigation;
    [self.window makeKeyAndVisible];
    return YES;
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
   
    return [FBSession.activeSession handleOpenURL:url];
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)devToken
{
    deviceTokenString = [[[[devToken description]
                           stringByReplacingOccurrencesOfString:@"<"withString:@""]
                          stringByReplacingOccurrencesOfString:@">" withString:@""]
                         stringByReplacingOccurrencesOfString: @" " withString: @""];
    
    


}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}
- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    NSUInteger orientations = UIInterfaceOrientationMaskAll;
    
    if (self.window.rootViewController)
    {
        UIViewController *presented = [[(UINavigationController *)self.window.rootViewController viewControllers] lastObject];
        orientations = [presented supportedInterfaceOrientations];
    }
    return orientations;
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    //UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"The Device Tocen" message:@"Error" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//    [alert show];
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

@end
