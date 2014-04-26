//
//  TTTCreatematch.m
//  TickTockTee
//
//  Created by macbook_ms on 26/02/14.
//  Copyright (c) 2014 com.esolz.TickTockTee. All rights reserved.
//

#import "TTTCreatematch.h"

#import "TTTAddFriend.h"
#import "TTTLocationName.h"
#import "TTTDateTime.h"
#import "TTTTeabox.h"
#import "SVProgressHUD.h"
#import "TTTGlobalMethods.h"
#import "TTTMatchListing.h"
#import "TTTMatchListing.h"
#import "TTTMatchDetails.h"
#import <CoreLocation/CoreLocation.h>
#import "TTTShowAllfriendmanu.h"
@interface TTTCreatematch ()<UITextFieldDelegate,UITextViewDelegate,UITextFieldDelegate,UITextViewDelegate,UIAlertViewDelegate>
 {
      BOOL IsComingForEdit;
     
      UITapGestureRecognizer *tapgesture;
      NSString *couse_id;
      NSString *course_name;
      NSOperationQueue *operationQ;
      TTTGlobalMethods *Method;
      NSMutableArray *SelectedFriends;
      NSString *FriendIds;
    
 }

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) IBOutlet UIView *Courseview;
@property (strong, nonatomic) IBOutlet UIView *TeeBoxView;
@property (strong, nonatomic) IBOutlet UIView *InviteFndview;
@property (strong, nonatomic) IBOutlet UIScrollView *FriendListScroll;
@property (strong, nonatomic) IBOutlet UIView *dateAndTimeView;
@property (strong, nonatomic) IBOutlet UITextView *DescrioptonTxtview;
@property (strong, nonatomic) IBOutlet UIView *SmallTeaView;

@end

 @implementation TTTCreatematch
 @synthesize courseId;
 @synthesize CourseName;
@synthesize isCommingfromLocation;

@synthesize IsComingFromActivityScreen;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
        self=(IsIphone5)?[super initWithNibName:@"TTTCreatematch" bundle:nil]:[super initWithNibName:@"TTTCreatematch_iPhone4" bundle:nil];
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    IsComingFromActivityScreen=NO;
    
    
    
    NSArray *Array=[self.FriendListScroll subviews];
    if ([Array count]>1)
    {
        for (UIView *Imgview in Array)
        {
            [Imgview removeFromSuperview];
        }

    }
    
    SelectedFriends=[[NSMutableArray alloc]init];
    Method=[[TTTGlobalMethods alloc]init];
    operationQ =[[NSOperationQueue alloc]init];
    NSUserDefaults *userDetais=[NSUserDefaults standardUserDefaults];
    courseId=[userDetais valueForKey:COURSE_ID];
    CourseName=[userDetais valueForKey:COURSE_NAME];
    
    if ([courseId integerValue]>0)
    {
        self.CourceLable.text=[userDetais valueForKey:COURSE_NAME];
    }
    
    NSDictionary *SessionParam=[userDetais objectForKey:SESSION_MATCHCREATEPARAMETES];
    NSLog(@"Start time start date:%@ %@",[[[[SessionParam valueForKey:PARAM_START_TIME] componentsSeparatedByString:@"  "] objectAtIndex:1] componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@": "]],[SessionParam valueForKey:PARAM_END_TIME]);
    
    
    if([[SessionParam valueForKey:PARAM_TEEBOX_NAME] length]>1)
    {
         [self.teaBoxLbl setText:[SessionParam valueForKey:PARAM_TEEBOX_NAME]];
         [_SmallTeaView setBackgroundColor:[TTTGlobalMethods colorFromHexString:[SessionParam valueForKey:PARAM_TEEBOX_COLOR]]];
         CGRect FrameOfTeebox=[_SmallTeaView frame];
         self.SmallTeaView.layer.cornerRadius=FrameOfTeebox.size.width/2;
         [self.SmallTeaView.layer setMasksToBounds:YES];
    }
    else
    {
        [[self teaBoxLbl] setText:@"Tee Box"];
        [self.SmallTeaView setBackgroundColor:[UIColor clearColor]];
    }
    
    if([[SessionParam valueForKey:PARAM_START_TIME] length]>0)
    {
        NSString *EndTime=[SessionParam valueForKey:PARAM_END_TIME];
    
        NSString *mainString=[NSString stringWithFormat:@"%@ %@ %@",[SessionParam valueForKey:PARAM_START_TIME],@"to",EndTime];
       [_DateAndTimeLbl setText:mainString];
    }
    

   
    FriendIds=[SessionParam valueForKey:PARAM_SELECTED_FRIENDS];
  
    if ([FriendIds length]>0)
    {
        self.invitefndLable.hidden=YES;
    }
     else
     {
       self.invitefndLable.hidden=NO;
     }
     NSInvocationOperation *Operation=[[NSInvocationOperation alloc] initWithTarget:self selector:@selector(getMyFriends) object:nil];
     [operationQ addOperation:Operation];
     [userDetais synchronize];
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self SetborderAndFrame];
   
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    self.navigationController.navigationBar.hidden=YES;
    [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
   
    [_DescrioptonTxtview setReturnKeyType:UIReturnKeyDone];
}

-(void)SetborderAndFrame
 {
     [_matchNameTxt setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
     [_matchNameTxt setTextColor:[UIColor whiteColor]];
     _matchNameTxt.font=[UIFont fontWithName:@"MyriadPro-Semibold" size:17.0f];
     _DescriotionlanleTxt.font=[UIFont fontWithName:@"MyriadPro-Regular" size:17.0f];
   
      _CourceLable.font=[UIFont fontWithName:@"MyriadPro-Semibold" size:17.0f];
      _teaBoxLbl.font=[UIFont fontWithName:@"MyriadPro-Semibold" size:17.0f];
       _DateAndTimeLbl.font=[UIFont fontWithName:@"MyriadPro-Semibold" size:17.0f];
      _invitefndLable.font=[UIFont fontWithName:@"MyriadPro-Semibold" size:17.0f];
      _DescrioptonTxtview.textColor=[UIColor whiteColor];
     
       _DescriotionlanleTxt.font=[UIFont fontWithName:@"MyriadPro-Semibold" size:17.0f];
      _DescrioptonTxtview.userInteractionEnabled=YES;
      _DescrioptonTxtview.editable=YES;
      _DescrioptonTxtview.textColor=[UIColor whiteColor];
      _DescrioptonTxtview.font=[UIFont fontWithName:@"MyriadPro-Regular" size:17.0f];
      _DescrioptonTxtview.delegate=self;
      tapgesture=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(coueseTouch:)];
      [self.Courseview addGestureRecognizer:tapgesture];
      tapgesture=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(Teaboxtouch:)];
      [self.TeeBoxView addGestureRecognizer:tapgesture];
      tapgesture=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(FriendTouch:)];
      [self.FriendListScroll addGestureRecognizer:tapgesture];
      tapgesture=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(Datetime:)];
      [self.dateAndTimeView addGestureRecognizer:tapgesture];
      [_DescrioptonTxtview setBackgroundColor:[UIColor clearColor]];
     
    
     
  
 }

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    [_DescriotionlanleTxt setHidden:YES];
    
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    if (_DescrioptonTxtview.text.length==0)
    {
        [_DescriotionlanleTxt setHidden:NO];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
     return YES;
}
- (IBAction)DismissView:(id)sender
{
    
    [self dismissViewControllerAnimated:YES completion:^{
        
        
    }];
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
   
   
    if([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        return NO;
    }
   
   return YES;
    }


-(void)getMyFriends

{
    
    @try
    
    {
        
        NSString *URL=[NSString stringWithFormat:@"%@user.php?mode=friends&userid=%@", API, [self LoggedId]];
        
        NSLog(@"%@", URL);
        
        NSData *getData=[NSData dataWithContentsOfURL:[NSURL URLWithString:URL]];
        
        
        
        if([getData length]>2)
            
        {
            
            [SelectedFriends removeAllObjects];
            
            NSDictionary *Output=[NSJSONSerialization JSONObjectWithData:getData options:kNilOptions error:nil];
            
            NSArray *FriendArry=[Output valueForKey:@"friendslist"];
            
            NSArray *SelectedFriendsArray=[FriendIds componentsSeparatedByString:@","];
            
            
            
            for(NSDictionary *var in FriendArry)
                
            {
                
                if([self IsSelectedFriendsWithId:[var objectForKey:@"FriendId"] From:SelectedFriendsArray])
                    
                    [SelectedFriends addObject:[[TTTGlobalMethods alloc] initWithId:[var objectForKey:@"FriendId"] withFriendName:[var objectForKey:@"FriendName"] withFriendImageURL:[var objectForKey:@"FriendImage"] withNoOfFriends:[var objectForKey:@"Totalfriends"] withFriendId:[var objectForKey:@"FriendId"]]];
                
            }
            
            NSLog(@"The selected friend array count:%d",[SelectedFriends count]);
            
            
            
            [self performSelectorOnMainThread:@selector(ShowMySelectedFriends) withObject:nil waitUntilDone:YES];
            
        }
        
        
        
    }
    
    @catch (NSException *juju)
    
    {
        
        NSLog(@"Reporting juju from getLocation : %@", juju);
        
    }
    
}
-(void)ShowMySelectedFriends
{
    int i=0;
    
    for (TTTGlobalMethods *localmathod in SelectedFriends)
    {
         UIImageView *FriendImage=[[UIImageView alloc]initWithFrame:CGRectMake(10+i*46, 7, 36, 36)];
         [self SetroundborderWithborderWidth:2.0f WithColour:UIColorFromRGB(0xe4f5f4) ForImageview:FriendImage];
         UIActivityIndicatorView *Spinner=[[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(7.0f, 7.0f, 20.0f, 20.0f)];
         [Spinner setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
         [Spinner setHidesWhenStopped:YES];
         [Spinner startAnimating];
         [Spinner setTag:[[localmathod Id] integerValue]];
         [FriendImage addSubview:Spinner];
         [self.FriendListScroll addSubview:FriendImage];
         [self LoadImage:@[FriendImage, [NSURL URLWithString:[localmathod FriendImageURL]], [localmathod Id], @"Fill"]];
         i++;
    }
    [self.FriendListScroll setContentSize:CGSizeMake(20+46*[SelectedFriends count],48)];
}


-(BOOL)IsSelectedFriendsWithId:(NSString *)Id From:(NSArray *)tempSelectedFriendsArray
{
    for(NSString *friendId in tempSelectedFriendsArray)
    {
        if([friendId isEqualToString:Id])
        {
            return TRUE;
        }
    }
     return false;
}


-(void)Datetime:(UITapGestureRecognizer *)touch
 {
    
     NSLog(@"the ttt date and time:");
     TTTDateTime *dateTime=[[TTTDateTime alloc] init];
     [self presentViewController:dateTime animated:YES completion:^{
         
     }];
 }

-(void)coueseTouch:(UITapGestureRecognizer *)Recognizer
 {
    
     
    
     NSLog(@"This is array");
     TTTLocationName *coursename=[[TTTLocationName alloc]init];
     [self presentViewController:coursename animated:YES completion:^{
         
     }];

   }
-(void)FriendTouch:(UITapGestureRecognizer *)gesture
{
    TTTAddFriend *addFnd=[[TTTAddFriend alloc]init];
    [self presentViewController:addFnd  animated:YES completion:^{
        
    }];
 
}

-(void)Teaboxtouch:(UITapGestureRecognizer *)recognizer
{
    TTTTeabox *teabox=[[TTTTeabox alloc] init];
    [self presentViewController:teabox animated:YES completion:^{
        
    }];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)CencelButtonclick:(id)sender
{
    
   
    [self PerformGoBack];
  
    
}

- (IBAction)CreteMatch:(id)sender
{
    
   
  if(![[_matchNameTxt text] length]>0)
    {
        [SVProgressHUD showErrorWithStatus:@"Enter Match Name"];
    }
   else if([[_matchNameTxt text] length]>=31)
    {
        [SVProgressHUD showErrorWithStatus:@"Match Name Should be with in 31 charector"];
    }
    
    else
    {
        NSUserDefaults *session=[[NSUserDefaults alloc] init];
        NSMutableDictionary *SessionParam=[[NSMutableDictionary alloc] initWithDictionary:[session objectForKey:SESSION_MATCHCREATEPARAMETES]];
        
        
        if(![(NSString *)[session objectForKey:COURSE_ID] length]>0)
        {
            [SVProgressHUD showErrorWithStatus:@"Select a Location"];
        }
        else if(![(NSString *)[SessionParam objectForKey:PARAM_TEEBOX_ID] length]>0)
        {
            [SVProgressHUD showErrorWithStatus:@"Select a Tee box"];
        }
        else if(![(NSString *)[SessionParam objectForKey:PARAM_START_TIME] length]>0)
        {
            [SVProgressHUD showErrorWithStatus:@"Choose Start Time"];
        }
        else if(![(NSString *)[SessionParam objectForKey:PARAM_END_TIME] length]>0)
        {
            [SVProgressHUD showErrorWithStatus:@"Choose End Time"];
        }
       
        else
        {
             NSString *CleaneTextField = [[_matchNameTxt text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
             NSString *ClearTextview = [[_DescrioptonTxtview text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
             [SessionParam setValue:CleaneTextField forKey:PARAM_MATCH_NAME];
             [SessionParam setValue:ClearTextview forKey:PARAM_MATCH_DESCRIPTION];
             [session setObject:SessionParam forKey:SESSION_MATCHCREATEPARAMETES];
             [session synchronize];
             [SVProgressHUD showWithStatus:@"Please Wait..."];
            
               NSInvocationOperation *CreateMatch=[[NSInvocationOperation alloc] initWithTarget:self selector:@selector(CreateMyMatch) object:nil];
              [operationQ addOperation:CreateMatch];
            
              [[self view] endEditing:YES];
              [[self view] setUserInteractionEnabled:YES];
        }
    }



    
}

-(void)CreateMyMatch
{
    @try
    {
        NSUserDefaults *session=[[NSUserDefaults alloc] init];
        NSDictionary *SessionParam=[session objectForKey:SESSION_MATCHCREATEPARAMETES];
        
        NSString *StartDate, *EndDate;
        NSArray *StartDateArray, *EndDateArray, *StartTimeArray, *EndTimeArray;
        NSMutableArray *NewstartTime,*NewEndtime;
        NewstartTime=[[NSMutableArray alloc]init];
        NewEndtime=[[NSMutableArray alloc]init];
        
        StartDate=[SessionParam valueForKey:PARAM_START_TIME];
   
        EndDate=[SessionParam valueForKey:PARAM_END_TIME];
        NSLog(@"Start time start date:%@ %@",StartDate,EndDate);
        
        StartDateArray=[StartDate componentsSeparatedByString:@"  "];
        EndDateArray=[EndDate componentsSeparatedByString:@"  "];
        NSLog(@"The value of start date and end date:%@ %@",StartDateArray,EndDateArray);
        NSLog(@"The value of start time array count:%d %d",[StartDateArray count],[EndDateArray count]);
        StartTimeArray=[(NSString *)[StartDateArray objectAtIndex:1] componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@": "]];
        EndTimeArray=[(NSString *)[EndDateArray objectAtIndex:1] componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@": "]];
        
        if ([[[StartDateArray objectAtIndex:1] componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@": "]] count]==2)
        {
            NSString *StartTimestr,*EndstringLatest;
           
            NewstartTime=[StartTimeArray copy];
            NewEndtime=[EndTimeArray copy];
            NSLog(@"The value of new start time and new end time:%@ %@",NewstartTime,NewEndtime);
            
                      //------ Code for Start date time calculation 24 hour formet --------//
            
            if ([[StartTimeArray objectAtIndex:0] integerValue]>12)
            {
                NSInteger Time=[[StartTimeArray objectAtIndex:0] integerValue]-12;
                StartTimestr=[NSString stringWithFormat:@"%d:%@ PM",Time,[StartTimeArray objectAtIndex:1]];
                StartTimeArray=[StartTimestr componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@": "]];
           
              
            }
            else if ([[StartTimeArray objectAtIndex:0] integerValue]==12&&[[StartTimeArray objectAtIndex:1] integerValue]>0)
            {
                StartTimestr=[NSString stringWithFormat:@"%@:%@ PM",[StartTimeArray objectAtIndex:0],[StartTimeArray objectAtIndex:1]];
                StartTimeArray=[StartTimestr componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@": "]];
            }
            else
            {
                StartTimestr=[NSString stringWithFormat:@"%@:%@ AM",[StartTimeArray objectAtIndex:0],[StartTimeArray objectAtIndex:1]];
                StartTimeArray=[StartTimestr componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@": "]];
            }
            
           
                    //------ Code for End date time calculation 24 hour formet --------//
            
            if ([[EndTimeArray objectAtIndex:0] integerValue]>12)
            {
                NSInteger Time=[[EndTimeArray objectAtIndex:0] integerValue]-12;
                EndstringLatest=[NSString stringWithFormat:@"%d:%@ PM",Time,[EndTimeArray objectAtIndex:1]];
                EndTimeArray=[EndstringLatest componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@": "]];

               
            }
            else if ([[EndTimeArray objectAtIndex:0] integerValue]==12&&[[EndTimeArray objectAtIndex:1] integerValue]>0)
            {
                EndstringLatest=[NSString stringWithFormat:@"%@:%@ PM",[EndTimeArray objectAtIndex:0],[EndTimeArray objectAtIndex:1]];
                EndTimeArray=[EndstringLatest componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@": "]];
            }
            else
            {
                EndstringLatest=[NSString stringWithFormat:@"%@:%@ AM",[EndTimeArray objectAtIndex:0],[EndTimeArray objectAtIndex:1]];
                EndTimeArray=[EndstringLatest componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@": "]];
            }
           
            NSLog(@"The value of startb time and end time-----:%@ %@",StartTimeArray,EndTimeArray);
            
        }
        
       // NSString *ActionMode=(IsComingForEdit)?@"editmatch":@"creatematch";
        NSString *ActionMode=@"creatematch";
        
        NSString *URL=[NSString stringWithFormat:@"%@user.php?mode=%@&title=%@&startdate=%@&starttime-hour=%@&starttime-min=%@&starttime-ampm=%@&enddate=%@&endtime-hour=%@&endtime-min=%@&endtime-ampm=%@&summary=%@&action=save&courseid=%@&teebox=%@&php_timezone=%@&userid=%@", API, ActionMode, [Method Encoder:[SessionParam valueForKey:PARAM_MATCH_NAME]],  [Method Encoder:(NSString *)[StartDateArray objectAtIndex:0]], [Method Encoder:(NSString *)[StartTimeArray objectAtIndex:0]], [Method Encoder:(NSString *)[StartTimeArray objectAtIndex:1]], [Method Encoder:(NSString *)[StartTimeArray objectAtIndex:2]], [Method Encoder:(NSString *)[EndDateArray objectAtIndex:0]], [Method Encoder:(NSString *)[EndTimeArray objectAtIndex:0]], [Method Encoder:(NSString *)[EndTimeArray objectAtIndex:1]], [Method Encoder:(NSString *)[EndTimeArray objectAtIndex:2]], [Method Encoder:[SessionParam valueForKey:PARAM_MATCH_DESCRIPTION]], [Method Encoder:[session valueForKey:COURSE_ID]], [Method Encoder:[SessionParam valueForKey:PARAM_TEEBOX_ID]], [self LocalTimeZoneName], [self LoggedId]];
        
        NSData *getData=[NSData dataWithContentsOfURL:[NSURL URLWithString:URL]];
        
        if([getData length]>2)
        {
            NSDictionary *Output=[NSJSONSerialization JSONObjectWithData:getData options:kNilOptions error:nil];
//            UIAlertView *alert213=[[UIAlertView alloc]initWithTitle:@"value of ids" message:[Output objectForKey:@"eventid"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//            [alert213 show];
            
            
           /* if(IsComingForEdit)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [SVProgressHUD showSuccessWithStatus:@"Match Updated Successfully"];
                   if(IsComingFromActivityScreen)
                        [self dismissViewControllerAnimated:YES completion:^{
                            
                            }];
                       else
                        {
                        TTTMatchListing *MatchListingViewNib=[[TTTMatchListing alloc] init];
                        [[self navigationController] pushViewController:MatchListingViewNib animated:YES];
                        }
                    
                });*/
            //}
          if([(NSString *)[Output objectForKey:@"eventid"] length]>0&[SelectedFriends count]>0)
            {
                

                dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                    
                    NSURL *URL=[NSURL URLWithString:[NSString stringWithFormat:@"%@user.php?mode=SubmitInvitation&callback=events,inviteUsers&eventid=%@&friendid=%@&userid=%@", API, [Output objectForKey:@"eventid"], [FriendIds substringFromIndex:1], [self LoggedId]]];
                    NSLog(@"%@", URL);
                    
                    [NSData dataWithContentsOfURL:URL];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                         [SVProgressHUD showSuccessWithStatus:@"Match has been created successfully"];
                         [[self view] setUserInteractionEnabled:YES];
                         NSMutableDictionary *SessionParam=[[NSMutableDictionary alloc] init];
                         [SessionParam setValue:@"abc" forKey:@"23"];
                         NSUserDefaults *session=[[NSUserDefaults alloc] init];
                        
                        [session setObject:SessionParam forKey:SESSION_MATCHCREATEPARAMETES];
                        [session synchronize];
                        TTTMatchDetails *MatchListingViewNib=[[TTTMatchDetails alloc]init];
                         MatchListingViewNib.matchID=[Output objectForKey:@"eventid"];
                         NSLog(@"Match creatred");
                         MatchListingViewNib.Iscommingfromcreatematch=TRUE;
                        [self PushViewController:MatchListingViewNib TransitationFrom:kCATransitionFromTop];
                        
                        
                    });
                });
            }
            
          else if ([[Output objectForKey:@"eventid"] length]>0&[SelectedFriends count]==0)
          {
              
               dispatch_async(dispatch_get_main_queue(), ^{
                
                   [SVProgressHUD showSuccessWithStatus:@"Match has been created successfully"];
                   TTTMatchDetails *MatchListingViewNib=[[TTTMatchDetails alloc]init];
                   MatchListingViewNib.Iscommingfromcreatematch=TRUE;
                   MatchListingViewNib.matchID=[Output objectForKey:@"eventid"];
                   [self PushViewController:MatchListingViewNib TransitationFrom:kCATransitionFromTop];
            });
          }
            else
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [SVProgressHUD showErrorWithStatus:[Output objectForKey:@"message"]];
                });
            }
            
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
                [SVProgressHUD showErrorWithStatus:@"Unexpected error occured."];
            });
        }
        
    }
    @catch (NSException *juju)
    {
        NSLog(@"Reporting juju from CreateMyMatch : %@", juju);
    }
}

-(void)InviteMyFriends: (NSString *)eventId
{
    @try
    {
        NSURL *URL=[NSURL URLWithString:[NSString stringWithFormat:@"%@user.php?mode=SubmitInvitation&callback=events,inviteUsers&eventid=%@&friendid=%@&userid=%@", API, eventId, [FriendIds substringFromIndex:1], [self LoggedId]]];
        NSLog(@"%@", URL);
        [NSData dataWithContentsOfURL:URL];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD showSuccessWithStatus:@"Match has been created successfully"];
            [[self view] setUserInteractionEnabled:YES];
            
                               NSMutableDictionary *SessionParam=[[NSMutableDictionary alloc] init];
                              [SessionParam setValue:@"abc" forKey:@"23"];
                               NSUserDefaults *session=[[NSUserDefaults alloc] init];
                               [session setObject:SessionParam forKey:SESSION_MATCHCREATEPARAMETES];
                               [session synchronize];
            
            
//                TTTMatchListing *MatchListingViewNib=[[TTTMatchListing alloc] init];
//               [self PushViewController:MatchListingViewNib TransitationFrom:kCATransitionFromLeft];
           // }
        });
    }
    @catch (NSException *juju)
    {
        NSLog(@"Reporting juju from InviteMyFriends : %@", juju);
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [SVProgressHUD dismiss];
    if (alertView.tag == 100) {
        if (buttonIndex == 0) {
            NSLog(@"i am here");
            TTTMatchListing *MatchListingViewNib=[[TTTMatchListing alloc] init];
            [self.navigationController pushViewController:MatchListingViewNib animated:YES];
            
        }
    }
}

//the value of current location
-(void)getLocationByLatLong
{
    @try
    {
      
        CLLocation *Location=[self.locationManager location];
        NSLog(@"location manager.location:%f",[Location coordinate].latitude);
        if([Location coordinate].latitude!=0.0f && [Location coordinate].longitude!=0.0f)
        {
            NSString *URLString=[NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?latlng=%f,%f&sensor=false", [Location coordinate].latitude, [Location coordinate].longitude];
            NSLog(@"the string url for the event:%@",URLString);
            NSData *getData=[NSData dataWithContentsOfURL:[NSURL URLWithString:URLString]];
            
            NSDictionary *Output=[NSJSONSerialization JSONObjectWithData:getData options:kNilOptions error:nil];
            
            
            
            NSArray *Result=[Output objectForKey:@"results"];
            NSDictionary *Dic1=[Result objectAtIndex:0];
            NSArray *address_components=[Dic1 objectForKey:@"address_components"];
            NSMutableArray *AddressArray=[[NSMutableArray alloc] initWithCapacity:3];
            
            for(NSDictionary *Dic2 in address_components)
            {
                NSArray *TypesArray=[Dic2 objectForKey:@"types"];
                if([(NSString *)[TypesArray objectAtIndex:0] isEqualToString:@"locality"] || [(NSString *)[TypesArray objectAtIndex:0] isEqualToString:@"administrative_area_level_1"])
                {
                    [AddressArray addObject:[Dic2 objectForKey:@"long_name"]];
                }
                
            }
             NSString *NewAddress=[AddressArray componentsJoinedByString:@", "];
            
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSUserDefaults *User=[[NSUserDefaults alloc] init];
                [User setValue:NewAddress forKey:SESSION_USERLOCAION];
                NSLog(@"the new address is:%@",NewAddress);
                [User synchronize];
                
            });
        }
        else
        {
            NSInvocationOperation *Invoc=[[NSInvocationOperation alloc] initWithTarget:self selector:@selector(getLocationByLatLong) object:nil];
            [operationQ addOperation:Invoc];
        }
    }
    @catch (NSException *juju)
    {
        NSLog(@"Reporting juju from getLocationByLatLong: %@", juju);
    }
}




- (IBAction)latmeback:(id)sender
{
   
   //[self PerformGoBack];
    [self PerformGoBack];
    
}

- (IBAction)goestofriendSection:(id)sender
{
    TTTAddFriend *addFnd=[[TTTAddFriend alloc]init];
    [self presentViewController:addFnd  animated:YES completion:^{
        
    }];
 
}

@end
