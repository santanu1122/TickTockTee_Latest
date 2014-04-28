//
//  TTTStatisticsViewController.m
//  TickTockTee
//
//  Created by Esolz_Mac on 22/03/14.
//  Copyright (c) 2014 com.esolz.TickTockTee. All rights reserved.
//

#import "TTTStatisticsViewController.h"
#import "SVProgressHUD.h"
#import "TTTAchievementDetailsViewController.h"
#import "TTTAchievementStatisticViewController.h"
#import "SGSLineGraphView.h"
#import "TTTroundlistViewController.h"
#import "TTTHandicaptViewController.h"
#import "TTTProfileViewController.h"
@interface TTTStatisticsViewController ()<UIGestureRecognizerDelegate>
{
    BOOL IsLeftMenuBoxOpen,Ishoveropen,IsChatMenuBoxOpen;
    TTTGlobalMethods *Method;
    NSMutableData *statisticData;
    NSMutableArray *statisticArray;
    NSMutableArray *round_arr,*scoring_arr,*par_arr;
    BOOL ISdropdownOpen;
    
    UIActivityIndicatorView *grayIndicator;
    NSString *ViewID;
    BOOL isFastLocation;
    BOOL islastlocation;
}
@property (weak, nonatomic) IBOutlet UIButton *BackButtonClick;
@property (weak, nonatomic) IBOutlet UIButton *ManubuttonClick;
@property (strong, nonatomic) IBOutlet UIView *chatBoxView;


@end

@implementation TTTStatisticsViewController
@synthesize statistic_table = _statistic_table;
@synthesize GraphView       = _GraphView;
@synthesize GraphViewLabelOne   = _GraphViewLabelOne;
@synthesize GraphViewLabelTwo   = _GraphViewLabelTwo;
@synthesize statistic_data      = _statistic_data;
@synthesize MainScrollView      = _MainScrollView;
@synthesize popupview=_popupview;
@synthesize BackButtonClick, ManubuttonClick,paramviewID;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
          self=(IsIphone5)?[super initWithNibName:@"TTTStatisticsViewController" bundle:nil]:[super initWithNibName:@"TTTStatisticsViewController_iPhone4" bundle:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"Failed with Error---");
    IsChatMenuBoxOpen=FALSE;
    IsLeftMenuBoxOpen=FALSE;
    Ishoveropen=FALSE;
    ISdropdownOpen=FALSE;
   _page_title.font = [UIFont fontWithName:@"MyriadPro-regular" size:20.0];
    //_lineGraphView=[[SGSLineGraphView alloc]init];
    
    [_footerView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bottom-bar2"]]];
    
    IsLeftMenuBoxOpen=FALSE;
    //Parm vaiew id
    ViewID=(paramviewID.length>0)?paramviewID:[self LoggedId];
    if (paramviewID.length>0)
    {
        self.ManubuttonClick.hidden=YES;
        self.BackButtonClick.hidden=NO;
    }
    else
    {
        self.ManubuttonClick.hidden=NO;
        self.BackButtonClick.hidden=YES;
        UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panDetected:)];
        panRecognizer.delegate=self;
        [self.ScreenView addGestureRecognizer:panRecognizer];
    }
    
    [_footerView setFrame:CGRectMake(0, (568 - _footerView.frame.size.height), _footerView.frame.size.width, _footerView.frame.size.height)];
     (!IsIphone5)?[_footerView setFrame:CGRectMake(0, (480 - _footerView.frame.size.height), _footerView.frame.size.width, _footerView.frame.size.height)]:[_footerView setFrame:CGRectMake(0, (568 - _footerView.frame.size.height), _footerView.frame.size.width, _footerView.frame.size.height)];
    [self.view bringSubviewToFront:_footerView];
    [self AddNavigationBarTo:_footerView withSelected:@""];
    [self.ScreenView addSubview:_footerView];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    self.navigationController.navigationBar.hidden=YES;
    [self.navigationController.navigationBar setBackgroundColor:[UIColor whiteColor]];
    
    _MainScrollView=[[UIScrollView alloc]init];
    if(IsIphone5)
    _MainScrollView.frame=CGRectMake(0,64,320,480-25);
    else
     _MainScrollView.frame=CGRectMake(0,64,320,480-125);
    
    _MainScrollView.showsVerticalScrollIndicator=YES;
    _MainScrollView.scrollEnabled=YES;
    _MainScrollView.userInteractionEnabled=YES;
    _MainScrollView.contentSize = CGSizeMake(320,1100);
    
    [_ScreenView addSubview:_MainScrollView];
    
    grayIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [grayIndicator setCenter:CGPointMake(_GraphView.layer.frame.size.width/2.0, (20+_GraphView.layer.frame.size.height)/2.0)];
    [_MainScrollView addSubview:grayIndicator];
    [grayIndicator startAnimating];
    
   
    
    // add graphview
    
    
    [_GraphView setFrame:CGRectMake(0, 15, _GraphView.layer.frame.size.width, _GraphView.layer.frame.size.height)];
   
    [_actionView setFrame:CGRectMake(0, _GraphView.layer.frame.size.height-28, _actionView.layer.frame.size.width, _actionView.layer.frame.size.height)];
    
    
    
    
    [_dataView setFrame:CGRectMake(0,_GraphView.frame.origin.x+_GraphView.frame.size.height+_actionView.layer.frame.size.height-28, _dataView.layer.frame.size.width, _dataView.layer.frame.size.height)];
    [_MainScrollView addSubview:_actionView];
    [_MainScrollView addSubview:_dataView];
   
    
    NSString *stringurl = [NSString stringWithFormat:@"%@user.php?mode=StatOverview&userid=%@&loggedin_userid=%@", API,ViewID,[self LoggedId]];
    NSLog(@"stringurl---%@",stringurl);
    NSURL *url = [NSURL URLWithString:stringurl];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:req delegate:self];
    
    if (connection)
    {
        statisticData = [[NSMutableData alloc]init];
    }
    
   // NSLog(@"Failed2 with Error---");

}
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    statisticData.length=0;
    
}




-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [statisticData appendData:data];
}


-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"Failed with Error---");
}


-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSArray *arr = [NSJSONSerialization JSONObjectWithData:statisticData options:0 error:nil];
    NSLog(@"the value of array:%@",arr);
    
    
    UILabel *label13= (UILabel *) [_GraphView viewWithTag:252];
    label13.text = [NSString stringWithFormat:@"%@'S STATISTICS",[[arr valueForKey:@"Profile"] uppercaseString]];
    label13.textColor=[UIColor whiteColor];
    label13.font=[UIFont fontWithName:MYREADPROREGULAR size:15.0];
    
    UILabel *label1 = (UILabel *) [_GraphView viewWithTag:251];
    
    label1.text =[NSString stringWithFormat:@"Since %@", [arr valueForKey:@"Activesince"]];
    label1.textColor=[UIColor whiteColor];
    label1.font=[UIFont fontWithName:MYRIARDPROLIGHT size:13.0];
    
    UILabel *leftLabel1= (UILabel *) [_dataView viewWithTag:106];
    leftLabel1.font=[UIFont fontWithName:MYREADPROREGULAR size:13.0];
    UILabel *leftLabel2= (UILabel *) [_dataView viewWithTag:109];
    leftLabel2.font=[UIFont fontWithName:MYREADPROREGULAR size:13.0];
    
    UILabel *leftLabel3= (UILabel *) [_dataView viewWithTag:118];
    leftLabel3.font=[UIFont fontWithName:MYREADPROREGULAR size:13.0];
    UILabel *leftLabel4= (UILabel *) [_dataView viewWithTag:122];
    leftLabel4.font=[UIFont fontWithName:MYREADPROREGULAR size:13.0];
    UILabel *leftLabel5= (UILabel *) [_dataView viewWithTag:126];
    leftLabel5.font=[UIFont fontWithName:MYREADPROREGULAR size:13.0];
    UILabel *leftLabel6= (UILabel *) [_dataView viewWithTag:130];
    leftLabel6.font=[UIFont fontWithName:MYREADPROREGULAR size:13.0];
    UILabel *leftLabel7= (UILabel *) [_dataView viewWithTag:136];
    leftLabel7.font=[UIFont fontWithName:MYREADPROREGULAR size:13.0];
    UILabel *leftLabel8= (UILabel *) [_dataView viewWithTag:140];
    leftLabel8.font=[UIFont fontWithName:MYREADPROREGULAR size:13.0];
    UILabel *leftLabel9= (UILabel *) [_dataView viewWithTag:147];
    leftLabel9.font=[UIFont fontWithName:MYREADPROREGULAR size:13.0];
    UILabel *leftLabel10= (UILabel *) [_dataView viewWithTag:151];
    leftLabel10.font=[UIFont fontWithName:MYREADPROREGULAR size:13.0];

    UILabel *label2 = (UILabel *) [_dataView viewWithTag:107];
    
    label2.text = [arr valueForKey:@"TotalRounds"];
    label2.textColor=[UIColor whiteColor];
    label2.font=[UIFont fontWithName:MYREADPROREGULAR size:13.0];
    
    UILabel *label3 = (UILabel *) [_dataView viewWithTag:110];
    
    label3.text = [arr valueForKey:@"HolesPlayed"];
    label3.textColor=[UIColor whiteColor];
    label3.font=[UIFont fontWithName:MYREADPROREGULAR size:13.0];
    
    
    UILabel *label23 = (UILabel *) [_dataView viewWithTag:501];
    label23.font=[UIFont fontWithName:@"MyriadPro-Semibold" size:15.0];
    UILabel *label32 = (UILabel *) [_dataView viewWithTag:514];
    label32.font=[UIFont fontWithName:@"MyriadPro-Semibold" size:15.0];
    UILabel *label31 = (UILabel *) [_dataView viewWithTag:544];
    label31.font=[UIFont fontWithName:@"MyriadPro-Semibold" size:15.0];
    
    UILabel *label4 = (UILabel *) [_dataView viewWithTag:119];
    
    label4.text = [arr valueForKey:@"TotalEagles"];
    label4.textColor=[UIColor whiteColor];
    label4.font=[UIFont fontWithName:MYREADPROREGULAR size:13.0];
    
    UILabel *label5 = (UILabel *) [_dataView viewWithTag:123];
    
    label5.text = [arr valueForKey:@"TotalBirdies"];
    label5.textColor=[UIColor whiteColor];
    label5.font=[UIFont fontWithName:MYREADPROREGULAR size:13.0];
    
    
    UILabel *label6 = (UILabel *) [_dataView viewWithTag:127];
    
    label6.text = [arr valueForKey:@"TotalPars"];
    label6.textColor=[UIColor whiteColor];
    label6.font=[UIFont fontWithName:MYREADPROREGULAR size:13.0];
    //  label1.font=[UIFont fontWithName:@"SegoeUI-Light" size:27.0];
    
    UILabel *label7 = (UILabel *) [_dataView viewWithTag:131];
    
    label7.text = [arr valueForKey:@"TotalBogeyes"];
    label7.textColor=[UIColor whiteColor];
    label7.font=[UIFont fontWithName:MYREADPROREGULAR size:12.0];
    
    UILabel *label8 = (UILabel *) [_dataView viewWithTag:137];
    
    label8.text = [arr valueForKey:@"TotalDoubles"];
    label8.textColor=[UIColor whiteColor];
    label8.font=[UIFont fontWithName:MYREADPROREGULAR size:12.0];
    
    UILabel *label9 = (UILabel *) [_dataView viewWithTag:141];
    
    label9.text = [arr valueForKey:@"TotalOthers"];
    label9.textColor=[UIColor whiteColor];
    label9.font=[UIFont fontWithName:MYREADPROREGULAR size:12.0];
    
    UILabel *leftLabel11= (UILabel *) [_dataView viewWithTag:147];
    
    leftLabel11.font=[UIFont fontWithName:MYREADPROREGULAR size:13.0];
    
    UILabel *leftLabel12= (UILabel *) [_dataView viewWithTag:151];
    
    leftLabel12.font=[UIFont fontWithName:MYREADPROREGULAR size:13.0];
    
    UILabel *leftLabel13= (UILabel *) [_dataView viewWithTag:155];
    
    leftLabel13.font=[UIFont fontWithName:MYREADPROREGULAR size:13.0];
    
    UILabel *leftLabel14= (UILabel *) [_dataView viewWithTag:201];
    
    leftLabel14.font=[UIFont fontWithName:MYRIARDPROSAMIBOLT size:14.0];
    
    UILabel *leftLabel15= (UILabel *) [_dataView viewWithTag:203];
    
    leftLabel15.font=[UIFont fontWithName:MYREADPROREGULAR size:13.0];
    
    UILabel *leftLabel16= (UILabel *) [_dataView viewWithTag:205];
    
    leftLabel16.font=[UIFont fontWithName:MYREADPROREGULAR size:13.0];
    
    UILabel *leftLabel18= (UILabel *) [_dataView viewWithTag:207];
    
    leftLabel18.font=[UIFont fontWithName:MYREADPROREGULAR size:13.0];
    
    UILabel *leftLabel19= (UILabel *) [_dataView viewWithTag:209];
    
    leftLabel19.font=[UIFont fontWithName:MYRIARDPROSAMIBOLT size:14.0];
    
    UILabel *leftLabel20= (UILabel *) [_dataView viewWithTag:211];
    
    leftLabel20.font=[UIFont fontWithName:MYREADPROREGULAR size:13.0];
    
    UILabel *leftLabel21= (UILabel *) [_dataView viewWithTag:213];
    
    leftLabel21.font=[UIFont fontWithName:MYREADPROREGULAR size:13.0];
    
    UILabel *leftLabel22= (UILabel *) [_dataView viewWithTag:215];
    
    leftLabel22.font=[UIFont fontWithName:MYREADPROREGULAR size:13.0];
    
    UILabel *leftLabel23= (UILabel *) [_dataView viewWithTag:217];
    
    leftLabel23.font=[UIFont fontWithName:MYRIARDPROSAMIBOLT size:14.0];
    
    
    
    
    UILabel *label10 = (UILabel *) [_dataView viewWithTag:148];
    
    NSArray* ParStat = [[arr valueForKey:@"Par3Stat"] componentsSeparatedByString: @"/"];
    
    
    
    label10.text =[ParStat objectAtIndex: 1] ;
    
    label10.textColor=[UIColor whiteColor];
    
    
    
    label10.font=[UIFont fontWithName:MYREADPROREGULAR size:12.0];
    
    UILabel *label11 = (UILabel *) [_dataView viewWithTag:152];
    
    
    
    label11.text =[ParStat objectAtIndex: 0] ;
    
    label11.textColor=[UIColor whiteColor];
    
    label11.font=[UIFont fontWithName:MYREADPROREGULAR size:12.0];
    
    float Par_Number=[[ParStat objectAtIndex: 1]  floatValue];
    
    float Shot_par=[[ParStat objectAtIndex: 0]  floatValue];
    
    float avg=(Shot_par/Par_Number)*100;
    
    UILabel *label12 = (UILabel *) [_dataView viewWithTag:156];
    
    
    
    label12.text = [NSString stringWithFormat:@"%.0f%%",avg];
    
    label12.textColor=[UIColor whiteColor];
    
    
    
    label12.font=[UIFont fontWithName:MYREADPROREGULAR size:12.0];
    
    UILabel *label14 = (UILabel *) [_dataView viewWithTag:202];
    
    
    
    label14.text = [arr valueForKey:@"Par3StatAvg"];
    
    label14.textColor=[UIColor whiteColor];
    
    
    
    label14.font=[UIFont fontWithName:MYRIARDPROSAMIBOLT size:13.0];
    
    
    
    UILabel *label20 = (UILabel *) [_dataView viewWithTag:204];
    
    NSArray* ParStat1 = [[arr valueForKey:@"Par4Stat"] componentsSeparatedByString: @"/"];
    
    label20.text =[ParStat1 objectAtIndex: 1];
    
    label20.textColor=[UIColor whiteColor];
    
    label20.font=[UIFont fontWithName:MYREADPROREGULAR size:12.0];
    
    UILabel *label21 = (UILabel *) [_dataView viewWithTag:206];
    
    
    
    label21.text =[ParStat1 objectAtIndex: 0];
    
    label21.textColor=[UIColor whiteColor];
    
    label21.font=[UIFont fontWithName:MYREADPROREGULAR size:12.0];
    
    float Par_Number1=[[ParStat1 objectAtIndex: 1] floatValue];
    
    float Shot_par1=[[ParStat1 objectAtIndex: 0] floatValue];
    
    float avg1=(Shot_par1/Par_Number1)*100;
    
    UILabel *label22 = (UILabel *) [_dataView viewWithTag:208];
    
    
    
    label22.text = [NSString stringWithFormat:@"%.0f%%",avg1];
    
    label22.textColor=[UIColor whiteColor];
    
    label22.font=[UIFont fontWithName:MYREADPROREGULAR size:12.0];
    
    UILabel *label24 = (UILabel *) [_dataView viewWithTag:210];
    
    
    
    label24.text = [arr valueForKey:@"Par4StatAvg"];
    
    label24.textColor=[UIColor whiteColor];
    
    label24.font=[UIFont fontWithName:MYRIARDPROSAMIBOLT size:13.0];
    
    UILabel *label25 = (UILabel *) [_dataView viewWithTag:212];
    
    NSArray* ParStat2 = [[arr valueForKey:@"Par5Stat"] componentsSeparatedByString: @"/"];
    
    NSString *ParNumber2 =[ParStat2 objectAtIndex: 1] ;
    
    NSString *Shotpar2 = [ParStat2 objectAtIndex: 0];
    
    label25.text =[NSString stringWithFormat:@"%@",ParNumber2];
    
    label25.textColor=[UIColor whiteColor];
    
    label25.font=[UIFont fontWithName:MYREADPROREGULAR size:12.0];
    
    UILabel *label26 = (UILabel *) [_dataView viewWithTag:214];
    
    
    
    label26.text =[NSString stringWithFormat:@"%@",Shotpar2];
    
    label26.textColor=[UIColor whiteColor];
    
    label26.font=[UIFont fontWithName:MYREADPROREGULAR size:12.0];
    
    float Par_Number2=[ParNumber2 floatValue];
    
    float Shot_par2=[Shotpar2 floatValue];
    
    float avg2=(Shot_par2/Par_Number2)*100;
    
    NSLog(@"Par_Number %f",Par_Number);
    
    NSLog(@"Shot_par %f",Shot_par);
    
    NSLog(@"avg2 %.0f",avg2);
    
    UILabel *label27 = (UILabel *) [_dataView viewWithTag:216];
    
    
    
    label27.text = [NSString stringWithFormat:@"%.0f%%",avg2];
    
    label27.textColor=[UIColor whiteColor];
    
    label27.font=[UIFont fontWithName:MYREADPROREGULAR size:12.0];
    
    
    
    UILabel *label28 = (UILabel *) [_dataView viewWithTag:218];
    
    
    
    label28.text = [arr valueForKey:@"Par5StatAvg"];
    
    label28.textColor=[UIColor whiteColor];
    
    label28.font=[UIFont fontWithName:MYRIARDPROSAMIBOLT size:13.0];
    
    
    [_dataView setFrame:CGRectMake(0,_GraphView.frame.origin.x+_GraphView.frame.size.height+_actionView.layer.frame.size.height-28, _dataView.layer.frame.size.width, _dataView.layer.frame.size.height)];
    [_MainScrollView addSubview:_dataView];
    
    
    if([[arr valueForKey:@"GraphData"]isKindOfClass:[NSDictionary class]]){
        NSMutableDictionary *data=[arr valueForKey:@"GraphData"];
        
        NSArray *WX = [[data valueForKey:@"X"] componentsSeparatedByString:@","];
        NSArray *WY = [[data valueForKey:@"Y"] componentsSeparatedByString:@","];
       
        NSMutableArray *x_origin=[[NSMutableArray alloc]init];
        NSMutableArray *y_origin=[[NSMutableArray alloc]init];
        float max=999999999.0,min=-999999999.0,temp;
        for(int i=0;i<[WX count];i++){
            
            [x_origin addObject:[NSString stringWithFormat:@"%@",[WX objectAtIndex:i]]];
        }
        for(int i=0;i<[WY count];i++){
            temp=[[NSString stringWithFormat:@"%@",[WY objectAtIndex:i]]floatValue];
            if(temp<max)
            {
                max=temp;
            }
            if(temp>min)
            {
                min=temp;
            }
            [y_origin addObject:[NSString stringWithFormat:@"%@",[WY objectAtIndex:i]]];
        }
        
        float   interval;
        if(min==max) {
            if(min<0)
                min=0;
            else
                max=0;
        }
        if(min>0&&max<0)
            interval=(max-min)/5;
        else
            interval=(min+max)/5;
        if(interval <0)
            interval*=-1;
        _lineGraphView.interval = interval;
        _lineGraphView.minValue = max;
        _lineGraphView.maxValue = min;
        
        [_lineGraphView clearall];
        
        NSLog(@"max min and interval ---- %f %f %f",max,min,interval);
        
        SGSLineGraphViewComponent *component = [[SGSLineGraphViewComponent alloc] init];
        [component setTitle:@""];
        [component setPoints:y_origin];
        
        NSLog(@"component.point %@",component.points);
        [component setShouldLabelValues:YES];
        [component setLabelFormat:@"$%.0f%"];
        [component setColour:[UIColor whiteColor]];
        [_lineGraphView setComponents:[@[component] mutableCopy]];
        
        [_lineGraphView setXLabels:x_origin];
        
        [_lineGraphView setupGraphPaths];
        [_lineGraphView startDrawingAnimation];
        
        [grayIndicator stopAnimating];
        [_MainScrollView addSubview:_GraphView];
        [_MainScrollView bringSubviewToFront:_actionView];
    }
    else{
        [UIView animateWithDuration:0.25 animations:^{
            [SVProgressHUD showErrorWithStatus:@"No Data Found"];
           
            _MainScrollView.contentSize = CGSizeMake(320,800);
            [UIView animateWithDuration:0.25 animations:^{
                _actionView.frame =  CGRectMake(0,0,0,0);
                _GraphView.frame=CGRectMake(0,0,0,0);
                _actionView.hidden=YES;
                _GraphView.hidden=YES;
                [_dataView setFrame:CGRectMake(0,0, _dataView.layer.frame.size.width, _dataView.layer.frame.size.height)];
            }];
        }];
        }
    [grayIndicator stopAnimating];
}



-(void)viewWillAppear:(BOOL)animated
{
    Ishoveropen=FALSE;
   
    [self AddLeftMenuTo:_MenuBarView];

    
}


- (IBAction)manuSlideropen:(id)sender
{
    self.chatBoxView.hidden=YES;
    self.MenuBarView.hidden=NO;
    [self keyboardhide];
    IsLeftMenuBoxOpen=[self PerformMenuSlider:_ScreenView withMenuArea:_MenuBarView IsOpen:IsLeftMenuBoxOpen];
    
}

- (IBAction)DropdownopenClose:(id)sender
{
    
    if (Ishoveropen==FALSE)
    {
        
        self.popupview.frame=CGRectMake(0, 60, 320, 0);
        self.popupview.alpha=0.0000f;
        [_ScreenView addSubview:self.popupview];
        
        [UIView animateWithDuration:0.2f animations:^{
            
            self.popupview.frame=CGRectMake(0, 60, 320, 235);
            self.popupview.alpha=1.0000f;
            
        }
                         completion:^(BOOL finished)
         {
             Ishoveropen=TRUE;
         }];
        
    }
    else
    {
        [UIView animateWithDuration:0.2f animations:^{
            self.popupview.frame=CGRectMake(0, 60, 320, 0);
            self.popupview.alpha=0.0000f;
        }
                         completion:^(BOOL finished)
         {
             
             Ishoveropen=FALSE;
             [self.popupview removeFromSuperview];
         }];
        
    }
    
}
- (IBAction)OverViewdetais:(id)sender
{
    [UIView animateWithDuration:0.2f animations:^{
        self.popupview.frame=CGRectMake(0, 60, 320, 0);
        self.popupview.alpha=0.0000f;
       }
                     completion:^(BOOL finished)
     {
         
         Ishoveropen=FALSE;
         [self.popupview removeFromSuperview];
     }];
    
    TTTStatisticsViewController *statistics=[[TTTStatisticsViewController alloc]init];
    statistics.paramviewID=paramviewID;
    [self PushViewController:statistics TransitationFrom:kCATransitionFade];
    
}


- (IBAction)AchivementDetais:(id)sender
{
    [UIView animateWithDuration:0.2f animations:^{
        self.popupview.frame=CGRectMake(0, 60, 320, 0);
        self.popupview.alpha=0.0000f;
    }
                     completion:^(BOOL finished)
     {
         
         Ishoveropen=FALSE;
         [self.popupview removeFromSuperview];
     }];
   
    TTTAchievementStatisticViewController *Achivemnt=[[TTTAchievementStatisticViewController alloc]init];
    Achivemnt.ParamViewid=paramviewID;
    [self PushViewController:Achivemnt TransitationFrom:kCATransitionFade];
}
- (IBAction)roundDetails:(id)sender {
    [UIView animateWithDuration:0.2f animations:^{
        self.popupview.frame=CGRectMake(0, 60, 320, 0);
        self.popupview.alpha=0.0000f;
    }
                     completion:^(BOOL finished)
     {
         
         Ishoveropen=FALSE;
         [self.popupview removeFromSuperview];
     }];
    
    TTTroundlistViewController *roundDetails=[[TTTroundlistViewController alloc]init];
    roundDetails.paramviewID=paramviewID;
    [self PushViewController:roundDetails TransitationFrom:kCATransitionFade];
    [UIView animateWithDuration:0.2f animations:^{
        self.popupview.frame=CGRectMake(0, 60, 320, 0);
        self.popupview.alpha=0.0000f;
    }
                     completion:^(BOOL finished)
     {
         
         Ishoveropen=FALSE;
         [self.popupview removeFromSuperview];
     }];
    
}


- (IBAction)GoesHandicapDetais:(UIButton *)sender
{
    [UIView animateWithDuration:0.2f animations:^{
        self.popupview.frame=CGRectMake(0, 60, 320, 0);
        self.popupview.alpha=0.0000f;
    }
                     completion:^(BOOL finished)
     {
         
         Ishoveropen=FALSE;
         [self.popupview removeFromSuperview];
     }];
   
    TTTHandicaptViewController *handicapts=[[TTTHandicaptViewController alloc]init];
    handicapts.paramviewID=paramviewID;
    [self PushViewController:handicapts TransitationFrom:kCATransitionFade];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)ThreeMonthsAction:(id)sender
{
   
    NSLog(@"Three months clicked");
    [grayIndicator startAnimating];
    NSString *stringurl = [NSString stringWithFormat:@"%@user.php?mode=StatOverview&userid=%@&loggedin_userid=%@&search=%@", API,ViewID,[self LoggedId],@"3month"];
    NSLog(@"stringurl---%@",stringurl);
    NSURL *url = [NSURL URLWithString:stringurl];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:req delegate:self];
    
    if (connection)
    {
       // statisticData = [[NSMutableData alloc]init];
        //[self removeAll];
        [_GraphView removeFromSuperview];
//        [_lineGraphView clearall];
    }
    if(!connection){
        UIAlertView *alertview=[[UIAlertView alloc]initWithTitle:@"Error !" message:@"Error occured during fetching Graph" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alertview show];
    }
 
}

- (IBAction)SixMonthsAction:(id)sender {
  NSLog(@"six months clicked");
    
    

    [grayIndicator startAnimating];
    NSString *stringurl = [NSString stringWithFormat:@"%@user.php?mode=StatOverview&userid=%@&loggedin_userid=%@&search=%@", API,ViewID,[self LoggedId],@"6month"];
    NSLog(@"stringurl---%@",stringurl);
    NSURL *url = [NSURL URLWithString:stringurl];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:req delegate:self];
    
    if (connection)
    {
       
        [_GraphView removeFromSuperview];

        
    }
    if(!connection){
        UIAlertView *alertview=[[UIAlertView alloc]initWithTitle:@"Error !" message:@"Error occured during fetching Graph" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alertview show];
    }
}

- (IBAction)OneYearAction:(id)sender
{
    NSLog(@"one year clicked");
    [grayIndicator startAnimating];
    NSString *stringurl = [NSString stringWithFormat:@"%@user.php?mode=StatOverview&userid=%@&loggedin_userid=%@&search=%@", API,ViewID,[self LoggedId],@"1year"];
    NSLog(@"stringurl---%@",stringurl);
    NSURL *url = [NSURL URLWithString:stringurl];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:req delegate:self];
    
    if (connection)
    {
        //statisticData = [[NSMutableData alloc]init];
        //[self removeAll];
        [_GraphView removeFromSuperview];
//        [_lineGraphView clearall];
        
        }
    if(!connection)
    {
        UIAlertView *alertview=[[UIAlertView alloc]initWithTitle:@"Error !" message:@"Error occured during fetching Graph" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alertview show];
    }

}
- (IBAction)AllAction:(id)sender
{
  NSLog(@"all action clicked");
        [grayIndicator startAnimating];
    NSString *stringurl = [NSString stringWithFormat:@"%@user.php?mode=StatOverview&userid=%@&loggedin_userid=%@&search=%@", API,ViewID,[self LoggedId],@"all"];
    NSLog(@"stringurl---%@",stringurl);
    NSURL *url = [NSURL URLWithString:stringurl];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:req delegate:self];
    
    if (connection)
    {

        [_GraphView removeFromSuperview];

        
    }
    if(!connection){
        UIAlertView *alertview=[[UIAlertView alloc]initWithTitle:@"Error !" message:@"Error occured during fetching Graph" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alertview show];
    }
}
-(void)removeAll{
    NSArray *oSubView = [_GraphView subviews];
    for(int iCount = 0; iCount < [oSubView count]; iCount++)
    {
        id object = [oSubView objectAtIndex:iCount];
        [object removeFromSuperview];
        iCount--;
    }

}

//Back button click

- (IBAction)backButtonClick:(id)sender
{
    [self PerformGoBack];
   // [self PopViewController:@"TTTProfileViewController" WithAnimation:kCATransitionFromTop];
   
//    NSArray* arr = [[NSArray alloc] initWithArray:self.navigationController.viewControllers];
//    
//    for (UIViewController *viewcontroller in arr)
//    {
//        if ([viewcontroller isKindOfClass:[TTTProfileViewController class]])
//        {
//             [self.navigationController popToViewController:viewcontroller animated:YES];
//             break;
//        }
//    }
    
}

//Add pan gesture to the gesture recognizer

- (void)panDetected:(UIPanGestureRecognizer *)panRecognizer
{
    
    CGPoint  stopLocation;
    [self keyboardhide];
    if(IsChatMenuBoxOpen==NO){
        self.chatBoxView.hidden=YES;
        self.MenuBarView.hidden=NO;
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
    self.chatBoxView.hidden=NO;
    self.MenuBarView.hidden=YES;
    IsChatMenuBoxOpen=[self PerformChatSlider:_ScreenView withChatArea:self.chatBoxView IsOpen:IsChatMenuBoxOpen];
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
