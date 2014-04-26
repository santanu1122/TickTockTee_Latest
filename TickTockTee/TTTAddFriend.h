//
//  TTTAddFriend.h
//  TickTockTee
//
//  Created by macbook_ms on 26/02/14.
//  Copyright (c) 2014 com.esolz.TickTockTee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTTGlobalViewController.h"

@interface TTTAddFriend : TTTGlobalViewController



@property (strong, nonatomic) IBOutlet UIView *ScreenView;


@property (strong, nonatomic) IBOutlet UIButton *BtnCancel;
@property (strong, nonatomic) IBOutlet UIButton *BtnDone;

@property (strong, nonatomic) IBOutlet UITextField *TFSearch;
@property (strong, nonatomic) IBOutlet UITableView *TblFriends;
@property(nonatomic, assign)BOOL IsComingThroughModal;

@end
