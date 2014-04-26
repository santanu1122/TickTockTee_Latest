//
//  TTTAchievementStatisticViewController.h
//  TickTockTee
//
//  Created by Esolz Tech on 21/03/14.
//  Copyright (c) 2014 com.esolz.TickTockTee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTTGlobalViewController.h"
#import "TTTImageDownLoader.h"
@interface TTTAchievementStatisticViewController : TTTGlobalViewController

@property (strong, nonatomic) IBOutlet UIScrollView *activityScroll;
@property (strong, nonatomic) IBOutlet UIView *upView;
@property (strong, nonatomic) IBOutlet UIView *ScreenView;
@property (strong, nonatomic) IBOutlet UIView *MenuView;
@property (strong, nonatomic) IBOutlet UILabel *dropDownMenu;
@property (strong, nonatomic) IBOutlet UIView *dropDownMenus;
@property (strong, nonatomic) IBOutlet UIView *footerView;

@property (strong, nonatomic) NSString *ParamViewid;
@property (strong, nonatomic) NSString *ParamloginviewID;


@end


