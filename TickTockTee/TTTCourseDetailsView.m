
//
//  TTTCourseDetailsView.m
//  TickTockTee
//
//  Created by macbook_ms on 10/04/14.
//  Copyright (c) 2014 com.esolz.TickTockTee. All rights reserved.
//

#import "TTTCourseDetailsView.h"
#import "SVProgressHUD.h"
#import "AFNetworking.h"
#import "AFImageRequestOperation.h"
#import "TTTCourseStatisticView.h"
#import "TTTCourseReviewViewController.h"
#import "TTTCourseOverviewViewController.h"
#import "TTTFollowerlistviewController.h"


@interface TTTCourseDetailsView ()
{
    NSString *ViewID;
    NSMutableDictionary *MainDetailsPageDetails;
    NSMutableArray *FollowerArray;
    NSMutableArray *ReviewArray;
    NSMutableArray *StatisticArry;
    NSString *followUnfollow;
    BOOL isFOLLOW;
    NSOperationQueue *Coursedetailsoperation;
   BOOL IsLeftMenuBoxOpen,isEditing,Ishoveropen,ISMoreData,ISsearched,ISLastContent,isChatboxopen;
    BOOL islastlocation;
    BOOL isFastLocation;
    BOOL ISSearchOpen,IfSearchViewopen,IsChatMenuBoxOpen;
    NSInteger TotalFollowingpeople;
    NSInteger Numborofreview;
    UIView *ReviewListview;

    
}

@property (strong, nonatomic) IBOutlet UIView *ChatSliderView;

@property (strong, nonatomic) IBOutlet UIView *Mainviewback;

@property (weak, nonatomic) IBOutlet UIImageView *BackgroundImage;
@property (weak, nonatomic) IBOutlet UIView *UserimageBackview;
@property (weak, nonatomic) IBOutlet UIImageView *userimageview;
@property (weak, nonatomic) IBOutlet UILabel *CoursenameLbl;
@property (weak, nonatomic) IBOutlet UILabel *CourseLocationLBL;
@property (weak, nonatomic) IBOutlet UILabel *Totalreview;
@property (weak, nonatomic) IBOutlet UILabel *totalActivationtimeLBL;
@property (weak, nonatomic) IBOutlet UILabel *TotalFollower;
@property (weak, nonatomic) IBOutlet UILabel *Followertxt;
@property (weak, nonatomic) IBOutlet UIButton *FolowerButton;
@property (strong, nonatomic) IBOutlet UIView *Screenview;
@property (strong, nonatomic) IBOutlet UIView *Vfooterback;
@property (strong, nonatomic) IBOutlet UIView *CourseAll;
@property (strong, nonatomic) IBOutlet UIImageView *FooterBackgroundimage;

@property (strong, nonatomic) IBOutlet UIView *menuview;
@end

@implementation TTTCourseDetailsView
@synthesize ParamViewerid,CourseID,ChatSliderView,FooterBackgroundimage;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    IsChatMenuBoxOpen=NO;
    Ishoveropen=FALSE;
    isEditing=NO;
    ISsearched=NO;
    ISMoreData=YES;
    IsLeftMenuBoxOpen=FALSE;
    ISLastContent=YES;
    if (!IsIphone5)
    {
        CGRect frame=[self.Vfooterback frame];
        frame.origin.y=480-49;
        [self.Vfooterback setFrame:frame];
    }
    
    
    ViewID=(ParamViewerid.length>0)?ParamViewerid:[self LoggedId];
    MainDetailsPageDetails=[[NSMutableDictionary alloc]init];
    FollowerArray=[[NSMutableArray alloc]init];
    ReviewArray=[[NSMutableArray alloc]init];
    StatisticArry =[[NSMutableArray alloc]init];
    [self SetroundborderWithborderWidth:2.0f WithColour:[UIColor whiteColor] ForView:_UserimageBackview];
    [self SetroundborderWithborderWidth:2.0f WithColour:[UIColor clearColor] ForImageview:_userimageview];
    _Followertxt.font=[UIFont fontWithName:MYREADPROREGULAR size:13.0f];
    _CoursenameLbl.font=[UIFont fontWithName:MYRIARDPROSAMIBOLT size:15.0f];
    _CourseLocationLBL.font=[UIFont fontWithName:MYRIARDPROLIGHT size:13.0f];
    _TotalFollower.font=[UIFont fontWithName:SEGIOUI size:13.0f];
    _totalActivationtimeLBL.font=[UIFont fontWithName:MYRIARDPROLIGHT size:13.0f];
    _Totalreview.font=[UIFont fontWithName:MYRIARDPROLIGHT size:13.0f];
    _Followertxt.font=[UIFont fontWithName:MYRIARDPROSAMIBOLT size:12.0f];
     Coursedetailsoperation=[[NSOperationQueue alloc]init];
     [SVProgressHUD show];
    ChatSliderView.hidden=TRUE;
    [self AddNavigationBarTo:_Vfooterback withSelected:@""];
     UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panDetected:)];
    panRecognizer.delegate=self;
    [self.Screenview addGestureRecognizer:panRecognizer];
    [self AddLeftMenuTo:_menuview setSelected:@""];

     NSInvocationOperation *operationloadall=[[NSInvocationOperation alloc]initWithTarget:self selector:@selector(PerFormcourseDetails) object:nil];
     [Coursedetailsoperation addOperation:operationloadall];
}



- (IBAction)PerformDropdown:(id)sender
{
  
    [self PerformGoBack];
}
-(void)OpenreciewList
{
    Numborofreview=0;
    NSArray *arr=[[NSBundle mainBundle] loadNibNamed:@"EtendedDesignView" owner:self options:nil];
    
    ReviewListview=[arr objectAtIndex:16];
    
    UIView *topView=[ReviewListview viewWithTag:200];
    
    UIButton *backButton=(UIButton *)[topView viewWithTag:201];
    
    
    
    [backButton addTarget:self action:@selector(backfuncforcommentView) forControlEvents:UIControlEventTouchUpInside];
    
 
    [ReviewListview setFrame:CGRectMake(0, ReviewListview.frame.size.height, ReviewListview.frame.size.width, ReviewListview.frame.size.height)];
    
    [self.view addSubview:ReviewListview];
    
//    [UIView animateWithDuration:0.2
//     
//                          delay:0.0
//     
//                        options: UIViewAnimationOptionTransitionFlipFromBottom
//     
//                     animations:^
//     
//     {
//         
//         CGRect frame = commentView.frame;
//         
//         frame.origin.y = 0;
//         
//         frame.origin.x = 0;
//         
//         ReviewListview.frame = frame;
//         
//     }
//     
//                     completion:^(BOOL finished)
//     
//     {
//         
//         
//         
//         
//         
//     }];
    
  
    [SVProgressHUD show];
  //  NSInvocationOperation *EventOperation=[[NSInvocationOperation alloc]initWithTarget:self selector:@selector(LoadActivitycomment:) object:[ActivityDic objectForKey:@"ActivityCommentId"]];
   // [ addOperation:EventOperation];
}

-(void)PerFormcourseDetails
{
    @try
    {
        if ([self isConnectedToInternet])
        {
            NSError *error;
            NSString *StrString=[NSString stringWithFormat:@"%@user.php?mode=coursedetails&userid=%@&courseid=%@&loggedin_userid=%@",API,ViewID,CourseID,[self LoggedId]];
            NSLog(@"The value of this url:%@",StrString);
            NSURL *url=[NSURL URLWithString:StrString];
            NSData *data=[NSData dataWithContentsOfURL:url];
            if (data.length>2)
            {
                NSDictionary *MainDic=[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                followUnfollow=[MainDic valueForKey:@"follow_unfollow"];
                NSArray *mainArraycourselist=[MainDic objectForKey:@"courselist"];
                NSDictionary *ClouseListDic=[mainArraycourselist objectAtIndex:0];
                NSArray *Statisticarray=[MainDic objectForKey:@"statisticslist"];
                NSArray *reviewListArry=[MainDic objectForKey:@"reviewlist"];
                NSArray *FollowerList=[MainDic objectForKey:@"followerlist"];
                
                [MainDetailsPageDetails setObject:[ClouseListDic valueForKey:@"courseid"] forKey:@"courseid"];
                [MainDetailsPageDetails setObject:[ClouseListDic valueForKey:@"course_userid"] forKey:@"course_userid"];
                [MainDetailsPageDetails setObject:[ClouseListDic valueForKey:@"course_user_thumb"] forKey:@"course_user_thumb"];
                [MainDetailsPageDetails setObject:[ClouseListDic valueForKey:@"course_name"] forKey:@"course_name"];
                [MainDetailsPageDetails setObject:[ClouseListDic valueForKey:@"street_address"] forKey:@"street_address"];
                [MainDetailsPageDetails setObject:[ClouseListDic valueForKey:@"city"] forKey:@"city"];
                [MainDetailsPageDetails setObject:[ClouseListDic valueForKey:@"state"] forKey:@"state"];
                [MainDetailsPageDetails setObject:[ClouseListDic valueForKey:@"location"] forKey:@"location"];
                [MainDetailsPageDetails setObject:[ClouseListDic valueForKey:@"zip"] forKey:@"zip"];
                [MainDetailsPageDetails setObject:[ClouseListDic valueForKey:@"county"] forKey:@"county"];
                [MainDetailsPageDetails setObject:[ClouseListDic valueForKey:@"country"] forKey:@"country"];
                [MainDetailsPageDetails setObject:[ClouseListDic valueForKey:@"phone"] forKey:@"phone"];
                [MainDetailsPageDetails setObject:[ClouseListDic valueForKey:@"fax_number"] forKey:@"fax_number"];
                [MainDetailsPageDetails setObject:[ClouseListDic valueForKey:@"course_url"] forKey:@"course_url"];
                [MainDetailsPageDetails setObject:[ClouseListDic valueForKey:@"total_holes"] forKey:@"total_holes"];
                [MainDetailsPageDetails setObject:[ClouseListDic valueForKey:@"architects"] forKey:@"architects"];
                [MainDetailsPageDetails setObject:[ClouseListDic valueForKey:@"year_builts"] forKey:@"year_builts"];
                [MainDetailsPageDetails setObject:[ClouseListDic valueForKey:@"course_normal_image"] forKey:@"course_normal_image"];
                [MainDetailsPageDetails setObject:[ClouseListDic valueForKey:@"total_review"] forKey:@"total_review"];
                [MainDetailsPageDetails setObject:[ClouseListDic valueForKey:@"amenities_available"] forKey:@"amenities_available"];
                [MainDetailsPageDetails setObject:[ClouseListDic valueForKey:@"totalfollowers"] forKey:@"totalfollowers"];
                [MainDetailsPageDetails setValue:[ClouseListDic valueForKey:@"useractivetime"] forKey:@"useractivetime"];
                [MainDetailsPageDetails setObject:[ClouseListDic valueForKey:@"average_review"] forKey:@"average_review"];
                [MainDetailsPageDetails setObject:[ClouseListDic valueForKey:@"course_url"] forKey:@"course_url"];
                
                for (NSDictionary *StateDic in Statisticarray)
                {
                    NSMutableDictionary *mutDic=[[NSMutableDictionary alloc]init];
                    [mutDic setValue:[StateDic valueForKey:@"tee_name"] forKey:@"tee_name"];
                    [mutDic setValue:[StateDic valueForKey:@"color_code"] forKey:@"color_code"];
                    [mutDic setValue:[StateDic valueForKey:@"course_tee_rating"] forKey:@"course_tee_rating"];
                    [mutDic setValue:[StateDic valueForKey:@"slope_rating"] forKey:@"slope_rating"];
                    [mutDic setValue:[StateDic valueForKey:@"course_front"] forKey:@"course_front"];
                    
                    [StatisticArry addObject:mutDic];
                }
                for (NSDictionary *ReviewDic in reviewListArry)
                {
                    NSMutableDictionary *mutDic=[[NSMutableDictionary alloc]init];
                    [mutDic setValue:[ReviewDic valueForKey:@"reviewId"] forKey:@"reviewId"];
                    [mutDic setValue:[ReviewDic valueForKey:@"review_user_name"] forKey:@"review_user_name"];
                    [mutDic setValue:[ReviewDic valueForKey:@"review_user_rating"] forKey:@"review_user_rating"];
                    [mutDic setValue:[ReviewDic valueForKey:@"review_time"] forKey:@"review_time"];
                    [mutDic setValue:[ReviewDic valueForKey:@"review"] forKey:@"review"];
                    [mutDic setValue:[ReviewDic valueForKey:@"review_provider"] forKey:@"review_provider"];
                    [ReviewArray addObject:mutDic];
                }
                for (NSDictionary *FollowerDic in FollowerList)
                {
                    NSMutableDictionary *mutDic=[[NSMutableDictionary alloc]init];
                    [mutDic setValue:[FollowerDic valueForKey:@"followers_id"] forKey:@"followers_id"];
                    [mutDic setValue:[FollowerDic valueForKey:@"followers_image"] forKey:@"followers_image"];
                    [mutDic setValue:[FollowerDic valueForKey:@"review_user_rating"] forKey:@"review_user_rating"];
                    [mutDic setValue:[FollowerDic valueForKey:@"followers_name"] forKey:@"followers_name"];
                    [mutDic setValue:[FollowerDic valueForKey:@"followers_status"] forKey:@"followers_status"];
                    [mutDic setValue:[FollowerDic valueForKey:@"followers_friendcount"] forKey:@"followers_friendcount"];
                    [FollowerArray addObject:mutDic];
                }
                [self performSelectorOnMainThread:@selector(loaddataindetailspage) withObject:nil waitUntilDone:YES];
                

            }
            else
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [SVProgressHUD showErrorWithStatus:@"unexpected error occurred"];
                });
            }
            
            
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [SVProgressHUD showErrorWithStatus:@"No internet connection"];
            });
        }
    }
    @catch (NSException *exception)
    {
        NSLog(@"The value of Exception is:%@",exception);
    }
   }


-(void)loaddataindetailspage
{
    
    [_CoursenameLbl setText:[MainDetailsPageDetails valueForKey:@"course_name"]];
    _CourseLocationLBL.text=[MainDetailsPageDetails valueForKey:@"location"];
    _Totalreview.text=[NSString stringWithFormat:@"%@ Reviews",[MainDetailsPageDetails valueForKey:@"total_review"]];
    _TotalFollower.text=[NSString stringWithFormat:@"%@",[MainDetailsPageDetails valueForKey:@"totalfollowers"]];
    _TotalFollower.font=[UIFont fontWithName:SEGIOUI size:20.0f];
    _totalActivationtimeLBL.text=[MainDetailsPageDetails valueForKey:@"useractivetime"];
    if ([followUnfollow integerValue]==1)
    {
         [_FolowerButton setBackgroundImage:[UIImage imageNamed:@"follow-btn"] forState:UIControlStateNormal];
          isFOLLOW=TRUE;
    }
    else
    {
         [_FolowerButton setBackgroundImage:[UIImage imageNamed:@"follow-btn1"] forState:UIControlStateNormal];
          isFOLLOW=FALSE;

    }
    // Download Image in imageview 
    
    NSURLRequest *request_img4 = [NSURLRequest requestWithURL:[NSURL URLWithString:[MainDetailsPageDetails valueForKey:@"course_user_thumb"]]];
    AFImageRequestOperation *operation = [AFImageRequestOperation imageRequestOperationWithRequest:request_img4
                                                                              imageProcessingBlock:nil
                                                                                           success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                                                               if(image!=nil)
                                                                                               {
                                                                                                   
                                                                                                   _userimageview.image=image;
                                                                                                  
                                                                                               }
                                                                                               
                                                                                           }
                                                                                           failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error)
                                          {
                                              NSLog(@"The errorcode:%@",error);
                                              
                                          }];
    [operation start];
    
    //Downloadin back ground image
    
    NSURLRequest *request_img5 = [NSURLRequest requestWithURL:[NSURL URLWithString:[MainDetailsPageDetails valueForKey:@"course_normal_image"]]];
    AFImageRequestOperation *operationBackimage = [AFImageRequestOperation imageRequestOperationWithRequest:request_img5
                                                                              imageProcessingBlock:nil
                                                                                           success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                                                               if(image!=nil)
                                                                                               {
                                                                                                   
                                                                                                   _BackgroundImage.image=image;
                                                                                                   [SVProgressHUD dismiss];
                                                                                                   
                                                                                               }
                                                                                               
                                                                                           }
                                                                                           failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error)
                                          {
                                              NSLog(@"The errorcode:%@",error);
                                              
                                          }];
    [operationBackimage start];
    
   //positioing starratting
    
    NSInteger Starratting=[[MainDetailsPageDetails valueForKey:@"average_review"] integerValue];
    NSLog(@"strr ratting:%d",Starratting);
   TotalFollowingpeople= [[MainDetailsPageDetails valueForKey:@"totalfollowers"] integerValue];
   
    for (int i=0; i<5; i++)
    {
        if (i<Starratting)
        {
            NSLog(@"The value of star:");
            UIImageView *imageStare=[[UIImageView alloc] initWithFrame:CGRectMake(94+(16*i), 130, 15, 14)];
            [imageStare setImage:[UIImage imageNamed:@"star"]];
            [self.Mainviewback addSubview:imageStare];
        }
        else
        {
            UIImageView *imageStare=[[UIImageView alloc] initWithFrame:CGRectMake(94+(16*i), 130, 15, 14)];
            [imageStare setImage:[UIImage imageNamed:@"starnot"]];
             [self.Mainviewback addSubview:imageStare];
        }
    }
    [SVProgressHUD dismiss];
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)FollowUnfollowBTn:(id)sender
{
    if (isFOLLOW==TRUE)
    {
        
        [_FolowerButton setBackgroundImage:[UIImage imageNamed:@"follow-btn1"] forState:UIControlStateNormal];
        isFOLLOW=FALSE;
         NSInvocationOperation *Invocationoperation=[[NSInvocationOperation alloc]initWithTarget:self selector:@selector(Followingnow:) object:@"1"];
        [Coursedetailsoperation addOperation:Invocationoperation];
        
    }
    else
    {
         // _TotalFollower.text=[NSString stringWithFormat:@"%d",(TotalFollowingpeople+1)];
        [_FolowerButton setBackgroundImage:[UIImage imageNamed:@"follow-btn"] forState:UIControlStateNormal];
          isFOLLOW=TRUE;
        NSInvocationOperation *Invocationoperation=[[NSInvocationOperation alloc]initWithTarget:self selector:@selector(Followingnow:) object:@"0"];
        [Coursedetailsoperation addOperation:Invocationoperation];
  
    }
}

//Follow un follow button
-(void)Followingnow:(NSString *)followdata
{
    NSString *followurl=[NSString stringWithFormat:@"%@user.php?mode=course_follow&userid=%@&courseid=%@&myoption=%@",API,[self LoggedId],[MainDetailsPageDetails valueForKey:@"courseid"],followdata];
    NSLog(@"The value follow unfollow string:%@",followurl);
    NSData *Data= [NSData dataWithContentsOfURL:[NSURL URLWithString:followurl]];
    NSDictionary *MainDic=[NSJSONSerialization JSONObjectWithData:Data options:kNilOptions error:nil];
    NSDictionary *Extraparam=[MainDic valueForKey:@"extraparam"];
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *message=[Extraparam valueForKey:@"message"];
        NSString *Responce=[Extraparam valueForKey:@"response"];
        if ([Responce isEqualToString:@"success"])
        {
            [SVProgressHUD showSuccessWithStatus:message];
            if (isFOLLOW==FALSE)
            {
                 _TotalFollower.text=[NSString stringWithFormat:@"%d",(TotalFollowingpeople-1)];
            }
            else
            {
              _TotalFollower.text=[NSString stringWithFormat:@"%d",TotalFollowingpeople];
            }
          
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:message];
        }
    });
    
}

//Show over view

- (IBAction)overviewbuttonclick:(id)sender
{
    
    TTTCourseOverviewViewController *courseOverview=[[TTTCourseOverviewViewController alloc]init];
    courseOverview.overviewlist=MainDetailsPageDetails;
    [self presentViewController:courseOverview animated:YES completion:^{
        [SVProgressHUD dismiss];
    }];
}

//Statistic button

- (IBAction)StatisticButtonClick:(id)sender
{
    
    TTTCourseStatisticView *statisticview=[[TTTCourseStatisticView alloc]init];
    statisticview.CoursesatisticArray=[StatisticArry copy];
    [self presentViewController:statisticview animated:YES completion:^{
        [SVProgressHUD dismiss];
    }];
    
}
- (IBAction)ReviewSbutton:(id)sender
{
    TTTCourseReviewViewController *coursereview=[[TTTCourseReviewViewController alloc]init];
    coursereview.reviewarraylist=ReviewArray;
    coursereview.courseid=CourseID;
    [self PushViewController:coursereview TransitationFrom:kCATransitionFromTop];
    
    
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
            
            stopLocation = [panRecognizer translationInView:_Screenview];
            
            CGRect frame=[_Screenview frame];
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
                        _Screenview.frame=frame;
                        
                    }];
                    
                }
                else
                {
                    NSLog(@"close satisfied");
                    IsLeftMenuBoxOpen=YES;
                    isFastLocation=TRUE;
                    CGRect lastFrame=[_Screenview frame];
                    lastFrame.origin.x=260;
                    [UIView animateWithDuration:.5 animations:^{
                        _Screenview.frame=lastFrame;
                        
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
                        _Screenview.frame=frame;
                        
                    }];
                    
                }
                else
                {
                    NSLog(@"close satisfied");
                    IsLeftMenuBoxOpen=NO;
                    islastlocation=TRUE;
                    CGRect lastFrame2=[_Screenview frame];
                    lastFrame2.origin.x=0;
                    [UIView animateWithDuration:.5 animations:^{
                        _Screenview.frame=lastFrame2;
                        
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
                CGRect framelast=[_Screenview frame];
                framelast.origin.x=0;
                
                
                [UIView animateWithDuration:.6 animations:^{
                    _Screenview.frame=framelast;
                    
                }];
            }
            
            if (stopLocation.x*-1<100.0f&isFastLocation==TRUE&IsLeftMenuBoxOpen==YES)
            {
                NSLog(@"Left Menu opened%f",stopLocation.x);
                
                CGRect framelast=[_Screenview frame];
                framelast.origin.x=260;
                
                
                [UIView animateWithDuration:.6 animations:^{
                    _Screenview.frame=framelast;
                    
                }];
                
            }
            
            
        }
        
    }
    
}


-(void)PerformChatSliderOperation
{
    
    IsChatMenuBoxOpen=[self PerformChatSlider:_Screenview withChatArea:self.ChatSliderView IsOpen:IsChatMenuBoxOpen];
    NSLog(@"PerformChatSliderOperation %@",IsChatMenuBoxOpen?@"YES":@"NO");
    
}
- (IBAction)TotalFollowerlist:(id)sender
{
    TTTFollowerlistviewController *folloewlist=[[TTTFollowerlistviewController alloc]init];
    folloewlist.CourseREviewID=CourseID;
  
    [self PushViewController:folloewlist WithAnimation:kCATransitionFade];
//    [self presentViewController:folloewlist animated:YES completion:^{
//        [SVProgressHUD dismiss];
//    }];
}
@end
