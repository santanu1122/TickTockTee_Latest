//
//  TTTViewController.m
//  Ticktocktee
//
//  Created by Iphone_2 on 17/02/14.
//  Copyright (c) 2014 com.esolz.Ticktocktee. All rights reserved.
//

#import "TTTViewController.h"
#import "TTTLaunchViewController.h"
#import "TTTAppDelegate.h"
#import "SVProgressHUD.h"
#import "AFNetworking.h"
#import "AFJSONRequestOperation.h"
#import "TTTLoginViewController.h"
#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation.h"

@interface TTTViewController ()
{
    NSString *userId;
    NSString *deviceTocken;
   
}

@property (nonatomic,retain) IBOutlet UIActivityIndicatorView *TimerActivity;
@property (nonatomic,retain) NSTimer *ActivityTimer;

@end

@implementation TTTViewController
@synthesize TimerActivity = _TimerActivity;
@synthesize ActivityTimer = _ActivityTimer;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    NSUserDefaults *userDefals=[NSUserDefaults standardUserDefaults];
    userId=[userDefals valueForKey:SESSION_ID];
    
    if ([userId integerValue]>0)
    {
       [_TimerActivity startAnimating];
       
    }
    
   
    
    _ActivityTimer = [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(ForWardToOtherView:) userInfo:nil repeats:NO];
    
}

-(IBAction)ForWardToOtherView:(id)sender {
   // [_TimerActivity stopAnimating];
    if ([userId integerValue]>0)
    {
        [self AutoLoginme];
         //[self ValidateAndRegisterMe];
//        TTTActivityStreem *activity=[[TTTActivityStreem alloc]init];
//        [self.navigationController pushViewController:activity animated:NO];
        
    }
    else
    {
        TTTLaunchViewController *Launch = [[TTTLaunchViewController alloc] init];
        [self PushViewController:Launch TransitationFrom:kCATransitionFade];
    }
    
 
    
}
-(void)ValidateAndRegisterMe
{
    TTTAppDelegate *appDelegate=(TTTAppDelegate *) [[UIApplication  sharedApplication] delegate];
    deviceTocken = appDelegate.deviceTokenString;
    
    
    @try
    {
        
        NSUserDefaults *userDefalds=[NSUserDefaults standardUserDefaults];
        
        NSString *userName=[userDefalds valueForKey:SESSION_USERNAME];
        NSString *PassWord=[userDefalds valueForKey:SESSION_PASSWORD];
        
        NSString *URL=[NSString stringWithFormat:@"%@user.php?mode=%@&username=%@&password=%@&device_token=%@&device_type=%d",API,@"login",userName,PassWord,deviceTocken,2];
       
        NSData *getData=[NSData dataWithContentsOfURL:[NSURL URLWithString:URL]];
        
        if([getData length]>0)
        {
            NSDictionary *OutputDic=[NSJSONSerialization JSONObjectWithData:getData options:kNilOptions error:nil];
            
            if([[OutputDic valueForKey:@"response"] isEqualToString:@"error"])
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    
                    TTTLoginViewController *signinview=[[TTTLoginViewController alloc]init];
                    [self PushViewController:signinview TransitationFrom:kCATransitionFade];
                    [SVProgressHUD showErrorWithStatus:(NSString *)[OutputDic valueForKey:@"message"]];
                   
                    
                    
                });
            }
            else
            {
                
                [self performSelectorOnMainThread:@selector(RedirectMe) withObject:nil waitUntilDone:YES];
            }
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                
           
                TTTLoginViewController *signinview=[[TTTLoginViewController alloc]init];
                [self PushViewController:signinview TransitationFrom:kCATransitionFade];
                [SVProgressHUD showErrorWithStatus:@"user name & password change"];
               
                
            });
        }
    }
    @catch (NSException *juju)
    {
        NSLog(@"Reporting juju from ValidateAndRegisterMe %@", juju);
    }
}


-(void)AutoLoginme
{
    TTTAppDelegate *appDelegate=(TTTAppDelegate *) [[UIApplication  sharedApplication] delegate];
    deviceTocken = appDelegate.deviceTokenString;
    
      NSUserDefaults *userDefalds=[NSUserDefaults standardUserDefaults];
        
        NSString *userName=[userDefalds valueForKey:SESSION_USERNAME];
        NSString *PassWord=[userDefalds valueForKey:SESSION_PASSWORD];
    
        NSString *URLSreing=[NSString stringWithFormat:@"%@user.php?mode=%@&username=%@&password=%@&device_token=%@&device_type=%d",API,@"login",userName,PassWord,deviceTocken,2];
    
         NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:URLSreing]];
      [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
      AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON)
                                                                                        {

                                                                                            NSLog(@"success");
                                                                                            
                                                                                            NSDictionary *OutputDic = (NSDictionary *) JSON;
                                                                                            
                                                                                            NSLog(@"The value of out put Dic:%@",JSON);
                                                                                            if([[OutputDic valueForKey:@"response"] isEqualToString:@"error"])
                                                                                            {
                                                                                              
                                                                                                    
                                                                                                    [_TimerActivity stopAnimating];
                                                                                                    TTTLoginViewController *signinview=[[TTTLoginViewController alloc]init];
                                                                                                    [self PushViewController:signinview TransitationFrom:kCATransitionFade];
                                                                                                    [SVProgressHUD showErrorWithStatus:@"user name & password change"];
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                            
                                                                                            }
                                                                                            else
                                                                                            {
                                                                                                
                                                                                                [self performSelectorOnMainThread:@selector(RedirectMe) withObject:nil waitUntilDone:YES];
                                                                                            }
                                                                                        }
                                         
                                          

                                          
                                                                                         failure:^(NSURLRequest *request, NSHTTPURLResponse *response,
                                                                                                    NSError *error, id JSON)
                                                                                             {
                                                                                                [_TimerActivity stopAnimating];
                                                                                                 NSLog(@"Request Failure Because %@",[error userInfo]);
                                                                                                 TTTLoginViewController *signinview=[[TTTLoginViewController alloc]init];
                                                                                                 [self PushViewController:signinview TransitationFrom:kCATransitionFade];
                                                                                                 [SVProgressHUD showErrorWithStatus:@"user name & password change"];

                                                                                                 
                                                                                             }
                                         ];
    
    [operation start];
}



-(void)RedirectMe
{
    
    [_TimerActivity startAnimating];
    TTTActivityStreem *Activiry=[[TTTActivityStreem alloc]init];
    [self PushViewController:Activiry TransitationFrom:kCATransitionFade];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
      return YES;
}


@end
