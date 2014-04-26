//
//  TTTForgetpasswordChangeViewController.m
//  TickTockTee
//
//  Created by Arnab on 20/02/14.
//  Copyright (c) 2014 com.esolz.TickTockTee. All rights reserved.
//

#import "TTTForgetpasswordChangeViewController.h"

@interface TTTForgetpasswordChangeViewController ()
@property (weak, nonatomic) IBOutlet UITextField *EnterPasswordTxt;
@property (weak, nonatomic) IBOutlet UITextField *VerifyPasswordTxt;

@end

@implementation TTTForgetpasswordChangeViewController

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
    [self.EnterPasswordTxt setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.VerifyPasswordTxt setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)NextPage:(id)sender {
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
