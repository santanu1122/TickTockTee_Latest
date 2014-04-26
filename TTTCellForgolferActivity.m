//
//  TTTCellForgolferActivity.m
//  TickTockTee
//
//  Created by macbook_ms on 11/03/14.
//  Copyright (c) 2014 com.esolz.TickTockTee. All rights reserved.
//

#import "TTTCellForgolferActivity.h"
#import "TTTGlobalViewController.h"

@implementation TTTCellForgolferActivity
@synthesize backgroundView;
@synthesize imageView;
@synthesize NameLbl;
@synthesize DescriptionLbl;
@synthesize detailTextLabel;
@synthesize dateTimelbl;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self CellDisplayWithevent];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)CellDisplayWithevent
 {
    
    TTTGlobalViewController *globalview=[[TTTGlobalViewController alloc]init];
    [globalview setRoundBorderToUiview:backgroundView];
    [globalview setRoundBorderToImageView:imageView];
    NameLbl.font=[UIFont fontWithName:MYRIARDPROSAMIBOLT size:14.0f];
    DescriptionLbl.font=[UIFont fontWithName:MYRIARDPROLIGHT size:13.0f];
    dateTimelbl.font=[UIFont fontWithName:SEGIOUI size:11.0f];
    
    
 }



@end
