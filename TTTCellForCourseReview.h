//
//  TTTCellForCourseReview.h
//  TickTockTee
//
//  Created by Esolz_Mac on 08/04/14.
//  Copyright (c) 2014 com.esolz.TickTockTee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TTTCellForCourseReview : UITableViewCell
@property (strong, nonatomic) IBOutlet UIView *BackView;
@property (strong, nonatomic) IBOutlet UIView *viewOnsenderimage;
@property (strong, nonatomic) IBOutlet UIImageView *senderimage;
@property (strong, nonatomic) IBOutlet UILabel *sendername;
@property (strong, nonatomic) IBOutlet UILabel *time;
@property (strong, nonatomic) IBOutlet UITextView *review;
@property (strong, nonatomic) IBOutlet UIView *starView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@end
