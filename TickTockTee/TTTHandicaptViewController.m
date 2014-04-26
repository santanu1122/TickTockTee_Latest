//
//  TTTHandicaptViewController.m
//  TickTockTee
//
//  Created by Esolz_Mac on 24/03/14.
//  Copyright (c) 2014 com.esolz.TickTockTee. All rights reserved.
//

#import "TTTHandicaptViewController.h"
#import "TTTAchievementDetailsViewController.h"
#import "TTTStatisticsViewController.h"
#import "TTTHandicaptViewController.h"
#import "TTTAchievementStatisticViewController.h"
#import "TTTHandicapDetails.h"
#import "TTTroundlistViewController.h"
@interface TTTHandicaptViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    int i;
    NSMutableArray *arrayContent;
    BOOL isopened;
    NSString *ViewID;
     BOOL IsLeftMenuBoxOpen,isFastLocation,islastlocation,IsChatMenuBoxOpen;
}
@property (strong, nonatomic) IBOutlet UIButton *overviewbtn;
@property (strong, nonatomic) IBOutlet UIButton *achievementbtn;
@property (strong, nonatomic) IBOutlet UIButton *rounddetailbtn;
@property (strong, nonatomic) IBOutlet UIButton *handicapdetailbtn;
@property (strong, nonatomic) IBOutlet UIView *chatBoxView;

@end

@implementation TTTHandicaptViewController
@synthesize ScreenView=_ScreenView;
@synthesize handcaplist=_handcaplist;
@synthesize footerView=_footerView;
@synthesize MenuBarView=_MenuBarView;
@synthesize nameview=_nameview;
@synthesize page_title=_page_title;
@synthesize statistics=_statistics;
@synthesize datestatics=_datestatics;
@synthesize avtivity=_avtivity;
@synthesize dropDownView1=_dropDownView1;
@synthesize paramviewID;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
        self=(IsIphone5)?[super initWithNibName:@"TTTHandicaptViewController" bundle:nil]:[super initWithNibName:@"TTTHandicaptViewController_iPhone4" bundle:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    arrayContent=[[NSMutableArray alloc]init];
    
    // Do any additional setup after loading the view from its nib.
    [_footerView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bottom-bar2"]]];
    
    ViewID=(paramviewID.length>0)?paramviewID:[self LoggedId];
    
    
    
    
    (!IsIphone5)?[_footerView setFrame:CGRectMake(0, (480 - _footerView.frame.size.height), _footerView.frame.size.width, _footerView.frame.size.height)]:[_footerView setFrame:CGRectMake(0, (568 - _footerView.frame.size.height), _footerView.frame.size.width, _footerView.frame.size.height)];
    [self.view bringSubviewToFront:_footerView];
    [self AddNavigationBarTo:_footerView withSelected:@""];
    [self.ScreenView addSubview:_footerView];
    
    if (IsIphone5)
    {
        [_nameview setFrame:CGRectMake(0, 64,_nameview.layer.frame.size.width, _nameview.layer.frame.size.height)];
    }else
    {
        [_nameview setFrame:CGRectMake(0, 57,_nameview.layer.frame.size.width, _nameview.layer.frame.size.height)];
    }
    
    [_ScreenView addSubview:_nameview];
    [_handcaplist setFrame:CGRectMake(0, _nameview.layer.frame.size.height+_nameview.layer.frame.origin.y,_handcaplist.layer.frame.size.width, _handcaplist.layer.frame.size.height+10)];
    _handcaplist.backgroundColor=[UIColor clearColor];
    [_ScreenView addSubview:_handcaplist];
    [self.view addSubview:_dropDownView1];
    _dropDownView1.hidden=YES;
}
-(void)viewDidAppear:(BOOL)animated{
    isopened=NO;
    
    [super viewDidAppear:YES];
    _page_title.text=@"Handicap Details";
    [self getTheData];
    
    
    
}
-(void)getTheData
{
    i=0;
    if ([self isConnectedToInternet])
    {
        __block NSString *str_url=[NSString stringWithFormat:@"%@user.php?mode=handicaplist&userid=%@&loggedin_userid=%@",API,ViewID,[self LoggedId]];
        
        NSLog(@"str_url ----- %@",str_url);
        
        NSURL *fire_url=[NSURL URLWithString:str_url];
        
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
            NSError *err=nil;
            NSData* data = [NSData dataWithContentsOfURL:fire_url options:0 error:&err];
            
            
            dispatch_async(dispatch_get_main_queue(), ^(void)
            {
                
                
                
                
                NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data  options:kNilOptions error:nil];
                
                arrayContent = [[NSMutableArray alloc] init];
                
                
                _statistics.font=[UIFont fontWithName:MYRIARDPROSAMIBOLT size:16];
                _datestatics.font=[UIFont fontWithName:MYRIARDPROLIGHT size:14];
                [_statistics setText:[NSString stringWithFormat:@"%@'s statistics",[dict objectForKey:@"Profile"]]];
                [_datestatics setText:[NSString stringWithFormat:@"Since %@",[dict objectForKey:@"Activesince"]]];
                
                
                
                
                
                if ([[dict objectForKey:@"handicaplist"] count] > 0)
                {
                    
                    for (NSDictionary *Datadic in [dict objectForKey:@"handicaplist"]) {
                        
                        NSLog(@"Datadic --- %@",Datadic);
                        
                        [arrayContent insertObject:Datadic atIndex:i];
                        i++;
                        
                    }
                    [_avtivity stopAnimating];
                    
                    [_handcaplist setDelegate:self];
                    [_handcaplist setDataSource:self];
                    [_ScreenView bringSubviewToFront:_handcaplist];
                    [_handcaplist reloadData];
                }
                else
                {
                    [_avtivity stopAnimating];
                }
                
                
            });
        });

    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD showErrorWithStatus:@"No internet connection"];
            
        });
    }
    
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"TableView count in handicapp count = %d",[arrayContent count]);
    return [arrayContent count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 78;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    
    NSMutableDictionary *dict=[arrayContent objectAtIndex:indexPath.row];
    
    
    NSLog(@"Values are %@ %@ %@ %@ ",[dict objectForKey:@"MatchName"],[dict objectForKey:@"Location"],[dict objectForKey:@"Matchdate"],[dict objectForKey:@"TttHandicapIndex"]);
    [tableView dequeueReusableCellWithIdentifier:@"PhotoCustomCell"];
    
    if(cell==nil)
    {
        NSArray *nibViews=[[NSBundle mainBundle]loadNibNamed:@"TTTCellForHandcap" owner:self options:nil];
        cell=[nibViews objectAtIndex:0];
    }
    UILabel *label1=(UILabel *)[cell.contentView viewWithTag:99];
    UILabel *label2=(UILabel *)[cell.contentView viewWithTag:98];
    UILabel *label3=(UILabel *)[cell.contentView viewWithTag:97];
    UILabel *label4=(UILabel *)[cell.contentView viewWithTag:96];
    label1.font=[UIFont fontWithName:MYRIARDPROSAMIBOLT size:15];
    label2.font=[UIFont fontWithName:MYRIARDPROLIGHT size:15];
    label3.font=[UIFont fontWithName:MYRIARDPROLIGHT size:13];
    label4.font=[UIFont fontWithName:MYREADPROREGULAR size:24];
    label1.text=[dict objectForKey:@"MatchName"];
    label2.text=[dict objectForKey:@"Location"];
    label3.text=[dict objectForKey:@"Matchdate"];
    label4.text=[dict objectForKey:@"TttHandicapIndex"];
    cell.contentView.backgroundColor=[UIColor clearColor];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
     cell.selectionStyle=UITableViewCellSelectionStyleNone;
    NSMutableDictionary *dict=[arrayContent objectAtIndex:indexPath.row];
    TTTHandicapDetails *handicap=[[TTTHandicapDetails alloc]initWithNibName:@"TTTHandicapDetails" bundle:nil];
    handicap.matchEventId=[dict valueForKey:@"MatchId"];
    handicap.paramviewID=paramviewID;
    [self PushViewController:handicap TransitationFrom:kCATransitionFade];
}


//-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//}



- (IBAction)backButtonClick:(id)sender {
    [self PerformGoBack];
}
- (IBAction)menuChanged:(id)sender {
    if(isopened==NO){
        
        [UIView animateWithDuration:.3 animations:^{
            _dropDownView1.frame=CGRectMake(0, 60, 320, 220);
            
            //_dropDownView1.frame=CGRectMake();
            
        }
                         completion:^(BOOL finished)
         {
             [UIView animateWithDuration:3
                                   delay:.25
                                 options:UIViewAnimationOptionCurveEaseIn
                              animations:^{
                                  isopened=YES;
                                  _overviewbtn.hidden=NO;
                                  _achievementbtn.hidden=NO;
                                  _rounddetailbtn.hidden=NO;
                                  _handicapdetailbtn.hidden=NO;
                                  _dropDownView1.hidden=NO;
                                  _page_title.text=@"Handicap Details";
                              }
                              completion:nil];
             
             
             
         }];
    }
    else{
        [UIView animateWithDuration:3
                              delay:.25
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             isopened=NO;
                             _overviewbtn.hidden=YES;
                             _achievementbtn.hidden=YES;
                             _rounddetailbtn.hidden=YES;
                             _handicapdetailbtn.hidden=YES;
                             _dropDownView1.hidden=YES;
                             
                             _page_title.text=@"Handicap Details";
                         }
                         completion:nil];
        
    }
    
    
}
- (IBAction)overviewfunc:(id)sender {
    [UIView animateWithDuration:3
                          delay:.25
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         isopened=NO;
                         _overviewbtn.hidden=YES;
                         _achievementbtn.hidden=YES;
                         _rounddetailbtn.hidden=YES;
                         _handicapdetailbtn.hidden=YES;
                         _dropDownView1.hidden=YES;
                         
                         
                         // _page_title.text=@"Overview";
                     }
                     completion:nil];
    
    TTTStatisticsViewController *statistic=[[TTTStatisticsViewController alloc]init];
    statistic.paramviewID=paramviewID;
    [self PushViewController:statistic TransitationFrom:kCATransitionFade];
    
}
- (IBAction)achievementunc:(id)sender {
    [UIView animateWithDuration:3
                          delay:.25
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         isopened=NO;
                         _overviewbtn.hidden=YES;
                         _achievementbtn.hidden=YES;
                         _rounddetailbtn.hidden=YES;
                         _handicapdetailbtn.hidden=YES;
                         _dropDownView1.hidden=YES;
                         
                         
                         // _page_title.text=@"Achievement Details";
                         TTTAchievementStatisticViewController *ScrobordView=[[TTTAchievementStatisticViewController alloc]init];
                         ScrobordView.ParamViewid=paramviewID;
                         [self PushViewController:ScrobordView TransitationFrom:kCATransitionFade];
                     }
                     completion:nil];
    
    
}

- (IBAction)roundfunc:(id)sender {
    [UIView animateWithDuration:3
                          delay:.25
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         isopened=NO;
                         _overviewbtn.hidden=YES;
                         _achievementbtn.hidden=YES;
                         _rounddetailbtn.hidden=YES;
                         _handicapdetailbtn.hidden=YES;
                         _dropDownView1.hidden=YES;
                         
                         //_page_title.text=@"Round Details";
                     }
                     completion:nil];
    TTTroundlistViewController *roudList=[[TTTroundlistViewController alloc]init];
    roudList.paramviewID=paramviewID;
    [self PushViewController:roudList TransitationFrom:kCATransitionFade];
    
}
- (IBAction)handicapfunc:(id)sender {
    [UIView animateWithDuration:3
                          delay:.25
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         isopened=NO;
                         _overviewbtn.hidden=YES;
                         _achievementbtn.hidden=YES;
                         _rounddetailbtn.hidden=YES;
                         _handicapdetailbtn.hidden=YES;
                         _dropDownView1.hidden=YES;
                         
                         _page_title.text=@"Handicap Details";
                     }
                     completion:nil];
    TTTHandicaptViewController *handicap=[[TTTHandicaptViewController alloc]init];
    handicap.paramviewID=paramviewID;
    [self PushViewController:handicap TransitationFrom:kCATransitionFade];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)panDetected:(UIPanGestureRecognizer *)panRecognizer
{
    
    CGPoint  stopLocation;
    
    if(IsChatMenuBoxOpen==NO){
        
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
    
    IsChatMenuBoxOpen=[self PerformChatSlider:_ScreenView withChatArea:self.chatBoxView IsOpen:IsChatMenuBoxOpen];
    NSLog(@"PerformChatSliderOperation %@",IsChatMenuBoxOpen?@"YES":@"NO");
    
}

@end
