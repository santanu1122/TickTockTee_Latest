//
//  TTTScoreBord.m
//  TickTockTee
//
//  Created by macbook_ms on 12/03/14.
//  Copyright (c) 2014 com.esolz.TickTockTee. All rights reserved.
//

#import "TTTScoreBord.h"
#import "TTTGlobalMethods.h"
#import "SVProgressHUD.h"
#import "AFNetworking.h"
#import "AFImageRequestOperation.h"

@interface TTTScoreBord ()<UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate,UIActionSheetDelegate,UIAlertViewDelegate>
{
   
    BOOL IsChatBoxOpen, IsLeftMenuBoxOpen, CanEditable, IsInLandscapeMode, IsPrepared;
    TTTGlobalMethods *Method;
    NSOperationQueue *OperationQueue;
    NSMutableArray *ScoreCardDetailsArray, *LeaderBoardArray;
    UIView *ScoreCardBackView;
    NSString *ScoreIn, *ScoreOut, *MatchId;
    int TotalHoleToBeShown, CurrentResponderTag;
    UIView *LandScapeView;
    
    CGSize InitialLandscapeContentSize;
    UIScrollView *SVLandscape;
    UITapGestureRecognizer *TapGesture;
    UITextField *TFfirstResponder;
    UIPickerView *pickerView;
    NSString *matchScorePostPermition;
    NSString *matchScoreEditparmition;
   
    NSMutableDictionary *MatchDetaisinScorecard;
    NSInteger TOTALVALUEOFIN;
    NSInteger TOTALVALUEOFOUT;
    UITextField *nithHoletext;
    NSInteger lastpostDataTag;
    UIView *ViewForlandScapeMode;
    NSString *privioustxtvalue;
    NSString *textfieldtext;
    
    NSString *ViewerID;
    BOOL loadLeaderbordFirsttime;
    NSString *grossscore;
    NSString *toper;
    BOOL Iscommiongforediting;
    NSString *Valueupdate;
    
}
@property (strong, nonatomic) IBOutlet UIImageView *MainScreenbacgroundimage;











@property (strong, nonatomic) IBOutlet UIView *LeaderBordScroll;

@property (strong, nonatomic) IBOutlet UIScrollView *ScrollForleaderbord;


@property (strong, nonatomic) IBOutlet UILabel *TotalScoreForpotred;



@property (strong, nonatomic) IBOutlet UIView *MainScreenlandScape;


@property (strong, nonatomic) IBOutlet UIButton *postBtnclick;

@property (strong, nonatomic) IBOutlet UIButton *Postbtn;








@property (strong, nonatomic) IBOutlet UIScrollView *landScapemainScroll;

@property (strong, nonatomic) IBOutlet UIScrollView *LandScapeScrollforiPhone4;


@property (strong, nonatomic) IBOutlet UIScrollView *mainScroll;

@property (strong, nonatomic) IBOutlet UIScrollView *ScorecardScroll;
@property (strong, nonatomic) IBOutlet UIView *LanScapeview;

@property (strong, nonatomic) IBOutlet UIView *landScapeviewforiPhone;

@property (strong, nonatomic) IBOutlet UIScrollView *ScorecardScrolliPhone5;

@property (strong, nonatomic) IBOutlet UIScrollView *ScoreCardScrollforiPhone4;

@property (strong, nonatomic) IBOutlet UIImageView *MainImageVirw;
@property (strong, nonatomic) IBOutlet UILabel *matchName;
@property (strong, nonatomic) IBOutlet UILabel *CourseName;

@property (strong, nonatomic) IBOutlet UIImageView *useimageview;


@property (strong, nonatomic) IBOutlet UIView *backview;


@property (strong, nonatomic) IBOutlet UILabel *nameLbl;
@property (strong, nonatomic) IBOutlet UILabel *TTThecplbl;
@property (strong, nonatomic) IBOutlet UILabel *matchHcplbl;
@property (strong, nonatomic) IBOutlet UILabel *Tooparlbl;

@property (strong, nonatomic) IBOutlet UILabel *holeLbl;
@property (strong, nonatomic) IBOutlet UILabel *Lablepar;
@property (strong, nonatomic) IBOutlet UILabel *lablelength;

@property (strong, nonatomic) IBOutlet UIView *teeboxcolor;

@property (strong, nonatomic) IBOutlet UILabel *Lablehand;
@property (strong, nonatomic) IBOutlet UILabel *lableScore;
@property (strong, nonatomic) IBOutlet UILabel *ScoreLable;


@end

@implementation TTTScoreBord

@synthesize MainImageVirw,matchHcplbl,manuSearchtxt,backview,Tooparlbl,CourseName,matchName,nameLbl,TTThecplbl,useimageview,matchID,paramId;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
     // Custom initialization
    }
    return self;
}


-(void)viewWillAppear:(BOOL)animated
 {
     IsInLandscapeMode=FALSE;
     
     if (IsIphone5)
     {
         _LanScapeview.frame=CGRectMake(0, 0, _LanScapeview.frame.size.width, _LanScapeview.frame.size.height);
         [self.view addSubview:_LanScapeview];
         _LanScapeview.hidden=YES;
     }
     else
     {
         [_mainScroll setContentSize:CGSizeMake(320, 700)];
     }
 }



- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
       MatchDetaisinScorecard=[[NSMutableDictionary alloc]init];
    self.mainScroll.hidden=YES;
      if (!IsIphone5)
      {
          CGRect frame=[_MainScreenlandScape frame];
          frame.origin.y=0;
         
          [_MainScreenlandScape setFrame:frame];
          CGRect frame2=[_mainScroll frame];
          frame2.origin.y=88+60;
          
          [_mainScroll setFrame:frame2];
          CGRect Fram3=[_MainScreenbacgroundimage frame];
          Fram3.origin.y=0;
         
          [_MainScreenbacgroundimage setFrame:Fram3];
          
          
      }
     loadLeaderbordFirsttime=FALSE;
       ViewerID =(paramId.length>0)?paramId:[self LoggedId];
    
       [_ScoreLable setFont:[UIFont fontWithName:MYRIARDPROSAMIBOLT size:15]];
       matchName.font=[UIFont fontWithName:MYRIARDPROSAMIBOLT size:15.0f];
       CourseName.font=[UIFont fontWithName:MYRIARDPROLIGHT size:15.0f];
    
        TTThecplbl.font=[UIFont fontWithName:MYRIARDPROLIGHT size:21.0f];
        matchHcplbl.font=[UIFont fontWithName:MYRIARDPROLIGHT size:21.0f];
        Tooparlbl.font=[UIFont fontWithName:MYRIARDPROLIGHT size:21.0f];
        nameLbl.font=[UIFont fontWithName:MYRIARDPROSAMIBOLT size:17.0f];
        _Lablepar.font=[UIFont fontWithName:MYREADPROREGULAR size:15.0f];
       _holeLbl.font=[UIFont fontWithName:MYRIARDPROSAMIBOLT size:15.0f];
       _lablelength.font=[UIFont fontWithName:MYREADPROREGULAR size:15.0f];
       _lableScore.font=[UIFont fontWithName:MYRIARDPROSAMIBOLT size:15.0f];
       _Lablehand.font=[UIFont fontWithName:MYREADPROREGULAR size:15.0f];
    
        ScoreCardDetailsArray=[[NSMutableArray alloc] init];
        OperationQueue=[[NSOperationQueue alloc] init];
        LeaderBoardArray=[[NSMutableArray alloc] init];
       _RounStatelable.font=[UIFont fontWithName:MYRIARDPROLIGHT size:15.0f];
      _roundState.font=[UIFont fontWithName:MYRIARDPROSAMIBOLT size:16.0];
       [SVProgressHUD show];
      NSInvocationOperation *operationscorebord=[[NSInvocationOperation alloc]initWithTarget:self selector:@selector(getScorecardDetais) object:nil];
     [OperationQueue addOperation:operationscorebord];
     [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rotationChanged:) name:@"UIDeviceOrientationDidChangeNotification" object:nil];
    
    
    //IPhone5............
    
    
  
    _ScoreLblLand5.font=[UIFont fontWithName:MYRIARDPROSAMIBOLT size:15.0f];
    _LengthLblLandscape5.font=[UIFont fontWithName:MYRIARDPROLIGHT size:15.0f];
   
    TTThecplbl.font=[UIFont fontWithName:MYRIARDPROLIGHT size:21.0f];
    matchHcplbl.font=[UIFont fontWithName:MYRIARDPROLIGHT size:21.0f];
    Tooparlbl.font=[UIFont fontWithName:MYRIARDPROLIGHT size:21.0f];
    nameLbl.font=[UIFont fontWithName:MYRIARDPROSAMIBOLT size:17.0f];
   
    _HolelableForlandScape5.font=[UIFont fontWithName:MYRIARDPROSAMIBOLT size:15.0f];
    _LengthLblLandscape5.font=[UIFont fontWithName:MYREADPROREGULAR size:15.0f];
    _Parlableforlandscapre5.font=[UIFont fontWithName:MYREADPROREGULAR size:15.0f];
    _ScoreLblLand5.font=[UIFont fontWithName:MYRIARDPROSAMIBOLT size:15.0f];
    _Lablehand.font=[UIFont fontWithName:MYREADPROREGULAR size:15.0f];
    //IPhone4......
    
    MatchDetaisinScorecard=[[NSMutableDictionary alloc]init];
    matchName.font=[UIFont fontWithName:MYRIARDPROSAMIBOLT size:15.0f];
    CourseName.font=[UIFont fontWithName:MYRIARDPROLIGHT size:15.0f];
   
     TTThecplbl.font=[UIFont fontWithName:MYRIARDPROLIGHT size:21.0f];
     matchHcplbl.font=[UIFont fontWithName:MYRIARDPROLIGHT size:21.0f];
     Tooparlbl.font=[UIFont fontWithName:MYRIARDPROLIGHT size:21.0f];
     nameLbl.font=[UIFont fontWithName:MYRIARDPROSAMIBOLT size:17.0f];
     _Lablepar.font=[UIFont fontWithName:MYREADPROREGULAR size:15.0f];
     _holeLbl.font=[UIFont fontWithName:MYRIARDPROSAMIBOLT size:15.0f];
     _lablelength.font=[UIFont fontWithName:MYREADPROREGULAR size:15.0f];
     _lableScore.font=[UIFont fontWithName:MYRIARDPROSAMIBOLT size:15.0f];
     _Lablehand.font=[UIFont fontWithName:MYREADPROREGULAR size:15.0f];
    
    
    
    
  
}
-(void)AssgnWork
{
    NSInvocationOperation *operatonlandScape=[[NSInvocationOperation alloc] initWithTarget:self selector:@selector(getScorecardDetais) object:nil];
    [OperationQueue addOperation:operatonlandScape];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    TFfirstResponder.text=privioustxtvalue;
}

-(void)rotationChanged:(NSNotification *)notification
{
    NSInteger orientation = [[UIDevice currentDevice] orientation];
    
    switch (orientation)
    {
        case 1:
          
            
            [[UIApplication sharedApplication] setStatusBarHidden:NO];
             IsInLandscapeMode=FALSE;
             _LanScapeview.hidden=YES;
             _landScapeviewforiPhone.hidden=YES;
             _MainScreenlandScape.hidden=NO;
            [_landScapeviewforiPhone removeFromSuperview];
            [_LanScapeview removeFromSuperview];
            //[SVProgressHUD show];
            [self AssgnWork];
            break;
         case 3:
            NSLog(@"LandscapeRight");
            
            [[UIApplication sharedApplication] setStatusBarHidden:NO];
            IsInLandscapeMode=TRUE;
            _MainScreenlandScape.hidden=YES;
            if (IsIphone5)
            {
            _LanScapeview.hidden=NO;
            [self.view addSubview:_LanScapeview];
                
            }
            else
            {
            _landScapeviewforiPhone.hidden=NO;
            [self.view addSubview:_landScapeviewforiPhone];
            }
           
            //[SVProgressHUD show];
            [self AssgnWork];
            break;
        case 4:
            [[UIApplication sharedApplication] setStatusBarHidden:NO];
            IsInLandscapeMode=TRUE;
            _MainScreenlandScape.hidden=YES;
            if (IsIphone5)
            {
                _LanScapeview.hidden=NO;
                [self.view addSubview:_LanScapeview];
                
            }
            else
            {
                _landScapeviewforiPhone.hidden=NO;
                [self.view addSubview:_landScapeviewforiPhone];
            }
            [self AssgnWork];
          break;
        default:
            [[UIApplication sharedApplication] setStatusBarHidden:NO];
           break;
    }
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

-(void)ShowLandscapeMode
{
    if(!IsInLandscapeMode)
    {
        IsInLandscapeMode=TRUE;
        [_LanScapeview setAutoresizesSubviews:YES];
        
        [[self LanScapeview] addSubview:LandScapeView];
        [[self LanScapeview] bringSubviewToFront:LandScapeView];
    }
}




-(void)ShowPotrateMode
{
    IsInLandscapeMode=FALSE;
    [LandScapeView removeFromSuperview];
}

- (BOOL)shouldAutorotate
{
    return YES;
}
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

-(void)getScorecardDetais
{
    IMFAPPPRINTMETHOD();
    
    [MatchDetaisinScorecard removeAllObjects];
    
    NSString *URL=[NSString stringWithFormat:@"%@user.php?mode=scorecardDetails&userid=%@&eventid=%@&loggedin_userid=%@", API,ViewerID,matchID,[self LoggedId]];
    
    NSLog(@"%@", URL);
    
    NSData *getData=[NSData dataWithContentsOfURL:[NSURL URLWithString:URL]];
    [ScoreCardDetailsArray removeAllObjects];
    [LeaderBoardArray removeAllObjects];
    
     NSDictionary *Output=[NSJSONSerialization JSONObjectWithData:getData options:kNilOptions error:nil];
    
     NSArray *ScoreCards = [Output objectForKey:@"MatchScore"];
     NSArray *LeaderBoard=[Output objectForKey:@"MatchPlayers"];

    [MatchDetaisinScorecard setValue:[Output valueForKey:@"MatchCourse"]forKey:@"MatchCourse"];
    [MatchDetaisinScorecard setValue:[Output valueForKey:@"MatchTitle"]forKey:@"MatchTitle"];
    NSString *matchScorevalue;
    if ([[Output valueForKey:@"MatchScoreValue"] length]>0)
    {
        matchScorevalue=[Output valueForKey:@"MatchScoreValue"];
    }
    else
    {
          matchScorevalue=@"0";
    }
    [MatchDetaisinScorecard setValue:matchScorevalue forKey:@"MatchScoreValue"];
    [MatchDetaisinScorecard setValue:[Output valueForKey:@"MatchHCP"]forKey:@"MatchHCP"];
    [MatchDetaisinScorecard setValue:[Output valueForKey:@"MatchUser"]forKey:@"MatchUser"];
    [MatchDetaisinScorecard setValue:[NSString stringWithFormat:@"%@",[Output valueForKey:@"MatchToPar"]]forKey:@"MatchToPar"];
    [MatchDetaisinScorecard setValue:[NSString stringWithFormat:@"%@",[Output valueForKey:@"MatchTeeboxColor"]]forKey:@"MatchTeeboxColor"];
    [MatchDetaisinScorecard setValue:[Output valueForKey:@"MatchUserImage"]forKey:@"MatchUserImage"];
    [MatchDetaisinScorecard setValue:[Output valueForKey:@"TTTHCP"]forKey:@"TTTHCP"];
    [MatchDetaisinScorecard setValue:[NSString stringWithFormat:@"%@",[Output valueForKey:@"MatchEditPermission"]]forKey:@"MatchEditPermission"];
    [MatchDetaisinScorecard setValue:[Output valueForKey:@"MatchScorecardPostPermission"]forKey:@"MatchScorecardPostPermission"];
    
    [MatchDetaisinScorecard setValue:[Output valueForKey:@"MatchHole"]forKey:@"MatchHole"];
    //[MatchDetaisinScorecard setValue:[NSString stringWithFormat:@"%@",[self RemoveNullandreplaceWithSpace:[Output valueForKey:@"MatchScoreValue"]]] forKey:@"MatchScoreValue"];
    [MatchDetaisinScorecard setValue:[Output valueForKey:@"MatchId"]forKey:@"MatchId"];//MatchCoverImage
    [MatchDetaisinScorecard setValue:[Output valueForKey:@"MatchCoverImage"]forKey:@"MatchCoverImage"];
    
    NSString *str1=[NSString stringWithFormat:@"%@ %@",@"Eagles + :",[Output valueForKey:@"MatchTotalEagles"]];
    NSString *str2=[NSString stringWithFormat:@"%@ %@",@"Birdies :",[Output valueForKey:@"MatchTotalBirdies"]];
    NSString *str3=[NSString stringWithFormat:@"%@ %@",@"Pars :",[Output valueForKey:@"MatchTotalPars"]];
    NSString *str4=[NSString stringWithFormat:@"%@ %@",@"Bogeys :",[Output valueForKey:@"MatchTotalBogeyes"]];
    NSString *str5=[NSString stringWithFormat:@"%@ %@",@"Doubles :",[Output valueForKey:@"MatchTotalDoubles"]];
    NSString *str6=[NSString stringWithFormat:@"%@ %@",@"Other :",[Output valueForKey:@"MatchTotalOthers"]];
    NSString *str7=[NSString stringWithFormat:@"%@ %@",@"Par 3 Avg :",[Output valueForKey:@"MatchTotalPar3avg"]];
    NSString *str9=[NSString stringWithFormat:@"%@ %@",@"Par 4 Avg :",[Output valueForKey:@"MatchTotalPar4avg"]];
    NSString *str10=[NSString stringWithFormat:@"%@ %@",@"Par 5 Avg :",[Output valueForKey:@"MatchTotalPar5avg"]];
    NSString *roundState=[NSString stringWithFormat:@"%@    %@    %@    %@    %@    %@    %@    %@    %@",str1,str2,str3,str4,str5,str6,str7,str9,str10];
    [MatchDetaisinScorecard setValue:roundState forKey:@"roundState"];
   //Leader bord Details scroll
    
    
     if ([LeaderBoard count]>0&&IsInLandscapeMode==FALSE&&loadLeaderbordFirsttime==FALSE)
     {
        
        for(NSDictionary *var in LeaderBoard)
        {
            NSMutableDictionary *mutDic=[[NSMutableDictionary alloc]init];
            [mutDic setValue:[var valueForKey:@"Id"] forKey:@"Id"];
            [mutDic setValue:[var valueForKey:@"PlayerName"] forKey:@"PlayerName"];
            [mutDic setValue:[var valueForKey:@"PayerImage"] forKey:@"PayerImage"];
            [mutDic setValue:[var valueForKey:@"GrosSsocre"] forKey:@"GrosSsocre"];
            [mutDic setValue:[var valueForKey:@"HolesPlayed"] forKey:@"HolesPlayed"];
            [LeaderBoardArray addObject:mutDic];
        }
         [self performSelectorOnMainThread:@selector(ShowleaderbordIfPresent) withObject:nil waitUntilDone:YES];
         
         
    }
    for(NSDictionary *var in ScoreCards)
    {
         NSMutableDictionary *mutDic=[[NSMutableDictionary alloc]init];
         [mutDic setValue:[NSString stringWithFormat:@"%@",[var valueForKey:@"Par"]] forKey:@"Par"];
         [mutDic setValue:[NSString stringWithFormat:@"%@",[var valueForKey:@"Length"]] forKey:@"Length"];
         [mutDic setValue:[NSString stringWithFormat:@"%@",[var valueForKey:@"HoleHCP"]] forKey:@"HoleHCP"];
         [mutDic setValue:[NSString stringWithFormat:@"%@",[var valueForKey:@"HoleHCPExp"]] forKey:@"HoleHCPExp"];
         [mutDic setValue:[NSString stringWithFormat:@"%@",[var valueForKey:@"HoleValue"]] forKey:@"HoleValue"];
         [mutDic setValue:[NSString stringWithFormat:@"%@",[var valueForKey:@"HoleValueExp"]] forKey:@"HoleValueExp"];
         [mutDic setValue:[NSString stringWithFormat:@"%@",[var valueForKey:@"HoleValueColor"]] forKey:@"HoleValueColor"];
        //[mutDic setValue:[NSString stringWithFormat:@"%@",[var valueForKey:@"HoleCompleted"]] forKey:@"HoleCompleted"];
       
        [ScoreCardDetailsArray addObject:mutDic];
        
    }
    [self performSelectorOnMainThread:@selector(reloaddataForScordcard) withObject:nil waitUntilDone:YES];
    
}

-(void)ShowleaderbordIfPresent
{
  
    NSInteger Numbor=[LeaderBoardArray count];
    _LeaderBordScroll.frame=CGRectMake(0, 449, _LeaderBordScroll.frame.size.width, _LeaderBordScroll.frame.size.height);
    [_mainScroll addSubview:_LeaderBordScroll];
    
    for (int i=0; i<[LeaderBoardArray count]; i++)
    {
        
        NSMutableDictionary *mutDic=[LeaderBoardArray objectAtIndex:i];
        UIView *leaderBordview=[[[NSBundle mainBundle] loadNibNamed:@"EtendedDesignView" owner:self options:nil] objectAtIndex:8];
        UIView *mainimagebackview=(UIView *)[leaderBordview viewWithTag:420];
        [self SetroundborderWithborderWidth:0.0f WithColour:[UIColor whiteColor] ForView:mainimagebackview];
        UIImageView *MainImageview=(UIImageView *)[leaderBordview viewWithTag:421];
        [self SetroundborderWithborderWidth:0.0f WithColour:[UIColor clearColor] ForImageview:MainImageview];
        NSURLRequest *request_img2 = [NSURLRequest requestWithURL:[NSURL URLWithString:[mutDic valueForKey:@"PayerImage"]]];
        
        AFImageRequestOperation *operationimage = [AFImageRequestOperation imageRequestOperationWithRequest:request_img2
                                                                                       imageProcessingBlock:nil
                                                                                                    success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                                                                        if(image!=nil)
                                                                                                        {
                                                                                                            [MainImageview setImage:image];
                                                                                                            
                                                                                                            
                                                                                                            
                                                                                                        }
                                                                                                        
                                                                                                    }
                                                                                                    failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error)
                                                   {
                                                       NSLog(@"Error %@",error);
                                                       
                                                   }];
         [operationimage start];
        
        
        
        UILabel *PlayerNameLble=(UILabel *)[leaderBordview viewWithTag:422];
        [PlayerNameLble setFont:[UIFont fontWithName:MYRIARDPROSAMIBOLT size:13.0f]];
        PlayerNameLble.textColor=[UIColor whiteColor];
        [PlayerNameLble setText:[mutDic valueForKey:@"PlayerName"]];
        
        UILabel *TotalScore=(UILabel *)[leaderBordview viewWithTag:423];
        [TotalScore setFont:[UIFont fontWithName:MYRIARDPROLIGHT size:13.0f]];
        TotalScore.textColor=[UIColor whiteColor];
        [TotalScore setText:[NSString stringWithFormat:@"%@ %@",@"Score: ",[mutDic valueForKey:@"GrosSsocre"]]];
        
        UILabel *HolePlayed=(UILabel *)[leaderBordview viewWithTag:424];
        [HolePlayed setFont:[UIFont fontWithName:MYRIARDPROLIGHT size:13.0f]];
        HolePlayed.textColor=[UIColor whiteColor];
        [HolePlayed setText:[NSString stringWithFormat:@"%@ %@",@"Hole : ",[mutDic valueForKey:@"HolesPlayed"]]];
        if (Numbor==1)
        {
            leaderBordview.frame=CGRectMake(113, 0, leaderBordview.frame.size.width, leaderBordview.frame.size.height);
        }
        else
        {
            leaderBordview.frame=CGRectMake(i*leaderBordview.frame.size.width, 0, leaderBordview.frame.size.width, leaderBordview.frame.size.height);
        }
        
         [_ScrollForleaderbord addSubview:leaderBordview];
        [_ScrollForleaderbord setContentSize:CGSizeMake(leaderBordview.frame.size.width*Numbor,leaderBordview.frame.size.height)];
     
    }
    
    if (IsIphone5)
    {
          [_mainScroll setContentSize:CGSizeMake(320, 650)];
    }
    else
    {
        [_mainScroll setContentSize:CGSizeMake(320, 500)];
    }
    loadLeaderbordFirsttime=TRUE;
}


-(void)reloaddataForScordcard
{
        IMFAPPPRINTMETHOD();
    
         CourseName.text=[MatchDetaisinScorecard valueForKey:@"MatchCourse"];
         matchName.text=[MatchDetaisinScorecard valueForKey:@"MatchTitle"];
        _TotalScoreForpotred.font=[UIFont fontWithName:MYRIARDPROLIGHT size:28.0f];
         _TotalScoreForpotred.text=[MatchDetaisinScorecard valueForKey:@"MatchScoreValue"];
         TTThecplbl.text=[MatchDetaisinScorecard valueForKey:@"TTTHCP"];
         matchHcplbl.text=[MatchDetaisinScorecard valueForKey:@"MatchHCP"];
         nameLbl.text=[MatchDetaisinScorecard valueForKey:@"MatchUser"];
         Tooparlbl.text=[MatchDetaisinScorecard valueForKey:@"MatchToPar"];
        _lableScore.text=[MatchDetaisinScorecard valueForKey:@"MatchScoreValue"];
    
      CGRect Frame1=[_RounStatelable frame];
      self.RounStatelable.text=[MatchDetaisinScorecard valueForKey:@"roundState"];
      NSLog(@"The round State Scroll:%@",[MatchDetaisinScorecard valueForKey:@"roundState"]);
    
      if ([[MatchDetaisinScorecard valueForKey:@"MatchScorecardPostPermission"] isEqualToString:@"0"])
      {
        _Postbtn.hidden=YES;
        _postBtnclick.hidden=YES;
      }

      NSAttributedString *attributedText21 =[[NSAttributedString alloc]
                                         initWithString:[MatchDetaisinScorecard valueForKey:@"roundState"]
                                         attributes:@
                                         {
                                         NSFontAttributeName:[UIFont fontWithName:@"MyriadProLight" size:16.0f]
                                         }];
    
     CGRect rect22 = [attributedText21 boundingRectWithSize:(CGSize){600, 21}
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                               context:nil];
     CGSize size22 = rect22.size;
     Frame1.size.width+=size22.width;
     self.RounStatelable.frame=Frame1;
     [self.rounStateScroll setContentSize:CGSizeMake(size22.width+150, self.rounStateScroll.frame.size.height)];
    
    
    
    [_teeboxcolor setBackgroundColor:[TTTGlobalMethods colorFromHexString:[MatchDetaisinScorecard valueForKey:@"MatchTeeboxColor"]]];
    [self setRoundBorderToUiview:_teeboxcolor];
    
    [self SetroundborderWithborderWidth:2.0f WithColour:[UIColor whiteColor] ForView:backview];
    [self SetroundborderWithborderWidth:2.0f WithColour:[UIColor clearColor] ForImageview:useimageview];
    
    NSLog(@"Match user image:%@",[MatchDetaisinScorecard valueForKey:@"MatchCoverImage"]);
    
    
     NSURLRequest *request_img2 = [NSURLRequest requestWithURL:[NSURL URLWithString:[MatchDetaisinScorecard valueForKey:@"MatchUserImage"]]];
     AFImageRequestOperation *operationimage = [AFImageRequestOperation imageRequestOperationWithRequest:request_img2
                                                                                   imageProcessingBlock:nil
                                                                                                success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                                                                    if(image!=nil)
                                                                                                    {
                                                                                                        [useimageview setImage:image];
                                                                                                        
                                                                                                        
                                                                                                        
                                                                                                    }
                                                                                                    
                                                                                                }
                                                                                                failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error)
    {
                                                                                                    NSLog(@"Error %@",error);
                                                                                                    
                                                                                                }];
    [operationimage start];
    
    
    
    NSURLRequest *request_img3 = [NSURLRequest requestWithURL:[NSURL URLWithString:[MatchDetaisinScorecard valueForKey:@"MatchCoverImage"]]];
    AFImageRequestOperation *operationimagecover = [AFImageRequestOperation imageRequestOperationWithRequest:request_img3
                                                                                   imageProcessingBlock:nil
                                                                                                success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                                                                    if(image!=nil)
                                                                                                    {
                                                                                                        [MainImageVirw setImage:image];
                                                                                                        [self.mainScroll setHidden:FALSE];
                                                                                                        
                                                                                                        
                                                                                                    }
                                                                                                    
                                                                                                }
                                                                                                failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error)
                                               {
                                                   NSLog(@"Error %@",error);
                                                   
                                               }];
    [operationimagecover start];
 
    
    
    
    
    NSAttributedString *attributedText =[[NSAttributedString alloc]
    initWithString:[MatchDetaisinScorecard valueForKey:@"MatchCourse"]
     attributes:@
     {
     NSFontAttributeName:[UIFont fontWithName:@"MyriadProLight" size:16.0f]
     }];
    
    CGRect rect = [attributedText boundingRectWithSize:(CGSize){240, 21}
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                               context:nil];
    CGSize size = rect.size;
    CGRect Frame=[_teeboxcolor frame];
    Frame.origin.x=CourseName.frame.origin.x+size.width+3;
    _teeboxcolor.frame=Frame;
    TotalHoleToBeShown=[[MatchDetaisinScorecard valueForKey:@"MatchHole"] integerValue];
    
    CanEditable=([[MatchDetaisinScorecard valueForKey:@"MatchScorecardPostPermission"] isEqualToString:@"1"])?TRUE:FALSE;
    if (!IsIphone5)
    {
        [_mainScroll setContentSize:CGSizeMake(320, 700)];
    }
    

    
    [self PrepareScoreCard];
    [self prepareScorecardForlandScape];
    
    
}



-(void)PrepareScoreCard
{
     NSLog(@"This is my rfecors:");
    [ScoreCardBackView removeFromSuperview];
    
    [SVProgressHUD dismiss];
    if (TotalHoleToBeShown==9)
    {
         ScoreCardBackView=[[[NSBundle mainBundle] loadNibNamed:@"EtendedDesignView" owner:self options:nil] objectAtIndex:5];
        [_ScorecardScroll addSubview:ScoreCardBackView];
        _ScorecardScroll.contentSize=CGSizeMake(607, ScoreCardBackView.frame.size.height);
    }
    else
    {
        ScoreCardBackView=[[[NSBundle mainBundle] loadNibNamed:@"EtendedDesignView" owner:self options:nil] objectAtIndex:9];
       
        ScoreCardBackView.frame=CGRectMake(0, 0, ScoreCardBackView.frame.size.width, ScoreCardBackView.frame.size.height);
       
        [_ScorecardScroll addSubview:ScoreCardBackView];
        
        _ScorecardScroll.contentSize=CGSizeMake(607*2, ScoreCardBackView.frame.size.height);
    }
    [self SetScoreToCard];
   }

-(void)prepareScorecardForlandScape
{
    [SVProgressHUD dismiss];
    [ViewForlandScapeMode removeFromSuperview];
    
   
   
    [self SetroundborderWithborderWidth:2 WithColour:[UIColor clearColor] ForView:_Backviewland5];
    [self SetroundborderWithborderWidth:2 WithColour:[UIColor clearColor] ForImageview:_userImageLand5];
    
    [self SetroundborderWithborderWidth:2 WithColour:[UIColor clearColor] ForView:_UseBackViewLand4];
    [self SetroundborderWithborderWidth:2 WithColour:[UIColor clearColor] ForImageview:_UserImageLand4];
    
    
    [_profilePicimageLand5 setImage:MainImageVirw.image];
    [_mainBackgrondimageLand4 setImage:MainImageVirw.image];
    [_userImageLand5 setImage:useimageview.image];
    [_UserImageLand4 setImage:useimageview.image];
   

    
    _nameForLand5.text=[MatchDetaisinScorecard valueForKey:@"MatchTitle"];
    
    _nameForLand5.font=[UIFont fontWithName:MYRIARDPROSAMIBOLT size:16.0f];
    
    _courseforlandScape.text=[MatchDetaisinScorecard valueForKey:@"MatchCourse"];
    _courseforlandScape.font=[UIFont fontWithName:MYRIARDPROLIGHT size:16.0f];
    
    _ScoreLand5.text=[MatchDetaisinScorecard valueForKey:@"MatchScoreValue"];
    _ScoreLand5.font=[UIFont fontWithName:MYRIARDPROLIGHT size:28.0f];
    
    _TTThcpLand5.text=[MatchDetaisinScorecard valueForKey:@"TTTHCP"];
    _TTThcpLand5.font=[UIFont fontWithName:MYRIARDPROLIGHT size:21.0f];
    _MatchHcpland5.text=[MatchDetaisinScorecard valueForKey:@"MatchHCP"];
    _MatchHcpland5.font=[UIFont fontWithName:MYRIARDPROLIGHT size:21.0f];
    _ToparLand5.text=[MatchDetaisinScorecard valueForKey:@"MatchToPar"];
    _ToparLand5.font=[UIFont fontWithName:MYRIARDPROLIGHT size:21.0f];
    
    _NmaelandScape4.text=[MatchDetaisinScorecard valueForKey:@"MatchTitle"];
    _NmaelandScape4.font=[UIFont fontWithName:MYRIARDPROSAMIBOLT size:16.0f];
    
    _CourselablelandScape4.text=[MatchDetaisinScorecard valueForKey:@"MatchCourse"];
    _CourselablelandScape4.font=[UIFont fontWithName:MYRIARDPROLIGHT size:16.0f];
    
    _ScoreLblland4.text=[MatchDetaisinScorecard valueForKey:@"MatchScoreValue"];
    _ScoreLblland4.font=[UIFont fontWithName:MYRIARDPROLIGHT size:21.0f];
    _TTTHcpLand4.text=[MatchDetaisinScorecard valueForKey:@"TTTHCP"];
    _TTTHcpLand4.font=[UIFont fontWithName:MYRIARDPROLIGHT size:21.0f];
    _MatchHcpland4.text=[MatchDetaisinScorecard valueForKey:@"MatchHCP"];
    _MatchHcpland4.font=[UIFont fontWithName:MYRIARDPROLIGHT size:21.0f];
    _ToparLblLand4.text=[MatchDetaisinScorecard valueForKey:@"MatchToPar"];
    _ToparLblLand4.font=[UIFont fontWithName:MYRIARDPROLIGHT size:21.0f];
    
    _HandicapLablelandScapp5.font=[UIFont fontWithName:MYREADPROREGULAR size:15.0f];
    
    self.HoletxtLbl.font=[UIFont fontWithName:MYRIARDPROSAMIBOLT size:15.0f];
    self.Scoretxtlbl.font=[UIFont fontWithName:MYRIARDPROSAMIBOLT size:15.0f];
    self.handtxtlbl.font=[UIFont fontWithName:MYREADPROREGULAR size:15.0f];
    self.holelengthtext.font=[UIFont fontWithName:MYREADPROREGULAR size:15.0f];
    self.holetxtlbl.font=[UIFont fontWithName:MYREADPROREGULAR size:15.0f];
    
    if (IsIphone5)
    {
        NSLog(@"the vaiew for land Scape:%@",ViewForlandScapeMode);
        
        if (TotalHoleToBeShown==9)
        {
            ViewForlandScapeMode=[[[NSBundle mainBundle] loadNibNamed:@"EtendedDesignView" owner:self options:nil] objectAtIndex:5];
            [_ScorecardScrolliPhone5 addSubview:ViewForlandScapeMode];
            _ScorecardScrolliPhone5.contentSize=CGSizeMake(607, ScoreCardBackView.frame.size.height);
            
        }
        else
        {
           
            
         ViewForlandScapeMode=[[[NSBundle mainBundle] loadNibNamed:@"EtendedDesignView" owner:self options:nil] objectAtIndex:9];
         ViewForlandScapeMode.frame=CGRectMake(0, 0, ViewForlandScapeMode.frame.size.width, ViewForlandScapeMode.frame.size.height);
         _ScorecardScrolliPhone5.contentSize=CGSizeMake(607*2, ViewForlandScapeMode.frame.size.height);
        [_ScorecardScrolliPhone5 addSubview:ViewForlandScapeMode];
         
        }

    }
    else
    {
        if (TotalHoleToBeShown==9)
        {
               ViewForlandScapeMode=[[[NSBundle mainBundle] loadNibNamed:@"EtendedDesignView" owner:self options:nil] objectAtIndex:5];
               [_ScoreCardScrollforiPhone4 addSubview:ViewForlandScapeMode];
              _ScoreCardScrollforiPhone4.contentSize=CGSizeMake(607, ViewForlandScapeMode.frame.size.height);
            
        }
        else
        {
              ViewForlandScapeMode=[[[NSBundle mainBundle] loadNibNamed:@"EtendedDesignView" owner:self options:nil] objectAtIndex:9];
              ViewForlandScapeMode.frame=CGRectMake(0, 0, ViewForlandScapeMode.frame.size.width, ViewForlandScapeMode.frame.size.height);
             _ScoreCardScrollforiPhone4.contentSize=CGSizeMake(607*2, ViewForlandScapeMode.frame.size.height);
        }
    }
    
   [self SetScorecardforlandScapemode];


}



-(void)SetScorecardforlandScapemode
{
    
    
    
    if (TotalHoleToBeShown==9)
    {
        for(UIView *Child in [ViewForlandScapeMode subviews])
        {
            NSLog(@" i am in");
            
            if([Child isKindOfClass:[UILabel class]] && [Child tag]>=100 && [Child tag]<=109)
            {
                UILabel *TempParLabel=(UILabel *)Child;
                TempParLabel.font=[UIFont fontWithName:MYREADPROREGULAR size:15.0f];
                NSString *Getparvalue=[self getHoleNumByTag:[Child tag]];
                NSMutableDictionary *mutableDic=[ScoreCardDetailsArray objectAtIndex:[Getparvalue integerValue]];
                TempParLabel.text=[mutableDic valueForKey:@"Par"];
                
            }
            else if([Child isKindOfClass:[UILabel class]] && [Child tag]>=200 && [Child tag]<=209)
            {
                UILabel *TempLengthLabel=(UILabel *)Child;
                TempLengthLabel.font=[UIFont fontWithName:MYREADPROREGULAR size:15.0f];
                NSString *Getparvalue=[self getHoleNumByTag:[Child tag]];
                NSMutableDictionary *mutableDic=[ScoreCardDetailsArray objectAtIndex:[Getparvalue integerValue]];
                TempLengthLabel.text=[mutableDic valueForKey:@"Length"];
                
            }
            
            else if ([Child isKindOfClass:[UILabel class]]&&[Child tag]==409)
            {
                UILabel *Inlable=(UILabel *)Child;
                Inlable.font=[UIFont fontWithName:MYREADPROREGULAR size:15.0f];
                NSString *Getparvalue=[self getHoleNumByTag:[Child tag]];
                NSMutableDictionary *mutableDic=[ScoreCardDetailsArray objectAtIndex:[Getparvalue integerValue]];
                Inlable.text=[mutableDic valueForKey:@"HoleValue"];
                
                
                
            }
            else if([Child isKindOfClass:[UILabel class]] && [Child tag]>=300 && [Child tag]<=309)
            {
                UILabel *TempHandicapLabel=(UILabel *)Child;
                TempHandicapLabel.font=[UIFont fontWithName:MYREADPROREGULAR size:15.0f];
                NSString *Getparvalue=[self getHoleNumByTag:[Child tag]];
                NSMutableDictionary *mutableDic=[ScoreCardDetailsArray objectAtIndex:[Getparvalue integerValue]];
                TempHandicapLabel.text=[mutableDic valueForKey:@"HoleHCP"];
                UILabel *lable=[[UILabel alloc]initWithFrame:CGRectMake(30, 0, 30, 30)];
                lable.textColor=[UIColor whiteColor];
                lable.textAlignment=NSTextAlignmentCenter;
                lable.font=[UIFont fontWithName:MYREADPROREGULAR size:12.0f];
               
                if (![[mutableDic valueForKey:@"HoleHCPExp"] isEqualToString:@"0"])
                {
                   lable.text=[mutableDic valueForKey:@"HoleHCPExp"];
                }
                [TempHandicapLabel addSubview:lable];
                
            }
            else if([Child isKindOfClass:[UITextField class]] && [Child tag]>=400 && [Child tag]<409)
            {
                UITextField *TempTextfiled=(UITextField *)Child;
                if (TempTextfiled.tag==408)
                {
                    nithHoletext=TempTextfiled;
                }
                TempTextfiled.font=[UIFont fontWithName:MYREADPROREGULAR size:15.0f];
                NSString *Getparvalue=[self getHoleNumByTag:[Child tag]];
                NSMutableDictionary *mutableDic=[ScoreCardDetailsArray objectAtIndex:[Getparvalue integerValue]];
                TempTextfiled.text=[mutableDic valueForKey:@"HoleValue"];
                UILabel *lable=[[UILabel alloc]initWithFrame:CGRectMake(30, 0, 30, 30)];
                lable.textColor=[UIColor whiteColor];
                lable.textAlignment=NSTextAlignmentCenter;
                lable.font=[UIFont fontWithName:MYREADPROREGULAR size:12.0f];
               
                if (![[mutableDic valueForKey:@"HoleValueExp"] isEqualToString:@"0"])
                {
                     lable.text=[mutableDic valueForKey:@"HoleValueExp"];
                }
                [TempTextfiled addSubview:lable];
                if ([[mutableDic valueForKey:@"HoleValueColor"] isEqualToString:@"#ffffff"])
                {
                    [TempTextfiled setBackgroundColor:[UIColor clearColor]];
                }
                else
                {
                    [TempTextfiled setBackgroundColor:[TTTGlobalMethods colorFromHexString:[mutableDic valueForKey:@"HoleValueColor"]]];
                }
              
                if(CanEditable)
                {
                    [TempTextfiled setDelegate:self];
                    [TempTextfiled setReturnKeyType:UIReturnKeyDone];
                   // [TempTextfiled setBackgroundColor:[UIColor blackColor]];
                }
                else
                {
                    [TempTextfiled setUserInteractionEnabled:NO];
                    
                }
                
                
            }
            else if([Child isKindOfClass:[UILabel class]] && [Child tag]==409)
            {
                UILabel *Inlable=(UILabel *)Child;
                Inlable.font=[UIFont fontWithName:MYREADPROREGULAR size:15.0f];
                NSString *Getparvalue=[self getHoleNumByTag:[Child tag]];
                NSMutableDictionary *mutableDic=[ScoreCardDetailsArray objectAtIndex:[Getparvalue integerValue]];
                Inlable.text=[mutableDic valueForKey:@"HoleValue"];
                
            }
            
            
        }
        
    }
    
    else
    {
        for(UIView *Child in [ViewForlandScapeMode subviews])
        {
            
            
            if([Child isKindOfClass:[UILabel class]] && [Child tag]>=100 && [Child tag]<=109)
            {
                
                UILabel *TempParLabel=(UILabel *)Child;
                TempParLabel.font=[UIFont fontWithName:MYREADPROREGULAR size:15.0f];
                NSString *Getparvalue=[self getHoleNumByTag:[Child tag]];
                NSMutableDictionary *mutableDic=[ScoreCardDetailsArray objectAtIndex:[Getparvalue integerValue]];
                TempParLabel.text=[mutableDic valueForKey:@"Par"];
                TempParLabel.textColor=[UIColor whiteColor];
                NSLog(@"The value of par:%@",[mutableDic valueForKey:@"Par"]);
                NSLog(@"Start6");
            }
            else if([Child isKindOfClass:[UILabel class]] && [Child tag]>=200 && [Child tag]<=209)
            {
                
                UILabel *TempLengthLabel=(UILabel *)Child;
                TempLengthLabel.font=[UIFont fontWithName:MYREADPROREGULAR size:15.0f];
                NSString *Getparvalue=[self getHoleNumByTag:[Child tag]];
                NSMutableDictionary *mutableDic=[ScoreCardDetailsArray objectAtIndex:[Getparvalue integerValue]];
                TempLengthLabel.textColor=[UIColor whiteColor];
                TempLengthLabel.text=[mutableDic valueForKey:@"Length"];
                NSLog(@"Start3");
            }
            else if([Child isKindOfClass:[UILabel class]] && [Child tag]>=300 && [Child tag]<=309)
            {
                
                UILabel *TempHandicapLabel=(UILabel *)Child;
                TempHandicapLabel.font=[UIFont fontWithName:MYREADPROREGULAR size:15.0f];
                NSString *Getparvalue=[self getHoleNumByTag:[Child tag]];
                NSMutableDictionary *mutableDic=[ScoreCardDetailsArray objectAtIndex:[Getparvalue integerValue]];
                TempHandicapLabel.text=[mutableDic valueForKey:@"HoleHCP"];
                UILabel *lable=[[UILabel alloc]initWithFrame:CGRectMake(30, 0, 30, 30)];
                lable.textColor=[UIColor whiteColor];
                lable.textAlignment=NSTextAlignmentCenter;
                lable.font=[UIFont fontWithName:MYREADPROREGULAR size:12.0f];
                TempHandicapLabel.textColor=[UIColor whiteColor];
                if (![[mutableDic valueForKey:@"HoleHCPExp"] isEqualToString:@"0"])
                {
                    lable.text=[mutableDic valueForKey:@"HoleHCPExp"];
                }
               
                [TempHandicapLabel addSubview:lable];
                NSLog(@"Start2");
            }
            
            else if([Child isKindOfClass:[UITextField class]] && [Child tag]>=400 && [Child tag]<409)
            {
                
                UITextField *TempTextfiled=(UITextField *)Child;
                TempTextfiled.font=[UIFont fontWithName:MYREADPROREGULAR size:15.0f];
                NSString *Getparvalue=[self getHoleNumByTag:[Child tag]];
                NSMutableDictionary *mutableDic=[ScoreCardDetailsArray objectAtIndex:[Getparvalue integerValue]];
                TempTextfiled.text=[mutableDic valueForKey:@"HoleValue"];
                UILabel *lable=[[UILabel alloc]initWithFrame:CGRectMake(30, 0, 30, 30)];
                lable.textColor=[UIColor whiteColor];
                lable.textAlignment=NSTextAlignmentCenter;
                lable.font=[UIFont fontWithName:MYREADPROREGULAR size:12.0f];
                lable.text=[mutableDic valueForKey:@"HoleValueExp"];
                [TempTextfiled setTextColor:[UIColor whiteColor]];
                [TempTextfiled addSubview:lable];
                
                if ([[mutableDic valueForKey:@"HoleValueColor"] isEqualToString:@"#ffffff"])
                {
                    [TempTextfiled setBackgroundColor:[UIColor clearColor]];
                }
                else
                {
                    [TempTextfiled setBackgroundColor:[TTTGlobalMethods colorFromHexString:[mutableDic valueForKey:@"HoleValueColor"]]];
                }
                
                if(CanEditable)
                {
                    [TempTextfiled setDelegate:self];
                    [TempTextfiled setReturnKeyType:UIReturnKeyDone];
                    //  [TempTextfiled setBackgroundColor:[UIColor blackColor]];
                }
                else
                {
                    [TempTextfiled setUserInteractionEnabled:NO];
                    //[self SetColorBoxTo:TempTextfiled forHole:[self getHoleNumByTag:[InnerChild tag]]];
                }
            }
            else if ([Child isKindOfClass:[UILabel class]]&&[Child tag]==409)
            {
                UILabel *Inlable=(UILabel *)Child;
                Inlable.font=[UIFont fontWithName:MYREADPROREGULAR size:15.0f];
                NSString *Getparvalue=[self getHoleNumByTag:[Child tag]];
                NSMutableDictionary *mutableDic=[ScoreCardDetailsArray objectAtIndex:[Getparvalue integerValue]];
                Inlable.text=[mutableDic valueForKey:@"HoleValue"];

                
                
            }
            
            else if([Child isKindOfClass:[UILabel class]] && [Child tag]>=110 && [Child tag]<=119)
            {
                NSLog(@"%d",[Child tag]);
                UILabel *TempParLabel=(UILabel *)Child;
                TempParLabel.font=[UIFont fontWithName:MYREADPROREGULAR size:15.0f];
                NSString *Getparvalue=[self getHoleNumByTag:[Child tag]];
                NSLog(@"%d",[Child tag]);
                
                NSMutableDictionary *mutableDic=[ScoreCardDetailsArray objectAtIndex:[Getparvalue integerValue]];
                TempParLabel.text=[mutableDic valueForKey:@"Par"];
                TempParLabel.textColor=[UIColor whiteColor];
                
                
            }
            else if([Child isKindOfClass:[UILabel class]] && [Child tag]>=210 && [Child tag]<=219)
            {
                NSLog(@"%d",[Child tag]);
                UILabel *TempLengthLabel=(UILabel *)Child;
                TempLengthLabel.font=[UIFont fontWithName:MYREADPROREGULAR size:15.0f];
                NSString *Getparvalue=[self getHoleNumByTag:[Child tag]];
                NSMutableDictionary *mutableDic=[ScoreCardDetailsArray objectAtIndex:[Getparvalue integerValue]];
                TempLengthLabel.textColor=[UIColor whiteColor];
                TempLengthLabel.text=[mutableDic valueForKey:@"Length"];
                
            }
            else if([Child isKindOfClass:[UILabel class]] && [Child tag]>=310 && [Child tag]<=319)
            {
                NSLog(@"%d",[Child tag]);
                UILabel *TempHandicapLabel=(UILabel *)Child;
                TempHandicapLabel.font=[UIFont fontWithName:MYREADPROREGULAR size:15.0f];
                NSString *Getparvalue=[self getHoleNumByTag:[Child tag]];
                NSMutableDictionary *mutableDic=[ScoreCardDetailsArray objectAtIndex:[Getparvalue integerValue]];
                TempHandicapLabel.text=[mutableDic valueForKey:@"HoleHCP"];
                UILabel *lable=[[UILabel alloc]initWithFrame:CGRectMake(30, 0, 30, 30)];
                lable.textColor=[UIColor whiteColor];
                lable.textAlignment=NSTextAlignmentCenter;
                lable.font=[UIFont fontWithName:MYREADPROREGULAR size:12.0f];
                if (![[mutableDic valueForKey:@"HoleHCPExp"]isEqualToString:@"0"])
                {
                    lable.text=[mutableDic valueForKey:@"HoleHCPExp"];
                }
                TempHandicapLabel.textColor=[UIColor whiteColor];
                [TempHandicapLabel addSubview:lable];
                
            }
            
            else if([Child isKindOfClass:[UITextField class]] && [Child tag]>=410 && [Child tag]<=419)
            {
                NSLog(@"%d",[Child tag]);
                UITextField *TempTextfiled=(UITextField *)Child;
                TempTextfiled.font=[UIFont fontWithName:MYREADPROREGULAR size:15.0f];
                NSString *Getparvalue=[self getHoleNumByTag:[Child tag]];
                NSMutableDictionary *mutableDic=[ScoreCardDetailsArray objectAtIndex:[Getparvalue integerValue]];
                TempTextfiled.text=[mutableDic valueForKey:@"HoleValue"];
                TempTextfiled.textColor=[UIColor whiteColor];
                TempTextfiled.textAlignment=NSTextAlignmentCenter;
                UILabel *lable=[[UILabel alloc]initWithFrame:CGRectMake(30, 0, 30, 30)];
                lable.textColor=[UIColor whiteColor];
                
                lable.textAlignment=NSTextAlignmentCenter;
                lable.font=[UIFont fontWithName:MYREADPROREGULAR size:12.0f];
                
                if (![[mutableDic valueForKey:@"HoleValueExp"]isEqualToString:@"0"])
                {
                    lable.text=[mutableDic valueForKey:@"HoleValueExp"];
                }
               
               
                [TempTextfiled addSubview:lable];
                
                if ([[mutableDic valueForKey:@"HoleValueColor"] isEqualToString:@"#ffffff"])
                {
                    [TempTextfiled setBackgroundColor:[UIColor clearColor]];
                }
                else
                {
                    [TempTextfiled setBackgroundColor:[TTTGlobalMethods colorFromHexString:[mutableDic valueForKey:@"HoleValueColor"]]];
                }
                if(CanEditable)
                {
                    [TempTextfiled setDelegate:self];
                    [TempTextfiled setReturnKeyType:UIReturnKeyDone];
                   
                }
                else
                {
                    [TempTextfiled setUserInteractionEnabled:NO];
                    
                }
                if (Child.tag==419)
                {
                    [TempTextfiled setBackgroundColor:[UIColor clearColor]];
                }
                
            }
            else if([Child isKindOfClass:[UITextField class]] && [Child tag]==419)
            {
                UITextField *intext=(UITextField *)Child;
                [intext setUserInteractionEnabled:NO];
                 [intext setBackgroundColor:[UIColor clearColor]];
             }
        }
        
        
        
    }

}




-(void)SetScoreToCard
{
    
   
    
    if (TotalHoleToBeShown==9)
    {
        for(UIView *Child in [ScoreCardBackView subviews])
        {
           
            
                 if([Child isKindOfClass:[UILabel class]] && [Child tag]>=100 && [Child tag]<=109)
                            {
                                UILabel *TempParLabel=(UILabel *)Child;
                                TempParLabel.font=[UIFont fontWithName:MYREADPROREGULAR size:15.0f];
                                TempParLabel.textColor=[UIColor whiteColor];
                                NSString *Getparvalue=[self getHoleNumByTag:[Child tag]];
                                NSMutableDictionary *mutableDic=[ScoreCardDetailsArray objectAtIndex:[Getparvalue integerValue]];
                                TempParLabel.text=[mutableDic valueForKey:@"Par"];
                                
                             }
                             else if([Child isKindOfClass:[UILabel class]] && [Child tag]>=200 && [Child tag]<=209)
                             {
                                UILabel *TempLengthLabel=(UILabel *)Child;
                                TempLengthLabel.font=[UIFont fontWithName:MYREADPROREGULAR size:15.0f];
                                 TempLengthLabel.textColor=[UIColor whiteColor];
                                NSString *Getparvalue=[self getHoleNumByTag:[Child tag]];
                                 NSMutableDictionary *mutableDic=[ScoreCardDetailsArray objectAtIndex:[Getparvalue integerValue]];
                                TempLengthLabel.text=[mutableDic valueForKey:@"Length"];
                                
                             }
                             else if ([Child isKindOfClass:[UILabel class]]&&[Child tag]==409)
                             {
                                 UILabel *Inlable=(UILabel *)Child;
                                 Inlable.font=[UIFont fontWithName:MYREADPROREGULAR size:15.0f];
                                 Inlable.textColor=[UIColor whiteColor];
                                 NSString *Getparvalue=[self getHoleNumByTag:[Child tag]];
                                 NSMutableDictionary *mutableDic=[ScoreCardDetailsArray objectAtIndex:[Getparvalue integerValue]];
                                 Inlable.text=[mutableDic valueForKey:@"HoleValue"];
                                 
                                 
                                 
                             }
                            else if([Child isKindOfClass:[UILabel class]] && [Child tag]>=300 && [Child tag]<=309)
                            {
                                UILabel *TempHandicapLabel=(UILabel *)Child;
                                 TempHandicapLabel.font=[UIFont fontWithName:MYREADPROREGULAR size:15.0f];
                                NSString *Getparvalue=[self getHoleNumByTag:[Child tag]];
                                [TempHandicapLabel setTextColor:[UIColor whiteColor]];
                                TempHandicapLabel.textAlignment=NSTextAlignmentCenter;
                                NSMutableDictionary *mutableDic=[ScoreCardDetailsArray objectAtIndex:[Getparvalue integerValue]];
                                TempHandicapLabel.text=[mutableDic valueForKey:@"HoleHCP"];
                                UILabel *lable=[[UILabel alloc]initWithFrame:CGRectMake(30, 0, 30, 30)];
                                lable.textColor=[UIColor whiteColor];
                                lable.textAlignment=NSTextAlignmentCenter;
                                lable.font=[UIFont fontWithName:MYREADPROREGULAR size:12.0f];
                                if (![[mutableDic valueForKey:@"HoleHCPExp"]isEqualToString:@"0"])
                                {
                                  lable.text=[mutableDic valueForKey:@"HoleHCPExp"];
                                }
                                
                                [TempHandicapLabel addSubview:lable];
                                
                            }
                            else if([Child isKindOfClass:[UITextField class]] && [Child tag]>=400 && [Child tag]<=408)
                            {
                                UITextField *TempTextfiled=(UITextField *)Child;
                               
                                TempTextfiled.font=[UIFont fontWithName:MYREADPROREGULAR size:15.0f];
                                TempTextfiled.textColor=[UIColor whiteColor];
                                TempTextfiled.textAlignment=NSTextAlignmentCenter;
                                NSString *Getparvalue=[self getHoleNumByTag:[Child tag]];
                                NSMutableDictionary *mutableDic=[ScoreCardDetailsArray objectAtIndex:[Getparvalue integerValue]];
                                TempTextfiled.text=[mutableDic valueForKey:@"HoleValue"];
                                UILabel *lable=[[UILabel alloc]initWithFrame:CGRectMake(30, 0, 30, 30)];
                                lable.textColor=[UIColor whiteColor];
                                lable.textAlignment=NSTextAlignmentCenter;
                                lable.font=[UIFont fontWithName:MYREADPROREGULAR size:12.0f];
                                if (![[mutableDic valueForKey:@"HoleValueExp"]isEqualToString:@"0"])
                                {
                                    lable.text=[mutableDic valueForKey:@"HoleValueExp"];
                                }
                                [TempTextfiled addSubview:lable];
                                if ([[mutableDic valueForKey:@"HoleValueColor"] isEqualToString:@"#ffffff"])
                                {
                                    [TempTextfiled setBackgroundColor:[UIColor clearColor]];
                                }
                                else
                                {
                                [TempTextfiled setBackgroundColor:[TTTGlobalMethods colorFromHexString:[mutableDic valueForKey:@"HoleValueColor"]]];
                                }
                                
                                if(CanEditable)
                                {
                                    [TempTextfiled setDelegate:self];
                                    [TempTextfiled setReturnKeyType:UIReturnKeyDone];
                                   
                                }
                                else
                                {
                                    [TempTextfiled setUserInteractionEnabled:NO];
                                    
                                }
                                
                              
                            }
                            else if([Child isKindOfClass:[UILabel class]] && [Child tag]==409)
                            {
                                UITextField *intext=(UITextField *)Child;
                                [intext setUserInteractionEnabled:NO];
                                 [intext setBackgroundColor:[UIColor clearColor]];
                            }
            
            
                        }
          
        }
    
    else
    {
        for(UIView *Child in [ScoreCardBackView subviews])
        {
            
            
            if([Child isKindOfClass:[UILabel class]] && [Child tag]>=100 && [Child tag]<=109)
            {
               
                UILabel *TempParLabel=(UILabel *)Child;
                TempParLabel.font=[UIFont fontWithName:MYREADPROREGULAR size:15.0f];
                NSString *Getparvalue=[self getHoleNumByTag:[Child tag]];
                NSMutableDictionary *mutableDic=[ScoreCardDetailsArray objectAtIndex:[Getparvalue integerValue]];
                TempParLabel.text=[mutableDic valueForKey:@"Par"];
                TempParLabel.textColor=[UIColor whiteColor];
              
            }
            else if([Child isKindOfClass:[UILabel class]] && [Child tag]>=200 && [Child tag]<=209)
            {
                
                UILabel *TempLengthLabel=(UILabel *)Child;
                TempLengthLabel.font=[UIFont fontWithName:MYREADPROREGULAR size:15.0f];
                NSString *Getparvalue=[self getHoleNumByTag:[Child tag]];
                NSMutableDictionary *mutableDic=[ScoreCardDetailsArray objectAtIndex:[Getparvalue integerValue]];
                TempLengthLabel.textColor=[UIColor whiteColor];
                TempLengthLabel.text=[mutableDic valueForKey:@"Length"];
                
            }
            else if ([Child isKindOfClass:[UILabel class]]&&[Child tag]==409)
            {
                UILabel *Inlable=(UILabel *)Child;
                Inlable.font=[UIFont fontWithName:MYREADPROREGULAR size:15.0f];
                NSString *Getparvalue=[self getHoleNumByTag:[Child tag]];
                NSMutableDictionary *mutableDic=[ScoreCardDetailsArray objectAtIndex:[Getparvalue integerValue]];
                Inlable.text=[mutableDic valueForKey:@"HoleValue"];
                
                
                
            }
            else if([Child isKindOfClass:[UILabel class]] && [Child tag]>=300 && [Child tag]<=309)
            {
                
                UILabel *TempHandicapLabel=(UILabel *)Child;
                TempHandicapLabel.font=[UIFont fontWithName:MYREADPROREGULAR size:15.0f];
                NSString *Getparvalue=[self getHoleNumByTag:[Child tag]];
                NSMutableDictionary *mutableDic=[ScoreCardDetailsArray objectAtIndex:[Getparvalue integerValue]];
                TempHandicapLabel.text=[mutableDic valueForKey:@"HoleHCP"];
                UILabel *lable=[[UILabel alloc]initWithFrame:CGRectMake(30, 0, 30, 30)];
                lable.textColor=[UIColor whiteColor];
                lable.textAlignment=NSTextAlignmentCenter;
                lable.font=[UIFont fontWithName:MYREADPROREGULAR size:12.0f];
                TempHandicapLabel.textColor=[UIColor whiteColor];
                lable.text=[mutableDic valueForKey:@"HoleHCPExp"];
                [TempHandicapLabel addSubview:lable];
              
            }
            
            else if([Child isKindOfClass:[UITextField class]] && [Child tag]>=400 && [Child tag]<=409)
            {
                
                UITextField *TempTextfiled=(UITextField *)Child;
                TempTextfiled.font=[UIFont fontWithName:MYREADPROREGULAR size:15.0f];
                NSString *Getparvalue=[self getHoleNumByTag:[Child tag]];
                NSMutableDictionary *mutableDic=[ScoreCardDetailsArray objectAtIndex:[Getparvalue integerValue]];
                TempTextfiled.text=[mutableDic valueForKey:@"HoleValue"];
                UILabel *lable=[[UILabel alloc]initWithFrame:CGRectMake(30, 0, 30, 30)];
                lable.textColor=[UIColor whiteColor];
                lable.textAlignment=NSTextAlignmentCenter;
                lable.font=[UIFont fontWithName:MYREADPROREGULAR size:12.0f];
                lable.text=[mutableDic valueForKey:@"HoleValueExp"];
                [TempTextfiled setTextColor:[UIColor whiteColor]];
                [TempTextfiled addSubview:lable];
                
                if ([[mutableDic valueForKey:@"HoleValueColor"] isEqualToString:@"#ffffff"])
                {
                    [TempTextfiled setBackgroundColor:[UIColor clearColor]];
                }
                else
                {
                    [TempTextfiled setBackgroundColor:[TTTGlobalMethods colorFromHexString:[mutableDic valueForKey:@"HoleValueColor"]]];
                }
                
                if(CanEditable)
                {
                     [TempTextfiled setDelegate:self];
                     [TempTextfiled setReturnKeyType:UIReturnKeyDone];
                    
                }
                else
                {
                    [TempTextfiled setUserInteractionEnabled:NO];
                    
                }
          
            }
            
            
            else if([Child isKindOfClass:[UILabel class]] && [Child tag]>=110 && [Child tag]<=119)
            {
                NSLog(@"%d",[Child tag]);
                UILabel *TempParLabel=(UILabel *)Child;
                TempParLabel.font=[UIFont fontWithName:MYREADPROREGULAR size:15.0f];
                NSString *Getparvalue=[self getHoleNumByTag:[Child tag]];
                NSLog(@"%d",[Child tag]);
                
                NSMutableDictionary *mutableDic=[ScoreCardDetailsArray objectAtIndex:[Getparvalue integerValue]];
                TempParLabel.text=[mutableDic valueForKey:@"Par"];
                TempParLabel.textColor=[UIColor whiteColor];
                
                
            }
            else if([Child isKindOfClass:[UILabel class]] && [Child tag]>=210 && [Child tag]<=219)
            {
                NSLog(@"%d",[Child tag]);
                UILabel *TempLengthLabel=(UILabel *)Child;
                TempLengthLabel.font=[UIFont fontWithName:MYREADPROREGULAR size:15.0f];
                NSString *Getparvalue=[self getHoleNumByTag:[Child tag]];
                NSMutableDictionary *mutableDic=[ScoreCardDetailsArray objectAtIndex:[Getparvalue integerValue]];
                TempLengthLabel.textColor=[UIColor whiteColor];
                TempLengthLabel.text=[mutableDic valueForKey:@"Length"];
                
               }
               else if([Child isKindOfClass:[UILabel class]] && [Child tag]>=310 && [Child tag]<=319)
               {
                NSLog(@"%d",[Child tag]);
                UILabel *TempHandicapLabel=(UILabel *)Child;
                TempHandicapLabel.font=[UIFont fontWithName:MYREADPROREGULAR size:15.0f];
                NSString *Getparvalue=[self getHoleNumByTag:[Child tag]];
                NSMutableDictionary *mutableDic=[ScoreCardDetailsArray objectAtIndex:[Getparvalue integerValue]];
                TempHandicapLabel.text=[mutableDic valueForKey:@"HoleHCP"];
                UILabel *lable=[[UILabel alloc]initWithFrame:CGRectMake(30, 0, 30, 30)];
                lable.textColor=[UIColor whiteColor];
                lable.textAlignment=NSTextAlignmentCenter;
                lable.font=[UIFont fontWithName:MYREADPROREGULAR size:12.0f];
                lable.text=[mutableDic valueForKey:@"HoleHCPExp"];
                TempHandicapLabel.textColor=[UIColor whiteColor];
                [TempHandicapLabel addSubview:lable];
                 
               }
          
               else if([Child isKindOfClass:[UITextField class]] && [Child tag]>=410 && [Child tag]<=419)
                {
                    NSLog(@"%d",[Child tag]);
                    UITextField *TempTextfiled=(UITextField *)Child;
                    TempTextfiled.font=[UIFont fontWithName:MYREADPROREGULAR size:15.0f];
                    NSString *Getparvalue=[self getHoleNumByTag:[Child tag]];
                    NSMutableDictionary *mutableDic=[ScoreCardDetailsArray objectAtIndex:[Getparvalue integerValue]];
                    TempTextfiled.text=[mutableDic valueForKey:@"HoleValue"];
                    TempTextfiled.textColor=[UIColor whiteColor];
                    TempTextfiled.textAlignment=NSTextAlignmentCenter;
                    UILabel *lable=[[UILabel alloc]initWithFrame:CGRectMake(30, 0, 30, 30)];
                    lable.textColor=[UIColor whiteColor];
                    
                    lable.textAlignment=NSTextAlignmentCenter;
                    lable.font=[UIFont fontWithName:MYREADPROREGULAR size:12.0f];
                    lable.text=[mutableDic valueForKey:@"HoleValueExp"];
                    [TempTextfiled addSubview:lable];
                    
                    if ([[mutableDic valueForKey:@"HoleValueColor"] isEqualToString:@"#ffffff"])
                    {
                        [TempTextfiled setBackgroundColor:[UIColor clearColor]];
                    }
                    else
                    {
                        [TempTextfiled setBackgroundColor:[TTTGlobalMethods colorFromHexString:[mutableDic valueForKey:@"HoleValueColor"]]];
                    }
                    if(CanEditable)
                    {
                        [TempTextfiled setDelegate:self];
                        [TempTextfiled setReturnKeyType:UIReturnKeyDone];
                        
                    }
                    else
                    {
                        
                    [TempTextfiled setUserInteractionEnabled:NO];
                        
                        
                      
                    }
                    if (Child.tag==419)
                    {
                          NSLog(@"the value text field set text:");
                          [TempTextfiled setBackgroundColor:[UIColor clearColor]];
                          [TempTextfiled setUserInteractionEnabled:NO];
                    }
                }
               else if([Child isKindOfClass:[UITextField class]] && [Child tag]==419)
               {
                   NSLog(@"the value text field:");
                   UITextField *intext=(UITextField *)Child;
                   [intext setUserInteractionEnabled:NO];
                   [intext setBackgroundColor:[UIColor clearColor]];
               }
            }
       
        


    }
    

    
}




-(void)SaveholevalueFortextfield:(UITextField *)TextField
{
   
    NSInteger hole;
    [self performSelectorOnMainThread:@selector(updatevaluefornetscoregrossScore) withObject:nil waitUntilDone:YES];
    if (TextField.tag>=410)
    {
          hole=TextField.tag-400;
    }
     else
     {
     hole=(TextField.tag-400)+1;
     }
    NSString *holeno=[NSString stringWithFormat:@"%d",hole];
    NSLog(@"TTT The value of Hole:%d",hole);
    
    NSString *Strurl=[NSString stringWithFormat:@"%@user.php?mode=scorecardsave&eventid=%@&userid=%@&holeno=%@&value=%@&loggedin_userid=%@&status=1",API,matchID,ViewerID,holeno,TextField.text,[self LoggedId]];
    NSLog(@"The sting url:%@",Strurl);
    NSData *data=[NSData dataWithContentsOfURL:[NSURL URLWithString:Strurl]];
    NSDictionary *mainDic=[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    NSString *responcemsg=[mainDic valueForKey:@"response"];
    NSString *message=[mainDic valueForKey:@"message"];
    if ([responcemsg isEqualToString:@"success"])
    {
        NSLog(@"Update value for score:");
        NSDictionary *matchval=[mainDic valueForKey:@"matchvalue"];
        
        [self performSelectorOnMainThread:@selector(updatevalueforscorecard:) withObject:matchval waitUntilDone:YES];
       
    }
    else
    {
      
        [_mainScroll setContentOffset:CGPointMake(0, 0) animated:YES];
        if (IsInLandscapeMode)
        {
            [_landScapemainScroll setContentOffset:CGPointMake(0, 0) animated:YES];
            [_LandScapeScrollforiPhone4 setContentOffset:CGPointMake(0, 0) animated:YES];
        }
       
        [SVProgressHUD showErrorWithStatus:message];
    }
    
}


-(void)updatevalueforscorecard:(NSMutableDictionary *)MutDicmain
{
    NSLog(@"The value of:%@",MutDicmain);
    grossscore=[MutDicmain valueForKey:@"grossscore"];
    toper=[NSString stringWithFormat:@"%@",[MutDicmain valueForKey:@"toper"]];
    Tooparlbl.text=toper;
    _TotalScoreForpotred.text=grossscore;
 
}

-(void)updatevaluefornetscoregrossScore
{
    //Upadate Filds for textview chande
  
    if (TotalHoleToBeShown==9)
    {
        
        if (IsInLandscapeMode)
        {
          NSInteger  scoreValue=0;
            for(UIView *Child in [ViewForlandScapeMode subviews])
            {
                if([Child isKindOfClass:[UITextField class]] && [Child tag]>=400 && [Child tag]<409)
                {
                    UITextField *TempTextfiled=(UITextField *)Child;
                    
                   
                    if (TempTextfiled.text.length>0)
                    {
                         scoreValue=[TempTextfiled.text integerValue]+scoreValue;
                    }
                    
                    
                    
                }
                UILabel *lableInvalue=(UILabel *)[ViewForlandScapeMode viewWithTag:409];
                [lableInvalue setText:[NSString stringWithFormat:@"%d",scoreValue]];
                
            }
            
            
        }
    
        else
        {
             NSInteger  scoreValue=0;
            for(UIView *Child in [ScoreCardBackView subviews])
            {
                if([Child isKindOfClass:[UITextField class]] && [Child tag]>=400 && [Child tag]<409)
                {
                    UITextField *TempTextfiled=(UITextField *)Child;
                  
                    if (TempTextfiled.text.length>0)
                    {
                        scoreValue=[TempTextfiled.text integerValue]+scoreValue;
                    }
                    
                    
                }
                
            }
            UILabel *lableInvalue=(UILabel *)[ScoreCardBackView viewWithTag:409];
            [lableInvalue setText:[NSString stringWithFormat:@"%d",scoreValue]];
        }
    }
    else
    {
        
        if (IsInLandscapeMode)
        {
            NSInteger scoreValue=0;
            NSInteger Totalscore=0;
            for(UIView *Child in [ViewForlandScapeMode subviews])
            {
                
                if([Child isKindOfClass:[UITextField class]] && [Child tag]>=400 && [Child tag]<409)
                {
                    UITextField *TempTextfiled=(UITextField *)Child;
                    
                    if (TempTextfiled.text.length>0)
                    {
                         scoreValue=[TempTextfiled.text integerValue]+scoreValue;
                    }
                    
                    
                }
                
            }
            for(UIView *Child in [ViewForlandScapeMode subviews])
            {
                
                if([Child isKindOfClass:[UITextField class]] && [Child tag]>409 && [Child tag]<419)
                {
                    UITextField *TempTextfiled=(UITextField *)Child;
                    
                    if (TempTextfiled.text.length>0)
                    {
                        Totalscore=[TempTextfiled.text integerValue]+Totalscore;
                    }
                    
                    
                }
                UILabel *lableInvalue=(UILabel *)[ViewForlandScapeMode viewWithTag:409];
                [lableInvalue setText:[NSString stringWithFormat:@"%d",scoreValue]];
                UITextField *textLast=(UITextField *)[ViewForlandScapeMode viewWithTag:419];
                [textLast setText:[NSString stringWithFormat:@"%d",Totalscore]];

                
            }

            
            
        }
        else
        {
            NSInteger scoreValue=0;
            NSInteger Totalscore=0;
            for(UIView *Child in [ScoreCardBackView subviews])
            {
                
                if([Child isKindOfClass:[UITextField class]] && [Child tag]>=400 && [Child tag]<409)
                {
                    UITextField *TempTextfiled=(UITextField *)Child;
                    
                    if (TempTextfiled.text.length>0)
                    {
                        scoreValue=[TempTextfiled.text integerValue]+scoreValue;
                    }
                    
                    
                }
                
            }
            for(UIView *Child in [ScoreCardBackView subviews])
            {
                
                if([Child isKindOfClass:[UITextField class]] && [Child tag]>409 && [Child tag]<419)
                {
                    UITextField *TempTextfiled=(UITextField *)Child;
                    
                    if (TempTextfiled.text.length>0)
                    {
                        Totalscore=[TempTextfiled.text integerValue]+Totalscore;
                    }
                    
                    
                }
                
                UILabel *lableInvalue=(UILabel *)[ScoreCardBackView viewWithTag:409];
                [lableInvalue setText:[NSString stringWithFormat:@"%d",scoreValue]];
                UITextField *textLast=(UITextField *)[ScoreCardBackView viewWithTag:419];
                [textLast setText:[NSString stringWithFormat:@"%d",Totalscore]];
                
                
            }
            
            
        }
        
       
    }
    
    
}



-(NSString *)getHoleNumByTag:(int)tag
{
  
    switch(tag)
    {
        case 100:
        case 200:
        case 300:
        case 400:
            return @"0";
        case 101:
        case 201:
        case 301:
        case 401:
            return @"1";
        case 102:
        case 202:
        case 302:
        case 402:
            return @"2";
        case 103:
        case 203:
        case 303:
        case 403:
            return @"3";
        case 104:
        case 204:
        case 304:
        case 404:
            return @"4";
        case 105:
        case 205:
        case 305:
        case 405:
            return @"5";
        case 106:
        case 206:
        case 306:
        case 406:
            return @"6";
        case 107:
        case 207:
        case 307:
        case 407:
            return @"7";
        case 108:
        case 208:
        case 308:
        case 408:
            return @"8";
        case 109:
        case 209:
        case 309:
        case 409:
            return @"9";
        case 110:
        case 210:
        case 310:
        case 410:
            return @"10";
        case 111:
        case 211:
        case 311:
        case 411:
            return @"11";
        case 112:
        case 212:
        case 312:
        case 412:
            return @"12";
        case 113:
        case 213:
        case 313:
        case 413:
            return @"13";
        case 114:
        case 214:
        case 314:
        case 414:
            return @"14";
        case 115:
        case 215:
        case 315:
        case 415:
            return @"15";
        case 116:
        case 216:
        case 316:
        case 416:
            return @"16";
        case 117:
        case 217:
        case 317:
        case 417:
            return @"17";
        case 118:
        case 218:
        case 318:
        case 418:
            return @"18";
        case 119:
        case 219:
        case 319:
        case 419:
            return @"19";
    }
    return @"";
}

#pragma mark for delegates


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 16;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return (row==0)?@"":[NSString stringWithFormat:@"%d", row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
   //[TFfirstResponder setText:(row==0)?@"":[NSString stringWithFormat:@"%d", row]];
     textfieldtext=(row==0)?@"":[NSString stringWithFormat:@"%d", row];
    if (textfieldtext.length>0)
    {
         NSLog(@"the value of text field:%@",textfieldtext);
    }
   
  
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [[self view] endEditing:YES];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSLog(@"The value of text field textt:%@",textField.text);
   
   if (textField.text.length>0)
    {
         Valueupdate=textField.text;
    }
   
    BOOL AllowMe=FALSE;
    textfieldtext=@"";
    

    
    [self UnHilightedPriviousornexttextfield:textField];
    UIView *VTFBack=(UIView *)[textField superview];
    privioustxtvalue=textField.text;
    textField.text=nil;
    if([textField tag]==400 || [textField tag]==CurrentResponderTag)
    {
       AllowMe=TRUE;
    }

    else
    {
        UITextField *PrevTextField;
        
        if (textField.tag==410)
         {
            PrevTextField=(UITextField *)[VTFBack viewWithTag:([textField tag]-2)];
         }
        else
         {
         PrevTextField=(UITextField *)[VTFBack viewWithTag:([textField tag]-1)];
         }
       
        if([[PrevTextField text] length]>0)
        {
           AllowMe=TRUE;
        }
       
        else
        {
            [textField resignFirstResponder];
            
            
            for(UITextField *child in [VTFBack subviews])
            {
                if([child isKindOfClass:[UITextField class]])
                {
                    if(![[child text] length]>0)
                    {
                        CurrentResponderTag=[child tag];
                       // [self becomeFirstResponderToTextField:child];
                        break;
                    }
                }
            }
        }
    }
    
    if(AllowMe)
    {
        //[textField becomeFirstResponder];
        [self becomeFirstResponderToTextField:textField];
        
    }
    else
    {
        [self resignAllFirstResponderInView:VTFBack];
        [SVProgressHUD showErrorWithStatus:@"You can't skip any hole"];
    }
}





-(void)textFieldDidEndEditing:(UITextField *)textField
{
    
   
    if (Valueupdate.length>0)
    {
        textField.text=Valueupdate;
    }
    textField.backgroundColor=[UIColor clearColor];
   
    NSLog(@"the value 1");
    if(IsInLandscapeMode)
    {
        [SVLandscape setContentSize:InitialLandscapeContentSize];
    }
    
    
   
}


-(void)resignCurrentFirstResponder
{
    [TFfirstResponder resignFirstResponder];
  
     CurrentResponderTag=0;
    NSLog(@"The value for current string:%@",textfieldtext);
    if (textfieldtext.length>0)
    {
        TFfirstResponder.text=textfieldtext;
        UIView *VTFBack=(UIView *)[TFfirstResponder superview];
        [self resignAllFirstResponderInView:VTFBack];
          [_ScorecardScroll setUserInteractionEnabled:YES];
        if (TotalHoleToBeShown==9)
        {
            if ([TFfirstResponder tag]==408)
            {
                NSInvocationOperation *operattonSvaeHoleValue=[[NSInvocationOperation alloc]initWithTarget:self selector:@selector(SaveholevalueFortextfield:) object:TFfirstResponder];
                [OperationQueue addOperation:operattonSvaeHoleValue];
                [self UnHilightedPriviousornexttextfield:TFfirstResponder];
                 [self resignFirstResponder];
            }
            else
            {
                [self becomeFirstResponderNextTextFieldAfter:TFfirstResponder];
                [self resignFirstResponder];
            }
        }
        if (TotalHoleToBeShown==18)
        {
            if ([TFfirstResponder tag]==418)
            {
                NSInvocationOperation *operattonSvaeHoleValue=[[NSInvocationOperation alloc]initWithTarget:self selector:@selector(SaveholevalueFortextfield:) object:TFfirstResponder];
                [OperationQueue addOperation:operattonSvaeHoleValue];
                 [self UnHilightedPriviousornexttextfield:TFfirstResponder];
                [self resignFirstResponder];
            }
            else
            {
                [self becomeFirstResponderNextTextFieldAfter:TFfirstResponder];
                [self resignFirstResponder];
            }
        }
        
    }
    else
    {
        UIAlertView *Alert=[[UIAlertView alloc]initWithTitle:@"sorry" message:@"you can't leave a hole blank!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [Alert show];
    }
    
   


}


-(void)becomeFirstResponderNextTextFieldAfter:(UITextField *)textField
{
  
    UIView *VTFBack=(UIView *)[textField superview];
    
    UIView *backviewSubview=(UIView *)[textField superview];
    int i = 1;
    for(UIView *Child in [backviewSubview subviews])
    {
        
        if([Child isKindOfClass:[UITextField class]] && [Child tag]>[textField tag] && [Child tag]<419)
        {
            
            UITextField *Nexttext=(UITextField *)Child;
            UITextField *privioustextfield;
            
            
            if (Nexttext.tag==410)
            {
                privioustextfield=(UITextField *)[backviewSubview viewWithTag:Nexttext.tag-2];
            }
            else
            {
                privioustextfield=(UITextField *)[backviewSubview viewWithTag:Nexttext.tag-1];
            }
            
            if ([Nexttext.text length]==0&&[privioustextfield.text length]>0)
            {
                lastpostDataTag=Nexttext.tag;
               
                break;
                
            }
            i++;
            
            
            
        }
        
        
    }
    
    
    
    TFfirstResponder=(UITextField *)[VTFBack viewWithTag:(lastpostDataTag)];
    [TFfirstResponder becomeFirstResponder];
    
    
    NSInvocationOperation *operattonSvaeHoleValue=[[NSInvocationOperation alloc]initWithTarget:self selector:@selector(SaveholevalueFortextfield:) object:textField];
    [OperationQueue addOperation:operattonSvaeHoleValue];

    
}




-(void)becomeFirstResponderToTextField:(UITextField *)textField
{
    
    pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 60.0f)];
    TFfirstResponder=textField;
   
    [pickerView setDelegate:self];
    [pickerView setDataSource:self];
    [pickerView setShowsSelectionIndicator:YES];
    [textField setInputView:pickerView];
    
    [_mainScroll setContentOffset:CGPointMake(0, 50) animated:YES];
    if (IsInLandscapeMode)
    {
        [_landScapemainScroll setContentOffset:CGPointMake(0, 170) animated:YES];
        [_LandScapeScrollforiPhone4 setContentOffset:CGPointMake(0, 140) animated:YES];
    }
    
    UIToolbar* keyboardDoneButtonView = [[UIToolbar alloc] init];
    [keyboardDoneButtonView setTranslucent:YES];
    [keyboardDoneButtonView setTintColor:Nil];
    [keyboardDoneButtonView sizeToFit];
    
    UIBarButtonItem* doneButton=[[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(resignCurrentFirstResponder)];
    UIBarButtonItem* cancelButton=[[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleDone target:self action:@selector(resignResponder)];
    [keyboardDoneButtonView setItems:@[doneButton, cancelButton]];
    [textField setInputAccessoryView:keyboardDoneButtonView];
    
    [self highlightColoumForTextField:textField];
}









-(void)highlightColoumForTextField:(UITextField *)textField
{
    UIView *VTFBack=(UIView *)[textField superview];
    for(UIView *child in [VTFBack subviews])
    {
        if([child isKindOfClass:[UILabel class]])
        {
            if(([child tag]==([textField tag]-100) || [child tag]==([textField tag]-200) || [child tag]==([textField tag]-300)))
            {
                [child setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"table-box-select-bg"]]];
            }
           
        }
        else if([child isKindOfClass:[UITextField class]])
        {
            if (child.tag==textField.tag)
            {
              [child setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"numberbg3"]]];
            }
            
        }
        }
   
    //[textField setBackgroundColor:[UIColor clearColor]];
}


-(void)UnHilightedPriviousornexttextfield:(UITextField *)textfield
 {
     UIView *VTFBack=(UIView *)[textfield superview];
     for(UIView *child in [VTFBack subviews])
     {
         if([child isKindOfClass:[UILabel class]])
         {
//             if(([child tag]==([textfield tag]-100) || [child tag]==([textfield tag]-200) || [child tag]==([textfield tag]-300)))
//             {
                [child setBackgroundColor:[UIColor clearColor]];
            // }
             
         }
//        else if([child isKindOfClass:[UITextField class]])
//             //[child setBackgroundColor:[UIColor clearColor]];
     }
 
 }

-(void)clearHighlightedColoumInView:(UIView *)VTFBack
{
    for(UIView *child in [VTFBack subviews])
    {
        if([child isKindOfClass:[UILabel class]] && [child tag]>0)
            [child setBackgroundColor:[UIColor clearColor]];
        else if([child isKindOfClass:[UITextField class]])
            [child setBackgroundColor:[UIColor clearColor]];
    }
}

-(void)resignResponder
{
   
        [_ScorecardScroll setUserInteractionEnabled:YES];
        [_mainScroll setContentOffset:CGPointMake(0, 0) animated:YES];
    
        [_landScapemainScroll setContentOffset:CGPointMake(0, 0) animated:YES];
        [_LandScapeScrollforiPhone4 setContentOffset:CGPointMake(0, 0) animated:YES];
    
   
        [TFfirstResponder setText:privioustxtvalue];
        [TFfirstResponder resignFirstResponder];
    
   
}

-(void)resignAllFirstResponderInView:(UIView *)VTFBack
{
    for(UIView *child in [VTFBack subviews])
    {
        if([child isKindOfClass:[UITextField class]])
        {
            [child resignFirstResponder];
        }
    }
}
//TextFieldDelegate





//post button click

-(void)postbuutonclick
{
    
    
    
  NSMutableDictionary *myarrayToStoreholes=[[NSMutableDictionary alloc]init];
    if (TotalHoleToBeShown==9)
    {
        
        if (IsInLandscapeMode)
        {
            for(UIView *Child in [ViewForlandScapeMode subviews])
            {
                if([Child isKindOfClass:[UITextField class]] && [Child tag]>=400 && [Child tag]<409)
                {
                    UITextField *TempTextfiled=(UITextField *)Child;
                    NSInteger keyInt=[Child tag]-400;
                    NSString *key=[NSString stringWithFormat:@"%d",keyInt];
                    if (TempTextfiled.text.length>0)
                    {
                      [myarrayToStoreholes setValue:TempTextfiled.text forKey:key];
                    }
                    
                    
                    
                }
                
            }
        }
        
        else
        {
        for(UIView *Child in [ScoreCardBackView subviews])
        {
            if([Child isKindOfClass:[UITextField class]] && [Child tag]>=400 && [Child tag]<409)
            {
                UITextField *TempTextfiled=(UITextField *)Child;
                NSInteger keyInt=[Child tag]-400;
                NSString *key=[NSString stringWithFormat:@"%d",keyInt];
                if (TempTextfiled.text.length>0)
                {
                    [myarrayToStoreholes setValue:TempTextfiled.text forKey:key];
                }
                
                
            }
            
        }
        }
        
            
            if ([myarrayToStoreholes count]==9)
            {
                
                NSString *mainString;
                mainString=[mainString valueForKey:@"0"];
                for (int i=1;i<[myarrayToStoreholes count];i++)
                {
                    NSString *key=[NSString stringWithFormat:@"%d",i];
                    
                    NSString *SentString=[myarrayToStoreholes valueForKey:key];
                    mainString=[NSString stringWithFormat:@"%@,%@",mainString,SentString];
                    
                    
                    
                }
                NSLog(@"The value of main string:%@",mainString);
                
                dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                    // NSLog(@"This is post");
                    
                    NSString *ScoreCarddic=[NSString stringWithFormat:@"%@user.php?mode=scorecardEntry&eventid=%@&userid=%@&holeval=%@&status=1&loggedin_userid=%@",API,matchID,ViewerID,mainString,[self LoggedId]];
                    NSData *data=[NSData dataWithContentsOfURL:[NSURL URLWithString:ScoreCarddic]];
                    NSDictionary *mainDic=[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                    NSString *responce=[mainDic valueForKey:@"response"];
                    NSString *messAge=[mainDic valueForKey:@"message"];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        if ([responce isEqualToString:@"error"])
                        {
                            [SVProgressHUD showErrorWithStatus:messAge];
                        }
                        else
                        {
                            [SVProgressHUD showSuccessWithStatus:messAge];
                            self.Postbtn.hidden=YES;
                            self.postBtnclick.hidden=YES;
                            [self UserInteractionDisableFromtextfield:409];
                        }
                        
                        
                        
                    });
                    
                    
                });
                
                
                
            }
            else
            {
                [SVProgressHUD showErrorWithStatus:@"Please select all the hole first"];
            }
            }
    else
    {
    
        if (IsInLandscapeMode)
        {
            for(UIView *Child in [ViewForlandScapeMode subviews])
            {
                if([Child isKindOfClass:[UITextField class]] && [Child tag]>=400 && [Child tag]<419)
                {
                    UITextField *TempTextfiled=(UITextField *)Child;
                    NSInteger keyInt=[Child tag]-400;
                    NSString *key=[NSString stringWithFormat:@"%d",keyInt];
                    if (TempTextfiled.text.length>0)
                    {
                        [myarrayToStoreholes setValue:TempTextfiled.text forKey:key];
                    }
                    
                    
                }
                
                
            }
            
           
        }
    else
    {
    for(UIView *Child in [ScoreCardBackView subviews])
    {
        if([Child isKindOfClass:[UITextField class]] && [Child tag]>=400 && [Child tag]<419)
        {
             UITextField *TempTextfiled=(UITextField *)Child;
             NSInteger keyInt=[Child tag]-400;
             NSString *key=[NSString stringWithFormat:@"%d",keyInt];
            if (TempTextfiled.text.length>0)
            {
                [myarrayToStoreholes setValue:TempTextfiled.text forKey:key];
            }
            
            
        }
        
  
    }
    
    }
    
     if ([myarrayToStoreholes count]==18)
        {
            
            NSString *mainString=[myarrayToStoreholes valueForKey:@"0"];
         
            
            for (int i=1;i<=[myarrayToStoreholes count];i++)
            {
                NSString *key=[NSString stringWithFormat:@"%d",i];
                if (i!=9)
                {
                    NSString *SentString=[myarrayToStoreholes valueForKey:key];
                    mainString=[NSString stringWithFormat:@"%@,%@",mainString,SentString];
                    
                }
                 NSLog(@"my array to score bord count:%@",mainString);
            }
            
            
                NSLog(@"The post Score card:%@",mainString);
                dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                    
                   
                    NSString *ScoreCarddic=[NSString stringWithFormat:@"%@user.php?mode=scorecardEntry&eventid=%@&userid=%@&holeval=%@&status=1&loggedin_userid=%@",API,matchID,ViewerID,mainString,[self LoggedId]];
                    NSLog(@"This is post:%@",ScoreCarddic);
                    NSData *data=[NSData dataWithContentsOfURL:[NSURL URLWithString:ScoreCarddic]];
                    NSDictionary *mainDic=[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                    NSString *responce=[mainDic valueForKey:@"response"];
                    NSString *messAge=[mainDic valueForKey:@"message"];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        if ([responce isEqualToString:@"error"])
                        {
                            [SVProgressHUD showErrorWithStatus:messAge];
                        }
                        else
                        {
                            [SVProgressHUD showSuccessWithStatus:messAge];
                            [self.postBtnclick setHidden:YES];
                            [self.Postbtn setHidden:YES];
                            [self UserInteractionDisableFromtextfield:419];
                            
                        }
                        
                        
                        
                    });
                    
                    
                });
                
                
            
        }
        
        else
        {
            [SVProgressHUD showErrorWithStatus:@"Please select all the hole first"];
            
        }
            
            
            
        }
}


-(void)UserInteractionDisableFromtextfield:(NSInteger)HOLE
{
    if (IsInLandscapeMode)
    {
        for(UIView *Child in [ViewForlandScapeMode subviews])
        {
            if([Child isKindOfClass:[UITextField class]] && [Child tag]>=400 && [Child tag]<HOLE)
            {
                UITextField *TempTextfiled=(UITextField *)Child;
                [TempTextfiled setUserInteractionEnabled:NO];
                
                
            }
            
            
        }
        
        
    }
    else
    {
        for(UIView *Child in [ScoreCardBackView subviews])
        {
            if([Child isKindOfClass:[UITextField class]] && [Child tag]>=400 && [Child tag]<HOLE)
            {
                UITextField *TempTextfiled=(UITextField *)Child;
                  [TempTextfiled setUserInteractionEnabled:NO];
                
            }
            
            
        }

    
    }
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    
}

- (IBAction)postBtnclick:(id)sender
{
    
    [self postbuutonclick];
    
    
}


- (IBAction)Backbuttonclick:(id)sender
{
    [self PerformGoBack];
}







- (IBAction)BackTopotred:(id)sender
{
}

@end
