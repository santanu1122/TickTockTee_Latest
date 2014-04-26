//
//  TTTFoegetpasswordVarificationCode.m
//  TickTockTee
//
//  Created by macbook_ms on 20/02/14.
//  Copyright (c) 2014 com.esolz.TickTockTee. All rights reserved.
//

#import "TTTFoegetpasswordVarificationCode.h"
#import "TTTForgetpasswordChangeViewController.h"

@interface TTTFoegetpasswordVarificationCode ()
@property (weak, nonatomic) IBOutlet UITextField *Verificationtxt;

@end

@implementation TTTFoegetpasswordVarificationCode

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
    [self.Verificationtxt setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)NextPage:(id)sender
{
    
    TTTForgetpasswordChangeViewController *obj = [[TTTForgetpasswordChangeViewController alloc]initWithNibName:@"TTTForgetpasswordChangeViewController" bundle:nil];
    [self.navigationController pushViewController:obj animated:YES];
}
- (IBAction)PreviousPage:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
