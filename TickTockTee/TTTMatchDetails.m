//
//  TTTMatchDetails.m
//  TickTockTee
//
//  Created by macbook_ms on 10/03/14.
//  Copyright (c) 2014 com.esolz.TickTockTee. All rights reserved.
//

#import "TTTMatchDetails.h"
#import "TTTGlobalMethods.h"
#import "TTTCellForgolferActivity.h"
#import "SVProgressHUD.h"
#import "AFNetworking.h"
#import "AFImageRequestOperation.h"
#import "TTTCellForgolferActivity.h"
#import "FXBlurView.h"
#import "TTTScoreBord.h"
#import "TTTMatchListing.h"

@interface TTTMatchDetails ()<UITableViewDelegate,UITableViewDataSource>
{
    UILabel *matchName;
    UILabel *coursename;
    UIView *Teeboxview;
    UIScrollView *matchPeopleScroll;
    UILabel *numborOfparticepant;
    UILabel *SlopLbl;
    UILabel *Ratting;
    UILabel *MatchHccp;
    BOOL ISDropdownManuOpen;
    NSMutableArray *ActivityArray;
    NSMutableArray *matchDetailsArray;
    NSOperationQueue *operation;
    NSMutableDictionary *MutableDic;
    NSMutableArray *MatchPlayerArry;
    UIImageView *MainDetailsbackimage;
    UILabel *matchdate;
    NSMutableArray *LeaderBordDetails;
    CGRect Frame;
    NSMutableDictionary *mymatchInfo;
    UIImage *matchimage;
    NSString *ViewerID;
    BOOL IsChatMenuBoxOpen;
    
}

@property (strong, nonatomic) IBOutlet UIView *HeaderBackview;

@property (strong, nonatomic) IBOutlet UIView *Mymatchinfoview;



@property (strong, nonatomic) IBOutlet UIView *ShowLeaderbordwithmatchdetais;

@property (strong, nonatomic) IBOutlet UIView *showmmymatchinfoWithmatchdetais;

@property (nonatomic, retain) UIView *DropdownMain;
@property (weak, nonatomic) IBOutlet UIButton *hoverButton;
@property (strong, nonatomic) IBOutlet UIView *joinmatchview;



@property (strong, nonatomic) IBOutlet UIView *ScoreCardView;


@property (strong, nonatomic) IBOutlet UIImageView *dropDownPng;

@property (strong, nonatomic) IBOutlet UIScrollView *LeaderBordScroll;
@property (strong, nonatomic) IBOutlet UILabel *LblmatchDetais;
@property (strong, nonatomic) IBOutlet UIView *matchDeailView;
@property (strong, nonatomic) IBOutlet UITableView *ActivitytblView;
@property (strong, nonatomic) IBOutlet UIView *VfooterBack;
@property (strong, nonatomic) IBOutlet UILabel *Headerlable;
@property (strong, nonatomic) IBOutlet UIView *tblheader;
@property (strong, nonatomic) IBOutlet UIButton *SettingBtn;

@property (strong, nonatomic) IBOutlet UIView *dropdownView;

@property (strong, nonatomic) IBOutlet UIButton *matchdetisBtn;
@property (strong, nonatomic) IBOutlet UIButton *leaderbordBtn;

@property (strong, nonatomic) IBOutlet UIButton *mymatchinfobutton;

@property (strong, nonatomic) IBOutlet UIView *leaderbordScrollback;

@property (strong, nonatomic) IBOutlet UIView *screenView;
@property (strong, nonatomic) IBOutlet UIView *chatView;

@end

@implementation TTTMatchDetails
@synthesize LblmatchDetais,matchDeailView,ActivitytblView,VfooterBack,matchID,DropdownMain,ParamViewerID;
@synthesize Commsfromcretematch,Iscommingfromcreatematch;
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
    //  Do any additional setup after loading the view from its nib .  //
    IsChatMenuBoxOpen=NO;
    self.chatView.hidden=YES;
    if (!IsIphone5)
    {
        CGRect frame= [_LeaderBordScroll frame];
        _LeaderBordScroll.backgroundColor=[UIColor clearColor];
        frame.origin.y=88+60;
        [_LeaderBordScroll setFrame:frame];
        CGRect frame2=[_HeaderBackview frame];
        frame2.size.height=60;
        [_HeaderBackview setFrame:frame2];
        CGRect frame3=[VfooterBack frame];
        frame3.origin.y=480-49;
        [VfooterBack setFrame:frame3];
        
    }
    _LeaderBordScroll.hidden=YES;
    _leaderbordScrollback.hidden=YES;
    NSLog(@"The value of Commsfromcretematch:%@",Commsfromcretematch);
    NSLog(@"The value of Commsfromcretematch:%hhd",Iscommingfromcreatematch);
    
    
    self.Mymatchinfoview.hidden=YES;
    ViewerID=(ParamViewerID.length>0)?ParamViewerID:[self LoggedId];
    ActivityArray=[[NSMutableArray alloc]init];
    ActivityArray=[[NSMutableArray alloc]init];
    matchDetailsArray=[[NSMutableArray alloc]init];
    operation=[[NSOperationQueue alloc]init];
    [SVProgressHUD showWithStatus:@"Please wait"];
    ISDropdownManuOpen=FALSE;
    
    LblmatchDetais.font=[UIFont fontWithName:MYREADPROREGULAR size:17.0f];
    ActivitytblView.backgroundColor=[UIColor clearColor];
    self.Headerlable.font=[UIFont fontWithName:MYRIARDPROSAMIBOLT size:16.0f];
    ActivitytblView.delegate=self;
    ActivitytblView.dataSource=self;
    
    UIView *matchView=[[[NSBundle mainBundle] loadNibNamed:@"EtendedDesignView" owner:self options:nil] objectAtIndex:0];
    matchName=(UILabel *)[matchView viewWithTag:1];
    matchName.font=[UIFont fontWithName:MYRIARDPROSAMIBOLT size:16.0f];
    matchdate=(UILabel *)[matchView viewWithTag:40];
    matchdate.font=[UIFont fontWithName:MYREADPROREGULAR size:15.0f];
    coursename=(UILabel *)[matchView viewWithTag:2];
    coursename.font=[UIFont fontWithName:SEGIOUI size:16.0f];
    MainDetailsbackimage=(UIImageView *)[matchView viewWithTag:30];
    
    Teeboxview=(UIView *)[matchView viewWithTag:3];
    [self setRoundBorderToUiview:Teeboxview];
    
    matchPeopleScroll=(UIScrollView *)[matchView viewWithTag:4];
    
    numborOfparticepant=(UILabel *)[matchView viewWithTag:5];
    numborOfparticepant.font=[UIFont fontWithName:MYRIARDPROLIGHT size:12.0f];
    
    SlopLbl=(UILabel *)[matchView viewWithTag:6];
    [SlopLbl setText:@"10"];
    SlopLbl.font=[UIFont fontWithName:MYRIARDPROLIGHT size:20.0f];
    Ratting=(UILabel *)[matchView viewWithTag:7];
    Ratting.font=[UIFont fontWithName:MYRIARDPROLIGHT size:20.0f];
    MatchHccp=(UILabel *)[matchView viewWithTag:8];
    MatchHccp.font=[UIFont fontWithName:MYRIARDPROLIGHT size:20.0f];
    [matchView setFrame:CGRectMake(0, 0, 320,  216)];
    [matchDeailView addSubview:matchView];
    MutableDic=[[NSMutableDictionary alloc]init];
    MatchPlayerArry=[[NSMutableArray alloc]init];
    NSInvocationOperation *MatchDetaisoperation=[[NSInvocationOperation alloc]initWithTarget:self selector:@selector(DuMyjob) object:nil];
    [operation addOperation:MatchDetaisoperation];
    
    
}



-(void)DuMyjob
{
    if ([self isConnectedToInternet])
    {
        
        @try
        {
            NSError *Error;
            NSString  *URL=[NSString stringWithFormat:@"%@user.php?mode=matchdetails&matchid=%@&userid=%@&loggedin_userid=%@", API,matchID,ViewerID,[self LoggedId]];
            NSLog(@"%@", URL);
            
            NSData *getData=[NSData dataWithContentsOfURL:[NSURL URLWithString:URL]];
            
            NSDictionary *Output=[NSJSONSerialization JSONObjectWithData:getData options:kNilOptions error:&Error];
            
            [MutableDic setObject:[Output valueForKey:@"MatchId"] forKey:@"MatchId"];
            [MutableDic setObject:[Output valueForKey:@"MatchTitle"] forKey:@"MatchTitle"];
            [MutableDic setObject:[Output valueForKey:@"MatchLocation"] forKey:@"MatchLocation"];
            [MutableDic setObject:[Output valueForKey:@"MatchCourse"] forKey:@"MatchCourse"];
            [MutableDic setObject:[Output valueForKey:@"MatchTeeboxColor"] forKey:@"MatchTeeboxColor"];
            [MutableDic setObject:[Output valueForKey:@"MatchInvitedGuest"] forKey:@"MatchInvitedGuest"];
            [MutableDic setObject:[Output valueForKey:@"MatchConfirmedCount"] forKey:@"MatchConfirmedCount"];
            [MutableDic setObject:[Output valueForKey:@"MatchCoverImage"] forKey:@"MatchCoverImage"];
            [MutableDic setObject:[Output valueForKey:@"MatchImage"] forKey:@"MatchImage"];
            [MutableDic setObject:[Output valueForKey:@"MatchSlope"] forKey:@"MatchSlope"];
            [MutableDic setObject:[Output valueForKey:@"MatchHCP"] forKey:@"MatchHCP"];
            [MutableDic setValue:[Output valueForKey:@"MatchRating"] forKey:@"MatchRating"];
            [MutableDic setValue:[Output valueForKey:@"MatchStartDate"] forKey:@"MatchStartDate"];
            
            [MutableDic setObject:[Output valueForKey:@"MatchRegisteredMember"] forKey:@"MatchRegisteredMember"];
            [MutableDic setObject:[Output valueForKey:@"MatchCreator"] forKey:@"MatchCreator"];
            [MutableDic setObject:[Output valueForKey:@"MyMatchInfo"] forKey:@"MyMatchInfo"];
            [MutableDic setObject:[Output valueForKey:@"MatchScorecard"] forKey:@"MatchScorecard"];
            [MutableDic setObject:[Output valueForKey:@"MatchLeaderbord"] forKey:@"MatchLeaderbord"];
            [MutableDic setObject:[Output valueForKey:@"MatchEditPermission"] forKey:@"MatchEditPermission"];
            [MutableDic setObject:[Output valueForKey:@"MatchJoinStatus"] forKey:@"MatchJoinStatus"];
            
            NSArray *PlayerDetais=[Output objectForKey:@"MatchPlayers"];
            
            for (NSDictionary *dic in PlayerDetais)
            {
                NSMutableDictionary *myimageDoictionary=[[NSMutableDictionary alloc]init];
                [myimageDoictionary setObject:[dic valueForKey:@"id"] forKey:@"id"];
                [myimageDoictionary setObject:[dic valueForKey:@"payerImage"] forKey:@"payerImage"];
                [myimageDoictionary setObject:[dic valueForKey:@"PlayerLink"] forKey:@"PlayerLink"];
                [MatchPlayerArry addObject:myimageDoictionary];
            }
            
            NSArray *matchActivity=[Output valueForKey:@"MatchActivity"];
            for (NSDictionary *activityDic in matchActivity)
            {
                NSMutableDictionary *Activitymutdic=[[NSMutableDictionary alloc]init];
                [Activitymutdic setObject:[self RemoveNullandreplaceWithSpace:[activityDic valueForKey:@"MatchActivityId"]] forKey:@"MatchActivityId"];
                [Activitymutdic setObject:[self RemoveNullandreplaceWithSpace:[activityDic valueForKey:@"MatchActivityAppType"]] forKey:@"MatchActivityAppType"];
                [Activitymutdic setObject:[self RemoveNullandreplaceWithSpace:[activityDic valueForKey:@"MatchActivityTitle"]] forKey:@"MatchActivityTitle"];
                [Activitymutdic setObject:[self RemoveNullandreplaceWithSpace:[activityDic valueForKey:@"MatchActivityCreator"]] forKey:@"MatchActivityCreator"];
                [Activitymutdic setObject:[self RemoveNullandreplaceWithSpace:[activityDic valueForKey:@"MatchActivityCreatorTitle"]] forKey:@"MatchActivityCreatorTitle"];
                [Activitymutdic setObject:[self RemoveNullandreplaceWithSpace:[activityDic valueForKey:@"MatchActivityCreatorImage"]] forKey:@"MatchActivityCreatorImage"];
                [Activitymutdic setObject:[self RemoveNullandreplaceWithSpace:[activityDic valueForKey:@"MatchActivityCreatedDate"]] forKey:@"MatchActivityCreatedDate"];
                [Activitymutdic setObject:[self RemoveNullandreplaceWithSpace:[activityDic valueForKey:@"MatchActivityCreatedRawDate"]] forKey:@"MatchActivityCreatedRawDate"];
                [Activitymutdic setObject:[self RemoveNullandreplaceWithSpace:[activityDic valueForKey:@"MatchActivityCommentCount"]] forKey:@"MatchActivityCommentCount"];
                [Activitymutdic setObject:[self RemoveNullandreplaceWithSpace:[activityDic valueForKey:@"MatchActivityCommentAllow"]] forKey:@"MatchActivityCommentAllow"];
                [Activitymutdic setObject:[self RemoveNullandreplaceWithSpace:[activityDic valueForKey:@"MatchActivityLikeCount"]] forKey:@"MatchActivityLikeCount"];
                [Activitymutdic setObject:[self RemoveNullandreplaceWithSpace:[activityDic valueForKey:@"MatchActivityLikeAllow"]] forKey:@"MatchActivityLikeAllow"];
                [ActivityArray addObject:Activitymutdic];
                
                
            }
            NSLog(@"I am here");
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self reloadData];
            });
            
        }
        @catch (NSException *exception)
        {
            NSLog(@"The value of:%@",exception);
        }
        
        
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [SVProgressHUD showErrorWithStatus:@"no internet connection available"];
            
        });
    }
    
    
    
    
}


-(void)reloadData
{
    
    [ActivitytblView reloadData];
    
    coursename.text=[MutableDic valueForKey:@"MatchCourse"];
    matchName.text=[MutableDic valueForKey:@"MatchTitle"];
    SlopLbl.text=[MutableDic valueForKey:@"MatchSlope"];
    MatchHccp.text=[MutableDic valueForKey:@"MatchHCP"];
    Ratting.text=[MutableDic valueForKey:@"MatchRating"];
    
    if ([[MutableDic objectForKey:@"MyMatchInfo"] integerValue]==0&[[MutableDic objectForKey:@"MatchLeaderbord"] integerValue]==0)
    {
        [[self hoverButton] setUserInteractionEnabled:NO];
        self.dropDownPng.hidden=YES;
    }
    else if ([[MutableDic objectForKey:@"MyMatchInfo"] integerValue]==1&[[MutableDic objectForKey:@"MatchLeaderbord"] integerValue]==0)
    {
        
        DropdownMain=_showmmymatchinfoWithmatchdetais;
        DropdownMain.backgroundColor=UIColorFromRGB(0x9cc6d9);
        Frame=CGRectMake(0, 60, 320, 110);
        
    }
    else if ([[MutableDic objectForKey:@"MyMatchInfo"] integerValue]==0&[[MutableDic objectForKey:@"MatchLeaderbord"] integerValue]==1)
    {
        DropdownMain=_ShowLeaderbordwithmatchdetais;
        Frame=CGRectMake(0, 60, 320, 110);
        DropdownMain.backgroundColor=UIColorFromRGB(0x9cc6d9);
    }
    else
    {
        _matchdetisBtn.hidden=YES;
        _leaderbordBtn.hidden=YES;
        
        _dropdownView.backgroundColor=UIColorFromRGB(0x9cc6d9);
        _dropdownView.frame=CGRectMake(0, 60, 320, 0);
        [_leaderbordBtn setTitle:@"Leaderboard" forState:UIControlStateNormal];
        [_leaderbordBtn setTitle:@"Leaderboard" forState:UIControlStateHighlighted];
        [_leaderbordBtn setTitle:@"Leaderboard" forState:UIControlStateSelected];
        
        [_matchdetisBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_leaderbordBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        _leaderbordBtn.titleLabel.font=[UIFont fontWithName:MYRIARDPROSAMIBOLT size:17.0f];
        _matchdetisBtn.titleLabel.font=[UIFont fontWithName:MYRIARDPROSAMIBOLT size:17.0f];
        
        
        [_matchdetisBtn setTitle:@"Match Details" forState:UIControlStateNormal];
        [_matchdetisBtn setTitle:@"Match Details" forState:UIControlStateHighlighted];
        [_matchdetisBtn setTitle:@"Match Details" forState:UIControlStateSelected];
        
        Frame=CGRectMake(0, 60, 320, 165);
        DropdownMain=_dropdownView;
        
    }
    
    
    if ([[MutableDic objectForKey:@"MatchEditPermission"] integerValue]==0)
    {
        [self.SettingBtn setHidden:YES];
    }
    if ([[MutableDic objectForKey:@"MatchScorecard"] integerValue]==1&&[[MutableDic objectForKey:@"MatchJoinStatus"] integerValue]==0)
    {
        [[self VfooterBack] addSubview:_ScoreCardView];
    }
    else if ([[MutableDic objectForKey:@"MatchScorecard"] integerValue]==0&&[[MutableDic objectForKey:@"MatchJoinStatus"] integerValue]==1)
    {
        [[self VfooterBack] addSubview:_joinmatchview];
    }
    else
    {
        [self AddNavigationBarTo:self.VfooterBack];
    }
    
    
    
    NSString *dateString=[[[MutableDic valueForKey:@"MatchStartDate"] componentsSeparatedByString:@" "] objectAtIndex:1];
    [matchdate setText:dateString];
    NSAttributedString *attributedText =
    [[NSAttributedString alloc]
     initWithString:[self RemoveNullandreplaceWithSpace:[MutableDic valueForKey:@"MatchCourse"]]
     attributes:@
     {
     NSFontAttributeName:[UIFont fontWithName:MYRIARDPROLIGHT size:16.0f]
     }];
    
    CGRect rect = [attributedText boundingRectWithSize:(CGSize){200, 18}
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                               context:nil];
    CGSize size = rect.size;
    NSString *participant;
    if ([[MutableDic valueForKey:@"MatchConfirmedCount"] integerValue]==1)
    {
        
        participant=[NSString stringWithFormat:@"%@ %@",[MutableDic valueForKey:@"MatchConfirmedCount"],@"Participant"];
    }
    else
    {
        participant=[NSString stringWithFormat:@"%@ %@",[MutableDic valueForKey:@"MatchConfirmedCount"],@"Participant's"];
        
    }
    
    [numborOfparticepant setText:participant];
    
    
    
    
    NSString *BackgroundImageStgring=[MutableDic valueForKey:@"MatchImage"];
    
    NSURLRequest *request_img = [NSURLRequest requestWithURL:[NSURL URLWithString:BackgroundImageStgring]];
    AFImageRequestOperation *operationDownload = [AFImageRequestOperation imageRequestOperationWithRequest:request_img
                                                                                      imageProcessingBlock:nil
                                                                                                   success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                                                                       if(image!=nil)
                                                                                                       {
                                                                                                           
                                                                                                           [SVProgressHUD dismiss];
                                                                                                           image=[image blurredImageWithRadius:2 iterations:1 tintColor:[UIColor darkGrayColor]];
                                                                                                           [MainDetailsbackimage setImage:image];
                                                                                                           matchimage=image;
                                                                                                       }
                                                                                                       
                                                                                                   }
                                                                                                   failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error)
                                                  {
                                                      NSLog(@"Error %@",error);
                                                      
                                                      [MainDetailsbackimage setImage:[UIImage imageNamed:@"picture.png"]];
                                                      [SVProgressHUD dismiss];
                                                  }];
    [operationDownload start];
    
    
    CGRect TeeBoxframe=[Teeboxview frame];
    TeeBoxframe.origin.x=coursename.frame.origin.x+size.width+20;
    TeeBoxframe.origin.y+=2;
    
    
    [Teeboxview setFrame:TeeBoxframe];
    Teeboxview.layer.cornerRadius=6.0f;
    [Teeboxview.layer setMasksToBounds:YES];
    [Teeboxview setBackgroundColor:[TTTGlobalMethods colorFromHexString:[MutableDic valueForKey:@"MatchTeeboxColor"]]];
    
    
    
    //-----ScrooView full functionaly design-------//.
    
    
    NSInteger numbor=[MatchPlayerArry count];
    
    [matchPeopleScroll setContentSize:CGSizeMake(numbor*50, matchPeopleScroll.frame.size.height)];
    if (numbor%2==1)
    {
        
        UIView *backView;
        UIImageView *ImageView;
        
        if (numbor==1)
        {
            ImageView=[[UIImageView alloc]initWithFrame:CGRectMake(140, 2, 40, 40)];
            backView=[[UIView alloc] initWithFrame:CGRectMake(138, 0, 44, 44)];
            
            [self SetroundborderWithborderWidth:2.0f WithColour:[UIColor clearColor] ForImageview:ImageView];
            [self SetroundborderWithborderWidth:2.0f WithColour:[UIColor whiteColor] ForView:backView];
            
            
            NSURLRequest *request_img2 = [NSURLRequest requestWithURL:[NSURL URLWithString:[[MatchPlayerArry objectAtIndex:0] valueForKey:@"payerImage"]]];
            AFImageRequestOperation *operationimage = [AFImageRequestOperation imageRequestOperationWithRequest:request_img2
                                                                                           imageProcessingBlock:nil
                                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                                                                            if(image!=nil)
                                                                                                            {
                                                                                                                
                                                                                                                ImageView.image=image;//[UIImage imageWithCGImage:CGImageCreateWithImageInRect(image.CGImage, CGRectMake(0, 0, 40, 40))];
                                                                                                                
                                                                                                                
                                                                                                            }
                                                                                                            
                                                                                                        }
                                                                                                        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                                                                                            NSLog(@"Error %@",error);
                                                                                                            
                                                                                                        }];
            [operationimage start];
            [matchPeopleScroll addSubview:backView];
            [matchPeopleScroll addSubview:ImageView];
            
            
        }
        else
        {
            for (int i=0; i<numbor; i++)
            {
                
                NSInteger Start=numbor/2;
                CGFloat x=138-(50*Start);
                if (x>0)
                {
                    
                    ImageView=[[UIImageView alloc]initWithFrame:CGRectMake((138-(50*Start))+(50*i), 2, 40, 40)];
                    backView=[[UIView alloc]initWithFrame:CGRectMake((136-(50*Start))+(50*i), 0, 44, 44)];
                    [self SetroundborderWithborderWidth:2.0f WithColour:[UIColor whiteColor] ForView:backView];
                    [self SetroundborderWithborderWidth:2.0f WithColour:[UIColor clearColor] ForImageview:ImageView];
                    
                    
                }
                else
                {
                    
                    ImageView=[[UIImageView alloc]initWithFrame:CGRectMake((50*i)+2, 2, 40, 40)];
                    backView=[[UIView alloc]initWithFrame:CGRectMake((50*i), 0, 44, 44)];
                    [self SetroundborderWithborderWidth:2.0f WithColour:[UIColor whiteColor] ForView:backView];
                    [self SetroundborderWithborderWidth:2.0f WithColour:[UIColor clearColor] ForImageview:ImageView];
                    
                }
                // [self SetroundborderWithborderWidth:2.0f WithColour:UIColorFromRGB(0xc9c9c9) ForImageview:ImageView];
                NSString *imageStrinh=[[MatchPlayerArry objectAtIndex:i] valueForKey:@"payerImage"];
                NSURLRequest *request_img3 = [NSURLRequest requestWithURL:[NSURL URLWithString:imageStrinh]];
                
                
                
                
                
                AFImageRequestOperation *operationImage3 = [AFImageRequestOperation imageRequestOperationWithRequest:request_img3
                                                                                                imageProcessingBlock:nil
                                                                                                             success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                                                                                 if(image!=nil)
                                                                                                                 {
                                                                                                                     
                                                                                                                     ImageView.image=image;//[UIImage imageWithCGImage:CGImageCreateWithImageInRect(image.CGImage, CGRectMake(0, 0, 40, 40))];
                                                                                                                     
                                                                                                                     
                                                                                                                 }
                                                                                                                 
                                                                                                             }
                                                                                                             failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error)
                                                            {
                                                                
                                                                
                                                                NSLog(@"The error:%@",error);
                                                                
                                                            }];
                [operationImage3 start];
                [matchPeopleScroll addSubview:backView];
                [matchPeopleScroll addSubview:ImageView];
                
                
            }
        }
    }
    else
    {
        
        
        
        
        for (int i=0; i<numbor; i++)
        {
            UIImageView *ImageView2;
            UIView *backView2;
            NSInteger Start=numbor/2;
            CGFloat x=161-(50*Start);
            CGFloat y=163-(50*Start);
            if (x>0)
            {
                
                ImageView2 =[[UIImageView alloc]initWithFrame:CGRectMake(y+(50*i), 2, 40, 40)];
                backView2 =[[UIView alloc]initWithFrame:CGRectMake(x+(50*i), 0, 44, 44)];
                [self SetroundborderWithborderWidth:2.0f WithColour:[UIColor whiteColor] ForView:backView2];
                [self SetroundborderWithborderWidth:2.0f WithColour:[UIColor clearColor] ForImageview:ImageView2];
                
                
                
            }
            else
            {
                ImageView2=[[UIImageView alloc]initWithFrame:CGRectMake((50*i)+2, 2, 40, 40)];
                backView2=[[UIView alloc]initWithFrame:CGRectMake((50*i), 0, 44, 44)];
                [self SetroundborderWithborderWidth:2.0f WithColour:[UIColor whiteColor] ForView:backView2];
                [self SetroundborderWithborderWidth:2.0f WithColour:[UIColor clearColor] ForImageview:ImageView2];
                
            }
            
            
            
            
            //download image
            
            NSURLRequest *request_img4 = [NSURLRequest requestWithURL:[NSURL URLWithString:[[MatchPlayerArry objectAtIndex:i] valueForKey:@"payerImage"]]];
            AFImageRequestOperation *operationimage3 = [AFImageRequestOperation imageRequestOperationWithRequest:request_img4
                                                                                            imageProcessingBlock:nil
                                                                                                         success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                                                                             if(image!=nil)
                                                                                                             {
                                                                                                                 
                                                                                                                 ImageView2.image=image;
                                                                                                                 
                                                                                                                 
                                                                                                             }
                                                                                                             
                                                                                                         }
                                                                                                         failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                                                                                             
                                                                                                         }];
            [operationimage3 start];
            [matchPeopleScroll addSubview:backView2];
            [matchPeopleScroll addSubview:ImageView2];
            
        }
    }
    
    
    
    
}






- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//Tableview data source mathods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [ActivityArray count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // static NSString *CellId=@"CellInfoid";
    NSMutableDictionary *mainDic=[ActivityArray objectAtIndex:indexPath.row];
    TTTCellForgolferActivity *cell;
    
    cell=(TTTCellForgolferActivity *)[tableView dequeueReusableCellWithIdentifier:@"TTTCellForActivityComment"];
    if (cell==nil)
    {
        NSArray *CellNib=[[NSBundle mainBundle] loadNibNamed:@"TTTCellForgolferActivity" owner:self options:nil];
        cell=(TTTCellForgolferActivity *)[CellNib objectAtIndex:0];
    }
    [self SetroundborderWithborderWidth:2.0f WithColour:[UIColor whiteColor] ForView:cell.BackView];
    [self SetroundborderWithborderWidth:2.0f WithColour:[UIColor clearColor] ForImageview:cell.useruimage];
    cell.BackView.backgroundColor=[UIColor clearColor];
    
    NSURLRequest *request_img4 = [NSURLRequest requestWithURL:[NSURL URLWithString:[mainDic valueForKey:@"MatchActivityCreatorImage"]]];
    AFImageRequestOperation *operationimage3 = [AFImageRequestOperation imageRequestOperationWithRequest:request_img4
                                                                                    imageProcessingBlock:nil
                                                                                                 success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                                                                     if(image!=nil)
                                                                                                     {
                                                                                                         
                                                                                                         cell.useruimage.image=image;
                                                                                                         
                                                                                                         
                                                                                                     }
                                                                                                     
                                                                                                 }
                                                                                                 failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                                                                                     
                                                                                                 }];
    [operationimage3 start];
    cell.NameLbl.font=[UIFont fontWithName:MYRIARDPROSAMIBOLT size:15.0f];
    cell.NameLbl.text=[mainDic valueForKey:@"MatchActivityCreatorTitle"];
    cell.dateTimelbl.text=[mainDic valueForKey:@"MatchActivityCreatedDate"];
    cell.dateTimelbl.font=[UIFont fontWithName:SEGIOUI size:12.0f];
    cell.DescriptionLbl.text=[mainDic valueForKey:@"MatchActivityTitle"];
    cell.DescriptionLbl.font=[UIFont fontWithName:MYRIARDPROLIGHT size:14.0f];
    
    
    
    cell.backgroundColor=[UIColor clearColor];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0f;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}

//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    return self.tblheader;
//}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (IBAction)backtopriviouspage:(id)sender
{
    if (Iscommingfromcreatematch==TRUE)
    {
        TTTMatchListing *matchlist=[[TTTMatchListing alloc]init];
        [self PushViewController:matchlist TransitationFrom:kCATransitionFromBottom];
    }
    else
    {
        NSUserDefaults *userdefalds=[NSUserDefaults standardUserDefaults];
        [userdefalds setValue:nil forKey:SESSION_MATCHCREATEPARAMETES];
        [userdefalds setValue:nil forKey:COURSE_ID];
        [userdefalds setValue:nil forKey:COURSE_NAME];
        [userdefalds synchronize];
        [self PerformGoBack];
    }
}
- (IBAction)performDropdown:(id)sender
{
    _matchdetisBtn.hidden=YES;
    _leaderbordBtn.hidden=YES;
    _mymatchinfobutton.hidden=YES;
    
    DropdownMain.frame=CGRectMake(0, 60, 320, 0);
    
    
    [self.view addSubview:DropdownMain];
    
    
    if (ISDropdownManuOpen==FALSE)
    {
        [DropdownMain setHidden:NO];
        
        [UIView animateWithDuration:.2 animations:^{
            DropdownMain.frame=Frame;
            
        }
                         completion:^(BOOL finished)
         {
             ISDropdownManuOpen=TRUE;
             
             _matchdetisBtn.hidden=NO;
             _leaderbordBtn.hidden=NO;
             _mymatchinfobutton.hidden=NO;
         }];
    }
    else
    {
        _matchdetisBtn.hidden=YES;
        _leaderbordBtn.hidden=YES;
        _mymatchinfobutton.hidden=YES;
        
        
        [UIView animateWithDuration:.2 animations:^{
            DropdownMain.frame=CGRectMake(0, 60, 320, 0);
            
        }
                         completion:^(BOOL finished)
         {
             ISDropdownManuOpen=FALSE;
             
             [DropdownMain setHidden:YES];
         }];
    }
    
}


- (IBAction)SettingIcom:(id)sender
{
    
    
    
}
- (IBAction)matchDetailsPage:(id)sender
{
    
    [self.dropdownView removeFromSuperview];
    
    matchDeailView.hidden=NO;
    _LeaderBordScroll.hidden=YES;
    _leaderbordScrollback.hidden=YES;
    _Mymatchinfoview.hidden=YES;
    CGRect frame1=[ActivitytblView frame];
    CGRect frame2=[_tblheader frame];
    frame2.origin.y=275;
    _tblheader.frame=frame2;
    frame1.origin.y=240+70;
    frame1.size.height=328-70;
    [ActivitytblView setFrame:frame1];
    LblmatchDetais.text=@"Match Details";
    
    
}

- (IBAction)LeaderBordDetais:(id)sender
{
    
    
    LblmatchDetais.text=@"Leaderboard";
    [self.ShowLeaderbordwithmatchdetais removeFromSuperview];
    matchDeailView.hidden=YES;
    _Mymatchinfoview.hidden=YES;
    _LeaderBordScroll.hidden=NO;
    _leaderbordScrollback.hidden=NO;
    CGRect frame1=[ActivitytblView frame];
    CGRect frame2=[_tblheader frame];
    frame2.origin.y=205;
    _tblheader.frame=frame2;
    frame1.origin.y=240;
    frame1.size.height=328;
    [ActivitytblView setFrame:frame1];
    
    [self.dropdownView removeFromSuperview];
    LeaderBordDetails=[[NSMutableArray alloc] init];
    [SVProgressHUD show];
    NSInvocationOperation *operationleaderbord=[[NSInvocationOperation alloc] initWithTarget:self selector:@selector(Doleaderbordwork) object:nil];
    [operation addOperation:operationleaderbord];
    
}

-(void)leaderBordviewoperation
{
    
    
    [SVProgressHUD dismiss];
    
    for (int i=0; i<[LeaderBordDetails count]; i++)
    {
        
        NSMutableDictionary *leaderBordDic=[LeaderBordDetails objectAtIndex:i];
        
        UIView *mainview=[[[NSBundle mainBundle] loadNibNamed:@"EtendedDesignView" owner:self options:nil] objectAtIndex:2];
        
        UIView *userimageback=(UIView *)[mainview viewWithTag:10];
        
        UIImageView *userimage=(UIImageView *)[mainview viewWithTag:11];
        [self SetroundborderWithborderWidth:2.0f WithColour:[UIColor clearColor] ForImageview:userimage];
        [self SetroundborderWithborderWidth:2.0f WithColour:[UIColor whiteColor] ForView:userimageback];
        NSURLRequest *request_img2 = [NSURLRequest requestWithURL:[NSURL URLWithString:[leaderBordDic valueForKey:@"PlayerImage"]]];
        AFImageRequestOperation *operationimage = [AFImageRequestOperation imageRequestOperationWithRequest:request_img2
                                                                                       imageProcessingBlock:nil
                                                                                                    success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                                                                        if(image!=nil)
                                                                                                        {
                                                                                                            [userimage setImage:image];
                                                                                                        }
                                                                                                        
                                                                                                    }
                                                                                                    failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                                                                                        NSLog(@"Error %@",error);
                                                                                                        
                                                                                                    }];
        [operationimage start];
        
        
        UILabel *GolfrName=(UILabel *)[mainview viewWithTag:12];
        GolfrName.font=[UIFont fontWithName:MYRIARDPROSAMIBOLT size:16.0f];
        [GolfrName setText:[leaderBordDic valueForKey:@"PlayerName"]];
        
        UILabel *lableleaderbord=(UILabel *)[mainview viewWithTag:300];
        [lableleaderbord setFont:[UIFont fontWithName:MYREADPROREGULAR size:12.0f]];
        [lableleaderbord setText:[NSString stringWithFormat:@"%d",i+1]];
        
        UILabel *MatchHccplbl=(UILabel *)[mainview viewWithTag:13.0f];
        MatchHccplbl.font=[UIFont fontWithName:MYREADPROREGULAR size:12.0f];
        [MatchHccplbl setText:[NSString stringWithFormat:@"%@: %@",@"Match Hcp",[leaderBordDic valueForKey:@"MatchHCP"]]];
        
        UILabel *inprogresslbl=(UILabel *)[mainview viewWithTag:14];
        inprogresslbl.font=[UIFont fontWithName:MYRIARDPROSAMIBOLT size:12.0f];
        
        inprogresslbl.text=[NSString stringWithFormat:@"%@: %@",@"In Progress",[leaderBordDic valueForKey:@"MatchHole"]];
        
        UILabel *ToperLbl=(UILabel *)[mainview viewWithTag:15];
        ToperLbl.font=[UIFont fontWithName:MYRIARDPROSAMIBOLT size:12.0f];
        ToperLbl.text=[NSString stringWithFormat:@"%@: %@",@"To Par",[leaderBordDic valueForKey:@"MatchToPar"]];
        mainview.frame=CGRectMake(120*i, 0, 120, 145);
        
        [self.LeaderBordScroll addSubview:mainview];
    }
    
    
}

-(void)Doleaderbordwork
{
    NSLog(@"match id:%@",matchID);
    NSString *LeaderBordString=[NSString stringWithFormat:@"%@user.php?mode=leaderbordDetails&userid=%@&eventid=%@&loggedin_userid=%@",API,ViewerID,matchID,[self LoggedId]];
    NSLog(@"The leader bord array:%@",LeaderBordString);
    NSURL *mainurl=[NSURL URLWithString:LeaderBordString];
    NSData *data=[NSData dataWithContentsOfURL:mainurl];
    NSDictionary *mainDic=[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    NSArray *ledeaderBordArray=[mainDic valueForKey:@"MatchLeaderbord"];
    
    for (NSDictionary *leaderDic in ledeaderBordArray)
    {
        NSString *playerId=[leaderDic valueForKey:@"PlayerId"];
        NSString *playerName=[leaderDic valueForKey:@"PlayerName"];
        NSString *playerimage=[leaderDic valueForKey:@"PlayerImage"];
        NSString *Matchhccp=[leaderDic valueForKey:@"MatchHCP"];
        NSString *matchTopar=[leaderDic valueForKey:@"MatchToPar"];
        NSString *matchHole=[leaderDic valueForKey:@"MatchHole"];
        NSString *matchNetScore=[leaderDic valueForKey:@"MatchNetScore"];
        
        NSMutableDictionary *mutableDic=[[NSMutableDictionary alloc]init];
        [mutableDic setValue:playerId forKey:@"PlayerId"];
        [mutableDic setValue:playerName forKey:@"PlayerName"];
        [mutableDic setValue:playerimage forKey:@"PlayerImage"];
        [mutableDic setValue:Matchhccp forKey:@"MatchHCP"];
        [mutableDic setValue:matchTopar forKey:@"MatchToPar"];
        [mutableDic setValue:matchHole forKey:@"MatchHole"];
        [mutableDic setValue:matchNetScore forKey:@"MatchNetScore"];
        
        [LeaderBordDetails addObject:mutableDic];
        
    }
    [self performSelectorOnMainThread:@selector(leaderBordviewoperation) withObject:nil waitUntilDone:YES];
}


-(void)Mymatchinfojson
{
    
    @try {
        if ([self isConnectedToInternet]==TRUE)
        {
            NSString *LeaderBordString=[NSString stringWithFormat:@"%@user.php?mode=mymatchinfo&userid=%@&eventid=%@&loggedin_userid=%@",API,ViewerID,matchID,[self LoggedId]];
            NSLog(@"The leader bord array:%@",LeaderBordString);
            NSURL *mainurl=[NSURL URLWithString:LeaderBordString];
            NSData *data=[NSData dataWithContentsOfURL:mainurl];
            NSDictionary *mainDic=[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            NSDictionary *Matchdiction=[mainDic valueForKey:@"matchdetails"];
            
            
                NSString *playerId=[NSString stringWithFormat:@"%@",[Matchdiction valueForKey:@"PlayerId"]];
                NSString *playerName=[NSString stringWithFormat:@"%@",[Matchdiction valueForKey:@"PlayerName"]];
                NSString *playerimage=[NSString stringWithFormat:@"%@",[Matchdiction valueForKey:@"PlayerImage"]];
                NSString *Matchhccp=[NSString stringWithFormat:@"%@",[Matchdiction valueForKey:@"MatchHCP"]];
                NSString *matchTopar=[NSString stringWithFormat:@"%@",[Matchdiction valueForKey:@"MatchToPar"]];
                NSString *matchHole=[NSString stringWithFormat:@"%@",[Matchdiction valueForKey:@"MatchHole"]];
                NSString *matchNetScore=[NSString stringWithFormat:@"%@",[Matchdiction valueForKey:@"MatchNetScore"]];
                
                NSMutableDictionary *mutableDic=[[NSMutableDictionary alloc]init];
                [mutableDic setValue:playerId forKey:@"PlayerId"];
                [mutableDic setValue:playerName forKey:@"PlayerName"];
                [mutableDic setValue:playerimage forKey:@"PlayerImage"];
                [mutableDic setValue:Matchhccp forKey:@"MatchHCP"];
                [mutableDic setValue:matchTopar forKey:@"MatchToPar"];
                [mutableDic setValue:matchHole forKey:@"MatchHole"];
                [mutableDic setValue:matchNetScore forKey:@"MatchNetScore"];
                [LeaderBordDetails addObject:mutableDic];
                NSArray *matchDetailsArry=[mainDic objectForKey:@"matchactivity"];
                for (NSDictionary *mainActivitydic in matchDetailsArry)
                {
                    NSMutableDictionary *MutDicallActivity=[[NSMutableDictionary alloc]init];
                    [MutDicallActivity setValue:[MutDicallActivity valueForKey:@"MatchActivityType"] forKey:@"MatchActivityType"];
                    [MutDicallActivity setValue:[MutDicallActivity valueForKey:@"MatchActivityId"] forKey:@"MatchActivityId"];
                    [MutDicallActivity setValue:[MutDicallActivity valueForKey:@"MatchActivityAppType"] forKey:@"MatchActivityAppType"];
                    [MutDicallActivity setValue:[MutDicallActivity valueForKey:@"MatchActivityTitle"] forKey:@"MatchActivityTitle"];
                    [MutDicallActivity setValue:[MutDicallActivity valueForKey:@"MatchAchivementId"] forKey:@"MatchAchivementId"];
                    [MutDicallActivity setValue:[MutDicallActivity valueForKey:@"MatchAchivementImage"] forKey:@"MatchAchivementImage"];
                    [MutDicallActivity setValue:[MutDicallActivity valueForKey:@"MatchActivityCreator"] forKey:@"MatchActivityCreator"];
                    [MutDicallActivity setValue:[MutDicallActivity valueForKey:@"MatchActivityCreatorTitle"] forKey:@"MatchActivityCreatorTitle"];
                    [MutDicallActivity setValue:[MutDicallActivity valueForKey:@"MatchActivityCreatorImage"] forKey:@"MatchActivityCreatorImage"];
                    [MutDicallActivity setValue:[MutDicallActivity valueForKey:@"MatchActivityCreatedDate"] forKey:@"MatchActivityCreatedDate"];
                    [MutDicallActivity setValue:[MutDicallActivity valueForKey:@"MatchActivityCreatedRawDate"] forKey:@"MatchActivityCreatedRawDate"];
                    [MutDicallActivity setValue:[MutDicallActivity valueForKey:@"MatchActivityCommentCount"] forKey:@"MatchActivityCommentCount"];
                    [MutDicallActivity setValue:[MutDicallActivity valueForKey:@"MatchActivityCommentAllow"] forKey:@"MatchActivityCommentAllow"];
                    [MutDicallActivity setValue:[MutDicallActivity valueForKey:@"MatchActivityLikeAllow"] forKey:@"MatchActivityCreatedRawDate"];
                     [MutDicallActivity setValue:[MutDicallActivity valueForKey:@"MatchActivityLikeAllow"] forKey:@"MatchActivityLikeAllow"];
                    
                    
                }
            
            
            
            [self performSelectorOnMainThread:@selector(GetmatchInfo) withObject:nil waitUntilDone:YES];
        }

    }
    @catch (NSException *exception)
    {
              NSLog(@"The Value of Exception:%@ %@",[exception name],exception);
    }
    
    
    
}

-(void)GetmatchInfo
{
    
    [SVProgressHUD dismiss];
    
    NSMutableDictionary *mutDic=[LeaderBordDetails objectAtIndex:0];
    UIView *mainview=[[[NSBundle mainBundle] loadNibNamed:@"EtendedDesignView" owner:self options:nil] objectAtIndex:3];
    
    UIView *userimageback=(UIView *)[mainview viewWithTag:1];
    
    UIImageView *userimage=(UIImageView *)[mainview viewWithTag:2];
    [self SetroundborderWithborderWidth:2.0f WithColour:[UIColor clearColor] ForImageview:userimage];
    [self SetroundborderWithborderWidth:2.0f WithColour:[UIColor whiteColor] ForView:userimageback];
    UIImageView *backimage=(UIImageView *)[mainview viewWithTag:50];
    [backimage setImage:matchimage];
    
    
    NSURLRequest *request_img2 = [NSURLRequest requestWithURL:[NSURL URLWithString:[mutDic valueForKey:@"PlayerImage"]]];
    AFImageRequestOperation *operationimage = [AFImageRequestOperation imageRequestOperationWithRequest:request_img2
                                                                                   imageProcessingBlock:nil
                                                                                                success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                                                                    if(image!=nil)
                                                                                                    {
                                                                                                        [userimage setImage:image];
                                                                                                        
                                                                                                        
                                                                                                        
                                                                                                    }
                                                                                                    
                                                                                                }
                                                                                                failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error)
                                               {
                                                   NSLog(@"Error %@",error);
                                                   
                                               }];
    [operationimage start];
    
    UILabel *nmaeLable=(UILabel *)[mainview viewWithTag:3];
    nmaeLable.font=[UIFont fontWithName:MYRIARDPROSAMIBOLT size:12];
    nmaeLable.text=[mutDic valueForKey:@"PlayerName"];
    
    
    UILabel *matchHcp=(UILabel *)[mainview viewWithTag:4];
    matchHcp.font=[UIFont fontWithName:MYRIARDPROLIGHT size:21];
    matchHcp.text=(NSString *)[mutDic valueForKey:@"MatchHCP"];
    
    
    
    UILabel *Toparlable=(UILabel *)[mainview viewWithTag:5];
    Toparlable.font=[UIFont fontWithName:MYRIARDPROLIGHT size:21];
    Toparlable.text=[NSString stringWithFormat:@"%@",[mutDic valueForKey:@"MatchToPar"]];
    Toparlable.text=(NSString *)[mutDic valueForKey:@"MatchToPar"];
    
    UILabel *totascore=(UILabel *)[mainview viewWithTag:7];
    [totascore setFont:[UIFont fontWithName:MYRIARDPROLIGHT size:28]];
    if ([[mutDic valueForKey:@"MatchNetScore"] length]>0)
    {
        totascore.text=(NSString *)[mutDic valueForKey:@"MatchNetScore"];
    }
    else
    {
        totascore.text=@"0";
    }
    
    totascore.textColor=[UIColor whiteColor];
    
    
    [self.Mymatchinfoview addSubview:mainview];
    
    
    
}


//tableview Delegate method......


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"The Bigger View Cell:");
    
}

- (IBAction)MymatchInformationbtn:(id)sender
{
    
    
    NSLog(@"This is text");
    LblmatchDetais.text=@"My Match Information";
    [_showmmymatchinfoWithmatchdetais removeFromSuperview];
    matchDeailView.hidden=YES;
    _LeaderBordScroll.hidden=YES;
    _leaderbordScrollback.hidden=YES;
    _Mymatchinfoview.hidden=NO;
    CGRect frame1=[ActivitytblView frame];
    CGRect frame2=[_tblheader frame];
    frame2.origin.y=218;
    _tblheader.frame=frame2;
    frame1.origin.y=310-57;
    frame1.size.height=258+57;
    [ActivitytblView setFrame:frame1];
    [self.dropdownView removeFromSuperview];
    LeaderBordDetails=[[NSMutableArray alloc] init];
    [SVProgressHUD show];
    
    NSInvocationOperation *mumatchinfo=[[NSInvocationOperation alloc] initWithTarget:self selector:@selector(Mymatchinfojson) object:nil];
    [operation addOperation:mumatchinfo];
    
    
}
- (IBAction)Joinmatch:(id)sender
{
    
}

- (IBAction)ScoreCardview:(id)sender
{
    TTTScoreBord *ScrobordView=[[TTTScoreBord alloc]init];
    ScrobordView.matchID=matchID;
    ScrobordView.paramId=ParamViewerID;
    [self PushViewController:ScrobordView TransitationFrom:kCATransitionFade];
    
    
}
- (IBAction)mymatchinfoBtnAll:(id)sender
{
    
    
    NSLog(@"This is text");
    [SVProgressHUD show];
    matchDeailView.hidden=YES;
    _LeaderBordScroll.hidden=YES;
    _leaderbordScrollback.hidden=YES;
    _Mymatchinfoview.hidden=NO;
    [self.dropdownView removeFromSuperview];
    [LeaderBordDetails removeAllObjects];
    
    NSInvocationOperation *mumatchinfo=[[NSInvocationOperation alloc] initWithTarget:self selector:@selector(Mymatchinfojson) object:nil];
    [operation addOperation:mumatchinfo];
}
-(void)PerformChatSliderOperation
{
    
    self.chatView.hidden=NO;
    IsChatMenuBoxOpen=[self PerformChatSlider:self.screenView withChatArea:self.chatView IsOpen:IsChatMenuBoxOpen];
    NSLog(@"PerformChatSliderOperation %@",IsChatMenuBoxOpen?@"YES":@"NO");
    
}

@end
