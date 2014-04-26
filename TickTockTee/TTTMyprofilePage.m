//
//  TTTMyprofilePage.m
//  TickTockTee
//
//  Created by macbook_ms on 25/02/14.
//  Copyright (c) 2014 com.esolz.TickTockTee. All rights reserved.
//

#import "TTTMyprofilePage.h"
#import "TTTAppDelegate.h"

@interface TTTMyprofilePage ()
{
    BOOL  IsChatBoxOpen,IsLeftMenuBoxOpen,Ishoveropen;
}
@property (strong, nonatomic) IBOutlet UIView *manuHeaderview;
@property (strong, nonatomic) IBOutlet UIView *chatboxView;
@property (strong, nonatomic) IBOutlet UIView *mainScreenView;
@property (strong, nonatomic) IBOutlet UITableView *ProfileTBL;
@property (strong, nonatomic) IBOutlet UIView *FooterView;
@property (strong, nonatomic) IBOutlet UIView *hoverview;

@end

@implementation TTTMyprofilePage
@synthesize manuHeaderview=_manuHeaderview;
@synthesize chatboxView =_chatboxView;
@synthesize mainScreenView =_mainScreenView;
@synthesize ProfileTBL =_ProfileTBL;
@synthesize FooterView =_FooterView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
self.navigationController.navigationBar.hidden=YES;
[self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];

    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [_mainScreenView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background_2.png"]]];
  
    _ProfileTBL.delegate=self;
    _ProfileTBL.dataSource=self;
    IsChatBoxOpen=FALSE;
    IsLeftMenuBoxOpen=FALSE;
    Ishoveropen=FALSE;
    [_FooterView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bottom-bar2"]]];
    
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panDetected:)];
    [_mainScreenView addGestureRecognizer:panRecognizer];
    
    
    [self AddNavigationBarTo:_FooterView withSelected:@""];
    
     [self AddLeftMenuTo:_manuHeaderview];
    //   _StatusView.frame=CGRectMake(0, 60, 320, 0);
    //    [_ScreenView addSubview:_StatusView];
    
    [_ProfileTBL setBackgroundColor:[UIColor clearColor]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) initPopUpView {
    self.hoverview.alpha = 0;
     self.hoverview.frame = CGRectMake (112, 60, 0, 0);
    [self.mainScreenView addSubview: self.hoverview];
}

- (void) animatePopUpShow
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationWillStartSelector:@selector(initPopUpView)];
    
    self.hoverview.alpha = 1;
    self.hoverview.frame = CGRectMake (20, 40, 300, 400);
    
    [UIView commitAnimations];
}

- (IBAction)performManuSlideroperation:(id)sender
{
    
    
}



- (IBAction)OpenSettingspage:(id)sender
{
  
    
    
}
- (IBAction)ProfileDetais:(id)sender
{
    
    
}

@end
