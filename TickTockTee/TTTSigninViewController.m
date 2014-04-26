//
//  TTTSigninViewController.m
//  Ticktocktee
//
//  Created by Joydip Pal on 17/02/14.
//  Copyright (c) 2014 com.esolz.Ticktocktee. All rights reserved.
//

#import "TTTSigninViewController.h"
#import "TTTActivityStreem.h"
#import "TTTAppDelegate.h"
#import "TTTLoginViewController.h"
#import "TTTGlobalMethods.h"
#import "TTTSignInuploadImage.h"
#import "TTTLaunchViewController.h"


@interface TTTSigninViewController (){
    NSOperationQueue *OperationQueue;
    TTTGlobalMethods *Method;
    NSString *PerformerId;
    TTTAppDelegate *appDelegate;
}
@property (strong, nonatomic) IBOutlet UILabel *sign_in_text;
@property (strong, nonatomic) IBOutlet UITextField *name;
@property (strong, nonatomic) IBOutlet UIScrollView *scroll;
@property (strong, nonatomic) IBOutlet UITextField *UsernameTxt;
@property (strong, nonatomic) IBOutlet UITextField *EmailTxt;
@property (strong, nonatomic) IBOutlet UITextField *PasswordTxt;
@property (strong, nonatomic) IBOutlet UITextField *VerifypswdTxt;
@property (strong, nonatomic) IBOutlet UIScrollView *Signupscroll;
@property (strong, nonatomic) IBOutlet UILabel *LblError;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *Spinner;

@property (strong, nonatomic) IBOutlet UIButton *SigninWithfacebookBtn;




@end

@implementation TTTSigninViewController
@synthesize  name=_NameTxt;
@synthesize  UsernameTxt=_UserNameTxt;
@synthesize PasswordTxt =_PasswordTxt;
@synthesize  EmailTxt=_EmailTxt;
@synthesize VerifypswdTxt =_VerifypswdTxt;
@synthesize Signupscroll =_SignupScroll;
@synthesize LblError =_LblError;
@synthesize Spinner =_Spinner;
@synthesize SigninWithfacebookBtn=_SigninWithfacebookBtn;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self=(IsIphone5)?[super initWithNibName:@"TTTSigninViewController" bundle:nil]:[super initWithNibName:@"TTTSigninViewController_4" bundle:nil];
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
     appDelegate=(TTTAppDelegate *)[[UIApplication sharedApplication] delegate];
   
     [self.navigationController setNavigationBarHidden:YES animated:NO];
     OperationQueue=[[NSOperationQueue alloc] init];
     _sign_in_text.font=[UIFont fontWithName:@"MyriadProLight" size:13.0f];
     Method=[[TTTGlobalMethods alloc]init];
   
   
    self.name.font=[UIFont fontWithName:@"MyriadPro-Regular" size:16.0f];
    self.UsernameTxt.font=[UIFont fontWithName:@"MyriadPro-Regular" size:16.0f];
    self.PasswordTxt.font=[UIFont fontWithName:@"MyriadPro-Regular" size:16.0f];
    self.EmailTxt.font=[UIFont fontWithName:@"MyriadPro-Regular" size:16.0f];
    self.VerifypswdTxt.font=[UIFont fontWithName:@"MyriadPro-Regular" size:16.0f];
  
    // change press holder colour
    
     [self.name setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
     [self.UsernameTxt setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
     [self.PasswordTxt setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
     [self.EmailTxt setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
     [self.VerifypswdTxt setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
   
   
    
 }

// Perform Registration operation


-(void)ValidateAndRegisterMe:(NSMutableDictionary *)Param
{
   
    
    
    NSString *URL=[NSString stringWithFormat:@"%@user.php?mode=register_save&name=%@&username=%@&email=%@&password=%@&device_token=%@&device_type=%d", API, [Method Encoder:self.name.text], [Method Encoder:self.UsernameTxt.text], [Method Encoder:self.EmailTxt.text], [Method Encoder:self.PasswordTxt.text],appDelegate.deviceTokenString,2];
    NSLog(@"%@", URL);
    NSData *getData=[NSData dataWithContentsOfURL:[NSURL URLWithString:URL]];
    
    if([getData length]>0)
    {
        
        
        NSDictionary *OutputDic=[NSJSONSerialization JSONObjectWithData:getData options:kNilOptions error:nil];
        if([[OutputDic valueForKey:@"response"] isEqualToString:@"error"])
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [[self view] setUserInteractionEnabled:YES];
               // [self ShowProgress:(NSString *)[OutputDic valueForKey:@"message"] :YES];
                [_Spinner stopAnimating];
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"error" message:(NSString *)[OutputDic valueForKey:@"message"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
                
                
            });
        }
        else
        {
            PerformerId=(NSString *)[OutputDic valueForKey:@"userid"];
            [self performSelectorOnMainThread:@selector(RedirectMe) withObject:nil waitUntilDone:YES];
        }
    }
}






#pragma mark for Main Thread Segments

-(void)RedirectMe
{
    [_LblError setHidden:YES];
    [_Spinner stopAnimating];
    NSUserDefaults *UserId = [NSUserDefaults standardUserDefaults];
    [UserId setObject:[_UserNameTxt text] forKey:SESSION_USERNAME];
    [UserId setObject:[_PasswordTxt text] forKey:SESSION_PASSWORD];
    [UserId setObject:PerformerId forKey:SESSION_ID];
    [UserId setObject:_NameTxt.text forKey:SESSION_LOGGERNAME];
    [UserId setObject:@"0.0" forKey:HANDICAPINDEX];
    [UserId setObject:@"0" forKey:TOTALPOINT];
    [UserId synchronize];
    [[self view] setUserInteractionEnabled:YES];
    [UserId synchronize];
    
    TTTSignInuploadImage *Step2=[[TTTSignInuploadImage alloc]init];
    Step2.isUpdate=NO;
    [self.navigationController pushViewController:Step2 animated:YES];
    

    
    
    

}






//Progress bar section


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






- (IBAction)cross_btn:(id)sender
{
    
    TTTLaunchViewController *launch=[[TTTLaunchViewController alloc]init];
    [self PushViewController:launch TransitationFrom:kCATransitionFade];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden= YES;
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
   
   
    if (IsIphone5)
    {
         _SignupScroll.contentSize=CGSizeMake(320, 568);
    }
    else
    {
    _SignupScroll.contentSize=CGSizeMake(320, 468);
     }
     [_SignupScroll setContentOffset:CGPointMake(0, 0) animated:YES];
    [textField resignFirstResponder];
    
    return YES;

}




-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (IsIphone5)
    {
        _SignupScroll.contentSize=CGSizeMake(320, 700);
    }
    else
    {
    _SignupScroll.contentSize=CGSizeMake(320, 560);
    }
    
    
    if (textField==_NameTxt)
    {
        [_SignupScroll setContentOffset:CGPointMake(0, 10) animated:YES];
    }
    else if(textField==_UserNameTxt)
    {
        [_SignupScroll setContentOffset:CGPointMake(0, 20) animated:YES];
    }
    else if(textField==_EmailTxt)
    {
        [_SignupScroll setContentOffset:CGPointMake(0, 30) animated:YES];
    }
    else if(textField==_PasswordTxt)
    {
        [_SignupScroll setContentOffset:CGPointMake(0, 40) animated:YES];
    }
    else
    {
        [_SignupScroll setContentOffset:CGPointMake(0, 50) animated:YES];

    }
    
    return YES;
}



- (IBAction)SigninButtonClick:(id)sender
{
    
    [[self view] endEditing:YES];
    
    if(![[_NameTxt text] length]>0)
    {
        //[self ShowProgress:@"Please enter your real name" :YES];
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Sorry" message:@"Please enter your real name" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        
    }
    else if(![[_UserNameTxt text] length]>0)
    {
       // [self ShowProgress:@"Please enter your username" :YES];
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Sorry" message:@"Please enter your username!!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if(![[_EmailTxt text] length]>0)
    {
       // [self ShowProgress:@"Please enter your email" :YES];
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Sorry" message:@"Please enter your email!!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
       
    }
    else if(![[_PasswordTxt text] length]>0)
    {
        //[self ShowProgress:@"Please enter your password" :YES];
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Sorry" message:@"Please enter your password!!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if([[_PasswordTxt text] length]<6)
    {
        //[self ShowProgress:@"Password should be atleast 6 charachters long" :YES];
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Sorry" message:@"Password should be atleast 6 charachters long!!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if(![[_PasswordTxt text] isEqualToString:[_VerifypswdTxt text]])
    {
        //[self ShowProgress:@"Password & verify password are not same" :YES];
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Sorry" message:@"Password & verify password are not same!!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        NSString *emailid = [_EmailTxt text];
        NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
        NSPredicate *emailTest =[NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
        BOOL myStringMatchesRegEx=[emailTest evaluateWithObject:emailid];
        if(!myStringMatchesRegEx)
        {
           // [self ShowProgress:@"Invalid Email address." :YES];
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Sorry" message:@"Invalid Email address." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
        else
        {
            [[self view] setUserInteractionEnabled:NO];

            [self ShowProgress:@"Please wait.." :NO];
           
            NSInvocationOperation *RegisterOperation=[[NSInvocationOperation alloc] initWithTarget:self selector:@selector(ValidateAndRegisterMe:) object:nil];
            [OperationQueue addOperation:RegisterOperation];
        }
    }

    
}


- (IBAction)GoestoLoginScreen:(UIButton *)sender
{
    
    
   
    TTTLoginViewController *loginview=[[TTTLoginViewController alloc]init];
    [self PushViewController:loginview TransitationFrom:kCATransitionFade];
    
}

- (IBAction)nextpageBtn:(id)sender
{
    
    
    TTTSignInuploadImage *Step2=[[TTTSignInuploadImage alloc]init];
    Step2.isUpdate=NO;
    [self.navigationController pushViewController:Step2 animated:YES];

}

@end
