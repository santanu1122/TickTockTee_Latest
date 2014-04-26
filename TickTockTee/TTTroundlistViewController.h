//
//  TTTroundlistViewController.h
//  TickTockTee
//
//  Created by Esolz_Mac on 24/03/14.
//  Copyright (c) 2014 com.esolz.TickTockTee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTTGlobalViewController.h"
#import "TTTGlobalMethods.h"
@interface TTTroundlistViewController : TTTGlobalViewController<UITableViewDataSource, UITableViewDelegate>{
    NSMutableData *rounddata;
    NSMutableArray *roundArray;
  
}
@property (strong, nonatomic) IBOutlet UIButton *menu;
//@property (strong, nonatomic) IBOutlet UIView *topView;
@property (strong, nonatomic) IBOutlet UILabel *page_title;
@property (strong, nonatomic) IBOutlet UILabel *profile_label;
@property (strong, nonatomic) IBOutlet UILabel *activesincelabel;
@property (strong, nonatomic) IBOutlet UIView *footerView;
@property (strong, nonatomic) IBOutlet UIView *ScreenView;
@property (strong, nonatomic) IBOutlet UIView *MenuBarView;
@property (strong, nonatomic) IBOutlet UIButton *dropdown;
@property (strong, nonatomic) IBOutlet UIView *nameview;
@property (strong, nonatomic) IBOutlet UITableView *roundlist;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *Spinner;
@property (strong, nonatomic) IBOutlet UIButton *roundButton;
@property (strong, nonatomic) IBOutlet UIButton *handicapButton;
@property (strong, nonatomic) IBOutlet UIButton *achievementButton;
@property (strong, nonatomic) IBOutlet UIButton *overviewButton;
@property (strong,nonatomic)IBOutlet UIView *DropdownMain;
@property (weak, nonatomic) IBOutlet UIButton *BackButtonClick;

@property (strong, nonatomic) NSString *paramviewID;

@property (strong,nonatomic)IBOutlet UIView *popupview;
- (IBAction)manuSlideropen:(id)sender;
- (IBAction)dropdown:(id)sender;
- (IBAction)Showrounddetails:(id)sender;
- (IBAction)Showhandicap:(id)sender;
- (IBAction)Showachievement:(id)sender;
- (IBAction)Showoverview:(id)sender;
- (IBAction)backButtonClick:(id)sender;
@end
