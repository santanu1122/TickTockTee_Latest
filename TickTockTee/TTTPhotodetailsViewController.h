//
//  TTTPhotodetailsViewController.h
//  TickTockTee
//
//  Created by Esolz_Mac on 28/03/14.
//  Copyright (c) 2014 com.esolz.TickTockTee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTTGlobalViewController.h"
#import "TTTGlobalMethods.h"
@interface TTTPhotodetailsViewController :TTTGlobalViewController
@property (strong, nonatomic) NSMutableArray *ParamPhotoArry;
@property (strong, nonatomic) NSString *OtheruserID;
@property (strong, nonatomic) NSString *ClickphotoId;

@property (strong, nonatomic) IBOutlet UIView *backview;

@end
