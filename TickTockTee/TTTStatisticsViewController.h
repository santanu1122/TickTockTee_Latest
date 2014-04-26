//
//  TTTStatisticsViewController.h
//  TickTockTee
//
//  Created by Esolz_Mac on 22/03/14.
//  Copyright (c) 2014 com.esolz.TickTockTee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTTGlobalViewController.h"
#import "TTTGlobalMethods.h"
@class SGSLineGraphView;
@interface TTTStatisticsViewController : TTTGlobalViewController<UIScrollViewDelegate>
    
@property (strong,retain ) IBOutlet SGSLineGraphView *lineGraphView;
@property (strong, nonatomic) IBOutlet UITableView *statistic_table;
@property (strong, nonatomic) IBOutlet UIButton *menu;
@property (strong, nonatomic) IBOutlet UIButton *option;
@property (strong, nonatomic) IBOutlet UILabel *page_title;
@property (strong, nonatomic) IBOutlet UIView *footerView;
@property (strong, nonatomic) IBOutlet UIView *dataView;
@property (strong, nonatomic) IBOutlet UIView *ScreenView;
@property (strong, nonatomic) IBOutlet UIView *MenuBarView;
@property (strong, nonatomic) IBOutlet UIScrollView *statistic_data;
@property (strong, nonatomic) IBOutlet UIView *popupview;
@property (strong, nonatomic) IBOutlet UIScrollView *MainScrollView;

@property (nonatomic,retain) IBOutlet UIView *GraphView;
@property (nonatomic,retain) IBOutlet UILabel *GraphViewLabelOne;
@property (nonatomic,retain) IBOutlet UILabel *GraphViewLabelTwo;
@property (strong, nonatomic) IBOutlet UIImageView *tick1;
@property (strong, nonatomic) IBOutlet UIImageView *tick2;
@property (strong, nonatomic) IBOutlet UIImageView *tick3;

@property (strong, nonatomic) IBOutlet UIView *actionView;

@property (strong, nonatomic) NSString *paramviewID;


- (IBAction)manuSlideropen:(id)sender;
@end
