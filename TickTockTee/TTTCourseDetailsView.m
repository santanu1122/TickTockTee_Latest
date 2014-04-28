
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
#import "TTTCellForCourseReview.h"


@interface TTTCourseDetailsView ()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate>
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
    UITableView *ReviewList;
    NSMutableArray *reviewListarry;
    CGFloat height;
    BOOL slideup,IScancelButtonclick,isfinish,clickcancel;
    int Addallrating;
    UIView *AddNewReviewView;
    NSString *MyString;
    NSString *viewerID;
    UIView *FooterView;
    

    
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

@property (strong, nonatomic)  UILabel *reviewOptionLbl;
@property (strong, nonatomic)  UIView *ScreenView;
@property (strong, nonatomic)  UIView *footerview;
@property (strong, nonatomic)  UITextView *writereview;
@property (strong, nonatomic)  UIButton *star1;
@property (strong, nonatomic)  UIButton *star2;
@property (strong, nonatomic)  UIButton *star3;
@property (strong, nonatomic)  UIButton *star4;
@property (strong, nonatomic)  UIButton *star5;
@property (strong, nonatomic)  UILabel *instruction;
@property (weak, nonatomic)    UIButton *ButtonDon;


@end

@implementation TTTCourseDetailsView
@synthesize ParamViewerid,CourseID,ChatSliderView,FooterBackgroundimage,writereview;

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
    height=0.0f;
    
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
    
     viewerID=([ParamViewerid length]>0)?ParamViewerid:[self LoggedId];
    
     [self AddLeftMenuTo:_menuview setSelected:@""];
     reviewListarry=[[NSMutableArray alloc] init];
    
     NSInvocationOperation *operationloadall=[[NSInvocationOperation alloc]initWithTarget:self selector:@selector(PerFormcourseDetails) object:nil];
     [Coursedetailsoperation addOperation:operationloadall];
}


//----------------- Review Listing page -------------//
-(void)ShowallreviewList
{
    @try
    {
        NSError *error;
        NSString *str=[NSString stringWithFormat:@"%@user.php?mode=coursedetailsreview&userid=%@&courseid=%@",API,[self LoggedId],CourseID];
        NSURL *url=[NSURL URLWithString:str];
        NSData *data=[NSData dataWithContentsOfURL:url];
        if (data.length>2)
        {
            NSDictionary *MainDic=[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            NSDictionary *reviewListArry=[MainDic valueForKey:@"reviewlist"];
           
            for (NSDictionary *ReviewDic in reviewListArry)
            {
                NSMutableDictionary *mutDic=[[NSMutableDictionary alloc]init];
                [mutDic setValue:[ReviewDic valueForKey:@"reviewId"] forKey:@"reviewId"];
                [mutDic setValue:[ReviewDic valueForKey:@"review_user_name"] forKey:@"review_user_name"];
                [mutDic setValue:[ReviewDic valueForKey:@"review_user_rating"] forKey:@"review_user_rating"];
                [mutDic setValue:[ReviewDic valueForKey:@"review_time"] forKey:@"review_time"];
                [mutDic setValue:[ReviewDic valueForKey:@"review"] forKey:@"review"];
                [mutDic setValue:[ReviewDic valueForKey:@"review_provider"] forKey:@"review_provider"];
                [reviewListarry addObject:mutDic];
            }
            [self performSelectorOnMainThread:@selector(reloadteble) withObject:nil waitUntilDone:YES];
        }
    }

     @catch (NSException *exception)
      {
        NSLog(@"The valureo of Exception:%@ %@",[exception name],exception);
      }
}
    
-(void)reloadteble
{
    [SVProgressHUD dismiss];
    [ReviewList reloadData];
}




- (IBAction)PerformDropdown:(id)sender
{
  [self PerformGoBack];
}


-(void)OpenreciewList
{
    NSArray *arr=[[NSBundle mainBundle] loadNibNamed:@"EtendedDesignView" owner:self options:nil];
    
    ReviewListview=[arr objectAtIndex:17];
    
    UIView *topView=[ReviewListview viewWithTag:200];
    
    UIButton *backButton=(UIButton *)[topView viewWithTag:500];
    [backButton addTarget:self action:@selector(backfuncforcommentView) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *EditButton=(UIButton *)[topView viewWithTag:502];
    
    [EditButton addTarget:self action:@selector(AddNewRiviewButton) forControlEvents:UIControlEventTouchUpInside];
    
    
 
    [ReviewListview setFrame:CGRectMake(0, ReviewListview.frame.size.height, ReviewListview.frame.size.width, ReviewListview.frame.size.height)];
    
    [self.view addSubview:ReviewListview];
    
    ReviewList=(UITableView *)[ReviewListview viewWithTag:503];
    ReviewList.delegate=self;
    ReviewList.dataSource=self;
    [ReviewList setBackgroundColor:[UIColor clearColor]];
    
    
    [UIView animateWithDuration:0.2
     
                          delay:0.0
     
                        options: UIViewAnimationOptionTransitionFlipFromBottom
     
                     animations:^
     
     {
         
         CGRect frame = ReviewListview.frame;
         
         frame.origin.y = 0;
         
         frame.origin.x = 0;
         
         ReviewListview.frame = frame;
         
     }
     
     completion:^(BOOL finished)
     
     {
         
    }];
    
    [reviewListarry removeAllObjects];
    [SVProgressHUD show];
    NSInvocationOperation *CommentInvication=[[NSInvocationOperation alloc]initWithTarget:self selector:@selector(ShowallreviewList) object:nil];
    [Coursedetailsoperation addOperation:CommentInvication];
    

}



-(void) backfuncforcommentView

{
    
    [UIView animateWithDuration:0.3
     
                          delay:0.0
     
                        options: UIViewAnimationOptionTransitionFlipFromTop
     
                     animations:^
     
      {
         
         CGRect frame = ReviewListview.frame;
         
         frame.origin.y =ReviewListview.frame.size.height;
         
         frame.origin.x = 0;
         
         ReviewListview.frame = frame;
         
      }
     
                     completion:^(BOOL finished)
     
      {
         
         
         
         
         
     }];
    
    
    
}

//----------- Add new review -------//

-(void)AddNewRiviewButton
{
    [self OpenCommentarray];
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

    [self OpenreciewList];
    
    
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
}

// ------ Tableview methods ------- //
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [reviewListarry count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITextView *reviewtxt=[[UITextView alloc]initWithFrame:CGRectMake(15, 70, 295, 30)];
    reviewtxt.font=[UIFont fontWithName:MYRIARDPROLIGHT size:15.0f];
    reviewtxt.textColor=[UIColor whiteColor];
    reviewtxt.textAlignment=NSTextAlignmentLeft;
    [reviewtxt setEditable:NO];
    reviewtxt.text =[NSString stringWithFormat:@"                   %@",[[reviewListarry objectAtIndex:indexPath.row]valueForKey:@"review"]];
  
    
    NSAttributedString *Attributed=[[NSAttributedString alloc]initWithString:reviewtxt.text attributes:@{
                                                                                                         
                                                                                                         NSFontAttributeName : [UIFont fontWithName:MYRIARDPROLIGHT size:15.0f],
                                                                                                         NSForegroundColorAttributeName : [UIColor whiteColor]
                                                                                                         }];
    
    
    
    [reviewtxt setAttributedText:Attributed];
    
    CGSize newSize = [reviewtxt sizeThatFits:CGSizeMake(295, MAXFLOAT)];
    CGFloat Extraheight=0.0f;
    if (newSize.height>30)
    {
        CGRect frame=[reviewtxt frame];
        Extraheight=newSize.height-30;
        frame.size.height+=Extraheight;
        [reviewtxt setFrame:frame];
    }
    
    height+=102+Extraheight;

    return 102+Extraheight;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TTTCellForCourseReview *cell=(TTTCellForCourseReview *)[tableView dequeueReusableCellWithIdentifier:nil];
    
    if (cell==nil)
    {
        NSArray *arr=[[NSBundle mainBundle]loadNibNamed:@"TTTCellForCourseReview" owner:self options:nil];
        
        cell=[arr objectAtIndex:0];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    cell.sendername.font=[UIFont fontWithName:MYRIARDPROSAMIBOLT size:18.0];
    
    cell.sendername.text=[[reviewListarry objectAtIndex:indexPath.row]valueForKey:@"review_user_name"];
    cell.review.font=[UIFont fontWithName:MYRIARDPROLIGHT size:15.0f];
    cell.time.font=[UIFont fontWithName:MYRIARDPROLIGHT size:13.0f];
    cell.time.text=[[reviewListarry objectAtIndex:indexPath.row]valueForKey:@"review_time"];
    [self SetroundborderWithborderWidth:2.0f WithColour:[UIColor whiteColor] ForView:cell.viewOnsenderimage];
    
    
    [self SetroundborderWithborderWidth:2.0f WithColour:[UIColor clearColor] ForImageview:cell.senderimage];
    
    NSString *BackgroundImageStgring=[[reviewListarry objectAtIndex:indexPath.row]valueForKey:@"review_provider"];
    
    
    
    NSURLRequest *request_img = [NSURLRequest requestWithURL:[NSURL URLWithString:BackgroundImageStgring]];
    AFImageRequestOperation *operation = [AFImageRequestOperation imageRequestOperationWithRequest:request_img
                                                                              imageProcessingBlock:nil
                                                                                           success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                                                               if(image!=nil)
                                                                                               {
                                                                                                   [cell.senderimage setImage:image];
                                                                                                   [cell.spinner stopAnimating];
                                                                                                   [cell.spinner setHidden:YES];
                                                                                               }
                                                                                               
                                                                                           }
                                                                                           failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                                                                               NSLog(@"Error %@",error);
                                                                                               [cell.spinner stopAnimating];
                                                                                               [cell.spinner setHidden:YES];
                                                                                               
                                                                                               
                                                                                           }];
    [operation start];
    
    
    
    
    int rating=[[[reviewListarry objectAtIndex:indexPath.row]valueForKey:@"review_user_rating"]intValue];
    NSLog(@"The value of ratting:%d",rating);
    for(int i=0; i<rating;  i++)
    {
        UIImageView *star=(UIImageView *)[cell.starView viewWithTag:100+i];
        [star setHidden:NO];
    }
    cell.review.textColor=[UIColor whiteColor];
    cell.review.backgroundColor=[UIColor clearColor];
    cell.review.textAlignment=NSTextAlignmentLeft;
    cell.review.delegate=self;
    cell.review.scrollEnabled=NO;
    [cell.review setEditable:NO];
    cell.review.text =[NSString stringWithFormat:@"                   %@",[[reviewListarry objectAtIndex:indexPath.row]valueForKey:@"review"]];
    
    NSAttributedString *Attributed=[[NSAttributedString alloc]initWithString:cell.review.text attributes:@{
                                                                                                           NSFontAttributeName :[UIFont fontWithName:MYRIARDPROLIGHT size:15.0f],
                                                                                                           NSForegroundColorAttributeName :[UIColor whiteColor]
                                                                                                           }];
    
    [cell.review setAttributedText:Attributed];
    
    CGSize newSize = [cell.review sizeThatFits:CGSizeMake(295, MAXFLOAT)];
    CGFloat Extraheight=0.0f;
    if (newSize.height>30)
    {
        CGRect frame=[cell.review frame];
        
        Extraheight=newSize.height-30;
        frame.size.height+=Extraheight;
        
        
        [cell.review setFrame:frame];
         cell.review.scrollEnabled=YES;
    }
    // Change the size of cell frame according to the textfield text
    
    CGRect Celframe=[cell.BackView frame];
    Celframe.size.height+=Extraheight;
    [cell.BackView setFrame:Celframe];
    
    return cell;
    
    
}
// --------- open addreview portion -----------//

-(void)OpenCommentarray
{
    NSLog(@"-----open comment area-----");
    
    Numborofreview=0;
    
    NSArray *arr=[[NSBundle mainBundle] loadNibNamed:@"EtendedDesignView" owner:self options:nil];
    
    AddNewReviewView=[arr objectAtIndex:18];
     UIView *topView=[AddNewReviewView viewWithTag:1000];
   
    
    UIButton *backButton=(UIButton *)[topView viewWithTag:1001];
    
    [backButton addTarget:self action:@selector(backtoreviewdetils) forControlEvents:UIControlEventTouchUpInside];
    NSDate *now = [NSDate date];
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"MMM d ,yyyy"];
	MyString = [dateFormatter stringFromDate:now];
   
    _star1=(UIButton *)[AddNewReviewView viewWithTag:100];
    _star2=(UIButton *)[AddNewReviewView viewWithTag:101];
    _star3=(UIButton *)[AddNewReviewView viewWithTag:102];
    _star4=(UIButton *)[AddNewReviewView viewWithTag:103];
    _star5=(UIButton *)[AddNewReviewView viewWithTag:104];
	writereview=(UITextView *)[AddNewReviewView viewWithTag:401];
   
    Addallrating=0;
    [_star1 addTarget:self action:@selector(rating:) forControlEvents:UIControlEventTouchUpInside];
    _star1.tag=100;
    [_star2 addTarget:self action:@selector(rating:) forControlEvents:UIControlEventTouchUpInside];
    _star2.tag=101;
    [_star3 addTarget:self action:@selector(rating:) forControlEvents:UIControlEventTouchUpInside];
    _star3.tag=102;
    [_star4 addTarget:self action:@selector(rating:) forControlEvents:UIControlEventTouchUpInside];
    _star4.tag=103;
    [_star5 addTarget:self action:@selector(rating:) forControlEvents:UIControlEventTouchUpInside];
    _star5.tag=104;
    
    
    
    
      writereview.font=[UIFont fontWithName:MYREADPROREGULAR size:15];
      self.reviewOptionLbl=(UILabel *)[AddNewReviewView viewWithTag:402];
    
      self.reviewOptionLbl.font=[UIFont fontWithName:MYREADPROREGULAR size:15];
      writereview.delegate=self;
    
      FooterView=(UIView *)[AddNewReviewView viewWithTag:403];
      UIButton *Cancelbutton=(UIButton *)[FooterView viewWithTag:404];
      [Cancelbutton addTarget:self action:@selector(CAncelbuttonwork) forControlEvents:UIControlEventTouchUpInside];
     _ButtonDon=(UIButton *)[FooterView viewWithTag:405];
     [_ButtonDon addTarget:self action:@selector(DoneeventClick) forControlEvents:UIControlEventTouchUpInside];
    
    //---------------The added -----------//
    
    [AddNewReviewView setFrame:CGRectMake(0, AddNewReviewView.frame.size.height, AddNewReviewView.frame.size.width, AddNewReviewView.frame.size.height)];
    
    [self.view addSubview:AddNewReviewView];
    
    
    [UIView animateWithDuration:0.2
     
                          delay:0.0
     
                        options: UIViewAnimationOptionTransitionFlipFromBottom
     
                     animations:^
     
     {
         
         CGRect frame = AddNewReviewView.frame;
         
         frame.origin.y = 0;
         
         frame.origin.x = 0;
         
         AddNewReviewView.frame = frame;
         
     }
     
                     completion:^(BOOL finished)
     
     {
         
     }];
    

  
}
-(void)DoneeventClick
{
    slideup=TRUE;
    [self slidefooterview];
    
    if([[writereview.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0){
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self clearrating];
            [SVProgressHUD showErrorWithStatus:@"Please write a review"];
        });
    }
    else if (!Addallrating >0)
    {
        [SVProgressHUD showErrorWithStatus:@"Please add rating"];
    }
    else
    {
        NSInvocationOperation *operation=[[NSInvocationOperation alloc]initWithTarget:self selector:@selector(postreview) object:nil];
        [Coursedetailsoperation addOperation:operation];
    }

    
}

-(void)CAncelbuttonwork
{
    slideup=TRUE;
    IScancelButtonclick=TRUE;
    [self clearrating];
    [self slidefooterview];
    [self backtoreviewdetils];
   
 
}

//load footerview

-(void)slidefooterview
{
    if(slideup==FALSE){
        [UIView animateWithDuration:.1f animations:^{
            
            CGRect rect1 = FooterView.frame;
            rect1.origin.y=302;
            FooterView.frame = rect1;
            
        }];
    }
    else
    {
        [UIView animateWithDuration:.1f animations:^{
            CGRect rect1 = FooterView.frame;
            if(IsIphone5){
                rect1.origin.y=519;
            }else{
                rect1.origin.y=431;
            }
            FooterView.frame = rect1;
        }
        completion:^(BOOL finish)
         {
             [writereview resignFirstResponder];
             
         }];
    }
    
}

-(void)backtoreviewdetils
{
    
    [self.writereview resignFirstResponder];
    [UIView animateWithDuration:0.3
     
                          delay:0.0
     
                        options: UIViewAnimationOptionTransitionFlipFromTop
     
                     animations:^
     
     {
         
         CGRect frame = AddNewReviewView.frame;
         
         frame.origin.y =AddNewReviewView.frame.size.height;
         
         frame.origin.x = 0;
         
         AddNewReviewView.frame = frame;
         
     }
     
                     completion:^(BOOL finished)
     
     {
         
         
         
         
         
     }];
    
 
}


//-------------- Add Review ----------//
-(void)postreview
{
   
      if ([self isConnectedToInternet])
        {
            NSError *Error;
            @try
            {
                NSString *URL=[NSString stringWithFormat:@"%@user.php?mode=course_review&userid=%@&courseid=%@&msg=%@&rating=%d", API,viewerID,CourseID,[[writereview.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],Addallrating];
                NSLog(@"%@", URL);
                
                NSData *data=[NSData dataWithContentsOfURL:[NSURL URLWithString:URL]];
                if([data length]>0)
                {
                    NSDictionary * OutputDic=[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&Error];
                    
                    if ([OutputDic isKindOfClass:[NSDictionary class]]){
                        NSDictionary *extraparam=[OutputDic valueForKey:@"extraparam"];
                        if ([extraparam isKindOfClass:[NSDictionary class]]){
                            if([[extraparam valueForKey:@"response"] isEqualToString:@"success"])
                            {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    
                                    
                                    [SVProgressHUD showSuccessWithStatus:[extraparam valueForKey:@"message"]];
                                    NSMutableDictionary *MutDicall=[[NSMutableDictionary alloc]init];
                                    Numborofreview+=1;
                                    [MutDicall setValue:@"500" forKey:@"reviewId"];
                                    [MutDicall setValue:[self LoggerName] forKey:@"review_user_name"];
                                    [MutDicall setValue:[self LoggerImageURL] forKey:@"review_provider"];
                                    [MutDicall setValue:writereview.text forKey:@"review"];
                                    [MutDicall setValue:MyString forKey:@"review_time"];
                                    [MutDicall setValue:[NSString stringWithFormat:@"%d",Addallrating] forKey:@"review_user_rating"];
                                    [reviewListarry insertObject:MutDicall atIndex:0];
                                    NSIndexPath *Indexpath=[NSIndexPath indexPathForRow:0 inSection:0];
                                    [ReviewList beginUpdates];
                                    [ReviewList insertRowsAtIndexPaths:[[NSArray alloc] initWithObjects:Indexpath, nil] withRowAnimation:UITableViewRowAnimationFade];
                                    [ReviewList endUpdates];
                                    
                                    // --- TOTAL RTEVIEW LIST -- //
                                    
                                    [_Totalreview setText:[NSString stringWithFormat:@"%d Reviews",[reviewListarry count]]];
                                    [self clearrating];
                                    [self backtoreviewdetils];
                                    
                                    
                                });
                            }else
                            {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    
                                    [SVProgressHUD showErrorWithStatus:[extraparam valueForKey:@"message"]];
                                });
                                
                                
                            }
                        }
                        else
                        {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                
                                [SVProgressHUD showErrorWithStatus:@"Unexpected error occured."];
                                
                            });
                        }
                    }
                    else
                    {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            [SVProgressHUD showErrorWithStatus:@"Unexpected error occured."];
                            
                        });
                    }
                }
                
            }@catch (NSException *exception) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [SVProgressHUD showErrorWithStatus:@"Unexpected error occured."];
                    
                });
                
                NSLog(@" %s exception %@",__PRETTY_FUNCTION__,exception);
            }
            
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:@"No internet connection"];
        }
    
    
}

//--- course review ----//

-(void)rating:(UIButton *)sender
{
    Addallrating=0;
    int tapbutton=sender.tag-100;
    NSLog(@"The value of touich button:%d",tapbutton);
    NSLog(@"the value of sender.couuent image:%@",sender.currentBackgroundImage);
    if([sender.currentBackgroundImage isEqual:[UIImage imageNamed:@"starnotBig"]])
    {
    
        for(int i=0;i<tapbutton+1;i++)
        {
            UIButton *Star=(UIButton *)[AddNewReviewView viewWithTag:100+i];
            
               [Star setBackgroundImage:[UIImage imageNamed:@"starbig"] forState:UIControlStateNormal];
               // Addallrating++;
        
        }
    }
    else if ([sender.currentBackgroundImage isEqual:[UIImage imageNamed:@"starbig"]])
    {
      
        
        for(int i=tapbutton;i<5;i++)
        {
            UIButton *Star1=(UIButton *)[AddNewReviewView viewWithTag:100+i];
            if([Star1.currentBackgroundImage isEqual:[UIImage imageNamed:@"starbig"]])
            {
                [Star1 setBackgroundImage:[UIImage imageNamed:@"starnotBig"] forState:UIControlStateNormal];
                 //Addallrating++;
            }
            
        }
    }
    
    for (int k=0; k<5; k++)
    {
        UIButton *Button=(UIButton *)[AddNewReviewView viewWithTag:100+k];
        if ([Button.currentBackgroundImage isEqual:[UIImage imageNamed:@"starbig"]])
        {
            Addallrating++;
        }
        
    }
    
    NSLog(@"Trhe value of add%d",Addallrating);
    if(Addallrating>0)
    {
        
        [[self ButtonDon] setBackgroundImage:[UIImage imageNamed:@"donegreen"] forState:UIControlStateNormal];
        
        [[self ButtonDon] setBackgroundImage:[UIImage imageNamed:@"donegreen"] forState:UIControlStateHighlighted];
        
        [[self ButtonDon] setBackgroundImage:[UIImage imageNamed:@"donegreen"] forState:UIControlStateSelected];
        
    }else{
        
        [[self ButtonDon] setBackgroundImage:[UIImage imageNamed:@"doneLocation"] forState:UIControlStateNormal];
        
        [[self ButtonDon] setBackgroundImage:[UIImage imageNamed:@"doneLocation"] forState:UIControlStateHighlighted];
        
        [[self ButtonDon] setBackgroundImage:[UIImage imageNamed:@"doneLocation"] forState:UIControlStateSelected];
        
    }
    
  
}


- (void)textViewDidBeginEditing:(UITextView *)textView
{
    slideup=FALSE;
    [self slidefooterview];
    [self.reviewOptionLbl setHidden:YES];
    //[textView becomeFirstResponder];
}
#pragma UITextViewDelegate
- (void)textViewDidEndEditing:(UITextView *)textView
{
    slideup=TRUE;
    [self slidefooterview];
    if (!textView.text.length>0)
    {
        self.reviewOptionLbl.hidden=NO;
    }
    
    [textView resignFirstResponder];
}

-(void)clearrating
{
    for(int i=0;i<5;i++){
        UIButton *star=(UIButton *)[AddNewReviewView viewWithTag:100+i];
        if([star.currentBackgroundImage isEqual:[UIImage imageNamed:@"starbig"]])
        {
            [star setBackgroundImage:[UIImage imageNamed:@"starnotBig"] forState:UIControlStateNormal];
            Addallrating--;
        }
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    
    
    if([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        
        return NO;
    }
    
    return YES;
}




@end
