#import "TTTroundlistViewController.h"
#import "TTTCellForRoundlist.h"
#import "SVProgressHUD.h"
#import "TTTHandicaptViewController.h"
#import "TTTRounddetailsViewController.h"
#import "TTTAchievementStatisticViewController.h"
#import "TTTStatisticsViewController.h"
@interface TTTroundlistViewController ()
{
    BOOL IsLeftMenuBoxOpen,Ishoveropen;
    NSString *profile,*activesince;
    NSOperationQueue *OperationQ;
    NSString *user_id,*ViewID;
    BOOL islastlocation;
    BOOL isFastLocation,IfMoreDataAvalable,IsChatMenuBoxOpen;
    NSString *lastID;
    
}
@property (strong, nonatomic) IBOutlet UIView *chatBoxView;
@property (strong, nonatomic) IBOutlet UIImageView *arrowImage;

@end

@implementation TTTroundlistViewController
@synthesize ScreenView=_ScreenView;
@synthesize roundlist=_roundlist;
@synthesize footerView=_footerView;
@synthesize Spinner=_Spinner;
@synthesize MenuBarView=_MenuBarView;
@synthesize menu=_menu;
@synthesize nameview=_nameview;
@synthesize dropdown=_dropdown;
@synthesize page_title=_page_title;
@synthesize profile_label=_profile_label;
@synthesize activesincelabel=_activesincelabel;
@synthesize paramviewID;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self=(IsIphone5)?[super initWithNibName:@"TTTroundlistViewController" bundle:nil]:[super initWithNibName:@"TTTroundlistViewController_iPhone4" bundle:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    roundArray =[[NSMutableArray alloc]init];
    OperationQ=[[NSOperationQueue alloc]init];
    IsLeftMenuBoxOpen=FALSE;
    IfMoreDataAvalable=TRUE;
    lastID=@"0";
    ViewID=(paramviewID.length>0)?paramviewID:[self LoggedId];

    if(paramviewID>0)
    {
        self.menu.hidden=YES;
        self.BackButtonClick.hidden=NO;

       
    }
    else
    {
        self.menu.hidden=NO;
        self.BackButtonClick.hidden=YES;
        islastlocation=TRUE;
        isFastLocation=TRUE;
        UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panDetected:)];
        panRecognizer.delegate=self;
        [self.ScreenView addGestureRecognizer:panRecognizer];
    }
    
    [self AddLeftMenuTo:_MenuBarView];
    _page_title.font = [UIFont fontWithName:@"MyriadPro-regular" size:19.0];
    
    // Do any additional setup after loading the view from its nib.
    [_footerView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bottom-bar2"]]];
    [SVProgressHUD show];
    
    (!IsIphone5)?[_footerView setFrame:CGRectMake(0, (480 - _footerView.frame.size.height), _footerView.frame.size.width, _footerView.frame.size.height)]:[_footerView setFrame:CGRectMake(0, (568 - _footerView.frame.size.height), _footerView.frame.size.width, _footerView.frame.size.height)];
    [self.view bringSubviewToFront:_footerView];
    [self AddNavigationBarTo:_footerView withSelected:@""];
    [self.ScreenView addSubview:_footerView];
    if (IsIphone5)
    {
        [_nameview setFrame:CGRectMake(0, 64,_nameview.layer.frame.size.width, _nameview.layer.frame.size.height)];
    }else{
        [_nameview setFrame:CGRectMake(0, 57,_nameview.layer.frame.size.width, _nameview.layer.frame.size.height)];
    }
    
    
    
    
    [_ScreenView addSubview:_nameview];
    [_roundlist setFrame:CGRectMake(0, _nameview.layer.frame.size.height+_nameview.layer.frame.origin.y,_roundlist.layer.frame.size.width, _roundlist.layer.frame.size.height)];
    _roundlist.backgroundColor=[UIColor clearColor];
    [_ScreenView addSubview:_roundlist];
    _roundlist.delegate=self;
    _roundlist.dataSource=self;
    _roundlist.hidden=YES;
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    self.navigationController.navigationBar.hidden=YES;
    [self.navigationController.navigationBar setBackgroundColor:[UIColor whiteColor]];
    
    [self Domywork];
   }


-(void)Domywork

{
    
    NSInvocationOperation *operation=[[NSInvocationOperation alloc]initWithTarget:self selector:@selector(data_for_table:) object:lastID];
    
    [OperationQ addOperation:operation];
    
}



-(void)data_for_table:(NSString *)lastidforloadmore

{
    
    NSError *error=nil;
    
    @try{
        
        if ([self isConnectedToInternet])
            
        {
            
            NSString *stringurl = [NSString stringWithFormat:@"%@user.php?mode=roundlist&userid=%@&loggedin_userid=%@&lastid=%@", API,ViewID,[self LoggedId],lastidforloadmore];
            
            
            
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
            
            
            
            if ([[Output objectForKey:@"roundlist"] isKindOfClass:[NSArray class]])
                
            {
                
                NSArray *arr=[Output objectForKey:@"roundlist"];
                
                if ([arr count]>0)
                    
                {
                    
                    
                    
                    for(NSMutableDictionary *loop in arr)
                        
                    {
                        
                        
                        
                        NSString *eventid = [loop objectForKey:@"eventid"];
                        
                        NSString *matchtitle = [loop objectForKey:@"matchtitle"];
                        
                        NSString *Location = [loop objectForKey:@"Location"];
                        
                        NSString *CourseName = [loop objectForKey:@"CourseName"];
                        
                        NSString *NetScore = [loop objectForKey:@"NetScore"];
                        
                        NSString *MatchCreated = [loop objectForKey:@"MatchCreated"];
                        
                        
                        
                        NSMutableDictionary *dicForAll = [[NSMutableDictionary alloc]init];
                        
                        
                        
                        
                        
                        [dicForAll setValue:eventid forKey:@"eventid"];
                        
                        [dicForAll setValue:matchtitle forKey:@"matchtitle"];
                        
                        [dicForAll setValue:Location forKey:@"Location"];
                        
                        [dicForAll setValue:CourseName forKey:@"CourseName"];
                        
                        [dicForAll setValue:NetScore forKey:@"NetScore"];
                        
                        [dicForAll setValue:MatchCreated forKey:@"MatchCreated"];
                        
                        
                        
                        
                        
                        [roundArray addObject:dicForAll];
                        
                        
                        
                    }
                    
                    [self performSelectorOnMainThread:@selector(ReloadTable) withObject:nil waitUntilDone:YES];
                    
                    
                    
                }
                
                else
                    
                {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [self.Spinner stopAnimating];
                        
                        [SVProgressHUD dismiss];
                        
                        [SVProgressHUD showErrorWithStatus:@"No Round details Found"];
                        
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
        
        
        
        NSLog(@"Reporting exception from Round details : %@", exception);
        
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
        
        if (IfMoreDataAvalable==TRUE)
            
        {
            NSLog(@"do my job first:");
            [self Domywork];
            
        }
        
        
        
    }
    
}




-(void)viewWillAppear:(BOOL)animated
{
    
    //  isDropDownOpen=NO;
    //  _dropDownMenus.hidden=YES;
}

- (IBAction)dropdown:(id)sender
{
    if (Ishoveropen==FALSE)
    {
        
        self.popupview.frame=CGRectMake(0, 60, 320, 0);
        self.popupview.alpha=0.0000f;
        [_ScreenView addSubview:self.popupview];
        
        [UIView animateWithDuration:0.2f animations:^{
            
            self.popupview.frame=CGRectMake(0, 60, 320, 174+55);
            self.popupview.backgroundColor=UIColorFromRGB(0x9cc6d9);
            self.popupview.alpha=1.0000f;
            
        }
                         completion:^(BOOL finished)
         {
             Ishoveropen=TRUE;
         }];
        self.arrowImage.hidden=YES;
        
    }
    else
    {
        [UIView animateWithDuration:0.2f animations:^{
            self.popupview.frame=CGRectMake(0, 60, 320, 0);
            self.popupview.backgroundColor=UIColorFromRGB(0x9cc6d9);
            self.popupview.alpha=0.0000f;
        }
                         completion:^(BOOL finished)
         {
             
             Ishoveropen=FALSE;
             [self.popupview removeFromSuperview];
         }];
        self.arrowImage.hidden=NO;
    }
    
    
}


- (IBAction)Showoverview:(id)sender
{
    
    NSLog(@"Show over view:");
    
    // [_page_title setText:@"Overview"];
    [UIView animateWithDuration:0.4f animations:^{
        self.popupview.frame=CGRectMake(0, 60, 320, 0);
        self.popupview.alpha=0.0000f;
    }
                     completion:^(BOOL finished)
     {
         Ishoveropen=FALSE;
         [self.popupview removeFromSuperview];
         //[SVProgressHUD show];
     }];
    self.arrowImage.hidden=NO;
    TTTStatisticsViewController *Statistic=[[TTTStatisticsViewController alloc]init];
    Statistic.paramviewID=paramviewID;
    [self PushViewController:Statistic TransitationFrom:kCATransitionFade];
    
}

- (IBAction)Showachievement:(id)sender
{
    //  [_page_title setText:@"Achievement"];
    [UIView animateWithDuration:0.4f animations:^{
        self.popupview.frame=CGRectMake(0, 60, 320, 0);
        self.popupview.alpha=0.0000f;
    }
                     completion:^(BOOL finished)
     {
         
         Ishoveropen=FALSE;
         [self.popupview removeFromSuperview];
     }];
    self.arrowImage.hidden=NO;
    TTTAchievementStatisticViewController *Achive=[[TTTAchievementStatisticViewController alloc]init];
    Achive.ParamViewid=paramviewID;
    [self PushViewController:Achive TransitationFrom:kCATransitionFade];
    
    
}


- (IBAction)Showhandicap:(id)sender
{
    // [_page_title setText:@"Handicap details"];
    
    [UIView animateWithDuration:0.4f animations:^{
        self.popupview.frame=CGRectMake(0, 60, 320, 0);
        self.popupview.alpha=0.0000f;
    }
                     completion:^(BOOL finished)
     {
         
         Ishoveropen=FALSE;
         
         [self.popupview removeFromSuperview];
         // [SVProgressHUD show];
         
     }];
    self.arrowImage.hidden=NO;
    TTTHandicaptViewController *hanDicap=[[TTTHandicaptViewController alloc]init];
    hanDicap.paramviewID=paramviewID;
    [self PushViewController:hanDicap TransitationFrom:kCATransitionFade];
}
- (IBAction)Showrounddetails:(id)sender
{
    // [_page_title setText:@"Round Details"];
    [UIView animateWithDuration:0.4f animations:^{
        self.popupview.frame=CGRectMake(0, 60, 320, 0);
        self.popupview.alpha=0.0000f;
    }
                     completion:^(BOOL finished)
     {
         
         Ishoveropen=FALSE;
         [self.popupview removeFromSuperview];
     }];
    self.arrowImage.hidden=NO;
    TTTroundlistViewController *roundList=[[TTTroundlistViewController alloc]init];
    roundList.paramviewID=paramviewID;
    [self PushViewController:roundList TransitationFrom:kCATransitionFade];
    
}

-(void)viewDidDisappear:(BOOL)animated
{
    [OperationQ cancelAllOperations];
}

-(void)ReloadTable

{
    _profile_label.text=[[NSString stringWithFormat:@"%@'S STATISTICS",profile] uppercaseString];
    
    _activesincelabel.text=[NSString stringWithFormat:@"Since %@",activesince];
    
    _profile_label.font = [UIFont fontWithName:MYRIARDPROSAMIBOLT size:16.0];
    
    _activesincelabel.font = [UIFont fontWithName:MYRIARDPROLIGHT size:14.0];
    
    [SVProgressHUD dismiss];
    
    [_roundlist setHidden:NO];
    
    [_roundlist reloadData];
    
}

- (IBAction)manuSlideropen:(id)sender
{
    self.MenuBarView.hidden=NO;
    self.chatBoxView.hidden=YES;
    IsLeftMenuBoxOpen=[self PerformMenuSlider:_ScreenView withMenuArea:_MenuBarView IsOpen:IsLeftMenuBoxOpen];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // return 1;
    //   return  [AllResturentArray count];
    return [roundArray count];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 77+1;
    
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    TTTCellForRoundlist *cell=(TTTCellForRoundlist *)[tableView dequeueReusableCellWithIdentifier:nil];
    
    if (cell==nil)
    {
        NSArray *arr=[[NSBundle mainBundle]loadNibNamed:@"TTTCellForRoundlist" owner:self options:nil];
        
        cell=[arr objectAtIndex:0];
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    // UIView *MainView=(UIView *)[cell.contentView viewWithTag:110];
    UILabel *matchtitle = (UILabel *) [cell.contentView viewWithTag:111];
    
    matchtitle.text = [[[roundArray objectAtIndex:indexPath.row]valueForKey:@"matchtitle"]uppercaseString];
    
    matchtitle.font=[UIFont fontWithName:MYRIARDPROSAMIBOLT size:15.0];
    matchtitle.textColor=[UIColor whiteColor];
    
    UILabel *CourseName = (UILabel *) [cell.contentView viewWithTag:112];
    
    CourseName.text = [[roundArray objectAtIndex:indexPath.row]valueForKey:@"CourseName"];
    
    CourseName.font=[UIFont fontWithName:MYRIARDPROLIGHT size:15.0];
    CourseName.textColor=[UIColor whiteColor];
    
    UILabel *MatchCreated = (UILabel *) [cell.contentView viewWithTag:113];
    
    MatchCreated.text = [[roundArray objectAtIndex:indexPath.row]valueForKey:@"MatchCreated"];
    
    MatchCreated.font=[UIFont fontWithName:MYRIARDPROLIGHT size:13.0];
    MatchCreated.textColor=[UIColor whiteColor];
    
    UILabel *NetScore = (UILabel *) [cell.contentView viewWithTag:114];
    
    NetScore.text = [[roundArray objectAtIndex:indexPath.row]valueForKey:@"NetScore"];
    
    NetScore.font=[UIFont fontWithName:MYREADPROREGULAR size:24.0];
    NetScore.textColor=[UIColor whiteColor];
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    TTTRounddetailsViewController *obj=[[TTTRounddetailsViewController alloc]initWithNibName:@"TTTRounddetailsViewController" bundle:nil];
    
    obj.eventid=[[roundArray objectAtIndex:indexPath.row]valueForKey:@"eventid"];
    obj.paramviewID=paramviewID;
    [self PushViewController:obj TransitationFrom:kCATransitionFade];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backButtonClick:(id)sender
{
    [self PerformGoBack];
}
- (void)panDetected:(UIPanGestureRecognizer *)panRecognizer
{
    
    CGPoint  stopLocation;
    
    if(IsChatMenuBoxOpen==NO){
        self.MenuBarView.hidden=NO;
        self.chatBoxView.hidden=YES;
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
    self.MenuBarView.hidden=YES;
    self.chatBoxView.hidden=NO;
    IsChatMenuBoxOpen=[self PerformChatSlider:_ScreenView withChatArea:self.chatBoxView IsOpen:IsChatMenuBoxOpen];
    NSLog(@"PerformChatSliderOperation %@",IsChatMenuBoxOpen?@"YES":@"NO");
    
}

@end
