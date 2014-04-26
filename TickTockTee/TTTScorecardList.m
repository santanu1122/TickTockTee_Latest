//
//  TTTScorecardList.m
//  TickTockTee
//
//  Created by Esolz_Mac on 19/03/14.
//  Copyright (c) 2014 com.esolz.TickTockTee. All rights reserved.
//

#import "TTTScorecardList.h"
#import "TTTcellForScorecard.h"

#import "SVProgressHUD.h"
#import "AFImageRequestOperation.h"
#import "SVProgressHUD.h"
#import "TTTMatchDetails.h"
#import "TTTScoreBord.h"
@interface TTTScorecardList ()
{
    NSArray *match;
    BOOL IsLeftMenuBoxOpen;
    BOOL IfSearchViewopen;
    TTTGlobalMethods *Method;
    NSOperationQueue *OperationQ;
    NSMutableArray *Scorecardlistarry;
    NSString *lastID;
    NSString *moreData;
    BOOL IfMoreDataAvalable;
    BOOL searchMoreDataAvalable;
    NSString *searchlastid;
    BOOL ISSearchButtonclick;
    int i;
    BOOL isFastLocation;
    BOOL islastlocation,IsChatMenuBoxOpen;
}
@property (strong, nonatomic) IBOutlet UIView *chatBoxView;

@end

@implementation TTTScorecardList

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self=(IsIphone5)?[super initWithNibName:@"TTTScorecardList" bundle:nil]:[super initWithNibName:@"TTTScorecardList_iPhone4" bundle:nil];    }
    return self;
}


- (void)viewDidLoad
{
    
    [super viewDidLoad];
    lastID=@"0";
    IfMoreDataAvalable=TRUE;
    ISSearchButtonclick=FALSE;
    searchlastid=@"0";
    
    self.chatBoxView.hidden=YES;
    self.MenuBarView.hidden=YES;
    IsChatMenuBoxOpen=NO;
    
    searchMoreDataAvalable=TRUE;
    _page_title.font = [UIFont fontWithName:@"MyriadPro-regular" size:20.0];
    Scorecardlistarry=[[NSMutableArray alloc]init];
    match1=[[NSMutableArray alloc]init];
    OperationQ=[[NSOperationQueue alloc]init];
    [_footerView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bottom-bar2"]]];
    
    IsLeftMenuBoxOpen=FALSE;
    (!IsIphone5)?[_footerView setFrame:CGRectMake(0, (480 - _footerView.frame.size.height), _footerView.frame.size.width, _footerView.frame.size.height)]:[_footerView setFrame:CGRectMake(0, (568 - _footerView.frame.size.height), _footerView.frame.size.width, _footerView.frame.size.height)];
    [self.view bringSubviewToFront:_footerView];
    [self AddNavigationBarTo:_footerView withSelected:@""];
    [self.ScreenView addSubview:_footerView];
    
    
    
    
    
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    self.navigationController.navigationBar.hidden=YES;
    [self.navigationController.navigationBar setBackgroundColor:[UIColor whiteColor]];
    [SVProgressHUD show];
    [self AddLeftMenuTo:_MenuBarView];
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panDetected:)];
    [self.ScreenView addGestureRecognizer:panRecognizer];
    [self DoMyjob];
    
    
}

-(void)viewDidAppear:(BOOL)animated
{
    
    _scorelist_table.delegate=self;
    _scorelist_table.dataSource=self;
    [_scorelist_table setBackgroundColor:[UIColor clearColor]];
    
}

-(void)DoMyjob
{
    
    [self.view setUserInteractionEnabled:NO];
    NSInvocationOperation *operation=[[NSInvocationOperation alloc]initWithTarget:self selector:@selector(data_for_table:) object:lastID];
    [OperationQ addOperation:operation];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    IfSearchViewopen=FALSE;
    [_SearchView removeFromSuperview];
    
    
}

//Pan Added to the menu

- (void)panDetected:(UIPanGestureRecognizer *)panRecognizer
{
    
    CGPoint  stopLocation;
    if(IsChatMenuBoxOpen==NO)
    {
        self.MenuBarView.hidden=NO;
        self.chatBoxView.hidden=YES;
        if (panRecognizer.state == UIGestureRecognizerStateChanged)
        {
            stopLocation = [panRecognizer translationInView:_ScreenView];
            
            CGRect frame=[_ScreenView frame];
            if (IsLeftMenuBoxOpen==NO&&stopLocation.x>0)
            {
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
        
        else if (panRecognizer.state==UIGestureRecognizerStateEnded)
        {
            
            if (stopLocation.x<150&islastlocation==TRUE&IsLeftMenuBoxOpen==NO)
            {
                
                CGRect framelast=[_ScreenView frame];
                framelast.origin.x=0;
                
                
                [UIView animateWithDuration:.2 animations:^{
                    _ScreenView.frame=framelast;
                    
                }];
            }
            
            if (stopLocation.x*-1<100.0f&isFastLocation==TRUE&IsLeftMenuBoxOpen==YES)
            {
                
                
                CGRect framelast=[_ScreenView frame];
                framelast.origin.x=260;
                
                
                [UIView animateWithDuration:.2 animations:^{
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



-(void)data_for_table:(NSString *)lastidforloadmore
{
    
    
    
    ISSearchButtonclick=FALSE;
    NSString *urlString2;
    NSError *error=nil;
    @try
    {
        if ([self isConnectedToInternet])
        {
            urlString2 = [NSString stringWithFormat:@"%@user.php?mode=scorecard&userid=%@&loggedin_userid=%@&lastid=%@", API,[self LoggedId],[self LoggedId],lastidforloadmore];
            
            NSLog(@"urlString2 ===== %@",urlString2);
            
            NSURL *requestURL2 = [NSURL URLWithString:urlString2];
            NSData *signeddataURL2 =  [NSData dataWithContentsOfURL:requestURL2 options:NSDataReadingUncached error:&error];
            
            NSMutableDictionary *result = [NSJSONSerialization
                                           JSONObjectWithData:signeddataURL2
                                           
                                           options:kNilOptions
                                           error:&error];
            
            
            if ([[result valueForKey:@"extraparam"] isKindOfClass:[NSDictionary class]])
            {
                NSDictionary *Extraparam=[result valueForKey:@"extraparam"];
                NSString *loadMoredata=[Extraparam valueForKey:@"moredata"];
                if ([loadMoredata integerValue]==0)
                {
                    IfMoreDataAvalable=FALSE;
                }
                lastID=[Extraparam valueForKey:@"lastid"];
            }
            
            
            if ([[result objectForKey:@"matches"] isKindOfClass:[NSArray class]])
            {
                NSArray *matchArray=[result objectForKey:@"matches"];
                if ([matchArray count]>0)
                {
                    
                    for (NSDictionary *Dicall in matchArray)
                    {
                        NSMutableDictionary *mutDic=[[NSMutableDictionary alloc]init];
                        [mutDic setValue:[Dicall valueForKey:@"ScoreId"] forKey:@"ScoreId"];
                        [mutDic setValue:[Dicall valueForKey:@"MatchId"] forKey:@"MatchId"];
                        [mutDic setValue:[Dicall valueForKey:@"MatchName"] forKey:@"MatchName"];
                        [mutDic setValue:[Dicall valueForKey:@"CourseName"] forKey:@"CourseName"];
                        [mutDic setValue:[Dicall valueForKey:@"MatchImage"] forKey:@"MatchImage"];
                        [mutDic setValue:[Dicall valueForKey:@"MatchDate"] forKey:@"MatchDate"];
                        [mutDic setValue:[Dicall valueForKey:@"MatchLocation"] forKey:@"MatchLocation"];
                        [mutDic setValue:[Dicall valueForKey:@"CourseBoxname"] forKey:@"CourseBoxname"];
                        [mutDic setValue:[Dicall valueForKey:@"CourseSlope"] forKey:@"CourseSlope"];
                        [mutDic setValue:[Dicall valueForKey:@"CourseRating"] forKey:@"CourseRating"];
                        [mutDic setValue:[Dicall valueForKey:@"CourseBoxcolor"] forKey:@"CourseBoxcolor"];
                        [mutDic setValue:[Dicall valueForKey:@"CourseBoxTextcolor"] forKey:@"CourseBoxTextcolor"];
                        [mutDic setValue:[Dicall valueForKey:@"GrossScore"] forKey:@"GrossScore"];
                        [mutDic setValue:[Dicall valueForKey:@"MatchActive"] forKey:@"MatchActive"];
                        [mutDic setValue:[Dicall valueForKey:@"NetScore"] forKey:@"NetScore"];
                        [mutDic setValue:[Dicall valueForKey:@"MatchTopar"] forKey:@"MatchTopar"];
                        
                        [Scorecardlistarry addObject:mutDic];
                    }
                    
                    [self performSelectorOnMainThread:@selector(Tblreload) withObject:nil waitUntilDone:YES];
                }
                else
                {
                    NSLog(@"off");
                    [self performSelectorOnMainThread:@selector(erroroccur) withObject:nil waitUntilDone:YES];
                    //                    dispatch_async(dispatch_get_main_queue(), ^(void)
                    //                                   {
                    //                                       [SVProgressHUD dismiss];
                    //                                       [SVProgressHUD showErrorWithStatus:@"No Score card List available!"];
                    //                                       [[self view] setUserInteractionEnabled:YES];
                    //                                   });
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
        
    }
    @catch (NSException *exception)
    {
        NSLog(@"This is the basik:%@",exception);
    }
    
    
    
    
    
    
}
-(void)erroroccur
{
    [self.view setUserInteractionEnabled:YES];
    
    
    [SVProgressHUD showErrorWithStatus:@"No Score card List available!"];
}
-(void)Tblreload
{
    
    [self.view setUserInteractionEnabled:YES];
    [SVProgressHUD dismiss];
    [_scorelist_table reloadData];
    
}
-(void)Domywork
{
    [self.view setUserInteractionEnabled:NO];
    NSInvocationOperation *operationmatch=[[NSInvocationOperation alloc] initWithTarget:self selector:@selector(data_for_table:) object:nil];
    [OperationQ addOperation:operationmatch];
}



- (IBAction)manuSlideropen:(id)sender
{
    IsLeftMenuBoxOpen=[self PerformMenuSlider:_ScreenView withMenuArea:_MenuBarView IsOpen:IsLeftMenuBoxOpen];
    [_Searchtextfield resignFirstResponder];
    
}
- (IBAction)AddMaxView:(id)sender
{
}


- (IBAction)search_bar:(id)sender
{
    
    [_Searchtextfield setTextColor:[UIColor whiteColor]];
    _Searchtextfield.font=[UIFont fontWithName:@"MyriadPro-Regular" size:16.0f];
    [_Searchtextfield setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [_SearchView setFrame:CGRectMake(0, 64, 320, 0)];
    
    [_ScreenView addSubview:_SearchView];
    CGRect Frame=[_SearchView frame];
    CGRect frame1=_scorelist_table.frame;
    
    
    if (IfSearchViewopen==FALSE)
    {
        
        Frame.size.height=40;
        if (IsIphone5)
        {
            frame1.origin.y=104;
            frame1.size.height=415;
        }
        else
        {
            frame1.origin.y=104;
            frame1.size.height=367-40;
        }
        
        _Searchtextfield.hidden=YES;
        _ScarchIconpng.hidden=YES;
        
        [UIView animateWithDuration:.4 animations:^{
            
            
            _SearchView.frame=Frame;
            _scorelist_table.frame = frame1;
        }
                         completion:^(BOOL finish)
         {
             
             IfSearchViewopen=TRUE;
             _Searchtextfield.hidden=FALSE;
             _ScarchIconpng.hidden=NO;
             _scorelist_table.frame = frame1;
         }];
    }
    
    else
    {
        NSLog(@"table1 frame %f",_scorelist_table.frame.origin.y);
        Frame.size.height=0;
        if (IsIphone5)
        {
            frame1.origin.y=64;
            frame1.size.height=455;
        }
        else
        {
            frame1.origin.y=64;
            frame1.size.height=367;
        }
        //        frame1.origin.y=64;
        //        frame1.size.height=455;
        [UIView animateWithDuration:.3 animations:^{
            _SearchView.frame=Frame;
            _Searchtextfield.hidden=TRUE;
            _ScarchIconpng.hidden=YES;
            _scorelist_table.frame =frame1;
        }
                         completion:^(BOOL finish)
         {
             NSLog(@"table4 frame %f",_scorelist_table.frame.origin.y);
             // _scorelist_table.frame = CGRectMake(0,104, 320, 455-40);
             IfSearchViewopen=FALSE;
             [_SearchView removeFromSuperview];
         }];
    }
    
    
    
    
    
    
}


- (IBAction)SearchButtonclick:(id)sender
{
    [SVProgressHUD showWithStatus:@"Scratching"];
    [_Searchtextfield resignFirstResponder];
    i=0;
    
    searchlastid=@"0";
    
    searchMoreDataAvalable=TRUE;
    [Scorecardlistarry removeAllObjects];
    //[self.view setUserInteractionEnabled:NO];
    NSInvocationOperation *invocation11=[[NSInvocationOperation alloc]initWithTarget:self selector:@selector(SearchText:) object:searchlastid];
    [OperationQ addOperation:invocation11];
}



-(void)SearchText:(NSString *)searchlastidforloadmore

{
    IfMoreDataAvalable=FALSE;
    ISSearchButtonclick=TRUE;
    
    NSString *URL=[NSString stringWithFormat:@"%@user.php?mode=scorecard&userid=%@&loggedin_userid=%@&lastid=%@&search=%@", API,[self LoggedId], [self LoggedId],searchlastidforloadmore,[[_Searchtextfield.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    
    
    NSLog(@"%@", URL);
    
    
    
    NSData *getData=[NSData dataWithContentsOfURL:[NSURL URLWithString:URL]];
    
    
    
    NSDictionary *Output=[NSJSONSerialization JSONObjectWithData:getData options:kNilOptions error:nil];
    
    NSArray *matchArray1=[Output objectForKey:@"matches"];
    
    if([matchArray1 count]>0)
    {
        NSArray *matchArray=[Output objectForKey:@"matches"];
        
        NSDictionary *Extraparam=[Output valueForKey:@"extraparam"];
        
        NSString *searchMoredata=[Extraparam valueForKey:@"moredata"];
        
        if ([searchMoredata integerValue]==0)
            
        {
            
            searchMoreDataAvalable=FALSE;
        }
        
        
        
        
        
        searchlastid=[Extraparam valueForKey:@"lastid"];
        
        for (NSDictionary *Dicall in matchArray)
            
        {
            
            NSMutableDictionary *mutDic=[[NSMutableDictionary alloc]init];
            
            [mutDic setValue:[Dicall valueForKey:@"ScoreId"] forKey:@"ScoreId"];
            
            [mutDic setValue:[Dicall valueForKey:@"MatchId"] forKey:@"MatchId"];
            
            [mutDic setValue:[Dicall valueForKey:@"MatchName"] forKey:@"MatchName"];
            
            [mutDic setValue:[Dicall valueForKey:@"CourseName"] forKey:@"CourseName"];
            
            [mutDic setValue:[Dicall valueForKey:@"MatchImage"] forKey:@"MatchImage"];
            
            [mutDic setValue:[Dicall valueForKey:@"MatchDate"] forKey:@"MatchDate"];
            
            [mutDic setValue:[Dicall valueForKey:@"MatchLocation"] forKey:@"MatchLocation"];
            
            [mutDic setValue:[Dicall valueForKey:@"CourseBoxname"] forKey:@"CourseBoxname"];
            
            [mutDic setValue:[Dicall valueForKey:@"CourseSlope"] forKey:@"CourseSlope"];
            
            [mutDic setValue:[Dicall valueForKey:@"CourseRating"] forKey:@"CourseRating"];
            
            [mutDic setValue:[Dicall valueForKey:@"CourseBoxcolor"] forKey:@"CourseBoxcolor"];
            
            [mutDic setValue:[Dicall valueForKey:@"CourseBoxTextcolor"] forKey:@"CourseBoxTextcolor"];
            
            [mutDic setValue:[Dicall valueForKey:@"GrossScore"] forKey:@"GrossScore"];
            
            [mutDic setValue:[Dicall valueForKey:@"MatchActive"] forKey:@"MatchActive"];
            
            [mutDic setValue:[Dicall valueForKey:@"NetScore"] forKey:@"NetScore"];
            
            [mutDic setValue:[Dicall valueForKey:@"MatchTopar"] forKey:@"MatchTopar"];
            
            [Scorecardlistarry addObject:mutDic];
            
        }
        
        
        
        [self performSelectorOnMainThread:@selector(Tblreload) withObject:nil waitUntilDone:YES];
        
        
        
    }   else
        
    {
        
        dispatch_async(dispatch_get_main_queue(), ^(void)
                       
                       {
                           [self.view setUserInteractionEnabled:YES];
                           [SVProgressHUD showErrorWithStatus:@"No scarch result found!"];
                           [SVProgressHUD dismiss];
                           [_scorelist_table reloadData];
                           searchMoreDataAvalable=FALSE;
                           
                       });
        
    }
    
}



-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    CGRect frame=[self.Scarchicon frame];
    frame.origin.x=9;
    [UIView animateWithDuration:.3f animations:^{
        
        self.Scarchicon.frame=frame;
    }];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [Scorecardlistarry count];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier=@"cell";
    NSMutableDictionary *mutDicForScorecard=[Scorecardlistarry objectAtIndex:indexPath.row];
    TTTcellForScorecard *scoreListcell = (TTTcellForScorecard *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (scoreListcell==nil)
    {
        
        
        NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"TTTcellForScorecard" owner:self options:nil];
        scoreListcell = [arr objectAtIndex:0];
        
        [scoreListcell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
    }
    
    
    
    UIView *MainView=(UIView *)[scoreListcell.contentView viewWithTag:712];
    
    UIActivityIndicatorView *Spinner=(UIActivityIndicatorView *)[MainView viewWithTag:2010];
    
    NSString *BackgroundImageStgring=[mutDicForScorecard valueForKey:@"MatchImage"];
    UIImageView *bgimage=(UIImageView *)[scoreListcell.contentView viewWithTag:241];
    
    [bgimage setContentMode:UIViewContentModeScaleAspectFill];
    
    NSURLRequest *request_img = [NSURLRequest requestWithURL:[NSURL URLWithString:BackgroundImageStgring]];
    AFImageRequestOperation *operation = [AFImageRequestOperation imageRequestOperationWithRequest:request_img
                                                                              imageProcessingBlock:nil
                                                                                           success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                                                               if(image!=nil)
                                                                                               {
                                                                                                   
                                                                                                   
                                                                                                   
                                                                                                   [bgimage setImage:image];
                                                                                                   
                                                                                                   [Spinner stopAnimating];
                                                                                                   [Spinner setHidden:YES];
                                                                                               }
                                                                                               
                                                                                           }
                                                                                           failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                                                                               NSLog(@"Error %@",error);
                                                                                               
                                                                                               [bgimage setImage:[UIImage imageNamed:@"picture.png"]];
                                                                                               
                                                                                           }];
    [operation start];
    
    
    scoreListcell.backgroundColor=[UIColor clearColor];
    
    UIImageView *overlay=(UIImageView *)[scoreListcell.contentView viewWithTag:2008];
    overlay.image=[UIImage imageNamed:@"overlay.png"];
    
    UILabel *match_name = (UILabel *) [MainView viewWithTag:2004];
    
    match_name.text = [mutDicForScorecard valueForKey:@"MatchName"];
    
    match_name.font=[UIFont fontWithName:@"MyriadPro-Semibold" size:16.0];
    match_name.textColor=[UIColor whiteColor];
    
    UILabel *matchdate = (UILabel *) [MainView viewWithTag:2006];
    
    matchdate.text = [mutDicForScorecard valueForKey:@"MatchDate"];
    matchdate.textColor=[UIColor whiteColor];
    matchdate.font=[UIFont fontWithName:MYRIARDPROLIGHT size:14.0];
    
    
    if(![[mutDicForScorecard valueForKey:@"MatchActive"] integerValue]==1)
    {
        UIImageView *active=(UIImageView *)[MainView viewWithTag:993];
        active.hidden=YES;
        
    }
    
    
    UILabel *score_label = (UILabel *) [MainView viewWithTag:2003];
    
    score_label.text = [mutDicForScorecard valueForKey:@"GrossScore"];
    
    score_label.textColor=[UIColor whiteColor];
    score_label.font=[UIFont fontWithName:MYRIARDPROLIGHT size:25.0];
    
    UILabel *grossScoreTxt=(UILabel *)[MainView viewWithTag:9999];
    grossScoreTxt.font=[UIFont fontWithName:MYREADPROREGULAR size:12.0f];
    UILabel *NetScoreTxt=(UILabel *)[MainView viewWithTag:99999];
    NetScoreTxt.font=[UIFont fontWithName:MYREADPROREGULAR size:12.0f];
    //
    UILabel *GrossoriginalScore=(UILabel *)[MainView viewWithTag:500];
    GrossoriginalScore.font=[UIFont fontWithName:MYRIARDPROLIGHT size:21.0f];
    GrossoriginalScore.text=[mutDicForScorecard valueForKey:@"GrossScore"];
    
    UILabel *NetoriginalScore=(UILabel *)[MainView viewWithTag:501];
    NetoriginalScore.font=[UIFont fontWithName:MYRIARDPROLIGHT size:21.0f];
    NetoriginalScore.text=[mutDicForScorecard valueForKey:@"NetScore"];
    
    UILabel *MatchTopar=(UILabel *)[MainView viewWithTag:502];
    MatchTopar.font=[UIFont fontWithName:MYRIARDPROLIGHT size:21.0f];
    MatchTopar.text=[mutDicForScorecard valueForKey:@"MatchTopar"];
    
    
    
    UILabel *course_name = (UILabel *)[MainView viewWithTag:420];
    
    course_name.backgroundColor=[UIColor clearColor];
    course_name.font=[UIFont fontWithName:MYRIARDPROLIGHT size:14.0];
    course_name.textAlignment=NSTextAlignmentLeft;
    course_name.textColor=[UIColor whiteColor];
    course_name.numberOfLines=0;
    
    
    
    NSAttributedString *attributedText =
    [[NSAttributedString alloc]
     initWithString:[self RemoveNullandreplaceWithSpace:[mutDicForScorecard valueForKey:@"CourseName"]]
     attributes:@
     {
     NSFontAttributeName:[UIFont fontWithName:MYRIARDPROLIGHT size:14.0f]
     }];
    
    CGRect rect = [attributedText boundingRectWithSize:(CGSize){190, 21}
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                               context:nil];
    CGSize size = rect.size;
    NSLog(@"the value for Siuze.width:%f",size.width);
    course_name.frame=CGRectMake(course_name.frame.origin.x, course_name.frame.origin.y, size.width, course_name.frame.size.height);
    course_name.text=[mutDicForScorecard valueForKey:@"CourseName"];
    
    UIView *ScoreView=(UIView *)[MainView viewWithTag:421];
    
    [self setRoundBorderToUiview:ScoreView];
    [ScoreView setBackgroundColor:[TTTGlobalMethods colorFromHexString:[mutDicForScorecard valueForKey:@"CourseBoxcolor"]]];
    [ScoreView setFrame:CGRectMake(size.width+20, ScoreView.frame.origin.y, ScoreView.frame.size.width, ScoreView.frame.size.height)];
    
    
    
    
    return scoreListcell;
    
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *mutDic=[Scorecardlistarry objectAtIndex:indexPath.row];
    TTTScoreBord *obj=[[TTTScoreBord alloc]init];
    obj.matchID=[mutDic valueForKey:@"MatchId"];
    [self PushViewController:obj TransitationFrom:kCATransitionFade];
    
}

#pragma UItextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    i=0;
    
    searchlastid=@"0";
    [self.view setUserInteractionEnabled:NO];
    searchMoreDataAvalable=TRUE;
    //    if (textField==_Searchtextfield&&_Searchtextfield.text.length>0)
    //    {
    [Scorecardlistarry removeAllObjects];
    [SVProgressHUD showWithStatus:@"Searching"];
    NSInvocationOperation *invocation=[[NSInvocationOperation alloc]initWithTarget:self selector:@selector(SearchText:) object:searchlastid];
    [OperationQ addOperation:invocation];
    // }
    
    return YES;
}
-(void)viewDidDisappear:(BOOL)animated
{
    [OperationQ cancelAllOperations];
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSLog(@"The scroll view did Disselareting call");
    
    CGPoint offset = scrollView.contentOffset;
    CGRect bounds = scrollView.bounds;
    CGSize size = scrollView.contentSize;
    UIEdgeInsets inset = scrollView.contentInset;
    float y = offset.y + bounds.size.height - inset.bottom;
    float h = size.height;
    
    float reload_distance = -60.0f;
    if(y > h + reload_distance)
    {
        
        if (ISSearchButtonclick==TRUE)
        {
            if (searchMoreDataAvalable==YES)
            {
                NSInvocationOperation *invocation11=[[NSInvocationOperation alloc]initWithTarget:self selector:@selector(SearchText:) object:searchlastid];
                [OperationQ addOperation:invocation11];
            }
            
        }
        else
        {
            if (IfMoreDataAvalable==TRUE)
            {
                NSInvocationOperation *operation=[[NSInvocationOperation alloc]initWithTarget:self selector:@selector(data_for_table:) object:lastID];
                [OperationQ addOperation:operation];
            }
            else
            {
                NSLog(@"Thereis mo data for loadmore");
            }
        }
    }
}




@end
