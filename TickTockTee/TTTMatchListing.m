//
//  TTTMatchListing.m
//  TickTockTee
//
//  Created by macbook_ms on 26/02/14.
//  Copyright (c) 2014 com.esolz.TickTockTee. All rights reserved.
//

#import "TTTMatchListing.h"
#import "TTTCreatematch.h"
#import "TTTGlobalMethods.h"
#import "SVProgressHUD.h"
#import "TTTCellFormatchList.h"
#import <CoreGraphics/CoreGraphics.h>
#import <CoreImage/CoreImage.h>
#import "ImageProcessor.h"
#import "AFNetworking.h"
#import "AFImageRequestOperation.h"
#import "UIImage+ImageEffects.h"
#import "UIImage+BlurredFrame.h"
#import "FXBlurView.h"
#import "TTTMatchDetails.h"
#import "TTTmatchListcellNewCell.h"



@interface TTTMatchListing ()<UITableViewDataSource, UITableViewDelegate,NSURLConnectionDataDelegate,UIGestureRecognizerDelegate,UITextFieldDelegate>
{
     BOOL IsChatMenuBoxOpen, IsLeftMenuBoxOpen, newMedia,IsUpdateRequired, IsAllowUserLocation, IsMoreCommentAvailable,AddStatus,Ishoveropen;
     NSMutableArray *matchListarry;
     TTTGlobalMethods *Method;
     NSMutableArray *friendImagearry;
     NSString *LastIdUpcomming;
     NSString *lastIdOngong;
     NSString *lastIdpast;
     NSString *LastIdScarch;
     ImageProcessor *LoadImage;
     NSOperationQueue *OperationQ;
     CGRect GlobalFrame;
     CGFloat Position;
    
       BOOL islastlocation;
       BOOL isFastLocation;
       BOOL IfSearchViewopen;
       NSString *MatchMode;
       BOOL ISMOREDATAAVLFORONGOING;
       BOOL ISMOREDATAAVALABLEUPCOMMING;
       BOOL ISMOREDATAAVALABLEPAST;
       BOOL Isongoingclick;
       BOOL isupcommingclick;
       BOOL ispastmatchclick;
       CGRect mainframe;
       NSString *ViewID;
    
}
@property (weak, nonatomic) IBOutlet UIButton *BackButton;
@property (weak, nonatomic) IBOutlet UIButton *Menubutton;

@property (strong, nonatomic) IBOutlet UIView *SliderTapView;
@property (strong, nonatomic) IBOutlet UIImageView *ButtomBarimage;


@property (strong, nonatomic) IBOutlet UIView *SearchView;
@property (strong, nonatomic) IBOutlet UIImageView *ScarchIconpng;
@property (strong, nonatomic) IBOutlet UITextField *Searchtextfield;
 @property(strong,nonatomic)NSString *isFromHere;


@property (strong, nonatomic) IBOutlet UILabel *NoMatchFoundLbl;


@property (strong, nonatomic) IBOutlet UIView *popupview;

@property (strong, nonatomic) IBOutlet UILabel *upcommingMatchLbl;
@property (strong, nonatomic) IBOutlet UIView *MamuView;
@property (strong, nonatomic) IBOutlet UITableView *matchListtable;
@property (strong, nonatomic) IBOutlet UIView *FooTerview;
@property (strong, nonatomic) IBOutlet UIView *ChatboxView;
@property (strong, nonatomic) IBOutlet UIView *ScreenView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *Spinner;

@end

@implementation TTTMatchListing
@synthesize upcommingMatchLbl,MamuView,matchListtable,FooTerview,ChatboxView,ParamUserID;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        
        // Custom initialization
        self=(IsIphone5)?[super initWithNibName:@"TTTMatchListing" bundle:nil]:[super initWithNibName:@"TTTMatchListing_iPhone4" bundle:nil];
    }
    return self;
}



- (void)viewDidLoad
{
   
    [super viewDidLoad];
    IsChatMenuBoxOpen=FALSE;
        IsLeftMenuBoxOpen=FALSE;
    ISMOREDATAAVALABLEUPCOMMING=TRUE;
    ISMOREDATAAVLFORONGOING=TRUE;
    ISMOREDATAAVALABLEPAST=TRUE;
    isupcommingclick=YES;
    Isongoingclick=NO;
    ispastmatchclick=NO;
    ViewID=(ParamUserID.length>0)?ParamUserID:[self LoggedId];
    mainframe=[matchListtable frame];
    MatchMode=@"upcomingevent";
    
    IfSearchViewopen=FALSE;
    self.NoMatchFoundLbl.hidden=YES;
    [self.upcommingMatchLbl setFont:[UIFont fontWithName:@"MyriadPro-Regular" size:17.0f]];
    GlobalFrame=[_ScreenView frame];
    islastlocation=TRUE;
    isFastLocation=TRUE;
    [ChatboxView setHidden:YES];
    LoadImage=[[ImageProcessor alloc]init];
    OperationQ=[[NSOperationQueue alloc]init];
    LastIdUpcomming=@"0";
    lastIdpast=@"0";
    LastIdScarch=@"0";
    Method=[[TTTGlobalMethods alloc]init];
    
    
    matchListtable.delegate=self;
    matchListtable.dataSource=self;
    
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    self.navigationController.navigationBar.hidden=YES;
    [self.matchListtable setBackgroundColor:[UIColor clearColor]];
        
    Ishoveropen=FALSE;
    [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
    
     [self AddLeftMenuTo:MamuView];
    //[FooTerview setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bottom-bar2"]]];
    if (ParamUserID.length>0)
    {
        self.BackButton.hidden=NO;
        self.Menubutton.hidden=YES;
    }
    else
    {
        self.BackButton.hidden=YES;
        self.Menubutton.hidden=NO;

    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panDetected:)];
    panRecognizer.delegate=self;
    [self.ScreenView addGestureRecognizer:panRecognizer];
    }
    self.tick2.hidden=YES;
    self.tick3.hidden=YES;
    //[self AddNavigationBarTo:FooTerview];
    [self AddNavigationBarTo:FooTerview withSelected:@""];
    [SVProgressHUD showWithStatus:@"please wait.."];
        [self DuMyJob];
    

    

    
  
    
    // Do any additional setup after loading the view from its nib.
    
    
}


-(void)DuMyJob
{
    if (IsLeftMenuBoxOpen==FALSE)
    {
         [self.view setUserInteractionEnabled:NO];
         matchListarry=[[NSMutableArray alloc]init];
         friendImagearry=[[NSMutableArray alloc]init];
          NSInvocationOperation *invocation=[[NSInvocationOperation alloc] initWithTarget:self selector:@selector(getUpcomingMatches:) object:LastIdUpcomming];
         [OperationQ addOperation:invocation];
    }
    
    
   
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)PerformmanuSlider:(id)sender
{
    self.MamuView.hidden=NO;
    self.ChatboxView.hidden=YES;
    IsLeftMenuBoxOpen=[self PerformMenuSlider:_ScreenView withMenuArea:MamuView IsOpen:IsLeftMenuBoxOpen];
    isFastLocation=IsLeftMenuBoxOpen;
    [_Searchtextfield resignFirstResponder];
}


- (IBAction)AddNewmatch:(id)sender
 {
     
    self.isFromHere=@"NO";
     NSUserDefaults *userdefalds=[NSUserDefaults standardUserDefaults];
     [userdefalds setValue:nil forKey:SESSION_MATCHCREATEPARAMETES];
     [userdefalds setValue:nil forKey:COURSE_ID];
     [userdefalds setValue:nil forKey:COURSE_NAME];
     [userdefalds synchronize];
     
     TTTCreatematch *CreateMatcheViewNib=[[TTTCreatematch alloc] init];
     [self PushViewController:CreateMatcheViewNib TransitationFrom:kCATransitionFromTop];

    
 }
//Ui gesture recognizer state

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        CGPoint translation = [(UIPanGestureRecognizer*)gestureRecognizer translationInView:self.ScreenView];
        if (fabsf(translation.x) > fabsf(translation.y))
        {
            return YES;
        }
        
        return NO;
    }
    
    return YES;
}




- (IBAction)Searchmatch:(id)sender
{
    
    [_Searchtextfield setTextColor:[UIColor whiteColor]];
    _Searchtextfield.font=[UIFont fontWithName:@"MyriadPro-Regular" size:16.0f];
    [_Searchtextfield setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [_SearchView setFrame:CGRectMake(0, 60, 320, 0)];
    [_ScreenView addSubview:_SearchView];
     CGRect Frame=[_SearchView frame];
    
    
    if (IfSearchViewopen==FALSE)
    {
        Frame.size.height=40;
        _Searchtextfield.hidden=YES;
        _ScarchIconpng.hidden=YES;
       // NSLog(@"the value of scarchlist");
        [UIView animateWithDuration:.4 animations:^{
            _SearchView.frame=Frame;
            if (IsIphone5)
            {
                matchListtable.frame = CGRectMake(0, 100, 320, 468);
            }
            else
            {
                matchListtable.frame = CGRectMake(0, 100, 320, 380);
            }
           
            
        }
        completion:^(BOOL finish)
         {
             IfSearchViewopen=TRUE;
             _Searchtextfield.hidden=FALSE;
             _ScarchIconpng.hidden=NO;
         }];
    }
    
    else
    {
        Frame.size.height=0;
        
        [UIView animateWithDuration:.3 animations:^{
             _SearchView.frame=Frame;
            _Searchtextfield.hidden=TRUE;
            _ScarchIconpng.hidden=YES;
            if (IsIphone5)
            {
                matchListtable.frame = CGRectMake(0, 60, 320, 508);
            }
            else
            {
                matchListtable.frame = CGRectMake(0, 60, 320, 420);
            }
           
            
             }
            completion:^(BOOL finish)
             {
             IfSearchViewopen=FALSE;
                [_SearchView removeFromSuperview];
              }];
    }
    
    
   
    
    
    
}

-(void)Searchviewopen
{
   
    [_Searchtextfield setTextColor:[UIColor whiteColor]];
    _Searchtextfield.font=[UIFont fontWithName:@"MyriadPro-Regular" size:16.0f];
    [_Searchtextfield setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [_SearchView setFrame:CGRectMake(0, 60, 320, 0)];
    [_ScreenView addSubview:_SearchView];
    CGRect Frame=[_SearchView frame];
    
    if (IfSearchViewopen==FALSE)
    {
        Frame.size.height=40;
        _Searchtextfield.hidden=YES;
        _ScarchIconpng.hidden=YES;
        // NSLog(@"the value of scarchlist");
        [UIView animateWithDuration:.4 animations:^{
            _SearchView.frame=Frame;
            if (IsIphone5)
            {
                matchListtable.frame = CGRectMake(0, 100, 320, 468);
            }
            else
            {
                matchListtable.frame = CGRectMake(0, 100, 320, 380);
            }
            
            
        }
                         completion:^(BOOL finish)
         {
             IfSearchViewopen=TRUE;
             _Searchtextfield.hidden=FALSE;
             _ScarchIconpng.hidden=NO;
         }];
    }
    
    else
    {
        Frame.size.height=0;
        
        [UIView animateWithDuration:.3 animations:^{
            _SearchView.frame=Frame;
            _Searchtextfield.hidden=TRUE;
            _ScarchIconpng.hidden=YES;
            if (IsIphone5)
            {
                matchListtable.frame = CGRectMake(0, 60, 320, 508);
            }
            else
            {
                matchListtable.frame = CGRectMake(0, 60, 320, 420);
            }
            
            
        }
                         completion:^(BOOL finish)
         {
             IfSearchViewopen=FALSE;
             [_SearchView removeFromSuperview];
         }];
    }
    

}


- (IBAction)UpcommingMatch:(id)sender
{
    IfSearchViewopen=TRUE;
    [self Searchviewopen];
    
    if (Ishoveropen==FALSE)
    {
       
        self.popupview.frame=CGRectMake(0, 60, 320, 0);
        self.popupview.alpha=0.0000f;
        [_ScreenView addSubview:self.popupview];
        
        [UIView animateWithDuration:0.2f animations:^{
            
            self.popupview.frame=CGRectMake(0, 60, 320, 174);
            self.popupview.alpha=1.0000f;
        
        }
        completion:^(BOOL finished)
        {
                Ishoveropen=TRUE;
        }];
        
    }
   else
    {
        [UIView animateWithDuration:0.2f animations:^{
            self.popupview.frame=CGRectMake(0, 60, 320, 0);
            self.popupview.alpha=0.0000f;
        }
    completion:^(BOOL finished)
        {
            
            Ishoveropen=FALSE;
            [self.popupview removeFromSuperview];
        }];
    }
    
    
}

- (void)panDetected:(UIPanGestureRecognizer *)panRecognizer
{
    
    CGPoint  stopLocation;
    
    if(IsChatMenuBoxOpen==NO){
        self.MamuView.hidden=NO;
        self.ChatboxView.hidden=YES;
        if (panRecognizer.state == UIGestureRecognizerStateBegan)
        {
            
            // CGPoint startLocation = [panRecognizer translationInView:_ScreenView];
            // NSLog(@"Strart locaton:%f",startLocation.x);
            
        }
        
        else if (panRecognizer.state == UIGestureRecognizerStateChanged)
        {
            
            stopLocation = [panRecognizer translationInView:_ScreenView];
            
            CGRect frame=[_ScreenView frame];
            if (IsLeftMenuBoxOpen==NO&&stopLocation.x>0)
            {
                NSLog(@"location is %f",stopLocation.x);
                if (stopLocation.x>60)
                {
                    islastlocation=FALSE;
                    
                    
                }
                else
                {
                    
                    frame.origin.x=stopLocation.x;
                    
                    
                }
                
                
                
                
                if (islastlocation)
                {
                    NSLog(@"open satisfied");
                    [UIView animateWithDuration:0.3f animations:^{
                        _ScreenView.frame=frame;
                        
                    }];
                    
                }
                else
                {
                    NSLog(@"close satisfied");
                    IsLeftMenuBoxOpen=YES;
                    isFastLocation=TRUE;
                    CGRect lastFrame=[_ScreenView frame];
                    lastFrame.origin.x=260;
                    [UIView animateWithDuration:.5 animations:^{
                        _ScreenView.frame=lastFrame;
                        
                    }];
                }
            }
            
            
            else
            {
                //NSLog(@"TRY Left Menu OPEN");
                
                if (stopLocation.x*-1>60.0f)
                {
                    isFastLocation=FALSE;
                    // NSLog(@"is fast location");
                }
                else
                {
                    if (stopLocation.x<0)
                    {
                        frame.origin.x=260+stopLocation.x;
                    }
                    
                }
                
                
                
                
                if (isFastLocation)
                {
                    
                    NSLog(@"open satisfied");
                    [UIView animateWithDuration:.2 animations:^{
                        _ScreenView.frame=frame;
                        
                    }];
                    
                }
                else
                {
                    NSLog(@"close satisfied");
                    IsLeftMenuBoxOpen=NO;
                    islastlocation=TRUE;
                    CGRect lastFrame2=[_ScreenView frame];
                    lastFrame2.origin.x=0;
                    [UIView animateWithDuration:.5 animations:^{
                        _ScreenView.frame=lastFrame2;
                        
                    }];
                }
            }
            
            
            
            
            
        }
        ///HERE LEFT MENU OPEN CLOSE HAPPENED
        else if (panRecognizer.state==UIGestureRecognizerStateEnded)
        {
            if (stopLocation.x<150&islastlocation==TRUE&IsLeftMenuBoxOpen==NO)
            {
                NSLog(@"Left Menu closed %f",stopLocation.x);
                CGRect framelast=[_ScreenView frame];
                framelast.origin.x=0;
                
                
                [UIView animateWithDuration:.6 animations:^{
                    _ScreenView.frame=framelast;
                    
                }];
            }
            
            if (stopLocation.x*-1<100.0f&isFastLocation==TRUE&IsLeftMenuBoxOpen==YES)
            {
                NSLog(@"Left Menu opened%f",stopLocation.x);
                
                CGRect framelast=[_ScreenView frame];
                framelast.origin.x=260;
                
                
                [UIView animateWithDuration:.6 animations:^{
                    _ScreenView.frame=framelast;
                    
                }];
                
            }
            
            
        }
        
    }
    
}


-(void)PerformChatSliderOperation
{
    self.MamuView.hidden=YES;
    self.ChatboxView.hidden=NO;
    IsChatMenuBoxOpen=[self PerformChatSlider:_ScreenView withChatArea:self.ChatboxView IsOpen:IsChatMenuBoxOpen];
    NSLog(@"PerformChatSliderOperation %@",IsChatMenuBoxOpen?@"YES":@"NO");
    
}

//Parse data and show in tableview

-(void)getOnGoingMatches:(NSString *)LastId
{
    @try
    {
        
     
        NSString  *URL=[NSString stringWithFormat:@"%@user.php?mode=ongoingevent&userid=%@&timezone=%@&loggedin_userid=%@&lastid=%@", API,ViewID,[Method Encoder:[self LocalTimeZoneName]],[self LoggedId],LastId];
        NSLog(@"%@", URL);
        
        NSData *getData=[NSData dataWithContentsOfURL:[NSURL URLWithString:URL]];
        
        NSDictionary *Output=[NSJSONSerialization JSONObjectWithData:getData options:kNilOptions error:nil];
        NSDictionary *paramdic=[Output valueForKey:@"extraparam"];
        lastIdOngong=[paramdic valueForKey:@"lastid"];
        NSString *moredata=[paramdic valueForKey:@"moredata"];
        if ([moredata integerValue]==0)
        {
            ISMOREDATAAVLFORONGOING=FALSE;
        }
        else
        {
          
        }
        NSArray *EventArry=[Output objectForKey:@"matches"];
        
        
        if ([EventArry count]>0)
        {
            for(NSDictionary *var in EventArry)
            {
                
                
                NSMutableDictionary *MutableDic=[[NSMutableDictionary alloc]init];
                [MutableDic setObject:[var valueForKey:@"MatchId"] forKey:@"MatchId"];
                [MutableDic setObject:[var valueForKey:@"MatchTitle"] forKey:@"MatchTitle"];
                [MutableDic setObject:[var valueForKey:@"MatchCreator"] forKey:@"MatchCreator"];
                [MutableDic setObject:[var valueForKey:@"MatchCourse"] forKey:@"MatchCourse"];
                [MutableDic setObject:[var valueForKey:@"MatchTeebox Color"] forKey:@"MatchTeebox Color"];
                [MutableDic setObject:[var valueForKey:@"MatchInvitedGuest"] forKey:@"MatchInvitedGuest"];
                [MutableDic setObject:[var valueForKey:@"MatchConfirmedCount"] forKey:@"MatchConfirmedCount"];
                [MutableDic setObject:[var valueForKey:@"MatchCoverImage"] forKey:@"MatchCoverImage"];
                [MutableDic setObject:[var valueForKey:@"MatchImage"] forKey:@"MatchImage"];
                [MutableDic setObject:[var valueForKey:@"MatchStartDate"] forKey:@"MatchStartDate"];
                [MutableDic setObject:[var valueForKey:@"MatchStartTime"] forKey:@"MatchStartTime"];
                [MutableDic setValue:[var valueForKey:@"Mymatch"] forKey:@"Mymatch"];
                
                
                NSArray *PlayerDetais=[var objectForKey:@"MatchPlayers"];
                
                NSMutableArray *MatchPlayerArry=[[NSMutableArray alloc]init];
                for (NSDictionary *dic in PlayerDetais)
                {
                    
                    
                    NSMutableDictionary *myimageDoictionary=[[NSMutableDictionary alloc]init];
                    [myimageDoictionary setObject:[dic valueForKey:@"id"] forKey:@"id"];
                    [myimageDoictionary setObject:[dic valueForKey:@"payerImage"] forKey:@"payerImage"];
                    [myimageDoictionary setObject:[dic valueForKey:@"PlayerLink"] forKey:@"PlayerLink"];
                    
                    [MatchPlayerArry addObject:myimageDoictionary];
                }
                
                [MutableDic setObject:MatchPlayerArry forKey:@"imagearray"];
                
                [matchListarry addObject:MutableDic];
                
            }
            [self performSelectorOnMainThread:@selector(ReloadTable) withObject:nil waitUntilDone:YES];
            
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
                [self.view setUserInteractionEnabled:YES];
                if ([matchListarry count]==0)
                {
                   [SVProgressHUD showErrorWithStatus:@"No Ongoing Matches Found"];
                }
                [matchListtable reloadData];
            });
        }
        
        
        
        
    }
    
    @catch (NSException *juju)
    {
        NSLog(@"Reporting juju from getUpcomingMatches : %@", juju);
    }
}

-(void)PerformLoadMore
{
   
    
}


-(void)getUpcomingMatches:(NSString *)LastId
{
    @try
    {
        
        
        NSString  *URL=[NSString stringWithFormat:@"%@user.php?mode=upcomingevent&userid=%@&timezone=%@&loggedin_userid=%@&lastid=%@", API,ViewID,[Method Encoder:[self LocalTimeZoneName]],[self LoggedId],LastId];
        NSLog(@"%@", URL);
        
        NSData *getData=[NSData dataWithContentsOfURL:[NSURL URLWithString:URL]];
        
        NSDictionary *Output=[NSJSONSerialization JSONObjectWithData:getData options:kNilOptions error:nil];
        NSDictionary *paramdic=[Output valueForKey:@"extraparam"];
        LastIdUpcomming=[paramdic valueForKey:@"lastid"];
        NSString *moredata=[paramdic valueForKey:@"moredata"];
        if ([moredata integerValue]==0)
        {
            ISMOREDATAAVALABLEUPCOMMING=FALSE;
        }
        
        NSArray *EventArry=[Output objectForKey:@"matches"];
      
        
        if ([EventArry count]>0)
        {
            for(NSDictionary *var in EventArry)
            {
                
              
                NSMutableDictionary *MutableDic=[[NSMutableDictionary alloc]init];
                [MutableDic setObject:[var valueForKey:@"MatchId"] forKey:@"MatchId"];
                [MutableDic setObject:[var valueForKey:@"MatchTitle"] forKey:@"MatchTitle"];
                [MutableDic setObject:[var valueForKey:@"MatchCreator"] forKey:@"MatchCreator"];
                [MutableDic setObject:[var valueForKey:@"MatchCourse"] forKey:@"MatchCourse"];
                [MutableDic setObject:[var valueForKey:@"MatchTeebox Color"] forKey:@"MatchTeebox Color"];
                [MutableDic setObject:[var valueForKey:@"MatchInvitedGuest"] forKey:@"MatchInvitedGuest"];
                [MutableDic setObject:[var valueForKey:@"MatchConfirmedCount"] forKey:@"MatchConfirmedCount"];
                [MutableDic setObject:[var valueForKey:@"MatchCoverImage"] forKey:@"MatchCoverImage"];
                [MutableDic setObject:[var valueForKey:@"MatchImage"] forKey:@"MatchImage"];
                [MutableDic setObject:[var valueForKey:@"MatchStartDate"] forKey:@"MatchStartDate"];
                [MutableDic setObject:[var valueForKey:@"MatchStartTime"] forKey:@"MatchStartTime"];
                [MutableDic setValue:[var valueForKey:@"Mymatch"] forKey:@"Mymatch"];
                
               
                NSArray *PlayerDetais=[var objectForKey:@"MatchPlayers"];
               
                NSMutableArray *MatchPlayerArry=[[NSMutableArray alloc]init];
                for (NSDictionary *dic in PlayerDetais)
                {
                   
                    
                    NSMutableDictionary *myimageDoictionary=[[NSMutableDictionary alloc]init];
                    [myimageDoictionary setObject:[dic valueForKey:@"id"] forKey:@"id"];
                    [myimageDoictionary setObject:[dic valueForKey:@"payerImage"] forKey:@"payerImage"];
                    [myimageDoictionary setObject:[dic valueForKey:@"PlayerLink"] forKey:@"PlayerLink"];
                    
                    [MatchPlayerArry addObject:myimageDoictionary];
                }
               
                  [MutableDic setObject:MatchPlayerArry forKey:@"imagearray"];
                
                  [matchListarry addObject:MutableDic];

            }
            [self performSelectorOnMainThread:@selector(ReloadTable) withObject:nil waitUntilDone:YES];
            
        }
        else
         {
             dispatch_async(dispatch_get_main_queue(), ^{
                 [SVProgressHUD dismiss];
                 [self.view setUserInteractionEnabled:YES];
                 if ([matchListarry count]==0)
                 {
                     [SVProgressHUD showErrorWithStatus:@"No Upcoming Matches Found"];
                 }
                  [matchListtable reloadData];
             });
         }
        
        
        
        
}

    @catch (NSException *juju)
    {
        NSLog(@"Reporting juju from getUpcomingMatches : %@", juju);
    }
}
-(void)ReloadTable
{
    [SVProgressHUD dismiss];
    [self.view setUserInteractionEnabled:YES];
    [[self matchListtable] setUserInteractionEnabled:YES];
    [_Spinner stopAnimating];
    [matchListtable setHidden:NO];
    [matchListtable reloadData];
}


-(void)getPastMatches:(NSString *)LastId
{
    @try
    {
       
        
        
        NSString *URL=[NSString stringWithFormat:@"%@user.php?mode=pastevents&currenttime=%@&timezone=%@&userid=%@&status=my&lastid=%@&loggedin_userid=%@", API, [Method Encoder:[self LocalDateTime]], [Method Encoder:[self LocalTimeZoneName]], ViewID, LastId,[self LoggedId]];
        NSLog(@"%@", URL);
        
        NSData *getData=[NSData dataWithContentsOfURL:[NSURL URLWithString:URL]];
        
        NSDictionary *Output=[NSJSONSerialization JSONObjectWithData:getData options:kNilOptions error:nil];
        NSDictionary *paramdic=[Output valueForKey:@"extraparam"];
        NSArray *EventArry=[Output objectForKey:@"matches"];
        lastIdpast=[paramdic valueForKey:@"lastid"];
        NSString *moredata=[paramdic valueForKey:@"moredata"];
        NSLog(@"The value of more data:%@",moredata);
        if ([moredata integerValue]==0)
        {
            ISMOREDATAAVALABLEPAST=FALSE;
        }
       
       
        
        
        if ([EventArry count]>0)
        {
            for(NSDictionary *var in EventArry)
            {
                
                
                NSMutableDictionary *MutableDic=[[NSMutableDictionary alloc]init];
                [MutableDic setObject:[var valueForKey:@"MatchId"] forKey:@"MatchId"];
                [MutableDic setObject:[var valueForKey:@"MatchTitle"] forKey:@"MatchTitle"];
                [MutableDic setObject:[var valueForKey:@"MatchCreator"] forKey:@"MatchCreator"];
                [MutableDic setObject:[var valueForKey:@"MatchCourse"] forKey:@"MatchCourse"];
                [MutableDic setObject:[var valueForKey:@"MatchTeebox Color"] forKey:@"MatchTeebox Color"];
                [MutableDic setObject:[var valueForKey:@"MatchInvitedGuest"] forKey:@"MatchInvitedGuest"];
                [MutableDic setObject:[var valueForKey:@"MatchConfirmedCount"] forKey:@"MatchConfirmedCount"];
                [MutableDic setObject:[var valueForKey:@"MatchImage"] forKey:@"MatchImage"];
                [MutableDic setObject:[var valueForKey:@"MatchCoverImage"] forKey:@"MatchCoverImage"];
                [MutableDic setObject:[var valueForKey:@"MatchStartDate"] forKey:@"MatchStartDate"];
                [MutableDic setObject:[var valueForKey:@"MatchStartTime"] forKey:@"MatchStartTime"];
                [MutableDic setValue:[var valueForKey:@"Mymatch"] forKey:@"Mymatch"];
                
                
                NSArray *PlayerDetais=[var objectForKey:@"MatchPlayers"];
                
                NSMutableArray *MatchPlayerArry=[[NSMutableArray alloc]init];
                for (NSDictionary *dic in PlayerDetais)
                {
                    
                    
                    NSMutableDictionary *myimageDoictionary=[[NSMutableDictionary alloc]init];
                    [myimageDoictionary setObject:[dic valueForKey:@"id"] forKey:@"id"];
                    [myimageDoictionary setObject:[dic valueForKey:@"payerImage"] forKey:@"payerImage"];
                    [myimageDoictionary setObject:[dic valueForKey:@"PlayerLink"] forKey:@"PlayerLink"];
                    
                    [MatchPlayerArry addObject:myimageDoictionary];
                }
                
                [MutableDic setObject:MatchPlayerArry forKey:@"imagearray"];
                
                [matchListarry addObject:MutableDic];
                
            }
            [self performSelectorOnMainThread:@selector(ReloadTable) withObject:nil waitUntilDone:YES];
            
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
                [self.view setUserInteractionEnabled:YES];
                if ([matchListarry count]==0)
                {
                     [SVProgressHUD showErrorWithStatus:@"No Past Matches Found"];
                }
               
            });
            
           
        }
        
        
        
        
    }
    
    @catch (NSException *juju)
    {
        NSLog(@"Reporting juju from getUpcomingMatches : %@", juju);
    }
}
//is more data availabl function

#pragma Implemant UITableView

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 218.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [matchListarry count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath

{
    
    static  NSString *CellIdentifire;
    
    if (ispastmatchclick==YES)
        
    {
        
        [CellIdentifire isEqual:@"TTTmatchListcellNewCell"];
        
    }
    

    
    TTTmatchListcellNewCell *matchListcell=(TTTmatchListcellNewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifire];
    
    NSMutableDictionary *murDic=[matchListarry objectAtIndex:indexPath.row];
    
    NSInteger numbor=[[murDic objectForKey:@"imagearray"] count];
    
    
    
    if (matchListcell==nil)
        
    {
        
        NSLog(@"TTT cell for row at indexpath:");
    
        NSArray *CellNib=[[NSBundle mainBundle] loadNibNamed:@"TTTMatchListcellNewxib" owner:self options:nil];
        
        matchListcell=(TTTmatchListcellNewCell *)[CellNib objectAtIndex:0];
        UIActivityIndicatorView *Spinner=(UIActivityIndicatorView *)[matchListcell.contentView viewWithTag:93];
        
        
        
        UIView *backView;
        
        UIImageView *ImageView;
        
        
        
        numbor>5?numbor=5:numbor ;
        
        
        
        for (int i=0; i<numbor; i++){
            
            int imageTag=1001+(i*2);
            
            ImageView=(UIImageView *)[matchListcell viewWithTag:imageTag];
            
            backView=(UIView *)[matchListcell viewWithTag:imageTag-1];
            
            if(numbor%2==0)
                
            {
                
                backView.center=CGPointMake(backView.center.x -26, backView.center.y);
                
                ImageView.center=CGPointMake(ImageView.center.x -26, ImageView.center.y);
                
            }
            
            
            
            [self SetroundborderWithborderWidth:0.0f WithColour:[UIColor clearColor] ForImageview:ImageView];
            
            [self SetroundborderWithborderWidth:2.0f WithColour:[UIColor whiteColor] ForView:backView];
            
            NSURLRequest *request_img2 = [NSURLRequest requestWithURL:[NSURL URLWithString:[[[murDic objectForKey:@"imagearray"] objectAtIndex:i] valueForKey:@"payerImage"]]];
            
            AFImageRequestOperation *operation = [AFImageRequestOperation imageRequestOperationWithRequest:request_img2
                                                  
                                                                                      imageProcessingBlock:nil
                                                  
                                                                                                   success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                                                                       
                                                                                                       if(image!=nil)
                                                                                                           
                                                                                                       {
                                                                                                           
                                                                                                           ImageView.image=image;
                                                                                                           
                                                                                                           [Spinner stopAnimating];
                                                                                                           
                                                                                                           [Spinner setHidden:YES];
                                                                                                           
                                                                                                       }
                                                                                                       
                                                                                                       
                                                                                                       
                                                                                                   }
                                                  
                                                                                                   failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                                                                                       
                                                                                                       NSLog(@"Error %@",error);
                                                                                                       
                                                                                                       
                                                                                                       
                                                                                                   }];
            
            [operation start];
            
            
        }
        
        
        
    }
        
        
        
    
        
        UIActivityIndicatorView *SpinnerForbackground=(UIActivityIndicatorView *)[matchListcell.contentView viewWithTag:93];
        
        
        
        //Clearing The back Ground
        
        
        
        matchListcell.backgroundColor=[UIColor clearColor];
        
        
        
        
        
        
        
        //Downlod back ground image in block and background thread
        
        
        
        NSString *BackgroundImageStgring=[murDic valueForKey:@"MatchCoverImage"];
        
        
        
        UIImageView *BackgrounImage=(UIImageView *)[matchListcell.contentView viewWithTag:100];
        
        NSURLRequest *request_img = [NSURLRequest requestWithURL:[NSURL URLWithString:BackgroundImageStgring]];
        
        
        
        AFImageRequestOperation *operation = [AFImageRequestOperation imageRequestOperationWithRequest:request_img
                                              
                                                                                  imageProcessingBlock:nil
                                              
                                                                                               success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                                                                   
                                                                                                   if(image!=nil)
                                                                                                       
                                                                                                   {
                                                                                                       
                                                                                                       
                                                                                                       
                                                                                                       [BackgrounImage setImage:image];
                                                                                                       
                                                                                                       
                                                                                                       
                                                                                                       [SpinnerForbackground stopAnimating];
                                                                                                       
                                                                                                       [SpinnerForbackground setHidden:YES];
                                                                                                       
                                                                                                   }
                                                                                                   
                                                                                                   
                                                                                                   
                                                                                               }
                                              
                                                                                               failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                                                                                   
                                                                                                   [[UIImage imageNamed:@"picture.png"] applyLightEffect];
                                                                                                   
                                                                                                   [BackgrounImage setImage:[UIImage imageNamed:@"picture.png"]];
                                                                                                   
                                                                                                   [SpinnerForbackground stopAnimating];
                                                                                                   
                                                                                                   [SpinnerForbackground hidesWhenStopped];
                                                                                                   
                                                                                                   NSLog(@"Error %@",error);
                                                                                                   
                                                                                               }];
        
        [operation start];
        
        
        
        
        
        
        
        
        
        
        
        
        
        //date lable creation For 21( according to design psd)
        
        
        
        NSString *dateAndTime=[murDic valueForKey:@"MatchStartDate"];
        
        NSArray *Concatarry=[dateAndTime componentsSeparatedByString:@" "];
        
        
        
        UILabel *dateLable=(UILabel *)[matchListcell.contentView viewWithTag:102];
        
        dateLable.font=[UIFont fontWithName:@"MyriadProLight" size:23.0f];
        
        dateLable.textColor=[UIColor whiteColor];
        
        dateLable.textAlignment=NSTextAlignmentCenter;
        
        dateLable.text=[Concatarry objectAtIndex:1];
        
        
        
        //Show month in short like DEC
        
        
        
        UILabel *MonthLable=(UILabel *)[matchListcell.contentView viewWithTag:103];
        
        MonthLable.font=[UIFont fontWithName:@"MyriadProLight" size:13.0f];
        
        
        
        MonthLable.textColor=[UIColor whiteColor];
        
        MonthLable.textAlignment=NSTextAlignmentCenter;
        
        MonthLable.text=[[Concatarry objectAtIndex:0] uppercaseString];
        
        
        
        //Set course name
        
        
        
        UILabel *MatchNameName=(UILabel *)[matchListcell.contentView viewWithTag:104];
        
        UIColor *color = MatchNameName.tintColor;
        
        
        
        
        
        MatchNameName.font=[UIFont fontWithName:@"MyriadPro-Semibold" size:18.0f];
        
        MatchNameName.textColor=[UIColor whiteColor];
        
        MatchNameName.textAlignment=NSTextAlignmentLeft;
        
        MatchNameName.text=[murDic valueForKey:@"MatchTitle"];
        
        MatchNameName.layer.shadowColor = [color CGColor];
        
        MatchNameName.layer.shadowRadius = 2.0f;
        
        MatchNameName.layer.shadowOpacity = 2.0f;
        
        MatchNameName.layer.shadowOffset = CGSizeZero;
        
        MatchNameName.layer.masksToBounds = YES;
        
        //course name
        
        
        
        UILabel *CourseNmae=(UILabel *)[matchListcell.contentView viewWithTag:105];
        
        CourseNmae.font=[UIFont fontWithName:@"MyriadProLight" size:16.0f];
        
        CourseNmae.layer.opacity=2.0f;
        
        CourseNmae.textColor=[UIColor whiteColor];
        
        CourseNmae.textAlignment=NSTextAlignmentLeft;
        
        
        
        
        
        NSAttributedString *attributedText =
        
        [[NSAttributedString alloc]
         
         initWithString:[self RemoveNullandreplaceWithSpace:[murDic valueForKey:@"MatchCourse"]]
         
         attributes:@
         
         {
             
         NSFontAttributeName:[UIFont fontWithName:@"MyriadProLight" size:16.0f]
             
         }];
        
        
        
        CGRect rect = [attributedText boundingRectWithSize:(CGSize){300, 24}
                       
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                       
                                                   context:nil];
        
        CGSize size = rect.size;
        
        CourseNmae.frame=CGRectMake(CourseNmae.frame.origin.x, CourseNmae.frame.origin.y, size.width, 21);
        
        CourseNmae.text=[self RemoveNullandreplaceWithSpace:[murDic valueForKey:@"MatchCourse"]];
        
        
        
        
        
        //CouseNameSideView
        
        
        
        UIView *TeeBoxlable=(UIView *)[matchListcell.contentView viewWithTag:108];
        
        CGRect TeeBoxframe=[TeeBoxlable frame];
        
        TeeBoxframe.origin.x=CourseNmae.frame.origin.x+size.width+6;
        
        
        
        [TeeBoxlable setFrame:TeeBoxframe];
        
        TeeBoxlable.layer.cornerRadius=5.0f;
        
        [TeeBoxlable.layer setMasksToBounds:YES];
        
        [TeeBoxlable setBackgroundColor:[TTTGlobalMethods colorFromHexString:[murDic valueForKey:@"MatchTeebox Color"]]];
        
        
        
        //ScrooView full functionaly design.
        
        
        
        // UIScrollView *ImageBackGroundScrool=(UIScrollView *)[matchListcell.contentView viewWithTag:109];
        
        
        
        //Numbor of participent join
        
        UILabel *Particepantlable=(UILabel *)[matchListcell.contentView viewWithTag:110];
        
        Particepantlable.font=[UIFont fontWithName:MYRIARDPROLIGHT size:13.0f];
        
        
        
        NSString *NumpracticString;
        
        if ([[murDic valueForKey:@"MatchConfirmedCount"] integerValue]==1)
            
        {
            
            
            
            NumpracticString=[NSString stringWithFormat:@"%d %@",numbor,@"Participant"];
            
        }
        
        else
            
        {
            
            NumpracticString=[NSString stringWithFormat:@"%d %@",numbor,@"Participant's"];
            
            
            
        }
        
        [Particepantlable setText:NumpracticString];
        
        
        
        
        
        //bigdate lable
        
        UILabel *bigTimelable=(UILabel *)[matchListcell.contentView viewWithTag:106];
        
        bigTimelable.textAlignment=NSTextAlignmentLeft;
        
        bigTimelable.font=[UIFont fontWithName:SEGIOUI size:28.0f];
        
        bigTimelable.textColor=[UIColor whiteColor];
        
        [bigTimelable setText:[murDic valueForKey:@"MatchStartTime"]];
        
        
        
        
        
        //join button
        
        UIButton *joinButton=(UIButton *)[matchListcell.contentView viewWithTag:107];
        
        [joinButton addTarget:self action:@selector(gotonext) forControlEvents:UIControlEventTouchUpInside];
        
        
        
        if ([[murDic valueForKey:@"Mymatch"] integerValue]==1)
            
        {
            
            joinButton.hidden=YES;
            
        }
        
        
        
    
    
    
    
    return matchListcell;
    
    
    
}

//Uitableview Delegate methods//
-(void)gotonext
{
//    TTTMatchDetails *matchList=[[TTTMatchDetails alloc]init];
//    [self PushViewController:matchList TransitationFrom:kCATransitionFade];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
 
     NSMutableDictionary *murDic=[matchListarry objectAtIndex:indexPath.row];
    TTTMatchDetails *matchdetais=[[TTTMatchDetails alloc]init];
     matchdetais.matchID=[murDic valueForKey:@"MatchId"];
    matchdetais.ParamViewerID=ParamUserID;
    self.isFromHere=@"YES";
    [self.navigationController pushViewController:matchdetais animated:YES];
}


- (IBAction)ShowUpcommingEvents:(id)sender
{
    IfSearchViewopen=TRUE;
    [self Searchviewopen];
    MatchMode=@"upcomingevent";
    self.tick2.hidden=YES;
    self.tick3.hidden=YES;
    [self.view setUserInteractionEnabled:NO];
    [SVProgressHUD showWithStatus:@"please wait.."];
    [self.upcommingMatchLbl setText:@"Upcoming"];
    matchListtable.hidden=YES;
    [UIView animateWithDuration:0.4f animations:^{
        self.popupview.frame=CGRectMake(0, 60, 320, 0);
        self.popupview.alpha=0.0000f;
    }
                     completion:^(BOOL finished)
     {
                  Ishoveropen=FALSE;
          self.tick1.hidden=NO;
         [self.popupview removeFromSuperview];
     }];
    ispastmatchclick=NO;
    Isongoingclick=NO;
    isupcommingclick=YES;
    [matchListarry removeAllObjects];
    
     NSInvocationOperation *invocation=[[NSInvocationOperation alloc] initWithTarget:self selector:@selector(getUpcomingMatches:) object:@"0"];
     [OperationQ addOperation:invocation];

}

- (IBAction)ShowOngoingEvent:(id)sender
{
    IfSearchViewopen=TRUE;
    [self Searchviewopen];
    MatchMode=@"ongoingevent";
    self.tick1.hidden=YES;
    [self.view setUserInteractionEnabled:NO];
    [SVProgressHUD showWithStatus:@"please wait.."];
    self.tick3.hidden=YES;
    matchListtable.hidden=YES;
    [self.upcommingMatchLbl setText:@"Ongoing"];
    [UIView animateWithDuration:0.4f animations:^{
        self.popupview.frame=CGRectMake(0, 60, 320, 0);
        self.popupview.alpha=0.0000f;
    }
    completion:^(BOOL finished)
     {
         self.tick2.hidden=NO;
         Ishoveropen=FALSE;
         [self.popupview removeFromSuperview];
     }];


    [self.Spinner startAnimating];
    lastIdOngong=@"0";
    [matchListarry removeAllObjects];
    ispastmatchclick=NO;
    Isongoingclick=YES;
    isupcommingclick=NO;
    NSInvocationOperation *invocation=[[NSInvocationOperation alloc] initWithTarget:self selector:@selector(getOnGoingMatches:) object:lastIdOngong];
    [OperationQ addOperation:invocation];

}


- (IBAction)PastEvent:(id)sender
{
  [self.upcommingMatchLbl setText:@"Past"];
    self.tick1.hidden=YES;
    self.tick2.hidden=YES;
    [self.view setUserInteractionEnabled:NO];
    [SVProgressHUD showWithStatus:@"please wait.."];
    MatchMode=@"pastevents";
    matchListtable.hidden=YES;
    [UIView animateWithDuration:0.4f animations:^{
        self.popupview.frame=CGRectMake(0, 60, 320, 0);
        self.popupview.alpha=0.0000f;
    }
                     completion:^(BOOL finished)
     {
        
         Ishoveropen=FALSE;
          self.tick3.hidden=NO;
         [self.popupview removeFromSuperview];
     }];
    ispastmatchclick=YES;
    Isongoingclick=NO;
    isupcommingclick=NO;
    lastIdpast=@"0";
  [matchListarry removeAllObjects];
    NSInvocationOperation *invocation=[[NSInvocationOperation alloc] initWithTarget:self selector:@selector(getPastMatches:) object:lastIdpast];
    [OperationQ addOperation:invocation];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [OperationQ cancelAllOperations];
}
//Acaccount

- (IBAction)SearchButtonclick:(id)sender
{
  
    [SVProgressHUD showWithStatus:@"searching"];
    [[self view] setUserInteractionEnabled:NO];
     NSInvocationOperation *SearchOperation=[[NSInvocationOperation alloc]initWithTarget:self selector:@selector(ScarchmatchWitlastId:) object:LastIdScarch];
    [OperationQ addOperation:SearchOperation];
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
   
    if (textField==self.Searchtextfield&&self.Searchtextfield.text.length>0)
    {
        [[self matchListtable] setUserInteractionEnabled:NO];
        if (IsLeftMenuBoxOpen==FALSE)
        {
            [SVProgressHUD showWithStatus:@"searching"];
            [[self view] setUserInteractionEnabled:NO];
            NSInvocationOperation *SearchOperation=[[NSInvocationOperation alloc]initWithTarget:self selector:@selector(ScarchmatchWitlastId:) object:LastIdScarch];
            [OperationQ addOperation:SearchOperation];
        }
        
        if ([self.manuSearchtxt.text length]<1)
        {
            CGRect frame=[self.Scarchicon frame];
            frame.origin.x=122;
            [UIView animateWithDuration:.3f animations:^{
                
                self.Scarchicon.frame=frame;
            }];
            
        }

    }
   
   
    return YES;
}
//perform Search operation

-(void)ScarchmatchWitlastId:(NSString *)LastId
{
    @try
    {
          [matchListarry removeAllObjects];
       
        NSString *URL=[NSString stringWithFormat:@"%@user.php?mode=%@&currenttime=%@&timezone=%@&userid=%@&status=my&lastid=%@&search=%@&loggedin_userid=%@", API,MatchMode,[Method Encoder:[self LocalDateTime]], [Method Encoder:[self LocalTimeZoneName]], ViewID, LastId,[Method Encoder:_Searchtextfield.text],[self LoggedId]];
        NSLog(@"%@", URL);
        
        NSData *getData=[NSData dataWithContentsOfURL:[NSURL URLWithString:URL]];
        
        NSDictionary *Output=[NSJSONSerialization JSONObjectWithData:getData options:kNilOptions error:nil];
        NSDictionary *paramdic=[Output valueForKey:@"extraparam"];
        LastIdUpcomming=[paramdic valueForKey:@"lastid"];
        NSString *moredata=[paramdic valueForKey:@"moredata"];
        if ([moredata integerValue]>0)
        {
           
        }
        else
        {
            
        }
        NSArray *EventArry=[Output objectForKey:@"matches"];
        
        
        if ([EventArry count]>0)
        {
            for(NSDictionary *var in EventArry)
            {
                
                
                NSMutableDictionary *MutableDic=[[NSMutableDictionary alloc]init];
                
                [MutableDic setObject:[var valueForKey:@"MatchId"] forKey:@"MatchId"];
                [MutableDic setObject:[var valueForKey:@"MatchTitle"] forKey:@"MatchTitle"];
                [MutableDic setObject:[var valueForKey:@"MatchCreator"] forKey:@"MatchCreator"];
                [MutableDic setObject:[var valueForKey:@"MatchCourse"] forKey:@"MatchCourse"];
                [MutableDic setObject:[var valueForKey:@"MatchTeebox Color"] forKey:@"MatchTeebox Color"];
                [MutableDic setObject:[var valueForKey:@"MatchInvitedGuest"] forKey:@"MatchInvitedGuest"];
                [MutableDic setObject:[var valueForKey:@"MatchConfirmedCount"] forKey:@"MatchConfirmedCount"];
                [MutableDic setObject:[var valueForKey:@"MatchImage"] forKey:@"MatchImage"];
                [MutableDic setObject:[var valueForKey:@"MatchCoverImage"] forKey:@"MatchCoverImage"];
                [MutableDic setObject:[var valueForKey:@"MatchStartDate"] forKey:@"MatchStartDate"];
                [MutableDic setObject:[var valueForKey:@"MatchStartTime"] forKey:@"MatchStartTime"];
                [MutableDic setValue:[var valueForKey:@"Mymatch"] forKey:@"Mymatch"];
                
                
                NSArray *PlayerDetais=[var objectForKey:@"MatchPlayers"];
                
                NSMutableArray *MatchPlayerArry=[[NSMutableArray alloc]init];
                for (NSDictionary *dic in PlayerDetais)
                {
                    
                    
                    NSMutableDictionary *myimageDoictionary=[[NSMutableDictionary alloc]init];
                    [myimageDoictionary setObject:[dic valueForKey:@"id"] forKey:@"id"];
                    [myimageDoictionary setObject:[dic valueForKey:@"payerImage"] forKey:@"payerImage"];
                    [myimageDoictionary setObject:[dic valueForKey:@"PlayerLink"] forKey:@"PlayerLink"];
                    
                    [MatchPlayerArry addObject:myimageDoictionary];
                }
                
                [MutableDic setObject:MatchPlayerArry forKey:@"imagearray"];
                
                [matchListarry addObject:MutableDic];
                
                
            }
            [self performSelectorOnMainThread:@selector(ReloadTable) withObject:nil waitUntilDone:YES];
            
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD showErrorWithStatus:@"No search result found!!"];
                [SVProgressHUD dismiss];
                [matchListtable reloadData];
                [self.view setUserInteractionEnabled:YES];

            });
            
            
        }
        
        
        
        
    }
    
    @catch (NSException *juju)
    {
        NSLog(@"Reporting juju from getUpcomingMatches : %@", juju);
    }
}
//Uitextfield Delegate

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    
    CGRect frame=[self.Scarchicon frame];
    frame.origin.x=9;
    [UIView animateWithDuration:.3f animations:^{
        
        self.Scarchicon.frame=frame;
        
        
    }];
    
    
    
}

//Scrollview Delegate


-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView==matchListtable)
    {
        
        
        [_ButtomBarimage setAlpha:0];
        
        
        
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView==matchListtable)
    {
        
        

        
        [_ButtomBarimage setAlpha:1];
            
            
      
        
    }
    
    CGPoint offset = scrollView.contentOffset;
    CGRect bounds = scrollView.bounds;
    CGSize size = scrollView.contentSize;
    UIEdgeInsets inset = scrollView.contentInset;
    float y = offset.y + bounds.size.height - inset.bottom;
    float h = size.height;
    
    float reload_distance = -60.0f;
    if(y > h + reload_distance)
    {
        if (ispastmatchclick==YES)
        {
            if (ISMOREDATAAVALABLEPAST==TRUE)
            {
                [self.view setUserInteractionEnabled:NO];
                 NSLog(@"Print original load more:");
                 NSInvocationOperation *invocation=[[NSInvocationOperation alloc] initWithTarget:self selector:@selector(getPastMatches:) object:lastIdpast];
                 [OperationQ addOperation:invocation];
            }
            else
            {
                NSLog(@"No more data avaleble:");
            }
            
        }
     
        
    }
    if (Isongoingclick==YES)
    {
        if (ISMOREDATAAVLFORONGOING==TRUE)
        {
            NSInvocationOperation *invocation=[[NSInvocationOperation alloc] initWithTarget:self selector:@selector(getOnGoingMatches:) object:lastIdOngong];
            [OperationQ addOperation:invocation];

        }
    }
    
    if (isupcommingclick==YES)
    {
        
            if (ISMOREDATAAVALABLEUPCOMMING==TRUE)
            {
                NSInvocationOperation *invocation=[[NSInvocationOperation alloc] initWithTarget:self selector:@selector(getUpcomingMatches:) object:LastIdUpcomming];
                [OperationQ addOperation:invocation];
            }
        
    }
 
    
   
}
//ScrollView Delegate for Onscroll pagination

- (IBAction)SelfPerformbackoperation:(id)sender
{
       [self PerformGoBack];
 }




@end
