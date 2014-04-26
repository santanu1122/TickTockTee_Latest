//
//  TTTCourseOverviewViewController.h
//  TickTockTee
//
//  Created by Esolz_Mac on 10/04/14.
//  Copyright (c) 2014 com.esolz.TickTockTee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTTGlobalViewController.h"
#import "TTTGlobalMethods.h"
@interface TTTCourseOverviewViewController : TTTGlobalViewController<UIScrollViewDelegate>
@property (strong, nonatomic) IBOutlet UIView *ScreenView;
@property (strong, nonatomic) IBOutlet UIView *dataview;
@property (strong, nonatomic) IBOutlet UIScrollView *scroll;
@property (strong,nonatomic) NSString *courseid;
@property (strong,nonatomic) NSString *paramid;
@property (strong,nonatomic) NSMutableDictionary *overviewlist;
@property (strong, nonatomic) IBOutlet UILabel *page_title;
- (IBAction)backButtonClick:(id)sender;
@end
