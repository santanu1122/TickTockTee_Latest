//
//  TTTMessagedetailsViewController.h
//  TickTockTee
//
//  Created by Esolz_Mac on 03/04/14.
//  Copyright (c) 2014 com.esolz.TickTockTee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTTGlobalViewController.h"
#import "TTTGlobalMethods.h"
@interface TTTMessagedetailsViewController : TTTGlobalViewController<UITextViewDelegate>
@property (nonatomic, strong) NSString *messageid,*msgsender_name;
- (IBAction)BackToprivious:(id)sender;
- (IBAction)post:(id)sender;
- (IBAction)AddMaxView:(id)sender;
@end
