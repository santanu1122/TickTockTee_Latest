//
//  TTTCourseReviewViewController.h
//  TickTockTee
//
//  Created by Esolz_Mac on 08/04/14.
//  Copyright (c) 2014 com.esolz.TickTockTee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTTGlobalViewController.h"
#import "TTTGlobalMethods.h"
@interface TTTCourseReviewViewController : TTTGlobalViewController<UITextViewDelegate>
@property (strong,nonatomic) NSString *courseid;
@property (strong,nonatomic) NSString *paramid;
@property (strong,nonatomic) NSMutableArray *reviewarraylist;

- (IBAction)BackToprivious:(id)sender;
- (IBAction)postreview:(id)sender;
@end
