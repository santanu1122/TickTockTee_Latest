//
//  TTTActivityStreem.h
//  Ticktocktee
//
//  Created by macbook_ms on 19/02/14.
//  Copyright (c) 2014 com.esolz.Ticktocktee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTTGlobalViewController.h"

@interface TTTActivityStreem : TTTGlobalViewController
@property (strong, nonatomic) IBOutlet UIButton *Statusbutton;

@property (strong, nonatomic) IBOutlet UIButton *Photobutton;
@property (strong, nonatomic) IBOutlet UIButton *Matchbutton;
@property (strong, nonatomic) IBOutlet UIView *Loadmorebsckview;
@property (strong, nonatomic) IBOutlet UILabel *LodingLBL;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *loadoreSopinner;
@end
