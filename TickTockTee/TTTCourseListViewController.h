//
//  TTTCourseListViewController.h
//  TickTockTee
//
//  Created by Esolz Tech on 07/04/14.
//  Copyright (c) 2014 com.esolz.TickTockTee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTTGlobalViewController.h"
@interface TTTCourseListViewController :TTTGlobalViewController
@property(strong,nonatomic) NSMutableArray *tableContent;
@property (strong, nonatomic) IBOutlet UIView *menuView;
@property (strong, nonatomic) IBOutlet UIView *screenView;

@end
