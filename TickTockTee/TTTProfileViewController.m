//
//  TTTProfileViewController.m
//  TickTockTee
//
//  Created by Esolz Tech on 29/03/14.
//  Copyright (c) 2014 com.esolz.TickTockTee. All rights reserved.
//

#import "TTTProfileViewController.h"
#import "AFNetworking.h"
#import "AFJSONRequestOperation.h"

#import "TTTStatisticsViewController.h"
#import "TTTShowAllfriendmanu.h"
#import "TTTPhotosofme.h"
#import "TTTAchievementStatisticViewController.h"
#import "TTTCretenewmessage.h"
#import "TTTMatchListing.h"
#import "TTTActivityStreem.h"
#import "TTTAppDelegate.h"
#import "TTTLoginViewController.h"
#import "ChangeprofileDetais.h"
#import "TTTAppDelegate.h"
#import "TTTAddPhotoWithoption.h"
#import "SVProgressHUD.h"
#import "TTTCreatematch.h"
#import "TTTProfiletypeActivityCell.h"
#import "TTTCellforAcceptFriendrequest.h"
#import "TTTCellforrounddetails.h"
#import "TTTCellFormatchActivity.h"
#import "TTTActivityCellforachivement.h"
#import "TTTCellForphotoActivity.h"
#import "AFNetworking.h"
#import "AFImageRequestOperation.h"
#import "TTTAchievementDetailsViewController.h"
#import "TTTProfileViewController.h"
#import "TTTPhotodetailsViewController.h"
#import "TTTVideoListViewController.h"
#import "TTTCellForCommentListing.h"
#import "TTTMatchDetails.h"
#import "TTTWebVideoViewController.h"
#import "TTTTotalteeuserlist.h"

@interface TTTProfileViewController ()<NSURLConnectionDelegate,UITextFieldDelegate,UITextViewDelegate>
{
    BOOL IsLeftMenuBoxOpen;
    NSMutableData *datax;
    NSURL *url;
    BOOL islastlocation;
    BOOL isFastLocation,IsChatMenuBoxOpen;
    NSOperationQueue *OperationQactivity;
    NSString *LastID;
    BOOL IsMoredataAvaiable;
    NSMutableArray *ActivityArray;
    NSOperationQueue *OprtationActivity;
    UITapGestureRecognizer *TapGesture;
    NSInteger TEETAG;
    NSInteger COMMENTTAG;
    NSInteger ACHIVEMENTCELL;
    NSInteger PHOTOCELL;
    NSInteger MATCHDETAILSCELL;
    
    UIView *statview;
    NSString *FirstLoadedID;
    UIRefreshControl *Refresher;
    
    UITextView *StatusTxt;
    UILabel *StatusTextLbl;
    TTTGlobalMethods *Method;
    UILabel *TotalteeHenclick;
    UIView *commentView;
    UITableView *commenttable;
    NSMutableArray *CommntArry;
    
    UILabel *Commentwritelable;
    NSString *LoadmoreCommentLastID;
    BOOL IsMoreComment;
    BOOL ISViewUP;
    UIView *mainCommentview;
    NSInteger commentposition;
    UIButton *CommentButton;
    NSInteger NumborofComment;
    CGFloat TotalcommentHeight;
    BOOL LoadFirsttime;
    CGFloat CommentTableConteheight;
    CGFloat isloadFirsttime;
    NSMutableDictionary *dict;
    
    BOOL isFastChatLocation,isLastChatLocation,IsChatBoxOpen,IsMoreCommentAvailable,IfUserLiked,IfUserComment;

}
@property (weak, nonatomic) IBOutlet UILabel *LableLoading;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *LoadingSpinner;

@property (weak, nonatomic) IBOutlet UIView *LoadingLableView;


@property (strong, nonatomic) IBOutlet UIView *vfooterbackview;

@property (weak, nonatomic) IBOutlet UIButton *BackButtonClick;
@property (weak, nonatomic) IBOutlet UIButton *menu;
@property (strong, nonatomic) IBOutlet UIView *chatBoxView;
@property (strong, nonatomic) UITextView *CommentTextview;
@end

@implementation TTTProfileViewController
@synthesize profileTable,ParamprofileViewerId,BackButtonClick,menu;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [super viewDidAppear:YES];
      IsChatMenuBoxOpen=NO;
    islastlocation=TRUE;
    isFastLocation=TRUE;
    [self AddLeftMenuTo:_sideView];
    
    // for Activity streem
    ISViewUP=FALSE;
    LastID =@"0";
    TEETAG=9999;
    COMMENTTAG=999999;
    ACHIVEMENTCELL=99;
    PHOTOCELL=50;
    MATCHDETAILSCELL=100000000;
    LoadFirsttime=TRUE;
    islastlocation=TRUE;
    isFastLocation=TRUE;
    IsChatBoxOpen=FALSE;
    IsLeftMenuBoxOpen=FALSE;
    
    self.LableLoading.font=[UIFont fontWithName:MYRIARDPROLIGHT size:13.0f];
    ActivityArray=[[NSMutableArray alloc]init];
    IsMoreCommentAvailable =TRUE;
    IsMoredataAvaiable=YES;
    self.LoadingLableView.hidden=YES;
    
    OprtationActivity=[[NSOperationQueue alloc]init];
    Method=[[TTTGlobalMethods alloc]init];
    
    
    [self setRoundBorderToImageView:_profileImage];
    [self SetroundborderWithborderWidth:2.0f WithColour:[UIColor whiteColor] ForView:_viewOnProfileImage];
    [self AddNavigationBarTo:_vfooterbackview];
    
    
    
    _scrollMenu.clipsToBounds=YES;
   
     dict=[[NSMutableDictionary alloc]init];
    
    _profileTTHCP.font=[UIFont fontWithName:MYRIARDPROLIGHT size:18];
    _profilePoints.font=[UIFont fontWithName:MYRIARDPROLIGHT size:18];
    _profileName.font=[UIFont fontWithName:MYREADPROREGULAR size:18];
    _profilePlace.font=[UIFont fontWithName:MYREADPROREGULAR size:12];
    
    _loggedInUserid=[self LoggedId];
  //  _MainLabel.text=[NSString stringWithFormat:@"%@'s Profile",_mainLabelString];
    ParamprofileViewerId=([ParamprofileViewerId length]>0)?ParamprofileViewerId:[self LoggedId];
    [self initializeDict];
    
    if([_loggedInUserid isEqualToString:ParamprofileViewerId])
    {
        _unflowButton.hidden=YES;
        _messagebutton.hidden=YES;
        
        self.menu.hidden=NO;
        self.BackButtonClick.hidden=YES;
        UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panDetected:)];
        [_screenView addGestureRecognizer:panRecognizer];
        
    }
    else{
        
        _unflowButton.hidden=NO;
        _messagebutton.hidden=NO;
       
        self.menu.hidden=YES;
        self.BackButtonClick.hidden=NO;
    }
     profileTable.delegate=self;
     profileTable.dataSource=self;
     IsLeftMenuBoxOpen=FALSE;
    
    
    _headerView.hidden=YES;
   
    OperationQactivity=[[NSOperationQueue alloc]init];
    NSInvocationOperation *Profiledetails=[[NSInvocationOperation alloc]initWithTarget:self selector:@selector(initializeDict) object:nil];
    [OperationQactivity addOperation:Profiledetails];
    [self DomyActivity];
}


- (void)panDetected:(UIPanGestureRecognizer *)panRecognizer
{
    
    CGPoint  stopLocation;
    
    if(IsChatMenuBoxOpen==NO){
        
       
        
        if (panRecognizer.state == UIGestureRecognizerStateChanged)
        {
            
            stopLocation = [panRecognizer translationInView:_screenView];
            
            CGRect frame=[_screenView frame];
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
                        _screenView.frame=frame;
                        
                    }];
                    
                }
                else
                {
                    NSLog(@"close satisfied");
                    IsLeftMenuBoxOpen=YES;
                    isFastLocation=TRUE;
                    CGRect lastFrame=[_screenView frame];
                    lastFrame.origin.x=260;
                    [UIView animateWithDuration:.5 animations:^{
                        _screenView.frame=lastFrame;
                        
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
                        _screenView.frame=frame;
                        
                    }];
                    
                }
                else
                {
                    NSLog(@"close satisfied");
                    IsLeftMenuBoxOpen=NO;
                    islastlocation=TRUE;
                    CGRect lastFrame2=[_screenView frame];
                    lastFrame2.origin.x=0;
                    [UIView animateWithDuration:.5 animations:^{
                        _screenView.frame=lastFrame2;
                        
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
                CGRect framelast=[_screenView frame];
                framelast.origin.x=0;
                
                
                [UIView animateWithDuration:.6 animations:^{
                    _screenView.frame=framelast;
                    
                }];
            }
            
            if (stopLocation.x*-1<100.0f&isFastLocation==TRUE&IsLeftMenuBoxOpen==YES)
            {
                NSLog(@"Left Menu opened%f",stopLocation.x);
                
                CGRect framelast=[_screenView frame];
                framelast.origin.x=260;
                
                
                [UIView animateWithDuration:.6 animations:^{
                    _screenView.frame=framelast;
                    
                }];
                
            }
            
            
        }
        
    }
    
}


-(void)PerformChatSliderOperation
{
    
    IsChatMenuBoxOpen=[self PerformChatSlider:_screenView withChatArea:self.chatBoxView IsOpen:IsChatMenuBoxOpen];
    NSLog(@"PerformChatSliderOperation %@",IsChatMenuBoxOpen?@"YES":@"NO");
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma Get Activity Stream

-(void)DetActivityStreem:(NSString *)TheValueoflastID
{
    if ([self isConnectedToInternet])
    {
        @try
        {
            NSError *Error;
            NSString *StringUrl=[NSString stringWithFormat:@"%@user.php?mode=activities&userid=%@&lastid=%@&timezone=%@&loggedin_userid=%@",API,ParamprofileViewerId,TheValueoflastID,[self LocalTimeZoneName],[self LoggedId]];
            NSLog(@"Activity url:%@",StringUrl);
            NSData *dataFromurl=[NSData dataWithContentsOfURL:[NSURL URLWithString:StringUrl]];
            NSDictionary *MainDiction=[NSJSONSerialization JSONObjectWithData:dataFromurl options:kNilOptions error:&Error];
            if ([[MainDiction valueForKey:@"extraparam"] isKindOfClass:[NSDictionary class]])
            {
                NSDictionary *ExtraparamDic=[MainDiction valueForKey:@"extraparam"];
                
                LastID=[ExtraparamDic valueForKey:@"lastid"];
                NSLog(@"The value of last id:%@",LastID);
                if ([[ExtraparamDic valueForKey:@"moredata"] integerValue]==0)
                {
                    IsMoredataAvaiable=FALSE;
                }
            }
            else
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [SVProgressHUD showErrorWithStatus:@"Unexpected error occured"];
                });
                
                
            }
            
            if ([[MainDiction valueForKey:@"activities"] isKindOfClass:[NSArray class]])
            {
                NSArray *SctivityDictionary=[MainDiction valueForKey:@"activities"];
                for (NSDictionary *DicforActivity in SctivityDictionary)
                {
                    NSMutableDictionary *mutDic=[[NSMutableDictionary alloc]init];
                    [mutDic setObject:[DicforActivity valueForKey:@"ActivityType"] forKey:@"ActivityType"];
                    [mutDic setObject:[DicforActivity valueForKey:@"ActivityId"] forKey:@"ActivityId"];
                    [mutDic setObject:[DicforActivity valueForKey:@"ActivityAppType"] forKey:@"ActivityAppType"];
                    [mutDic setObject:[DicforActivity valueForKey:@"ActivityTitle"] forKey:@"ActivityTitle"];
                    
                    
                    if ([[DicforActivity objectForKey:@"ActivityType"] integerValue]==5)
                    {
                        [mutDic setObject:[DicforActivity valueForKey:@"Photourl"] forKey:@"Photourl"];
                        [mutDic setObject:[DicforActivity objectForKey:@"Photolocation"] forKey:@"Photolocation"];
                        [mutDic setObject:[DicforActivity valueForKey:@"PhotoCaption"] forKey:@"PhotoCaption"];
                        [mutDic setObject:[self RemoveNullandreplaceWithSpace:[DicforActivity objectForKey:@"PhotoComment"]] forKey:@"PhotoComment"];
                        [mutDic setObject:[DicforActivity valueForKey:@"ActivityPhotoPosition"] forKey:@"ActivityPhotoPosition"];
                        [mutDic setObject:[DicforActivity valueForKey:@"Photoheight"] forKey:@"Photoheight"];
                        [mutDic setObject:[DicforActivity valueForKey:@"Photowidth"] forKey:@"Photowidth"];
                        
                        
                        
                    }
                    else if ([[DicforActivity objectForKey:@"ActivityType"] integerValue]==6)
                    {
                        [mutDic setObject:[DicforActivity valueForKey:@"Photourl"] forKey:@"Photourl"];
                        [mutDic setObject:[DicforActivity objectForKey:@"Photolocation"] forKey:@"Photolocation"];
                        [mutDic setObject:[DicforActivity valueForKey:@"PhotoCaption"] forKey:@"PhotoCaption"];
                        [mutDic setObject:[self RemoveNullandreplaceWithSpace:[DicforActivity objectForKey:@"PhotoComment"]] forKey:@"PhotoComment"];
                        [mutDic setObject:[self RemoveNullandreplaceWithSpace:[DicforActivity objectForKey:@"Videourl"]] forKey:@"Videourl"];
                        
                    }
                    else if ([[DicforActivity objectForKey:@"ActivityType"] integerValue]==4)
                    {
                        [mutDic setObject:[self RemoveNullandreplaceWithSpace:[DicforActivity valueForKey:@"ActivityTarget"]] forKey:@"ActivityTarget"];
                        [mutDic setObject:[self RemoveNullandreplaceWithSpace:[DicforActivity objectForKey:@"ActivityTargetImage"]] forKey:@"ActivityTargetImage"];
                        [mutDic setObject:[self RemoveNullandreplaceWithSpace:[DicforActivity objectForKey:@"ActivityTargetTitle"]] forKey:@"ActivityTargetTitle"];
                        
                    }
                    else if ([[DicforActivity objectForKey:@"ActivityType"] integerValue]==7)
                    {
                        [mutDic setObject:[self RemoveNullandreplaceWithSpace:[DicforActivity valueForKey:@"ActivityComment"]] forKey:@"ActivityComment"];
                    }
                    
                    if ([[DicforActivity valueForKey:@"MatchDetails"] isKindOfClass:[NSArray class]])
                    {
                        NSArray *MatchDetisarry=[DicforActivity objectForKey:@"MatchDetails"];
                        if ([MatchDetisarry count]>0)
                        {
                            NSDictionary *MatchDetilsDic=[MatchDetisarry objectAtIndex:0];
                            NSMutableDictionary *MatchDetilsdic=[[NSMutableDictionary alloc]init];
                            [MatchDetilsdic setValue:[MatchDetilsDic valueForKey:@"MatchId"] forKey:@"MatchId"];
                            [MatchDetilsdic setValue:[MatchDetilsDic valueForKey:@"MatchTitle"] forKey:@"MatchTitle"];
                            [MatchDetilsdic setValue:[MatchDetilsDic valueForKey:@"MatchLocation"] forKey:@"MatchLocation"];
                            [MatchDetilsdic setValue:[MatchDetilsDic valueForKey:@"MatchSummary"] forKey:@"MatchSummary"];
                            [MatchDetilsdic setValue:[MatchDetilsDic valueForKey:@"MatchDescription"] forKey:@"MatchDescription"];
                            [MatchDetilsdic setValue:[MatchDetilsDic valueForKey:@"MatchStartDate"] forKey:@"MatchStartDate"];
                            [MatchDetilsdic setValue:[MatchDetilsDic valueForKey:@"MatchStartTime"] forKey:@"MatchStartTime"];
                            [MatchDetilsdic setValue:[MatchDetilsDic valueForKey:@"MatchEndDate"] forKey:@"MatchEndDate"];
                            
                            [MatchDetilsdic setValue:[MatchDetilsDic valueForKey:@"MatchEndTime"] forKey:@"MatchEndTime"];
                            [MatchDetilsdic setValue:[self RemoveNullandreplaceWithSpace:[MatchDetilsDic valueForKey:@"MatchCourse"]] forKey:@"MatchCourse"];
                            [MatchDetilsdic setValue:[MatchDetilsDic valueForKey:@"MatchTeeboxColor"] forKey:@"MatchTeeboxColor"];
                            [MatchDetilsdic setValue:[MatchDetilsDic valueForKey:@"MatchSlope"] forKey:@"MatchSlope"];
                            [MatchDetilsdic setValue:[MatchDetilsDic valueForKey:@"MatchRating"] forKey:@"MatchRating"];
                            [MatchDetilsdic setValue:[MatchDetilsDic valueForKey:@"MatchJoinStatus"] forKey:@"MatchJoinStatus"];
                            
                            [MatchDetilsdic setValue:[MatchDetilsDic valueForKey:@"MatchCoverImage"] forKey:@"MatchCoverImage"];
                            [MatchDetilsdic setValue:[MatchDetilsDic valueForKey:@"MatchImage"] forKey:@"MatchImage"];
                            [MatchDetilsdic setValue:[MatchDetilsDic valueForKey:@"EndedStatus"] forKey:@"EndedStatus"];
                            [mutDic setObject:MatchDetilsDic forKey:@"MatchDetails"];
                            
                            
                        }
                        
                    }
                    if ([[DicforActivity valueForKey:@"MatchAchivement"] isKindOfClass:[NSArray class]])
                    {
                        NSArray *MatchDetisarry=[DicforActivity objectForKey:@"MatchAchivement"];
                        if ([MatchDetisarry count]>0)
                        {
                            NSDictionary *MatchDetilsDic=[MatchDetisarry objectAtIndex:0];
                            NSMutableDictionary *MatchDetilsdic=[[NSMutableDictionary alloc]init];
                            [MatchDetilsdic setValue:[MatchDetilsDic valueForKey:@"AchivementId"] forKey:@"AchivementId"];
                            [MatchDetilsdic setValue:[MatchDetilsDic valueForKey:@"AchivementTitle"] forKey:@"AchivementTitle"];
                            [MatchDetilsdic setValue:[MatchDetilsDic valueForKey:@"AchivementImage"] forKey:@"AchivementImage"];
                            [mutDic setObject:MatchDetilsDic forKey:@"MatchAchivement"];
                            
                            
                        }
                        
                    }
                    
                    if ([[DicforActivity valueForKey:@"Photos_list"] isKindOfClass:[NSArray class]])
                    {
                        NSArray *MatchDetisarry=[DicforActivity objectForKey:@"Photos_list"];
                        if ([MatchDetisarry count]>0)
                        {
                            NSMutableArray *MymatchArry=[[NSMutableArray alloc]init];
                            for (NSDictionary *photoDic in MatchDetisarry)
                            {
                                NSMutableDictionary *MatchDetilsdic=[[NSMutableDictionary alloc]init];
                                [MatchDetilsdic setValue:[photoDic valueForKey:@"photo_id"] forKey:@"photo_id"];
                                [MatchDetilsdic setValue:[photoDic valueForKey:@"albumid"] forKey:@"albumid"];
                                [MatchDetilsdic setValue:[photoDic valueForKey:@"caption"] forKey:@"caption"];
                                [MatchDetilsdic setValue:[photoDic valueForKey:@"location"] forKey:@"location"];
                                [MatchDetilsdic setValue:[photoDic valueForKey:@"datetime"] forKey:@"datetime"];
                                [MatchDetilsdic setValue:[photoDic valueForKey:@"thumbnail"] forKey:@"thumbnail"];
                                [MatchDetilsdic setValue:[photoDic valueForKey:@"original"] forKey:@"original"];
                                [MatchDetilsdic setValue:[photoDic valueForKey:@"likecount"] forKey:@"likecount"];
                                
                                [MatchDetilsdic setValue:[photoDic valueForKey:@"commentcount"] forKey:@"commentcount"];
                                [MatchDetilsdic setValue:[photoDic valueForKey:@"isUserLiked"] forKey:@"isUserLiked"];
                                [MatchDetilsdic setValue:[photoDic valueForKey:@"likePermission"] forKey:@"likePermission"];
                                [MatchDetilsdic setValue:[photoDic valueForKey:@"commentPermission"] forKey:@"commentPermission"];
                                [MatchDetilsdic setValue:[photoDic valueForKey:@"sharePermission"] forKey:@"sharePermission"];
                                [MatchDetilsdic setValue:[photoDic valueForKey:@"thumbnail"] forKey:@"thumbnail"];
                                [MatchDetilsdic setValue:[photoDic valueForKey:@"original"] forKey:@"original"];
                                [MatchDetilsdic setValue:[photoDic valueForKey:@"tagPermission"] forKey:@"tagPermission"];
                                [MymatchArry addObject:MatchDetilsdic];
                            }
                            
                            [mutDic setObject:MymatchArry forKey:@"Photos_list"];
                        }
                        
                    }
                    
                    if ([[DicforActivity valueForKey:@"MatchLeaderbord"] isKindOfClass:[NSArray class]])
                    {
                        NSArray *matchleaderbord=[DicforActivity objectForKey:@"MatchLeaderbord"];
                        if ([matchleaderbord count]>0)
                        {
                            NSMutableArray *leaderbordarry=[[NSMutableArray alloc]init];
                            for (NSDictionary *lraderbordDic in matchleaderbord)
                            {
                                NSMutableDictionary *MatchDetilsdic=[[NSMutableDictionary alloc]init];
                                [MatchDetilsdic setValue:[lraderbordDic valueForKey:@"PlayerId"] forKey:@"PlayerId"];
                                [MatchDetilsdic setValue:[lraderbordDic valueForKey:@"PlayerName"] forKey:@"PlayerName"];
                                [MatchDetilsdic setValue:[lraderbordDic valueForKey:@"PlayerImage"] forKey:@"PlayerImage"];
                                [MatchDetilsdic setValue:[lraderbordDic valueForKey:@"MatchHCP"] forKey:@"MatchHCP"];
                                
                                [MatchDetilsdic setValue:[lraderbordDic valueForKey:@"MatchToPar"] forKey:@"MatchToPar"];
                                [MatchDetilsdic setValue:[lraderbordDic valueForKey:@"MatchHole"] forKey:@"MatchHole"];
                                [MatchDetilsdic setValue:[lraderbordDic valueForKey:@"MatchNetScore"] forKey:@"MatchNetScore"];
                                
                                [leaderbordarry addObject:MatchDetilsdic];
                            }
                            
                            [mutDic setObject:leaderbordarry forKey:@"MatchLeaderbord"];
                        }
                        
                    }
                    
                    
                    
                    
                    [mutDic setObject:[DicforActivity valueForKey:@"ActivityCreator"] forKey:@"ActivityCreator"];
                    [mutDic setObject:[DicforActivity valueForKey:@"ActivityCreatorTitle"] forKey:@"ActivityCreatorTitle"];
                    [mutDic setObject:[DicforActivity valueForKey:@"ActivityCreatorImage"] forKey:@"ActivityCreatorImage"];
                    [mutDic setObject:[DicforActivity valueForKey:@"ActivityCreatedDate"] forKey:@"ActivityCreatedDate"];
                    
                    [mutDic setObject:[DicforActivity valueForKey:@"ActivityCreatedRawDate"] forKey:@"ActivityCreatedRawDate"];
                    [mutDic setObject:[DicforActivity valueForKey:@"ActivityCommentCount"] forKey:@"ActivityCommentCount"];
                    [mutDic setObject:[self RemoveNullandreplaceWithSpace:[DicforActivity valueForKey:@"ActivityCommentAllow"]] forKey:@"ActivityCommentAllow"];
                    [mutDic setObject:[DicforActivity valueForKey:@"ActivityLikeCount"] forKey:@"ActivityLikeCount"];
                    [mutDic setObject:[DicforActivity valueForKey:@"ActivityLikeAllow"] forKey:@"ActivityLikeAllow"];
                    [mutDic setObject:[DicforActivity valueForKey:@"ActivityUserLiked"] forKey:@"ActivityUserLiked"];
                    [mutDic setObject:[DicforActivity valueForKey:@"ActivityLikeAllow"] forKey:@"ActivityLikeAllow"];
                    [mutDic setObject:[DicforActivity valueForKey:@"ActivityUserLiked"] forKey:@"ActivityUserLiked"];
                    [mutDic setObject:[DicforActivity valueForKey:@"ActivityLikeAllow"] forKey:@"ActivityLikeAllow"];
                    [mutDic setObject:[DicforActivity valueForKey:@"ActivityUserCommented"] forKey:@"ActivityUserCommented"];
                    [mutDic setObject:[DicforActivity valueForKey:@"ActivityLikeId"] forKey:@"ActivityLikeId"];
                    [mutDic setObject:[DicforActivity valueForKey:@"ActivityCommentId"] forKey:@"ActivityCommentId"];
                    
                    
                    [ActivityArray addObject:mutDic];
                    
                }
                [self performSelectorOnMainThread:@selector(ReloadActivityContent) withObject:nil waitUntilDone:YES];
                
                
            }
            
            else
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [SVProgressHUD showErrorWithStatus:@"Unexpected error occured"];
                });
                
            }
            
            
        }
        @catch (NSException *exception)
        {
            NSLog(@"The exception name and type:%@ %@",[exception name],exception);
        }
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD showErrorWithStatus:@"No internet connection available"];
        });
        
    }
}

-(void)ReloadActivityContent
{
    [self.headerView setHidden:NO];
    [self.LoadingSpinner stopAnimating];
    CGRect tableframe=[profileTable frame];
    _LoadingLableView.hidden=YES;
    if (IsIphone5)
    {
        tableframe.size.height=456;
    }
    
    [profileTable setFrame:tableframe];
    
    [SVProgressHUD dismiss];
    [profileTable reloadData];
}

#pragma Add status post
-(void) StatusClicked
{
    NSArray *arr=[[NSBundle mainBundle] loadNibNamed:@"EtendedDesignView" owner:self options:nil];
    statview=[arr objectAtIndex:13];
    UIView *topView=[statview viewWithTag:9000];
    UIButton *backButton=(UIButton *)[topView viewWithTag:9001];
    
    [backButton addTarget:self action:@selector(backfunc) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *PostButtonclick=(UIButton *)[topView viewWithTag:89567];
    PostButtonclick.titleLabel.font=[UIFont fontWithName:MYRIARDPROLIGHT size:16.0f];
    [PostButtonclick addTarget:self action:@selector(Poststatuswithevent:) forControlEvents:UIControlEventTouchUpInside];
    UIView *UserImagebackview=(UIView *)[statview viewWithTag:9002];
    UIImageView *userimageview=(UIImageView *)[statview viewWithTag:9003];
    [self SetroundborderWithborderWidth:2.0f WithColour:[UIColor whiteColor] ForView:UserImagebackview];
    [self SetroundborderWithborderWidth:0.0f WithColour:[UIColor clearColor] ForImageview:userimageview];
    _LoadingLableView.hidden=YES;
    NSURLRequest *request_img2 = [NSURLRequest requestWithURL:[NSURL URLWithString:[self LoggerImageURL]]];
    
    AFImageRequestOperation *operationProfileimage = [AFImageRequestOperation imageRequestOperationWithRequest:request_img2
                                                      
                                                                                          imageProcessingBlock:nil
                                                      
                                                                                                       success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                                                                           
                                                                                                           if(image!=nil)
                                                                                                               
                                                                                                           {
                                                                                                               
                                                                                                               userimageview.image=image;
                                                                                                               
                                                                                                               
                                                                                                               
                                                                                                           }
                                                                                                           
                                                                                                           
                                                                                                           
                                                                                                       }
                                                      
                                                                                                       failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                                                                                           
                                                                                                           NSLog(@"Error %@",error);
                                                                                                           
                                                                                                           
                                                                                                           
                                                                                                       }];
    
    [operationProfileimage start];
    
    
    
    StatusTxt=(UITextView *)[statview viewWithTag:9004];
    StatusTxt.delegate=self;
    [StatusTxt setReturnKeyType:UIReturnKeyDone];
    [StatusTxt becomeFirstResponder];
    StatusTextLbl=(UILabel *)[statview viewWithTag:9800];
    StatusTxt.font=[UIFont fontWithName:MYRIARDPROLIGHT size:13.0f];
    [StatusTextLbl setFont:[UIFont fontWithName:MYRIARDPROLIGHT size:13.0f]];
    
    [statview setFrame:CGRectMake(0, statview.frame.size.height, statview.frame.size.width, statview.frame.size.height)];
    [self.view addSubview:statview];
    [UIView animateWithDuration:0.3
                          delay:0.02
                        options: UIViewAnimationOptionTransitionFlipFromBottom
                     animations:^
     {
         CGRect frame = statview.frame;
         frame.origin.y = 0;
         frame.origin.x = 0;
         statview.frame = frame;
     }
                     completion:^(BOOL finished)
     {
         
         
     }];
}

-(void) backfunc
{
    
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options: UIViewAnimationOptionTransitionFlipFromTop
                     animations:^
     {
         CGRect frame = statview.frame;
         frame.origin.y =statview.frame.size.height;
         frame.origin.x = 0;
         statview.frame = frame;
     }
                     completion:^(BOOL finished)
     {
         
         
     }];
    
}



// ----- Post Status ------- //

-(IBAction)Poststatuswithevent:(id)sender
{
    
    if (!StatusTxt.text.length>0)
    {
        [SVProgressHUD showErrorWithStatus:@"Status cannot be left blank"];
    }
    else
    {
        [self backfunc];
        NSMutableDictionary *ActivityDicFirst=[ActivityArray objectAtIndex:0];
        FirstLoadedID=[ActivityDicFirst objectForKey:@"ActivityId"];
        NSInvocationOperation *StatusInvocation=[[NSInvocationOperation alloc]initWithTarget:self selector:@selector(AddstatustoActivityview:) object:FirstLoadedID];
        [OperationQactivity addOperation:StatusInvocation];
    }
    
    
}


-(void)AddstatustoActivityview:(NSString *)FirstID
{
    if ([self isConnectedToInternet])
    {
        @try
        {
            NSError *Error;
            NSString *StrString=[NSString stringWithFormat:@"%@user.php?mode=statuswallpost&userid=%@&status=%@&target=%@",API,[self LoggedId],[Method Encoder:StatusTxt.text],ParamprofileViewerId];
            NSLog(@"The value for status post:%@",StrString);
            NSData *PostStatusdata=[NSData dataWithContentsOfURL:[NSURL URLWithString:StrString]];
            NSDictionary *maindicActivity=[NSJSONSerialization JSONObjectWithData:PostStatusdata options:kNilOptions error:&Error];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSString *message=[maindicActivity objectForKey:@"message"];
                if ([message isEqualToString:@"success"])
                {
                    [self PULLMEUP];
                }
                else
                {
                    [SVProgressHUD showErrorWithStatus:@"Fail to post status"];
                }
                
            });
            
            
            
        }
        @catch (NSException *exception)
        {
            NSLog(@"The Exception name:%@",[exception name]);
            NSLog(@"The Exception type:%@",exception);
        }
        
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD showErrorWithStatus:@"Fail to post status"];
            
        });
    }
    
    
    
}

//Set pull me up to update the new satus

-(void)PULLMEUP
 {
    NSMutableDictionary *ActivityDicFirst=[ActivityArray objectAtIndex:0];
    FirstLoadedID=[ActivityDicFirst objectForKey:@"ActivityId"];
    NSInvocationOperation *InvocationPULL=[[NSInvocationOperation alloc]initWithTarget:self selector:@selector(pooltorefefreshbuttonclick:) object:FirstLoadedID];
    [OperationQactivity addOperation:InvocationPULL];
 }



-(void)pooltorefefreshbuttonclick:(NSString *)FirtloadedId
{
    if ([self isConnectedToInternet])
    {
        @try
        {
            NSError *Error;
            NSString *StringUrl=[NSString stringWithFormat:@"%@user.php?mode=activities&userid=%@&lastid=%@&timezone=%@&isbefore=1&loggedin_userid=%@",API,ParamprofileViewerId,FirtloadedId,[self LocalTimeZoneName],[self LoggedId]];
            NSLog(@"Activity url:%@",StringUrl);
            NSData *dataFromurl=[NSData dataWithContentsOfURL:[NSURL URLWithString:StringUrl]];
            NSDictionary *MainDiction=[NSJSONSerialization JSONObjectWithData:dataFromurl options:kNilOptions error:&Error];
            
            if ([[MainDiction valueForKey:@"activities"] isKindOfClass:[NSArray class]])
            {
                NSArray *SctivityDictionary=[MainDiction valueForKey:@"activities"];
                
                if ([SctivityDictionary count]>0)
                {
                    
                    
                    for (NSDictionary *DicforActivity in SctivityDictionary)
                    {
                        
                        NSMutableDictionary *mutDic=[[NSMutableDictionary alloc]init];
                        [mutDic setObject:[DicforActivity valueForKey:@"ActivityType"] forKey:@"ActivityType"];
                        [mutDic setObject:[DicforActivity valueForKey:@"ActivityId"] forKey:@"ActivityId"];
                        [mutDic setObject:[DicforActivity valueForKey:@"ActivityAppType"] forKey:@"ActivityAppType"];
                        [mutDic setObject:[DicforActivity valueForKey:@"ActivityTitle"] forKey:@"ActivityTitle"];
                        if ([[DicforActivity objectForKey:@"ActivityType"] integerValue]==5)
                        {
                            [mutDic setObject:[DicforActivity valueForKey:@"Photourl"] forKey:@"Photourl"];
                            [mutDic setObject:[DicforActivity objectForKey:@"Photolocation"] forKey:@"Photolocation"];
                            [mutDic setObject:[DicforActivity valueForKey:@"PhotoCaption"] forKey:@"PhotoCaption"];
                            [mutDic setObject:[self RemoveNullandreplaceWithSpace:[DicforActivity objectForKey:@"PhotoComment"]] forKey:@"PhotoComment"];
                            [mutDic setObject:[DicforActivity valueForKey:@"Photoheight"] forKey:@"Photoheight"];
                            [mutDic setObject:[DicforActivity valueForKey:@"Photowidth"] forKey:@"Photowidth"];
                            
                            
                        }
                        else if ([[DicforActivity objectForKey:@"ActivityType"] integerValue]==6)
                        {
                            [mutDic setObject:[DicforActivity valueForKey:@"Photourl"] forKey:@"Photourl"];
                            [mutDic setObject:[DicforActivity objectForKey:@"Photolocation"] forKey:@"Photolocation"];
                            [mutDic setObject:[DicforActivity valueForKey:@"PhotoCaption"] forKey:@"PhotoCaption"];
                            [mutDic setObject:[self RemoveNullandreplaceWithSpace:[DicforActivity objectForKey:@"PhotoComment"]] forKey:@"PhotoComment"];
                            [mutDic setObject:[self RemoveNullandreplaceWithSpace:[DicforActivity objectForKey:@"Videourl"]] forKey:@"Videourl"];
                        }
                        
                        else if ([[DicforActivity objectForKey:@"ActivityType"] integerValue]==7)
                        {
                            [mutDic setObject:[self RemoveNullandreplaceWithSpace:[DicforActivity valueForKey:@"ActivityComment"]] forKey:@"ActivityComment"];
                        }
                        else if ([[DicforActivity objectForKey:@"ActivityType"] integerValue]==4)
                        {
                            [mutDic setObject:[self RemoveNullandreplaceWithSpace:[DicforActivity valueForKey:@"ActivityTarget"]] forKey:@"ActivityTarget"];
                            [mutDic setObject:[self RemoveNullandreplaceWithSpace:[DicforActivity objectForKey:@"ActivityTargetImage"]] forKey:@"ActivityTargetImage"];
                            [mutDic setObject:[self RemoveNullandreplaceWithSpace:[DicforActivity objectForKey:@"ActivityTargetTitle"]] forKey:@"ActivityTargetTitle"];
                            
                        }
                        
                        if ([[DicforActivity valueForKey:@"MatchDetails"] isKindOfClass:[NSArray class]])
                        {
                            NSArray *MatchDetisarry=[DicforActivity objectForKey:@"MatchDetails"];
                            if ([MatchDetisarry count]>0)
                            {
                                NSDictionary *MatchDetilsDic=[MatchDetisarry objectAtIndex:0];
                                NSMutableDictionary *MatchDetilsdic=[[NSMutableDictionary alloc]init];
                                [MatchDetilsdic setValue:[MatchDetilsDic valueForKey:@"MatchId"] forKey:@"MatchId"];
                                [MatchDetilsdic setValue:[MatchDetilsDic valueForKey:@"MatchTitle"] forKey:@"MatchTitle"];
                                [MatchDetilsdic setValue:[MatchDetilsDic valueForKey:@"MatchLocation"] forKey:@"MatchLocation"];
                                [MatchDetilsdic setValue:[MatchDetilsDic valueForKey:@"MatchSummary"] forKey:@"MatchSummary"];
                                [MatchDetilsdic setValue:[MatchDetilsDic valueForKey:@"MatchDescription"] forKey:@"MatchDescription"];
                                [MatchDetilsdic setValue:[MatchDetilsDic valueForKey:@"MatchStartDate"] forKey:@"MatchStartDate"];
                                [MatchDetilsdic setValue:[MatchDetilsDic valueForKey:@"MatchStartTime"] forKey:@"MatchStartTime"];
                                [MatchDetilsdic setValue:[MatchDetilsDic valueForKey:@"MatchEndDate"] forKey:@"MatchEndDate"];
                                
                                [MatchDetilsdic setValue:[MatchDetilsDic valueForKey:@"MatchEndTime"] forKey:@"MatchEndTime"];
                                [MatchDetilsdic setValue:[self RemoveNullandreplaceWithSpace:[MatchDetilsDic valueForKey:@"MatchCourse"]] forKey:@"MatchCourse"];
                                [MatchDetilsdic setValue:[MatchDetilsDic valueForKey:@"MatchTeeboxColor"] forKey:@"MatchTeeboxColor"];
                                [MatchDetilsdic setValue:[MatchDetilsDic valueForKey:@"MatchSlope"] forKey:@"MatchSlope"];
                                [MatchDetilsdic setValue:[MatchDetilsDic valueForKey:@"MatchRating"] forKey:@"MatchRating"];
                                [MatchDetilsdic setValue:[MatchDetilsDic valueForKey:@"MatchJoinStatus"] forKey:@"MatchJoinStatus"];
                                
                                [MatchDetilsdic setValue:[MatchDetilsDic valueForKey:@"MatchCoverImage"] forKey:@"MatchCoverImage"];
                                [MatchDetilsdic setValue:[MatchDetilsDic valueForKey:@"MatchImage"] forKey:@"MatchImage"];
                                [MatchDetilsdic setValue:[MatchDetilsDic valueForKey:@"EndedStatus"] forKey:@"EndedStatus"];
                                [mutDic setObject:MatchDetilsDic forKey:@"MatchDetails"];
                                
                                
                            }
                            
                        }
                        if ([[DicforActivity valueForKey:@"MatchAchivement"] isKindOfClass:[NSArray class]])
                        {
                            NSArray *MatchDetisarry=[DicforActivity objectForKey:@"MatchAchivement"];
                            if ([MatchDetisarry count]>0)
                            {
                                NSDictionary *MatchDetilsDic=[MatchDetisarry objectAtIndex:0];
                                NSMutableDictionary *MatchDetilsdic=[[NSMutableDictionary alloc]init];
                                [MatchDetilsdic setValue:[MatchDetilsDic valueForKey:@"AchivementId"] forKey:@"AchivementId"];
                                [MatchDetilsdic setValue:[MatchDetilsDic valueForKey:@"AchivementTitle"] forKey:@"AchivementTitle"];
                                [MatchDetilsdic setValue:[MatchDetilsDic valueForKey:@"AchivementImage"] forKey:@"AchivementImage"];
                                [mutDic setObject:MatchDetilsDic forKey:@"MatchAchivement"];
                                
                                
                            }
                            
                        }
                        
                        if ([[DicforActivity valueForKey:@"Photos_list"] isKindOfClass:[NSArray class]])
                        {
                            NSArray *MatchDetisarry=[DicforActivity objectForKey:@"Photos_list"];
                            if ([MatchDetisarry count]>0)
                            {
                                NSMutableArray *MymatchArry=[[NSMutableArray alloc]init];
                                for (NSDictionary *photoDic in MatchDetisarry)
                                {
                                    NSMutableDictionary *MatchDetilsdic=[[NSMutableDictionary alloc]init];
                                    [MatchDetilsdic setValue:[photoDic valueForKey:@"photo_id"] forKey:@"photo_id"];
                                    [MatchDetilsdic setValue:[photoDic valueForKey:@"albumid"] forKey:@"albumid"];
                                    [MatchDetilsdic setValue:[photoDic valueForKey:@"caption"] forKey:@"caption"];
                                    [MatchDetilsdic setValue:[photoDic valueForKey:@"location"] forKey:@"location"];
                                    [MatchDetilsdic setValue:[photoDic valueForKey:@"datetime"] forKey:@"datetime"];
                                    [MatchDetilsdic setValue:[photoDic valueForKey:@"thumbnail"] forKey:@"thumbnail"];
                                    [MatchDetilsdic setValue:[photoDic valueForKey:@"original"] forKey:@"original"];
                                    [MatchDetilsdic setValue:[photoDic valueForKey:@"likecount"] forKey:@"likecount"];
                                    
                                    [MatchDetilsdic setValue:[photoDic valueForKey:@"commentcount"] forKey:@"commentcount"];
                                    [MatchDetilsdic setValue:[photoDic valueForKey:@"isUserLiked"] forKey:@"isUserLiked"];
                                    [MatchDetilsdic setValue:[photoDic valueForKey:@"likePermission"] forKey:@"likePermission"];
                                    [MatchDetilsdic setValue:[photoDic valueForKey:@"commentPermission"] forKey:@"commentPermission"];
                                    [MatchDetilsdic setValue:[photoDic valueForKey:@"sharePermission"] forKey:@"sharePermission"];
                                    [MatchDetilsdic setValue:[photoDic valueForKey:@"thumbnail"] forKey:@"thumbnail"];
                                    [MatchDetilsdic setValue:[photoDic valueForKey:@"original"] forKey:@"original"];
                                    [MatchDetilsdic setValue:[photoDic valueForKey:@"tagPermission"] forKey:@"tagPermission"];
                                    
                                    [MymatchArry addObject:MatchDetilsdic];
                                }
                                
                                [mutDic setObject:MymatchArry forKey:@"Photos_list"];
                            }
                            
                        }
                        
                        if ([[DicforActivity valueForKey:@"MatchLeaderbord"] isKindOfClass:[NSArray class]])
                        {
                            NSArray *matchleaderbord=[DicforActivity objectForKey:@"MatchLeaderbord"];
                            if ([matchleaderbord count]>0)
                            {
                                NSMutableArray *leaderbordarry=[[NSMutableArray alloc]init];
                                for (NSDictionary *lraderbordDic in matchleaderbord)
                                {
                                    NSMutableDictionary *MatchDetilsdic=[[NSMutableDictionary alloc]init];
                                    [MatchDetilsdic setValue:[lraderbordDic valueForKey:@"PlayerId"] forKey:@"PlayerId"];
                                    [MatchDetilsdic setValue:[lraderbordDic valueForKey:@"PlayerName"] forKey:@"PlayerName"];
                                    [MatchDetilsdic setValue:[lraderbordDic valueForKey:@"PlayerImage"] forKey:@"PlayerImage"];
                                    [MatchDetilsdic setValue:[lraderbordDic valueForKey:@"MatchHCP"] forKey:@"MatchHCP"];
                                    
                                    [MatchDetilsdic setValue:[lraderbordDic valueForKey:@"MatchToPar"] forKey:@"MatchToPar"];
                                    [MatchDetilsdic setValue:[lraderbordDic valueForKey:@"MatchHole"] forKey:@"MatchHole"];
                                    [MatchDetilsdic setValue:[lraderbordDic valueForKey:@"MatchNetScore"] forKey:@"MatchNetScore"];
                                    
                                    [leaderbordarry addObject:MatchDetilsdic];
                                }
                                
                                [mutDic setObject:leaderbordarry forKey:@"MatchLeaderbord"];
                            }
                            
                        }
                        
                        
                        
                        
                        [mutDic setObject:[DicforActivity valueForKey:@"ActivityCreator"] forKey:@"ActivityCreator"];
                        [mutDic setObject:[DicforActivity valueForKey:@"ActivityCreatorTitle"] forKey:@"ActivityCreatorTitle"];
                        [mutDic setObject:[DicforActivity valueForKey:@"ActivityCreatorImage"] forKey:@"ActivityCreatorImage"];
                        [mutDic setObject:[DicforActivity valueForKey:@"ActivityCreatedDate"] forKey:@"ActivityCreatedDate"];
                        
                        [mutDic setObject:[DicforActivity valueForKey:@"ActivityCreatedRawDate"] forKey:@"ActivityCreatedRawDate"];
                        [mutDic setObject:[DicforActivity valueForKey:@"ActivityCommentCount"] forKey:@"ActivityCommentCount"];
                        [mutDic setObject:[DicforActivity valueForKey:@"ActivityCommentAllow"] forKey:@"ActivityCommentAllow"];
                        [mutDic setObject:[DicforActivity valueForKey:@"ActivityLikeCount"] forKey:@"ActivityLikeCount"];
                        [mutDic setObject:[DicforActivity valueForKey:@"ActivityLikeAllow"] forKey:@"ActivityLikeAllow"];
                        [mutDic setObject:[DicforActivity valueForKey:@"ActivityUserLiked"] forKey:@"ActivityUserLiked"];
                        [mutDic setObject:[DicforActivity valueForKey:@"ActivityLikeAllow"] forKey:@"ActivityLikeAllow"];
                        [mutDic setObject:[DicforActivity valueForKey:@"ActivityUserLiked"] forKey:@"ActivityUserLiked"];
                        [mutDic setObject:[DicforActivity valueForKey:@"ActivityLikeAllow"] forKey:@"ActivityLikeAllow"];
                        [mutDic setObject:[DicforActivity valueForKey:@"ActivityUserCommented"] forKey:@"ActivityUserCommented"];
                        [mutDic setObject:[DicforActivity valueForKey:@"ActivityLikeId"] forKey:@"ActivityLikeId"];
                        [mutDic setObject:[DicforActivity valueForKey:@"ActivityCommentId"] forKey:@"ActivityCommentId"];
                        
                        
                        [self performSelectorOnMainThread:@selector(InsertARowinThetable:) withObject:mutDic waitUntilDone:YES];
                        
                        
                    }
                    
                }
                else
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [Refresher endRefreshing];
                    });
                    
                }
                
            }
            
            else
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [SVProgressHUD showErrorWithStatus:@"Unexpected error occured"];
                });
                
            }
            
            
        }
        @catch (NSException *exception)
        {
            NSLog(@"The exception name and type:%@ %@",[exception name],exception);
        }
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD showErrorWithStatus:@"No internet connection available"];
        });
        
    }
    
}
-(void)InsertARowinThetable:(NSMutableDictionary *)mutDic
{
    [Refresher endRefreshing];
    [ActivityArray insertObject:mutDic atIndex:0];
    NSIndexPath *indexpath=[NSIndexPath indexPathForRow:1 inSection:0];
    [profileTable beginUpdates];
    [profileTable insertRowsAtIndexPaths:[NSArray arrayWithObjects:indexpath, nil] withRowAnimation:UITableViewRowAnimationFade];
    [profileTable endUpdates];
    
}


//------------ Status post complet ------------//





//----- Add Comment portion ---------//


-(void)DomyActivity
{
    
    [profileTable reloadData];
    NSInvocationOperation *Invocation=[[NSInvocationOperation alloc]initWithTarget:self selector:@selector(DetActivityStreem:) object:LastID];
    [OperationQactivity addOperation:Invocation];
}

//Give comment on cliucking the comment biutton

-(void)opencommentWithActivityDictionary:(NSMutableDictionary *)ActivityDic
{
    
    NumborofComment=0;
    NSArray *arr=[[NSBundle mainBundle] loadNibNamed:@"EtendedDesignView" owner:self options:nil];
    
    commentView=[arr objectAtIndex:14];
    
    UIView *topView=[commentView viewWithTag:200];
    
    UIButton *backButton=(UIButton *)[topView viewWithTag:201];
    
    
    
    [backButton addTarget:self action:@selector(backfuncforcommentView) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    UIView *dataView=[commentView viewWithTag:202];
    
    commenttable=(UITableView *)[dataView viewWithTag:203];
    
    commenttable.backgroundColor=[UIColor clearColor];
    
    commenttable.delegate=self;
    
    commenttable.dataSource=self;
    
    mainCommentview=(UIView *)[commentView viewWithTag:2003];
    
    Commentwritelable=(UILabel *)[mainCommentview viewWithTag:20005];
    Commentwritelable.font=[UIFont fontWithName:MYRIARDPROLIGHT size:14.0f];
    
    self.CommentTextview =(UITextView *)[mainCommentview viewWithTag:888];
    self.CommentTextview.delegate=self;
    self.CommentTextview.font=[UIFont fontWithName:MYRIARDPROLIGHT size:14.0f];
    
    
    UIButton *PostButton=(UIButton *)[mainCommentview viewWithTag:20004];
    [PostButton addTarget:self action:@selector(Postacomment:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
    
    [commentView setFrame:CGRectMake(0, commentView.frame.size.height, commentView.frame.size.width, commentView.frame.size.height)];
    
    [self.view addSubview:commentView];
    
    [UIView animateWithDuration:0.2
     
                          delay:0.0
     
                        options: UIViewAnimationOptionTransitionFlipFromBottom
     
                     animations:^
     
     {
         
         CGRect frame = commentView.frame;
         
         frame.origin.y = 0;
         
         frame.origin.x = 0;
         
         commentView.frame = frame;
         
     }
     
                     completion:^(BOOL finished)
     
     {
         
         
         
         
         
     }];
    
    CommntArry=[[NSMutableArray alloc]init];
    
    [CommntArry addObject:ActivityDic];
    [CommntArry addObject:ActivityDic];
    [CommntArry addObject:ActivityDic];
    [SVProgressHUD show];
    NSInvocationOperation *EventOperation=[[NSInvocationOperation alloc]initWithTarget:self selector:@selector(LoadActivitycomment:) object:[ActivityDic objectForKey:@"ActivityCommentId"]];
    [OperationQactivity addOperation:EventOperation];
    
    
    
}
-(void)LoadActivitycomment:(NSString *)ActivityID
{
    
    @try
    {
        if ([self isConnectedToInternet])
        {
            NSError *Error;
            NSString *ActivityCommentstr=[NSString stringWithFormat:@"%@user.php?mode=activitiescomment&userid=%@&activityid=%@&loggedin_userid=%@",API,ParamprofileViewerId,ActivityID,[self LoggedId]];
            NSLog(@"The value for string url-----Comment url:%@",ActivityCommentstr);
            NSData *data=[NSData dataWithContentsOfURL:[NSURL URLWithString:ActivityCommentstr]];
            if (data.length>2)
            {
                NSDictionary *mainDic=[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&Error];
                NSDictionary *ExtraparamDic=[mainDic valueForKey:@"extraparam"];
                LoadmoreCommentLastID=[ExtraparamDic valueForKey:@"lastid"];
                IsMoreComment=([ExtraparamDic valueForKey:@"moredata"]>0)?TRUE:FALSE;
                if ([[mainDic valueForKey:@"comments"] isKindOfClass:[NSArray class]])
                {
                    NSArray *CommentMainArray=[mainDic objectForKey:@"comments"];
                    for (NSDictionary *DicComment in CommentMainArray)
                    {
                        NSMutableDictionary *Dicmain=[[NSMutableDictionary alloc]init];
                        [Dicmain setValue:[DicComment valueForKey:@"commentid"] forKey:@"commentid"];
                        [Dicmain setValue:[DicComment valueForKey:@"commentedByID"] forKey:@"commentedByID"];
                        [Dicmain setValue:[DicComment valueForKey:@"comment"] forKey:@"comment"];
                        [Dicmain setValue:[DicComment valueForKey:@"commentedByName"] forKey:@"commentedByName"];
                        [Dicmain setValue:[DicComment valueForKey:@"commentedByImage"] forKey:@"commentedByImage"];
                        [Dicmain setValue:[DicComment valueForKey:@"commentdate"] forKey:@"commentdate"];
                        [CommntArry addObject:Dicmain];
                    }
                   
                    [self performSelectorOnMainThread:@selector(reloadComment) withObject:nil waitUntilDone:YES];
                }
                else
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [SVProgressHUD showErrorWithStatus:@"Unexpected error occured"];
                        
                    });
                }
                
            }
            else
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [SVProgressHUD showErrorWithStatus:@"Unexpected error occured"];
                    
                });
            }
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [SVProgressHUD showErrorWithStatus:@"No internet connection!"];
                
            });
        }
        
    }
    @catch (NSException *exception)
    {
        NSLog(@"The value of exception:%@ %@",[exception name],exception);
    }
    
    
    
    
    
}



-(void)reloadComment
{
    [SVProgressHUD dismiss];
    [commenttable reloadData];
}


-(IBAction)Postacomment:(UIButton *)Postbtn
{
    
    
    ISViewUP=TRUE;
    [_CommentTextview resignFirstResponder];
    [self UptheCencelOrdoneview];
    
    if (_CommentTextview.text.length>0)
    {
        NSMutableDictionary *ActivityDic=[CommntArry objectAtIndex:0];
        NSInvocationOperation *CommentInvocation=[[NSInvocationOperation alloc]initWithTarget:self selector:@selector(Postcommntonactivity:) object:[ActivityDic objectForKey:@"ActivityCommentId"]];
        [OperationQactivity addOperation:CommentInvocation];
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:@"please write something"];
        [commenttable setContentSize:CGSizeMake(320, CommentTableConteheight)];
        NSIndexPath *Indexpath=[NSIndexPath indexPathForRow:[CommntArry count]-1 inSection:0];
        
        [commenttable scrollToRowAtIndexPath:Indexpath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        
    }
    
    
}

//---------------- Post button click for posting the method ----------------//

-(void)Postcommntonactivity:(NSString *)ActivityID
{
    @try
    {
        NSError *erroe;
        if ([self isConnectedToInternet])
        {
            NSString *AddCommentUrl=[NSString stringWithFormat:@"%@user.php?mode=addactivityComment&userid=%@&activityid=%@&comment=%@&loggedin_userid=%@",API,[self LoggedId],ActivityID,[Method Encoder:_CommentTextview.text],[self LoggedId]];
            NSLog(@"Addd comment url------------%@",AddCommentUrl);
            NSData *maindata=[NSData dataWithContentsOfURL:[NSURL URLWithString:AddCommentUrl]];
            if (maindata.length>2)
            {
                NSDictionary *MainDataDic=[NSJSONSerialization JSONObjectWithData:maindata options:kNilOptions error:&erroe];
                NSString *resopnce=[MainDataDic valueForKey:@"response"];
                NSString *messagestr=[MainDataDic valueForKey:@"message"];
                if ([resopnce isEqualToString:@"success"])
                {
                    [self performSelectorOnMainThread:@selector(reloadcommentwithmesssage:) withObject:messagestr waitUntilDone:YES];
                }
                else
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [SVProgressHUD showErrorWithStatus:messagestr];
                    });
                    
                }
            }
            else
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [SVProgressHUD showErrorWithStatus:@"unexpected error occurred!"];
                });
            }
            
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD showErrorWithStatus:@"No internet connection!"];
            });
        }
    }
    @catch (NSException *exception)
    {
        NSLog(@"Type of exception--Kind of exception---%@ ---------%@",[exception name],exception);
    }
    
}

// ------------ set message -------------//

-(void)reloadcommentwithmesssage:(NSString *)message
{
    
    NumborofComment=NumborofComment+1;
    NSMutableDictionary *Mutdicadd=[[NSMutableDictionary alloc]init];
    [Mutdicadd setValue:[self LoggedId] forKey:@"commentid"];
    [Mutdicadd setValue:[self LoggedId] forKey:@"commentedByID"];
    [Mutdicadd setValue:_CommentTextview.text forKey:@"comment"];
    [Mutdicadd setValue:[self LoggerName] forKey:@"commentedByName"];
    [Mutdicadd setValue:[self LoggerImageURL] forKey:@"commentedByImage"];
    [Mutdicadd setValue:@"A moment ago" forKey:@"commentdate"];
    _CommentTextview.text=nil;
    Commentwritelable.hidden=FALSE;
    [CommntArry addObject:Mutdicadd];
    NSIndexPath *Indexpath=[NSIndexPath indexPathForRow:[CommntArry count]-1 inSection:0];
    [commenttable beginUpdates];
    [commenttable insertRowsAtIndexPaths:[[NSArray alloc]initWithObjects:Indexpath, nil] withRowAnimation:UITableViewRowAnimationFade];
    [commenttable endUpdates];
     [commenttable setContentSize:CGSizeMake(320, CommentTableConteheight)];
    [commenttable scrollToRowAtIndexPath:Indexpath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
   
    [SVProgressHUD showSuccessWithStatus:message];
}



-(void) backfuncforcommentView

{
    
    if (NumborofComment>0)
    {
        NSMutableDictionary *mutDic=[CommntArry objectAtIndex:0];
        UIView *Superview=[CommentButton superview];
        NSArray *sunviewarray=[Superview subviews];
        if (NumborofComment>0||[[mutDic objectForKey:@"ActivityUserCommented"] integerValue]>0)
        {
            [CommentButton setBackgroundImage:[UIImage imageNamed:@"commentParmitionhave"] forState:UIControlStateNormal];
            [CommentButton setBackgroundImage:[UIImage imageNamed:@"commentParmitionhave"] forState:UIControlStateSelected];
            [CommentButton setBackgroundImage:[UIImage imageNamed:@"commentParmitionhave"] forState:UIControlStateHighlighted];
            
        }
        for (UIView *Subview in sunviewarray)
        {
            if ([Subview isKindOfClass:[UILabel class]])
            {
                if (Subview.tag==12)
                {
                    UILabel *commentlbl=(UILabel *)Subview;
                    commentlbl.text=[NSString stringWithFormat:@"%d Comments",NumborofComment+[[mutDic objectForKey:@"ActivityCommentCount"] integerValue]];
                    
                }
            }
        }
        [mutDic setObject:[NSString stringWithFormat:@"%d",NumborofComment+[[mutDic objectForKey:@"ActivityCommentCount"] integerValue]] forKey:@"ActivityCommentCount"];
        [mutDic setObject:@"1" forKey:@"ActivityUserCommented"];
        [ActivityArray replaceObjectAtIndex:commentposition withObject:mutDic];
         NSIndexPath *indexpath=[NSIndexPath indexPathForRow:commentposition inSection:0];
        [profileTable reloadRowsAtIndexPaths:[[NSArray alloc]initWithObjects:indexpath, nil ] withRowAnimation:UITableViewRowAnimationNone];
        
    }
    
    [UIView animateWithDuration:0.3
     
                          delay:0.0
     
                        options: UIViewAnimationOptionTransitionFlipFromTop
     
                     animations:^
     
     {
         
         CGRect frame = commentView.frame;
         
         frame.origin.y =commentView.frame.size.height;
         
         frame.origin.x = 0;
         
         commentView.frame = frame;
         
     }
     
                     completion:^(BOOL finished)
     
     {
         
         
         
         
         
     }];
    
    
    
}

#pragma mark UITableViewDelegate

-(int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   
    
    return (tableView==profileTable)?([ActivityArray count]+1):[CommntArry count];
    
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView==profileTable)
    {
        if(indexPath.row==0)
        {
             UITableViewCell *cell=[[UITableViewCell alloc]init];
             [cell.contentView addSubview:_headerView];
             cell.backgroundColor=[UIColor clearColor];
             return cell;
        }
        else
        {
        NSMutableDictionary *mutDicActivity=[ActivityArray objectAtIndex:indexPath.row-1];
        if ([[mutDicActivity valueForKey:@"ActivityType"] integerValue]==1)
        {
            //----------------------Activity Type Achivement-----------------------//
            //  ------- Section1 -------   //
            static NSString *TTTcellforachivement=@"TTTActivityCellforachivement";
            TTTActivityCellforachivement *AchivementCell=(TTTActivityCellforachivement *)[tableView dequeueReusableCellWithIdentifier:TTTcellforachivement];
            AchivementCell=nil;
            if (AchivementCell==nil)
            {
                NSArray *CellNib=[[NSBundle mainBundle] loadNibNamed:@"TTTActivityCellforachivement" owner:self options:nil];
                AchivementCell=(TTTActivityCellforachivement *)[CellNib objectAtIndex:0];
                //}
                CGFloat extraHeight=0.0f;
                UIView *UserphotobackView=(UIView *)[AchivementCell.contentView viewWithTag:1];
                [self SetroundborderWithborderWidth:2.0f WithColour:[UIColor whiteColor] ForView:UserphotobackView];
                
                UIImageView *ActivityOwnerimageView=(UIImageView *)[AchivementCell.contentView viewWithTag:2];
                [self SetroundborderWithborderWidth:0.0f WithColour:[UIColor clearColor] ForImageview:ActivityOwnerimageView];
                
                //Download Image in image
                
                NSURLRequest *request_img2 = [NSURLRequest requestWithURL:[NSURL URLWithString:[mutDicActivity objectForKey:@"ActivityCreatorImage"]]];
                
                AFImageRequestOperation *operationProfileimage = [AFImageRequestOperation imageRequestOperationWithRequest:request_img2
                                                                  
                                                                                                      imageProcessingBlock:nil
                                                                  
                                                                                                                   success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                                                                                       
                                                                                                                       if(image!=nil)
                                                                                                                           
                                                                                                                       {
                                                                                                                           
                                                                                                                           ActivityOwnerimageView.image=image;
                                                                                                                           
                                                                                                                           
                                                                                                                           
                                                                                                                       }
                                                                                                                       
                                                                                                                       
                                                                                                                       
                                                                                                                   }
                                                                  
                                                                                                                   failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                                                                                                       
                                                                                                                       NSLog(@"Error %@",error);
                                                                                                                       
                                                                                                                       
                                                                                                                       
                                                                                                                   }];
                
                [operationProfileimage start];
                
                // --------  Send to profile image view  ------- //
                TapGesture=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(SendToProfileView:)];
                [TapGesture setNumberOfTapsRequired:1];
                [ActivityOwnerimageView setUserInteractionEnabled:YES];
                [ActivityOwnerimageView setTag:[[mutDicActivity objectForKey:@"ActivityCreator"] integerValue]];
                [ActivityOwnerimageView addGestureRecognizer:TapGesture];
                
                //Activity owner name
                
                UILabel *OwnernameLbl=(UILabel *)[AchivementCell.contentView viewWithTag:3];
                OwnernameLbl.font=[UIFont fontWithName:MYRIARDPROSAMIBOLT size:16.0f];
                OwnernameLbl.text=[mutDicActivity objectForKey:@"ActivityCreatorTitle"];
                
                //Activity Titel Lable
                
                UILabel *ActivityTitel=(UILabel *)[AchivementCell.contentView viewWithTag:4];
                CGRect activityframe=[ActivityTitel frame];
                ActivityTitel.font=[UIFont fontWithName:MYRIARDPROLIGHT size:15.0f];
                ActivityTitel.textColor=[UIColor whiteColor];
                ActivityTitel.textAlignment=NSTextAlignmentLeft;
                
                CGRect ActivityTitelframe = [[mutDicActivity objectForKey:@"ActivityTitle"] boundingRectWithSize:CGSizeMake(230, MAXFLOAT)
                                                                                                         options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                                                                      attributes:@{NSFontAttributeName:[UIFont fontWithName:MYRIARDPROLIGHT size:15.0f]
                                                                                                                   }
                                                                                                         context:nil];
                
                extraHeight=(ActivityTitelframe.size.height>21)?ActivityTitelframe.size.height-21:0.0f;
                
                ActivityTitel.text=[mutDicActivity objectForKey:@"ActivityTitle"];
                [ActivityTitel setNumberOfLines:0];
                [ActivityTitel setLineBreakMode:NSLineBreakByWordWrapping];
                activityframe.size.height+=extraHeight;
                [ActivityTitel setFrame:activityframe];
                
                //----- Activity posted time from privious time -----//
                
                UILabel *PostTimeLBL=(UILabel *)[AchivementCell.contentView viewWithTag:5];
                PostTimeLBL.textColor=[UIColor whiteColor];
                PostTimeLBL.font=[UIFont fontWithName:MYRIARDPROLIGHT size:13.0f];
                PostTimeLBL.text=[mutDicActivity objectForKey:@"ActivityCreatedDate"];
                
                //   Section 2  //
                
                //------------- Set Achivement image To the achivement image view tag-400 ---------------//
                
                NSMutableDictionary *ActivityAchivementDic=[mutDicActivity objectForKey:@"MatchAchivement"];
                
                UIImageView *AchiveImgview=(UIImageView *)[AchivementCell.contentView viewWithTag:400];
                
                [self SetroundborderWithborderWidth:2.0f WithColour:[UIColor clearColor] ForImageview:AchiveImgview];
                [AchiveImgview setTag:ACHIVEMENTCELL+indexPath.row];
                TapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(GoestoAchivement:)];
                [TapGesture setNumberOfTapsRequired:1];
                [AchiveImgview setUserInteractionEnabled:YES];
                [AchiveImgview addGestureRecognizer:TapGesture];
                
                NSURLRequest *AchiveMentimage = [NSURLRequest requestWithURL:[NSURL URLWithString:[ActivityAchivementDic valueForKey:@"AchivementImage"]]];
                
                AFImageRequestOperation *DownlodAchivementImage = [AFImageRequestOperation imageRequestOperationWithRequest:AchiveMentimage
                                                                   
                                                                                                       imageProcessingBlock:nil
                                                                   
                                                                                                                    success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                                                                                        
                                                                                                                        if(image!=nil)
                                                                                                                            
                                                                                                                        {
                                                                                                                            
                                                                                                                            AchiveImgview.image=image;
                                                                                                                            
                                                                                                                            
                                                                                                                            
                                                                                                                        }
                                                                                                                        
                                                                                                                        
                                                                                                                        
                                                                                                                    }
                                                                   
                                                                                                                    failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                                                                                                        
                                                                                                                        NSLog(@"Error %@",error);
                                                                                                                        
                                                                                                                        
                                                                                                                        
                                                                                                                    }];
                
                [DownlodAchivementImage start];
                
                //-------------Set match name--------//
                
                NSMutableDictionary *MatchDetailsDic=[mutDicActivity objectForKey:@"MatchDetails"];
                UILabel *MatchName=(UILabel *)[AchivementCell.contentView viewWithTag:6];
                MatchName.font=[UIFont fontWithName:MYRIARDPROSAMIBOLT size:15.0f];
                MatchName.textColor=[UIColor whiteColor];
                MatchName.text=[MatchDetailsDic valueForKey:@"MatchTitle"];
                //-----------Set match Course-------------//
                UILabel *MatchCourse=(UILabel *)[AchivementCell.contentView viewWithTag:7];
                MatchCourse.font=[UIFont fontWithName:MYRIARDPROLIGHT size:15.0f];
                MatchCourse.textColor=[UIColor whiteColor];
                MatchCourse.text=[MatchDetailsDic objectForKey:@"MatchCourse"];
                //------Section 3------//
                
                //TotalTee Lable
                
                UILabel *Totaltee=(UILabel *)[AchivementCell.contentView viewWithTag:9];
                Totaltee.textColor=[UIColor whiteColor];
                Totaltee.font=[UIFont fontWithName:MYRIARDPROLIGHT size:14.0f];
                Totaltee.text=[NSString stringWithFormat:@"%@ Tee'd It",[mutDicActivity objectForKey:@"ActivityLikeCount"]];
                
                //Total Comment Lable
                
                UILabel *TotalteeTextLBL=(UILabel *)[AchivementCell.contentView viewWithTag:10];
                TotalteeTextLBL.textColor=[UIColor whiteColor];
                TotalteeTextLBL.font=[UIFont fontWithName:MYRIARDPROLIGHT size:14.0f];
                
                //total comment lable
                
                UILabel *TotalComment=(UILabel *)[AchivementCell.contentView viewWithTag:12];
                TotalComment.font=[UIFont fontWithName:MYRIARDPROLIGHT size:14.0f];
                TotalComment.textColor=[UIColor whiteColor];
                TotalComment.text=[NSString stringWithFormat:@"%@ Comments",[mutDicActivity objectForKey:@"ActivityCommentCount"]];
                
                //Total comment text lable
                
                UILabel *totalCommentTxtLBL=(UILabel *)[AchivementCell.contentView viewWithTag:11];
                totalCommentTxtLBL.font=[UIFont fontWithName:MYRIARDPROLIGHT size:14.0f];
                totalCommentTxtLBL.textColor=[UIColor whiteColor];
                
                
                //Tee and comment button
                
                IfUserLiked=([[mutDicActivity objectForKey:@"ActivityUserLiked"] integerValue]==0)?FALSE:TRUE;
                IfUserComment=([[mutDicActivity objectForKey:@"ActivityUserCommented"] integerValue]==0)?FALSE:TRUE;
                UIButton *TeeBtn=(UIButton *)[AchivementCell.contentView viewWithTag:14];
                UIButton *CommentBtn=(UIButton *)[AchivementCell.contentView viewWithTag:13];
                if (IfUserLiked)
                {
                    [TeeBtn setBackgroundImage:[UIImage imageNamed:@"teeball"] forState:UIControlStateNormal];
                    [TeeBtn setBackgroundImage:[UIImage imageNamed:@"teeball"] forState:UIControlStateHighlighted];
                    [TeeBtn setBackgroundImage:[UIImage imageNamed:@"teeball"] forState:UIControlStateSelected];
                    
                }
                else
                {
                    [TeeBtn setBackgroundImage:[UIImage imageNamed:@"teeballLite"] forState:UIControlStateNormal];
                    [TeeBtn setBackgroundImage:[UIImage imageNamed:@"teeballLite"] forState:UIControlStateHighlighted];
                    [TeeBtn setBackgroundImage:[UIImage imageNamed:@"teeballLite"] forState:UIControlStateSelected];
                }
                
                if (IfUserComment)
                {
                    [CommentBtn setBackgroundImage:[UIImage imageNamed:@"commentParmitionhave"] forState:UIControlStateNormal];
                    [CommentBtn setBackgroundImage:[UIImage imageNamed:@"commentParmitionhave"] forState:UIControlStateHighlighted];
                    [CommentBtn setBackgroundImage:[UIImage imageNamed:@"commentParmitionhave"] forState:UIControlStateSelected];
                    
                }
                else
                {
                    [CommentBtn setBackgroundImage:[UIImage imageNamed:@"commentparmitionhavenot"] forState:UIControlStateNormal];
                    [CommentBtn setBackgroundImage:[UIImage imageNamed:@"commentparmitionhavenot"] forState:UIControlStateHighlighted];
                    [CommentBtn setBackgroundImage:[UIImage imageNamed:@"commentparmitionhavenot"] forState:UIControlStateSelected];
                }
                
                
                //Like comment allow or not
                
                if ([[mutDicActivity objectForKey:@"ActivityCommentAllow"] integerValue]==1)
                {
                    [CommentBtn addTarget:self action:@selector(CommmentButton:) forControlEvents:UIControlEventTouchUpInside];
                    [CommentBtn setTag:COMMENTTAG+indexPath.row];
                }
                else
                {
                    [CommentBtn setHidden:YES];
                }
                if ([[mutDicActivity objectForKey:@"ActivityLikeAllow"] integerValue]==1)
                {
                    [TeeBtn addTarget:self action:@selector(teebuttonclick:) forControlEvents:UIControlEventTouchUpInside];
                    [TeeBtn setTag:TEETAG+indexPath.row];
                    
                    
                }
                else
                {
                    [TeeBtn setHidden:YES];
                }
            }
            return AchivementCell;
            
        }
        else if ([[mutDicActivity valueForKey:@"ActivityType"] integerValue]==2)
        {
            
            //------------------------Match Eeded activity-----------------//
            
            static NSString *NormalMatch=@"TTTCellforrounddetails";
            
            TTTCellforrounddetails *matchCell=[tableView dequeueReusableCellWithIdentifier:NormalMatch];
            matchCell=nil;
            if (matchCell==nil)
            {
                NSArray *CellNIb=[[NSBundle mainBundle] loadNibNamed:@"TTTcellforrounddetails" owner:self options:nil];
                matchCell=(TTTCellforrounddetails *)[CellNIb objectAtIndex:0];
            }
            //--------------------Section 1 ---------------------//
            
            //--------------  Download user photo And user image Operation  ------ //
            
            CGFloat extraHeight=0.0f;
            UIView *UserphotobackView=(UIView *)[matchCell.contentView viewWithTag:1];
            [self SetroundborderWithborderWidth:2.0f WithColour:[UIColor whiteColor] ForView:UserphotobackView];
            
            UIImageView *ActivityOwnerimageView=(UIImageView *)[matchCell.contentView viewWithTag:2];
            [self SetroundborderWithborderWidth:0.0f WithColour:[UIColor clearColor] ForImageview:ActivityOwnerimageView];
            
            //--------Download Image in image-------//
            
            NSURLRequest *request_img2 = [NSURLRequest requestWithURL:[NSURL URLWithString:[mutDicActivity objectForKey:@"ActivityCreatorImage"]]];
            
            AFImageRequestOperation *operationProfileimage = [AFImageRequestOperation imageRequestOperationWithRequest:request_img2
                                                              
                                                                                                  imageProcessingBlock:nil
                                                              
                                                                                                               success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                                                                                   
                                                                                                                   if(image!=nil)
                                                                                                                       
                                                                                                                   {
                                                                                                                       
                                                                                                                       ActivityOwnerimageView.image=image;
                                                                                                                       
                                                                                                                       
                                                                                                                       
                                                                                                                   }
                                                                                                                   
                                                                                                                   
                                                                                                                   
                                                                                                               }
                                                              
                                                                                                               failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                                                                                                   
                                                                                                                   NSLog(@"Error %@",error);
                                                                                                                   
                                                                                                                   
                                                                                                                   
                                                                                                               }];
            
            [operationProfileimage start];
            
            
            //--------- Send to profile image view -------//
            
            
            
            TapGesture=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(SendToProfileView:)];
            [TapGesture setNumberOfTapsRequired:1];
            [ActivityOwnerimageView setUserInteractionEnabled:YES];
            [ActivityOwnerimageView setTag:[[mutDicActivity objectForKey:@"ActivityCreator"] integerValue]];
            [ActivityOwnerimageView addGestureRecognizer:TapGesture];
            
            //Activity owner name
            
            UILabel *OwnernameLbl=(UILabel *)[matchCell.contentView viewWithTag:3];
            OwnernameLbl.font=[UIFont fontWithName:MYRIARDPROSAMIBOLT size:16.0f];
            OwnernameLbl.text=[mutDicActivity objectForKey:@"ActivityCreatorTitle"];
            
            
            //Activity Titel Lable
            
            UILabel *ActivityTitel=(UILabel *)[matchCell.contentView viewWithTag:4];
            CGRect activityframe=[ActivityTitel frame];
            ActivityTitel.font=[UIFont fontWithName:MYRIARDPROLIGHT size:15.0f];
            ActivityTitel.textColor=[UIColor whiteColor];
            ActivityTitel.textAlignment=NSTextAlignmentLeft;
            
            CGRect ActivityTitelframe = [[mutDicActivity objectForKey:@"ActivityTitle"] boundingRectWithSize:CGSizeMake(230, MAXFLOAT)
                                                                                                     options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                                                                  attributes:@{NSFontAttributeName:[UIFont fontWithName:MYRIARDPROLIGHT size:15.0f]
                                                                                                               }
                                                                                                     context:nil];
            
            extraHeight=(ActivityTitelframe.size.height>21)?ActivityTitelframe.size.height-21:0.0f;
            
            ActivityTitel.text=[mutDicActivity objectForKey:@"ActivityTitle"];
            [ActivityTitel setNumberOfLines:0];
            [ActivityTitel setLineBreakMode:NSLineBreakByWordWrapping];
            activityframe.size.height+=extraHeight;
            [ActivityTitel setFrame:activityframe];
            
            //Activity posted time from privious time
            
            UILabel *PostTimeLBL=(UILabel *)[matchCell.contentView viewWithTag:5];
            PostTimeLBL.textColor=[UIColor whiteColor];
            PostTimeLBL.font=[UIFont fontWithName:MYRIARDPROLIGHT size:13.0f];
            PostTimeLBL.text=[mutDicActivity objectForKey:@"ActivityCreatedDate"];
            
            //-----------------------------------Section 2 --------------------------------//
            //match portion//
            
            UIView *matchMainView=(UIView *)[matchCell.contentView viewWithTag:8888];
            CGRect MatchMainviewFrame=[matchMainView frame];
            
            NSMutableDictionary *Mutdicmatch=[mutDicActivity objectForKey:@"MatchDetails"];
            
            
            NSString *dateAndTime=[Mutdicmatch valueForKey:@"MatchStartDate"];
            
            NSArray *Concatarry=[dateAndTime componentsSeparatedByString:@" "];
            
            
            
            UILabel *dateLable=(UILabel *)[matchMainView viewWithTag:306];
            
            dateLable.font=[UIFont fontWithName:MYRIARDPROLIGHT size:23.0f];
            
            dateLable.textColor=[UIColor whiteColor];
            
            dateLable.textAlignment=NSTextAlignmentCenter;
            
            dateLable.text=[Concatarry objectAtIndex:1];
            
            
            
            //Show month in short like DEC
            
            
            
            UILabel *MonthLable=(UILabel *)[matchMainView viewWithTag:302];
            
            MonthLable.font=[UIFont fontWithName:@"MyriadProLight" size:13.0f];
            
            
            
            MonthLable.textColor=[UIColor whiteColor];
            
            MonthLable.textAlignment=NSTextAlignmentCenter;
            
            MonthLable.text=[[Concatarry objectAtIndex:0] uppercaseString];
            
            
            
            //Set match name
            
            
            
            UILabel *MatchNameName=(UILabel *)[matchMainView viewWithTag:304];
            
            MatchNameName.font=[UIFont fontWithName:@"MyriadPro-Semibold" size:18.0f];
            
            MatchNameName.textColor=[UIColor whiteColor];
            
            MatchNameName.textAlignment=NSTextAlignmentLeft;
            
            MatchNameName.text=[Mutdicmatch valueForKey:@"MatchTitle"];
            
            
            
            //course name
            
            
            
            UILabel *CourseNmae=(UILabel *)[matchMainView viewWithTag:303];
            
            CourseNmae.font=[UIFont fontWithName:@"MyriadProLight" size:16.0f];
            
            CourseNmae.textColor=[UIColor whiteColor];
            
            CourseNmae.textAlignment=NSTextAlignmentLeft;
            CourseNmae.text=[Mutdicmatch valueForKey:@"MatchCourse"];
            
            
            
            
            NSString *BackgroundImageStgring=[Mutdicmatch valueForKey:@"MatchCoverImage"];
            
            
            UIImageView *BackgrounImageViewForimagedownload=(UIImageView *)[matchMainView viewWithTag:9999999];
            
            NSURLRequest *request_img = [NSURLRequest requestWithURL:[NSURL URLWithString:BackgroundImageStgring]];
            
            
            
            AFImageRequestOperation *operationDownloadimage = [AFImageRequestOperation imageRequestOperationWithRequest:request_img
                                                               
                                                                                                   imageProcessingBlock:nil
                                                               
                                                                                                                success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                                                                                    
                                                                                                                    if(image!=nil)
                                                                                                                        
                                                                                                                    {
                                                                                                                        
                                                                                                                        
                                                                                                                        
                                                                                                                        [BackgrounImageViewForimagedownload setImage:image];
                                                                                                                        
                                                                                                                        
                                                                                                                        
                                                                                                                        
                                                                                                                        
                                                                                                                    }
                                                                                                                    
                                                                                                                    
                                                                                                                    
                                                                                                                }
                                                               
                                                                                                                failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                                                                                                    
                                                                                                                    
                                                                                                                    
                                                                                                                    NSLog(@"Error %@",error);
                                                                                                                    
                                                                                                                }];
            
            [operationDownloadimage start];
            
            
            
            //-------------------------------Do Leader bord array---------------------//
            
            
            UIView *LeaderBord1=(UIView *)[matchMainView viewWithTag:33331];
            UIView *LeaderBord2=(UIView *)[matchMainView viewWithTag:33332];
            UIView *LeaderBord3=(UIView *)[matchMainView viewWithTag:33333];
            
            CGRect FrameLeaderBord1=[LeaderBord1 frame];
            CGRect FrameLeaderBord2=[LeaderBord2 frame];
            
            NSMutableArray *Leaderbordarry=[mutDicActivity objectForKey:@"MatchLeaderbord"];
            NSInteger Numbor=[[mutDicActivity objectForKey:@"MatchLeaderbord"] count];
            
            
            if (Numbor==1)
            {
                NSMutableDictionary *Dicleaderbord=[Leaderbordarry objectAtIndex:0];
                UIView *Imagebackview=(UIView *)[LeaderBord1 viewWithTag:700];
                [self SetroundborderWithborderWidth:2.0f WithColour:[UIColor whiteColor] ForView:Imagebackview];
                UIImageView *BordImage=(UIImageView *)[LeaderBord1 viewWithTag:701];
                [self SetroundborderWithborderWidth:0.0f WithColour:[UIColor clearColor] ForImageview:BordImage];
                
                NSURLRequest *request_imgleaderbord = [NSURLRequest requestWithURL:[NSURL URLWithString:[Dicleaderbord valueForKey:@"PlayerImage"]]];
                AFImageRequestOperation *operationLeaderbord = [AFImageRequestOperation imageRequestOperationWithRequest:request_imgleaderbord
                                                                
                                                                                                    imageProcessingBlock:nil
                                                                
                                                                                                                 success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                                                                                     
                                                                                                                     if(image!=nil)
                                                                                                                         
                                                                                                                     {
                                                                                                                         
                                                                                                                         
                                                                                                                         
                                                                                                                         [BordImage setImage:image];
                                                                                                                         
                                                                                                                         
                                                                                                                         
                                                                                                                         
                                                                                                                         
                                                                                                                     }
                                                                                                                     
                                                                                                                     
                                                                                                                     
                                                                                                                 }
                                                                
                                                                                                                 failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                                                                                                     
                                                                                                                     
                                                                                                                     
                                                                                                                     NSLog(@"Error %@",error);
                                                                                                                     
                                                                                                                 }];
                
                [operationLeaderbord start];
                
                UILabel *matchScoreLbl=(UILabel *)[LeaderBord1 viewWithTag:1003];
                matchScoreLbl.font=[UIFont fontWithName:MYRIARDPROLIGHT size:18.0f];
                matchScoreLbl.text=[Dicleaderbord valueForKey:@"MatchNetScore"];
                [LeaderBord1 setFrame:FrameLeaderBord2];
                [LeaderBord2 removeFromSuperview];
                [LeaderBord3 removeFromSuperview];
                
            }
            else if (Numbor==2)
            {
                for (int i=33331; i<33333; i++)
                {
                    UIView *leaderBordview=(UIView *)[matchMainView viewWithTag:i];
                    NSMutableDictionary *Dicleaderbord=[Leaderbordarry objectAtIndex:0];
                    UIView *Imagebackview=(UIView *)[leaderBordview viewWithTag:700];
                    [self SetroundborderWithborderWidth:2.0f WithColour:[UIColor whiteColor] ForView:Imagebackview];
                    UIImageView *BordImage=(UIImageView *)[leaderBordview viewWithTag:701];
                    [self SetroundborderWithborderWidth:0.0f WithColour:[UIColor clearColor] ForImageview:BordImage];
                    
                    NSURLRequest *request_imgleaderbord = [NSURLRequest requestWithURL:[NSURL URLWithString:[Dicleaderbord valueForKey:@"PlayerImage"]]];
                    AFImageRequestOperation *operationLeaderbord = [AFImageRequestOperation imageRequestOperationWithRequest:request_imgleaderbord
                                                                    
                                                                                                        imageProcessingBlock:nil
                                                                    
                                                                                                                     success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                                                                                         
                                                                                                                         if(image!=nil)
                                                                                                                             
                                                                                                                         {
                                                                                                                             
                                                                                                                             
                                                                                                                             
                                                                                                                             [BordImage setImage:image];
                                                                                                                             
                                                                                                                             
                                                                                                                             
                                                                                                                             
                                                                                                                             
                                                                                                                         }
                                                                                                                         
                                                                                                                         
                                                                                                                         
                                                                                                                     }
                                                                    
                                                                                                                     failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                                                                                                         
                                                                                                                         
                                                                                                                         
                                                                                                                         NSLog(@"Error %@",error);
                                                                                                                         
                                                                                                                     }];
                    
                    [operationLeaderbord start];
                    
                    //--------------------Match Score Lable----------------------//
                    
                    
                    UILabel *matchScoreLbl=(UILabel *)[LeaderBord1 viewWithTag:1003];
                    matchScoreLbl.font=[UIFont fontWithName:MYRIARDPROLIGHT size:18.0f];
                    matchScoreLbl.text=[Dicleaderbord valueForKey:@"MatchNetScore"];
                    
                    
                }
                FrameLeaderBord1.origin.x+=40;
                FrameLeaderBord2.origin.x+=40;
                [LeaderBord1 setFrame:FrameLeaderBord1];
                [LeaderBord2 setFrame:FrameLeaderBord2];
                [LeaderBord3 removeFromSuperview];
            }
            else
            {
                for (int i=33333; i<=33333; i++)
                {
                    UIView *leaderBordview=(UIView *)[matchMainView viewWithTag:i];
                    NSMutableDictionary *Dicleaderbord=[Leaderbordarry objectAtIndex:0];
                    UIView *Imagebackview=(UIView *)[leaderBordview viewWithTag:700];
                    [self SetroundborderWithborderWidth:2.0f WithColour:[UIColor whiteColor] ForView:Imagebackview];
                    UIImageView *BordImage=(UIImageView *)[leaderBordview viewWithTag:701];
                    [self SetroundborderWithborderWidth:0.0f WithColour:[UIColor clearColor] ForImageview:BordImage];
                    
                    NSURLRequest *request_imgleaderbord = [NSURLRequest requestWithURL:[NSURL URLWithString:[Dicleaderbord valueForKey:@"PlayerImage"]]];
                    AFImageRequestOperation *operationLeaderbord = [AFImageRequestOperation imageRequestOperationWithRequest:request_imgleaderbord
                                                                    
                                                                                                        imageProcessingBlock:nil
                                                                    
                                                                                                                     success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                                                                                         
                                                                                                                         if(image!=nil)
                                                                                                                             
                                                                                                                         {
                                                                                                                             
                                                                                                                             
                                                                                                                             
                                                                                                                             [BordImage setImage:image];
                                                                                                                             
                                                                                                                             
                                                                                                                             
                                                                                                                             
                                                                                                                             
                                                                                                                         }
                                                                                                                         
                                                                                                                         
                                                                                                                         
                                                                                                                     }
                                                                    
                                                                                                                     failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                                                                                                         
                                                                                                                         
                                                                                                                         
                                                                                                                         NSLog(@"Error %@",error);
                                                                                                                         
                                                                                                                     }];
                    
                    [operationLeaderbord start];
                    
                    
                    //--------------------Match Score Lable----------------------//
                    
                    
                    UILabel *matchScoreLbl=(UILabel *)[LeaderBord1 viewWithTag:1003];
                    matchScoreLbl.font=[UIFont fontWithName:MYRIARDPROLIGHT size:18.0f];
                    matchScoreLbl.text=[Dicleaderbord valueForKey:@"MatchNetScore"];
                    
                    
                }
            }
            
            
            
            //date lable creation For 21( according to design psd)
            
            
            
            
            
            MatchMainviewFrame.origin.y+=extraHeight;
            [matchMainView setFrame:MatchMainviewFrame];
            TapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goestomatchdetils:)];
            [TapGesture setNumberOfTapsRequired:1];
            [matchMainView setUserInteractionEnabled:YES];
            [matchMainView setTag:MATCHDETAILSCELL+indexPath.row];
            [matchMainView addGestureRecognizer:TapGesture];
            //------------------------------Footer View ---------------------//
            //Section three//
            
            UIView *Vfooterview=(UIView *)[matchCell.contentView viewWithTag:8];
            CGRect footerFrame =[Vfooterview frame];
            
            //TotalTee Lable
            
            UILabel *Totaltee=(UILabel *)[matchCell.contentView viewWithTag:9];
            Totaltee.textColor=[UIColor whiteColor];
            Totaltee.font=[UIFont fontWithName:MYRIARDPROLIGHT size:14.0f];
            Totaltee.text=[NSString stringWithFormat:@"%@ Tee'd It",[mutDicActivity objectForKey:@"ActivityLikeCount"]];
            
            
            //Total Comment Lable
            
            UILabel *TotalteeTextLBL=(UILabel *)[matchCell.contentView viewWithTag:10];
            TotalteeTextLBL.textColor=[UIColor whiteColor];
            TotalteeTextLBL.font=[UIFont fontWithName:MYRIARDPROLIGHT size:14.0f];
            
            //total comment lable
            
            UILabel *TotalComment=(UILabel *)[matchCell.contentView viewWithTag:12];
            TotalComment.font=[UIFont fontWithName:MYRIARDPROLIGHT size:14.0f];
            TotalComment.textColor=[UIColor whiteColor];
            TotalComment.text=[NSString stringWithFormat:@"%@ Comments",[mutDicActivity objectForKey:@"ActivityCommentCount"]];
            
            //Total comment text lable
            
            UILabel *totalCommentTxtLBL=(UILabel *)[matchCell.contentView viewWithTag:11];
            totalCommentTxtLBL.font=[UIFont fontWithName:MYRIARDPROLIGHT size:14.0f];
            totalCommentTxtLBL.textColor=[UIColor whiteColor];
            
            
            //Tee and comment button
            
            IfUserLiked=([[mutDicActivity objectForKey:@"ActivityUserLiked"] integerValue]==0)?FALSE:TRUE;
            IfUserComment=([[mutDicActivity objectForKey:@"ActivityUserCommented"] integerValue]==0)?FALSE:TRUE;
            UIButton *TeeBtn=(UIButton *)[matchCell.contentView viewWithTag:14];
            UIButton *CommentBtn=(UIButton *)[matchCell.contentView viewWithTag:13];
            if (IfUserLiked)
            {
                [TeeBtn setBackgroundImage:[UIImage imageNamed:@"teeball"] forState:UIControlStateNormal];
                [TeeBtn setBackgroundImage:[UIImage imageNamed:@"teeball"] forState:UIControlStateHighlighted];
                [TeeBtn setBackgroundImage:[UIImage imageNamed:@"teeball"] forState:UIControlStateSelected];
                
            }
            else
            {
                [TeeBtn setBackgroundImage:[UIImage imageNamed:@"teeballLite"] forState:UIControlStateNormal];
                [TeeBtn setBackgroundImage:[UIImage imageNamed:@"teeballLite"] forState:UIControlStateHighlighted];
                [TeeBtn setBackgroundImage:[UIImage imageNamed:@"teeballLite"] forState:UIControlStateSelected];
            }
            
            if (IfUserComment)
            {
                [CommentBtn setBackgroundImage:[UIImage imageNamed:@"commentParmitionhave"] forState:UIControlStateNormal];
                [CommentBtn setBackgroundImage:[UIImage imageNamed:@"commentParmitionhave"] forState:UIControlStateHighlighted];
                [CommentBtn setBackgroundImage:[UIImage imageNamed:@"commentParmitionhave"] forState:UIControlStateSelected];
                
            }
            else
            {
                [CommentBtn setBackgroundImage:[UIImage imageNamed:@"commentparmitionhavenot"] forState:UIControlStateNormal];
                [CommentBtn setBackgroundImage:[UIImage imageNamed:@"commentparmitionhavenot"] forState:UIControlStateHighlighted];
                [CommentBtn setBackgroundImage:[UIImage imageNamed:@"commentparmitionhavenot"] forState:UIControlStateSelected];
            }
            
            
            //Like comment allow or not
            
            if ([[mutDicActivity objectForKey:@"ActivityCommentAllow"] integerValue]==1)
            {
                [CommentBtn addTarget:self action:@selector(CommmentButton:) forControlEvents:UIControlEventTouchUpInside];
                [CommentBtn setTag:COMMENTTAG+indexPath.row];
            }
            if ([[mutDicActivity objectForKey:@"ActivityLikeAllow"] integerValue]==1)
            {
                [TeeBtn addTarget:self action:@selector(teebuttonclick:) forControlEvents:UIControlEventTouchUpInside];
                [TeeBtn setTag:TEETAG+indexPath.row];
                
            }
            footerFrame.origin.y+=extraHeight;
            [Vfooterview setFrame:footerFrame];
            UIView *MainBackview=(UIView *)[matchCell.contentView viewWithTag:999];
            CGRect Frame=[MainBackview frame];
            Frame.size.height+=extraHeight;
            [MainBackview setFrame:Frame];
            return matchCell;
            
            
        }
        else if ([[mutDicActivity valueForKey:@"ActivityType"] integerValue]==3)
        {
            //-------------------------Normal Event Post match post------------------------------------//
            
            
            TTTCellFormatchActivity *matchCell=[tableView dequeueReusableCellWithIdentifier:@"TTTCellFormatchActivity"];
            matchCell=nil;
            if (matchCell==nil)
            {
                NSArray *CellNIb=[[NSBundle mainBundle] loadNibNamed:@"TTTCellFormatchActivity" owner:self options:nil];
                matchCell=(TTTCellFormatchActivity *)[CellNIb objectAtIndex:0];
            }
            //--------------------Section 1 ---------------------//
            
            //----------  Download user photo And user image Operation  ------ //
            
            CGFloat extraHeight=0.0f;
            UIView *UserphotobackView=(UIView *)[matchCell.contentView viewWithTag:1];
            [self SetroundborderWithborderWidth:2.0f WithColour:[UIColor whiteColor] ForView:UserphotobackView];
            
            UIImageView *ActivityOwnerimageView=(UIImageView *)[matchCell.contentView viewWithTag:2];
            [self SetroundborderWithborderWidth:0.0f WithColour:[UIColor clearColor] ForImageview:ActivityOwnerimageView];
            
            //--------Download Image in image-------//
            
            NSURLRequest *request_img2 = [NSURLRequest requestWithURL:[NSURL URLWithString:[mutDicActivity objectForKey:@"ActivityCreatorImage"]]];
            
            AFImageRequestOperation *operationProfileimage = [AFImageRequestOperation imageRequestOperationWithRequest:request_img2
                                                              
                                                                                                  imageProcessingBlock:nil
                                                              
                                                                                                               success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                                                                                   
                                                                                                                   if(image!=nil)
                                                                                                                       
                                                                                                                   {
                                                                                                                       
                                                                                                                       ActivityOwnerimageView.image=image;
                                                                                                                       
                                                                                                                       
                                                                                                                       
                                                                                                                   }
                                                                                                                   
                                                                                                                   
                                                                                                                   
                                                                                                               }
                                                              
                                                                                                               failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                                                                                                   
                                                                                                                   NSLog(@"Error %@",error);
                                                                                                                   
                                                                                                                   
                                                                                                                   
                                                                                                               }];
            
            [operationProfileimage start];
            
            
            //--------- Send to profile image view -------//
            
            
            
            TapGesture=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(SendToProfileView:)];
            [TapGesture setNumberOfTapsRequired:1];
            [ActivityOwnerimageView setUserInteractionEnabled:YES];
            [ActivityOwnerimageView setTag:[[mutDicActivity objectForKey:@"ActivityCreator"] integerValue]];
            [ActivityOwnerimageView addGestureRecognizer:TapGesture];
            
            //Activity owner name
            
            UILabel *OwnernameLbl=(UILabel *)[matchCell.contentView viewWithTag:3];
            OwnernameLbl.font=[UIFont fontWithName:MYRIARDPROSAMIBOLT size:16.0f];
            OwnernameLbl.text=[mutDicActivity objectForKey:@"ActivityCreatorTitle"];
            
            
            //Activity Titel Lable
            
            UILabel *ActivityTitel=(UILabel *)[matchCell.contentView viewWithTag:4];
            CGRect activityframe=[ActivityTitel frame];
            ActivityTitel.font=[UIFont fontWithName:MYRIARDPROLIGHT size:15.0f];
            ActivityTitel.textColor=[UIColor whiteColor];
            ActivityTitel.textAlignment=NSTextAlignmentLeft;
            
            CGRect ActivityTitelframe = [[mutDicActivity objectForKey:@"ActivityTitle"] boundingRectWithSize:CGSizeMake(230, MAXFLOAT)
                                                                                                     options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                                                                  attributes:@{NSFontAttributeName:[UIFont fontWithName:MYRIARDPROLIGHT size:15.0f]
                                                                                                               }
                                                                                                     context:nil];
            
            extraHeight=(ActivityTitelframe.size.height>21)?ActivityTitelframe.size.height-21:0.0f;
            
            ActivityTitel.text=[mutDicActivity objectForKey:@"ActivityTitle"];
            [ActivityTitel setNumberOfLines:0];
            [ActivityTitel setLineBreakMode:NSLineBreakByWordWrapping];
            activityframe.size.height+=extraHeight;
            [ActivityTitel setFrame:activityframe];
            
            //Activity posted time from privious time
            
            UILabel *PostTimeLBL=(UILabel *)[matchCell.contentView viewWithTag:5];
            PostTimeLBL.textColor=[UIColor whiteColor];
            PostTimeLBL.font=[UIFont fontWithName:MYRIARDPROLIGHT size:13.0f];
            PostTimeLBL.text=[mutDicActivity objectForKey:@"ActivityCreatedDate"];
            
            //-----------------------------------Section 2 --------------------------------//
            //match portion//
            
            UIView *matchMainView=(UIView *)[matchCell.contentView viewWithTag:109];
            TapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goestomatchdetils:)];
            [TapGesture setNumberOfTapsRequired:1];
            [matchMainView setUserInteractionEnabled:YES];
            [matchMainView setTag:MATCHDETAILSCELL+indexPath.row];
            [matchMainView addGestureRecognizer:TapGesture];
            
            CGRect MatchMainviewFrame=[matchMainView frame];
            
            NSMutableDictionary *Mutdicmatch=[mutDicActivity objectForKey:@"MatchDetails"];
            
            NSString *BackgroundImageStgring=[Mutdicmatch valueForKey:@"MatchCoverImage"];
            
            
            
            UIImageView *BackgrounImage=(UIImageView *)[matchCell.contentView viewWithTag:100];
            
            NSURLRequest *request_img = [NSURLRequest requestWithURL:[NSURL URLWithString:BackgroundImageStgring]];
            
            
            
            AFImageRequestOperation *operation = [AFImageRequestOperation imageRequestOperationWithRequest:request_img
                                                  
                                                                                      imageProcessingBlock:nil
                                                  
                                                                                                   success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                                                                       
                                                                                                       if(image!=nil)
                                                                                                           
                                                                                                       {
                                                                                                           
                                                                                                           
                                                                                                           
                                                                                                           [BackgrounImage setImage:image];
                                                                                                           
                                                                                                           
                                                                                                           
                                                                                                           
                                                                                                           
                                                                                                       }
                                                                                                       
                                                                                                       
                                                                                                       
                                                                                                   }
                                                  
                                                                                                   failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                                                                                       
                                                                                                       
                                                                                                       
                                                                                                       NSLog(@"Error %@",error);
                                                                                                       
                                                                                                   }];
            
            [operation start];
            
            
            
            
            
            
            
            
            
            
            
            
            
            //date lable creation For 21( according to design psd)
            
            
            
            NSString *dateAndTime=[Mutdicmatch valueForKey:@"MatchStartDate"];
            
            NSArray *Concatarry=[dateAndTime componentsSeparatedByString:@" "];
            
            
            
            UILabel *dateLable=(UILabel *)[matchCell.contentView viewWithTag:102];
            
            dateLable.font=[UIFont fontWithName:@"MyriadProLight" size:23.0f];
            
            dateLable.textColor=[UIColor whiteColor];
            
            dateLable.textAlignment=NSTextAlignmentCenter;
            
            dateLable.text=[Concatarry objectAtIndex:1];
            
            
            
            //Show month in short like DEC
            
            
            
            UILabel *MonthLable=(UILabel *)[matchCell.contentView viewWithTag:103];
            
            MonthLable.font=[UIFont fontWithName:@"MyriadProLight" size:13.0f];
            
            
            
            MonthLable.textColor=[UIColor whiteColor];
            
            MonthLable.textAlignment=NSTextAlignmentCenter;
            
            MonthLable.text=[[Concatarry objectAtIndex:0] uppercaseString];
            
            
            
            //Set course name
            
            
            
            UILabel *MatchNameName=(UILabel *)[matchCell.contentView viewWithTag:104];
            MatchNameName.font=[UIFont fontWithName:@"MyriadPro-Semibold" size:18.0f];
            
            MatchNameName.textColor=[UIColor whiteColor];
            
            MatchNameName.textAlignment=NSTextAlignmentLeft;
            
            MatchNameName.text=[Mutdicmatch valueForKey:@"MatchTitle"];
            
            
            //course name
            
            
            
            UILabel *CourseNmae=(UILabel *)[matchCell.contentView viewWithTag:105];
            
            CourseNmae.font=[UIFont fontWithName:@"MyriadProLight" size:16.0f];
            
            CourseNmae.layer.opacity=2.0f;
            
            CourseNmae.textColor=[UIColor whiteColor];
            
            CourseNmae.textAlignment=NSTextAlignmentLeft;
            
            NSAttributedString *attributedText =
            
            [[NSAttributedString alloc]
             
             initWithString:[self RemoveNullandreplaceWithSpace:[Mutdicmatch valueForKey:@"MatchCourse"]]
             
             attributes:@
             
             {
                 
             NSFontAttributeName:[UIFont fontWithName:MYRIARDPROLIGHT size:15.0f]
                 
             }];
            
            
            
            CGRect rect = [attributedText boundingRectWithSize:(CGSize){300, 21}
                           
                                                       options:NSStringDrawingUsesLineFragmentOrigin
                           
                                                       context:nil];
            
            CGSize size = rect.size;
            
            CourseNmae.frame=CGRectMake(CourseNmae.frame.origin.x, CourseNmae.frame.origin.y, size.width+10, 21);
            
            CourseNmae.text=[self RemoveNullandreplaceWithSpace:[Mutdicmatch valueForKey:@"MatchCourse"]];
            
            
            
            UIView *TeeBoxview=(UIView *)[matchCell.contentView viewWithTag:100000];
            CGRect TeeBoxframe=[TeeBoxview frame];
            
            [self  SetroundborderWithborderWidth:0.0f WithColour:[UIColor clearColor] ForView:TeeBoxview];
            [TeeBoxview setBackgroundColor:[TTTGlobalMethods colorFromHexString:[Mutdicmatch valueForKey:@"MatchTeeboxColor"]]];
            TeeBoxframe.origin.x=CourseNmae.frame.origin.x+size.width+15;
            [TeeBoxview setFrame:TeeBoxframe];
            
            //-----------------------Big Time lable----------------------------------//
            
            UILabel *bigTimelable=(UILabel *)[matchCell.contentView viewWithTag:106];
            
            bigTimelable.textAlignment=NSTextAlignmentLeft;
            
            bigTimelable.font=[UIFont fontWithName:SEGIOUI size:28.0f];
            
            bigTimelable.textColor=[UIColor whiteColor];
            
            [bigTimelable setText:[Mutdicmatch valueForKey:@"MatchStartTime"]];
            
            
            
            
            
            //join button
            
            UIButton *joinButton=(UIButton *)[matchCell.contentView viewWithTag:107];
            
            [joinButton addTarget:self action:@selector(gotonext) forControlEvents:UIControlEventTouchUpInside];
            
            
            
            if ([[Mutdicmatch valueForKey:@"MatchJoinStatus"] integerValue]==0)
            {
                
                joinButton.hidden=YES;
                
            }
            MatchMainviewFrame.origin.y+=extraHeight;
            [matchMainView setFrame:MatchMainviewFrame];
            
            
            //------------------------------Footer View ---------------------//
            //Section three//
            
            UIView *Vfooterview=(UIView *)[matchCell.contentView viewWithTag:8];
            CGRect footerFrame =[Vfooterview frame];
            
            //TotalTee Lable
            
            UILabel *Totaltee=(UILabel *)[matchCell.contentView viewWithTag:9];
            Totaltee.textColor=[UIColor whiteColor];
            Totaltee.font=[UIFont fontWithName:MYRIARDPROLIGHT size:14.0f];
            Totaltee.text=[NSString stringWithFormat:@"%@ Tee'd It",[mutDicActivity objectForKey:@"ActivityLikeCount"]];
            
            //Total Comment Lable
            
            UILabel *TotalteeTextLBL=(UILabel *)[matchCell.contentView viewWithTag:10];
            TotalteeTextLBL.textColor=[UIColor whiteColor];
            TotalteeTextLBL.font=[UIFont fontWithName:MYRIARDPROLIGHT size:14.0f];
            
            //total comment lable
            
            UILabel *TotalComment=(UILabel *)[matchCell.contentView viewWithTag:12];
            TotalComment.font=[UIFont fontWithName:MYRIARDPROLIGHT size:14.0f];
            TotalComment.textColor=[UIColor whiteColor];
            TotalComment.text=[NSString stringWithFormat:@"%@ Comments",[mutDicActivity objectForKey:@"ActivityCommentCount"] ];
            
            //Total comment text lable
            
            UILabel *totalCommentTxtLBL=(UILabel *)[matchCell.contentView viewWithTag:11];
            totalCommentTxtLBL.font=[UIFont fontWithName:MYRIARDPROLIGHT size:14.0f];
            totalCommentTxtLBL.textColor=[UIColor whiteColor];
            
            
            //Tee and comment button
            
            IfUserLiked=([[mutDicActivity objectForKey:@"ActivityUserLiked"] integerValue]==0)?FALSE:TRUE;
            IfUserComment=([[mutDicActivity objectForKey:@"ActivityUserCommented"] integerValue]==0)?FALSE:TRUE;
            UIButton *TeeBtn=(UIButton *)[matchCell.contentView viewWithTag:14];
            UIButton *CommentBtn=(UIButton *)[matchCell.contentView viewWithTag:13];
            if (IfUserLiked)
            {
                [TeeBtn setBackgroundImage:[UIImage imageNamed:@"teeball"] forState:UIControlStateNormal];
                [TeeBtn setBackgroundImage:[UIImage imageNamed:@"teeball"] forState:UIControlStateHighlighted];
                [TeeBtn setBackgroundImage:[UIImage imageNamed:@"teeball"] forState:UIControlStateSelected];
                
            }
            else
            {
                [TeeBtn setBackgroundImage:[UIImage imageNamed:@"teeballLite"] forState:UIControlStateNormal];
                [TeeBtn setBackgroundImage:[UIImage imageNamed:@"teeballLite"] forState:UIControlStateHighlighted];
                [TeeBtn setBackgroundImage:[UIImage imageNamed:@"teeballLite"] forState:UIControlStateSelected];
            }
            
            if (IfUserComment)
            {
                [CommentBtn setBackgroundImage:[UIImage imageNamed:@"commentParmitionhave"] forState:UIControlStateNormal];
                [CommentBtn setBackgroundImage:[UIImage imageNamed:@"commentParmitionhave"] forState:UIControlStateHighlighted];
                [CommentBtn setBackgroundImage:[UIImage imageNamed:@"commentParmitionhave"] forState:UIControlStateSelected];
                
            }
            else
            {
                [CommentBtn setBackgroundImage:[UIImage imageNamed:@"commentparmitionhavenot"] forState:UIControlStateNormal];
                [CommentBtn setBackgroundImage:[UIImage imageNamed:@"commentparmitionhavenot"] forState:UIControlStateHighlighted];
                [CommentBtn setBackgroundImage:[UIImage imageNamed:@"commentparmitionhavenot"] forState:UIControlStateSelected];
            }
            
            
            
            
            //Like comment allow or not
            
            if ([[mutDicActivity objectForKey:@"ActivityCommentAllow"] integerValue]==1)
            {
                [CommentBtn addTarget:self action:@selector(CommmentButton:) forControlEvents:UIControlEventTouchUpInside];
                [CommentBtn setTag:COMMENTTAG+indexPath.row];
            }
            else
            {
                [CommentBtn setHidden:YES];
            }
            if ([[mutDicActivity objectForKey:@"ActivityLikeAllow"] integerValue]==1)
            {
                [TeeBtn addTarget:self action:@selector(teebuttonclick:) forControlEvents:UIControlEventTouchUpInside];
                [TeeBtn setTag:TEETAG+indexPath.row];
                
            }
            else
            {
                [TeeBtn setHidden:YES];
            }
            footerFrame.origin.y+=extraHeight;
            [Vfooterview setFrame:footerFrame];
            UIView *Backview=(UIView *)[matchCell.contentView viewWithTag:999];
            CGRect Backframe=[Backview frame];
            Backframe.size.height+=extraHeight;
            [Backview setFrame:Backframe];
            
            return matchCell;
            
            
        }
        
        else if ([[mutDicActivity valueForKey:@"ActivityType"] integerValue]==4)
        {
            
            //--------------------Activity Accept friend Request----------------//
            
            static NSString *friendDeque=@"TTTCellforAcceptFriendrequest";
            TTTCellforAcceptFriendrequest *FriendCell=(TTTCellforAcceptFriendrequest *)[tableView dequeueReusableCellWithIdentifier:friendDeque];
            
            if (FriendCell==nil)
            {
                NSArray *CellNib=[[NSBundle mainBundle] loadNibNamed:@"TTTCellforAcceptFriendrequest" owner:self options:nil];
                FriendCell=(TTTCellforAcceptFriendrequest *)[CellNib objectAtIndex:0];
            }
            FriendCell.backgroundColor=[UIColor clearColor];
            UIView *CreaterbackView=(UIView *)[FriendCell.contentView viewWithTag:1];
            UIImageView *CreaterImageView=(UIImageView *)[FriendCell.contentView viewWithTag:2];
            
            UIView *TargetbackView=(UIView *)[FriendCell.contentView viewWithTag:3];
            UIImageView *TargetImageView=(UIImageView *)[FriendCell.contentView viewWithTag:4];
            
            [self SetroundborderWithborderWidth:0.0f WithColour:[UIColor clearColor] ForImageview:CreaterImageView];
            [self SetroundborderWithborderWidth:0.0f WithColour:[UIColor clearColor] ForImageview:TargetImageView];
            
            [self SetroundborderWithborderWidth:2.0f WithColour:[UIColor whiteColor] ForView:CreaterbackView];
            [self SetroundborderWithborderWidth:2.0f WithColour:[UIColor whiteColor] ForView:TargetbackView];
            
            NSURLRequest *request_img2 = [NSURLRequest requestWithURL:[NSURL URLWithString:[mutDicActivity objectForKey:@"ActivityCreatorImage"]]];
            
            //Down load creater image
            
            AFImageRequestOperation *operationProfileimage = [AFImageRequestOperation imageRequestOperationWithRequest:request_img2
                                                              
                                                                                                  imageProcessingBlock:nil
                                                              
                                                                                                               success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                                                                                   
                                                                                                                   if(image!=nil)
                                                                                                                       
                                                                                                                   {
                                                                                                                       
                                                                                                                       CreaterImageView.image=image;
                                                                                                                       
                                                                                                                       
                                                                                                                       
                                                                                                                   }
                                                                                                                   
                                                                                                                   
                                                                                                                   
                                                                                                               }
                                                              
                                                                                                               failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                                                                                                   
                                                                                                                   NSLog(@"Error %@",error);
                                                                                                                   
                                                                                                                   
                                                                                                                   
                                                                                                               }];
            
            [operationProfileimage start];
            
            
            //------------------- download Terget image -------------------//
            
            
            NSURLRequest *request_img3 = [NSURLRequest requestWithURL:[NSURL URLWithString:[mutDicActivity objectForKey:@"ActivityTargetImage"]]];
            
            AFImageRequestOperation *operationTergetimage = [AFImageRequestOperation imageRequestOperationWithRequest:request_img3
                                                             
                                                                                                 imageProcessingBlock:nil
                                                             
                                                                                                              success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                                                                                  
                                                                                                                  if(image!=nil)
                                                                                                                      
                                                                                                                  {
                                                                                                                      
                                                                                                                      TargetImageView.image=image;
                                                                                                                      
                                                                                                                      
                                                                                                                      
                                                                                                                  }
                                                                                                                  
                                                                                                                  
                                                                                                                  
                                                                                                              }
                                                             
                                                                                                              failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                                                                                                  
                                                                                                                  NSLog(@"Error %@",error);
                                                                                                                  
                                                                                                                  
                                                                                                                  
                                                                                                              }];
            
            [operationTergetimage start];
            
            
            //--------------------- Sending to profile page -----------------//
            
            
            TapGesture=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(SendToProfileView:)];
            [TapGesture setNumberOfTapsRequired:1];
            [CreaterImageView setUserInteractionEnabled:YES];
            [CreaterImageView setTag:[[mutDicActivity objectForKey:@"ActivityCreator"] integerValue]];
            [TargetImageView setTag:[[mutDicActivity objectForKey:@"ActivityTarget"] integerValue]];
            [TargetImageView setUserInteractionEnabled:YES];
            [CreaterImageView addGestureRecognizer:TapGesture];
            [TargetImageView addGestureRecognizer:TapGesture];
            
            NSAttributedString *matchAttribute=[self getAttributedString:[mutDicActivity valueForKey:@"ActivityTitle"] HightLightString:[mutDicActivity valueForKey:@"ActivityCreatorTitle"] HightLighted2:[mutDicActivity valueForKey:@"ActivityTargetTitle"] withFontSize:15.0f];
            
            UILabel *TitelLbl=(UILabel *)[FriendCell.contentView viewWithTag:5];
            TitelLbl.textColor=[UIColor whiteColor];
            [TitelLbl setAttributedText:matchAttribute];
            return FriendCell;
            
        }
            
            
            
            
        else if ([[mutDicActivity valueForKey:@"ActivityType"] integerValue]==5)
        {
            
            //-------------- Activity Type photo ----------------//
            static NSString *Activitypost =@"TTTCellForphotoActive";
            
            TTTCellForphotoActivity *PhotoActivity=(TTTCellForphotoActivity *)[tableView dequeueReusableCellWithIdentifier:Activitypost];
            PhotoActivity=nil;
            if (PhotoActivity==nil)
            {
                NSArray *CellNib=[[NSBundle mainBundle] loadNibNamed:@"TTTCellForphotoActive" owner:self options:nil];
                PhotoActivity=(TTTCellForphotoActivity *)[CellNib objectAtIndex:0];
                
            }
            float ImgRatio=[[mutDicActivity objectForKey:@"Photowidth"] floatValue]/[[mutDicActivity objectForKey:@"Photoheight"] floatValue];
            float NewImgHeight=200.0f/ImgRatio;
            float ExtraHeightForImage=(NewImgHeight > 180.0f)?NewImgHeight-180.0f:0.0f;
            
            
            [PhotoActivity setBackgroundColor:[UIColor clearColor]];
            // Download user photo And user image Operation
            
            CGFloat extraHeight=0.0f;
            UIView *UserphotobackView=(UIView *)[PhotoActivity.contentView viewWithTag:1];
            [self SetroundborderWithborderWidth:2.0f WithColour:[UIColor whiteColor] ForView:UserphotobackView];
            
            UIImageView *ActivityOwnerimageView=(UIImageView *)[PhotoActivity.contentView viewWithTag:2];
            [self SetroundborderWithborderWidth:0.0f WithColour:[UIColor clearColor] ForImageview:ActivityOwnerimageView];
            
            //Download Image in image
            
            NSURLRequest *request_img2 = [NSURLRequest requestWithURL:[NSURL URLWithString:[mutDicActivity objectForKey:@"ActivityCreatorImage"]]];
            
            AFImageRequestOperation *operationProfileimage = [AFImageRequestOperation imageRequestOperationWithRequest:request_img2
                                                              
                                                                                                  imageProcessingBlock:nil
                                                              
                                                                                                               success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                                                                                   
                                                                                                                   if(image!=nil)
                                                                                                                       
                                                                                                                   {
                                                                                                                       
                                                                                                                       ActivityOwnerimageView.image=image;
                                                                                                                       
                                                                                                                       
                                                                                                                       
                                                                                                                   }
                                                                                                                   
                                                                                                                   
                                                                                                                   
                                                                                                               }
                                                              
                                                                                                               failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                                                                                                   
                                                                                                                   NSLog(@"Error %@",error);
                                                                                                                   
                                                                                                                   
                                                                                                                   
                                                                                                               }];
            
            [operationProfileimage start];
            //******  Send to profile image view  *****//
            
            TapGesture=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(SendToProfileView:)];
            [TapGesture setNumberOfTapsRequired:1];
            [ActivityOwnerimageView setUserInteractionEnabled:YES];
            [ActivityOwnerimageView setTag:[[mutDicActivity objectForKey:@"ActivityCreator"] integerValue]];
            [ActivityOwnerimageView addGestureRecognizer:TapGesture];
            
            //Activity owner name
            
            UILabel *OwnernameLbl=(UILabel *)[PhotoActivity.contentView viewWithTag:3];
            OwnernameLbl.font=[UIFont fontWithName:MYRIARDPROSAMIBOLT size:16.0f];
            OwnernameLbl.text=[mutDicActivity objectForKey:@"ActivityCreatorTitle"];
            
            
            //Activity Titel Lable
            
            UILabel *ActivityTitel=(UILabel *)[PhotoActivity.contentView viewWithTag:4];
            CGRect activityframe=[ActivityTitel frame];
            ActivityTitel.font=[UIFont fontWithName:MYRIARDPROLIGHT size:15.0f];
            ActivityTitel.textColor=[UIColor whiteColor];
            ActivityTitel.textAlignment=NSTextAlignmentLeft;
            
            CGRect ActivityTitelframe = [[mutDicActivity objectForKey:@"ActivityTitle"] boundingRectWithSize:CGSizeMake(230, MAXFLOAT)
                                                                                                     options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                                                                  attributes:@{NSFontAttributeName:[UIFont fontWithName:MYRIARDPROLIGHT size:15.0f]
                                                                                                               }
                                                                                                     context:nil];
            
            extraHeight=(ActivityTitelframe.size.height>16)?ActivityTitelframe.size.height-16:0.0f;
            
            ActivityTitel.text=[mutDicActivity objectForKey:@"ActivityTitle"];
            [ActivityTitel setNumberOfLines:0];
            [ActivityTitel setLineBreakMode:NSLineBreakByWordWrapping];
            activityframe.size.height+=extraHeight;
            [ActivityTitel setFrame:activityframe];
            
            //Activity posted time from privious time
            
            UILabel *PostTimeLBL=(UILabel *)[PhotoActivity.contentView viewWithTag:5];
            PostTimeLBL.textColor=[UIColor whiteColor];
            PostTimeLBL.font=[UIFont fontWithName:MYRIARDPROLIGHT size:13.0f];
            PostTimeLBL.text=[mutDicActivity objectForKey:@"ActivityCreatedDate"];
            
            
            // Location View Show or hide
            
            UIView *locationView=(UIView *)[PhotoActivity.contentView viewWithTag:400];
            CGRect locationframe=[locationView frame];
            locationframe.origin.y+=extraHeight;
            
            if (![self RemoveNullandreplaceWithSpace:[mutDicActivity objectForKey:@"Photolocation"]].length>0)
            {
                locationView.hidden=YES;
            }
            else
            {
                UILabel *LocationLBl=(UILabel *)[PhotoActivity.contentView viewWithTag:401];
                LocationLBl.font=[UIFont fontWithName:MYRIARDPROLIGHT size:11.0f];
                LocationLBl.textColor=[UIColor whiteColor];
                LocationLBl.text=[mutDicActivity objectForKey:@"Photolocation"];
                [locationView setFrame:locationframe];
            }
            
            
            // MainActivity Content frame
            //Downlod Photo to which the comment is posted main photo for photo activity
            
            UIView *ImageBackview=(UIView *)[PhotoActivity.contentView viewWithTag:9804197];
            ImageBackview.hidden=YES;
            CGRect Backmainframe=[ImageBackview frame];
            
            UIImageView *PhotoImage=(UIImageView *)[PhotoActivity.contentView viewWithTag:403];
            
            
            TapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(SenToimagedetailspage:)];
            [TapGesture setNumberOfTapsRequired:1];
            [PhotoImage setUserInteractionEnabled:YES];
            [PhotoImage setTag:PHOTOCELL+indexPath.row];
            [PhotoImage addGestureRecognizer:TapGesture];
            
            CGRect PhotoTagFrame=[PhotoImage frame];
            NSURLRequest *MainImageDownload = [NSURLRequest requestWithURL:[NSURL URLWithString:[mutDicActivity objectForKey:@"Photourl"]]];
            //Extra height for caption
            CGFloat ExtreaContent=0.0f;
            if ([[mutDicActivity objectForKey:@"PhotoCaption"] length]>0)
            {
                
                UILabel *Caption2Lbl=(UILabel *)[PhotoActivity.contentView viewWithTag:98382];
                CGRect captionFrame=[Caption2Lbl frame];
                Caption2Lbl.font=[UIFont fontWithName:MYRIARDPROLIGHT size:15.0f];
                
                
                CGRect ActivityContentTextframe2 = [[mutDicActivity objectForKey:@"PhotoCaption"] boundingRectWithSize:CGSizeMake(292, MAXFLOAT)
                                                                                                               options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                                                                            attributes:@{NSFontAttributeName:[UIFont fontWithName:MYRIARDPROLIGHT size:15.0f]
                                                                                                                         }
                                                                                                               context:nil];
                
                ExtreaContent=(ActivityContentTextframe2.size.height>21.0f)?ActivityContentTextframe2.size.height:21.0f;
                captionFrame.size.height=ExtreaContent;
                Caption2Lbl.text=[mutDicActivity objectForKey:@"PhotoCaption"];
                Caption2Lbl.numberOfLines=0.0f;
                Caption2Lbl.lineBreakMode=NSLineBreakByCharWrapping;
                [Caption2Lbl setFrame:captionFrame];
                
            }
            else
            {
                ExtreaContent=0.0f;
            }
            
            
            UILabel *ActivityContent=(UILabel *)[PhotoActivity.contentView viewWithTag:1111111];
            ActivityContent.font=[UIFont fontWithName:MYRIARDPROLIGHT size:15.0f];
            ActivityContent.textColor=[UIColor whiteColor];
            CGFloat ExtraHightforcontent=0.0f;
            
            CGRect ActivityContentframe=[ActivityContent frame];
            
            
            CGRect ActivityContentTextframe = [[mutDicActivity objectForKey:@"PhotoComment"] boundingRectWithSize:CGSizeMake(292, MAXFLOAT)
                                                                                                          options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                                                                       attributes:@{NSFontAttributeName:[UIFont fontWithName:MYRIARDPROLIGHT size:15.0f]
                                                                                                                    }
                                                                                                          context:nil];
            
            ExtraHightforcontent=(ActivityContentTextframe.size.height>21.0f)?ActivityContentTextframe.size.height-21:0.0f;
            
            
            //Set frame to the activity content.........
            ActivityContentframe.origin.y+=extraHeight+ExtreaContent+ExtraHeightForImage;
            ActivityContentframe.size.height+=ExtraHightforcontent;
            [ActivityContent setText:[mutDicActivity objectForKey:@"PhotoComment"]];
            [ActivityContent setLineBreakMode:NSLineBreakByWordWrapping];
            [ActivityContent setNumberOfLines:0];
            
            [ActivityContent setFrame:ActivityContentframe];
            
            
            
            
            //Downloading image
            
            AFImageRequestOperation *mainImageDownload = [AFImageRequestOperation imageRequestOperationWithRequest:MainImageDownload
                                                          
                                                                                              imageProcessingBlock:nil
                                                          
                                                                                                           success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                                                                               
                                                                                                               if(image!=nil)
                                                                                                                   
                                                                                                               {
                                                                                                                   
                                                                                                                   PhotoImage.image=image;
                                                                                                                   
                                                                                                                   
                                                                                                                   
                                                                                                               }
                                                                                                               
                                                                                                               
                                                                                                               
                                                                                                           }
                                                          
                                                                                                           failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                                                                                               
                                                                                                               NSLog(@"Error %@",error);
                                                                                                               
                                                                                                               
                                                                                                               
                                                                                                           }];
            
            [mainImageDownload start];
            
            PhotoTagFrame.origin.y+=extraHeight+ExtreaContent;
            PhotoTagFrame.size.height+=ExtraHeightForImage;
            [PhotoImage setFrame:PhotoTagFrame];
            
            Backmainframe.origin.y+=extraHeight+ExtreaContent+ExtraHeightForImage;
            [ImageBackview setFrame:Backmainframe];
            
            //---------------------------Like commnt area-------------------------//
            //----Footer Section----//
            
            //Footer portion like comment area and total comment
            
            UIView *Vfooterview=(UIView *)[PhotoActivity.contentView viewWithTag:8];
            CGRect footerFrame =[Vfooterview frame];
            
            //TotalTee Lable
            
            UILabel *Totaltee=(UILabel *)[PhotoActivity.contentView viewWithTag:9];
            Totaltee.textColor=[UIColor whiteColor];
            Totaltee.font=[UIFont fontWithName:MYRIARDPROLIGHT size:14.0f];
            Totaltee.text=[NSString stringWithFormat:@"%@ Tee'd It",[mutDicActivity objectForKey:@"ActivityLikeCount"]];
            
            //Total Comment Lable
            
            UILabel *TotalteeTextLBL=(UILabel *)[PhotoActivity.contentView viewWithTag:10];
            TotalteeTextLBL.textColor=[UIColor whiteColor];
            TotalteeTextLBL.font=[UIFont fontWithName:MYRIARDPROLIGHT size:14.0f];
            
            //total comment lable
            
            UILabel *TotalComment=(UILabel *)[PhotoActivity.contentView viewWithTag:12];
            TotalComment.font=[UIFont fontWithName:MYRIARDPROLIGHT size:14.0f];
            TotalComment.textColor=[UIColor whiteColor];
            TotalComment.text=[NSString stringWithFormat:@"%@ Comments",[mutDicActivity objectForKey:@"ActivityCommentCount"]];
            
            //Total comment text lable
            
            UILabel *totalCommentTxtLBL=(UILabel *)[PhotoActivity.contentView viewWithTag:11];
            totalCommentTxtLBL.font=[UIFont fontWithName:MYRIARDPROLIGHT size:14.0f];
            totalCommentTxtLBL.textColor=[UIColor whiteColor];
            
            
            //Tee and comment button
            
            IfUserLiked=([[mutDicActivity objectForKey:@"ActivityUserLiked"] integerValue]==0)?FALSE:TRUE;
            IfUserComment=([[mutDicActivity objectForKey:@"ActivityUserCommented"] integerValue]==0)?FALSE:TRUE;
            UIButton *TeeBtn=(UIButton *)[PhotoActivity.contentView viewWithTag:14];
            UIButton *CommentBtn=(UIButton *)[PhotoActivity.contentView viewWithTag:13];
            if (IfUserLiked)
            {
                [TeeBtn setBackgroundImage:[UIImage imageNamed:@"teeball"] forState:UIControlStateNormal];
                [TeeBtn setBackgroundImage:[UIImage imageNamed:@"teeball"] forState:UIControlStateHighlighted];
                [TeeBtn setBackgroundImage:[UIImage imageNamed:@"teeball"] forState:UIControlStateSelected];
                
            }
            else
            {
                [TeeBtn setBackgroundImage:[UIImage imageNamed:@"teeballLite"] forState:UIControlStateNormal];
                [TeeBtn setBackgroundImage:[UIImage imageNamed:@"teeballLite"] forState:UIControlStateHighlighted];
                [TeeBtn setBackgroundImage:[UIImage imageNamed:@"teeballLite"] forState:UIControlStateSelected];
            }
            
            if (IfUserComment)
            {
                [CommentBtn setBackgroundImage:[UIImage imageNamed:@"commentParmitionhave"] forState:UIControlStateNormal];
                [CommentBtn setBackgroundImage:[UIImage imageNamed:@"commentParmitionhave"] forState:UIControlStateHighlighted];
                [CommentBtn setBackgroundImage:[UIImage imageNamed:@"commentParmitionhave"] forState:UIControlStateSelected];
                
            }
            else
            {
                [CommentBtn setBackgroundImage:[UIImage imageNamed:@"commentparmitionhavenot"] forState:UIControlStateNormal];
                [CommentBtn setBackgroundImage:[UIImage imageNamed:@"commentparmitionhavenot"] forState:UIControlStateHighlighted];
                [CommentBtn setBackgroundImage:[UIImage imageNamed:@"commentparmitionhavenot"] forState:UIControlStateSelected];
            }
            
            
            
            //Like comment allow or not
            
            if ([[mutDicActivity objectForKey:@"ActivityCommentAllow"] integerValue]==1)
            {
                [CommentBtn addTarget:self action:@selector(CommmentButton:) forControlEvents:UIControlEventTouchUpInside];
                [CommentBtn setTag:COMMENTTAG+indexPath.row];
            }
            else
            {
                CommentBtn.hidden=YES;
            }
            if ([[mutDicActivity objectForKey:@"ActivityLikeAllow"] integerValue]==1)
            {
                [TeeBtn addTarget:self action:@selector(teebuttonclick:) forControlEvents:UIControlEventTouchUpInside];
                [TeeBtn setTag:TEETAG+indexPath.row];
                
            }
            else
            {
                TeeBtn.hidden=YES;
            }
            if ([[mutDicActivity objectForKey:@"PhotoComment"] length]>0)
            {
                footerFrame.origin.y+=extraHeight+ExtraHightforcontent+ExtreaContent+ExtraHeightForImage;
                [Vfooterview setFrame:footerFrame];
                UIView *bacKView=[PhotoActivity.contentView viewWithTag:999];
                CGRect FrameBackview=[bacKView frame];
                FrameBackview.size.height+=extraHeight+ExtraHightforcontent+ExtreaContent+ExtraHeightForImage;
                [bacKView setFrame:FrameBackview];
            }
            else
            {
                footerFrame.origin.y+=extraHeight-16+ExtreaContent+ExtraHeightForImage;
                [Vfooterview setFrame:footerFrame];
                UIView *bacKView=[PhotoActivity.contentView viewWithTag:999];
                CGRect FrameBackview=[bacKView frame];
                FrameBackview.size.height+=extraHeight-20+ExtreaContent+ExtraHeightForImage;
                [bacKView setFrame:FrameBackview];
            }
            
            
            return PhotoActivity;
            
        }
            
            
            
            
        else if ([[mutDicActivity valueForKey:@"ActivityType"] integerValue]==6)
        {
            
            //-------------------Vedio Section programme---------------------//
            
            static NSString *Activitypost =@"TTTCellForphotoActive";
            
            TTTCellForphotoActivity *PhotoActivity=(TTTCellForphotoActivity *)[tableView dequeueReusableCellWithIdentifier:Activitypost];
            PhotoActivity=nil;
            if (PhotoActivity==nil)
            {
                NSArray *CellNib=[[NSBundle mainBundle] loadNibNamed:@"TTTCellForphotoActive" owner:self options:nil];
                PhotoActivity=(TTTCellForphotoActivity *)[CellNib objectAtIndex:0];
                
            }
            [PhotoActivity setBackgroundColor:[UIColor clearColor]];
            // Download user photo And user image Operation
            
            CGFloat extraHeight=0.0f;
            UIView *UserphotobackView=(UIView *)[PhotoActivity.contentView viewWithTag:1];
            [self SetroundborderWithborderWidth:2.0f WithColour:[UIColor whiteColor] ForView:UserphotobackView];
            
            UIImageView *ActivityOwnerimageView=(UIImageView *)[PhotoActivity.contentView viewWithTag:2];
            [self SetroundborderWithborderWidth:0.0f WithColour:[UIColor clearColor] ForImageview:ActivityOwnerimageView];
            
            //Download Image in image
            
            NSURLRequest *request_img2 = [NSURLRequest requestWithURL:[NSURL URLWithString:[mutDicActivity objectForKey:@"ActivityCreatorImage"]]];
            
            AFImageRequestOperation *operationProfileimage = [AFImageRequestOperation imageRequestOperationWithRequest:request_img2
                                                              
                                                                                                  imageProcessingBlock:nil
                                                              
                                                                                                               success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                                                                                   
                                                                                                                   if(image!=nil)
                                                                                                                       
                                                                                                                   {
                                                                                                                       
                                                                                                                       ActivityOwnerimageView.image=image;
                                                                                                                       
                                                                                                                       
                                                                                                                       
                                                                                                                   }
                                                                                                                   
                                                                                                                   
                                                                                                                   
                                                                                                               }
                                                              
                                                                                                               failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                                                                                                   
                                                                                                                   NSLog(@"Error %@",error);
                                                                                                                   
                                                                                                                   
                                                                                                                   
                                                                                                               }];
            
            [operationProfileimage start];
            // ---------  Send to profile image view  ----- //
            
            TapGesture=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(SendToProfileView:)];
            [TapGesture setNumberOfTapsRequired:1];
            [ActivityOwnerimageView setUserInteractionEnabled:YES];
            [ActivityOwnerimageView setTag:[[mutDicActivity objectForKey:@"ActivityCreator"] integerValue]];
            [ActivityOwnerimageView addGestureRecognizer:TapGesture];
            
            //Activity owner name
            
            UILabel *OwnernameLbl=(UILabel *)[PhotoActivity.contentView viewWithTag:3];
            OwnernameLbl.font=[UIFont fontWithName:MYRIARDPROSAMIBOLT size:16.0f];
            OwnernameLbl.text=[mutDicActivity objectForKey:@"ActivityCreatorTitle"];
            
            
            //Activity Titel Lable
            
            UILabel *ActivityTitel=(UILabel *)[PhotoActivity.contentView viewWithTag:4];
            CGRect activityframe=[ActivityTitel frame];
            ActivityTitel.font=[UIFont fontWithName:MYRIARDPROLIGHT size:15.0f];
            ActivityTitel.textColor=[UIColor whiteColor];
            ActivityTitel.textAlignment=NSTextAlignmentLeft;
            
            CGRect ActivityTitelframe = [[mutDicActivity objectForKey:@"ActivityTitle"] boundingRectWithSize:CGSizeMake(230, MAXFLOAT)
                                                                                                     options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                                                                  attributes:@{NSFontAttributeName:[UIFont fontWithName:MYRIARDPROLIGHT size:15.0f]
                                                                                                               }
                                                                                                     context:nil];
            
            extraHeight=(ActivityTitelframe.size.height>16)?ActivityTitelframe.size.height-16:0.0f;
            
            ActivityTitel.text=[mutDicActivity objectForKey:@"ActivityTitle"];
            [ActivityTitel setNumberOfLines:0];
            [ActivityTitel setLineBreakMode:NSLineBreakByWordWrapping];
            activityframe.size.height+=extraHeight;
            [ActivityTitel setFrame:activityframe];
            
            //Activity posted time from privious time
            
            UILabel *PostTimeLBL=(UILabel *)[PhotoActivity.contentView viewWithTag:5];
            PostTimeLBL.textColor=[UIColor whiteColor];
            PostTimeLBL.font=[UIFont fontWithName:MYRIARDPROLIGHT size:13.0f];
            PostTimeLBL.text=[mutDicActivity objectForKey:@"ActivityCreatedDate"];
            
            
            // Location View Show or hide
            
            UIView *locationView=(UIView *)[PhotoActivity.contentView viewWithTag:400];
            CGRect locationframe=[locationView frame];
            locationframe.origin.y+=extraHeight;
            NSLog(@"The photo location:%@",[mutDicActivity objectForKey:@"Photolocation"]);
            if (![self RemoveNullandreplaceWithSpace:[mutDicActivity objectForKey:@"Photolocation"]].length>0)
            {
                locationView.hidden=YES;
            }
            else
            {
                UILabel *LocationLBl=(UILabel *)[PhotoActivity.contentView viewWithTag:401];
                LocationLBl.font=[UIFont fontWithName:MYRIARDPROLIGHT size:11.0f];
                LocationLBl.textColor=[UIColor whiteColor];
                LocationLBl.text=[mutDicActivity objectForKey:@"Photolocation"];
                [locationView setFrame:locationframe];
            }
            
            
            // MainActivity Content frame
            
            
            // Downlod Photo to which the comment is posted main photo for photo activity
            
            UIView *ImageBackview=(UIView *)[PhotoActivity.contentView viewWithTag:9804197];
            CGRect Backmainframe=[ImageBackview frame];
            
            UIImageView *PhotoImage=(UIImageView *)[PhotoActivity.contentView viewWithTag:403];
            TapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(Sendtovideodetails:)];
            [TapGesture setNumberOfTapsRequired:1];
            [PhotoImage setUserInteractionEnabled:YES];
            [PhotoImage setTag:PHOTOCELL+indexPath.row];
            [PhotoImage addGestureRecognizer:TapGesture];
            
            CGRect PhotoTagFrame=[PhotoImage frame];
            NSURLRequest *MainImageDownload = [NSURLRequest requestWithURL:[NSURL URLWithString:[mutDicActivity objectForKey:@"Photourl"]]];
            //Extra height for caption
            CGFloat ExtreaContent=0.0f;
            if ([[mutDicActivity objectForKey:@"PhotoCaption"] length]>0)
            {
                
                UILabel *Caption2Lbl=(UILabel *)[PhotoActivity.contentView viewWithTag:98382];
                CGRect captionFrame=[Caption2Lbl frame];
                Caption2Lbl.font=[UIFont fontWithName:MYRIARDPROLIGHT size:15.0f];
                
                
                CGRect ActivityContentTextframe2 = [[mutDicActivity objectForKey:@"PhotoCaption"] boundingRectWithSize:CGSizeMake(292, MAXFLOAT)
                                                                                                               options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                                                                            attributes:@{NSFontAttributeName:[UIFont fontWithName:MYRIARDPROLIGHT size:15.0f]
                                                                                                                         }
                                                                                                               context:nil];
                
                ExtreaContent=(ActivityContentTextframe2.size.height>21.0f)?ActivityContentTextframe2.size.height:21.0f;
                captionFrame.size.height=ExtreaContent;
                Caption2Lbl.text=[mutDicActivity objectForKey:@"PhotoCaption"];
                Caption2Lbl.numberOfLines=0.0f;
                Caption2Lbl.lineBreakMode=NSLineBreakByCharWrapping;
                [Caption2Lbl setFrame:captionFrame];
                
            }
            else
            {
                ExtreaContent=0.0f;
            }
            
            
            UILabel *ActivityContent=(UILabel *)[PhotoActivity.contentView viewWithTag:1111111];
            ActivityContent.font=[UIFont fontWithName:MYRIARDPROLIGHT size:15.0f];
            ActivityContent.textColor=[UIColor whiteColor];
            CGFloat ExtraHightforcontent=0.0f;
            
            CGRect ActivityContentframe=[ActivityContent frame];
            
            
            CGRect ActivityContentTextframe = [[mutDicActivity objectForKey:@"PhotoComment"] boundingRectWithSize:CGSizeMake(292, MAXFLOAT)
                                                                                                          options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                                                                       attributes:@{NSFontAttributeName:[UIFont fontWithName:MYRIARDPROLIGHT size:15.0f]
                                                                                                                    }
                                                                                                          context:nil];
            
            ExtraHightforcontent=(ActivityContentTextframe.size.height>21.0f)?ActivityContentTextframe.size.height-21:0.0f;
            
            
            //Set frame to the activity content.........
            ActivityContentframe.origin.y+=extraHeight+ExtreaContent;
            ActivityContentframe.size.height+=ExtraHightforcontent;
            [ActivityContent setText:[mutDicActivity objectForKey:@"PhotoComment"]];
            [ActivityContent setLineBreakMode:NSLineBreakByWordWrapping];
            [ActivityContent setNumberOfLines:0];
            
            [ActivityContent setFrame:ActivityContentframe];
            
            
            
            
            //Downloading image
            
            AFImageRequestOperation *mainImageDownload = [AFImageRequestOperation imageRequestOperationWithRequest:MainImageDownload
                                                          
                                                                                              imageProcessingBlock:nil
                                                          
                                                                                                           success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                                                                               
                                                                                                               if(image!=nil)
                                                                                                                   
                                                                                                               {
                                                                                                                   
                                                                                                                   PhotoImage.image=image;
                                                                                                                   
                                                                                                                   
                                                                                                                   
                                                                                                               }
                                                                                                               
                                                                                                               
                                                                                                               
                                                                                                           }
                                                          
                                                                                                           failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                                                                                               
                                                                                                               NSLog(@"Error %@",error);
                                                                                                               
                                                                                                               
                                                                                                               
                                                                                                           }];
            
            [mainImageDownload start];
            
            PhotoTagFrame.origin.y+=extraHeight+ExtreaContent;
            
            [PhotoImage setFrame:PhotoTagFrame];
            Backmainframe.origin.y+=extraHeight+ExtreaContent;
            [ImageBackview setFrame:Backmainframe];
            
            //---------------------------Like commnt area-------------------------//
            //----Footer Section----//
            
            //Footer portion like comment area and total comment
            
            UIView *Vfooterview=(UIView *)[PhotoActivity.contentView viewWithTag:8];
            CGRect footerFrame =[Vfooterview frame];
            
            //TotalTee Lable
            
            UILabel *Totaltee=(UILabel *)[PhotoActivity.contentView viewWithTag:9];
            Totaltee.textColor=[UIColor whiteColor];
            Totaltee.font=[UIFont fontWithName:MYRIARDPROLIGHT size:14.0f];
            Totaltee.text=[NSString stringWithFormat:@"%@ Tee'd It",[mutDicActivity objectForKey:@"ActivityLikeCount"]];;
            
            //Total Comment Lable
            
            UILabel *TotalteeTextLBL=(UILabel *)[PhotoActivity.contentView viewWithTag:10];
            TotalteeTextLBL.textColor=[UIColor whiteColor];
            TotalteeTextLBL.font=[UIFont fontWithName:MYRIARDPROLIGHT size:14.0f];
            
            //total comment lable
            
            UILabel *TotalComment=(UILabel *)[PhotoActivity.contentView viewWithTag:12];
            TotalComment.font=[UIFont fontWithName:MYRIARDPROLIGHT size:14.0f];
            TotalComment.textColor=[UIColor whiteColor];
            TotalComment.text=[NSString stringWithFormat:@"%@ Comments",[mutDicActivity objectForKey:@"ActivityCommentCount"]];
            
            //Total comment text lable
            
            UILabel *totalCommentTxtLBL=(UILabel *)[PhotoActivity.contentView viewWithTag:11];
            totalCommentTxtLBL.font=[UIFont fontWithName:MYRIARDPROLIGHT size:14.0f];
            totalCommentTxtLBL.textColor=[UIColor whiteColor];
            
            
            //Tee and comment button
            
            IfUserLiked=([[mutDicActivity objectForKey:@"ActivityUserLiked"] integerValue]==0)?FALSE:TRUE;
            IfUserComment=([[mutDicActivity objectForKey:@"ActivityUserCommented"] integerValue]==0)?FALSE:TRUE;
            UIButton *TeeBtn=(UIButton *)[PhotoActivity.contentView viewWithTag:14];
            UIButton *CommentBtn=(UIButton *)[PhotoActivity.contentView viewWithTag:13];
            if (IfUserLiked)
            {
                [TeeBtn setBackgroundImage:[UIImage imageNamed:@"teeball"] forState:UIControlStateNormal];
                [TeeBtn setBackgroundImage:[UIImage imageNamed:@"teeball"] forState:UIControlStateHighlighted];
                [TeeBtn setBackgroundImage:[UIImage imageNamed:@"teeball"] forState:UIControlStateSelected];
                
            }
            else
            {
                [TeeBtn setBackgroundImage:[UIImage imageNamed:@"teeballLite"] forState:UIControlStateNormal];
                [TeeBtn setBackgroundImage:[UIImage imageNamed:@"teeballLite"] forState:UIControlStateHighlighted];
                [TeeBtn setBackgroundImage:[UIImage imageNamed:@"teeballLite"] forState:UIControlStateSelected];
            }
            
            if (IfUserComment)
            {
                [CommentBtn setBackgroundImage:[UIImage imageNamed:@"commentParmitionhave"] forState:UIControlStateNormal];
                [CommentBtn setBackgroundImage:[UIImage imageNamed:@"commentParmitionhave"] forState:UIControlStateHighlighted];
                [CommentBtn setBackgroundImage:[UIImage imageNamed:@"commentParmitionhave"] forState:UIControlStateSelected];
                
            }
            else
            {
                [CommentBtn setBackgroundImage:[UIImage imageNamed:@"commentparmitionhavenot"] forState:UIControlStateNormal];
                [CommentBtn setBackgroundImage:[UIImage imageNamed:@"commentparmitionhavenot"] forState:UIControlStateHighlighted];
                [CommentBtn setBackgroundImage:[UIImage imageNamed:@"commentparmitionhavenot"] forState:UIControlStateSelected];
            }
            
            
            
            //Like comment allow or not
            
            if ([[mutDicActivity objectForKey:@"ActivityCommentAllow"] integerValue]==1)
            {
                [CommentBtn addTarget:self action:@selector(CommmentButton:) forControlEvents:UIControlEventTouchUpInside];
                [CommentBtn setTag:COMMENTTAG+indexPath.row];
            }
            else
            {
                CommentBtn.hidden=YES;
            }
            if ([[mutDicActivity objectForKey:@"ActivityLikeAllow"] integerValue]==1)
            {
                [TeeBtn addTarget:self action:@selector(teebuttonclick:) forControlEvents:UIControlEventTouchUpInside];
                [TeeBtn setTag:TEETAG+indexPath.row];
                
            }
            else
            {
                TeeBtn.hidden=YES;
            }
            if ([[mutDicActivity objectForKey:@"PhotoComment"] length]>0)
            {
                footerFrame.origin.y+=extraHeight+ExtraHightforcontent+ExtreaContent;
                [Vfooterview setFrame:footerFrame];
                UIView *bacKView=[PhotoActivity.contentView viewWithTag:999];
                CGRect FrameBackview=[bacKView frame];
                FrameBackview.size.height+=extraHeight+ExtraHightforcontent+ExtreaContent;
                [bacKView setFrame:FrameBackview];
            }
            else
            {
                footerFrame.origin.y+=extraHeight-14+ExtreaContent;
                [Vfooterview setFrame:footerFrame];
                UIView *bacKView=[PhotoActivity.contentView viewWithTag:999];
                CGRect FrameBackview=[bacKView frame];
                FrameBackview.size.height+=extraHeight-14+ExtreaContent;
                [bacKView setFrame:FrameBackview];
            }
            
            
            return PhotoActivity;
            
        }
            
            
            
        else
        {
            //-------------------Profile Type cativity------------------//
            //Step one//
            
            static NSString *Activitypost =@"TTTprofiletypeActivityCell";
            
            TTTProfiletypeActivityCell *PhotoActivity=(TTTProfiletypeActivityCell *)[tableView dequeueReusableCellWithIdentifier:Activitypost];
            PhotoActivity=nil;
            if (PhotoActivity==nil)
            {
                NSArray *CellNib=[[NSBundle mainBundle] loadNibNamed:@"TTTprofiletypeActivityCell" owner:self options:nil];
                PhotoActivity=(TTTProfiletypeActivityCell *)[CellNib objectAtIndex:0];
                
            }
            [PhotoActivity setBackgroundColor:[UIColor clearColor]];
            // Download user photo And user image Operation
            CGFloat extraHeight=0.0f;
            UIView *UserphotobackView=(UIView *)[PhotoActivity.contentView viewWithTag:1];
            [self SetroundborderWithborderWidth:2.0f WithColour:[UIColor whiteColor] ForView:UserphotobackView];
            
            UIImageView *ActivityOwnerimageView=(UIImageView *)[PhotoActivity.contentView viewWithTag:2];
            [self SetroundborderWithborderWidth:0.0f WithColour:[UIColor clearColor] ForImageview:ActivityOwnerimageView];
            
            //Download Image in image
            
            NSURLRequest *request_img2 = [NSURLRequest requestWithURL:[NSURL URLWithString:[mutDicActivity objectForKey:@"ActivityCreatorImage"]]];
            
            AFImageRequestOperation *operationProfileimage = [AFImageRequestOperation imageRequestOperationWithRequest:request_img2
                                                              
                                                                                                  imageProcessingBlock:nil
                                                              
                                                                                                               success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                                                                                   
                                                                                                                   if(image!=nil)
                                                                                                                       
                                                                                                                   {
                                                                                                                       
                                                                                                                       ActivityOwnerimageView.image=image;
                                                                                                                       
                                                                                                                       
                                                                                                                       
                                                                                                                   }
                                                                                                                   
                                                                                                                   
                                                                                                                   
                                                                                                               }
                                                              
                                                                                                               failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                                                                                                   
                                                                                                                   NSLog(@"Error %@",error);
                                                                                                                   
                                                                                                                   
                                                                                                                   
                                                                                                               }];
            
            [operationProfileimage start];
            
            //******  Send to profile image view  *****//
            
            TapGesture=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(SendToProfileView:)];
            [TapGesture setNumberOfTapsRequired:1];
            [ActivityOwnerimageView setUserInteractionEnabled:YES];
            [ActivityOwnerimageView setTag:[[mutDicActivity objectForKey:@"ActivityCreator"] integerValue]];
            [ActivityOwnerimageView addGestureRecognizer:TapGesture];
            
            //Activity owner name
            
            UILabel *OwnernameLbl=(UILabel *)[PhotoActivity.contentView viewWithTag:3];
            OwnernameLbl.font=[UIFont fontWithName:MYRIARDPROSAMIBOLT size:16.0f];
            OwnernameLbl.text=[mutDicActivity objectForKey:@"ActivityCreatorTitle"];
            
            //Titel for status ...
            UILabel *TitelContent=(UILabel *)[PhotoActivity.contentView viewWithTag:4];
            TitelContent.font=[UIFont fontWithName:MYRIARDPROLIGHT size:15.0f];
            TitelContent.textColor=[UIColor whiteColor];
            TitelContent.text=[mutDicActivity objectForKey:@"ActivityTitle"];
            
            //Activity Titel Lable
            
            UILabel *ActivityTitel=(UILabel *)[PhotoActivity.contentView viewWithTag:666];
            CGRect activityframe=[ActivityTitel frame];
            ActivityTitel.font=[UIFont fontWithName:MYRIARDPROLIGHT size:15.0f];
            ActivityTitel.textColor=[UIColor whiteColor];
            ActivityTitel.textAlignment=NSTextAlignmentLeft;
            
            CGRect ActivityTitelframe = [[mutDicActivity objectForKey:@"ActivityComment"] boundingRectWithSize:CGSizeMake(285, MAXFLOAT)
                                                                                                       options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                                                                    attributes:@{NSFontAttributeName:[UIFont fontWithName:MYRIARDPROLIGHT size:15.0f]
                                                                                                                 }
                                                                                                       context:nil];
            
            extraHeight=(ActivityTitelframe.size.height>21)?ActivityTitelframe.size.height-21:0.0f;
            
            ActivityTitel.text=[mutDicActivity objectForKey:@"ActivityComment"];
            [ActivityTitel setNumberOfLines:0];
            [ActivityTitel setLineBreakMode:NSLineBreakByWordWrapping];
            activityframe.size.height=ActivityTitelframe.size.height;
            [ActivityTitel setFrame:activityframe];
            
            //Activity posted time from privious time
            
            UILabel *PostTimeLBL=(UILabel *)[PhotoActivity.contentView viewWithTag:5];
            PostTimeLBL.textColor=[UIColor whiteColor];
            PostTimeLBL.font=[UIFont fontWithName:MYRIARDPROLIGHT size:13.0f];
            PostTimeLBL.text=[mutDicActivity objectForKey:@"ActivityCreatedDate"];
            
            // UILabel *AcrivityContent=(UILabel *)[PhotoActivity.contentView viewWithTag:];
            
            //-------------------Activity Footer view----------------------//
            
            UIView *Vfooterview=(UIView *)[PhotoActivity.contentView viewWithTag:8];
            CGRect footerFrame =[Vfooterview frame];
            
            //TotalTee Lable
            
            UILabel *Totaltee=(UILabel *)[PhotoActivity.contentView viewWithTag:9];
            Totaltee.textColor=[UIColor whiteColor];
            Totaltee.font=[UIFont fontWithName:MYRIARDPROLIGHT size:14.0f];
            Totaltee.text=[NSString stringWithFormat:@"%@ Tee'd It",[mutDicActivity objectForKey:@"ActivityLikeCount"]];
            
            //Total Comment Lable
            
            UILabel *TotalteeTextLBL=(UILabel *)[PhotoActivity.contentView viewWithTag:10];
            TotalteeTextLBL.textColor=[UIColor whiteColor];
            TotalteeTextLBL.font=[UIFont fontWithName:MYRIARDPROLIGHT size:14.0f];
            
            //total comment lable
            
            UILabel *TotalComment=(UILabel *)[PhotoActivity.contentView viewWithTag:12];
            TotalComment.font=[UIFont fontWithName:MYRIARDPROLIGHT size:14.0f];
            TotalComment.textColor=[UIColor whiteColor];
            TotalComment.text=[NSString stringWithFormat:@"%@ Comments",[mutDicActivity objectForKey:@"ActivityCommentCount"]];
            
            //Total comment text lable
            
            UILabel *totalCommentTxtLBL=(UILabel *)[PhotoActivity.contentView viewWithTag:11];
            totalCommentTxtLBL.font=[UIFont fontWithName:MYRIARDPROLIGHT size:14.0f];
            totalCommentTxtLBL.textColor=[UIColor whiteColor];
            
            
            //Tee and comment button
            
            IfUserLiked=([[mutDicActivity objectForKey:@"ActivityUserLiked"] integerValue]==0)?FALSE:TRUE;
            IfUserComment=([[mutDicActivity objectForKey:@"ActivityUserCommented"] integerValue]==0)?FALSE:TRUE;
            UIButton *TeeBtn=(UIButton *)[PhotoActivity.contentView viewWithTag:14];
            UIButton *CommentBtn=(UIButton *)[PhotoActivity.contentView viewWithTag:13];
            if (IfUserLiked)
            {
                [TeeBtn setBackgroundImage:[UIImage imageNamed:@"teeball"] forState:UIControlStateNormal];
                [TeeBtn setBackgroundImage:[UIImage imageNamed:@"teeball"] forState:UIControlStateHighlighted];
                [TeeBtn setBackgroundImage:[UIImage imageNamed:@"teeball"] forState:UIControlStateSelected];
                
            }
            else
            {
                [TeeBtn setBackgroundImage:[UIImage imageNamed:@"teeballLite"] forState:UIControlStateNormal];
                [TeeBtn setBackgroundImage:[UIImage imageNamed:@"teeballLite"] forState:UIControlStateHighlighted];
                [TeeBtn setBackgroundImage:[UIImage imageNamed:@"teeballLite"] forState:UIControlStateSelected];
            }
            
            if (IfUserComment)
            {
                [CommentBtn setBackgroundImage:[UIImage imageNamed:@"commentParmitionhave"] forState:UIControlStateNormal];
                [CommentBtn setBackgroundImage:[UIImage imageNamed:@"commentParmitionhave"] forState:UIControlStateHighlighted];
                [CommentBtn setBackgroundImage:[UIImage imageNamed:@"commentParmitionhave"] forState:UIControlStateSelected];
                
            }
            else
            {
                [CommentBtn setBackgroundImage:[UIImage imageNamed:@"commentparmitionhavenot"] forState:UIControlStateNormal];
                [CommentBtn setBackgroundImage:[UIImage imageNamed:@"commentparmitionhavenot"] forState:UIControlStateHighlighted];
                [CommentBtn setBackgroundImage:[UIImage imageNamed:@"commentparmitionhavenot"] forState:UIControlStateSelected];
            }
            
            
            
            
            //Like comment allow or not
            
            if ([[mutDicActivity objectForKey:@"ActivityCommentAllow"] integerValue]==1)
            {
                [CommentBtn addTarget:self action:@selector(CommmentButton:) forControlEvents:UIControlEventTouchUpInside];
                [CommentBtn setTag:COMMENTTAG+indexPath.row];
            }
            else
            {
                CommentBtn.hidden=YES;
            }
            if ([[mutDicActivity objectForKey:@"ActivityLikeAllow"] integerValue]==1)
            {
                [TeeBtn addTarget:self action:@selector(teebuttonclick:) forControlEvents:UIControlEventTouchUpInside];
                [TeeBtn setTag:TEETAG+indexPath.row];
                
            }
            else
            {
                TeeBtn.hidden=YES;
            }
            UIView *BackView=(UIView *)[PhotoActivity.contentView viewWithTag:999];
            CGRect backframe=[BackView frame];
            backframe.size.height+=extraHeight;
            NSLog(@"Thge value of back frame:%f",backframe.size.height);
            [BackView setFrame:backframe];
            footerFrame.origin.y+=extraHeight;
            [Vfooterview setFrame:footerFrame];
            return PhotoActivity;
            
        }

        
    }
    }
    else
    {
        NSMutableDictionary *CommentACtivityDic=[CommntArry objectAtIndex:indexPath.row];
        if (indexPath.row==0)
        {
            
            if ([[CommentACtivityDic valueForKey:@"ActivityType"] integerValue]==1)
            {
                
                
                
                //----------------------Activity Type Achivement-----------------------//
                
                
                //     Section1     //
                
                
                static NSString *TTTcellforachivement=@"TTTActivityCellforachivement";
                TTTActivityCellforachivement *AchivementCell=(TTTActivityCellforachivement *)[tableView dequeueReusableCellWithIdentifier:TTTcellforachivement];
                AchivementCell=nil;
                if (AchivementCell==nil)
                {
                    NSArray *CellNib=[[NSBundle mainBundle] loadNibNamed:@"TTTActivityCellforachivement" owner:self options:nil];
                    AchivementCell=(TTTActivityCellforachivement *)[CellNib objectAtIndex:0];
                    //}
                    CGFloat extraHeight=0.0f;
                    UIView *UserphotobackView=(UIView *)[AchivementCell.contentView viewWithTag:1];
                    [self SetroundborderWithborderWidth:2.0f WithColour:[UIColor whiteColor] ForView:UserphotobackView];
                    
                    UIImageView *ActivityOwnerimageView=(UIImageView *)[AchivementCell.contentView viewWithTag:2];
                    [self SetroundborderWithborderWidth:0.0f WithColour:[UIColor clearColor] ForImageview:ActivityOwnerimageView];
                    
                    //Download Image in image
                    
                    NSURLRequest *request_img2 = [NSURLRequest requestWithURL:[NSURL URLWithString:[CommentACtivityDic objectForKey:@"ActivityCreatorImage"]]];
                    
                    AFImageRequestOperation *operationProfileimage = [AFImageRequestOperation imageRequestOperationWithRequest:request_img2
                                                                      
                                                                                                          imageProcessingBlock:nil
                                                                      
                                                                                                                       success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                                                                                           
                                                                                                                           if(image!=nil)
                                                                                                                               
                                                                                                                           {
                                                                                                                               
                                                                                                                               ActivityOwnerimageView.image=image;
                                                                                                                               
                                                                                                                               
                                                                                                                               
                                                                                                                           }
                                                                                                                           
                                                                                                                           
                                                                                                                           
                                                                                                                       }
                                                                      
                                                                                                                       failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                                                                                                           
                                                                                                                           NSLog(@"Error %@",error);
                                                                                                                           
                                                                                                                           
                                                                                                                           
                                                                                                                       }];
                    
                    [operationProfileimage start];
                    //******  Send to profile image view  *****//
                    TapGesture=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(SendToProfileView:)];
                    [TapGesture setNumberOfTapsRequired:1];
                    [ActivityOwnerimageView setUserInteractionEnabled:NO];
                    [ActivityOwnerimageView setTag:[[CommentACtivityDic objectForKey:@"ActivityCreator"] integerValue]];
                    [ActivityOwnerimageView addGestureRecognizer:TapGesture];
                    
                    //Activity owner name
                    
                    UILabel *OwnernameLbl=(UILabel *)[AchivementCell.contentView viewWithTag:3];
                    OwnernameLbl.font=[UIFont fontWithName:MYRIARDPROSAMIBOLT size:16.0f];
                    OwnernameLbl.text=[CommentACtivityDic objectForKey:@"ActivityCreatorTitle"];
                    
                    //Activity Titel Lable
                    
                    UILabel *ActivityTitel=(UILabel *)[AchivementCell.contentView viewWithTag:4];
                    CGRect activityframe=[ActivityTitel frame];
                    ActivityTitel.font=[UIFont fontWithName:MYRIARDPROLIGHT size:15.0f];
                    ActivityTitel.textColor=[UIColor whiteColor];
                    ActivityTitel.textAlignment=NSTextAlignmentLeft;
                    
                    CGRect ActivityTitelframe = [[CommentACtivityDic objectForKey:@"ActivityTitle"] boundingRectWithSize:CGSizeMake(230, MAXFLOAT)
                                                                                                                 options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                                                                              attributes:@{NSFontAttributeName:[UIFont fontWithName:MYRIARDPROLIGHT size:15.0f]
                                                                                                                           }
                                                                                                                 context:nil];
                    
                    extraHeight=(ActivityTitelframe.size.height>21)?ActivityTitelframe.size.height-21:0.0f;
                    
                    ActivityTitel.text=[CommentACtivityDic objectForKey:@"ActivityTitle"];
                    [ActivityTitel setNumberOfLines:0];
                    [ActivityTitel setLineBreakMode:NSLineBreakByWordWrapping];
                    activityframe.size.height+=extraHeight;
                    [ActivityTitel setFrame:activityframe];
                    
                    //Activity posted time from privious time
                    
                    UILabel *PostTimeLBL=(UILabel *)[AchivementCell.contentView viewWithTag:5];
                    PostTimeLBL.textColor=[UIColor whiteColor];
                    PostTimeLBL.font=[UIFont fontWithName:MYRIARDPROLIGHT size:13.0f];
                    PostTimeLBL.text=[CommentACtivityDic objectForKey:@"ActivityCreatedDate"];
                    
                    UIView *BackviewRect=(UIView *)[AchivementCell.contentView viewWithTag:954001];
                    BackviewRect.hidden=YES;
                    
                    //   Section 2  //
                    
                    //------------- Set Achivement image To the achivement image view tag-400 ---------------//
                    
                    NSMutableDictionary *ActivityAchivementDic=[CommentACtivityDic objectForKey:@"MatchAchivement"];
                    
                    UIImageView *AchiveImgview=(UIImageView *)[AchivementCell.contentView viewWithTag:400];
                    
                    [self SetroundborderWithborderWidth:2.0f WithColour:[UIColor clearColor] ForImageview:AchiveImgview];
                    [AchiveImgview setTag:ACHIVEMENTCELL+[[CommentACtivityDic objectForKey:@"AchivementId"] integerValue]];
                    TapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(GoestoAchivement:)];
                    [TapGesture setNumberOfTapsRequired:1];
                    [AchiveImgview addGestureRecognizer:TapGesture];
                    [AchiveImgview setUserInteractionEnabled:NO];
                    
                    NSURLRequest *AchiveMentimage = [NSURLRequest requestWithURL:[NSURL URLWithString:[ActivityAchivementDic valueForKey:@"AchivementImage"]]];
                    
                    AFImageRequestOperation *DownlodAchivementImage = [AFImageRequestOperation imageRequestOperationWithRequest:AchiveMentimage
                                                                       
                                                                                                           imageProcessingBlock:nil
                                                                       
                                                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                                                                                            
                                                                                                                            if(image!=nil)
                                                                                                                                
                                                                                                                            {
                                                                                                                                
                                                                                                                                AchiveImgview.image=image;
                                                                                                                                
                                                                                                                                
                                                                                                                                
                                                                                                                            }
                                                                                                                            
                                                                                                                            
                                                                                                                            
                                                                                                                        }
                                                                       
                                                                                                                        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                                                                                                            
                                                                                                                            NSLog(@"Error %@",error);
                                                                                                                            
                                                                                                                            
                                                                                                                            
                                                                                                                        }];
                    
                    [DownlodAchivementImage start];
                    
                    //-------------Set match name--------//
                    
                    NSMutableDictionary *MatchDetailsDic=[CommentACtivityDic objectForKey:@"MatchDetails"];
                    UILabel *MatchName=(UILabel *)[AchivementCell.contentView viewWithTag:6];
                    MatchName.font=[UIFont fontWithName:MYRIARDPROSAMIBOLT size:15.0f];
                    MatchName.textColor=[UIColor whiteColor];
                    MatchName.text=[MatchDetailsDic valueForKey:@"MatchTitle"];
                    //-----------Set match Course-------------//
                    UILabel *MatchCourse=(UILabel *)[AchivementCell.contentView viewWithTag:7];
                    MatchCourse.font=[UIFont fontWithName:MYRIARDPROLIGHT size:15.0f];
                    MatchCourse.textColor=[UIColor whiteColor];
                    MatchCourse.text=[MatchDetailsDic objectForKey:@"MatchCourse"];
                    //------Section 3------//
                    
                    //TotalTee Lable
                    
                    UIView *vfooterView=(UIView *)[AchivementCell.contentView viewWithTag:8];
                    vfooterView.hidden=YES;
                    
                    UILabel *Totaltee=(UILabel *)[AchivementCell.contentView viewWithTag:9];
                    Totaltee.textColor=[UIColor whiteColor];
                    Totaltee.font=[UIFont fontWithName:MYRIARDPROLIGHT size:14.0f];
                    Totaltee.text=[NSString stringWithFormat:@"%@ Tee'd It",[CommentACtivityDic objectForKey:@"ActivityLikeCount"]];
                    
                    //Total Comment Lable
                    
                    UILabel *TotalteeTextLBL=(UILabel *)[AchivementCell.contentView viewWithTag:10];
                    TotalteeTextLBL.textColor=[UIColor whiteColor];
                    TotalteeTextLBL.font=[UIFont fontWithName:MYRIARDPROLIGHT size:14.0f];
                    
                    //total comment lable
                    
                    UILabel *TotalComment=(UILabel *)[AchivementCell.contentView viewWithTag:12];
                    TotalComment.font=[UIFont fontWithName:MYRIARDPROLIGHT size:14.0f];
                    TotalComment.textColor=[UIColor whiteColor];
                    TotalComment.text=[NSString stringWithFormat:@"%@ Comments",[CommentACtivityDic objectForKey:@"ActivityCommentCount"]];
                    
                    //Total comment text lable
                    
                    UILabel *totalCommentTxtLBL=(UILabel *)[AchivementCell.contentView viewWithTag:11];
                    totalCommentTxtLBL.font=[UIFont fontWithName:MYRIARDPROLIGHT size:14.0f];
                    totalCommentTxtLBL.textColor=[UIColor whiteColor];
                    
                    
                    //Tee and comment button
                    
                    IfUserLiked=([[CommentACtivityDic objectForKey:@"ActivityUserLiked"] integerValue]==0)?FALSE:TRUE;
                    IfUserComment=([[CommentACtivityDic objectForKey:@"ActivityUserCommented"] integerValue]==0)?FALSE:TRUE;
                    UIButton *TeeBtn=(UIButton *)[AchivementCell.contentView viewWithTag:14];
                    UIButton *CommentBtn=(UIButton *)[AchivementCell.contentView viewWithTag:13];
                    if (IfUserLiked)
                    {
                        [TeeBtn setBackgroundImage:[UIImage imageNamed:@"teeball"] forState:UIControlStateNormal];
                        [TeeBtn setBackgroundImage:[UIImage imageNamed:@"teeball"] forState:UIControlStateHighlighted];
                        [TeeBtn setBackgroundImage:[UIImage imageNamed:@"teeball"] forState:UIControlStateSelected];
                        
                    }
                    else
                    {
                        [TeeBtn setBackgroundImage:[UIImage imageNamed:@"teeballLite"] forState:UIControlStateNormal];
                        [TeeBtn setBackgroundImage:[UIImage imageNamed:@"teeballLite"] forState:UIControlStateHighlighted];
                        [TeeBtn setBackgroundImage:[UIImage imageNamed:@"teeballLite"] forState:UIControlStateSelected];
                    }
                    
                    if (IfUserComment)
                    {
                        [CommentBtn setBackgroundImage:[UIImage imageNamed:@"commentParmitionhave"] forState:UIControlStateNormal];
                        [CommentBtn setBackgroundImage:[UIImage imageNamed:@"commentParmitionhave"] forState:UIControlStateHighlighted];
                        [CommentBtn setBackgroundImage:[UIImage imageNamed:@"commentParmitionhave"] forState:UIControlStateSelected];
                        
                    }
                    else
                    {
                        [CommentBtn setBackgroundImage:[UIImage imageNamed:@"commentparmitionhavenot"] forState:UIControlStateNormal];
                        [CommentBtn setBackgroundImage:[UIImage imageNamed:@"commentparmitionhavenot"] forState:UIControlStateHighlighted];
                        [CommentBtn setBackgroundImage:[UIImage imageNamed:@"commentparmitionhavenot"] forState:UIControlStateSelected];
                    }
                    
                    [TeeBtn setUserInteractionEnabled:NO];
                    [CommentBtn setUserInteractionEnabled:NO];
                    
                    //Like comment allow or not
                    
                    if ([[CommentACtivityDic objectForKey:@"ActivityCommentAllow"] integerValue]==1)
                    {
                        [CommentBtn addTarget:self action:@selector(CommmentButton:) forControlEvents:UIControlEventTouchUpInside];
                        [CommentBtn setTag:COMMENTTAG+indexPath.row];
                    }
                    else
                    {
                        CommentBtn.hidden=YES;
                    }
                    if ([[CommentACtivityDic objectForKey:@"ActivityLikeAllow"] integerValue]==1)
                    {
                        [TeeBtn addTarget:self action:@selector(teebuttonclick:) forControlEvents:UIControlEventTouchUpInside];
                        [TeeBtn setTag:TEETAG+indexPath.row];
                        
                    }
                    else
                    {
                        TeeBtn.hidden=YES;
                    }
                    
                }
                return AchivementCell;
                
            }
            else if ([[CommentACtivityDic valueForKey:@"ActivityType"] integerValue]==2)
            {
                
                //------------------------Match Eeded activity-----------------//
                
                static NSString *NormalMatch=@"TTTCellforrounddetails";
                
                TTTCellforrounddetails *matchCell=[tableView dequeueReusableCellWithIdentifier:NormalMatch];
                matchCell=nil;
                if (matchCell==nil)
                {
                    NSArray *CellNIb=[[NSBundle mainBundle] loadNibNamed:@"TTTcellforrounddetails" owner:self options:nil];
                    matchCell=(TTTCellforrounddetails *)[CellNIb objectAtIndex:0];
                }
                //--------------------Section 1 ---------------------//
                
                //--------------  Download user photo And user image Operation  ------ //
                
                CGFloat extraHeight=0.0f;
                UIView *UserphotobackView=(UIView *)[matchCell.contentView viewWithTag:1];
                [self SetroundborderWithborderWidth:2.0f WithColour:[UIColor whiteColor] ForView:UserphotobackView];
                
                UIImageView *ActivityOwnerimageView=(UIImageView *)[matchCell.contentView viewWithTag:2];
                [self SetroundborderWithborderWidth:0.0f WithColour:[UIColor clearColor] ForImageview:ActivityOwnerimageView];
                
                //--------Download Image in image-------//
                
                NSURLRequest *request_img2 = [NSURLRequest requestWithURL:[NSURL URLWithString:[CommentACtivityDic objectForKey:@"ActivityCreatorImage"]]];
                
                AFImageRequestOperation *operationProfileimage = [AFImageRequestOperation imageRequestOperationWithRequest:request_img2
                                                                  
                                                                                                      imageProcessingBlock:nil
                                                                  
                                                                                                                   success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                                                                                       
                                                                                                                       if(image!=nil)
                                                                                                                           
                                                                                                                       {
                                                                                                                           
                                                                                                                           ActivityOwnerimageView.image=image;
                                                                                                                           
                                                                                                                           
                                                                                                                           
                                                                                                                       }
                                                                                                                       
                                                                                                                       
                                                                                                                       
                                                                                                                   }
                                                                  
                                                                                                                   failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                                                                                                       
                                                                                                                       NSLog(@"Error %@",error);
                                                                                                                       
                                                                                                                       
                                                                                                                       
                                                                                                                   }];
                
                [operationProfileimage start];
                
                
                //--------- Send to profile image view -------//
                
                
                
                TapGesture=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(SendToProfileView:)];
                [TapGesture setNumberOfTapsRequired:1];
                [ActivityOwnerimageView setUserInteractionEnabled:NO];
                [ActivityOwnerimageView setTag:[[CommentACtivityDic objectForKey:@"ActivityCreator"] integerValue]];
                [ActivityOwnerimageView addGestureRecognizer:TapGesture];
                
                //Activity owner name
                
                UILabel *OwnernameLbl=(UILabel *)[matchCell.contentView viewWithTag:3];
                OwnernameLbl.font=[UIFont fontWithName:MYRIARDPROSAMIBOLT size:16.0f];
                OwnernameLbl.text=[CommentACtivityDic objectForKey:@"ActivityCreatorTitle"];
                
                
                //Activity Titel Lable
                
                UILabel *ActivityTitel=(UILabel *)[matchCell.contentView viewWithTag:4];
                CGRect activityframe=[ActivityTitel frame];
                ActivityTitel.font=[UIFont fontWithName:MYRIARDPROLIGHT size:15.0f];
                ActivityTitel.textColor=[UIColor whiteColor];
                ActivityTitel.textAlignment=NSTextAlignmentLeft;
                
                CGRect ActivityTitelframe = [[CommentACtivityDic objectForKey:@"ActivityTitle"] boundingRectWithSize:CGSizeMake(230, MAXFLOAT)
                                                                                                             options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                                                                          attributes:@{NSFontAttributeName:[UIFont fontWithName:MYRIARDPROLIGHT size:15.0f]
                                                                                                                       }
                                                                                                             context:nil];
                
                extraHeight=(ActivityTitelframe.size.height>21)?ActivityTitelframe.size.height-21:0.0f;
                
                ActivityTitel.text=[CommentACtivityDic objectForKey:@"ActivityTitle"];
                [ActivityTitel setNumberOfLines:0];
                [ActivityTitel setLineBreakMode:NSLineBreakByWordWrapping];
                activityframe.size.height+=extraHeight;
                [ActivityTitel setFrame:activityframe];
                
                //Activity posted time from privious time
                
                UILabel *PostTimeLBL=(UILabel *)[matchCell.contentView viewWithTag:5];
                PostTimeLBL.textColor=[UIColor whiteColor];
                PostTimeLBL.font=[UIFont fontWithName:MYRIARDPROLIGHT size:13.0f];
                PostTimeLBL.text=[CommentACtivityDic objectForKey:@"ActivityCreatedDate"];
                
                //-----------------------------------Section 2 --------------------------------//
                //match portion//
                
                UIView *matchMainView=(UIView *)[matchCell.contentView viewWithTag:8888];
                CGRect MatchMainviewFrame=[matchMainView frame];
                
                NSMutableDictionary *Mutdicmatch=[CommentACtivityDic objectForKey:@"MatchDetails"];
                
                
                NSString *dateAndTime=[Mutdicmatch valueForKey:@"MatchStartDate"];
                
                NSArray *Concatarry=[dateAndTime componentsSeparatedByString:@" "];
                
                
                
                UILabel *dateLable=(UILabel *)[matchMainView viewWithTag:306];
                
                dateLable.font=[UIFont fontWithName:MYRIARDPROLIGHT size:23.0f];
                
                dateLable.textColor=[UIColor whiteColor];
                
                dateLable.textAlignment=NSTextAlignmentCenter;
                
                dateLable.text=[Concatarry objectAtIndex:1];
                
                
                
                //Show month in short like DEC
                
                
                
                UILabel *MonthLable=(UILabel *)[matchMainView viewWithTag:302];
                
                MonthLable.font=[UIFont fontWithName:@"MyriadProLight" size:13.0f];
                
                
                
                MonthLable.textColor=[UIColor whiteColor];
                
                MonthLable.textAlignment=NSTextAlignmentCenter;
                
                MonthLable.text=[[Concatarry objectAtIndex:0] uppercaseString];
                
                
                
                //Set match name
                
                
                
                UILabel *MatchNameName=(UILabel *)[matchMainView viewWithTag:304];
                
                MatchNameName.font=[UIFont fontWithName:@"MyriadPro-Semibold" size:18.0f];
                
                MatchNameName.textColor=[UIColor whiteColor];
                
                MatchNameName.textAlignment=NSTextAlignmentLeft;
                
                MatchNameName.text=[Mutdicmatch valueForKey:@"MatchTitle"];
                
                
                
                //course name
                
                
                
                UILabel *CourseNmae=(UILabel *)[matchMainView viewWithTag:303];
                
                CourseNmae.font=[UIFont fontWithName:@"MyriadProLight" size:16.0f];
                
                CourseNmae.textColor=[UIColor whiteColor];
                
                CourseNmae.textAlignment=NSTextAlignmentLeft;
                CourseNmae.text=[Mutdicmatch valueForKey:@"MatchCourse"];
                
                
                
                
                NSString *BackgroundImageStgring=[Mutdicmatch valueForKey:@"MatchCoverImage"];
                
                
                UIImageView *BackgrounImageViewForimagedownload=(UIImageView *)[matchMainView viewWithTag:9999999];
                
                NSURLRequest *request_img = [NSURLRequest requestWithURL:[NSURL URLWithString:BackgroundImageStgring]];
                
                
                
                AFImageRequestOperation *operationDownloadimage = [AFImageRequestOperation imageRequestOperationWithRequest:request_img
                                                                   
                                                                                                       imageProcessingBlock:nil
                                                                   
                                                                                                                    success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                                                                                        
                                                                                                                        if(image!=nil)
                                                                                                                            
                                                                                                                        {
                                                                                                                            
                                                                                                                            
                                                                                                                            
                                                                                                                            [BackgrounImageViewForimagedownload setImage:image];
                                                                                                                            
                                                                                                                            
                                                                                                                            
                                                                                                                            
                                                                                                                            
                                                                                                                        }
                                                                                                                        
                                                                                                                        
                                                                                                                        
                                                                                                                    }
                                                                   
                                                                                                                    failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                                                                                                        
                                                                                                                        
                                                                                                                        
                                                                                                                        
                                                                                                                        
                                                                                                                    }];
                
                [operationDownloadimage start];
                
                
                
                //------------------------ Do Leader bord array ---------------------//
                
                
                UIView *LeaderBord1=(UIView *)[matchMainView viewWithTag:33331];
                UIView *LeaderBord2=(UIView *)[matchMainView viewWithTag:33332];
                UIView *LeaderBord3=(UIView *)[matchMainView viewWithTag:33333];
                
                CGRect FrameLeaderBord1=[LeaderBord1 frame];
                CGRect FrameLeaderBord2=[LeaderBord2 frame];
                
                NSMutableArray *Leaderbordarry=[CommentACtivityDic objectForKey:@"MatchLeaderbord"];
                NSInteger Numbor=[[CommentACtivityDic objectForKey:@"MatchLeaderbord"] count];
                
                
                if (Numbor==1)
                {
                    NSMutableDictionary *Dicleaderbord=[Leaderbordarry objectAtIndex:0];
                    UIView *Imagebackview=(UIView *)[LeaderBord1 viewWithTag:700];
                    [self SetroundborderWithborderWidth:2.0f WithColour:[UIColor whiteColor] ForView:Imagebackview];
                    UIImageView *BordImage=(UIImageView *)[LeaderBord1 viewWithTag:701];
                    [self SetroundborderWithborderWidth:0.0f WithColour:[UIColor clearColor] ForImageview:BordImage];
                    
                    NSURLRequest *request_imgleaderbord = [NSURLRequest requestWithURL:[NSURL URLWithString:[Dicleaderbord valueForKey:@"PlayerImage"]]];
                    AFImageRequestOperation *operationLeaderbord = [AFImageRequestOperation imageRequestOperationWithRequest:request_imgleaderbord
                                                                    
                                                                                                        imageProcessingBlock:nil
                                                                    
                                                                                                                     success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                                                                                         
                                                                                                                         if(image!=nil)
                                                                                                                             
                                                                                                                         {
                                                                                                                             
                                                                                                                             
                                                                                                                             
                                                                                                                             [BordImage setImage:image];
                                                                                                                             
                                                                                                                             
                                                                                                                             
                                                                                                                             
                                                                                                                             
                                                                                                                         }
                                                                                                                         
                                                                                                                         
                                                                                                                         
                                                                                                                     }
                                                                    
                                                                                                                     failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                                                                                                         
                                                                                                                         
                                                                                                                         
                                                                                                                         NSLog(@"Error %@",error);
                                                                                                                         
                                                                                                                     }];
                    
                    [operationLeaderbord start];
                    
                    UILabel *matchScoreLbl=(UILabel *)[LeaderBord1 viewWithTag:1003];
                    matchScoreLbl.font=[UIFont fontWithName:MYRIARDPROLIGHT size:18.0f];
                    matchScoreLbl.text=[Dicleaderbord valueForKey:@"MatchNetScore"];
                    [LeaderBord1 setFrame:FrameLeaderBord2];
                    [LeaderBord2 removeFromSuperview];
                    [LeaderBord3 removeFromSuperview];
                    
                }
                else if (Numbor==2)
                {
                    for (int i=33331; i<33333; i++)
                    {
                        UIView *leaderBordview=(UIView *)[matchMainView viewWithTag:i];
                        NSMutableDictionary *Dicleaderbord=[Leaderbordarry objectAtIndex:0];
                        UIView *Imagebackview=(UIView *)[leaderBordview viewWithTag:700];
                        [self SetroundborderWithborderWidth:2.0f WithColour:[UIColor whiteColor] ForView:Imagebackview];
                        UIImageView *BordImage=(UIImageView *)[leaderBordview viewWithTag:701];
                        [self SetroundborderWithborderWidth:0.0f WithColour:[UIColor clearColor] ForImageview:BordImage];
                        
                        NSURLRequest *request_imgleaderbord = [NSURLRequest requestWithURL:[NSURL URLWithString:[Dicleaderbord valueForKey:@"PlayerImage"]]];
                        AFImageRequestOperation *operationLeaderbord = [AFImageRequestOperation imageRequestOperationWithRequest:request_imgleaderbord
                                                                        
                                                                                                            imageProcessingBlock:nil
                                                                        
                                                                                                                         success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                                                                                             
                                                                                                                             if(image!=nil)
                                                                                                                                 
                                                                                                                             {
                                                                                                                                 
                                                                                                                                 
                                                                                                                                 
                                                                                                                                 [BordImage setImage:image];
                                                                                                                                 
                                                                                                                                 
                                                                                                                                 
                                                                                                                                 
                                                                                                                                 
                                                                                                                             }
                                                                                                                             
                                                                                                                             
                                                                                                                             
                                                                                                                         }
                                                                        
                                                                                                                         failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                                                                                                             
                                                                                                                             
                                                                                                                             
                                                                                                                             NSLog(@"Error %@",error);
                                                                                                                             
                                                                                                                         }];
                        
                        [operationLeaderbord start];
                        
                        //--------------------Match Score Lable----------------------//
                        
                        
                        UILabel *matchScoreLbl=(UILabel *)[LeaderBord1 viewWithTag:1003];
                        matchScoreLbl.font=[UIFont fontWithName:MYRIARDPROLIGHT size:18.0f];
                        matchScoreLbl.text=[Dicleaderbord valueForKey:@"MatchNetScore"];
                        
                        
                    }
                    FrameLeaderBord1.origin.x+=40;
                    FrameLeaderBord2.origin.x+=40;
                    [LeaderBord1 setFrame:FrameLeaderBord1];
                    [LeaderBord2 setFrame:FrameLeaderBord2];
                    [LeaderBord3 removeFromSuperview];
                }
                else
                {
                    for (int i=33333; i<=33333; i++)
                    {
                        UIView *leaderBordview=(UIView *)[matchMainView viewWithTag:i];
                        NSMutableDictionary *Dicleaderbord=[Leaderbordarry objectAtIndex:0];
                        UIView *Imagebackview=(UIView *)[leaderBordview viewWithTag:700];
                        [self SetroundborderWithborderWidth:2.0f WithColour:[UIColor whiteColor] ForView:Imagebackview];
                        UIImageView *BordImage=(UIImageView *)[leaderBordview viewWithTag:701];
                        [self SetroundborderWithborderWidth:0.0f WithColour:[UIColor clearColor] ForImageview:BordImage];
                        
                        NSURLRequest *request_imgleaderbord = [NSURLRequest requestWithURL:[NSURL URLWithString:[Dicleaderbord valueForKey:@"PlayerImage"]]];
                        AFImageRequestOperation *operationLeaderbord = [AFImageRequestOperation imageRequestOperationWithRequest:request_imgleaderbord
                                                                        
                                                                                                            imageProcessingBlock:nil
                                                                        
                                                                                                                         success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                                                                                             
                                                                                                                             if(image!=nil)
                                                                                                                                 
                                                                                                                             {
                                                                                                                                 
                                                                                                                                 
                                                                                                                                 
                                                                                                                                 [BordImage setImage:image];
                                                                                                                                 
                                                                                                                                 
                                                                                                                                 
                                                                                                                                 
                                                                                                                                 
                                                                                                                             }
                                                                                                                             
                                                                                                                             
                                                                                                                             
                                                                                                                         }
                                                                        
                                                                                                                         failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                                                                                                             
                                                                                                                             
                                                                                                                             
                                                                                                                             NSLog(@"Error %@",error);
                                                                                                                             
                                                                                                                         }];
                        
                        [operationLeaderbord start];
                        
                        
                        //-------------------- Match Score Lable ----------------------//
                        
                        
                        UILabel *matchScoreLbl=(UILabel *)[LeaderBord1 viewWithTag:1003];
                        matchScoreLbl.font=[UIFont fontWithName:MYRIARDPROLIGHT size:18.0f];
                        matchScoreLbl.text=[Dicleaderbord valueForKey:@"MatchNetScore"];
                        
                        
                    }
                }
                
                
                
                //date lable creation For 21( according to design psd)
                
                
                
                
                
                MatchMainviewFrame.origin.y+=extraHeight;
                [matchMainView setFrame:MatchMainviewFrame];
                
                
                //------------------------------Footer View ---------------------//
                //Section three//
                
                UIView *Vfooterview=(UIView *)[matchCell.contentView viewWithTag:8];
                CGRect footerFrame =[Vfooterview frame];
                [Vfooterview setHidden:YES];
                //TotalTee Lable
                
                UILabel *Totaltee=(UILabel *)[matchCell.contentView viewWithTag:9];
                Totaltee.textColor=[UIColor whiteColor];
                Totaltee.font=[UIFont fontWithName:MYRIARDPROLIGHT size:14.0f];
                Totaltee.text=[CommentACtivityDic objectForKey:@"ActivityLikeCount"];
                
                //Total Comment Lable
                
                UILabel *TotalteeTextLBL=(UILabel *)[matchCell.contentView viewWithTag:10];
                TotalteeTextLBL.textColor=[UIColor whiteColor];
                TotalteeTextLBL.font=[UIFont fontWithName:MYRIARDPROLIGHT size:14.0f];
                
                //total comment lable
                
                UILabel *TotalComment=(UILabel *)[matchCell.contentView viewWithTag:12];
                TotalComment.font=[UIFont fontWithName:MYRIARDPROLIGHT size:14.0f];
                TotalComment.textColor=[UIColor whiteColor];
                TotalComment.text=[CommentACtivityDic objectForKey:@"ActivityCommentCount"];
                
                //Total comment text lable
                
                UILabel *totalCommentTxtLBL=(UILabel *)[matchCell.contentView viewWithTag:11];
                totalCommentTxtLBL.font=[UIFont fontWithName:MYRIARDPROLIGHT size:14.0f];
                totalCommentTxtLBL.textColor=[UIColor whiteColor];
                
                
                //Tee and comment button
                
                IfUserLiked=([[CommentACtivityDic objectForKey:@"ActivityUserLiked"] integerValue]==0)?FALSE:TRUE;
                IfUserComment=([[CommentACtivityDic objectForKey:@"ActivityUserCommented"] integerValue]==0)?FALSE:TRUE;
                UIButton *TeeBtn=(UIButton *)[matchCell.contentView viewWithTag:14];
                UIButton *CommentBtn=(UIButton *)[matchCell.contentView viewWithTag:13];
                if (IfUserLiked)
                {
                    [TeeBtn setBackgroundImage:[UIImage imageNamed:@"teeball"] forState:UIControlStateNormal];
                    [TeeBtn setBackgroundImage:[UIImage imageNamed:@"teeball"] forState:UIControlStateHighlighted];
                    [TeeBtn setBackgroundImage:[UIImage imageNamed:@"teeball"] forState:UIControlStateSelected];
                    
                }
                else
                {
                    [TeeBtn setBackgroundImage:[UIImage imageNamed:@"teeballLite"] forState:UIControlStateNormal];
                    [TeeBtn setBackgroundImage:[UIImage imageNamed:@"teeballLite"] forState:UIControlStateHighlighted];
                    [TeeBtn setBackgroundImage:[UIImage imageNamed:@"teeballLite"] forState:UIControlStateSelected];
                }
                
                if (IfUserComment)
                {
                    [CommentBtn setBackgroundImage:[UIImage imageNamed:@"commentParmitionhave"] forState:UIControlStateNormal];
                    [CommentBtn setBackgroundImage:[UIImage imageNamed:@"commentParmitionhave"] forState:UIControlStateHighlighted];
                    [CommentBtn setBackgroundImage:[UIImage imageNamed:@"commentParmitionhave"] forState:UIControlStateSelected];
                    
                }
                else
                {
                    [CommentBtn setBackgroundImage:[UIImage imageNamed:@"commentparmitionhavenot"] forState:UIControlStateNormal];
                    [CommentBtn setBackgroundImage:[UIImage imageNamed:@"commentparmitionhavenot"] forState:UIControlStateHighlighted];
                    [CommentBtn setBackgroundImage:[UIImage imageNamed:@"commentparmitionhavenot"] forState:UIControlStateSelected];
                }
                
                [TeeBtn setUserInteractionEnabled:NO];
                [CommentBtn setUserInteractionEnabled:NO];
                
                //Like comment allow or not
                
                if ([[CommentACtivityDic objectForKey:@"ActivityCommentAllow"] integerValue]==1)
                {
                    [CommentBtn addTarget:self action:@selector(CommmentButton:) forControlEvents:UIControlEventTouchUpInside];
                    [CommentBtn setTag:COMMENTTAG+indexPath.row];
                }
                else
                {
                    CommentBtn.hidden=YES;
                }
                if ([[CommentACtivityDic objectForKey:@"ActivityLikeAllow"] integerValue]==1)
                {
                    [TeeBtn addTarget:self action:@selector(teebuttonclick:) forControlEvents:UIControlEventTouchUpInside];
                    [TeeBtn setTag:TEETAG+indexPath.row];
                    
                }
                else
                {
                    TeeBtn.hidden=YES;
                }
                footerFrame.origin.y+=extraHeight;
                [Vfooterview setFrame:footerFrame];
                UIView *MainBackview=(UIView *)[matchCell.contentView viewWithTag:999];
                CGRect Frame=[MainBackview frame];
                Frame.size.height+=extraHeight;
                [MainBackview setFrame:Frame];
                return matchCell;
                
                
            }
            else if ([[CommentACtivityDic valueForKey:@"ActivityType"] integerValue]==3)
            {
                //  -------------------------Normal Event Post match post------------------------------------  //
                
                static NSString *NormalMatch=@"TTTCellFormatchActivity";
                
                TTTCellFormatchActivity *matchCell=[tableView dequeueReusableCellWithIdentifier:NormalMatch];
                matchCell=nil;
                if (matchCell==nil)
                {
                    NSArray *CellNIb=[[NSBundle mainBundle] loadNibNamed:@"TTTCellFormatchActivity" owner:self options:nil];
                    matchCell=(TTTCellFormatchActivity *)[CellNIb objectAtIndex:0];
                    // }
                    //--------------------Section 1 ---------------------//
                    
                    //----------  Download user photo And user image Operation  ------ //
                    
                    CGFloat extraHeight=0.0f;
                    UIView *UserphotobackView=(UIView *)[matchCell.contentView viewWithTag:1];
                    [self SetroundborderWithborderWidth:2.0f WithColour:[UIColor whiteColor] ForView:UserphotobackView];
                    
                    UIImageView *ActivityOwnerimageView=(UIImageView *)[matchCell.contentView viewWithTag:2];
                    [self SetroundborderWithborderWidth:0.0f WithColour:[UIColor clearColor] ForImageview:ActivityOwnerimageView];
                    
                    //--------Download Image in image-------//
                    
                    NSURLRequest *request_img2 = [NSURLRequest requestWithURL:[NSURL URLWithString:[CommentACtivityDic objectForKey:@"ActivityCreatorImage"]]];
                    
                    AFImageRequestOperation *operationProfileimage = [AFImageRequestOperation imageRequestOperationWithRequest:request_img2
                                                                      
                                                                                                          imageProcessingBlock:nil
                                                                      
                                                                                                                       success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                                                                                           
                                                                                                                           if(image!=nil)
                                                                                                                               
                                                                                                                           {
                                                                                                                               
                                                                                                                               ActivityOwnerimageView.image=image;
                                                                                                                               
                                                                                                                               
                                                                                                                               
                                                                                                                           }
                                                                                                                           
                                                                                                                           
                                                                                                                           
                                                                                                                       }
                                                                      
                                                                                                                       failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                                                                                                           
                                                                                                                           NSLog(@"Error %@",error);
                                                                                                                           
                                                                                                                           
                                                                                                                           
                                                                                                                       }];
                    
                    [operationProfileimage start];
                    
                    
                    //--------- Send to profile image view -------//
                    
                    
                    
                    TapGesture=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(SendToProfileView:)];
                    [TapGesture setNumberOfTapsRequired:1];
                    [ActivityOwnerimageView setUserInteractionEnabled:NO];
                    [ActivityOwnerimageView setTag:[[CommentACtivityDic objectForKey:@"ActivityCreator"] integerValue]];
                    [ActivityOwnerimageView addGestureRecognizer:TapGesture];
                    
                    //Activity owner name
                    
                    UILabel *OwnernameLbl=(UILabel *)[matchCell.contentView viewWithTag:3];
                    OwnernameLbl.font=[UIFont fontWithName:MYRIARDPROSAMIBOLT size:16.0f];
                    OwnernameLbl.text=[CommentACtivityDic objectForKey:@"ActivityCreatorTitle"];
                    
                    
                    //Activity Titel Lable
                    
                    UILabel *ActivityTitel=(UILabel *)[matchCell.contentView viewWithTag:4];
                    CGRect activityframe=[ActivityTitel frame];
                    ActivityTitel.font=[UIFont fontWithName:MYRIARDPROLIGHT size:15.0f];
                    ActivityTitel.textColor=[UIColor whiteColor];
                    ActivityTitel.textAlignment=NSTextAlignmentLeft;
                    
                    CGRect ActivityTitelframe = [[CommentACtivityDic objectForKey:@"ActivityTitle"] boundingRectWithSize:CGSizeMake(230, MAXFLOAT)
                                                                                                                 options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                                                                              attributes:@{NSFontAttributeName:[UIFont fontWithName:MYRIARDPROLIGHT size:15.0f]
                                                                                                                           }
                                                                                                                 context:nil];
                    
                    extraHeight=(ActivityTitelframe.size.height>21)?ActivityTitelframe.size.height-21:0.0f;
                    
                    ActivityTitel.text=[CommentACtivityDic objectForKey:@"ActivityTitle"];
                    [ActivityTitel setNumberOfLines:0];
                    [ActivityTitel setLineBreakMode:NSLineBreakByWordWrapping];
                    activityframe.size.height+=extraHeight;
                    [ActivityTitel setFrame:activityframe];
                    
                    //Activity posted time from privious time
                    
                    UILabel *PostTimeLBL=(UILabel *)[matchCell.contentView viewWithTag:5];
                    PostTimeLBL.textColor=[UIColor whiteColor];
                    PostTimeLBL.font=[UIFont fontWithName:MYRIARDPROLIGHT size:13.0f];
                    PostTimeLBL.text=[CommentACtivityDic objectForKey:@"ActivityCreatedDate"];
                    
                    //-----------------------------------Section 2 --------------------------------//
                    //match portion//
                    
                    UIView *matchMainView=(UIView *)[matchCell.contentView viewWithTag:109];
                    CGRect MatchMainviewFrame=[matchMainView frame];
                    
                    NSMutableDictionary *Mutdicmatch=[CommentACtivityDic objectForKey:@"MatchDetails"];
                    
                    NSString *BackgroundImageStgring=[Mutdicmatch valueForKey:@"MatchCoverImage"];
                    
                    
                    
                    UIImageView *BackgrounImage=(UIImageView *)[matchCell.contentView viewWithTag:100];
                    
                    NSURLRequest *request_img = [NSURLRequest requestWithURL:[NSURL URLWithString:BackgroundImageStgring]];
                    
                    
                    
                    AFImageRequestOperation *operation = [AFImageRequestOperation imageRequestOperationWithRequest:request_img
                                                          
                                                                                              imageProcessingBlock:nil
                                                          
                                                                                                           success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                                                                               
                                                                                                               if(image!=nil)
                                                                                                                   
                                                                                                               {
                                                                                                                   
                                                                                                                   
                                                                                                                   
                                                                                                                   [BackgrounImage setImage:image];
                                                                                                                   
                                                                                                                   
                                                                                                                   
                                                                                                                   
                                                                                                                   
                                                                                                               }
                                                                                                               
                                                                                                               
                                                                                                               
                                                                                                           }
                                                          
                                                                                                           failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                                                                                               
                                                                                                               
                                                                                                               
                                                                                                               NSLog(@"Error %@",error);
                                                                                                               
                                                                                                           }];
                    
                    [operation start];
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    //date lable creation For 21( according to design psd)
                    
                    
                    
                    NSString *dateAndTime=[Mutdicmatch valueForKey:@"MatchStartDate"];
                    
                    NSArray *Concatarry=[dateAndTime componentsSeparatedByString:@" "];
                    
                    
                    
                    UILabel *dateLable=(UILabel *)[matchCell.contentView viewWithTag:102];
                    
                    dateLable.font=[UIFont fontWithName:@"MyriadProLight" size:23.0f];
                    
                    dateLable.textColor=[UIColor whiteColor];
                    
                    dateLable.textAlignment=NSTextAlignmentCenter;
                    
                    dateLable.text=[Concatarry objectAtIndex:1];
                    
                    
                    
                    //Show month in short like DEC
                    
                    
                    
                    UILabel *MonthLable=(UILabel *)[matchCell.contentView viewWithTag:103];
                    
                    MonthLable.font=[UIFont fontWithName:@"MyriadProLight" size:13.0f];
                    
                    
                    
                    MonthLable.textColor=[UIColor whiteColor];
                    
                    MonthLable.textAlignment=NSTextAlignmentCenter;
                    
                    MonthLable.text=[[Concatarry objectAtIndex:0] uppercaseString];
                    
                    
                    
                    //Set course name
                    
                    
                    
                    UILabel *MatchNameName=(UILabel *)[matchCell.contentView viewWithTag:104];
                    MatchNameName.font=[UIFont fontWithName:@"MyriadPro-Semibold" size:18.0f];
                    
                    MatchNameName.textColor=[UIColor whiteColor];
                    
                    MatchNameName.textAlignment=NSTextAlignmentLeft;
                    
                    MatchNameName.text=[Mutdicmatch valueForKey:@"MatchTitle"];
                    
                    
                    //course name
                    
                    
                    
                    UILabel *CourseNmae=(UILabel *)[matchCell.contentView viewWithTag:105];
                    
                    CourseNmae.font=[UIFont fontWithName:@"MyriadProLight" size:16.0f];
                    
                    CourseNmae.layer.opacity=2.0f;
                    
                    CourseNmae.textColor=[UIColor whiteColor];
                    
                    CourseNmae.textAlignment=NSTextAlignmentLeft;
                    
                    NSAttributedString *attributedText =
                    
                    [[NSAttributedString alloc]
                     
                     initWithString:[self RemoveNullandreplaceWithSpace:[Mutdicmatch valueForKey:@"MatchCourse"]]
                     
                     attributes:@
                     
                     {
                         
                     NSFontAttributeName:[UIFont fontWithName:MYRIARDPROLIGHT size:15.0f]
                         
                     }];
                    
                    
                    
                    CGRect rect = [attributedText boundingRectWithSize:(CGSize){300, 21}
                                   
                                                               options:NSStringDrawingUsesLineFragmentOrigin
                                   
                                                               context:nil];
                    
                    CGSize size = rect.size;
                    
                    CourseNmae.frame=CGRectMake(CourseNmae.frame.origin.x, CourseNmae.frame.origin.y, size.width+10, 21);
                    
                    CourseNmae.text=[self RemoveNullandreplaceWithSpace:[Mutdicmatch valueForKey:@"MatchCourse"]];
                    
                    
                    
                    UIView *TeeBoxview=(UIView *)[matchCell.contentView viewWithTag:100000];
                    CGRect TeeBoxframe=[TeeBoxview frame];
                    
                    [self  SetroundborderWithborderWidth:0.0f WithColour:[UIColor clearColor] ForView:TeeBoxview];
                    [TeeBoxview setBackgroundColor:[TTTGlobalMethods colorFromHexString:[Mutdicmatch valueForKey:@"MatchTeeboxColor"]]];
                    TeeBoxframe.origin.x=CourseNmae.frame.origin.x+size.width+10;
                    [TeeBoxview setFrame:TeeBoxframe];
                    
                    //-----------------------Big Time lable----------------------------------//
                    
                    UILabel *bigTimelable=(UILabel *)[matchCell.contentView viewWithTag:106];
                    
                    bigTimelable.textAlignment=NSTextAlignmentLeft;
                    
                    bigTimelable.font=[UIFont fontWithName:SEGIOUI size:28.0f];
                    
                    bigTimelable.textColor=[UIColor whiteColor];
                    
                    [bigTimelable setText:[Mutdicmatch valueForKey:@"MatchStartTime"]];
                    
                    
                    
                    
                    
                    //join button
                    
                    UIButton *joinButton=(UIButton *)[matchCell.contentView viewWithTag:107];
                    
                    [joinButton addTarget:self action:@selector(gotonext) forControlEvents:UIControlEventTouchUpInside];
                    
                    
                    
                    if ([[Mutdicmatch valueForKey:@"MatchJoinStatus"] integerValue]==0)
                    {
                        
                        joinButton.hidden=YES;
                        
                    }
                    MatchMainviewFrame.origin.y+=extraHeight;
                    [matchMainView setFrame:MatchMainviewFrame];
                    
                    
                    //------------------------------Footer View ---------------------//
                    //Section three//
                    
                    UIView *Vfooterview=(UIView *)[matchCell.contentView viewWithTag:8];
                    CGRect footerFrame =[Vfooterview frame];
                    [Vfooterview setHidden:YES];
                    //TotalTee Lable
                    
                    UILabel *Totaltee=(UILabel *)[matchCell.contentView viewWithTag:9];
                    Totaltee.textColor=[UIColor whiteColor];
                    Totaltee.font=[UIFont fontWithName:MYRIARDPROLIGHT size:14.0f];
                    Totaltee.text=[CommentACtivityDic objectForKey:@"ActivityLikeCount"];
                    
                    //Total Comment Lable
                    
                    UILabel *TotalteeTextLBL=(UILabel *)[matchCell.contentView viewWithTag:10];
                    TotalteeTextLBL.textColor=[UIColor whiteColor];
                    TotalteeTextLBL.font=[UIFont fontWithName:MYRIARDPROLIGHT size:14.0f];
                    
                    //total comment lable
                    
                    UILabel *TotalComment=(UILabel *)[matchCell.contentView viewWithTag:12];
                    TotalComment.font=[UIFont fontWithName:MYRIARDPROLIGHT size:14.0f];
                    TotalComment.textColor=[UIColor whiteColor];
                    TotalComment.text=[CommentACtivityDic objectForKey:@"ActivityCommentCount"];
                    
                    //Total comment text lable
                    
                    UILabel *totalCommentTxtLBL=(UILabel *)[matchCell.contentView viewWithTag:11];
                    totalCommentTxtLBL.font=[UIFont fontWithName:MYRIARDPROLIGHT size:14.0f];
                    totalCommentTxtLBL.textColor=[UIColor whiteColor];
                    
                    
                    //Tee and comment button
                    
                    IfUserLiked=([[CommentACtivityDic objectForKey:@"ActivityUserLiked"] integerValue]==0)?FALSE:TRUE;
                    IfUserComment=([[CommentACtivityDic objectForKey:@"ActivityUserCommented"] integerValue]==0)?FALSE:TRUE;
                    UIButton *TeeBtn=(UIButton *)[matchCell.contentView viewWithTag:14];
                    UIButton *CommentBtn=(UIButton *)[matchCell.contentView viewWithTag:13];
                    if (IfUserLiked)
                    {
                        [TeeBtn setBackgroundImage:[UIImage imageNamed:@"teeball"] forState:UIControlStateNormal];
                        [TeeBtn setBackgroundImage:[UIImage imageNamed:@"teeball"] forState:UIControlStateHighlighted];
                        [TeeBtn setBackgroundImage:[UIImage imageNamed:@"teeball"] forState:UIControlStateSelected];
                        
                    }
                    else
                    {
                        [TeeBtn setBackgroundImage:[UIImage imageNamed:@"teeballLite"] forState:UIControlStateNormal];
                        [TeeBtn setBackgroundImage:[UIImage imageNamed:@"teeballLite"] forState:UIControlStateHighlighted];
                        [TeeBtn setBackgroundImage:[UIImage imageNamed:@"teeballLite"] forState:UIControlStateSelected];
                    }
                    
                    if (IfUserComment)
                    {
                        [CommentBtn setBackgroundImage:[UIImage imageNamed:@"commentParmitionhave"] forState:UIControlStateNormal];
                        [CommentBtn setBackgroundImage:[UIImage imageNamed:@"commentParmitionhave"] forState:UIControlStateHighlighted];
                        [CommentBtn setBackgroundImage:[UIImage imageNamed:@"commentParmitionhave"] forState:UIControlStateSelected];
                        
                    }
                    else
                    {
                        [CommentBtn setBackgroundImage:[UIImage imageNamed:@"commentparmitionhavenot"] forState:UIControlStateNormal];
                        [CommentBtn setBackgroundImage:[UIImage imageNamed:@"commentparmitionhavenot"] forState:UIControlStateHighlighted];
                        [CommentBtn setBackgroundImage:[UIImage imageNamed:@"commentparmitionhavenot"] forState:UIControlStateSelected];
                    }
                    
                    [TeeBtn setUserInteractionEnabled:NO];
                    [CommentBtn setUserInteractionEnabled:NO];
                    
                    
                    //Like comment allow or not
                    
                    if ([[CommentACtivityDic objectForKey:@"ActivityCommentAllow"] integerValue]==1)
                    {
                        [CommentBtn addTarget:self action:@selector(CommmentButton:) forControlEvents:UIControlEventTouchUpInside];
                        [CommentBtn setTag:COMMENTTAG+indexPath.row];
                    }
                    else
                    {
                        CommentBtn.hidden=YES;
                    }
                    if ([[CommentACtivityDic objectForKey:@"ActivityLikeAllow"] integerValue]==1)
                    {
                        [TeeBtn addTarget:self action:@selector(teebuttonclick:) forControlEvents:UIControlEventTouchUpInside];
                        [TeeBtn setTag:TEETAG+indexPath.row];
                        
                    }
                    else
                    {
                        TeeBtn.hidden=YES;
                    }
                    footerFrame.origin.y+=extraHeight;
                    [Vfooterview setFrame:footerFrame];
                    UIView *Backview=(UIView *)[matchCell.contentView viewWithTag:999];
                    CGRect Backframe=[Backview frame];
                    Backframe.size.height+=extraHeight;
                    [Backview setFrame:Backframe];
                }
                return matchCell;
                
                
            }
            
            
            
            
            else if ([[CommentACtivityDic valueForKey:@"ActivityType"] integerValue]==4)
            {
                
                //--------------------Activity Accept friend Request----------------//
                
                static NSString *friendDeque=@"TTTCellforAcceptFriendrequest";
                TTTCellforAcceptFriendrequest *FriendCell=(TTTCellforAcceptFriendrequest *)[tableView dequeueReusableCellWithIdentifier:friendDeque];
                
                if (FriendCell==nil)
                {
                    NSArray *CellNib=[[NSBundle mainBundle] loadNibNamed:@"TTTCellforAcceptFriendrequest" owner:self options:nil];
                    FriendCell=(TTTCellforAcceptFriendrequest *)[CellNib objectAtIndex:0];
                }
                FriendCell.backgroundColor=[UIColor clearColor];
                [FriendCell setSelectionStyle:UITableViewCellSelectionStyleNone];
                UIView *CreaterbackView=(UIView *)[FriendCell.contentView viewWithTag:1];
                UIImageView *CreaterImageView=(UIImageView *)[FriendCell.contentView viewWithTag:2];
                
                UIView *TargetbackView=(UIView *)[FriendCell.contentView viewWithTag:3];
                UIImageView *TargetImageView=(UIImageView *)[FriendCell.contentView viewWithTag:4];
                
                [self SetroundborderWithborderWidth:0.0f WithColour:[UIColor clearColor] ForImageview:CreaterImageView];
                [self SetroundborderWithborderWidth:0.0f WithColour:[UIColor clearColor] ForImageview:TargetImageView];
                
                [self SetroundborderWithborderWidth:2.0f WithColour:[UIColor whiteColor] ForView:CreaterbackView];
                [self SetroundborderWithborderWidth:2.0f WithColour:[UIColor whiteColor] ForView:TargetbackView];
                
                NSURLRequest *request_img2 = [NSURLRequest requestWithURL:[NSURL URLWithString:[CommentACtivityDic objectForKey:@"ActivityCreatorImage"]]];
                
                //Down load creater image
                
                AFImageRequestOperation *operationProfileimage = [AFImageRequestOperation imageRequestOperationWithRequest:request_img2
                                                                  
                                                                                                      imageProcessingBlock:nil
                                                                  
                                                                                                                   success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                                                                                       
                                                                                                                       if(image!=nil)
                                                                                                                           
                                                                                                                       {
                                                                                                                           
                                                                                                                           CreaterImageView.image=image;
                                                                                                                           
                                                                                                                           
                                                                                                                           
                                                                                                                       }
                                                                                                                       
                                                                                                                       
                                                                                                                       
                                                                                                                   }
                                                                  
                                                                                                                   failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                                                                                                       
                                                                                                                       NSLog(@"Error %@",error);
                                                                                                                       
                                                                                                                       
                                                                                                                       
                                                                                                                   }];
                
                [operationProfileimage start];
                
                
                //------------------- download Terget image -------------------//
                
                
                NSURLRequest *request_img3 = [NSURLRequest requestWithURL:[NSURL URLWithString:[CommentACtivityDic objectForKey:@"ActivityTargetImage"]]];
                
                AFImageRequestOperation *operationTergetimage = [AFImageRequestOperation imageRequestOperationWithRequest:request_img3
                                                                 
                                                                                                     imageProcessingBlock:nil
                                                                 
                                                                                                                  success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                                                                                      
                                                                                                                      if(image!=nil)
                                                                                                                          
                                                                                                                      {
                                                                                                                          
                                                                                                                          TargetImageView.image=image;
                                                                                                                          
                                                                                                                          
                                                                                                                          
                                                                                                                      }
                                                                                                                      
                                                                                                                      
                                                                                                                      
                                                                                                                  }
                                                                 
                                                                                                                  failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                                                                                                      
                                                                                                                      NSLog(@"Error %@",error);
                                                                                                                      
                                                                                                                      
                                                                                                                      
                                                                                                                  }];
                
                [operationTergetimage start];
                
                
                //--------------------- Sending to profile page -----------------//
                
                
                TapGesture=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(SendToProfileView:)];
                [TapGesture setNumberOfTapsRequired:1];
                [CreaterImageView setUserInteractionEnabled:NO];
                [CreaterImageView setTag:[[CommentACtivityDic objectForKey:@"ActivityCreator"] integerValue]];
                [TargetImageView setTag:[[CommentACtivityDic objectForKey:@"ActivityTarget"] integerValue]];
                [TargetImageView setUserInteractionEnabled:NO];
                [CreaterImageView addGestureRecognizer:TapGesture];
                [TargetImageView addGestureRecognizer:TapGesture];
                
                NSAttributedString *matchAttribute=[self getAttributedString:[CommentACtivityDic valueForKey:@"ActivityTitle"] HightLightString:[CommentACtivityDic valueForKey:@"ActivityCreatorTitle"] HightLighted2:[CommentACtivityDic valueForKey:@"ActivityTargetTitle"] withFontSize:15.0f];
                
                UILabel *TitelLbl=(UILabel *)[FriendCell.contentView viewWithTag:5];
                TitelLbl.textColor=[UIColor whiteColor];
                [TitelLbl setAttributedText:matchAttribute];
                return FriendCell;
                
            }
            
            
            
            
            else if ([[CommentACtivityDic valueForKey:@"ActivityType"] integerValue]==5)
            {
                
                //-------------- Activity Type photo ----------------//
                static NSString *Activitypost =@"TTTCellForphotoActive";
                
                TTTCellForphotoActivity *PhotoActivity=(TTTCellForphotoActivity *)[tableView dequeueReusableCellWithIdentifier:Activitypost];
                PhotoActivity=nil;
                if (PhotoActivity==nil)
                {
                    NSArray *CellNib=[[NSBundle mainBundle] loadNibNamed:@"TTTCellForphotoActive" owner:self options:nil];
                    PhotoActivity=(TTTCellForphotoActivity *)[CellNib objectAtIndex:0];
                    
                }
                float ImgRatio=[[CommentACtivityDic objectForKey:@"Photowidth"] floatValue]/[[CommentACtivityDic objectForKey:@"Photoheight"] floatValue];
                float NewImgHeight=200.0f/ImgRatio;
                float ExtraHeightForImage=(NewImgHeight > 180.0f)?NewImgHeight-180.0f:0.0f;
                
                
                [PhotoActivity setBackgroundColor:[UIColor clearColor]];
                // Download user photo And user image Operation
                
                CGFloat extraHeight=0.0f;
                UIView *UserphotobackView=(UIView *)[PhotoActivity.contentView viewWithTag:1];
                [self SetroundborderWithborderWidth:2.0f WithColour:[UIColor whiteColor] ForView:UserphotobackView];
                
                UIImageView *ActivityOwnerimageView=(UIImageView *)[PhotoActivity.contentView viewWithTag:2];
                [self SetroundborderWithborderWidth:0.0f WithColour:[UIColor clearColor] ForImageview:ActivityOwnerimageView];
                
                //Download Image in image
                
                NSURLRequest *request_img2 = [NSURLRequest requestWithURL:[NSURL URLWithString:[CommentACtivityDic objectForKey:@"ActivityCreatorImage"]]];
                
                AFImageRequestOperation *operationProfileimage = [AFImageRequestOperation imageRequestOperationWithRequest:request_img2
                                                                  
                                                                                                      imageProcessingBlock:nil
                                                                  
                                                                                                                   success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                                                                                       
                                                                                                                       if(image!=nil)
                                                                                                                           
                                                                                                                       {
                                                                                                                           
                                                                                                                           ActivityOwnerimageView.image=image;
                                                                                                                           
                                                                                                                           
                                                                                                                           
                                                                                                                       }
                                                                                                                       
                                                                                                                       
                                                                                                                       
                                                                                                                   }
                                                                  
                                                                                                                   failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                                                                                                       
                                                                                                                       NSLog(@"Error %@",error);
                                                                                                                       
                                                                                                                       
                                                                                                                       
                                                                                                                   }];
                
                [operationProfileimage start];
                //******  Send to profile image view  *****//
                
                TapGesture=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(SendToProfileView:)];
                [TapGesture setNumberOfTapsRequired:1];
                [ActivityOwnerimageView setUserInteractionEnabled:NO];
                [ActivityOwnerimageView setTag:[[CommentACtivityDic objectForKey:@"ActivityCreator"] integerValue]];
                [ActivityOwnerimageView addGestureRecognizer:TapGesture];
                
                //Activity owner name
                
                UILabel *OwnernameLbl=(UILabel *)[PhotoActivity.contentView viewWithTag:3];
                OwnernameLbl.font=[UIFont fontWithName:MYRIARDPROSAMIBOLT size:16.0f];
                OwnernameLbl.text=[CommentACtivityDic objectForKey:@"ActivityCreatorTitle"];
                
                
                //Activity Titel Lable
                
                UILabel *ActivityTitel=(UILabel *)[PhotoActivity.contentView viewWithTag:4];
                CGRect activityframe=[ActivityTitel frame];
                ActivityTitel.font=[UIFont fontWithName:MYRIARDPROLIGHT size:15.0f];
                ActivityTitel.textColor=[UIColor whiteColor];
                ActivityTitel.textAlignment=NSTextAlignmentLeft;
                
                CGRect ActivityTitelframe = [[CommentACtivityDic objectForKey:@"ActivityTitle"] boundingRectWithSize:CGSizeMake(230, MAXFLOAT)
                                                                                                             options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                                                                          attributes:@{NSFontAttributeName:[UIFont fontWithName:MYRIARDPROLIGHT size:15.0f]
                                                                                                                       }
                                                                                                             context:nil];
                
                extraHeight=(ActivityTitelframe.size.height>16)?ActivityTitelframe.size.height-16:0.0f;
                
                ActivityTitel.text=[CommentACtivityDic objectForKey:@"ActivityTitle"];
                [ActivityTitel setNumberOfLines:0];
                [ActivityTitel setLineBreakMode:NSLineBreakByWordWrapping];
                activityframe.size.height+=extraHeight;
                [ActivityTitel setFrame:activityframe];
                
                //Activity posted time from privious time
                
                UILabel *PostTimeLBL=(UILabel *)[PhotoActivity.contentView viewWithTag:5];
                PostTimeLBL.textColor=[UIColor whiteColor];
                PostTimeLBL.font=[UIFont fontWithName:MYRIARDPROLIGHT size:13.0f];
                PostTimeLBL.text=[CommentACtivityDic objectForKey:@"ActivityCreatedDate"];
                
                
                // Location View Show or hide
                
                UIView *locationView=(UIView *)[PhotoActivity.contentView viewWithTag:400];
                CGRect locationframe=[locationView frame];
                locationframe.origin.y+=extraHeight;
                
                if (![self RemoveNullandreplaceWithSpace:[CommentACtivityDic objectForKey:@"Photolocation"]].length>0)
                {
                    locationView.hidden=YES;
                }
                else
                {
                    UILabel *LocationLBl=(UILabel *)[PhotoActivity.contentView viewWithTag:401];
                    LocationLBl.font=[UIFont fontWithName:MYRIARDPROLIGHT size:11.0f];
                    LocationLBl.textColor=[UIColor whiteColor];
                    LocationLBl.text=[CommentACtivityDic objectForKey:@"Photolocation"];
                    [locationView setFrame:locationframe];
                }
                
                
                // MainActivity Content frame
                //Downlod Photo to which the comment is posted main photo for photo activity
                
                UIView *ImageBackview=(UIView *)[PhotoActivity.contentView viewWithTag:9804197];
                ImageBackview.hidden=YES;
                CGRect Backmainframe=[ImageBackview frame];
                
                UIImageView *PhotoImage=(UIImageView *)[PhotoActivity.contentView viewWithTag:403];
                
                
                TapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(SenToimagedetailspage:)];
                [TapGesture setNumberOfTapsRequired:1];
                [PhotoImage setUserInteractionEnabled:NO];
                [PhotoImage setTag:PHOTOCELL+indexPath.row];
                [PhotoImage addGestureRecognizer:TapGesture];
                
                CGRect PhotoTagFrame=[PhotoImage frame];
                NSURLRequest *MainImageDownload = [NSURLRequest requestWithURL:[NSURL URLWithString:[CommentACtivityDic objectForKey:@"Photourl"]]];
                //Extra height for caption
                CGFloat ExtreaContent=0.0f;
                if ([[CommentACtivityDic objectForKey:@"PhotoCaption"] length]>0)
                {
                    
                    UILabel *Caption2Lbl=(UILabel *)[PhotoActivity.contentView viewWithTag:98382];
                    CGRect captionFrame=[Caption2Lbl frame];
                    Caption2Lbl.font=[UIFont fontWithName:MYRIARDPROLIGHT size:15.0f];
                    
                    
                    CGRect ActivityContentTextframe2 = [[CommentACtivityDic objectForKey:@"PhotoCaption"] boundingRectWithSize:CGSizeMake(292, MAXFLOAT)
                                                                                                                       options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                                                                                    attributes:@{NSFontAttributeName:[UIFont fontWithName:MYRIARDPROLIGHT size:15.0f]
                                                                                                                                 }
                                                                                                                       context:nil];
                    
                    ExtreaContent=(ActivityContentTextframe2.size.height>21.0f)?ActivityContentTextframe2.size.height:21.0f;
                    captionFrame.size.height=ExtreaContent;
                    Caption2Lbl.text=[CommentACtivityDic objectForKey:@"PhotoCaption"];
                    Caption2Lbl.numberOfLines=0.0f;
                    Caption2Lbl.lineBreakMode=NSLineBreakByCharWrapping;
                    [Caption2Lbl setFrame:captionFrame];
                    
                }
                else
                {
                    ExtreaContent=0.0f;
                }
                
                
                UILabel *ActivityContent=(UILabel *)[PhotoActivity.contentView viewWithTag:1111111];
                ActivityContent.font=[UIFont fontWithName:MYRIARDPROLIGHT size:15.0f];
                ActivityContent.textColor=[UIColor whiteColor];
                CGFloat ExtraHightforcontent=0.0f;
                
                CGRect ActivityContentframe=[ActivityContent frame];
                
                
                CGRect ActivityContentTextframe = [[CommentACtivityDic objectForKey:@"PhotoComment"] boundingRectWithSize:CGSizeMake(292, MAXFLOAT)
                                                                                                                  options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                                                                               attributes:@{NSFontAttributeName:[UIFont fontWithName:MYRIARDPROLIGHT size:15.0f]
                                                                                                                            }
                                                                                                                  context:nil];
                
                ExtraHightforcontent=(ActivityContentTextframe.size.height>21.0f)?ActivityContentTextframe.size.height-21:0.0f;
                
                
                //Set frame to the activity content.........
                ActivityContentframe.origin.y+=extraHeight+ExtreaContent+ExtraHeightForImage;
                ActivityContentframe.size.height+=ExtraHightforcontent;
                [ActivityContent setText:[CommentACtivityDic objectForKey:@"PhotoComment"]];
                [ActivityContent setLineBreakMode:NSLineBreakByWordWrapping];
                [ActivityContent setNumberOfLines:0];
                
                [ActivityContent setFrame:ActivityContentframe];
                
                
                
                
                //Downloading image
                
                AFImageRequestOperation *mainImageDownload = [AFImageRequestOperation imageRequestOperationWithRequest:MainImageDownload
                                                              
                                                                                                  imageProcessingBlock:nil
                                                              
                                                                                                               success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                                                                                   
                                                                                                                   if(image!=nil)
                                                                                                                       
                                                                                                                   {
                                                                                                                       
                                                                                                                       PhotoImage.image=image;
                                                                                                                       
                                                                                                                       
                                                                                                                       
                                                                                                                   }
                                                                                                                   
                                                                                                                   
                                                                                                                   
                                                                                                               }
                                                              
                                                                                                               failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                                                                                                   
                                                                                                                   NSLog(@"Error %@",error);
                                                                                                                   
                                                                                                                   
                                                                                                                   
                                                                                                               }];
                
                [mainImageDownload start];
                
                PhotoTagFrame.origin.y+=extraHeight+ExtreaContent;
                PhotoTagFrame.size.height+=ExtraHeightForImage;
                [PhotoImage setFrame:PhotoTagFrame];
                
                Backmainframe.origin.y+=extraHeight+ExtreaContent+ExtraHeightForImage;
                [ImageBackview setFrame:Backmainframe];
                
                //---------------------------Like commnt area-------------------------//
                //----Footer Section----//
                
                //Footer portion like comment area and total comment
                
                UIView *Vfooterview=(UIView *)[PhotoActivity.contentView viewWithTag:8];
                CGRect footerFrame =[Vfooterview frame];
                [Vfooterview setHidden:YES];
                //TotalTee Lable
                
                UILabel *Totaltee=(UILabel *)[PhotoActivity.contentView viewWithTag:9];
                Totaltee.textColor=[UIColor whiteColor];
                Totaltee.font=[UIFont fontWithName:MYRIARDPROLIGHT size:14.0f];
                Totaltee.text=[CommentACtivityDic objectForKey:@"ActivityLikeCount"];
                
                //Total Comment Lable
                
                UILabel *TotalteeTextLBL=(UILabel *)[PhotoActivity.contentView viewWithTag:10];
                TotalteeTextLBL.textColor=[UIColor whiteColor];
                TotalteeTextLBL.font=[UIFont fontWithName:MYRIARDPROLIGHT size:14.0f];
                
                //total comment lable
                
                UILabel *TotalComment=(UILabel *)[PhotoActivity.contentView viewWithTag:12];
                TotalComment.font=[UIFont fontWithName:MYRIARDPROLIGHT size:14.0f];
                TotalComment.textColor=[UIColor whiteColor];
                TotalComment.text=[CommentACtivityDic objectForKey:@"ActivityCommentCount"];
                
                //Total comment text lable
                
                UILabel *totalCommentTxtLBL=(UILabel *)[PhotoActivity.contentView viewWithTag:11];
                totalCommentTxtLBL.font=[UIFont fontWithName:MYRIARDPROLIGHT size:14.0f];
                totalCommentTxtLBL.textColor=[UIColor whiteColor];
                
                
                //Tee and comment button
                
                IfUserLiked=([[CommentACtivityDic objectForKey:@"ActivityUserLiked"] integerValue]==0)?FALSE:TRUE;
                IfUserComment=([[CommentACtivityDic objectForKey:@"ActivityUserCommented"] integerValue]==0)?FALSE:TRUE;
                UIButton *TeeBtn=(UIButton *)[PhotoActivity.contentView viewWithTag:14];
                UIButton *CommentBtn=(UIButton *)[PhotoActivity.contentView viewWithTag:13];
                if (IfUserLiked)
                {
                    [TeeBtn setBackgroundImage:[UIImage imageNamed:@"teeball"] forState:UIControlStateNormal];
                    [TeeBtn setBackgroundImage:[UIImage imageNamed:@"teeball"] forState:UIControlStateHighlighted];
                    [TeeBtn setBackgroundImage:[UIImage imageNamed:@"teeball"] forState:UIControlStateSelected];
                    
                }
                else
                {
                    [TeeBtn setBackgroundImage:[UIImage imageNamed:@"teeballLite"] forState:UIControlStateNormal];
                    [TeeBtn setBackgroundImage:[UIImage imageNamed:@"teeballLite"] forState:UIControlStateHighlighted];
                    [TeeBtn setBackgroundImage:[UIImage imageNamed:@"teeballLite"] forState:UIControlStateSelected];
                }
                
                if (IfUserComment)
                {
                    [CommentBtn setBackgroundImage:[UIImage imageNamed:@"commentParmitionhave"] forState:UIControlStateNormal];
                    [CommentBtn setBackgroundImage:[UIImage imageNamed:@"commentParmitionhave"] forState:UIControlStateHighlighted];
                    [CommentBtn setBackgroundImage:[UIImage imageNamed:@"commentParmitionhave"] forState:UIControlStateSelected];
                    
                }
                else
                {
                    [CommentBtn setBackgroundImage:[UIImage imageNamed:@"commentparmitionhavenot"] forState:UIControlStateNormal];
                    [CommentBtn setBackgroundImage:[UIImage imageNamed:@"commentparmitionhavenot"] forState:UIControlStateHighlighted];
                    [CommentBtn setBackgroundImage:[UIImage imageNamed:@"commentparmitionhavenot"] forState:UIControlStateSelected];
                }
                
                
                
                //Like comment allow or not
                
                if ([[CommentACtivityDic objectForKey:@"ActivityCommentAllow"] integerValue]==1)
                {
                    [CommentBtn addTarget:self action:@selector(CommmentButton:) forControlEvents:UIControlEventTouchUpInside];
                    [CommentBtn setTag:COMMENTTAG+indexPath.row];
                }
                else
                {
                    CommentBtn.hidden=YES;
                }
                if ([[CommentACtivityDic objectForKey:@"ActivityLikeAllow"] integerValue]==1)
                {
                    [TeeBtn addTarget:self action:@selector(teebuttonclick:) forControlEvents:UIControlEventTouchUpInside];
                    [TeeBtn setTag:TEETAG+indexPath.row];
                    
                }
                else
                {
                    TeeBtn.hidden=YES;
                }
                if ([[CommentACtivityDic objectForKey:@"PhotoComment"] length]>0)
                {
                    footerFrame.origin.y+=extraHeight+ExtraHightforcontent+ExtreaContent+ExtraHeightForImage;
                    [Vfooterview setFrame:footerFrame];
                    UIView *bacKView=[PhotoActivity.contentView viewWithTag:999];
                    CGRect FrameBackview=[bacKView frame];
                    FrameBackview.size.height+=extraHeight+ExtraHightforcontent+ExtreaContent+ExtraHeightForImage;
                    [bacKView setFrame:FrameBackview];
                }
                else
                {
                    footerFrame.origin.y+=extraHeight-14+ExtreaContent+ExtraHeightForImage;
                    [Vfooterview setFrame:footerFrame];
                    UIView *bacKView=[PhotoActivity.contentView viewWithTag:999];
                    CGRect FrameBackview=[bacKView frame];
                    FrameBackview.size.height+=extraHeight-14+ExtreaContent+ExtraHeightForImage;
                    [bacKView setFrame:FrameBackview];
                }
                
                
                return PhotoActivity;
                
            }
            
            
            
            
            else if ([[CommentACtivityDic valueForKey:@"ActivityType"] integerValue]==6)
            {
                
                //-------------------Vedio Section programme---------------------//
                
                static NSString *Activitypost =@"TTTCellForphotoActive";
                
                TTTCellForphotoActivity *PhotoActivity=(TTTCellForphotoActivity *)[tableView dequeueReusableCellWithIdentifier:Activitypost];
                PhotoActivity=nil;
                if (PhotoActivity==nil)
                {
                    NSArray *CellNib=[[NSBundle mainBundle] loadNibNamed:@"TTTCellForphotoActive" owner:self options:nil];
                    PhotoActivity=(TTTCellForphotoActivity *)[CellNib objectAtIndex:0];
                    
                }
                [PhotoActivity setBackgroundColor:[UIColor clearColor]];
                // Download user photo And user image Operation
                
                CGFloat extraHeight=0.0f;
                UIView *UserphotobackView=(UIView *)[PhotoActivity.contentView viewWithTag:1];
                [self SetroundborderWithborderWidth:2.0f WithColour:[UIColor whiteColor] ForView:UserphotobackView];
                
                UIImageView *ActivityOwnerimageView=(UIImageView *)[PhotoActivity.contentView viewWithTag:2];
                [self SetroundborderWithborderWidth:0.0f WithColour:[UIColor clearColor] ForImageview:ActivityOwnerimageView];
                
                //Download Image in image
                
                NSURLRequest *request_img2 = [NSURLRequest requestWithURL:[NSURL URLWithString:[CommentACtivityDic objectForKey:@"ActivityCreatorImage"]]];
                
                AFImageRequestOperation *operationProfileimage = [AFImageRequestOperation imageRequestOperationWithRequest:request_img2
                                                                  
                                                                                                      imageProcessingBlock:nil
                                                                  
                                                                                                                   success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                                                                                       
                                                                                                                       if(image!=nil)
                                                                                                                           
                                                                                                                       {
                                                                                                                           
                                                                                                                           ActivityOwnerimageView.image=image;
                                                                                                                           
                                                                                                                           
                                                                                                                           
                                                                                                                       }
                                                                                                                       
                                                                                                                       
                                                                                                                       
                                                                                                                   }
                                                                  
                                                                                                                   failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                                                                                                       
                                                                                                                       NSLog(@"Error %@",error);
                                                                                                                       
                                                                                                                       
                                                                                                                       
                                                                                                                   }];
                
                [operationProfileimage start];
                //******  Send to profile image view  *****//
                
                TapGesture=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(SendToProfileView:)];
                [TapGesture setNumberOfTapsRequired:1];
                [ActivityOwnerimageView setUserInteractionEnabled:YES];
                [ActivityOwnerimageView setTag:[[CommentACtivityDic objectForKey:@"ActivityCreator"] integerValue]];
                [ActivityOwnerimageView addGestureRecognizer:TapGesture];
                
                //Activity owner name
                
                UILabel *OwnernameLbl=(UILabel *)[PhotoActivity.contentView viewWithTag:3];
                OwnernameLbl.font=[UIFont fontWithName:MYRIARDPROSAMIBOLT size:16.0f];
                OwnernameLbl.text=[CommentACtivityDic objectForKey:@"ActivityCreatorTitle"];
                
                
                //Activity Titel Lable
                
                UILabel *ActivityTitel=(UILabel *)[PhotoActivity.contentView viewWithTag:4];
                CGRect activityframe=[ActivityTitel frame];
                ActivityTitel.font=[UIFont fontWithName:MYRIARDPROLIGHT size:15.0f];
                ActivityTitel.textColor=[UIColor whiteColor];
                ActivityTitel.textAlignment=NSTextAlignmentLeft;
                
                CGRect ActivityTitelframe = [[CommentACtivityDic objectForKey:@"ActivityTitle"] boundingRectWithSize:CGSizeMake(230, MAXFLOAT)
                                                                                                             options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                                                                          attributes:@{NSFontAttributeName:[UIFont fontWithName:MYRIARDPROLIGHT size:15.0f]
                                                                                                                       }
                                                                                                             context:nil];
                
                extraHeight=(ActivityTitelframe.size.height>16)?ActivityTitelframe.size.height-16:0.0f;
                
                ActivityTitel.text=[CommentACtivityDic objectForKey:@"ActivityTitle"];
                [ActivityTitel setNumberOfLines:0];
                [ActivityTitel setLineBreakMode:NSLineBreakByWordWrapping];
                activityframe.size.height+=extraHeight;
                [ActivityTitel setFrame:activityframe];
                
                //Activity posted time from privious time
                
                UILabel *PostTimeLBL=(UILabel *)[PhotoActivity.contentView viewWithTag:5];
                PostTimeLBL.textColor=[UIColor whiteColor];
                PostTimeLBL.font=[UIFont fontWithName:MYRIARDPROLIGHT size:13.0f];
                PostTimeLBL.text=[CommentACtivityDic objectForKey:@"ActivityCreatedDate"];
                
                
                // Location View Show or hide
                
                UIView *locationView=(UIView *)[PhotoActivity.contentView viewWithTag:400];
                CGRect locationframe=[locationView frame];
                locationframe.origin.y+=extraHeight;
                
                if (![self RemoveNullandreplaceWithSpace:[CommentACtivityDic objectForKey:@"Photolocation"]].length>0)
                {
                    locationView.hidden=YES;
                }
                else
                {
                    UILabel *LocationLBl=(UILabel *)[PhotoActivity.contentView viewWithTag:401];
                    LocationLBl.font=[UIFont fontWithName:MYRIARDPROLIGHT size:11.0f];
                    LocationLBl.textColor=[UIColor whiteColor];
                    LocationLBl.text=[CommentACtivityDic objectForKey:@"Photolocation"];
                    [locationView setFrame:locationframe];
                }
                
                
                // MainActivity Content frame
                
                
                //Downlod Photo to which the comment is posted main photo for photo activity
                UIView *ImageBackview=(UIView *)[PhotoActivity.contentView viewWithTag:9804197];
                CGRect Backmainframe=[ImageBackview frame];
                
                UIImageView *PhotoImage=(UIImageView *)[PhotoActivity.contentView viewWithTag:403];
                TapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(Sendtovideodetails:)];
                [TapGesture setNumberOfTapsRequired:1];
                [PhotoImage setUserInteractionEnabled:NO];
                [PhotoImage setTag:PHOTOCELL+indexPath.row];
                [PhotoImage addGestureRecognizer:TapGesture];
                
                CGRect PhotoTagFrame=[PhotoImage frame];
                NSURLRequest *MainImageDownload = [NSURLRequest requestWithURL:[NSURL URLWithString:[CommentACtivityDic objectForKey:@"Photourl"]]];
                //Extra height for caption
                CGFloat ExtreaContent=0.0f;
                if ([[CommentACtivityDic objectForKey:@"PhotoCaption"] length]>0)
                {
                    
                    UILabel *Caption2Lbl=(UILabel *)[PhotoActivity.contentView viewWithTag:98382];
                    CGRect captionFrame=[Caption2Lbl frame];
                    Caption2Lbl.font=[UIFont fontWithName:MYRIARDPROLIGHT size:15.0f];
                    
                    
                    CGRect ActivityContentTextframe2 = [[CommentACtivityDic objectForKey:@"PhotoCaption"] boundingRectWithSize:CGSizeMake(292, MAXFLOAT)
                                                                                                                       options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                                                                                    attributes:@{NSFontAttributeName:[UIFont fontWithName:MYRIARDPROLIGHT size:15.0f]
                                                                                                                                 }
                                                                                                                       context:nil];
                    
                    ExtreaContent=(ActivityContentTextframe2.size.height>21.0f)?ActivityContentTextframe2.size.height:21.0f;
                    captionFrame.size.height=ExtreaContent;
                    Caption2Lbl.text=[CommentACtivityDic objectForKey:@"PhotoCaption"];
                    Caption2Lbl.numberOfLines=0.0f;
                    Caption2Lbl.lineBreakMode=NSLineBreakByCharWrapping;
                    [Caption2Lbl setFrame:captionFrame];
                    
                }
                else
                {
                    ExtreaContent=0.0f;
                }
                
                
                UILabel *ActivityContent=(UILabel *)[PhotoActivity.contentView viewWithTag:1111111];
                ActivityContent.font=[UIFont fontWithName:MYRIARDPROLIGHT size:15.0f];
                ActivityContent.textColor=[UIColor whiteColor];
                CGFloat ExtraHightforcontent=0.0f;
                
                CGRect ActivityContentframe=[ActivityContent frame];
                
                
                CGRect ActivityContentTextframe = [[CommentACtivityDic objectForKey:@"PhotoComment"] boundingRectWithSize:CGSizeMake(292, MAXFLOAT)
                                                                                                                  options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                                                                               attributes:@{NSFontAttributeName:[UIFont fontWithName:MYRIARDPROLIGHT size:15.0f]
                                                                                                                            }
                                                                                                                  context:nil];
                
                ExtraHightforcontent=(ActivityContentTextframe.size.height>21.0f)?ActivityContentTextframe.size.height-21:0.0f;
                
                
                //Set frame to the activity content.........
                ActivityContentframe.origin.y+=extraHeight+ExtreaContent;
                ActivityContentframe.size.height+=ExtraHightforcontent;
                [ActivityContent setText:[CommentACtivityDic objectForKey:@"PhotoComment"]];
                [ActivityContent setLineBreakMode:NSLineBreakByWordWrapping];
                [ActivityContent setNumberOfLines:0];
                
                [ActivityContent setFrame:ActivityContentframe];
                
                
                
                
                //Downloading image
                
                AFImageRequestOperation *mainImageDownload = [AFImageRequestOperation imageRequestOperationWithRequest:MainImageDownload
                                                              
                                                                                                  imageProcessingBlock:nil
                                                              
                                                                                                               success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                                                                                   
                                                                                                                   if(image!=nil)
                                                                                                                       
                                                                                                                   {
                                                                                                                       
                                                                                                                       PhotoImage.image=image;
                                                                                                                       
                                                                                                                       
                                                                                                                       
                                                                                                                   }
                                                                                                                   
                                                                                                                   
                                                                                                                   
                                                                                                               }
                                                              
                                                                                                               failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                                                                                                   
                                                                                                                   NSLog(@"Error %@",error);
                                                                                                                   
                                                                                                                   
                                                                                                                   
                                                                                                               }];
                
                [mainImageDownload start];
                
                PhotoTagFrame.origin.y+=extraHeight+ExtreaContent;
                
                [PhotoImage setFrame:PhotoTagFrame];
                Backmainframe.origin.y+=extraHeight+ExtreaContent;
                [ImageBackview setFrame:Backmainframe];
                
                //---------------------------Like commnt area-------------------------//
                //----Footer Section----//
                
                //Footer portion like comment area and total comment
                
                UIView *Vfooterview=(UIView *)[PhotoActivity.contentView viewWithTag:8];
                CGRect footerFrame =[Vfooterview frame];
                [Vfooterview setHidden:YES];
                //TotalTee Lable
                
                UILabel *Totaltee=(UILabel *)[PhotoActivity.contentView viewWithTag:9];
                Totaltee.textColor=[UIColor whiteColor];
                Totaltee.font=[UIFont fontWithName:MYRIARDPROLIGHT size:14.0f];
                Totaltee.text=[CommentACtivityDic objectForKey:@"ActivityLikeCount"];
                
                //Total Comment Lable
                
                UILabel *TotalteeTextLBL=(UILabel *)[PhotoActivity.contentView viewWithTag:10];
                TotalteeTextLBL.textColor=[UIColor whiteColor];
                TotalteeTextLBL.font=[UIFont fontWithName:MYRIARDPROLIGHT size:14.0f];
                
                //total comment lable
                
                UILabel *TotalComment=(UILabel *)[PhotoActivity.contentView viewWithTag:12];
                TotalComment.font=[UIFont fontWithName:MYRIARDPROLIGHT size:14.0f];
                TotalComment.textColor=[UIColor whiteColor];
                TotalComment.text=[CommentACtivityDic objectForKey:@"ActivityCommentCount"];
                
                //Total comment text lable
                
                UILabel *totalCommentTxtLBL=(UILabel *)[PhotoActivity.contentView viewWithTag:11];
                totalCommentTxtLBL.font=[UIFont fontWithName:MYRIARDPROLIGHT size:14.0f];
                totalCommentTxtLBL.textColor=[UIColor whiteColor];
                
                
                //Tee and comment button
                
                IfUserLiked=([[CommentACtivityDic objectForKey:@"ActivityUserLiked"] integerValue]==0)?FALSE:TRUE;
                IfUserComment=([[CommentACtivityDic objectForKey:@"ActivityUserCommented"] integerValue]==0)?FALSE:TRUE;
                UIButton *TeeBtn=(UIButton *)[PhotoActivity.contentView viewWithTag:14];
                UIButton *CommentBtn=(UIButton *)[PhotoActivity.contentView viewWithTag:13];
                if (IfUserLiked)
                {
                    [TeeBtn setBackgroundImage:[UIImage imageNamed:@"teeball"] forState:UIControlStateNormal];
                    [TeeBtn setBackgroundImage:[UIImage imageNamed:@"teeball"] forState:UIControlStateHighlighted];
                    [TeeBtn setBackgroundImage:[UIImage imageNamed:@"teeball"] forState:UIControlStateSelected];
                    
                }
                else
                {
                    [TeeBtn setBackgroundImage:[UIImage imageNamed:@"teeballLite"] forState:UIControlStateNormal];
                    [TeeBtn setBackgroundImage:[UIImage imageNamed:@"teeballLite"] forState:UIControlStateHighlighted];
                    [TeeBtn setBackgroundImage:[UIImage imageNamed:@"teeballLite"] forState:UIControlStateSelected];
                }
                
                if (IfUserComment)
                {
                    [CommentBtn setBackgroundImage:[UIImage imageNamed:@"commentParmitionhave"] forState:UIControlStateNormal];
                    [CommentBtn setBackgroundImage:[UIImage imageNamed:@"commentParmitionhave"] forState:UIControlStateHighlighted];
                    [CommentBtn setBackgroundImage:[UIImage imageNamed:@"commentParmitionhave"] forState:UIControlStateSelected];
                    
                }
                else
                {
                    [CommentBtn setBackgroundImage:[UIImage imageNamed:@"commentparmitionhavenot"] forState:UIControlStateNormal];
                    [CommentBtn setBackgroundImage:[UIImage imageNamed:@"commentparmitionhavenot"] forState:UIControlStateHighlighted];
                    [CommentBtn setBackgroundImage:[UIImage imageNamed:@"commentparmitionhavenot"] forState:UIControlStateSelected];
                }
                
                [TeeBtn setUserInteractionEnabled:NO];
                [CommentBtn setUserInteractionEnabled:NO];
                
                
                //Like comment allow or not
                
                if ([[CommentACtivityDic objectForKey:@"ActivityCommentAllow"] integerValue]==1)
                {
                    [CommentBtn addTarget:self action:@selector(CommmentButton:) forControlEvents:UIControlEventTouchUpInside];
                    [CommentBtn setTag:COMMENTTAG+indexPath.row];
                }
                else
                {
                    CommentBtn.hidden=YES;
                }
                if ([[CommentACtivityDic objectForKey:@"ActivityLikeAllow"] integerValue]==1)
                {
                    [TeeBtn addTarget:self action:@selector(teebuttonclick:) forControlEvents:UIControlEventTouchUpInside];
                    [TeeBtn setTag:TEETAG+indexPath.row];
                    
                }
                else
                {
                    TeeBtn.hidden=YES;
                }
                if ([[CommentACtivityDic objectForKey:@"PhotoComment"] length]>0)
                {
                    footerFrame.origin.y+=extraHeight+ExtraHightforcontent+ExtreaContent;
                    [Vfooterview setFrame:footerFrame];
                    UIView *bacKView=[PhotoActivity.contentView viewWithTag:999];
                    CGRect FrameBackview=[bacKView frame];
                    FrameBackview.size.height+=extraHeight+ExtraHightforcontent+ExtreaContent;
                    [bacKView setFrame:FrameBackview];
                }
                else
                {
                    footerFrame.origin.y+=extraHeight-14+ExtreaContent;
                    [Vfooterview setFrame:footerFrame];
                    UIView *bacKView=[PhotoActivity.contentView viewWithTag:999];
                    CGRect FrameBackview=[bacKView frame];
                    FrameBackview.size.height+=extraHeight-14+ExtreaContent;
                    [bacKView setFrame:FrameBackview];
                }
                
                
                return PhotoActivity;
            }
            
            
            
            else
            {
                //-------------------Profile Type cativity------------------//
                
                //---------- Step one ------//
                
                static NSString *Activitypost =@"TTTprofiletypeActivityCell";
                
                TTTProfiletypeActivityCell *PhotoActivity=(TTTProfiletypeActivityCell *)[tableView dequeueReusableCellWithIdentifier:Activitypost];
                PhotoActivity=nil;
                if (PhotoActivity==nil)
                {
                    NSArray *CellNib=[[NSBundle mainBundle] loadNibNamed:@"TTTprofiletypeActivityCell" owner:self options:nil];
                    PhotoActivity=(TTTProfiletypeActivityCell *)[CellNib objectAtIndex:0];
                    
                }
                [PhotoActivity setBackgroundColor:[UIColor clearColor]];
                // Download user photo And user image Operation
                CGFloat extraHeight=0.0f;
                UIView *UserphotobackView=(UIView *)[PhotoActivity.contentView viewWithTag:1];
                [self SetroundborderWithborderWidth:2.0f WithColour:[UIColor whiteColor] ForView:UserphotobackView];
                
                UIImageView *ActivityOwnerimageView=(UIImageView *)[PhotoActivity.contentView viewWithTag:2];
                [self SetroundborderWithborderWidth:0.0f WithColour:[UIColor clearColor] ForImageview:ActivityOwnerimageView];
                
                //Download Image in image
                
                NSURLRequest *request_img2 = [NSURLRequest requestWithURL:[NSURL URLWithString:[CommentACtivityDic objectForKey:@"ActivityCreatorImage"]]];
                
                AFImageRequestOperation *operationProfileimage = [AFImageRequestOperation imageRequestOperationWithRequest:request_img2
                                                                  
                                                                                                      imageProcessingBlock:nil
                                                                  
                                                                                                                   success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                                                                                       
                                                                                                                       if(image!=nil)
                                                                                                                           
                                                                                                                       {
                                                                                                                           
                                                                                                                           ActivityOwnerimageView.image=image;
                                                                                                                           
                                                                                                                           
                                                                                                                           
                                                                                                                       }
                                                                                                                       
                                                                                                                       
                                                                                                                       
                                                                                                                   }
                                                                  
                                                                                                                   failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                                                                                                       
                                                                                                                       NSLog(@"Error %@",error);
                                                                                                                       
                                                                                                                       
                                                                                                                       
                                                                                                                   }];
                
                [operationProfileimage start];
                
                //******  Send to profile image view  *****//
                
                TapGesture=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(SendToProfileView:)];
                [TapGesture setNumberOfTapsRequired:1];
                [ActivityOwnerimageView setUserInteractionEnabled:NO];
                [ActivityOwnerimageView setTag:[[CommentACtivityDic objectForKey:@"ActivityCreator"] integerValue]];
                [ActivityOwnerimageView addGestureRecognizer:TapGesture];
                
                //Activity owner name
                
                UILabel *OwnernameLbl=(UILabel *)[PhotoActivity.contentView viewWithTag:3];
                OwnernameLbl.font=[UIFont fontWithName:MYRIARDPROSAMIBOLT size:16.0f];
                OwnernameLbl.text=[CommentACtivityDic objectForKey:@"ActivityCreatorTitle"];
                
                //Titel for status ...
                UILabel *TitelContent=(UILabel *)[PhotoActivity.contentView viewWithTag:4];
                TitelContent.font=[UIFont fontWithName:MYRIARDPROLIGHT size:15.0f];
                TitelContent.textColor=[UIColor whiteColor];
                TitelContent.text=[CommentACtivityDic objectForKey:@"ActivityTitle"];
                
                //Activity Titel Lable
                
                UILabel *ActivityTitel=(UILabel *)[PhotoActivity.contentView viewWithTag:666];
                CGRect activityframe=[ActivityTitel frame];
                ActivityTitel.font=[UIFont fontWithName:MYRIARDPROLIGHT size:15.0f];
                ActivityTitel.textColor=[UIColor whiteColor];
                ActivityTitel.textAlignment=NSTextAlignmentLeft;
                
                CGRect ActivityTitelframe = [[CommentACtivityDic objectForKey:@"ActivityComment"] boundingRectWithSize:CGSizeMake(285, MAXFLOAT)
                                                                                                               options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                                                                            attributes:@{NSFontAttributeName:[UIFont fontWithName:MYRIARDPROLIGHT size:15.0f]
                                                                                                                         }
                                                                                                               context:nil];
                
                extraHeight=(ActivityTitelframe.size.height>16)?ActivityTitelframe.size.height-16:0.0f;
                
                ActivityTitel.text=[CommentACtivityDic objectForKey:@"ActivityComment"];
                [ActivityTitel setNumberOfLines:0];
                [ActivityTitel setLineBreakMode:NSLineBreakByWordWrapping];
                activityframe.size.height=ActivityTitelframe.size.height;
                [ActivityTitel setFrame:activityframe];
                
                //Activity posted time from privious time
                
                UILabel *PostTimeLBL=(UILabel *)[PhotoActivity.contentView viewWithTag:5];
                PostTimeLBL.textColor=[UIColor whiteColor];
                PostTimeLBL.font=[UIFont fontWithName:MYRIARDPROLIGHT size:13.0f];
                PostTimeLBL.text=[CommentACtivityDic objectForKey:@"ActivityCreatedDate"];
                
                // UILabel *AcrivityContent=(UILabel *)[PhotoActivity.contentView viewWithTag:];
                
                //-------------------Activity Footer view----------------------//
                
                UIView *Vfooterview=(UIView *)[PhotoActivity.contentView viewWithTag:8];
                CGRect footerFrame =[Vfooterview frame];
                Vfooterview.hidden=YES;
                //TotalTee Lable
                
                UILabel *Totaltee=(UILabel *)[PhotoActivity.contentView viewWithTag:9];
                Totaltee.textColor=[UIColor whiteColor];
                Totaltee.font=[UIFont fontWithName:MYRIARDPROLIGHT size:14.0f];
                Totaltee.text=[CommentACtivityDic objectForKey:@"ActivityLikeCount"];
                
                //Total Comment Lable
                
                UILabel *TotalteeTextLBL=(UILabel *)[PhotoActivity.contentView viewWithTag:10];
                TotalteeTextLBL.textColor=[UIColor whiteColor];
                TotalteeTextLBL.font=[UIFont fontWithName:MYRIARDPROLIGHT size:14.0f];
                
                //total comment lable
                
                UILabel *TotalComment=(UILabel *)[PhotoActivity.contentView viewWithTag:12];
                TotalComment.font=[UIFont fontWithName:MYRIARDPROLIGHT size:14.0f];
                TotalComment.textColor=[UIColor whiteColor];
                TotalComment.text=[CommentACtivityDic objectForKey:@"ActivityCommentCount"];
                
                //Total comment text lable
                
                UILabel *totalCommentTxtLBL=(UILabel *)[PhotoActivity.contentView viewWithTag:11];
                totalCommentTxtLBL.font=[UIFont fontWithName:MYRIARDPROLIGHT size:14.0f];
                totalCommentTxtLBL.textColor=[UIColor whiteColor];
                
                
                //Tee and comment button
                IfUserLiked=([[CommentACtivityDic objectForKey:@"ActivityUserLiked"] integerValue]==0)?FALSE:TRUE;
                IfUserComment=([[CommentACtivityDic objectForKey:@"ActivityUserCommented"] integerValue]==0)?FALSE:TRUE;
                UIButton *TeeBtn=(UIButton *)[PhotoActivity.contentView viewWithTag:14];
                UIButton *CommentBtn=(UIButton *)[PhotoActivity.contentView viewWithTag:13];
                if (IfUserLiked)
                {
                    [TeeBtn setBackgroundImage:[UIImage imageNamed:@"teeball"] forState:UIControlStateNormal];
                    [TeeBtn setBackgroundImage:[UIImage imageNamed:@"teeball"] forState:UIControlStateHighlighted];
                    [TeeBtn setBackgroundImage:[UIImage imageNamed:@"teeball"] forState:UIControlStateSelected];
                    
                }
                else
                {
                    [TeeBtn setBackgroundImage:[UIImage imageNamed:@"teeballLite"] forState:UIControlStateNormal];
                    [TeeBtn setBackgroundImage:[UIImage imageNamed:@"teeballLite"] forState:UIControlStateHighlighted];
                    [TeeBtn setBackgroundImage:[UIImage imageNamed:@"teeballLite"] forState:UIControlStateSelected];
                }
                
                if (IfUserComment)
                {
                    [CommentBtn setBackgroundImage:[UIImage imageNamed:@"commentParmitionhave"] forState:UIControlStateNormal];
                    [CommentBtn setBackgroundImage:[UIImage imageNamed:@"commentParmitionhave"] forState:UIControlStateHighlighted];
                    [CommentBtn setBackgroundImage:[UIImage imageNamed:@"commentParmitionhave"] forState:UIControlStateSelected];
                    
                }
                else
                {
                    [CommentBtn setBackgroundImage:[UIImage imageNamed:@"commentparmitionhavenot"] forState:UIControlStateNormal];
                    [CommentBtn setBackgroundImage:[UIImage imageNamed:@"commentparmitionhavenot"] forState:UIControlStateHighlighted];
                    [CommentBtn setBackgroundImage:[UIImage imageNamed:@"commentparmitionhavenot"] forState:UIControlStateSelected];
                }
                
                [TeeBtn setUserInteractionEnabled:NO];
                [CommentBtn setUserInteractionEnabled:NO];
                
                //Like comment allow or not
                
                if ([[CommentACtivityDic objectForKey:@"ActivityCommentAllow"] integerValue]==1)
                {
                    [CommentBtn addTarget:self action:@selector(CommmentButton:) forControlEvents:UIControlEventTouchUpInside];
                    [CommentBtn setTag:COMMENTTAG+indexPath.row];
                }
                else
                {
                    CommentBtn.hidden=YES;
                }
                if ([[CommentACtivityDic objectForKey:@"ActivityLikeAllow"] integerValue]==1)
                {
                    [TeeBtn addTarget:self action:@selector(teebuttonclick:) forControlEvents:UIControlEventTouchUpInside];
                    [TeeBtn setTag:TEETAG+indexPath.row];
                    
                }
                else
                {
                    TeeBtn.hidden=YES;
                }
                UIView *BackView=(UIView *)[PhotoActivity.contentView viewWithTag:999];
                CGRect backframe=[BackView frame];
                backframe.size.height+=extraHeight;
                [BackView setFrame:backframe];
                footerFrame.origin.y+=extraHeight;
                [Vfooterview setFrame:footerFrame];
                return PhotoActivity;
                
            }
            
        }
        else if (indexPath.row==1)
        {
            UITableViewCell *cell=[[UITableViewCell alloc]init];
            NSArray *arr=[[NSBundle mainBundle] loadNibNamed:@"EtendedDesignView" owner:self options:nil];
            cell.backgroundColor=[UIColor clearColor];
            UIView *mainview=[arr objectAtIndex:15];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            UILabel *Totalteelbl=(UILabel *)[mainview viewWithTag:200];
            Totalteelbl.textColor=[UIColor whiteColor];
            Totalteelbl.font=[UIFont fontWithName:MYRIARDPROSAMIBOLT size:14.0f];
            NSString *Extracomment=[NSString stringWithFormat:@"%d",[[CommentACtivityDic objectForKey:@"ActivityLikeCount"] integerValue]-1];
            if ([[CommentACtivityDic objectForKey:@"ActivityLikeCount"] integerValue]>1)
            {
                Totalteelbl.text=[NSString stringWithFormat:@"You and %@ people Tee'd it",Extracomment];
            }
            else if ([[CommentACtivityDic objectForKey:@"ActivityLikeCount"] integerValue]==1)
            {
                Totalteelbl.text=@"You Tee'd it";
            }
            else
            {
                Totalteelbl.text=@"No one Tee'd it";
            }
            
            [cell.contentView addSubview:mainview];
            return cell;
            
        }
        else if (indexPath.row==2)
        {
            UITableViewCell *cell=[[UITableViewCell alloc]init];
            cell.backgroundColor=[UIColor clearColor];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            NSArray *arr=[[NSBundle mainBundle] loadNibNamed:@"EtendedDesignView" owner:self options:nil];
            UIView *mainview=[arr objectAtIndex:16];
            UILabel *Totalteelbl=(UILabel *)[mainview viewWithTag:100];
            Totalteelbl.textColor=[UIColor whiteColor];
            Totalteelbl.font=[UIFont fontWithName:MYRIARDPROSAMIBOLT size:14.0f];
            UIButton *LoadmoreButton=(UIButton *)[mainview viewWithTag:101];
            [LoadmoreButton addTarget:self action:@selector(LoadMoreComment:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:mainview];
            return cell;
            
        }
        else
        {
            
            static NSString *CellForcommentList =@"TTTCellForCommentListing";
            
            TTTCellForCommentListing *CommentActivity=(TTTCellForCommentListing *)[tableView dequeueReusableCellWithIdentifier:CellForcommentList];
            CommentActivity=nil;
            if (CommentActivity==nil)
            {
                NSArray *CellNib=[[NSBundle mainBundle] loadNibNamed:@"TTTCellForCommentListing" owner:self options:nil];
                CommentActivity=(TTTCellForCommentListing *)[CellNib objectAtIndex:0];
                
            }
            [CommentActivity setBackgroundColor:[UIColor clearColor]];
            [CommentActivity setSelectionStyle:UITableViewCellSelectionStyleNone];
            UIView *imageback=(UIView *)[CommentActivity.contentView viewWithTag:1001];
            UIImageView *userImage=(UIImageView *)[CommentActivity.contentView viewWithTag:1002];
            [self SetroundborderWithborderWidth:2.0f WithColour:[UIColor whiteColor] ForView:imageback];
            [self SetroundborderWithborderWidth:0.0f WithColour:[UIColor clearColor] ForImageview:userImage];
            // Comment count
            
            NSURLRequest *request_img2 = [NSURLRequest requestWithURL:[NSURL URLWithString:[CommentACtivityDic objectForKey:@"commentedByImage"]]];
            
            
            AFImageRequestOperation *operationProfileimage = [AFImageRequestOperation imageRequestOperationWithRequest:request_img2
                                                              
                                                                                                  imageProcessingBlock:nil
                                                              
                                                                                                               success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                                                                                   
                                                                                                                   if(image!=nil)
                                                                                                                       
                                                                                                                   {
                                                                                                                       
                                                                                                                       userImage.image=image;
                                                                                                                       
                                                                                                                       
                                                                                                                       
                                                                                                                   }
                                                                                                                   
                                                                                                                   
                                                                                                                   
                                                                                                               }
                                                              
                                                                                                               failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                                                                                                   
                                                                                                                   NSLog(@"Error %@",error);
                                                                                                                   
                                                                                                                   
                                                                                                                   
                                                                                                               }];
            
            [operationProfileimage start];
            
            UILabel *Commenteduser=(UILabel *)[CommentActivity.contentView viewWithTag:1003];
            Commenteduser.font=[UIFont fontWithName:MYRIARDPROSAMIBOLT size:15];
            Commenteduser.textColor=[UIColor whiteColor];
            Commenteduser.text=[CommentACtivityDic valueForKey:@"commentedByName"];
            //Comment text lable
            UILabel *CommentText=(UILabel *)[CommentActivity.contentView viewWithTag:895678];
            CommentText.font=[UIFont fontWithName:MYRIARDPROLIGHT size:15.0f];
            CommentText.textAlignment=NSTextAlignmentLeft;
            CGFloat extraHeight=0.0f;
            CGRect commentactivityframe=[CommentText frame];
            CGRect Commentframe = [[CommentACtivityDic objectForKey:@"comment"] boundingRectWithSize:CGSizeMake(230, MAXFLOAT)
                                                                                             options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                                                          attributes:@{NSFontAttributeName:[UIFont fontWithName:MYRIARDPROLIGHT size:15.0f]
                                                                                                       }
                                                                                             context:nil];
            
            extraHeight=(Commentframe.size.height>21)?Commentframe.size.height-21:0.0f;
            
            commentactivityframe.size.height=Commentframe.size.height;
            [CommentText setFrame:commentactivityframe];
            
            CommentText.text=[CommentACtivityDic valueForKey:@"comment"];
            CommentText.textColor=[UIColor whiteColor];
            [CommentText setNumberOfLines:0];
            [CommentText setLineBreakMode:NSLineBreakByWordWrapping];
            
            UILabel *dateTimeLable=(UILabel *)[CommentActivity.contentView viewWithTag:1005];
            [dateTimeLable setFont:[UIFont fontWithName:MYRIARDPROLIGHT size:13.0f]];
            [dateTimeLable setText:[CommentACtivityDic valueForKey:@"commentdate"]];
            UIView *mainview=(UIView *)[CommentActivity.contentView viewWithTag:1000];
            CGRect frameMain=[mainview frame];
            frameMain.size.height+=extraHeight;
            [mainview setFrame:frameMain];
            return CommentActivity;
        }
    
  
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CGFloat Height= 0.0f;
    CGFloat extraHeight=0.0f;
    CGFloat ExtraHightforcontent=0.0f;
    if (tableView==profileTable)
    {
        if (indexPath.row==0)
        {
            CGRect HeaderHeight=[_headerView frame];
            Height=HeaderHeight.size.height;
        }
        else
        {
        NSMutableDictionary *mutDicActivity=[ActivityArray objectAtIndex:indexPath.row-1];
        
        if ([[mutDicActivity objectForKey:@"ActivityType"] integerValue]==1)
        {
            Height=320.0f;
        }
        else if ([[mutDicActivity objectForKey:@"ActivityType"] integerValue]==2)
        {
            
            
            CGRect ActivityTitelframe = [[mutDicActivity objectForKey:@"ActivityTitle"] boundingRectWithSize:CGSizeMake(230, MAXFLOAT)
                                                                                                     options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                                                                  attributes:@{NSFontAttributeName:[UIFont fontWithName:MYRIARDPROLIGHT size:15.0f]
                                                                                                               }
                                                                                                     context:nil];
            
            extraHeight=(ActivityTitelframe.size.height>21)?ActivityTitelframe.size.height-21:0.0f;
            Height=314+extraHeight;
            
        }
        else if ([[mutDicActivity objectForKey:@"ActivityType"] integerValue]==3)
        {
            
            CGRect ActivityTitelframe = [[mutDicActivity objectForKey:@"ActivityTitle"] boundingRectWithSize:CGSizeMake(230, MAXFLOAT)
                                                                                                     options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                                                                  attributes:@{NSFontAttributeName:[UIFont fontWithName:MYRIARDPROLIGHT size:15.0f]
                                                                                                               }
                                                                                                     context:nil];
            
            extraHeight=(ActivityTitelframe.size.height>21)?ActivityTitelframe.size.height-21:0.0f;
            Height=314+extraHeight;
            
        }
        else if ([[mutDicActivity objectForKey:@"ActivityType"] integerValue]==4)
        {
            Height=40.0f;
        }
        else if ([[mutDicActivity objectForKey:@"ActivityType"] integerValue]==5||[[mutDicActivity objectForKey:@"ActivityType"] integerValue]==6)
        {
            
            float ImgRatio=[[mutDicActivity objectForKey:@"Photowidth"] floatValue]/[[mutDicActivity objectForKey:@"Photoheight"] floatValue];
            float NewImgHeight=200.0f/ImgRatio;
            float ExtraHeightForImage=(NewImgHeight > 180.0f)?NewImgHeight-180.0f:0.0f;
            
            
            CGRect ActivityTitelframe = [[mutDicActivity objectForKey:@"ActivityTitle"] boundingRectWithSize:CGSizeMake(230, MAXFLOAT)
                                                                                                     options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                                                                  attributes:@{NSFontAttributeName:[UIFont fontWithName:MYRIARDPROLIGHT size:15.0f]
                                                                                                               }
                                                                                                     context:nil];
            
            extraHeight=(ActivityTitelframe.size.height>16)?ActivityTitelframe.size.height-16:0.0f;
            
            CGRect ActivityContentTextframe = [[mutDicActivity objectForKey:@"PhotoComment"] boundingRectWithSize:CGSizeMake(292, MAXFLOAT)
                                                                                                          options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                                                                       attributes:@{NSFontAttributeName:[UIFont fontWithName:MYRIARDPROLIGHT size:15.0f]
                                                                                                                    }
                                                                                                          context:nil];
            
            CGFloat ExtreaContent=0.0f;
            if ([[mutDicActivity objectForKey:@"PhotoCaption"] length]>0)
            {
                
                
                
                
                CGRect ActivityContentTextframe2 = [[mutDicActivity objectForKey:@"PhotoCaption"] boundingRectWithSize:CGSizeMake(292, MAXFLOAT)
                                                                                                               options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                                                                            attributes:@{NSFontAttributeName:[UIFont fontWithName:MYRIARDPROLIGHT size:15.0f]
                                                                                                                         }
                                                                                                               context:nil];
                
                ExtreaContent=(ActivityContentTextframe2.size.height>21.0f)?ActivityContentTextframe2.size.height:21.0f;
                
                
            }
            else
            {
                ExtreaContent=0.0f;
            }
            
            
            
            ExtraHightforcontent=(ActivityContentTextframe.size.height>21.0f)?ActivityContentTextframe.size.height-21:0.0f;
            if ([[mutDicActivity objectForKey:@"PhotoComment"] length]>0)
            {
                Height=extraHeight+ExtraHightforcontent+306+ExtreaContent+ExtraHeightForImage;
            }
            else
            {
                Height=extraHeight+ExtraHightforcontent+300-14+ExtreaContent+ExtraHeightForImage;
            }
            
            
            
        }
        
        else
        {
            
            CGRect ActivityTitelframe = [[mutDicActivity objectForKey:@"ActivityComment"] boundingRectWithSize:CGSizeMake(285, MAXFLOAT)
                                                                                                       options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                                                                    attributes:@{NSFontAttributeName:[UIFont fontWithName:MYRIARDPROLIGHT size:15.0f]
                                                                                                                 }
                                                                                                       context:nil];
            
            extraHeight=(ActivityTitelframe.size.height>21)?ActivityTitelframe.size.height-21:0.0f;
            Height=129+extraHeight;
            
            NSLog(@"The activity comment: %f",Height);
            
        }
        
    }
    }
    //---------- Anothother table view Comment table View ----------//
    
    else
    {
        
        NSLog(@"The value of content size:%d",[CommntArry count]);
        NSMutableDictionary *mutDicActivity=[CommntArry objectAtIndex:indexPath.row];
        if (indexPath.row==0)
        {
            
            if ([[mutDicActivity objectForKey:@"ActivityType"] integerValue]==1)
            {
                Height=320.0f-40;
            }
            else if ([[mutDicActivity objectForKey:@"ActivityType"] integerValue]==2)
            {
                
                
                CGRect ActivityTitelframe = [[mutDicActivity objectForKey:@"ActivityTitle"] boundingRectWithSize:CGSizeMake(230, MAXFLOAT)
                                                                                                         options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                                                                      attributes:@{NSFontAttributeName:[UIFont fontWithName:MYRIARDPROLIGHT size:15.0f]
                                                                                                                   }
                                                                                                         context:nil];
                
                extraHeight=(ActivityTitelframe.size.height>21)?ActivityTitelframe.size.height-21:0.0f;
                Height=314+extraHeight-40;
                
            }
            else if ([[mutDicActivity objectForKey:@"ActivityType"] integerValue]==3)
            {
                
                CGRect ActivityTitelframe = [[mutDicActivity objectForKey:@"ActivityTitle"] boundingRectWithSize:CGSizeMake(230, MAXFLOAT)
                                                                                                         options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                                                                      attributes:@{NSFontAttributeName:[UIFont fontWithName:MYRIARDPROLIGHT size:15.0f]
                                                                                                                   }
                                                                                                         context:nil];
                
                extraHeight=(ActivityTitelframe.size.height>21)?ActivityTitelframe.size.height-21:0.0f;
                Height=314+extraHeight-40;
                
            }
            else if ([[mutDicActivity objectForKey:@"ActivityType"] integerValue]==4)
            {
                Height=40.0f;
            }
            else if ([[mutDicActivity objectForKey:@"ActivityType"] integerValue]==5||[[mutDicActivity objectForKey:@"ActivityType"] integerValue]==6)
            {
                
                float ImgRatio=[[mutDicActivity objectForKey:@"Photowidth"] floatValue]/[[mutDicActivity objectForKey:@"Photoheight"] floatValue];
                float NewImgHeight=200.0f/ImgRatio;
                float ExtraHeightForImage=(NewImgHeight > 180.0f)?NewImgHeight-180.0f:0.0f;
                
                
                CGRect ActivityTitelframe = [[mutDicActivity objectForKey:@"ActivityTitle"] boundingRectWithSize:CGSizeMake(230, MAXFLOAT)
                                                                                                         options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                                                                      attributes:@{NSFontAttributeName:[UIFont fontWithName:MYRIARDPROLIGHT size:15.0f]
                                                                                                                   }
                                                                                                         context:nil];
                
                extraHeight=(ActivityTitelframe.size.height>16)?ActivityTitelframe.size.height-16:0.0f;
                
                CGRect ActivityContentTextframe = [[mutDicActivity objectForKey:@"PhotoComment"] boundingRectWithSize:CGSizeMake(292, MAXFLOAT)
                                                                                                              options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                                                                           attributes:@{NSFontAttributeName:[UIFont fontWithName:MYRIARDPROLIGHT size:15.0f]
                                                                                                                        }
                                                                                                              context:nil];
                
                CGFloat ExtreaContent=0.0f;
                if ([[mutDicActivity objectForKey:@"PhotoCaption"] length]>0)
                {
                    
                    
                    
                    
                    CGRect ActivityContentTextframe2 = [[mutDicActivity objectForKey:@"PhotoCaption"] boundingRectWithSize:CGSizeMake(292, MAXFLOAT)
                                                                                                                   options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                                                                                attributes:@{NSFontAttributeName:[UIFont fontWithName:MYRIARDPROLIGHT size:15.0f]
                                                                                                                             }
                                                                                                                   context:nil];
                    
                    ExtreaContent=(ActivityContentTextframe2.size.height>21.0f)?ActivityContentTextframe2.size.height:21.0f;
                    
                    
                }
                else
                {
                    ExtreaContent=0.0f;
                }
                
                
                
                ExtraHightforcontent=(ActivityContentTextframe.size.height>21.0f)?ActivityContentTextframe.size.height-21:0.0f;
                if ([[mutDicActivity objectForKey:@"PhotoComment"] length]>0)
                {
                    Height=extraHeight+ExtraHightforcontent+314+ExtreaContent+ExtraHeightForImage;
                }
                else
                {
                    Height=extraHeight+ExtraHightforcontent+300+ExtreaContent+ExtraHeightForImage;
                }
                Height=Height-35;
                
                
            }
            else
            {
                CGRect ActivityTitelframe = [[mutDicActivity objectForKey:@"ActivityComment"] boundingRectWithSize:CGSizeMake(285, MAXFLOAT)
                                                                                                           options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                                                                        attributes:@{NSFontAttributeName:[UIFont fontWithName:MYRIARDPROLIGHT size:15.0f]
                                                                                                                     }
                                                                                                           context:nil];
                
                extraHeight=(ActivityTitelframe.size.height>21)?ActivityTitelframe.size.height-21:0.0f;
                Height=129+extraHeight;
                
            }
            
            if (isloadFirsttime)
            {
                //NSLog(@"The value of extra height:");
                TotalcommentHeight+=Height;
                isloadFirsttime=FALSE;
                
            }
            
        }
        
        else if (indexPath.row==1||indexPath.row==2)
        {
            Height=32.0f;
            
            
        }
        else if (indexPath.row>2)
        {
            CGRect Commentframe = [[mutDicActivity objectForKey:@"comment"] boundingRectWithSize:CGSizeMake(230, MAXFLOAT)
                                                                                         options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                                                      attributes:@{NSFontAttributeName:[UIFont fontWithName:MYRIARDPROLIGHT size:15.0f]
                                                                                                   }
                                                                                         context:nil];
            
            extraHeight=(Commentframe.size.height>21)?Commentframe.size.height-21:0.0f;
            Height=68.0f+extraHeight;
            if (LoadFirsttime==TRUE)
            {
                
                TotalcommentHeight+=Height;
                
            }
            
            if (LoadFirsttime==FALSE&&indexPath.row==[CommntArry count]-1)
            {
                TotalcommentHeight+=68.0f+extraHeight;
                
            }
            
            
        }
        
        // NSLog(@"Thevalue for total comment:%f",TotalcommentHeight);
        
        
    }
    
    
    
    return Height;
}




-(void)initializeDict
{
    
    @try
    {
        NSError *Error;
        if ([self isConnectedToInternet])
        {
            NSString *stringurl = [NSString stringWithFormat:@"%@user.php?mode=userprofile&userid=%@&loggedin_userid=%@",API,ParamprofileViewerId,[self LoggedId]];
            NSLog(@"stringurl %@",stringurl);
            NSURL *urlinisilize = [NSURL URLWithString:stringurl];
            NSData *Data=[NSData dataWithContentsOfURL:urlinisilize];
            NSDictionary *mainDic=[NSJSONSerialization JSONObjectWithData:Data options:kNilOptions error:&Error];
            [dict setValue:[mainDic valueForKey:@"itsmyprofile"] forKey:@"itsmyprofile"];
            [dict setValue:[mainDic valueForKey:@"ismyfriend"] forKey:@"ismyfriend"];
            [dict setValue:[mainDic valueForKey:@"myfriendCount"] forKey:@"myfriendCount"];
            [dict setValue:[mainDic valueForKey:@"myphotoCount"] forKey:@"myphotoCount"];
            [dict setValue:[mainDic valueForKey:@"username"] forKey:@"username"];
            [dict setValue:[mainDic valueForKey:@"thumb"] forKey:@"thumb"];
            [dict setValue:[mainDic valueForKey:@"coverphoto"] forKey:@"coverphoto"];
            [dict setValue:[mainDic valueForKey:@"userfullname"] forKey:@"userfullname"];
            [dict setValue:[mainDic valueForKey:@"handicapindex"] forKey:@"handicapindex"];
            [dict setValue:[mainDic valueForKey:@"points"] forKey:@"points"];
            [dict setValue:[mainDic valueForKey:@"Gender"] forKey:@"Gender"];
            [dict setValue:[mainDic valueForKey:@"Birthdate"] forKey:@"Birthdate"];
            [dict setValue:[mainDic valueForKey:@"Address"] forKey:@"Address"];
            [dict setValue:[mainDic valueForKey:@"City / Town"] forKey:@"City / Town"];
            [dict setValue:[mainDic valueForKey:@"State"] forKey:@"State"];
            [dict setValue:[mainDic valueForKey:@"Country"] forKey:@"Country"];
            [self performSelectorOnMainThread:@selector(Showuserprifile) withObject:nil waitUntilDone:YES];
            
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
             
                [SVProgressHUD showErrorWithStatus:@"No interent comnnection"];
            });
        }
       
        
        
    }
    @catch (NSException *exception)
    {
        NSLog(@"The exception is:%@ %@",[exception name],exception);
    }
    
    
   
}

-(void)Showuserprifile
{
    [self setimage:[dict objectForKey:@"coverphoto"] tag:1];
    [self setimage:[dict objectForKey:@"thumb"] tag:0];
    _profileName.text=[dict objectForKey:@"userfullname"];
    NSString *mainString;
    if ([[dict objectForKey:@"CityTown"] length]>0&&[[dict objectForKey:@"State"] length]>0&&[[dict objectForKey:@"Country"] length]>0)
    {
        mainString=[NSString stringWithFormat:@"%@, %@, %@",[self RemoveNullandreplaceWithSpace:[dict objectForKey:@"CityTown"]],[self RemoveNullandreplaceWithSpace:[dict objectForKey:@"State"] ],[self RemoveNullandreplaceWithSpace:[dict objectForKey:@"Country"]]];
    }
    else if ([[dict objectForKey:@"CityTown"] length]==0&&[[dict objectForKey:@"State"] length]>0&&[[dict objectForKey:@"Country"] length]>0)
    {
        mainString=[NSString stringWithFormat:@"%@, %@",[self RemoveNullandreplaceWithSpace:[dict objectForKey:@"State"]],[self RemoveNullandreplaceWithSpace:[dict objectForKey:@"Country"]]];
    }
    else if ([[dict objectForKey:@"CityTown"] length]==0&&[[dict objectForKey:@"State"] length]==0&&[[dict objectForKey:@"Country"] length]>0)
    {
        mainString=[NSString stringWithFormat:@"%@",[self RemoveNullandreplaceWithSpace:[dict objectForKey:@"Country"]]];
    }
  
    _profilePlace.text=mainString;
    _profileTTHCP.text=[dict objectForKey:@"handicapindex"];
    _profilePoints.text=[dict objectForKey:@"points"];
    _lblFriends.text=[NSString stringWithFormat:@"(%@)",[dict objectForKey:@"myfriendCount"]];
    _lblPhotos.text=[NSString stringWithFormat:@"(%@)",[dict objectForKey:@"myphotoCount"]];
     _MainLabel.text=[NSString stringWithFormat:@"%@'s Profile",[dict objectForKey:@"username"]];
    
    if ([[dict valueForKey:@"ismyfriend"] integerValue]==1)
    {
        self.plusButton.hidden=NO;
    }
    else
    {
        self.plusButton.hidden=YES;
    }


}




-(void)setimage:(NSString *)urldata tag:(int)i
{
    
    NSURLRequest *request_img = [NSURLRequest requestWithURL:[NSURL URLWithString:urldata]];
    AFImageRequestOperation *operation = [AFImageRequestOperation imageRequestOperationWithRequest:request_img
                                                                              imageProcessingBlock:nil
                                                                                           success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                                                               if(image!=nil)
                                                                                               {
                                                                                                   
                                                                                                   if(i==0){
                                                                                                       [_profileImage setImage:image];
                                                                                                      
                                                                                                       
                                                                                                       
                                                                                                   }
                                                                                                   if(i==1){
                                                                                                       [_holeProfileImage setImage:image];
                                                                                                       
                                                                                                   }
                                                                                               }
                                                                                               
                                                                                           }
                                                                                           failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                                                                               NSLog(@"Error %@",error);
                                                                                               
                                                                                               NSLog(@"error")
                                                                                               ;
                                                                                               
                                                                                               
                                                                                           }];
    [operation start];
    
    
}


- (IBAction)menuClicked:(id)sender
{
    [self keyboardhide];
    IsLeftMenuBoxOpen=[self PerformMenuSlider:_screenView withMenuArea:_sideView IsOpen:IsLeftMenuBoxOpen];
    
}
- (IBAction)unflowAction:(id)sender
{
    
}
- (IBAction)messageAction:(id)sender
{
    TTTCretenewmessage *creteNewmsg=[[TTTCretenewmessage alloc]init];
    creteNewmsg.MessageSenderid=ParamprofileViewerId;
    creteNewmsg.friendName=_mainLabelString;
    creteNewmsg.Friendimageurl=[dict objectForKey:@"thumb"];
    [self presentViewController:creteNewmsg animated:YES completion:^{
        [SVProgressHUD dismiss];
    }];
}

- (IBAction)previousAction:(id)sender
{
    CGPoint p=[_scrollMenu contentOffset];
    if(p.x>54)
        [_scrollMenu setContentOffset:CGPointMake(p.x-70,p.y) animated:YES];
    _previous.userInteractionEnabled=NO;
    _next.userInteractionEnabled=YES;
    [_previous setBackgroundImage:[UIImage imageNamed:@"left-arrow-black"] forState:UIControlStateNormal];
    
}

- (IBAction)nextAction:(id)sender {
    CGPoint p=[_scrollMenu contentOffset];
    if(p.x<54)
        [_scrollMenu setContentOffset:CGPointMake(p.x+70,p.y) animated:YES];
    _next.userInteractionEnabled=NO;
    _previous.userInteractionEnabled=YES;
    [_previous setBackgroundImage:[UIImage imageNamed:@"left-arrow"] forState:UIControlStateNormal];
}
- (IBAction)goStatistics:(id)sender
{
    if([_loggedInUserid isEqualToString:ParamprofileViewerId])
    {
        ParamprofileViewerId=@"";
    }
    
    TTTStatisticsViewController *achievement=[[TTTStatisticsViewController alloc]init];
    achievement.paramviewID=ParamprofileViewerId;
    [self PushViewController:achievement TransitationFrom:kCATransitionFade];
}
- (IBAction)goBadges:(id)sender
{
    if([_loggedInUserid isEqualToString:ParamprofileViewerId])
    {
        ParamprofileViewerId=@"";
    }
    TTTAchievementStatisticViewController *AchiveMent=[[TTTAchievementStatisticViewController alloc]init];
    AchiveMent.ParamViewid=ParamprofileViewerId;
    [self PushViewController:AchiveMent TransitationFrom:kCATransitionFade];
}

- (IBAction)plusClickedAction:(id)sender
{
    [self StatusClicked];
    
}

- (IBAction)GoestoFeiendlist:(id)sender
{
    if([_loggedInUserid isEqualToString:ParamprofileViewerId])
    {
        ParamprofileViewerId=@"";
    }
    TTTShowAllfriendmanu *Showfriend=[[TTTShowAllfriendmanu alloc]init];
    Showfriend.Parmfrienduserid=ParamprofileViewerId;
    [self PushViewController:Showfriend TransitationFrom:kCATransitionFade];
}
- (IBAction)photosofuserpagelink:(id)sender
{
    NSLog(@"the vphoto button click");
    if([_loggedInUserid isEqualToString:ParamprofileViewerId])
    {
        ParamprofileViewerId=@"";
    }
    TTTPhotosofme *photosofme=[[TTTPhotosofme alloc]init];
    photosofme.ParmuserofPhoto=ParamprofileViewerId;
    photosofme.ViewerName=_mainLabelString;
    [self PushViewController:photosofme TransitationFrom:kCATransitionFade];
}


- (IBAction)ShowMatches:(id)sender
{
    if([_loggedInUserid isEqualToString:ParamprofileViewerId])
    {
        ParamprofileViewerId=@"";
    }
    TTTMatchListing *matchList=[[TTTMatchListing alloc]init];
    matchList.ParamUserID=ParamprofileViewerId;
    [self PushViewController:matchList TransitationFrom:kCATransitionFade];
}


-(void)keyboardhide
{
    
    [self.manuSearchtxt resignFirstResponder];
    [SVProgressHUD dismiss];
    if ([self.manuSearchtxt.text length]<1 && self.Scarchicon.frame.origin.x==9)
    {
        CGRect frame=[self.Scarchicon frame];
        frame.origin.x=122;
        [UIView animateWithDuration:.3f animations:^{
            
            self.Scarchicon.frame=frame;
            
            
        }];
    }
    
}

- (IBAction)backButtonClick:(id)sender
{
    [self PerformGoBack];
}

//Do aditional Work Like Tee Comment and other section

-(void)Sendtovideodetails:(UITapGestureRecognizer *)Recognizer
{
    UIImageView *TouchView=(UIImageView *)[[Recognizer self] view];
    NSMutableDictionary *DictionActivity=[ActivityArray objectAtIndex:TouchView.tag-(PHOTOCELL+1)];
    
    TTTWebVideoViewController *Videolist=[[TTTWebVideoViewController alloc]init];
    Videolist.videoURL=[DictionActivity objectForKey:@"Videourl"];
    [self presentViewController:Videolist animated:YES completion:^{
        [SVProgressHUD dismiss];
    }];
}



// ----------------- Goes to Photo Details page --------------------- //

-(void)SenToimagedetailspage:(UITapGestureRecognizer *)Recognizer
{
    
    UIImageView *TouchView=(UIImageView *)[[Recognizer self] view];
    NSMutableDictionary *PhotoDicActivity=[ActivityArray objectAtIndex:TouchView.tag-(PHOTOCELL+1)];
    TTTPhotodetailsViewController *PhotoDetails=[[TTTPhotodetailsViewController alloc]init];
    PhotoDetails.ParamPhotoArry=[PhotoDicActivity objectForKey:@"Photos_list"];
    PhotoDetails.ClickphotoId=[PhotoDicActivity objectForKey:@"ActivityPhotoPosition"];
    [self presentViewController:PhotoDetails animated:YES completion:^{
        [SVProgressHUD dismiss];
    }];
    
}


//-------------- GOES TO ACHIVEMENT DETAILS --------------//

-(IBAction)GoestoAchivement:(UITapGestureRecognizer *)recognizer
{
    
    UIImageView *TouchedImage=(UIImageView *)[[recognizer self] view];
    NSInteger achivemenTag=TouchedImage.tag-(ACHIVEMENTCELL+1);
    NSMutableDictionary *mutDic=[ActivityArray objectAtIndex:achivemenTag];
    NSMutableDictionary *AchivemantDic=[mutDic objectForKey:@"MatchAchivement"];
    TTTAchievementDetailsViewController *AchivementDetais=[[TTTAchievementDetailsViewController alloc] init];
    AchivementDetais.tag=[[AchivemantDic valueForKey:@"AchivementId"] integerValue];
    AchivementDetais.ParamviewAchivementdetails=([mutDic objectForKey:@"ActivityCreator"]==[self LoggedId])?@"":[mutDic objectForKey:@"ActivityCreator"];
    [self PushViewController:AchivementDetais TransitationFrom:kCATransitionFade];
}



// ------------ Goes to Profile page ------------------ //


-(void)SendToProfileView:(UITapGestureRecognizer *)Recognizer
{
    UIImageView *TouchedImage=(UIImageView *)[[Recognizer self] view];
    TTTProfileViewController *ProfileView=[[TTTProfileViewController alloc]init];
    ProfileView.ParamprofileViewerId=([NSString stringWithFormat:@"%d",TouchedImage.tag]==[self LoggedId])?@"":[NSString stringWithFormat:@"%d",TouchedImage.tag];
    [self PushViewController:ProfileView TransitationFrom:kCATransitionFade];
    
    
}


//  Goes tomatch detais page

-(IBAction)goestomatchdetils:(UITapGestureRecognizer *)Recognizer
{
    
    
    UIView *GestureView=(UIView *)[[Recognizer self] view];
    NSInteger matchPosition=GestureView.tag-(MATCHDETAILSCELL+1);
    NSMutableDictionary *mainDic=[ActivityArray objectAtIndex:matchPosition];
    NSMutableDictionary *matchDic=[mainDic objectForKey:@"MatchDetails"];
    TTTMatchDetails *matchDetails=[[TTTMatchDetails alloc]init];
    matchDetails.ParamViewerID=([mainDic objectForKey:@"ActivityCreator"]==[self LoggedId])?@"":[mainDic objectForKey:@"ActivityCreator"];
    matchDetails.matchID=[matchDic valueForKey:@"MatchId"];
    [self PushViewController:matchDetails TransitationFrom:kCATransitionFade];
}


//--------------- Perform tee operation Action when tee button click ------------//


-(IBAction)teebuttonclick:(UIButton *)sender
{
    NSMutableDictionary *MutdicTee=[ActivityArray objectAtIndex:sender.tag-(TEETAG+1)];
    int LocalLikeCounter=0;
    BOOL Like=TRUE;
    UIView *Superview=[sender superview];
    for (UIView *lable in [Superview subviews])
    {
        if ([lable isKindOfClass:[UILabel class]])
        {
            UILabel *totalteeLbl=(UILabel *)lable;
            if (totalteeLbl.tag==9)
            {
                TotalteeHenclick=totalteeLbl;
            }
        }
        
    }
    LocalLikeCounter=[[TotalteeHenclick text] integerValue];
    
    if ([[MutdicTee objectForKey:@"ActivityUserLiked"] integerValue]==1)
    {
        Like=TRUE;
        [MutdicTee setObject:[NSString stringWithFormat:@"%d",LocalLikeCounter-1] forKey:@"ActivityLikeCount"];
        [MutdicTee setObject:@"0" forKey:@"ActivityUserLiked"];
        TotalteeHenclick.text=[NSString stringWithFormat:@"%d Tee'd It",LocalLikeCounter-1];
        [sender setBackgroundImage:[UIImage imageNamed:@"teeballLite"] forState:UIControlStateNormal];
        [sender setBackgroundImage:[UIImage imageNamed:@"teeballLite"] forState:UIControlStateSelected];
        [sender setBackgroundImage:[UIImage imageNamed:@"teeballLite"] forState:UIControlStateHighlighted];
        
    }
    else
    {
        Like=FALSE;
        [MutdicTee setObject:[NSString stringWithFormat:@"%d",LocalLikeCounter+1] forKey:@"ActivityLikeCount"];
        [MutdicTee setObject:@"1" forKey:@"ActivityUserLiked"];
        TotalteeHenclick.text=[NSString stringWithFormat:@"%d Tee'd It",LocalLikeCounter+1];
        [sender setBackgroundImage:[UIImage imageNamed:@"teeball"] forState:UIControlStateNormal];
        [sender setBackgroundImage:[UIImage imageNamed:@"teeball"] forState:UIControlStateSelected];
        [sender setBackgroundImage:[UIImage imageNamed:@"teeball"] forState:UIControlStateHighlighted];
    }
    NSString *URLString=[NSString stringWithFormat:@"%@user.php?mode=addactivityLike&userid=%@&activityid=%@&type=%@", API, [self LoggedId], [MutdicTee objectForKey:@"ActivityLikeId"], (Like)?@"dislike":@"like"];
    
    [self PingServer:URLString];
    
    [ActivityArray replaceObjectAtIndex:sender.tag-(TEETAG+1) withObject:MutdicTee];
    
}

//--------------------- Perform comment operation ------------------//

-(IBAction)CommmentButton:(UIButton *)sender
{
    TotalcommentHeight=0.0f;
    LoadFirsttime=TRUE;
    isloadFirsttime=TRUE;
    NSMutableDictionary *MutDicAll=[ActivityArray objectAtIndex:sender.tag-(COMMENTTAG+1)];
    commentposition=sender.tag-(COMMENTTAG+1);
    CommentButton=sender;
    [self opencommentWithActivityDictionary:MutDicAll];
    
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    
    CGRect frame=[self.Scarchicon frame];
    frame.origin.x=9;
    [UIView animateWithDuration:.3f animations:^{
        
        self.Scarchicon.frame=frame;
        
        
    }];
    
    
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    
    [textField resignFirstResponder];
    
    
    if ([self.manuSearchtxt.text length]<1)
    {
        CGRect frame=[self.Scarchicon frame];
        frame.origin.x=122;
        [UIView animateWithDuration:.3f animations:^{
            
            self.Scarchicon.frame=frame;
            
            
        }];
        
    }
    
    return YES;
}


//Per form Load more operation on reaching To the scroll end

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView==profileTable)
    {
        CGPoint offset = scrollView.contentOffset;
        CGRect bounds = scrollView.bounds;
        CGSize size = scrollView.contentSize;
        UIEdgeInsets inset = scrollView.contentInset;
        float y = offset.y + bounds.size.height - inset.bottom;
        float h = size.height;
        
        float reload_distance = -40.0f;
        if(y > h + reload_distance)
        {
            if (IsMoredataAvaiable==YES)
            {
                [self.view setUserInteractionEnabled:YES];
                
                _LoadingLableView.hidden=NO;
                CGRect tableframe=[profileTable frame];
                tableframe.size.height=456.0f-25.0f;
                
                [profileTable setFrame:tableframe];
                
                NSInvocationOperation *invocation=[[NSInvocationOperation alloc] initWithTarget:self selector:@selector(DetActivityStreem:) object:LastID];
                [OperationQactivity addOperation:invocation];
            }
            else
            {
                
                
                CGRect tableframe=[profileTable frame];
                _LoadingLableView.hidden=YES;
                tableframe.size.height=456.0f;
                [profileTable setFrame:tableframe];
            }
            
        }
        
        
    }
    
}


-(void)textViewDidBeginEditing:(UITextView *)textView
{
    
    LoadFirsttime=FALSE;
    CommentTableConteheight=commenttable.contentSize.height;
    
    [commenttable setContentOffset:CGPointMake(0, TotalcommentHeight-150) animated:YES];
    [commenttable setContentSize:CGSizeMake(320, commenttable.frame.size.height+TotalcommentHeight-150)];
    
    
    StatusTextLbl.hidden=YES;
    Commentwritelable.hidden=YES;
    
    
    [self UptheCencelOrdoneview];
    
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    if ([StatusTxt.text length]==0)
    {
        StatusTextLbl.hidden=NO;
    }
    if (_CommentTextview.text.length==0)
    {
        Commentwritelable.hidden=NO;
    }
}

// -------- Activity Indicator view ------- //

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    
    
    if([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        
        ISViewUP=TRUE;
        
        [_CommentTextview resignFirstResponder];
        [self UptheCencelOrdoneview];
        if (_CommentTextview.text.length>0)
        {
            NSMutableDictionary *ActivityDic=[CommntArry objectAtIndex:0];
            NSInvocationOperation *CommentInvocation=[[NSInvocationOperation alloc]initWithTarget:self selector:@selector(Postcommntonactivity:) object:[ActivityDic objectForKey:@"ActivityId"]];
            [OperationQactivity addOperation:CommentInvocation];
        }
        else
        {
            [commenttable setContentSize:CGSizeMake(320, CommentTableConteheight)];
            [commenttable setContentOffset:CGPointMake(0, 0) animated:YES];
            
            
        }
        
        return NO;
    }
    
    return YES;
}



//View did Dismiss

-(void)viewDidDisappear:(BOOL)animated
{
    [SVProgressHUD dismiss];
    [OprtationActivity cancelAllOperations];
}

// --------- perform Comment manu operation --------- //

-(void)UptheCencelOrdoneview
{
    CGRect Frame1=[mainCommentview frame];
    if (ISViewUP==FALSE)
    {
        Frame1.origin.y=306;
        [UIView animateWithDuration:0.18f animations:^{
            [mainCommentview setFrame:Frame1];
            
        }
                         completion:^(BOOL finish)
         {
             ISViewUP=TRUE;
         }];
    }
    else
    {
        Frame1.origin.y=523;
        [UIView animateWithDuration:0.18f animations:^{
            [mainCommentview setFrame:Frame1];
            
        }
                         completion:^(BOOL finish)
         {
             ISViewUP=FALSE;
         }];
    }
}








@end
