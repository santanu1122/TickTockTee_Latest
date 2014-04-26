//
//  TTTCellForCourseReview.m
//  TickTockTee
//
//  Created by Esolz_Mac on 08/04/14.
//  Copyright (c) 2014 com.esolz.TickTockTee. All rights reserved.
//

#import "TTTCellForCourseReview.h"
#import "TTTGlobalViewController.h"
@implementation TTTCellForCourseReview
@synthesize BackView,viewOnsenderimage,senderimage,sendername,time,review,starView,spinner;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
