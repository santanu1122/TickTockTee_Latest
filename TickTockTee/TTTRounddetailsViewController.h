//
//  TTTRounddetailsViewController.h
//  TickTockTee
//
//  Created by Esolz_Mac on 25/03/14.
//  Copyright (c) 2014 com.esolz.TickTockTee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTTGlobalViewController.h"
#import "TTTGlobalMethods.h"
@interface TTTRounddetailsViewController :TTTGlobalViewController<UITableViewDataSource, UITableViewDelegate>{
    NSMutableData *details_data;
    NSMutableArray *dataArray;
    NSMutableDictionary *dicForAll;
}
@property (nonatomic, strong) NSString *eventid;
@property (nonatomic, strong) NSString *userid;
@property (strong, nonatomic) IBOutlet UIButton *back;
//@property (strong, nonatomic) IBOutlet UIView *topView;
@property (strong, nonatomic) IBOutlet UILabel *page_title;
@property (strong, nonatomic) IBOutlet UILabel *matchtitle;
@property (strong, nonatomic) IBOutlet UILabel *datetitle;

@property (strong, nonatomic) IBOutlet UIView *footerView;
@property (strong, nonatomic) IBOutlet UIView *ScreenView;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) IBOutlet UIButton *dropdown;
@property (strong, nonatomic) IBOutlet UIView *detailsview;
@property (strong, nonatomic) IBOutlet UIView *dataview;
//@property (strong, nonatomic) IBOutlet UITableView *datalist;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *Spinner;
@property (strong, nonatomic) NSString *paramviewID;

- (IBAction)backButtonClick:(id)sender;
@end
