//
//  TTTAppDelegate.h
//  Ticktocktee
//
//  Created by Iphone_2 on 17/02/14.
//  Copyright (c) 2014 com.esolz.Ticktocktee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTTActivityStreem.h"
#import <FacebookSDK/FacebookSDK.h>

@class TTTViewController;


@interface TTTAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) TTTViewController *viewController;

@property (nonatomic,retain) UINavigationController *Navigation;
@property (nonatomic, strong) NSString *deviceTokenString;
@property (nonatomic, strong) TTTActivityStreem *ActivityStream;
@property (strong, nonatomic) FBSession *session;


@end
