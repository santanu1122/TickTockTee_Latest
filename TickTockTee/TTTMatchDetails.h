//
//  TTTMatchDetails.h
//  TickTockTee
//
//  Created by macbook_ms on 10/03/14.
//  Copyright (c) 2014 com.esolz.TickTockTee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTTGlobalMethods.h"
#import "TTTGlobalViewController.h"

@interface TTTMatchDetails : TTTGlobalViewController
@property (nonatomic, strong) NSString *matchID;
@property (nonatomic, strong) NSString *ParamViewerID;
@property (nonatomic, strong) NSString *Commsfromcretematch;
@property (assign) BOOL Iscommingfromcreatematch;



@end
