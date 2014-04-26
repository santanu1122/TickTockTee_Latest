//
//  TTTHandicaptViewController.h
//  TickTockTee
//
//  Created by Esolz_Mac on 24/03/14.
//  Copyright (c) 2014 com.esolz.TickTockTee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTTGlobalViewController.h"
@interface TTTHandicaptViewController : TTTGlobalViewController
@property (strong, nonatomic) IBOutlet UILabel *page_title;
@property (strong, nonatomic) IBOutlet UIView *footerView;
@property (strong, nonatomic) IBOutlet UIView *ScreenView;
@property (strong, nonatomic) IBOutlet UIView *MenuBarView;
@property (strong, nonatomic) IBOutlet UIView *nameview;
@property (strong, nonatomic) IBOutlet UITableView *handcaplist;
@property (strong, nonatomic) IBOutlet UILabel *statistics;
@property (strong, nonatomic) IBOutlet UILabel *datestatics;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *avtivity;
@property (strong, nonatomic) IBOutlet UIView *dropDownView1;
@property (strong, nonatomic) NSString *paramviewID;
@end
