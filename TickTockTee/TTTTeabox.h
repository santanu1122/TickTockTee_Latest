//
//  TTTTeabox.h
//  TickTockTee
//
//  Created by macbook_ms on 26/02/14.
//  Copyright (c) 2014 com.esolz.TickTockTee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTTGlobalViewController.h"

@interface TTTTeabox : TTTGlobalViewController<UITableViewDataSource,UITableViewDelegate>


@property (strong, nonatomic) IBOutlet UITableView *TblTeeBoxes;
@property(nonatomic, assign)BOOL IsComingThroughModal;

@end
