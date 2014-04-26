//
//  TTTRounddetailsViewController.m
//  TickTockTee
//
//  Created by Esolz_Mac on 25/03/14.
//  Copyright (c) 2014 com.esolz.TickTockTee. All rights reserved.
//

#import "TTTRounddetailsViewController.h"
#import "SVProgressHUD.h"
#import "TTTScoreBord.h"

@interface TTTRounddetailsViewController (){
    NSOperationQueue *OperationQ;
    NSArray * firstrowList,*secondrowlist;
    NSString *ViewID;
}
@property (strong, nonatomic) IBOutlet UILabel *SlopVal;
@property (strong, nonatomic) IBOutlet UILabel *RattiongVal;

@end

@implementation TTTRounddetailsViewController
@synthesize ScreenView=_ScreenView;
@synthesize scrollView=_scrollView;
@synthesize dataview=_dataview;
@synthesize footerView=_footerView;
@synthesize Spinner=_Spinner;
@synthesize eventid,userid;
@synthesize back=_back;
@synthesize detailsview=_detailsview;
@synthesize dropdown=_dropdown;
@synthesize page_title=_page_title;
@synthesize matchtitle=_matchtitle;
@synthesize datetitle=_datetitle;
@synthesize paramviewID;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self=(IsIphone5)?[super initWithNibName:@"TTTRounddetailsViewController" bundle:nil]:[super initWithNibName:@"TTTRounddetailsViewController_iPhone4" bundle:nil];
        
    }
    return self;
}
- (IBAction)GeestoScorecard:(id)sender
{
    TTTScoreBord *Scorebord=[[TTTScoreBord alloc]init];
    Scorebord.matchID=[dicForAll valueForKey:@"eventid"];
    Scorebord.paramId=ViewID;
    [self PushViewController:Scorebord TransitationFrom:kCATransitionFade];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _page_title.font = [UIFont fontWithName:@"MyriadPro-regular" size:19.0];
    
    ViewID=(paramviewID.length>0)?paramviewID:[self LoggedId];
    
    
    OperationQ=[[NSOperationQueue alloc]init];
    
    
    (!IsIphone5)?[_footerView setFrame:CGRectMake(0, (480 - _footerView.frame.size.height), _footerView.frame.size.width, _footerView.frame.size.height)]:[_footerView setFrame:CGRectMake(0, (568 - _footerView.frame.size.height), _footerView.frame.size.width, _footerView.frame.size.height)];
    //  [self.view bringSubviewToFront:_footerView];
    
    [self.ScreenView addSubview:_footerView];
    
    // _scrollView.contentSize = CGSizeMake(320,600);
    if (!IsIphone5)
        
    {
        _scrollView.contentSize = CGSizeMake(320,500-25);
    }
    
    
    [_detailsview setFrame:CGRectMake(0, 0,_detailsview.layer.frame.size.width, _detailsview.layer.frame.size.height)];
    
    [_scrollView addSubview:_detailsview];
    _detailsview.hidden=YES;
    [_dataview setFrame:CGRectMake(0, _detailsview.layer.frame.size.height+_detailsview.layer.frame.origin.y,_dataview.layer.frame.size.width,_dataview.layer.frame.size.height)];
    _dataview.backgroundColor=[UIColor clearColor];
    [_scrollView addSubview:_dataview];
    
    _dataview.hidden=YES;
    
    [SVProgressHUD showWithStatus:@"Please wait..."];
    NSInvocationOperation *LoadroundDetais=[[NSInvocationOperation alloc]initWithTarget:self selector:@selector(LoadRounddetais) object:nil];
    [OperationQ addOperation:LoadroundDetais];
    
    
    
}


-(void)LoadRounddetais
{
    NSString *stringurl = [NSString stringWithFormat:@"%@user.php?mode=rounddetails&userid=%@&loggedin_userid=%@&eventid=%@", API,ViewID,[self LoggedId],eventid];
    NSLog(@"The round Ditais Arry:%@",stringurl);
    NSURL *url = [NSURL URLWithString:stringurl];
    NSData *Detaisdata=[NSData dataWithContentsOfURL:url];
    NSDictionary *Output = [NSJSONSerialization JSONObjectWithData:Detaisdata options:0 error:Nil];
    NSDictionary *arr=[Output objectForKey:@"rounddetails"];
    
    NSLog(@"arr %@",arr);
    
    if ([arr count]>0)
    {
        
        
        
        NSString *eventid1 = [arr valueForKey:@"eventid"];
        
        NSString *matchtitle = [arr valueForKey:@"matchtitle"];
        
        NSString *CourseName = [arr valueForKey:@"CourseName"];
        
        
        
        
        NSString *NetScore = [arr valueForKey:@"NetScore"];
        NSString *MatchCreated = [arr valueForKey:@"MatchCreated"];
        NSString *Tees=[arr valueForKey:@"Tees"];
        
        NSString *Slop=[arr valueForKey:@"Slope"];
        
        NSString *Rating=[arr objectForKey:@"Rating"];
        
        
        NSString *GrossScore = [NSString stringWithFormat:@"%@",[arr valueForKey:@"GrossScore"]];
        NSString *Eagles = [NSString stringWithFormat:@"%@",[arr valueForKey:@"Eagles"]];
        NSString *BirdiesOrBetter = [NSString stringWithFormat:@"%@",[arr valueForKey:@"BirdiesOrBetter"]];
        NSString *Pars = [NSString stringWithFormat:@"%@",[arr valueForKey:@"Pars"]];
        NSString *Bogeys = [NSString stringWithFormat:@"%@",[arr valueForKey:@"Bogeys"]];
        NSString *Doubles = [NSString stringWithFormat:@"%@",[arr valueForKey:@"Doubles"]];
        NSString *Other = [NSString stringWithFormat:@"%@",[arr valueForKey:@"Other"]];
        
        dicForAll =[[NSMutableDictionary alloc]init];
        
        [dicForAll setValue:eventid1 forKey:@"eventid"];
        [dicForAll setValue:matchtitle forKey:@"matchtitle"];
        [dicForAll setValue:CourseName forKey:@"CourseName"];
        [dicForAll setValue:NetScore forKey:@"NetScore"];
        [dicForAll setValue:MatchCreated forKey:@"MatchCreated"];
        [dicForAll setValue:Tees forKey:@"Tees"];
        [dicForAll setValue:Slop forKey:@"Slop"];
        [dicForAll setValue:Rating forKey:@"Rating"];
        
        [dicForAll setValue:GrossScore forKey:@"GrossScore"];
        [dicForAll setValue:Eagles forKey:@"Eagles"];
        [dicForAll setValue:BirdiesOrBetter forKey:@"BirdiesOrBetter"];
        [dicForAll setValue:Pars forKey:@"Pars"];
        [dicForAll setValue:Bogeys forKey:@"Bogeys"];
        [dicForAll setValue:Doubles forKey:@"Doubles"];
        [dicForAll setValue:Other forKey:@"Other"];
        
        
        
        
        [self performSelectorOnMainThread:@selector(Reloaddata) withObject:nil waitUntilDone:YES];
        
    }
    
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [_Spinner startAnimating];
    //  isDropDownOpen=NO;
    //  _dropDownMenus.hidden=YES;
}

-(void)viewDidDisappear:(BOOL)animated
{
    [OperationQ cancelAllOperations];
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [details_data setLength:0];
    
}


-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [details_data appendData:data];
    
}


-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"Error ocur----");
    
}


-(void)Reloaddata
{
    
    [SVProgressHUD dismiss];
    [_detailsview setHidden:NO];
    [ _dataview setHidden:NO];
    _matchtitle.text=[dicForAll objectForKey:@"matchtitle"];
    _datetitle.text=[dicForAll objectForKey:@"MatchCreated"];
    _matchtitle.font = [UIFont fontWithName:MYRIARDPROSAMIBOLT size:18.0];
    _datetitle.font = [UIFont fontWithName:SEGIOUI size:15.0];
    
    
    self.SlopVal.text=[dicForAll objectForKey:@"Slop"];
    self.SlopVal.font = [UIFont fontWithName:MYRIARDPROLIGHT size:21.0f];
    
    
    self.RattiongVal.text=[dicForAll objectForKey:@"Rating"];
    self.RattiongVal.font = [UIFont fontWithName:MYRIARDPROLIGHT size:21.0];
    
    UILabel *gross_value = (UILabel *)[_detailsview viewWithTag:422];
    gross_value.text=[dicForAll objectForKey:@"GrossScore"];
    gross_value.textColor=UIColorFromRGB(0xfc6f23);
    
    gross_value.font = [UIFont fontWithName:MYRIARDPROSAMIBOLT size:35.0];
    UILabel *gross = (UILabel *)[_detailsview viewWithTag:423];
    gross.text=@"Gross Score";
    gross.font = [UIFont fontWithName:MYRIARDPROSAMIBOLT size:16.0];
    UILabel *course_name = (UILabel *)[_detailsview viewWithTag:420];
    
    course_name.backgroundColor=[UIColor clearColor];
    course_name.font=[UIFont fontWithName:MYRIARDPROLIGHT size:16.0];
    //course_name.textAlignment=NSTextAlignmentLeft;
    course_name.textColor=[UIColor whiteColor];
    course_name.numberOfLines=0;
    
    NSAttributedString *attributedText =
    [[NSAttributedString alloc]
     initWithString:[self RemoveNullandreplaceWithSpace:[dicForAll valueForKey:@"CourseName"]]
     attributes:@
     {
     NSFontAttributeName:[UIFont fontWithName:MYRIARDPROLIGHT size:16.0f]
     }];
    
    CGRect rect = [attributedText boundingRectWithSize:(CGSize){200, 21}
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                               context:nil];
    CGSize size = rect.size;
    
    course_name.frame=CGRectMake((320-size.width)/2, course_name.frame.origin.y, size.width, course_name.frame.size.height);
    
    
    course_name.text=[dicForAll valueForKey:@"CourseName"];
    
    UIView *ScoreView=(UIView *)[_detailsview viewWithTag:421];
    
    [self setRoundBorderToUiview:ScoreView];
    CGRect Frame=[ScoreView frame];
    [ScoreView setBackgroundColor:[TTTGlobalMethods colorFromHexString:[dicForAll valueForKey:@"Tees"]]];
    
    Frame.origin.x=course_name.frame.origin.x+course_name.frame.size.width+10;
    [ScoreView setFrame:Frame];
    
    
    UIView *firstrow= (UIView *) [_dataview viewWithTag:120];
    
    UILabel *eagles= (UILabel *) [firstrow viewWithTag:112];
    eagles.text = @"Eagles";
    eagles.textColor=[UIColor whiteColor];
    eagles.font=[UIFont fontWithName:@"MyriadPro-SemiBold" size:16.0];
    UILabel *eagles_txt= (UILabel *) [firstrow viewWithTag:115];
    eagles_txt.text = [dicForAll objectForKey:@"Eagles"];
    eagles_txt.textColor=[UIColor whiteColor];
    eagles_txt.font=[UIFont fontWithName:@"MyriadPro-SemiBold" size:16.0];
    
    UILabel *BirdiesOrBetter= (UILabel *) [firstrow viewWithTag:113];
    BirdiesOrBetter.text = @"Birdies";
    BirdiesOrBetter.textColor=[UIColor whiteColor];
    BirdiesOrBetter.font=[UIFont fontWithName:MYRIARDPROSAMIBOLT size:16.0];
    UILabel *BirdiesOrBetter_txt= (UILabel *) [firstrow viewWithTag:116];
    BirdiesOrBetter_txt.text = [dicForAll objectForKey:@"BirdiesOrBetter"];
    BirdiesOrBetter_txt.textColor=[UIColor whiteColor];
    BirdiesOrBetter_txt.font=[UIFont fontWithName:@"MyriadPro-SemiBold" size:16.0];
    
    UILabel *Pars= (UILabel *) [firstrow viewWithTag:114];
    Pars.text = @"Pars";
    Pars.textColor=[UIColor whiteColor];
    Pars.font=[UIFont fontWithName:@"MyriadPro-SemiBold" size:16.0];
    UILabel *Pars_txt= (UILabel *) [firstrow viewWithTag:117];
    Pars_txt.text = [dicForAll objectForKey:@"Pars"];
    Pars_txt.textColor=[UIColor whiteColor];
    Pars_txt.font=[UIFont fontWithName:@"MyriadPro-SemiBold" size:16.0];
    
    UIView *secondrow= (UIView *) [_dataview viewWithTag:121];
    
    UILabel *Bogeys= (UILabel *) [secondrow viewWithTag:123];
    Bogeys.text = @"Bogeys";
    Bogeys.textColor=[UIColor whiteColor];
    Bogeys.font=[UIFont fontWithName:MYRIARDPROSAMIBOLT size:16.0f];
    eagles.font=[UIFont fontWithName:@"MyriadPro-SemiBold" size:16.0];
    UILabel *Bogeys_txt= (UILabel *) [secondrow viewWithTag:126];
    Bogeys_txt.text = [dicForAll objectForKey:@"Bogeys"];
    Bogeys_txt.textColor=[UIColor whiteColor];
    Bogeys_txt.font=[UIFont fontWithName:@"MyriadPro-SemiBold" size:16.0];
    
    UILabel *Doubles= (UILabel *) [secondrow viewWithTag:124];
    Doubles.text = @"Doubles";
    Doubles.textColor=[UIColor whiteColor];
    Doubles.font=[UIFont fontWithName:@"MyriadPro-SemiBold" size:16.0];
    UILabel *Doubles_txt= (UILabel *) [secondrow viewWithTag:127];
    Doubles_txt.text = [dicForAll objectForKey:@"Doubles"];
    Doubles_txt.textColor=[UIColor whiteColor];
    Doubles_txt.font=[UIFont fontWithName:@"MyriadPro-SemiBold" size:16.0];
    
    UILabel *Other= (UILabel *) [secondrow viewWithTag:125];
    Other.text = @"Other";
    Pars.textColor=[UIColor whiteColor];
    Other.font=[UIFont fontWithName:@"MyriadPro-SemiBold" size:16.0];
    UILabel *Other_txt= (UILabel *) [secondrow viewWithTag:128];
    Other_txt.text = [dicForAll objectForKey:@"Other"];
    Other_txt.textColor=[UIColor whiteColor];
    Other_txt.font=[UIFont fontWithName:@"MyriadPro-SemiBold" size:16.0];
    
    
    
}
- (IBAction)backButtonClick:(id)sender
{
    [self PerformGoBack];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
