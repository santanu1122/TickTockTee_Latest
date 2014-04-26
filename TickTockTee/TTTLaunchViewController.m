//
//  TTTLaunchViewController.m
//  Ticktocktee
//
//  Created by Joydip Pal on 17/02/14.
//  Copyright (c) 2014 com.esolz.Ticktocktee. All rights reserved.
//

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
#import "TTTAppDelegate.h"
#import "TTTGlobalMethods.h"

@interface TTTLaunchViewController ()
{
    NSOperationQueue *OperationQueue;
    BOOL GotError,IsFBThreadFire;
    NSString *Name;
    NSString *PerformerId;
    TTTGlobalMethods *Method;
}
@property (strong, nonatomic) IBOutlet UIButton *FacebookLogin;
@property (strong, nonatomic) IBOutlet UILabel *LblError;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *Spinner;

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
    OperationQueue=[[NSOperationQueue alloc] init];
    Method=[[TTTGlobalMethods alloc]init];
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
- (IBAction)FacebookSignup:(id)sender {
    NSLog(@"Button on facebook clicked");
    [self.FacebookLogin setBackgroundImage:[UIImage imageNamed:@"sign-in-with-facebook-on-tap"] forState:UIControlStateNormal];
    [self.FacebookLogin setBackgroundImage:[UIImage imageNamed:@"sign-in-with-facebook-on-tap"] forState:UIControlStateSelected];
    [self.FacebookLogin setBackgroundImage:[UIImage imageNamed:@"sign-in-with-facebook-on-tap"] forState:UIControlStateHighlighted];
    [[self view] setUserInteractionEnabled:NO];
    [self ShowProgress:@"Please wait.." :NO];
    
    if (FBSession.activeSession.isOpen)
    {
        [self updateView];
        
    }
    else
    {
        [self openSessionWithAllowLoginUI:YES];
        
    }
    
}
-(void)ShowProgress:(NSString *)message :(BOOL)IsError
{
    if(IsError)
    {
        [_Spinner stopAnimating];
        [[_LblError layer] setMasksToBounds:YES];
        [_LblError setFont:[UIFont fontWithName:@"MyriadPro-Regular" size:14.0f]];
        [_LblError setTextColor:[UIColor whiteColor]];
    }
    else
    {
        [_Spinner startAnimating];
        [_LblError setFont:[UIFont systemFontOfSize:14.0f]];
        [_LblError setTextColor:[UIColor whiteColor]];
    }
    [_LblError setText:message];
    [_LblError setHidden:NO];
}
- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI
{
    NSArray *permissions = [[NSArray alloc] initWithObjects: @"email", nil];
    
    NSLog(@"open1");
    
    return [FBSession openActiveSessionWithReadPermissions:permissions allowLoginUI:allowLoginUI completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
        [self sessionStateChanged:session state:status error:error];
    }];
    
}
- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error
{
    NSLog(@"SessionStateChanged: %@", error);
    switch (state)
    {
        case FBSessionStateOpen:
            if (!error)
            {
                // We have a valid session
                [[self view] setUserInteractionEnabled:YES];
                TTTAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
                appDelegate.session=session;
                NSLog(@"Valid Session");
                [self updateView];
            }
            break;
        case FBSessionStateClosed:
        case FBSessionStateClosedLoginFailed:
            [[self view] setUserInteractionEnabled:YES];
            [self ShowProgress:@"Allow TickTockTee to access your fb account." :YES];
            [FBSession.activeSession closeAndClearTokenInformation];
            break;
        default:
            break;
    }
}
- (void)updateView
{
    
    TTTAppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    
    
    
    if (appDelegate.session.isOpen)
    {
        _FBAccessToken=appDelegate.session.accessTokenData.accessToken;
        
        
        if(![FBAccessTokenData  isEqual:@""] && !IsFBThreadFire)
        {
            
            IsFBThreadFire=TRUE;
            NSInvocationOperation *RegisterOperation=[[NSInvocationOperation alloc] initWithTarget:self selector:@selector(getFacebookFeed) object:nil];
            [OperationQueue addOperation:RegisterOperation];
        }
    }
    else
    {
        
        [[self view] setUserInteractionEnabled:YES];
        [[FBSession activeSession] closeAndClearTokenInformation];
        [[FBSession activeSession] close];
    }
}
-(void) getFacebookFeed
{
    NSLog(@"FaceBokFeed is called");
    @try
    {
        NSString *url=[NSString stringWithFormat:@"%@me?access_token=%@", GraphAPI, _FBAccessToken];
        NSLog(@"%@", url);
        NSError *gotError;
        
        NSData *getData=[NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
        if([getData length]>0)
        {
            NSArray *getArray=[NSJSONSerialization JSONObjectWithData:getData options:kNilOptions error:&gotError];
            NSLog(@"Email:: %@", [getArray valueForKey:@"email"]);
            if(!gotError)
            {
                NSMutableDictionary *ParamDic=[[NSMutableDictionary alloc] initWithCapacity:2];
                [ParamDic setValue:[getArray valueForKey:@"email"] forKey:@"email"];
                [ParamDic setValue:[getArray valueForKey:@"id"] forKey:@"connectid"];
                [ParamDic setValue:[getArray valueForKey:@"first_name"] forKey:@"first_name"];
                [ParamDic setValue:[getArray valueForKey:@"last_name"] forKey:@"last_name"];
                [ParamDic setValue:[getArray valueForKey:@"username"] forKey:@"username"];
                [ParamDic setValue:@"facebook_register" forKey:@"mode"];
                NSInvocationOperation *RegisterOperation=[[NSInvocationOperation alloc] initWithTarget:self selector:@selector(ValidateAndRegister:) object:ParamDic];
                [OperationQueue addOperation:RegisterOperation];
            }
            else
            {
                NSLog(@"%@",gotError.localizedDescription);
            }
        }
        else
        {
            [self performSelectorOnMainThread:@selector(HandleFBError) withObject:nil waitUntilDone:NO];
            NSLog(@"Data is null..");
        }
    }
    @catch (NSException *juju)
    {
        //play with your little juju.
    }
}
-(void)ValidateAndRegister:(NSMutableDictionary *)Param
{
    @try
    {
        GotError=FALSE;
        
        NSString *Mode=([[Param valueForKey:@"mode"] isEqualToString:@"facebook_register"])?@"facebook_register":@"login";
        
        NSString *URL=[NSString stringWithFormat:@"%@user.php?mode=%@&username=%@&password=%@&email=%@&connectid=%@&first_name=%@&last_name=%@", API, Mode, [Method Encoder:[Param valueForKey:@"username"]], [Method Encoder:[Param valueForKey:@"password"]], [Method Encoder:[Param valueForKey:@"email"]], [Method Encoder:[Param valueForKey:@"connectid"]], [Method Encoder:[Param valueForKey:@"first_name"]], [Method Encoder:[Param valueForKey:@"last_name"]] ];
        NSLog(@"%@", URL);
        NSData *getData=[NSData dataWithContentsOfURL:[NSURL URLWithString:URL]];
        
        if([getData length]>0)
        {
            NSDictionary *OutputDic=[NSJSONSerialization JSONObjectWithData:getData options:kNilOptions error:nil];
            if([[OutputDic valueForKey:@"response"] isEqualToString:@"error"])
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self ShowProgress:(NSString *)[OutputDic valueForKey:@"message"] :YES];
                    
                    [[self view] setUserInteractionEnabled:YES];
                });
            }
            else
            {
                PerformerId=[OutputDic valueForKey:@"userid"];
                Name=[OutputDic valueForKey:@"name"];
                
                
                NSData *tempData=[NSData dataWithContentsOfURL:[NSURL URLWithString:(NSString *)[OutputDic valueForKey:@"thumb"]]];
                
                
                // NSUserDefaults *UserId=[[NSUserDefaults alloc] init];
                NSUserDefaults * userdefalds=[NSUserDefaults standardUserDefaults];
                
                [userdefalds setValue:PerformerId forKey:SESSION_ID];
                [userdefalds setValue:Name forKey:SESSION_LOGGERNAME];
                [userdefalds setObject:tempData forKey:SESSION_LOGGERIMAGEDATA];
                [userdefalds setObject:[OutputDic valueForKey:@"image"] forKey:SESSION_LOGGERIMAGEURL];
                
                [userdefalds setValue:@"0" forKey:HANDICAPINDEX];
                [userdefalds setValue:@"0.00" forKey:TOTALPOINT];
                
                [userdefalds synchronize];
                
                [self performSelectorOnMainThread:@selector(RedirectmeForfacebook) withObject:nil waitUntilDone:YES];
            }
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Incorrect user name & password" message:@"Error !" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                
                [[self view] setUserInteractionEnabled:YES];
            });
        }
    }
    @catch (NSException *juju)
    {
        NSLog(@"Reporting juju from ValidateAndRegisterMe %@", juju);
    }
}

-(void)RedirectmeForfacebook
{
    TTTActivityStreem *Activity=[[TTTActivityStreem alloc]initWithNibName:@"TTTActivityStreem" bundle:nil];
    [self.navigationController pushViewController:Activity animated:YES];
}

@end
