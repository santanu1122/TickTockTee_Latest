//
//  TTTAchievementStatisticViewController.m
//  TickTockTee
//
//  Created by Esolz Tech on 21/03/14.
//  Copyright (c) 2014 com.esolz.TickTockTee. All rights reserved.
//

#import "TTTAchievementStatisticViewController.h"
#import "TTTAchievementDetailsViewController.h"
#import "TTTHandicaptViewController.h"
#import "TTTRounddetailsViewController.h"
#import "TTTroundlistViewController.h"
#import "TTTStatisticsViewController.h"
#import "AFNetworking.h"
#import "AFImageRequestOperation.h"

typedef enum {
    NetworkError,JSonError
}ErrorTypes;
@interface TTTAchievementStatisticViewController ()<UIGestureRecognizerDelegate>
{
    UIImageView *fullBackImage;
    int initialx,initialy,numx,numy;
    UIView *viewcell,*labelView;
    UIImageView *cellImage;
    UILabel *cellLabel;
    UIImageView *topBackImage;
    UIActivityIndicatorView *indicatorView;
    BOOL IsLeftMenuBoxOpen,isDropDownOpen;
    int countOfView;
    
    //UILabel *viewcell;
    int fetchInitial;
    NSURL *fire_url;
    NSOperationQueue *opt_Que;
    NSMutableDictionary *dict_retrieved ;
    NSMutableArray *arrayWithAllObjects;
    NSMutableArray *allimages;
    ErrorTypes err_types;
    NSString *viewID;
    UIActivityIndicatorView *indicView;
    BOOL islastlocation,isFastLocation,IsChatMenuBoxOpen;
}

@property (weak, nonatomic) IBOutlet UIButton *MenubuttonClick;

@property (weak, nonatomic) IBOutlet UIButton *Backbuttonclick;
@property (strong, nonatomic) IBOutlet UIButton *roundButton;
@property (strong, nonatomic) IBOutlet UIButton *handicapButton;
@property (strong, nonatomic) IBOutlet UIButton *achievementButton;
@property (strong, nonatomic) IBOutlet UIButton *overviewButton;
@property (strong,nonatomic)IBOutlet UIView *DropdownMain;
@property (strong,nonatomic)NSMutableArray *content;
@property (strong, nonatomic) IBOutlet UIView *chatBoxview;
@property (strong, nonatomic) IBOutlet UIButton *arrowImage;

@end

@implementation TTTAchievementStatisticViewController
@synthesize MenuView=_MenuView;
@synthesize upView=_upView;
@synthesize ScreenView=_ScreenView;
@synthesize dropDownMenu=_dropDownMenu;
@synthesize dropDownMenus=_dropDownMenus;
@synthesize Backbuttonclick;
@synthesize ParamViewid;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
         self=(IsIphone5)?[super initWithNibName:@"TTTAchievementStatisticViewController" bundle:nil]:[super initWithNibName:@"TTTAchievementStatisticViewController_iPhone4" bundle:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    isDropDownOpen=NO;
    countOfView=0;
    fetchInitial=1;
    arrayWithAllObjects=[[NSMutableArray alloc]init];
    indicView=[[UIActivityIndicatorView alloc]init];
    indicView.center=CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2);
    [indicView startAnimating];
    [self.view addSubview:indicView];
    IsLeftMenuBoxOpen=FALSE;
   [self AddLeftMenuTo:_MenuView];
    
    [self.view addSubview:_dropDownMenus];
    
    _dropDownMenus.hidden=YES;
    viewID=([ParamViewid length]>0)?ParamViewid:[self LoggedId];
    
    if (ParamViewid.length>0)
    {
        Backbuttonclick.hidden=NO;
        self.MenubuttonClick.hidden=YES;
    }
    else
    {
        Backbuttonclick.hidden=YES;
        self.MenubuttonClick.hidden=NO;
        UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panDetected:)];
        panRecognizer.delegate=self;
        [self.ScreenView addGestureRecognizer:panRecognizer];
    }
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    self.navigationController.navigationBar.hidden=YES;
    [self.navigationController.navigationBar setBackgroundColor:[UIColor whiteColor]];
    
    
    [_footerView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bottom-bar2"]]];
    (!IsIphone5)?[_footerView setFrame:CGRectMake(0, (480 - _footerView.frame.size.height), _footerView.frame.size.width, _footerView.frame.size.height)]:[_footerView setFrame:CGRectMake(0, (568 - _footerView.frame.size.height), _footerView.frame.size.width, _footerView.frame.size.height)];
    [self.view bringSubviewToFront:_footerView];
    [self AddNavigationBarTo:_footerView withSelected:@""];
    [self.ScreenView addSubview:_footerView];
    
    
    }
-(void)viewWillAppear:(BOOL)animated
{
    
    countOfView=0;
    
    [super viewWillAppear:YES];
    
    if(fetchInitial==1)
        
        [self fetchInitialData];
    
    
    
    _dropDownMenu.text=@"Achievements";
    
    isDropDownOpen=NO;
    
    fetchInitial++;
    
}

//Featch content
-(void)fetchInitialData
{
    opt_Que = [[NSOperationQueue alloc] init];
    [opt_Que setMaxConcurrentOperationCount:1];
    
    dict_retrieved = [[NSMutableDictionary alloc] init];
    
    __block NSString *str_url=[NSString stringWithFormat:@"%@user.php?mode=achivementlist&userid=%@&loggedin_userid=%@",API,viewID,[self LoggedId]];
    NSLog(@" url str is %@",str_url);
    
    fire_url=[NSURL URLWithString:str_url];
  
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        
        NSError *err=nil;
        NSData* data = [NSData dataWithContentsOfURL:fire_url options:0 error:&err];
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            
           
            int i=0;
            NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data  options:kNilOptions error:nil];
            
            _content=[[NSMutableArray alloc]init];
            
            if ([[[dict objectForKey:@"extraparam"] objectForKey:@"total_achivement"] intValue] > 0) {
                for (NSMutableDictionary *Mutabledata in [dict objectForKey:@"achivementlist"]) {
                    NSMutableDictionary *dictinsert=[[NSMutableDictionary alloc]init];
                    
                    
                    
                    [dictinsert setObject:[Mutabledata objectForKey:@"achivement_title"] forKey:@"achievementtitle"];
                    [dictinsert setObject:[Mutabledata objectForKey:@"thumb"] forKey:@"thumb"];
                    [dictinsert setObject:[Mutabledata objectForKey:@"achivement_id"] forKey:@"achievementid"];
                    [dictinsert setObject:[Mutabledata objectForKey:@"total_get_this_achivement"] forKey:@"totalachievement"];
                    
                   

                    [_content insertObject:[Mutabledata objectForKey:@"achivement_id"] atIndex:i];
                     [arrayWithAllObjects insertObject:dictinsert atIndex:i];
                    i++;
                
                    
                }
                
             
               // IsLeftMenuBoxOpen=FALSE;
               
                
                
                topBackImage=[[UIImageView alloc]initWithFrame:CGRectMake(_upView.bounds.origin.x, _upView.bounds.origin.y, _upView.bounds.size.width, _upView.bounds.size.height)];
                topBackImage.image=[UIImage imageNamed:@"topbar-1"];
                [_upView addSubview:topBackImage];
                [_upView sendSubviewToBack:topBackImage];
                initialx=initialy=0;
                numx=0;
                numy=0;
                NSArray *nibviews=[[NSBundle mainBundle]loadNibNamed:@"Empty" owner:self options:nil];
                  viewcell=[nibviews objectAtIndex:0];
                
                
                _activityScroll.userInteractionEnabled=YES;
                
                // Do any additional setup after loading the view from its nib.
                
                fullBackImage=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bgAchievement"]];
                fullBackImage.frame=self.view.frame;
                [_ScreenView addSubview:fullBackImage];
                [_ScreenView sendSubviewToBack:fullBackImage];
                
                NSMutableDictionary *tagDictonary=[[NSMutableDictionary alloc]init];
                
                while(numy<4 && countOfView<[arrayWithAllObjects count]){
                    
                    
                   
                    [self createViewCell:initialx*107 end:initialy*107 index:countOfView];
                    initialx++;
                    numx++;
                    if(initialx==3)
                    {
                        initialx=0;
                        initialy++;
                        numy++;
                    }
                    
                    
                    if(numy==2)
                    {
                        _activityScroll.contentSize=CGSizeMake(320, 107*4);
                    }
                    
                    
                    [_activityScroll addSubview:viewcell];
                    UITapGestureRecognizer *recognize=[[UITapGestureRecognizer alloc]initWithTarget:self
                                                                                             action:@selector(handleSingleTap:)];
                    [viewcell addGestureRecognizer:recognize];
                    viewcell.tag=countOfView+2000;
                    
                    [tagDictonary setObject:[NSString stringWithFormat:@"%d",countOfView+2000] forKey:@"ViewTag"];
                    
                    countOfView++;
                    
                }
                [indicView stopAnimating];
            }
            else
            {
                [indicView stopAnimating];
                [SVProgressHUD showErrorWithStatus:@"No Achievements found"];
            }
        });
    });
    
}
-(void)createViewCell:(int) i end:(int)j index:(int)index
{
    
    NSDictionary *dictcn=[arrayWithAllObjects objectAtIndex:index];
   
    viewcell=[[UIView alloc]initWithFrame:CGRectMake(i, j, 106, 144)];
    cellImage=[[UIImageView alloc]initWithFrame:CGRectMake(20,20,65,65)];
    cellImage.image=[UIImage imageNamed:@"noimage"];
    UIImageView *cellimage=[[UIImageView alloc]initWithFrame:CGRectMake(20,20,65,65)];
    cellLabel=[[UILabel alloc]initWithFrame:CGRectMake(0,90,106,16)];
    
    
    indicatorView=[[UIActivityIndicatorView alloc]init];
    indicatorView.center=CGPointMake(CGRectGetMidX(cellImage.bounds), CGRectGetMidY(cellImage.bounds));
    indicatorView.activityIndicatorViewStyle=UIActivityIndicatorViewStyleGray;
    [indicatorView startAnimating];
    [cellImage addSubview:indicatorView];
    [cellImage bringSubviewToFront:indicatorView];
    
    cellLabel.text=[dictcn objectForKey:@"achievementtitle"];
    cellLabel.font=[UIFont fontWithName:MYRIARDPROLIGHT size:13];
    cellLabel.textColor=[UIColor whiteColor];
    cellLabel.textAlignment=NSTextAlignmentCenter;
    
    cellLabel.backgroundColor=[UIColor clearColor];
    viewcell.backgroundColor=[UIColor clearColor];
    
    cellImage.backgroundColor=[UIColor clearColor];
    
   
    
    UILabel *CircleView =[[UILabel alloc]initWithFrame:CGRectMake(68,20,25,25)];
    CircleView.backgroundColor=[UIColor colorWithRed:55/255.0 green:52/255.0 blue:93/255.0 alpha:1.0];
   // labelView=[[UIView alloc]initWithFrame:CGRectMake(68,20,25,25)];
    CircleView.layer.cornerRadius = 12.0;
    CircleView.layer.masksToBounds = YES;
    CircleView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    CircleView.layer.borderWidth = 1.0;
    CircleView.text=[NSString stringWithFormat:@"%@",[dictcn objectForKey:@"totalachievement"]];
   
    CircleView.textColor=[UIColor whiteColor];
    CircleView.font= [UIFont fontWithName:MYREADPROREGULAR size:10];
    CircleView.textAlignment=NSTextAlignmentCenter;
    

    
    
    
    cellImage.tag=997;
    labelView.tag=998;
    cellLabel.tag=999;
   
    indicatorView.tag=1003;
    
    
    [viewcell addSubview:cellImage];
    [viewcell addSubview:cellLabel];
    NSURLRequest *request_img = [NSURLRequest requestWithURL:[NSURL URLWithString:[dictcn objectForKey:@"thumb"]]];
    NSLog(@"The image url request:%@",request_img);
    AFImageRequestOperation *operation = [AFImageRequestOperation imageRequestOperationWithRequest:request_img
                                                                              imageProcessingBlock:nil
                                                                                           success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                                                               if(image!=nil)
                                                                                               {
                                                                                                   
                                                                                                   [cellimage setImage:image];
                                                                                                   NSLog(@"The value of image :%@",image);
                                                                                                   [indicatorView stopAnimating];
                                                                                                   
                                                                                               }
                                                                                               
                                                                                           }
                                                                                           failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                                                                               NSLog(@"Error %@",error);
                                                                                               
                                                                                               NSLog(@"error");
                                                                                               
                                                                                           }];
    [operation start];
    
    [self SetroundborderWithborderWidth:2.0f WithColour:[UIColor whiteColor] ForImageview:cellimage];
  
      [viewcell addSubview:cellimage];
      [viewcell addSubview:CircleView];
}
- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
    int mytag=recognizer.view.tag;
    TTTAchievementDetailsViewController *ScrobordView=[[TTTAchievementDetailsViewController alloc]init];
    ScrobordView.ParamviewAchivementdetails=ParamViewid;
    int dataone = [[_content objectAtIndex:mytag-2000] intValue];
    ScrobordView.tag=dataone;
    [self PushViewController:ScrobordView TransitationFrom:kCATransitionFade];
}
- (IBAction)menuClicked:(id)sender {
    [self keyboardhide];
    self.MenuView.hidden=NO;
    self.chatBoxview.hidden=YES;
     IsLeftMenuBoxOpen=[self PerformMenuSlider:_ScreenView withMenuArea:_MenuView IsOpen:IsLeftMenuBoxOpen];
    
}

-(void)updateUI{
    __block NSDictionary *dict;
    allimages=[[NSMutableArray alloc]init];
    dispatch_async(dispatch_get_main_queue(), ^(void){
    for(int i=0;i<[arrayWithAllObjects count];i++){
        
        dict=[arrayWithAllObjects objectAtIndex:i];
        
       NSString * str_url=[dict objectForKey:@"thumb"];
        NSError *err=nil;
        NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:str_url] options:0 error:&err];
        UIImage *img=[UIImage imageWithData:data];
        [allimages addObject:img];
    }
        
    });
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}
- (IBAction)menuaction:(id)sender {
    NSLog(@"It is clicked in menu");
    
    
    if(isDropDownOpen==NO){
        
        [UIView animateWithDuration:.3 animations:^{
            
            _dropDownMenus.frame=CGRectMake(0, 60, 320, 115);
            
        }
                         completion:^(BOOL finished)
         {
             isDropDownOpen=YES;
             _dropDownMenus.hidden=NO;
             _roundButton.hidden=NO;
             _handicapButton.hidden=NO;
             _achievementButton.hidden=NO;
             _overviewButton.hidden=NO;
             _dropDownMenus.backgroundColor=UIColorFromRGB(0x9cc6d9);
             _dropDownMenus.frame=CGRectMake(0, 60, 320, 230);
             
             
         }];
        self.arrowImage.hidden=YES;
    }
    else{
        isDropDownOpen=NO;
        _roundButton.hidden=YES;
        _handicapButton.hidden=YES;
        _achievementButton.hidden=YES;
        _overviewButton.hidden=YES;
        _dropDownMenus.hidden=YES;
       _dropDownMenu.text=@"Achievements";
    }
    //[self.view addSubview:_dropDownMenu];
}
- (IBAction)overViewAction:(id)sender {
    //_dropDownMenu.text=@"Overview";
    isDropDownOpen=NO;
    _roundButton.hidden=YES;
    _handicapButton.hidden=YES;
    _achievementButton.hidden=YES;
    _overviewButton.hidden=YES;
    _dropDownMenus.hidden=YES;
    TTTStatisticsViewController *statistics=[[TTTStatisticsViewController  alloc]init];
    statistics.paramviewID=ParamViewid;
    [self PushViewController:statistics TransitationFrom:kCATransitionFade];
    NSLog(@"overviewAction clicked");
    
}
- (IBAction)achievementAction:(id)sender {
    // _dropDownMenu.text=@"Achievements";
    isDropDownOpen=NO;
    _roundButton.hidden=YES;
    _handicapButton.hidden=YES;
    _achievementButton.hidden=YES;
    _overviewButton.hidden=NO;
    _dropDownMenus.hidden=YES;
    TTTAchievementStatisticViewController *Achive=[[TTTAchievementStatisticViewController alloc]init];
    Achive.ParamViewid=ParamViewid;
    [self PushViewController:Achive TransitationFrom:kCATransitionFade];
    NSLog(@"achievementAction clicked");
}
- (IBAction)roundDetails:(id)sender
{
    // _dropDownMenu.text=@"Round Details";
    isDropDownOpen=NO;
    _roundButton.hidden=YES;
    _handicapButton.hidden=YES;
    _achievementButton.hidden=YES;
    _overviewButton.hidden=YES;
    _dropDownMenus.hidden=YES;
    TTTroundlistViewController *roundlist=[[TTTroundlistViewController alloc]init];
    roundlist.paramviewID=ParamViewid;
    [self PushViewController:roundlist TransitationFrom:kCATransitionFade];
    
    
}
- (IBAction)HandicapAction:(id)sender {
    // _dropDownMenu.text=@"Handicap Details";
    isDropDownOpen=NO;
    _roundButton.hidden=YES;
    _handicapButton.hidden=YES;
    _achievementButton.hidden=YES;
    _overviewButton.hidden=YES;
    _dropDownMenus.hidden=YES;
    TTTHandicaptViewController *handicap=[[TTTHandicaptViewController alloc]init];
    handicap.paramviewID=ParamViewid;
    [self PushViewController:handicap TransitationFrom:kCATransitionFade];
    NSLog(@"HandicapAction clicked");
}
- (IBAction)BackbuttonClick:(id)sender
{
    [self PerformGoBack];
    
}
//TTT Achive ment statistic view controller

- (void)panDetected:(UIPanGestureRecognizer *)panRecognizer
{
    
    CGPoint  stopLocation;
    [self keyboardhide];
    if(IsChatMenuBoxOpen==NO){
        self.chatBoxview.hidden=YES;
        self.MenuView.hidden=NO;
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
    self.chatBoxview.hidden=NO;
    self.MenuView.hidden=YES;
    IsChatMenuBoxOpen=[self PerformChatSlider:_ScreenView withChatArea:self.chatBoxview IsOpen:IsChatMenuBoxOpen];
    NSLog(@"PerformChatSliderOperation %@",IsChatMenuBoxOpen?@"YES":@"NO");
    
}
-(void)keyboardhide{
    
    [SVProgressHUD dismiss];
    
    [self.manuSearchtxt resignFirstResponder];
    
    if ([self.manuSearchtxt.text length]<1 && self.Scarchicon.frame.origin.x==9)
        
    {
        
        CGRect frame=[self.Scarchicon frame];
        
        frame.origin.x=205;
        
        [UIView animateWithDuration:.3f animations:^{
            
            
            
            self.Scarchicon.frame=frame;
            
            
            
            
            
        }];
        
    }
    
    
    
}





-(BOOL)textFieldShouldReturn:(UITextField *)textField

{
    [textField resignFirstResponder];
    
     if ([self.manuSearchtxt.text length]<1)
        
    {
        
        CGRect frame=[self.Scarchicon frame];
        
        frame.origin.x=205;
        
        [UIView animateWithDuration:.3f animations:^{
            
            self.Scarchicon.frame=frame;
            
        }];
        
    }else{
        [self globalSearch];
    }
    
    
    
    return YES;
    
}



-(void)textFieldDidBeginEditing:(UITextField *)textField

{
    
    CGRect frame=[self.Scarchicon frame];
    
    frame.origin.x=9;
    
    [UIView animateWithDuration:.3f animations:^{
        
        self.Scarchicon.frame=frame;
        
    }];
    
}


@end
