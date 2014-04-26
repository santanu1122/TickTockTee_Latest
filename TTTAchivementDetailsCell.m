//
//  TTTAchivementDetailsCell.m
//  TickTockTee
//
//  Created by Esolz Tech on 20/03/14.
//  Copyright (c) 2014 com.esolz.TickTockTee. All rights reserved.
//

#import "TTTAchivementDetailsCell.h"

@implementation TTTAchivementDetailsCell
@synthesize cellImageView       = _cellImageView;
@synthesize cellImageViewActi   = _cellImageViewActi;
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
