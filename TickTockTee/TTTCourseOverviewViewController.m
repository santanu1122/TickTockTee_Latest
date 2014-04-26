//
//  TTTCourseOverviewViewController.m
//  TickTockTee
//
//  Created by Esolz_Mac on 10/04/14.
//  Copyright (c) 2014 com.esolz.TickTockTee. All rights reserved.
//

#import "TTTCourseOverviewViewController.h"

@interface TTTCourseOverviewViewController (){
    NSOperationQueue *OperationQ;
    NSDictionary *dicForoverview;
}

@end

@implementation TTTCourseOverviewViewController
@synthesize ScreenView,dataview,scroll,overviewlist,page_title;
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
    page_title.font = [UIFont fontWithName:MYREADPROREGULAR size:19.0];
    OperationQ=[[NSOperationQueue alloc]init];
    
        

    if(overviewlist.count>0)
    {
        [SVProgressHUD show];
        [self showoverview];
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD showErrorWithStatus:@"No data found!"];
            
        });
    }

}
-(void)showoverview
{
   UILabel *phone= (UILabel *) [dataview viewWithTag:100];
    phone.text=@"Phone";
    phone.font=[UIFont fontWithName:MYREADPROREGULAR size:15.0f];
    UILabel *phoneno= (UILabel *) [dataview viewWithTag:101];
    phoneno.text=[overviewlist valueForKey:@"phone"];
    phoneno.font=[UIFont fontWithName:MYREADPROREGULAR size:15.0f];
    UILabel *fax= (UILabel *) [dataview viewWithTag:102];
    fax.text=@"Fax";
    fax.font=[UIFont fontWithName:MYREADPROREGULAR size:15.0f];
    UILabel *faxno= (UILabel *) [dataview viewWithTag:103];
    faxno.text=[overviewlist valueForKey:@"fax_number"];
     faxno.font=[UIFont fontWithName:MYREADPROREGULAR size:15.0f];
    UILabel *website= (UILabel *) [dataview viewWithTag:104];
    website.text=@"Website";
     website.font=[UIFont fontWithName:MYREADPROREGULAR size:15.0f];
    UILabel *websitetxt= (UILabel *) [dataview viewWithTag:105];
    websitetxt.text=[overviewlist valueForKey:@"course_url"];
     websitetxt.font=[UIFont fontWithName:MYREADPROREGULAR size:15.0f];
    UILabel *address= (UILabel *) [dataview viewWithTag:106];
    address.text=@"Address";
    address.font=[UIFont fontWithName:MYREADPROREGULAR size:15.0f];
    UILabel *Addresstxt= (UILabel *) [dataview viewWithTag:107];
    Addresstxt.font=[UIFont fontWithName:MYREADPROREGULAR size:15.0f];
    Addresstxt.text=[overviewlist valueForKey:@"location"];
    UILabel *Architect= (UILabel *) [dataview viewWithTag:108];
    Architect.font=[UIFont fontWithName:MYREADPROREGULAR size:15.0f];
    Architect.text=@"Course Architect";
    UILabel *Architecttxt= (UILabel *) [dataview viewWithTag:109];
    Architecttxt.text=[overviewlist valueForKey:@"architects"];
    Architecttxt.font=[UIFont fontWithName:MYREADPROREGULAR size:15.0f];
    UILabel *year_builts= (UILabel *) [dataview viewWithTag:110];
    year_builts.font=[UIFont fontWithName:MYREADPROREGULAR size:15.0f];
    year_builts.text=@"Built Year";
    UILabel *year_builtstxt= (UILabel *) [dataview viewWithTag:111];
    year_builtstxt.text=[overviewlist valueForKey:@"year_builts"];
    year_builtstxt.font=[UIFont fontWithName:MYREADPROREGULAR size:15.0f];
    UILabel *total_holes= (UILabel *) [dataview viewWithTag:112];
    total_holes.text=@"Total Holes";
     total_holes.font=[UIFont fontWithName:MYREADPROREGULAR size:15.0f];
    UILabel *total_holestxt= (UILabel *) [dataview viewWithTag:113];
    total_holestxt.text=[overviewlist valueForKey:@"total_holes"];
     total_holestxt.font=[UIFont fontWithName:MYREADPROREGULAR size:15.0f];
    [SVProgressHUD dismiss];
    
}
- (IBAction)backButtonClick:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
