//
//  TTTProfileViewController.h
//  TickTockTee
//
//  Created by Esolz Tech on 29/03/14.
//  Copyright (c) 2014 com.esolz.TickTockTee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTTGlobalViewController.h"

@interface TTTProfileViewController :TTTGlobalViewController<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet UITableView *profileTable;
@property (strong, nonatomic) IBOutlet UILabel *profileName;
@property (strong, nonatomic) IBOutlet UIImageView *profileImage;
@property (strong, nonatomic) IBOutlet UIImageView *holeProfileImage;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *indicatorOnProfile;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *indicatorOnScreen;

@property (strong, nonatomic) IBOutlet UIView *viewOnProfileImage;
@property (strong, nonatomic) IBOutlet UILabel *profilePlace;
@property (strong, nonatomic) IBOutlet UILabel *profileTTHCP;
@property (strong, nonatomic) IBOutlet UILabel *profilePoints;
@property (strong, nonatomic) IBOutlet UIButton *previous;
@property (strong, nonatomic) IBOutlet UIButton *next;
@property (strong, nonatomic) IBOutlet UIButton *unflowButton;
@property (strong, nonatomic) IBOutlet UIButton *messagebutton;
@property (strong, nonatomic) IBOutlet UIView *sideView;
@property (strong, nonatomic) IBOutlet UIView *footerView;
@property (strong, nonatomic) IBOutlet UIView *screenView;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollMenu;

@property (strong, nonatomic) IBOutlet UIButton *plusButton;

@property (strong, nonatomic) IBOutlet UILabel *lblFriends;
@property (strong, nonatomic) IBOutlet UILabel *lblPhotos;
@property (strong, nonatomic) IBOutlet UILabel *MainLabel;


@property(strong,nonatomic) NSDictionary *dict;
//USERID and LOGGEDIN USERID 
@property (strong,nonatomic)NSString *userId;
@property (strong,nonatomic)NSString *loggedInUserid;
- (IBAction)unflowAction:(id)sender;
- (IBAction)messageAction:(id)sender;
- (IBAction)previousAction:(id)sender;
- (IBAction)nextAction:(id)sender;

- (IBAction)plusClickedAction:(id)sender;

@property(nonatomic, strong) NSString *ParamprofileViewerId;
@property (strong,nonatomic)NSString *mainLabelString;

@end
