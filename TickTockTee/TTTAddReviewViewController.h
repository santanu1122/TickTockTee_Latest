//
//  TTTAddReviewViewController.h
//  TickTockTee
//
//  Created by Esolz_Mac on 08/04/14.
//  Copyright (c) 2014 com.esolz.TickTockTee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTTGlobalViewController.h"
#import "TTTGlobalMethods.h"
@interface TTTAddReviewViewController :TTTGlobalViewController<UITextViewDelegate>
@property (strong,nonatomic) NSString *reviewCourseID;
@property (strong, nonatomic) NSMutableArray *AllReviews;


- (IBAction)cancel:(id)sender;
- (IBAction)submit:(id)sender;
- (IBAction)BackToprivious:(id)sender;

@end
