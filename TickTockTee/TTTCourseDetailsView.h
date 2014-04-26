//
//  TTTCourseDetailsView.h
//  TickTockTee
//
//  Created by macbook_ms on 10/04/14.
//  Copyright (c) 2014 com.esolz.TickTockTee. All rights reserved.
//

#import "TTTGlobalViewController.h"

@interface TTTCourseDetailsView : TTTGlobalViewController
@property (nonatomic, strong) NSString *ParamViewerid;
@property (nonatomic, strong) NSString *CourseID;
@property (strong, nonatomic) IBOutlet UIButton *Showtotalfollower;
- (IBAction)TotalFollowerlist:(id)sender;

@end
