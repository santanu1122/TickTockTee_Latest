//
//  TTTHandicapDetails.m
//  TickTockTee
//
//  Created by macbook_ms on 25/03/14.
//  Copyright (c) 2014 com.esolz.TickTockTee. All rights reserved.
//

#import "TTTHandicapDetails.h"
#import "TTTGlobalMethods.h"
#import "SVProgressHUD.h"
#import "TTTScoreBord.h"

@interface TTTHandicapDetails ()
{
    NSDictionary *MutDicForhanDicap;
    NSOperationQueue *MymainOperation;
    NSString *ViewID;
    
}
@property (strong, nonatomic) IBOutlet UILabel *MatchLbl;


@property (strong, nonatomic) IBOutlet UIView *Roundbackview;


@property (strong, nonatomic) IBOutlet UILabel *course2lbl;
@property (strong, nonatomic) IBOutlet UILabel *SlopLbl;
@property (strong, nonatomic) IBOutlet UILabel *RattingLbl;
@property (strong, nonatomic) IBOutlet UILabel *Datetimelbl;

@property (strong, nonatomic) IBOutlet UILabel *grossScoreLbl;
@property (strong, nonatomic) IBOutlet UILabel *GrossScoreTxt;

@property (strong, nonatomic) IBOutlet UIView *BackLblhandicapDif;
@property (strong, nonatomic) IBOutlet UILabel *HanDicapDifperroundLbl;

@property (strong, nonatomic) IBOutlet UIView *TTTHanDicapDitis;

@property (strong, nonatomic) IBOutlet UILabel *ttthanDicapDetaisLbl;

@property (strong, nonatomic) IBOutlet UIScrollView *HanDicapBackScroll;



@end

@implementation TTTHandicapDetails
@synthesize MatchLbl,course2lbl,SlopLbl,RattingLbl,grossScoreLbl,GrossScoreTxt,BackLblhandicapDif,ttthanDicapDetaisLbl,TTTHanDicapDitis,Datetimelbl,HanDicapDifperroundLbl,matchEventId,paramviewID;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self=(IsIphone5)?[super initWithNibName:@"TTTHandicapDetails" bundle:nil]:[super initWithNibName:@"TTTHandicapDetails_iPhone4" bundle:nil];
    }
    return self;
}
- (IBAction)BackToprivious:(id)sender
{
    [self PerformGoBack];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    MutDicForhanDicap=[[NSMutableDictionary alloc]init];
    MymainOperation=[[NSOperationQueue alloc]init];
    ViewID=(paramviewID.length>0)?paramviewID:[self LoggedId];
    MatchLbl.font=[UIFont fontWithName:MYRIARDPROSAMIBOLT size:18.0f];
    course2lbl.font=[UIFont fontWithName:MYRIARDPROLIGHT size:17.0f];
    Datetimelbl.font=[UIFont fontWithName:MYRIARDPROLIGHT size:15.0f];
    SlopLbl.font=[UIFont fontWithName:MYRIARDPROLIGHT size:21.0f];
    RattingLbl.font=[UIFont fontWithName:MYRIARDPROLIGHT size:21.0f];
    grossScoreLbl.font=[UIFont fontWithName:MYRIARDPROSAMIBOLT size:35.0f];
    GrossScoreTxt.font=[UIFont fontWithName:MYRIARDPROSAMIBOLT size:15.0f];
    
    HanDicapDifperroundLbl.font=[UIFont fontWithName:MYRIARDPROSAMIBOLT size:42.0f];
    HanDicapDifperroundLbl.textColor=[UIColor whiteColor];
    ttthanDicapDetaisLbl.font=[UIFont fontWithName:MYRIARDPROSAMIBOLT size:42.0f];
    [SVProgressHUD showWithStatus:@"please Wait...."];
    if (!IsIphone5)
    {
        self.HanDicapBackScroll.contentSize=CGSizeMake(320, 500);
    }
    
    NSInvocationOperation *opetaionfor=[[NSInvocationOperation alloc]initWithTarget:self selector:@selector(LoadAlldata) object:Nil];
    [MymainOperation addOperation:opetaionfor];
    
    
    
    
    
    
}

-(void)LoadAlldata
{
    NSString *StringUrl=[NSString stringWithFormat:@"%@user.php?mode=handicapdetails&eventid=%@&userid=%@",API,matchEventId,ViewID];
    
    NSLog(@"The handicapDetails:%@",StringUrl);
    
    NSData *data=[NSData dataWithContentsOfURL:[NSURL URLWithString:StringUrl]];
    NSDictionary *mainDic=[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    NSDictionary *HanDicapDic=[mainDic valueForKey:@"handicapdetails"];
    [MutDicForhanDicap setValue:[HanDicapDic valueForKey:@"MatchId"] forKey:@"MatchId"];
    [MutDicForhanDicap setValue:[HanDicapDic valueForKey:@"MatchName"] forKey:@"MatchName"];
    [MutDicForhanDicap setValue:[HanDicapDic valueForKey:@"CourseName"] forKey:@"CourseName"];
    [MutDicForhanDicap setValue:[HanDicapDic valueForKey:@"Matchdate"] forKey:@"Matchdate"];
    [MutDicForhanDicap setValue:[HanDicapDic valueForKey:@"Tees"] forKey:@"Tees"];
    [MutDicForhanDicap setValue:[HanDicapDic valueForKey:@"Slope"] forKey:@"Slope"];
    [MutDicForhanDicap setValue:[HanDicapDic valueForKey:@"Rating"] forKey:@"Rating"];
    [MutDicForhanDicap setValue:[HanDicapDic valueForKey:@"Gross_score"] forKey:@"Gross_score"];
    [MutDicForhanDicap setValue:[HanDicapDic valueForKey:@"Net_score"] forKey:@"Net_score"];
    [MutDicForhanDicap setValue:[HanDicapDic valueForKey:@"TttHandicapIndex"] forKey:@"TttHandicapIndex"];
    [MutDicForhanDicap setValue:[HanDicapDic valueForKey:@"Handicapdifferential"] forKey:@"Handicapdifferential"];
    
    [self performSelectorOnMainThread:@selector(Reloaddata) withObject:nil waitUntilDone:YES];
    
    
}
-(void)Reloaddata
{
    [SVProgressHUD dismiss];
    MatchLbl.text=[MutDicForhanDicap valueForKey:@"MatchName"];
    MatchLbl.textColor=[UIColor whiteColor];
    Datetimelbl.text=[MutDicForhanDicap valueForKey:@"Matchdate"];
    Datetimelbl.textColor=[UIColor whiteColor];
    course2lbl.text=[MutDicForhanDicap valueForKey:@"CourseName"];
    course2lbl.textColor=[UIColor whiteColor];
    NSAttributedString *attributedText =
    [[NSAttributedString alloc]
     initWithString:[self RemoveNullandreplaceWithSpace:[MutDicForhanDicap valueForKey:@"CourseName"]]
     attributes:@
     {
     NSFontAttributeName:[UIFont fontWithName:MYRIARDPROLIGHT size:16.0f]
     }];
    
    CGRect rect = [attributedText boundingRectWithSize:(CGSize){200, 21}
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                               context:nil];
    CGSize size = rect.size;
    
    course2lbl.frame=CGRectMake((290-size.width)/2, course2lbl.frame.origin.y, size.width+30, course2lbl.frame.size.height);
    SlopLbl.text=[MutDicForhanDicap valueForKey:@"Slope"];
    SlopLbl.textColor=[UIColor whiteColor];
    RattingLbl.text=[MutDicForhanDicap valueForKey:@"Rating"];
    RattingLbl.textColor=[UIColor whiteColor];
    grossScoreLbl.text=[MutDicForhanDicap valueForKey:@"Gross_score"];
    grossScoreLbl.textColor=[UIColor orangeColor];
    ttthanDicapDetaisLbl.textColor=[UIColor whiteColor];
    ttthanDicapDetaisLbl.text=[MutDicForhanDicap valueForKey:@"TttHandicapIndex"];
    HanDicapDifperroundLbl.textColor=[UIColor whiteColor];
    HanDicapDifperroundLbl.text=[MutDicForhanDicap valueForKey:@"Handicapdifferential"];
    
    [self setRoundBorderToUiview:_Roundbackview];
    [_Roundbackview setBackgroundColor:[TTTGlobalMethods colorFromHexString:[MutDicForhanDicap valueForKey:@"Tees"]]];
    [_Roundbackview setFrame:CGRectMake(course2lbl.frame.origin.x+course2lbl.frame.size.width+5, _Roundbackview.frame.origin.y, _Roundbackview.frame.size.width, _Roundbackview.frame.size.height)];
    
    
}

-(void)viewDidDisappear:(BOOL)animated
{
    [MymainOperation cancelAllOperations];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)GoesToScorecardDetis:(id)sender
{
    TTTScoreBord *ScoreBord=[[TTTScoreBord alloc]init];
    ScoreBord.matchID=[MutDicForhanDicap valueForKey:@"MatchId"];
    ScoreBord.paramId=paramviewID;
    [self PushViewController:ScoreBord TransitationFrom:kCATransitionFade];
    
}


@end
