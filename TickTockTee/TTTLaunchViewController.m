//
//  TTTLaunchViewController.m
//  Ticktocktee
//
//  Created by Joydip Pal on 17/02/14.
//  Copyright (c) 2014 com.esolz.Ticktocktee. All rights reserved.
//

#import "TTTLaunchViewController.h"
#import "TTTSigninViewController.h"
#import "TTTLoginViewController.h"


@interface TTTLaunchViewController ()
@property (strong, nonatomic) IBOutlet UIButton *FacebookLogin;

@end

@implementation TTTLaunchViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        //  Custom initialization
        self=(IsIphone5)?[super initWithNibName:@"TTTLaunchViewController" bundle:nil]:[super initWithNibName:@"TTTLaunchViewController_4" bundle:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
//    [self.FacebookLogin setBackgroundImage:[UIImage imageNamed:@"sign-in-with-facebook.png"] forState:UIControlStateNormal];
//    [self.FacebookLogin setBackgroundImage:[UIImage imageNamed:@"sign-in-with-facebook.png"] forState:UIControlStateHighlighted];
//    [self.FacebookLogin setBackgroundImage:[UIImage imageNamed:@"sign-in-with-facebook.png"] forState:UIControlStateSelected];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)getstarted:(UIButton *)sender {
    TTTSigninViewController *v;
   
     v=[[TTTSigninViewController alloc] initWithNibName:@"TTTSigninViewController" bundle:nil];
    
    // [self.navigationController pushViewController:v animated:NO];
    [self PushViewController:v TransitationFrom:kCATransitionFade];
  
    
}
- (IBAction)signin:(id)sender {
    TTTLoginViewController *signin_v;
    if(IsIphone5){
        signin_v=[[TTTLoginViewController alloc] initWithNibName:@"TTTLoginViewController" bundle:nil];
    }else{
        signin_v=[[TTTLoginViewController alloc] initWithNibName:@"TTTLoginViewController_4" bundle:nil];
    }
    
    
    [self PushViewController:signin_v TransitationFrom:kCATransitionFade];
    //[self.navigationController pushViewController:signin_v animated:NO];
 
    
}

@end
