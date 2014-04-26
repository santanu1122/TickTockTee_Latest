//
//  TTTScoreBord.h
//  TickTockTee
//
//  Created by macbook_ms on 12/03/14.
//  Copyright (c) 2014 com.esolz.TickTockTee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTTGlobalViewController.h"
#import "TTTGlobalMethods.h"

@interface TTTScoreBord : TTTGlobalViewController
@property (strong, nonatomic) IBOutlet UIScrollView *rounStateScroll;
@property (strong, nonatomic) IBOutlet UILabel *RounStatelable;
@property (strong, nonatomic) IBOutlet UILabel *roundState;
@property (strong, nonatomic) NSString *Otheruserid;

@property (strong, nonatomic) NSString *matchID;

- (IBAction)BackTopotred:(id)sender;


@property (strong, nonatomic) IBOutlet UIView *LandScapebackview;
@property (strong, nonatomic) IBOutlet UIImageView *LandScapeuserimage;
@property (strong, nonatomic) IBOutlet UIImageView *LandScapeBackGrond;
//Land Scape iPhone 5;
@property (strong, nonatomic) IBOutlet UILabel *LengthLblLandscape5;
@property (strong, nonatomic) IBOutlet UILabel *HandicapLablelandScapp5;

@property (strong, nonatomic) IBOutlet UILabel *Parlableforlandscapre5;

@property (strong, nonatomic) IBOutlet UILabel *HolelableForlandScape5;
@property (strong, nonatomic) IBOutlet UILabel *ScoreLblLand5;

@property (strong, nonatomic) IBOutlet UIImageView *userImageLand5;

@property (strong, nonatomic) IBOutlet UIImageView *profilePicimageLand5;

@property (strong, nonatomic) IBOutlet UIView *Backviewland5;

@property (strong, nonatomic) IBOutlet UILabel *ScoreLand5;

@property (strong, nonatomic) IBOutlet UILabel *TTThcpLand5;
@property (strong, nonatomic) IBOutlet UILabel *MatchHcpland5;
@property (strong, nonatomic) IBOutlet UILabel *ToparLand5;

@property (strong, nonatomic) IBOutlet UILabel *nameForLand5;

@property (strong, nonatomic) IBOutlet UILabel *courseforlandScape;


//Score bar lbls Bar For IPhone 4


@property (strong, nonatomic) IBOutlet UILabel *HoletxtLbl;

@property (strong, nonatomic) IBOutlet UILabel *holetxtlbl;

@property (strong, nonatomic) IBOutlet UILabel *holelengthtext;

@property (strong, nonatomic) IBOutlet UILabel *handtxtlbl;

@property (strong, nonatomic) IBOutlet UILabel *Scoretxtlbl;


@property (strong, nonatomic) IBOutlet UILabel *TTTHcpLand4;

@property (strong, nonatomic) IBOutlet UILabel *MatchHcpland4;
@property (strong, nonatomic) IBOutlet UILabel *ToparLblLand4;

@property (strong, nonatomic) IBOutlet UILabel *ScoreLblland4;
@property (strong, nonatomic) IBOutlet UIImageView *mainBackgrondimageLand4;

@property (strong, nonatomic) IBOutlet UIImageView *UserImageLand4;

@property (strong, nonatomic) IBOutlet UIView *UseBackViewLand4;

@property (strong, nonatomic) IBOutlet UILabel *NmaelandScape4;
@property (strong, nonatomic) IBOutlet UILabel *CourselablelandScape4;

//Vieweid
@property (strong, nonatomic) NSString *paramId;



@end
