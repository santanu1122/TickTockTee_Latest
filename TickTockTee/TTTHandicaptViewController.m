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
#import "SVProgressHUD.h"
#import "TTTroundlistViewController.h"
@interface TTTHandicaptViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    int i;
    NSMutableArray *arrayContent;
    BOOL isopened;
    NSString *ViewID;
     BOOL IsLeftMenuBoxOpen,isFastLocation,islastlocation,IsChatMenuBoxOpen;
    BOOL isScroll,isLoadMode,IfMoreDataAvalable;
    UIActivityIndicatorView *progress;
    UIView *viewonfooter;
    NSInteger numborofarray;
    NSOperationQueue *OperationQ;
    NSString *lastID;
    NSString *profile,*activesince;
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
     _page_title.text=@"Handicap Details";
    _page_title.font = [UIFont fontWithName:@"MyriadPro-regular" size:19.0];
    OperationQ=[[NSOperationQueue alloc]init];
    arrayContent = [[NSMutableArray alloc] init];
    lastID=@"0";
    IfMoreDataAvalable=TRUE;
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
    [_handcaplist setFrame:CGRectMake(0, _nameview.layer.frame.size.height+_nameview.layer.frame.origin.y,_handcaplist.layer.frame.size.width, _handcaplist.layer.frame.size.height)];
    _handcaplist.backgroundColor=[UIColor clearColor];
    [_ScreenView addSubview:_handcaplist];
    [self.view addSubview:_dropDownView1];
    [_handcaplist setDelegate:self];
    [_handcaplist setDataSource:self];
    [_handcaplist setHidden:YES];
   // [_ScreenView bringSubviewToFront:_handcaplist];
    
    _dropDownView1.hidden=YES;
    [SVProgressHUD show];
    [self Domywork];
}


-(void)Domywork

{
    
    NSInvocationOperation *operation=[[NSInvocationOperation alloc]initWithTarget:self selector:@selector(getTheData:) object:lastID];
    
    [OperationQ addOperation:operation];
    
}


-(void)viewDidAppear:(BOOL)animated{
    isopened=NO;
    
    [super viewDidAppear:YES];
   
    
    
    
    
}
-(void)getTheData:(NSString *)lastidforloadmore

{
    NSError *error=nil;
    
    @try{
        
        if ([self isConnectedToInternet])
            
        {
            
            NSString *stringurl = [NSString stringWithFormat:@"%@user.php?mode=handicaplist&userid=%@&loggedin_userid=%@&lastid=%@", API,ViewID,[self LoggedId],lastidforloadmore];
            
            
            
            NSLog(@"urlllllllllll %@", stringurl);
            
            NSURL *requestURL2 = [NSURL URLWithString:stringurl];
            
            NSData *signeddataURL2 =  [NSData dataWithContentsOfURL:requestURL2 options:NSDataReadingUncached error:&error];
            
            NSMutableDictionary *Output = [NSJSONSerialization
                                           
                                           JSONObjectWithData:signeddataURL2
                                           
                                           
                                           
                                           options:kNilOptions
                                           
                                           error:&error];
            
            
            
            
            
            if ([[Output valueForKey:@"extraparam"] isKindOfClass:[NSDictionary class]])
                
            {
                
                NSDictionary *Extraparam=[Output valueForKey:@"extraparam"];
                
                NSString *loadMoredata=[Extraparam valueForKey:@"moredata"];
                
                if ([loadMoredata integerValue]==0)
                    
                {
                    
                    IfMoreDataAvalable=FALSE;
                    
                }
                
                lastID=[Extraparam valueForKey:@"lastid"];
                
            }
            
            
            
            profile=[Output valueForKey:@"Profile"];
            
            activesince=[Output valueForKey:@"Activesince"];
            
            if ([[Output objectForKey:@"handicaplist"] isKindOfClass:[NSArray class]])
                
            {
                
                NSArray *arr=[Output objectForKey:@"handicaplist"];
                
                if ([arr count]>0)
                    
                {
                    
                    for(NSMutableDictionary *loop in arr)
                        
                    {
                        NSMutableDictionary *dicForAll = [[NSMutableDictionary alloc]init];
                        
                        [dicForAll setValue:[self RemoveNullandreplaceWithSpace:[loop objectForKey:@"MatchId"]] forKey:@"MatchId"];
                        
                        [dicForAll setValue:[self RemoveNullandreplaceWithSpace:[loop objectForKey:@"MatchName"]] forKey:@"MatchName"];
                        
                        [dicForAll setValue:[self RemoveNullandreplaceWithSpace:[loop objectForKey:@"Location"]] forKey:@"Location"];
                        
                        [dicForAll setValue:[self RemoveNullandreplaceWithSpace:[loop objectForKey:@"CourseName"]] forKey:@"CourseName"];
                        
                        [dicForAll setValue:[self RemoveNullandreplaceWithSpace:[loop objectForKey:@"Matchdate"]] forKey:@"Matchdate"];
                        
                        [dicForAll setValue:[self RemoveNullandreplaceWithSpace:[loop objectForKey:@"TttHandicapIndex"]] forKey:@"TttHandicapIndex"];
                        
                         [arrayContent addObject:dicForAll];
                        
                        
                        
                        if(isLoadMode==TRUE){
                            [self performSelectorOnMainThread:@selector(inserthandicaplistintotable) withObject:nil waitUntilDone:YES];
                        }
                    }
                    
                    if(isLoadMode==FALSE){
                        [self performSelectorOnMainThread:@selector(ReloadTable) withObject:nil waitUntilDone:YES];
                    }
                    
                    
                    
                    
                }
                
                else
                    
                {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        
                        [SVProgressHUD dismiss];
                        
                        [SVProgressHUD showErrorWithStatus:@"No handicap list found"];
                        
                    });
                    
                }
                
            }
            
            else
                
            {
                
                dispatch_async(dispatch_get_main_queue(), ^(void)
                               
                               {
                                   
                                   [SVProgressHUD dismiss];
                                   
                                   [SVProgressHUD showErrorWithStatus:@"Unexpected error occur."];
                                   
                               });
                
            }
            
            
        }
        
        else
            
        {
            
            dispatch_async(dispatch_get_main_queue(), ^(void)
                           
                           {
                               
                               [SVProgressHUD dismiss];
                               
                               [SVProgressHUD showErrorWithStatus:@"No internet connection available!"];
                               
                               [[self view] setUserInteractionEnabled:YES];
                               
                           });
            
        }
        
        
        
        
        
    }@catch (NSException *exception)
    
    {
        
        
        
        NSLog(@"Reporting exception from handicap details : %@", exception);
        
    }
    
    
    
}



-(void)ReloadTable

{
  
    _statistics.text=[[NSString stringWithFormat:@"%@'S STATISTICS",profile] uppercaseString];
    
    _datestatics.text=[NSString stringWithFormat:@"Since %@",activesince];
    
    _statistics.font = [UIFont fontWithName:MYRIARDPROSAMIBOLT size:16.0];
    
    _datestatics.font = [UIFont fontWithName:MYRIARDPROLIGHT size:14.0];
    
    [SVProgressHUD dismiss];
    [_handcaplist setHidden:NO];
    [_handcaplist reloadData];
    
}


-(void)inserthandicaplistintotable
{
    numborofarray=[arrayContent count]-1;
  
    [_handcaplist beginUpdates];
    NSIndexPath *Indexpath=[NSIndexPath indexPathForRow:numborofarray inSection:0];
    [_handcaplist insertRowsAtIndexPaths:[[NSArray alloc] initWithObjects:Indexpath, nil] withRowAnimation:UITableViewRowAnimationFade];
    [_handcaplist endUpdates];
    [SVProgressHUD dismiss];
    [progress stopAnimating];
    [progress hidesWhenStopped];
    [viewonfooter removeFromSuperview];
    [self footer];
    isScroll=FALSE;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  
    return [arrayContent count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 78;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    
    NSMutableDictionary *dict=[arrayContent objectAtIndex:indexPath.row];
    
  
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
    label1.text=[[dict objectForKey:@"MatchName"]uppercaseString];
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
   // [self PerformGoBack];
    int index;
    NSArray* arr = [[NSArray alloc] initWithArray:self.navigationController.viewControllers];
    for(int j=0 ; j<[arr count] ; j++)
    {
        if(![[arr objectAtIndex:j] isKindOfClass:NSClassFromString(@"TTTHandicaptViewController")])
            
        {
            index = j;
        }
    }
    [self.navigationController popToViewController:[arr objectAtIndex:index] animated:YES];

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
                    
                    [UIView animateWithDuration:0.3f animations:^{
                        _ScreenView.frame=frame;
                        
                    }];
                    
                }
                else
                {
                   
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
               
                
                if (stopLocation.x*-1>60.0f)
                {
                    isFastLocation=FALSE;
                    
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
                    
                   
                    [UIView animateWithDuration:.2 animations:^{
                        _ScreenView.frame=frame;
                        
                    }];
                    
                }
                else
                {
                    
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
                
                CGRect framelast=[_ScreenView frame];
                framelast.origin.x=0;
                
                
                [UIView animateWithDuration:.6 animations:^{
                    _ScreenView.frame=framelast;
                    
                }];
            }
            
            if (stopLocation.x*-1<100.0f&isFastLocation==TRUE&IsLeftMenuBoxOpen==YES)
            {
                
                
                CGRect framelast=[_ScreenView frame];
                framelast.origin.x=260;
                
                
                [UIView animateWithDuration:.6 animations:^{
                    _ScreenView.frame=framelast;
                    
                }];
                
            }
            
            
        }
        
    }
    
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView

{
    
    CGPoint offset = scrollView.contentOffset;
    
    CGRect bounds = scrollView.bounds;
    
    CGSize size = scrollView.contentSize;
    
    UIEdgeInsets inset = scrollView.contentInset;
    
    float y = offset.y + bounds.size.height - inset.bottom;
    
    float h = size.height;
    
    float reload_distance = -60.0f;
    
    if(y > h + reload_distance)
        
    {
        if (IfMoreDataAvalable==TRUE && isScroll==FALSE)
            
        {
            isLoadMode=TRUE;
            isScroll=TRUE;
            [self Load];
            NSInvocationOperation *operation=[[NSInvocationOperation alloc]initWithTarget:self selector:@selector(getTheData:) object:lastID];
            [OperationQ addOperation:operation];
        }
        
    }
    
}

-(void)Load{
    viewonfooter = [[UIView alloc] initWithFrame:CGRectMake(0,_handcaplist.frame.size.height, 320, 30)];
    viewonfooter.backgroundColor=[UIColor clearColor];
    progress= [[UIActivityIndicatorView alloc] initWithFrame: CGRectMake(150,10, 20, 20)];
    progress.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    [viewonfooter addSubview:progress];
    [progress startAnimating];
    _handcaplist.tableFooterView= viewonfooter;
}
-(void)footer{
    viewonfooter = [[UIView alloc] initWithFrame:CGRectMake(0,_handcaplist.frame.size.height, 320, 0)];
    viewonfooter.backgroundColor=[UIColor clearColor];
    _handcaplist.tableFooterView= viewonfooter;
}




-(void)PerformChatSliderOperation
{
    
    IsChatMenuBoxOpen=[self PerformChatSlider:_ScreenView withChatArea:self.chatBoxView IsOpen:IsChatMenuBoxOpen];
  
    
}

@end
