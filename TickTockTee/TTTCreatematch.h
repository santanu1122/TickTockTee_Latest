//
//  TTTCreatematch.h
//  TickTockTee
//
//  Created by macbook_ms on 26/02/14.
//  Copyright (c) 2014 com.esolz.TickTockTee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTTGlobalViewController.h"

@interface TTTCreatematch :TTTGlobalViewController
@property (strong, nonatomic) IBOutlet UITextField *matchNameTxt;
@property (strong, nonatomic) IBOutlet UILabel *DescriotionlanleTxt;

@property (strong, nonatomic) IBOutlet UILabel *CourceLable;
@property (strong, nonatomic) IBOutlet UILabel *teaBoxLbl;
@property (strong, nonatomic) IBOutlet UILabel *DateAndTimeLbl;
@property (strong, nonatomic) IBOutlet UILabel *invitefndLable;
@property (assign) BOOL isCommingfromLocation;
@property (nonatomic ,assign) BOOL IsComingFromActivityScreen;


//Propary TO Collect data  from other Class

@property (nonatomic, retain) NSString *courseId;
@property (nonatomic, retain) NSString *CourseName;



@end
