//
//  TTTLoginViewController.m
//  Ticktocktee
//
//  Created by Joydip Pal on 17/02/14.
//  Copyright (c) 2014 com.esolz.Ticktocktee. All rights reserved.
//

#import "TTTLoginViewController.h"
#import "TTTAppDelegate.h"
#import "TTTActivityStreem.h"
#import "TTTForgetpasswordHome.h"
#import "TTTSigninViewController.h"
#import "TTTSignInuploadImage.h"
#import <Social/Social.h>
#import <Accounts/Accounts.h>
#import "TTTGlobalMethods.h"
#import "TTTLaunchViewController.h"



@interface TTTLoginViewController ()
{
    NSOperationQueue *OperationQueue;
    BOOL GotError, IsFBThreadFire;
    NSString *PerformerId, *Name,*handicapIndex,*point;
    NSString *deviceTocken;
    TTTGlobalMethods *Method;
    
   
}
@property (strong, nonatomic) IBOutlet UIButton *SigninWithFb;

@property (strong, nonatomic) IBOutlet UILabel *Signuptxt;
@property (strong, nonatomic) IBOutlet UILabel *forgotPassword;

@property (strong, nonatomic) IBOutlet UITextField *UserNameTxt;
@property (strong, nonatomic) IBOutlet UITextField *PasswordTxt;
@property (strong, nonatomic) IBOutlet UIScrollView *LoginScroll;
@property (strong, nonatomic) IBOutlet UILabel *LblError;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *Spinner;
- (IBAction)SignInTouched:(id)sender;

@end

@implementation TTTLoginViewController
@synthesize  UserNameTxt=_UserNameTxt;
@synthesize PasswordTxt =_PasswordTxt;
@synthesize LoginScroll =_LoginScroll;
@synthesize LblError = _LblError;
@synthesize Spinner = _Spinner;
@synthesize Signuptxt =__Signuptxt;
@synthesize forgotPassword =__forgotPassword;

-(void)viewDidAppear:(BOOL)animated
{
    [_LblError setHidden:YES];
    [_Spinner stopAnimating];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
      self.navigationController.navigationBar.hidden=YES;
     [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
    Method=[[TTTGlobalMethods alloc]init];
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    
    {
       //  Custom initialization
    self=(IsIphone5)?[super initWithNibName:@"TTTLoginViewController" bundle:nil]:[super initWithNibName:@"TTTLoginViewController_4" bundle:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
     [self.navigationController setNavigationBarHidden:YES animated:NO];
      OperationQueue=[[NSOperationQueue alloc] init];
    
    __forgotPassword.font=[UIFont fontWithName:@"MyriadProLight" size:13.0f];
    __Signuptxt.font=[UIFont fontWithName:@"MyriadProLight" size:13.0f];
   
    
    _UserNameTxt.font=[UIFont fontWithName:@"MyriadPro-Regular" size:16.0f];
      _PasswordTxt.font=[UIFont fontWithName:@"MyriadPro-Regular" size:16.0f];
    
    [_UserNameTxt setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [_PasswordTxt setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
  
  //  [self perforAutologin];
    
    
    // Do any additional setup after loading the view from its nib.
}

-(void)perforAutologin
{
   
    NSLog(@"I am out:");
    NSUserDefaults *userDetais=[NSUserDefaults standardUserDefaults];
    if ([[userDetais valueForKey:SESSION_ID] integerValue]>0)
        
    {
        
        NSLog(@"I am in");
         _UserNameTxt.text=[userDetais valueForKey:SESSION_USERNAME];
         _PasswordTxt.text=[userDetais valueForKey:SESSION_PASSWORD];
        NSInvocationOperation *operationAutologin=[[NSInvocationOperation alloc]initWithTarget:self selector:@selector(ValidateAndRegisterMe) object:nil];
        [OperationQueue addOperation:operationAutologin];
    }
}

- (IBAction)cross_btn:(id)sender
{
    TTTLaunchViewController *SigninLonch=[[TTTLaunchViewController alloc]init];
    [self PushViewController:SigninLonch TransitationFrom:kCATransitionFade];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
   
    if (IsIphone5)
    {
        
        
        _LoginScroll.contentSize=CGSizeMake(320, 568);
    }
    else
    {
       
        _LoginScroll.contentSize=CGSizeMake(320, 480);
    }
    [_LoginScroll setContentOffset:CGPointMake(0, 0) animated:YES];
    
    [textField resignFirstResponder];
    
     return YES;
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    if (IsIphone5)
    {
         _LoginScroll.contentSize=CGSizeMake(320, 700);
        
        
    }
    else
    {
          _LoginScroll.contentSize=CGSizeMake(320, 580);
    }
   
    if (textField==_UserNameTxt)
    {
         [_LoginScroll setContentOffset:CGPointMake(0, 30) animated:YES];
    }
    else
    {
         [_LoginScroll setContentOffset:CGPointMake(0, 50) animated:YES];
    }
    
    return YES;
}



-(void)ShowProgress:(NSString *)message :(BOOL)IsError
{
    if(IsError)
    {
        [_Spinner stopAnimating];

        
        [_LblError setTextColor:[UIColor whiteColor]];
        [_LblError setFont:[UIFont fontWithName:@"MyriadPro-Regular" size:14.0f]];
        [_LblError setText:message];
        [_LblError setHidden:YES];
    }
    else
    {
        [_Spinner startAnimating];
        [[_LblError layer] setCornerRadius:0.0f];
        [[_LblError layer] setBorderWidth:0.0f];
        [[_LblError layer] setBorderColor:[[UIColor clearColor] CGColor]];
        [[_LblError layer] setMasksToBounds:YES];
        [_LblError setFont:[UIFont fontWithName:@"MyriadPro-Regular" size:14.0f]];
        [_LblError setTextColor:[UIColor whiteColor]];
        [_LblError setText:message];
        [_LblError setHidden:NO];
    }
   
}
-(void)ValidateAndRegisterMe
{
      TTTAppDelegate *appDelegate=(TTTAppDelegate *) [[UIApplication  sharedApplication] delegate];
      deviceTocken = appDelegate.deviceTokenString;
    
  
    @try
    {
        GotError=FALSE;
        NSString *userName=[_UserNameTxt.text stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *PassWord=[_PasswordTxt.text stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *URL=[NSString stringWithFormat:@"%@user.php?mode=%@&username=%@&password=%@&device_token=%@&device_type=%d",API,@"login",userName,PassWord,deviceTocken,2];
        NSLog(@"%@", URL);
        NSData *getData=[NSData dataWithContentsOfURL:[NSURL URLWithString:URL]];
        
        if([getData length]>0)
        {
            NSDictionary *OutputDic=[NSJSONSerialization JSONObjectWithData:getData options:kNilOptions error:nil];
            if([[OutputDic valueForKey:@"response"] isEqualToString:@"error"])
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    //[self ShowProgress:(NSString *)[OutputDic valueForKey:@"message"] :YES];
                    [_Spinner stopAnimating];

                    UIAlertView *Alert=[[UIAlertView alloc]initWithTitle:@"error" message:(NSString *)[OutputDic valueForKey:@"message"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                                       [Alert show];
                      [self ShowProgress:@"Please wait.." :YES];
                    [[self view] setUserInteractionEnabled:YES];
                });
            }
            else
            {
                PerformerId=(NSString *)[OutputDic valueForKey:@"userid"];
                Name=(NSString *)[OutputDic valueForKey:@"name"];
                handicapIndex  =(NSString *)[OutputDic valueForKey:@"handicapIndex"];
                point=(NSString *)[OutputDic valueForKey:@"Point"];
                
                
                
                NSData *tempData=[NSData dataWithContentsOfURL:[NSURL URLWithString:(NSString *)[OutputDic valueForKey:@"image"]]];
                
               // NSLog(@"%@",[OutputDic valueForKey:@"Point"]);
                
                NSUserDefaults *UserId=[[NSUserDefaults alloc] init];
                [UserId setObject:tempData forKey:SESSION_LOGGERIMAGEDATA];
                                [UserId synchronize];
                [UserId setValue:[OutputDic valueForKey:@"image"] forKey:SESSION_LOGGERIMAGEURL];
                
                [self performSelectorOnMainThread:@selector(RedirectMe) withObject:nil waitUntilDone:YES];
            }
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
               // [self ShowProgress:@"Incorrect user name & password" :YES];
               
                [_Spinner stopAnimating];

                UIAlertView *Alert=[[UIAlertView alloc]initWithTitle:@"error" message:@"Incorrect user name & password" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [Alert show];
                
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

-(void)RedirectMe
{
    [_LblError setHidden:YES];
    [_Spinner stopAnimating];

    
    NSUserDefaults *UserId = [NSUserDefaults standardUserDefaults];
    [UserId setObject:[_UserNameTxt text] forKey:SESSION_USERNAME];
    [UserId setObject:[_PasswordTxt text] forKey:SESSION_PASSWORD];
    [UserId setObject:PerformerId forKey:SESSION_ID];
    [UserId setObject:Name forKey:SESSION_LOGGERNAME];
    [UserId setObject:handicapIndex forKey:HANDICAPINDEX];
    [UserId setObject:point forKey:TOTALPOINT];
    [UserId synchronize];
    [[self view] setUserInteractionEnabled:YES];
    IsFBThreadFire=FALSE;
    TTTActivityStreem *Activity=[[TTTActivityStreem alloc]initWithNibName:@"TTTActivityStreem" bundle:nil];
    [self.navigationController pushViewController:Activity animated:YES];
    
    

    
}
- (IBAction)ForgetPassWord:(id)sender
{
    
    
    TTTForgetpasswordHome *Forgetpass=[[TTTForgetpasswordHome alloc]initWithNibName:@"TTTForgetpasswordHome" bundle:nil];
    [self.navigationController pushViewController:Forgetpass animated:YES];
    

}


- (IBAction)SignInTouched:(id)sender
{
    
  
    [_LoginScroll setContentOffset:CGPointMake(0, 0) animated:YES];
    if(![[_UserNameTxt text] length]>0)
    {
        //[self ShowProgress:@"Please enter your username" :YES];
        UIAlertView *Alert=[[UIAlertView alloc]initWithTitle:@"Sorry" message:@"Please enter your username" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [Alert show];
    }
    else if(![[_PasswordTxt text] length]>0)
    {
        //[self ShowProgress:@"Please enter your password" :YES];
        UIAlertView *Alert=[[UIAlertView alloc]initWithTitle:@"Sorry" message:@"Please enter your password" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [Alert show];
    }
    else
    {
        NSLog(@"%@", @"-1");
        [[self view] setUserInteractionEnabled:NO];
        NSMutableDictionary *ParamDic=[[NSMutableDictionary alloc] initWithCapacity:5];
       
        
        [self ShowProgress:@"Please wait.." :NO];
        
        NSInvocationOperation *RegisterOperation=[[NSInvocationOperation alloc] initWithTarget:self selector:@selector(ValidateAndRegisterMe) object:ParamDic];
        [OperationQueue addOperation:RegisterOperation];
        
        
    }
}

- (IBAction)GoestoSignup:(id)sender
{
    
    TTTSigninViewController *SignUp=[[TTTSigninViewController alloc]init];
    [self PushViewController:SignUp TransitationFrom:kCATransitionFade];
    
}

- (IBAction)FacebookSignup:(id)sender
{
    
     [self.SigninWithFb setBackgroundImage:[UIImage imageNamed:@"sign-in-with-facebook-on-tap"] forState:UIControlStateNormal];
     [self.SigninWithFb setBackgroundImage:[UIImage imageNamed:@"sign-in-with-facebook-on-tap"] forState:UIControlStateSelected];
     [self.SigninWithFb setBackgroundImage:[UIImage imageNamed:@"sign-in-with-facebook-on-tap"] forState:UIControlStateHighlighted];
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
- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI
{
    NSArray *permissions = [[NSArray alloc] initWithObjects: @"email", nil];
    
    NSLog(@"open1");
    
    return [FBSession openActiveSessionWithReadPermissions:permissions allowLoginUI:allowLoginUI completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
        [self sessionStateChanged:session state:status error:error];
    }];
    
}

-(void) getFacebookFeed
{
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
                [self ShowProgress:@"Incorrect user name & password" :YES];
                
                [[self view] setUserInteractionEnabled:YES];
            });
        }
    }
    @catch (NSException *juju)
    {
        NSLog(@"Reporting juju from ValidateAndRegisterMe %@", juju);
    }
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




-(void)viewDidDisappear:(BOOL)animated
{
    [OperationQueue cancelAllOperations];
}

@end
