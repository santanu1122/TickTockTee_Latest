//
//  TTTVideoListViewController.m
//  TickTockTee
//
//  Created by Esolz Tech on 14/04/14.
//  Copyright (c) 2014 com.esolz.TickTockTee. All rights reserved.
//

#import "TTTVideoListViewController.h"
#import "AFImageRequestOperation.h"
#import "TTTWebVideoViewController.h"

@interface TTTVideoListViewController ()<UIGestureRecognizerDelegate,UIWebViewDelegate>{
    UITapGestureRecognizer *TapGesture;
    NSMutableArray *videosOfMyArray;
    NSOperationQueue *operationMain;
   NSString *totalVideoString;
    NSString *ViewerId;
    NSMutableDictionary *dict;
    BOOL  IsLeftMenuBoxOpen,isFastLocation,islastlocation,IsChatMenuBoxOpen;
    UIImageView *imgview;
    UIActivityIndicatorView *spinner,*pageSpinner;;
    UIWebView *webView;
}
@property (strong, nonatomic) IBOutlet UIView *chatBoxView;
//@property (strong, nonatomic) IBOutlet UITableView *videoTblview;
@property (strong, nonatomic) IBOutlet UIView *menuView;
@property (strong, nonatomic) IBOutlet UIView *vFooter;
@property (strong, nonatomic) IBOutlet UIButton *leftMenu;
@property (strong, nonatomic) IBOutlet UIScrollView *videoScroll;
@property (strong, nonatomic) IBOutlet UILabel *totalVideolabel;
@property (strong, nonatomic) IBOutlet UIButton *backButton;
@property (strong, nonatomic) IBOutlet UIView *Screenview;
@property (strong, nonatomic) IBOutlet UIButton *backRightButton;

- (IBAction)plusButtonClicked:(id)sender;

@end

@implementation TTTVideoListViewController
@synthesize  videoIdentifier,totalVideolabel;
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
    IsLeftMenuBoxOpen=NO;
    IsChatMenuBoxOpen=NO;
    IsLeftMenuBoxOpen=FALSE;
    [self AddNavigationBarTo:_vFooter withSelected:@""];
    _backRightButton.hidden=YES;
    operationMain=[[NSOperationQueue alloc]init];
    videosOfMyArray=[[NSMutableArray alloc]init];
    
    ViewerId=([self.videoIdentifier length]>0)?self.videoIdentifier:[self LoggedId];
    if ([self.videoIdentifier length]==0)
    {
        _backButton.hidden=TRUE;
        _leftMenu.hidden=FALSE;
        UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panDetected:)];
        panRecognizer.delegate=self;
        [_Screenview addGestureRecognizer:panRecognizer];
        
    }
    else
    {
        _backButton.hidden=FALSE;
        _leftMenu.hidden=TRUE;
    }

    pageSpinner=[[UIActivityIndicatorView alloc]init];
    pageSpinner.center=self.videoScroll.center;
    pageSpinner.activityIndicatorViewStyle=UIActivityIndicatorViewStyleGray;
    [pageSpinner startAnimating];
    [self AddLeftMenuTo:self.menuView];
    [self viewVideos];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)LoadPhotoScroll
{
    
    [SVProgressHUD dismiss];
    CGFloat Thevalueofy=0.0f;
    
    int j=0;
    
    for (int i=0; i<[videosOfMyArray count]; i++)
    {
        UIImageView *Imageviewmain=[[UIImageView alloc]init];
        
        
        if (i%4==0&i!=0)
        {
            Thevalueofy=Thevalueofy+80;
            
            j=0;
        }
        
        
        [Imageviewmain setFrame:CGRectMake(80*j, Thevalueofy, 80, 80)];
        TapGesture=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ViewPhotos:)];
        [TapGesture setNumberOfTapsRequired:1];
        [Imageviewmain setTag:i];
        
        [Imageviewmain addGestureRecognizer:TapGesture];
        [Imageviewmain setUserInteractionEnabled:YES];
        [self.videoScroll addSubview:Imageviewmain];
        UIActivityIndicatorView *Spinner=[[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(30, 30, 20, 20)];
        [Spinner startAnimating];
        [Imageviewmain addSubview:Spinner];
        NSMutableDictionary *PhotoDic=[videosOfMyArray objectAtIndex:i];
        //Download Image in imageview
        NSURLRequest *request_img4 = [NSURLRequest requestWithURL:[NSURL URLWithString:[PhotoDic valueForKey:@"thumbnail"]]];
        AFImageRequestOperation *operation = [AFImageRequestOperation imageRequestOperationWithRequest:request_img4
                                                                                  imageProcessingBlock:nil
                                                                                               success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                                                                   if(image!=nil)
                                                                                                   {
                                                                                                       
                                                                                                       Imageviewmain.image=image;
                                                                                                       [Spinner stopAnimating];
                                                                                                       [Spinner hidesWhenStopped];
                                                                                                   }
                                                                                                   
                                                                                               }
                                                                                               failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error)
                                              {
                                                  NSLog(@"The errorcode:%@",error);
                                                  [Spinner stopAnimating];
                                                  [Spinner hidesWhenStopped];
                                              }];
        [operation start];
        
        
        j++;
        
    }
    
    
    self.totalVideolabel.font=[UIFont fontWithName:MYREADPROREGULAR size:16.0f];
    self.videoScroll.contentSize=CGSizeMake(320, (([videosOfMyArray count]*80)/4)+80);
    
}


-(void)viewVideos{
    @try {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        // DATA PROCESSING 1
        
        NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@user.php?mode=getvideo&userid=%@&loggedin_userid=%@", API, ViewerId,[self LoggedId]]];
        NSData *getData=[NSData dataWithContentsOfURL:url];
        dict=[NSJSONSerialization JSONObjectWithData:getData options:kNilOptions error:nil];
        videosOfMyArray=[dict objectForKey:@"videolist"];
        NSLog(@"Videos of my array %@ count %d",videosOfMyArray,[videosOfMyArray count]);
        dispatch_async(dispatch_get_main_queue(), ^{
            // UI UPDATION 1
            
            for(UIView *image in self.videoScroll.subviews){
                [image removeFromSuperview];
            }
            CGFloat Thevalueofy=0.0f;
            
            int j=0;
            
                    for(int i=0;i<[videosOfMyArray count];i++){
                        NSDictionary *dictp=(NSDictionary *)[videosOfMyArray objectAtIndex:i];
                        UIImageView *Imageviewmain=[[UIImageView alloc]init];
                        if (i%4==0&i!=0)
                        {
                            Thevalueofy=Thevalueofy+80;
                            
                            j=0;
                        }
                        [Imageviewmain setFrame:CGRectMake(80*j, Thevalueofy, 80, 80)];
                        TapGesture=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ViewVideoAtYouTube:)];
                        [TapGesture setNumberOfTapsRequired:1];
                        //int videoid=[[dictp objectForKey:@"videoid"]integerValue];
                        [Imageviewmain setTag:i];
                        
                        [Imageviewmain addGestureRecognizer:TapGesture];
                        [Imageviewmain setUserInteractionEnabled:YES];
                        [self.videoScroll addSubview:Imageviewmain];
                        UIActivityIndicatorView *Spinner=[[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(30, 30, 20, 20)];
                        [Spinner startAnimating];
                        Spinner.activityIndicatorViewStyle=UIActivityIndicatorViewStyleGray;
                        
                        [Imageviewmain addSubview:Spinner];
                        [Imageviewmain bringSubviewToFront:Spinner];
                        
                       
                        
                   
                    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@",[dictp objectForKey:@"thumb"]]];
                        NSLog(@"Image URL is %@",url);
                    AFImageRequestOperation *operation = [AFImageRequestOperation imageRequestOperationWithRequest:[NSURLRequest requestWithURL:url]
                                                                                              imageProcessingBlock:nil
                                                                                                           success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                                                                               if(image!=nil)
                                                                                                               {
                                                                                                                   
                                                                                                                   Imageviewmain.image=image;
                                                                                                                   [Spinner stopAnimating];
                                                                                                                   [Spinner hidesWhenStopped];
//                                                                                                                   if(Imageviewmain.image==nil){
//                                                                                                                       UIImage *img=[UIImage imageNamed:@"stockImage"];
//                                                                                                                       Imageviewmain.image=img;
//                                                                                                                   }
                                                                                                                   totalVideolabel.text=[NSString stringWithFormat:@"Total %d %@",[videosOfMyArray count],@" Videos"];
                                                                                                                   NSLog(@"We are at here");
                                                                                                               }
                                                                                                               
                                                                                                           }
                                                                                                           failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error)
                                                          {
                                                              NSLog(@"The errorcode at image downloader:%@",error);
                                                              [Spinner stopAnimating];
                                                              [Spinner hidesWhenStopped];
                                                              UIImage *img=[UIImage imageNamed:@"stockImage"];
                                                              Imageviewmain.image=img;
                                                          }];
                    [operation start];
                        j++;
                    
                }
                 [pageSpinner stopAnimating];
            [pageSpinner hidesWhenStopped];
               
                
            });
            
            
        });
        
    }
    @catch (NSException *exception) {
        NSLog(@"REPORTING JUJU");
    }
    
}
-(void)ViewVideoAtYouTube:(UITapGestureRecognizer *)Recognizer
{
//    _backRightButton.hidden=NO;
    UIImageView *TouchedView=(UIImageView *)[[Recognizer self] view];
    int TouchviewTag=TouchedView.tag;
    NSDictionary *dictp=(NSDictionary *)[videosOfMyArray objectAtIndex:TouchviewTag];
    NSString *videoURL=[dictp objectForKey:@"video_path"];
    TTTWebVideoViewController *video=[[TTTWebVideoViewController alloc]init];
    video.videoURL=videoURL;
    [self presentViewController:video animated:YES completion:nil];
    
//    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 60, self.view.frame.size.width, self.view.frame.size.height)];  //Change self.view.bounds to a smaller CGRect if you don't want it to take up the whole screen
//    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:videoURL]]];
//    webView.delegate=self;
//    activityIndicator=[[UIActivityIndicatorView alloc]init];
//    activityIndicator.center=[webView center];
//    activityIndicator.activityIndicatorViewStyle=UIActivityIndicatorViewStyleGray;
//    [webView addSubview:activityIndicator];
//    
//    [self.Screenview addSubview:webView];
    
}

- (IBAction)leftMenuOpen:(id)sender {
    [self keyboardhide];
    self.menuView.hidden=NO;
    self.chatBoxView.hidden=YES;
    IsLeftMenuBoxOpen=[self PerformMenuSlider:_Screenview withMenuArea:_leftMenu IsOpen:IsLeftMenuBoxOpen];
    isFastLocation=IsLeftMenuBoxOpen;
}

- (IBAction)plusButtonClicked:(id)sender {
    [webView removeFromSuperview];
    _backRightButton.hidden=YES;
}
- (IBAction)backClicked:(id)sender {
    [self PerformGoBack];
}
- (void)panDetected:(UIPanGestureRecognizer *)panRecognizer
{
    
    CGPoint  stopLocation;
    [self keyboardhide];
    if(IsChatMenuBoxOpen==NO){
        self.menuView.hidden=NO;
        self.chatBoxView.hidden=YES;
        if (panRecognizer.state == UIGestureRecognizerStateBegan)
        {
            
            // CGPoint startLocation = [panRecognizer translationInView:_ScreenView];
            // NSLog(@"Strart locaton:%f",startLocation.x);
            
        }
        
        else if (panRecognizer.state == UIGestureRecognizerStateChanged)
        {
            
            stopLocation = [panRecognizer translationInView:self.Screenview];
            
            CGRect frame=[self.Screenview frame];
            if (IsLeftMenuBoxOpen==NO&&stopLocation.x>0)
            {
                //NSLog(@"location is %f",stopLocation.x);
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
                    // NSLog(@"open satisfied");
                    [UIView animateWithDuration:0.3f animations:^{
                        self.Screenview.frame=frame;
                        
                    }];
                    
                }
                else
                {
                    //NSLog(@"close satisfied");
                    IsLeftMenuBoxOpen=YES;
                    isFastLocation=TRUE;
                    CGRect lastFrame=[self.Screenview frame];
                    lastFrame.origin.x=260;
                    [UIView animateWithDuration:.5 animations:^{
                        self.Screenview.frame=lastFrame;
                        
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
                    
                    //NSLog(@"open satisfied");
                    [UIView animateWithDuration:.2 animations:^{
                        self.Screenview.frame=frame;
                        
                    }];
                    
                }
                else
                {
                    //NSLog(@"close satisfied");
                    IsLeftMenuBoxOpen=NO;
                    islastlocation=TRUE;
                    CGRect lastFrame2=[self.Screenview frame];
                    lastFrame2.origin.x=0;
                    [UIView animateWithDuration:.5 animations:^{
                        self.Screenview.frame=lastFrame2;
                        
                    }];
                }
            }
            
            
        }
        
        
        
        ///HERE LEFT MENU OPEN CLOSE HAPPENED
        else if (panRecognizer.state==UIGestureRecognizerStateEnded)
        {
            if (stopLocation.x<150&islastlocation==TRUE&IsLeftMenuBoxOpen==NO)
            {
                //NSLog(@"Left Menu closed %f",stopLocation.x);
                //self.Manuvire.hidden=YES;
                CGRect framelast=[self.Screenview frame];
                framelast.origin.x=0;
                
                
                [UIView animateWithDuration:.6 animations:^{
                    self.Screenview.frame=framelast;
                    
                }];
            }
            
            if (stopLocation.x*-1<100.0f&isFastLocation==TRUE&IsLeftMenuBoxOpen==YES)
            {
                // NSLog(@"Left Menu opened%f",stopLocation.x);
                //self.Manuvire.hidden=YES;
                
                CGRect framelast=[self.Screenview frame];
                framelast.origin.x=260;
                
                
                [UIView animateWithDuration:.6 animations:^{
                    self.Screenview.frame=framelast;
                    
                }];
                
            }
            
            
        }
        
    }
    
}


-(void)PerformChatSliderOperation
{
    
    self.menuView.hidden=YES;
    self.chatBoxView.hidden=NO;
    IsChatMenuBoxOpen=[self PerformChatSlider:self.Screenview withChatArea:self.chatBoxView IsOpen:IsChatMenuBoxOpen];
    NSLog(@"PerformChatSliderOperation %@ %@",IsChatMenuBoxOpen?@"YES":@"NO",[NSDate date]);
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
