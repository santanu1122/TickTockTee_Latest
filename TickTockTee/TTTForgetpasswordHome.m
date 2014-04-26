//
//  TTTForgetpasswordHome.m
//  Ticktocktee
//
//  Created by macbook_ms on 19/02/14.
//  Copyright (c) 2014 com.esolz.Ticktocktee. All rights reserved.
//

#import "TTTForgetpasswordHome.h"
#import "TTTAppDelegate.h"
#import "TTTFoegetpasswordVarificationCode.h"


@interface TTTForgetpasswordHome ()
@property (strong, nonatomic) IBOutlet UITextField *EmailTxt;

@end

@implementation TTTForgetpasswordHome



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
   
    self.navigationController.navigationBar.hidden=NO;
    [self.EmailTxt setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
     
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)NextPage:(id)sender
{
    
    NSString *emailRegEx = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];

    if ([_EmailTxt.text length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed" message:@"Email field should not be left blank" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];

    }
    
    else if ([emailTest evaluateWithObject:_EmailTxt.text] == NO)
    {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed" message:@"Please Enter Valid Email Address." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
        
        return;
    }

    
    else
        
    {
    TTTFoegetpasswordVarificationCode *obj = [[TTTFoegetpasswordVarificationCode alloc]initWithNibName:@"TTTFoegetpasswordVarificationCode" bundle:Nil];
    
    [self.navigationController pushViewController:obj animated:YES];
    }
    
}

- (IBAction)PreviousPage:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


@end
