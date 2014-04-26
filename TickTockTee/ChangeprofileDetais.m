//
//  ChangeprofileDetais.m
//  TickTockTee
//
//  Created by macbook_ms on 25/02/14.
//  Copyright (c) 2014 com.esolz.TickTockTee. All rights reserved.
//

#import "ChangeprofileDetais.h"
#import "TTTSignInuploadImage.h"
#import "TTTMyprofilePage.h"
#import "TTTGlobalMethods.h"
#import "TTTActivityStreem.h"




@interface ChangeprofileDetais ()<UIAlertViewDelegate>
{
    NSOperationQueue *operation;
    NSMutableDictionary *maindataDic;
    TTTGlobalMethods *globalMethod;
    NSString *message;
    NSString *resoponce;
}
@property (strong, nonatomic) IBOutlet UILabel *Lblusernmae;
@property (strong, nonatomic) IBOutlet UILabel *Lbklyourname;
@property (strong, nonatomic) IBOutlet UILabel *Lblemail;
@property (strong, nonatomic) IBOutlet UILabel *Lblpassword;
@property (strong, nonatomic) IBOutlet UILabel *LblvarifyPas;
@property (strong, nonatomic) IBOutlet UILabel *userNameTxt;
@property (strong, nonatomic) IBOutlet UITextField *YournmaeTxt;
@property (strong, nonatomic) IBOutlet UITextField *EmailTxt;
@property (strong, nonatomic) IBOutlet UITextField *PassWordTxt;
@property (strong, nonatomic) IBOutlet UITextField *ViarifypassWordTxt;
@property (weak, nonatomic) IBOutlet UILabel *LblSkip;
@property (weak, nonatomic) IBOutlet UIButton *Saveuserdate;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *Spinner;
@property (strong, nonatomic) IBOutlet UIScrollView *EditAccoundScroll;
@end

@implementation ChangeprofileDetais
@synthesize EditAccoundScroll;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}




- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    operation=[[NSOperationQueue alloc]init];
    [self.userNameTxt setUserInteractionEnabled:NO];
    maindataDic=[[NSMutableDictionary alloc]init];
     globalMethod=[[TTTGlobalMethods alloc]init];
    self.Lblemail.font=[UIFont fontWithName:@"MyriadPro-Regular" size:15.0f];
    self.Lblpassword.font=[UIFont fontWithName:@"MyriadPro-Regular" size:15.0f];
    self.LblSkip.font=[UIFont fontWithName:@"MyriadPro-Regular" size:17.0f];
    self.Lblusernmae.font=[UIFont fontWithName:@"MyriadPro-Regular" size:15.0f];
    self.LblvarifyPas.font=[UIFont fontWithName:@"MyriadPro-Regular" size:15.0f];
    self.Lbklyourname.font=[UIFont fontWithName:@"MyriadPro-Regular" size:15.0f];
    
   
    
     self.userNameTxt.font=[UIFont fontWithName:@"MyriadPro-Regular" size:16.0f];
     self.userNameTxt.textColor=[UIColor grayColor];
     self.YournmaeTxt.font=[UIFont fontWithName:@"MyriadPro-Regular" size:16.0f];
     self.EmailTxt.font=[UIFont fontWithName:@"MyriadPro-Regular" size:16.0f];
     self.PassWordTxt.font=[UIFont fontWithName:@"MyriadPro-Regular" size:16.0f];
     self.ViarifypassWordTxt.font=[UIFont fontWithName:@"MyriadPro-Regular" size:16.0f];
    
    // change press holder colour
    
    
    [self.YournmaeTxt setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.EmailTxt setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.PassWordTxt setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.ViarifypassWordTxt setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.Saveuserdate setBackgroundColor:UIColorFromRGB(0x71d65a)];
//    [self.Saveuserdate addTarget:self action:@selector(SaveUserdateforEdit:) forControlEvents:UIControlEventTouchUpInside];
    
    NSInvocationOperation *istoperatiuon=[[NSInvocationOperation alloc]initWithTarget:self selector:@selector(loadAlldata) object:nil];
    [operation addOperation:istoperatiuon];
    
    
}

//Saving data if user edit

-(void)loadAlldata
{
    NSUserDefaults *userDefals=[NSUserDefaults standardUserDefaults];
    NSString *string=[NSString stringWithFormat:@"%@user.php?mode=userprofile&userid=%@&viewid=%@",API,[userDefals valueForKey:SESSION_ID],[userDefals valueForKey:SESSION_ID]];
    NSLog(@"data:%@",string);
    NSURL *url=[NSURL URLWithString:string];
    NSData *data=[NSData dataWithContentsOfURL:url];
    NSDictionary *mainDic=[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    [maindataDic setObject:[mainDic valueForKey:@"username"] forKey:@"username"];
    [maindataDic setObject:[mainDic valueForKey:@"thumb"] forKey:@"thumb"];
    [maindataDic setObject:[mainDic valueForKey:@"userfullname"] forKey:@"userfullname"];
    [maindataDic setObject:[mainDic valueForKey:@"Gender"] forKey:@"Gender"];
    [maindataDic setObject:[mainDic valueForKey:@"Birthdate"] forKey:@"Birthdate"];
    [maindataDic setObject:[mainDic valueForKey:@"About me"] forKey:@"About me"];
    [maindataDic setObject:[mainDic valueForKey:@"Mobile phone"] forKey:@"Mobile phone"];
    [maindataDic setObject:[mainDic valueForKey:@"Land phone"] forKey:@"Land phone"];
    [maindataDic setObject:[mainDic valueForKey:@"Mobile phone"] forKey:@"Mobile phone"];
    [maindataDic setObject:[mainDic valueForKey:@"email"] forKey:@"email"];
    [self performSelectorOnMainThread:@selector(AdddatatoFields) withObject:nil waitUntilDone:YES];
    
    
}

-(void)AdddatatoFields
{
    _userNameTxt.text=[maindataDic valueForKey:@"username"];
    _YournmaeTxt.text=[maindataDic valueForKey:@"userfullname"];
    _EmailTxt.text=[maindataDic valueForKey:@"email"];
    [self.Spinner stopAnimating];
}

-(IBAction)SaveUserdateforEdit:(id)sender
 {
     //[[self view] endEditing:YES];
     
     if(![[_YournmaeTxt text] length]>0)
     {
         
         UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Error" message:@"Please enter your real name" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"nil", nil];
         [alert show];
     }
     
     else if(![[_EmailTxt text] length]>0)
     {
      
         UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Error" message:@"Please enter your email" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"nil", nil];
         [alert show];
     }
     
     else if(![[_PassWordTxt text] isEqualToString:[_ViarifypassWordTxt text]])
     {
         
         UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Error" message:@"Password & verify password are not same" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"nil", nil];
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
             
             UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Error" message:@"Invalid Email address." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"nil", nil];
             [alert show];
         }
         else
         {
            
             [self.Spinner startAnimating];
             
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
             [self ValidateAndRegisterMe];
            });
//             NSInvocationOperation *RegisterOperation=[[NSInvocationOperation alloc] initWithTarget:self selector:@selector(ValidateAndRegisterMe) object:nil];
//             [operation addOperation:RegisterOperation];
         }
     }
     

 }


-(void)ValidateAndRegisterMe
{
   
   
    NSUserDefaults *userdefals=[NSUserDefaults standardUserDefaults];
    NSString *urlString=[NSString stringWithFormat:@"%@user.php?mode=update_account&step=1&userid=%@&name=%@&email=%@&password=%@",API,[userdefals valueForKey:SESSION_ID],[globalMethod Encoder:_YournmaeTxt.text],[globalMethod Encoder:_EmailTxt.text ],[globalMethod Encoder:_PassWordTxt.text]];
    NSLog(@"url strimg:%@",urlString);
    NSURL *url=[NSURL URLWithString:urlString];
    NSData *data=[NSData dataWithContentsOfURL:url];
    NSDictionary *Dic=[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    NSLog(@"This is the dictionay:%@",Dic);
     resoponce=[Dic valueForKey:@"response"];
       NSLog(@"Massage:%@",resoponce);
  
     message=[Dic valueForKey:@"message"];
     NSLog(@"Massage:%@",message);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self ChangeDetais];
    });
    
    
}

-(void)ChangeDetais
{
    
    NSLog(@"The change details:");
    [self.Spinner stopAnimating];
    
    if ([message isEqualToString:@"success"])
    {
       
        NSUserDefaults *UserId = [NSUserDefaults standardUserDefaults];
        if (_PassWordTxt.text.length>0)
        {
              [UserId setObject:[_PassWordTxt text] forKey:SESSION_PASSWORD];
        }
        
        
           [UserId setObject:_YournmaeTxt.text forKey:SESSION_LOGGERNAME];
        
          [UserId synchronize];
       
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:resoponce message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:resoponce message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([message isEqualToString:@"success"])
     {
         TTTSignInuploadImage *uploadImage=[[TTTSignInuploadImage alloc]initWithNibName:@"TTTSignInuploadImage" bundle:nil];
          uploadImage.isUpdate=YES;
         [self.navigationController pushViewController:uploadImage animated:YES];
     }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)SkipToNextbutton:(id)sender
{
    TTTSignInuploadImage *uploadImage=[[TTTSignInuploadImage alloc]initWithNibName:@"TTTSignInuploadImage" bundle:nil];
    [self.navigationController pushViewController:uploadImage animated:YES];
    
}
- (IBAction)BackToprofilepage:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
      [textField resignFirstResponder];
      [self.EditAccoundScroll setContentOffset:CGPointMake(0, 0) animated:YES];
      return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField==_YournmaeTxt)
    {
      [self.EditAccoundScroll setContentOffset:CGPointMake(0, 10) animated:YES];
    }
    else if (textField==_EmailTxt)
    {
          [self.EditAccoundScroll setContentOffset:CGPointMake(0, 20) animated:YES];
    }
    
    return YES;
}

@end
