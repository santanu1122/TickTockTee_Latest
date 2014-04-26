//
//  TTTMessageListViewController.h
//  TickTockTee
//
//  Created by Esolz Tech on 03/04/14.
//  Copyright (c) 2014 com.esolz.TickTockTee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTTGlobalViewController.h"
#import "TTTMessagedetailsViewController.h"

@interface TTTMessageListViewController :TTTGlobalViewController<UITableViewDelegate,UITableViewDataSource>
{
    
}


@property (nonatomic, strong) NSString *Parmfrienduserid;

@property (strong, nonatomic) IBOutlet UITableView *messageTable;
@property (strong, nonatomic) IBOutlet UIView *MenuView;
@property (strong, nonatomic) IBOutlet UIView *screenView;
@property (strong, nonatomic) IBOutlet UILabel *page_title;



- (IBAction)plusClicked:(id)sender;
- (IBAction)backClicked:(id)sender;

@end
