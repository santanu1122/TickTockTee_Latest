//
//  TTTScorecardList.h
//  TickTockTee
//
//  Created by Esolz_Mac on 19/03/14.
//  Copyright (c) 2014 com.esolz.TickTockTee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTTGlobalViewController.h"
#import "TTTGlobalMethods.h"
@interface TTTScorecardList :  TTTGlobalViewController<UITableViewDataSource, UITableViewDelegate,UITextFieldDelegate>{
    UIView *search_view;
    BOOL filter;
    NSMutableArray  *match1;
    NSMutableDictionary *to_show;
    NSArray *searchResults;
    UIActivityIndicatorView *loader;
}
@property (strong, nonatomic) IBOutlet UITableView *scorelist_table;
@property (strong, nonatomic) IBOutlet UIButton *menu;
@property (strong, nonatomic) IBOutlet UIButton *search;
@property (strong, nonatomic) IBOutlet UILabel *page_title;
@property (strong, nonatomic) IBOutlet UIView *footerView;
@property (strong, nonatomic) IBOutlet UIView *ScreenView;
@property (strong, nonatomic) IBOutlet UIView *MenuBarView;
@property (strong, nonatomic) IBOutlet UIView *StatusView;
@property (strong, nonatomic) IBOutlet UIView *SearchView;
@property (strong, nonatomic) IBOutlet UIImageView *ScarchIconpng;
@property (strong, nonatomic) IBOutlet UITextField *Searchtextfield;


- (IBAction)search_bar:(id)sender;

- (IBAction)SearchButtonclick:(id)sender;
@end