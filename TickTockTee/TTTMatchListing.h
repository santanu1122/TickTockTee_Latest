//
//  TTTMatchListing.h
//  TickTockTee
//
//  Created by macbook_ms on 26/02/14.
//  Copyright (c) 2014 com.esolz.TickTockTee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTTGlobalViewController.h"


@interface TTTMatchListing : TTTGlobalViewController
@property (strong, nonatomic) IBOutlet UIImageView *tick1;
@property (strong, nonatomic) IBOutlet UIImageView *tick2;
@property (strong, nonatomic) IBOutlet UIImageView *tick3;
@property (strong, nonatomic) NSString *ParamUserID;
@end
