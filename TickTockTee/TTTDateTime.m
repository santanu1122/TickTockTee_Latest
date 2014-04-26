//
//  TTTDateTime.m
//  TickTockTee
//
//  Created by macbook_ms on 26/02/14.
//  Copyright (c) 2014 com.esolz.TickTockTee. All rights reserved.
//

#import "TTTDateTime.h"
#import "SVProgressHUD.h"

@interface TTTDateTime ()
{
    BOOL IsChatBoxOpen, IsLeftMenuBoxOpen, IsForStartTime;
    UIActionSheet *menu;
    UIDatePicker *datePicker, *datePickerEnd;
    UITapGestureRecognizer *taptoActionSet;
    
}

@property (strong, nonatomic) IBOutlet UILabel *StartLable;

@property (strong, nonatomic) IBOutlet UILabel *Enddate;



@end

@implementation TTTDateTime
@synthesize SVScreen,StartLable,Enddate;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self=(IsIphone5)?[super initWithNibName:@"TTTdateTime_iPhone5" bundle:nil]:[super initWithNibName:@"TTTDateTime" bundle:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self PrepareScreen];
}
-(void)viewDidAppear:(BOOL)animated
{
    NSUserDefaults *session=[[NSUserDefaults alloc] init];
    NSDictionary *SessionParam=[session objectForKey:SESSION_MATCHCREATEPARAMETES];
    
    if([[SessionParam valueForKey:PARAM_START_TIME] length]>0)
    {
        [StartLable setText:[SessionParam valueForKey:PARAM_START_TIME]];
    }
    
    if([[SessionParam valueForKey:PARAM_END_TIME] length]>0)
    {
        [Enddate setText:[SessionParam valueForKey:PARAM_END_TIME]];
    }
}

-(void)viewDidDisappear:(BOOL)animated
{
    [SVProgressHUD dismiss];
}


- (IBAction)Performgoback:(id)sender
{
    
//    NSUserDefaults *session=[[NSUserDefaults alloc] init];
//    NSMutableDictionary *SessionParam=[[NSMutableDictionary alloc] initWithDictionary:[session objectForKey:SESSION_MATCHCREATEPARAMETES]];
//    [SessionParam setValue:nil forKey:PARAM_START_TIME];
//    [SessionParam setValue:nil forKey:PARAM_END_TIME];
//    [session setObject:SessionParam forKey:SESSION_MATCHCREATEPARAMETES];
//    [session synchronize];

    [self dismissViewControllerAnimated:YES completion:^{
        [SVProgressHUD dismiss];
    }];
}
- (IBAction)cencelButton:(id)sender
{
   




    
    [self dismissViewControllerAnimated:YES completion:^{
        [SVProgressHUD dismiss];
    }];
    
}
- (IBAction)DoneButtonClick:(id)sender
{
    NSUserDefaults *session=[[NSUserDefaults alloc] init];
    NSMutableDictionary *SessionParam=[[NSMutableDictionary alloc] initWithDictionary:[session objectForKey:SESSION_MATCHCREATEPARAMETES]];
    [SessionParam setValue:[StartLable text] forKey:PARAM_START_TIME];
    [SessionParam setValue:[Enddate text] forKey:PARAM_END_TIME];
    [session setObject:SessionParam forKey:SESSION_MATCHCREATEPARAMETES];
    [session synchronize];
    
    
    [self dismissViewControllerAnimated:YES completion:^{
        [SVProgressHUD dismiss];
     }];
    
}

-(void)PrepareScreen
{
    
    IsLeftMenuBoxOpen=FALSE;
    IsForStartTime=TRUE;
       Enddate.font=[UIFont fontWithName:@"MyriadPro-Regular" size:16.0f];
       StartLable.font=[UIFont fontWithName:@"MyriadPro-Regular" size:16.0f];
    
     [Enddate setTextColor:[UIColor whiteColor]];
      datePicker=[[UIDatePicker alloc] initWithFrame:CGRectMake(0, 150, 320, 100)];
     NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    
    [datePicker setDatePickerMode:UIDatePickerModeDateAndTime];
    
    
     NSDate *NewDate=[[NSDate alloc] initWithTimeInterval:60*5 sinceDate:[datePicker date]];
     NSDate *NewDateSet=[[NSDate alloc] initWithTimeInterval:0 sinceDate:[datePicker date]];
     [datePicker setMinimumDate:NewDateSet];
    
    NSDateComponents* addOneMonthComponents = [NSDateComponents new] ;
    addOneMonthComponents.year = 1 ;
    NSDate* NextYear = [[NSCalendar currentCalendar] dateByAddingComponents:addOneMonthComponents toDate:[NSDate date] options:0];
    [datePicker setMaximumDate:NextYear];
    [datePicker setDatePickerMode:UIDatePickerModeDateAndTime];
    
    menu = [[UIActionSheet alloc] initWithTitle:@"Select a Date & Time" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"Cancel" otherButtonTitles:@"Done", nil];
    
    
     datePickerEnd=[[UIDatePicker alloc] initWithFrame:CGRectMake(0, 150, 320, 100)];
    [datePickerEnd setDatePickerMode:UIDatePickerModeDate];
    
    NSDate *NewDateEnd=[[NSDate alloc] initWithTimeInterval:60*60*4 sinceDate:[datePicker date]];
    [datePickerEnd setMinimumDate:NewDateEnd];
    
    NSDateComponents* addOneMonthComponentsEnd = [NSDateComponents new];
    addOneMonthComponentsEnd.year = 1 ;
    NSDate* NextYearEnd = [[NSCalendar currentCalendar] dateByAddingComponents:addOneMonthComponents toDate:[NSDate date] options:0];
    [datePickerEnd setMaximumDate:NextYearEnd];
    [datePickerEnd setDatePickerMode:UIDatePickerModeDateAndTime];
    
    datePicker.date=NewDate;
    [dateFormatter setDateFormat:@"MM/dd/yyyy  hh:mm a"];
    
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];

    [StartLable setText:[dateFormatter stringFromDate:NewDate]];
    [Enddate setText:[dateFormatter stringFromDate:[datePickerEnd date]]];
    
    NSUserDefaults *session=[[NSUserDefaults alloc] init];
    NSMutableDictionary *SessionParam=[[NSMutableDictionary alloc] initWithDictionary:[session objectForKey:SESSION_MATCHCREATEPARAMETES]];
    if ([[SessionParam valueForKey:PARAM_START_TIME] length]>0)
    {
        StartLable.text=[SessionParam valueForKey:PARAM_START_TIME];
    }
    else
    {
      //[SessionParam setValue:[StartLable text] forKey:PARAM_START_TIME];
    }
    
    if ([[SessionParam valueForKey:PARAM_END_TIME] length]>0)
    {
        Enddate.text=[SessionParam valueForKey:PARAM_END_TIME];
    }
    else
    {
      //  [SessionParam setValue:[Enddate text] forKey:PARAM_END_TIME];
    }
     [session setObject:SessionParam forKey:SESSION_MATCHCREATEPARAMETES];
     [session synchronize];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)TouchStartdate
{
    NSLog(@"Start date");
    IsForStartTime=TRUE;
    [menu setUserInteractionEnabled:YES];
    [menu addSubview:datePicker];
    [menu showInView:SVScreen];
    [menu setBounds:CGRectMake(0,0,320, 600)];
}
-(void)TouchToEndButton
{
    NSLog(@"End date");
    IsForStartTime=FALSE;
    [menu setUserInteractionEnabled:YES];
    [menu addSubview:datePickerEnd];
    [menu showInView:SVScreen];
    [menu setBounds:CGRectMake(0,0,320, 600)];
}

#pragma UIActionSetdelegate


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //Get the name of the current pressed button
    
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    
    if ([buttonTitle isEqualToString:@"Cancel"])
    {
        [datePicker removeFromSuperview];
        [datePickerEnd removeFromSuperview];
    }
    else if ([buttonTitle isEqualToString:@"Done"])
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
       
         [dateFormatter setDateFormat:@"MM/dd/yyyy  hh:mm a"];
         //[dateFormatter setDateFormat:[NSDateFormatter dateFormatFromTemplate:@"MM/dd/yyyy  hh:mm a" options:0 locale:[NSLocale currentLocale]]];
        
        
        if(IsForStartTime)
        {
            [StartLable setText:[NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:[datePicker date]]]];
            
//             NSUserDefaults *session=[[NSUserDefaults alloc] init];
//             NSMutableDictionary *SessionParam=[[NSMutableDictionary alloc] initWithDictionary:[session objectForKey:SESSION_MATCHCREATEPARAMETES]];
//             [SessionParam setValue:[StartLable text] forKey:PARAM_START_TIME];
//             [session setObject:SessionParam forKey:SESSION_MATCHCREATEPARAMETES];
//             [session synchronize];
             [datePicker removeFromSuperview];
             [datePickerEnd removeFromSuperview];
        }
        else
        {
             [Enddate setText:[NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:[datePickerEnd date]]]];
             NSUserDefaults *session=[[NSUserDefaults alloc] init];
             NSMutableDictionary *SessionParam=[[NSMutableDictionary alloc] initWithDictionary:[session objectForKey:SESSION_MATCHCREATEPARAMETES]];
             [SessionParam setValue:[Enddate text] forKey:PARAM_END_TIME];
            
             [session setObject:SessionParam forKey:SESSION_MATCHCREATEPARAMETES];
             [session synchronize];
             [datePicker removeFromSuperview];
             [datePickerEnd removeFromSuperview];
        }
    }
}

- (IBAction)StartButtonclivk:(id)sender
{
    NSLog(@"Show date paicker");
    IsForStartTime=TRUE;
    [menu setUserInteractionEnabled:YES];
    [menu addSubview:datePicker];
    [menu showInView:SVScreen];
    [menu setBounds:CGRectMake(0,0,320, 600)];
}

- (IBAction)EndButtonClick:(id)sender
{
     NSLog(@"Show date paicker");
    IsForStartTime=FALSE;
    [menu setUserInteractionEnabled:YES];
    [menu addSubview:datePickerEnd];
    [menu showInView:SVScreen];
    [menu setBounds:CGRectMake(0,0,320, 600)];
}



@end
