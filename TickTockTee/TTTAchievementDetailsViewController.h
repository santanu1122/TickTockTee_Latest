//
//  TTTAchievementDetailsViewController.h
//  TickTockTee
//
//  Created by Esolz Tech on 20/03/14.
//  Copyright (c) 2014 com.esolz.TickTockTee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTTGlobalViewController.h"
#import "TTTImageDownLoader.h"

@interface TTTAchievementDetailsViewController :TTTGlobalViewController <ImageDownloaderDelegate>
@property (weak, nonatomic) IBOutlet UITableView *achivementDetailTable;
@property (weak, nonatomic) IBOutlet UIImageView *mediumImageView;
@property (strong, nonatomic) IBOutlet UITextView *textview;
@property (strong, nonatomic) IBOutlet UILabel *labelOnImageView;
@property (weak, nonatomic) IBOutlet UIView *topview;
@property(strong,nonatomic) NSMutableArray *arrayContent;
@property(assign,nonatomic)NSInteger tag;
@property (nonatomic, strong) NSString *ParamviewAchivementdetails;

@property(nonatomic,retain) IBOutlet UIImageView *MainImageView;
@end
