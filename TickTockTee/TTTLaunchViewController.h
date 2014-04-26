//
//  TTTLaunchViewController.h
//  Ticktocktee
//
//  Created by Joydip Pal on 17/02/14.
//  Copyright (c) 2014 com.esolz.Ticktocktee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTTSigninViewController.h"
#import "TTTGlobalViewController.h"

@interface TTTLaunchViewController : TTTGlobalViewController
@property (strong, nonatomic) TTTSigninViewController *viewController;

@property (nonatomic,retain) UINavigationController *Navigation;
@property(nonatomic, retain) NSString *FBAccessToken;
@end
