//
//  TTTPhotodetailsViewController.m
//  TickTockTee
//
//  Created by Esolz_Mac on 28/03/14.
//  Copyright (c) 2014 com.esolz.TickTockTee. All rights reserved.
//

#import "TTTPhotodetailsViewController.h"
#import "SVProgressHUD.h"
#import "TTTGlobalMethods.h"
#import "AFNetworking.h"
#import "AFImageRequestOperation.h"
#import "TTTTagesuserViewcontroller.h"

@interface TTTPhotodetailsViewController ()<UIScrollViewDelegate,UIActionSheetDelegate,UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate>
{
    NSMutableDictionary *PreSentPhotoArry;
    BOOL Canuserlike;
    UIPinchGestureRecognizer *PinchGesture;
    NSOperationQueue *operationPhoto;
    NSString *ViewerId;
    BOOL ISShowMoreCaption;
    TTTGlobalMethods *Method;
    BOOL IsInLandScapemode;
    
    
}
@property (strong, nonatomic) IBOutlet UILabel *TotalteeLbl;
@property (strong, nonatomic) IBOutlet UILabel *totalCommentLbl;
@property (strong, nonatomic) IBOutlet UILabel *TeetxtLbl;
@property (strong, nonatomic) IBOutlet UILabel *commentTxtlbl;
@property (strong, nonatomic) IBOutlet UILabel *dateLble;
@property (strong, nonatomic) IBOutlet UILabel *ImageTitelLbl;
@property (strong, nonatomic) IBOutlet UIImageView *MainImageView;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *SpinnerView;

@property (strong, nonatomic) IBOutlet UIScrollView *MainScrollVire;
@property (strong, nonatomic) IBOutlet UIView *blackView;
@property (strong, nonatomic) IBOutlet UILabel *locationLbl;

@property (strong, nonatomic) IBOutlet UIView *loactionBackview;

@property (strong, nonatomic) IBOutlet UIButton *Buttonteabox;
@property (strong, nonatomic) IBOutlet UIButton *SeeMoreButton;
@property (strong, nonatomic) IBOutlet UIView *blacktransparentView;
@property (weak, nonatomic) IBOutlet UIView *MainBackview;
@property (weak, nonatomic) IBOutlet UIButton *DoneButtonclicked;

@end

@implementation TTTPhotodetailsViewController
@synthesize totalCommentLbl,TotalteeLbl,TeetxtLbl,dateLble,ImageTitelLbl,commentTxtlbl,MainImageView,MainScrollVire,ParamPhotoArry,SpinnerView,locationLbl,loactionBackview,OtheruserID,SeeMoreButton,ClickphotoId;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    self=(IsIphone5)?[super initWithNibName:@"TTTPhotodetailsViewController" bundle:nil]:[super initWithNibName:@"TTTPhotodetailsViewController_iPhone4" bundle:nil];
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    SeeMoreButton.hidden=YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    IsInLandScapemode=FALSE;
     TeetxtLbl.font=[UIFont fontWithName:MYRIARDPROSAMIBOLT size:11.0f];
     commentTxtlbl.font=[UIFont fontWithName:MYRIARDPROSAMIBOLT size:11.0f];
     dateLble.font=[UIFont fontWithName:MYREADPROREGULAR size:12.0f];
     ImageTitelLbl.font=[UIFont fontWithName:MYRIARDPROSAMIBOLT size:15.0f];
     TotalteeLbl.font=[UIFont fontWithName:MYREADPROREGULAR size:11.0f];
     totalCommentLbl.font=[UIFont fontWithName:MYREADPROREGULAR size:11.0f];
     operationPhoto=[[NSOperationQueue alloc]init];
      Canuserlike=FALSE;
      loactionBackview.hidden=TRUE;
      locationLbl.hidden=TRUE;
     ViewerId=([OtheruserID length]>0)?OtheruserID:[self LoggedId];
     self.backview.backgroundColor=[UIColor clearColor];
     TotalteeLbl.hidden=YES;
     TeetxtLbl.hidden=YES;
     totalCommentLbl.hidden=YES;
     commentTxtlbl.hidden=YES;
     ISShowMoreCaption=FALSE;
     Method=[[TTTGlobalMethods alloc]init];
     SeeMoreButton.titleLabel.font=[UIFont fontWithName:MYRIARDPROSAMIBOLT size:11.0f];
    
     [self PrepareScreen];
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rotationChanged:) name:@"UIDeviceOrientationDidChangeNotification" object:nil];
    
    
}

//-------------------- Rotation change ------------------------//

-(void)rotationChanged:(NSNotification *)notification
{
    NSInteger orientation = [[UIDevice currentDevice] orientation];
    CGRect FarmeBackview=[_MainBackview frame];
    CGRect ScrollView=[MainScrollVire frame];
    
    switch (orientation)
    {
        case 1:
            
             NSLog(@"Potred mode pangesture");
            IsInLandScapemode=FALSE;
             [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
            if (IsIphone5)
            {
                FarmeBackview.size.height=568.0f;
                FarmeBackview.size.width=320.0f;
                ScrollView.size.height=568.0f;
                ScrollView.size.width=320.0f;
                [_MainBackview setFrame:FarmeBackview];
                [MainScrollVire setFrame:ScrollView];
                [_DoneButtonclicked setFrame:CGRectMake(255, 27, 57, 29)];
            }
            else
            {
                FarmeBackview.size.height=480.0f;
                FarmeBackview.size.width=320.0f;
                ScrollView.size.height=480.0f;
                ScrollView.size.width=320.0f;
                [_MainBackview setFrame:FarmeBackview];
                [MainScrollVire setFrame:ScrollView];
                 [_DoneButtonclicked setFrame:CGRectMake(501, 27, 57, 29)];
            }
           
            break;
        case 3:
            NSLog(@"LandscapeRight");
            
           //---Same task for iPhone 5 and iPhone 6v--//
            IsInLandScapemode=TRUE;
            if (IsIphone5)
            {
                FarmeBackview.size.height=320.0f;
                FarmeBackview.size.width=568.0f;
                ScrollView.size.height=320.0f;
                ScrollView.size.width=568.0f;
                [_MainBackview setFrame:FarmeBackview];
                [MainScrollVire setFrame:ScrollView];
                 [_DoneButtonclicked setFrame:CGRectMake(501, 27, 57, 29)];
            }
            else
            {
                FarmeBackview.size.height=320.0f;
                FarmeBackview.size.width=480.0f;
                ScrollView.size.height=320.0f;
                ScrollView.size.width=480.0f;
                [_MainBackview setFrame:FarmeBackview];
                [MainScrollVire setFrame:ScrollView];
                 [_DoneButtonclicked setFrame:CGRectMake(501, 27, 57, 29)];
            }
            
            break;
         case 4:
            NSLog(@"The land scape left");
            IsInLandScapemode=TRUE;
            [[UIApplication sharedApplication] setStatusBarHidden:NO];
            
          //  -- Same task for iPhone 5 and iPhone 6v -- //
            if (IsIphone5)
            {
                FarmeBackview.size.height=320.0f;
                FarmeBackview.size.width=568.0f;
                ScrollView.size.height=320.0f;
                ScrollView.size.width=568.0f;
                [_MainBackview setFrame:FarmeBackview];
                [MainScrollVire setFrame:ScrollView];
                 [_DoneButtonclicked setFrame:CGRectMake(501, 27, 57, 29)];
            }
            else
            {
                FarmeBackview.size.height=320.0f;
                FarmeBackview.size.width=480.0f;
                ScrollView.size.height=320.0f;
                ScrollView.size.width=480.0f;
                [_MainBackview setFrame:FarmeBackview];
                [MainScrollVire setFrame:ScrollView];
                 [_DoneButtonclicked setFrame:CGRectMake(501, 27, 57, 29)];

            }
            
          
            break;
        default:
            [[UIApplication sharedApplication] setStatusBarHidden:NO];
            break;
    }
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

- (BOOL)shouldAutorotate
{
    return YES;
}
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}


-(void)ReloadbackSectionofphoto
{
    
    if ([TotalteeLbl.text integerValue]<1&&[[totalCommentLbl text] integerValue]>1)
    {
        NSLog(@"1");
        CGRect commenttxtframe=[commentTxtlbl frame];
        CGRect Totalcommentlblframe=[totalCommentLbl frame];
        Totalcommentlblframe.origin.y=85;
        commenttxtframe.origin.y=85;
        
        TeetxtLbl.hidden=YES;
        TotalteeLbl.hidden=YES;
        commentTxtlbl.hidden=NO;
        commentTxtlbl.hidden=NO;
        [commentTxtlbl setFrame:commenttxtframe];
        [totalCommentLbl setFrame:Totalcommentlblframe];
    }
    else if ([TotalteeLbl.text integerValue]>1&&[[totalCommentLbl text] integerValue]<1)
    {
        NSLog(@"2");
        totalCommentLbl.hidden=YES;
        commentTxtlbl.hidden=YES;
        TotalteeLbl.hidden=NO;
        TeetxtLbl.hidden=NO;
        
    }
    else if ([TotalteeLbl.text integerValue]>1&&[[totalCommentLbl text] integerValue]>1)
    {
        NSLog(@"3");
        
        CGRect commenttxtframe=[commentTxtlbl frame];
        CGRect Totalcommentlblframe=[totalCommentLbl frame];
        Totalcommentlblframe.origin.y=99;
        commenttxtframe.origin.y=99;
        [commentTxtlbl setFrame:commenttxtframe];
        [totalCommentLbl setFrame:Totalcommentlblframe];
        totalCommentLbl.hidden=NO;
        commentTxtlbl.hidden=NO;
        TotalteeLbl.hidden=NO;
        TeetxtLbl.hidden=NO;
        
    }
    else
    {
        NSLog(@"the 4");
        
        totalCommentLbl.hidden=YES;
        commentTxtlbl.hidden=YES;
        TotalteeLbl.hidden=YES;
        TeetxtLbl.hidden=YES;
    }
    
    
  
}


-(void)PrepareScreen
{
   
    PreSentPhotoArry=[ParamPhotoArry objectAtIndex:[ClickphotoId integerValue]];
    NSString *MyImageContent=[PreSentPhotoArry valueForKey:@"original"];
    UIImageView *imageview;
    if (IsInLandScapemode)
    {
        if (IsIphone5)
        {
            imageview=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 568, 320)];
        }
        else
        {
            imageview=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 480, 320)];
        }
    }
     else
      {
      if (IsIphone5)
       {
        imageview=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 568, 320)];
       }
      else
      {
        imageview=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 480, 320)];
      }
    }
    NSURLRequest *request_img4 = [NSURLRequest requestWithURL:[NSURL URLWithString:MyImageContent]];
    [imageview setContentMode:UIViewContentModeScaleAspectFit];
    [imageview setTag:[[PreSentPhotoArry valueForKey:@"photo_id"] integerValue]];
    [SpinnerView startAnimating];
    
    
    AFImageRequestOperation *operation = [AFImageRequestOperation imageRequestOperationWithRequest:request_img4
                                                                              imageProcessingBlock:nil
                                                                                           success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image)
                                               {
                                              if(image!=nil)
                                              {
                                                  
                                                  imageview.image=image;
                                                  [SpinnerView stopAnimating];
                                              }
                                              
                                          }
                                                                                           failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error)
                                          {
                                              NSLog(@"The errorcode:%@",error);
                                              [SpinnerView stopAnimating];
                                              [SpinnerView hidesWhenStopped];
                                              [SVProgressHUD showErrorWithStatus:@"unexpected error occurred"];
                                          }];
    [operation start];
    
    [MainScrollVire addSubview:imageview];
    totalCommentLbl.text=[PreSentPhotoArry valueForKey:@"commentcount"];
    
    TotalteeLbl.text=[PreSentPhotoArry valueForKey:@"likecount"];
    dateLble.text=[PreSentPhotoArry valueForKey:@"datetime"];
    [imageview setUserInteractionEnabled:YES];
    PinchGesture=[[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(AllowZoomInZoomOut:)];
    [imageview addGestureRecognizer:PinchGesture];
    
    Canuserlike=[[PreSentPhotoArry valueForKey:@"isUserLiked"] integerValue]>0?TRUE:FALSE;
    locationLbl.text=[PreSentPhotoArry valueForKey:@"caption"];
    ImageTitelLbl.text=[PreSentPhotoArry valueForKey:@"location"];
    
    if ([[PreSentPhotoArry valueForKey:@"location"] length]>2&&[[PreSentPhotoArry valueForKey:@"caption"] length]>37)
    {
    
        loactionBackview.hidden=FALSE;
        locationLbl.hidden=FALSE;
        locationLbl.text=[PreSentPhotoArry valueForKey:@"caption"];
        ImageTitelLbl.text=[PreSentPhotoArry valueForKey:@"location"];
        CGRect FrameTitle=[ImageTitelLbl frame];
        CGRect FrameLocation=[locationLbl frame];
        CGRect frameDateTime=[dateLble frame];
        FrameLocation.origin.y=0;
        FrameTitle.origin.y=32.0f;
        frameDateTime.origin.y=55.0f;
        locationLbl.frame=FrameLocation;
        ImageTitelLbl.frame=FrameTitle;
        dateLble.frame=frameDateTime;
        SeeMoreButton.hidden=NO;
        
    }
    else if ([[PreSentPhotoArry valueForKey:@"location"] length]<2&&[[PreSentPhotoArry valueForKey:@"caption"] length]>37)
    {
        
        if (IsIphone5)
        {
            [self.blacktransparentView setFrame:CGRectMake(0, 460, 320, 110)];
        }
        CGRect FrameTitle=[ImageTitelLbl frame];
        CGRect frameDateTime=[dateLble frame];
        [ImageTitelLbl setText:[PreSentPhotoArry valueForKey:@"caption"]];
        [self.blacktransparentView setFrame:self.blackView.frame];
        FrameTitle.origin.y=18.0f;
        frameDateTime.origin.y=55.0f;
        ImageTitelLbl.frame=FrameTitle;
        dateLble.frame=frameDateTime;
        SeeMoreButton.hidden=NO;
    }
    
    else
    {
       
        if (IsIphone5)
        {
            [self.blacktransparentView setFrame:CGRectMake(0, 479, 320, 90)];
        }
        
        loactionBackview.hidden=TRUE;
        locationLbl.hidden=TRUE;
        CGRect FrameTitle=[ImageTitelLbl frame];
        CGRect frameDateTime=[dateLble frame];
        CGRect FrameLocation=[locationLbl frame];
        FrameLocation.origin.y=16.0f;
        FrameTitle.origin.y=40.0f;
        frameDateTime.origin.y=63.0f;
        locationLbl.frame=FrameLocation;
        ImageTitelLbl.frame=FrameTitle;
        dateLble.frame=frameDateTime;
        ImageTitelLbl.text=[PreSentPhotoArry valueForKey:@"caption"];
        SeeMoreButton.hidden=YES;
        
        
    }
    
    
    if ([TotalteeLbl.text integerValue]<1&&[[totalCommentLbl text] integerValue]>1)
    {
        NSLog(@"1");
        CGRect commenttxtframe=[commentTxtlbl frame];
        CGRect Totalcommentlblframe=[totalCommentLbl frame];
        Totalcommentlblframe.origin.y=85;
        commenttxtframe.origin.y=85;
        
        TeetxtLbl.hidden=YES;
        TotalteeLbl.hidden=YES;
        commentTxtlbl.hidden=NO;
        commentTxtlbl.hidden=NO;
        [commentTxtlbl setFrame:commenttxtframe];
        [totalCommentLbl setFrame:Totalcommentlblframe];
    }
    else if ([TotalteeLbl.text integerValue]>1&&[[totalCommentLbl text] integerValue]<1)
    {
       
        totalCommentLbl.hidden=YES;
        commentTxtlbl.hidden=YES;
        TotalteeLbl.hidden=NO;
        TeetxtLbl.hidden=NO;
        
    }
    else if ([TotalteeLbl.text integerValue]>1&&[[totalCommentLbl text] integerValue]>1)
    {
        NSLog(@"3");
        CGRect commenttxtframe=[commentTxtlbl frame];
        CGRect Totalcommentlblframe=[totalCommentLbl frame];
        Totalcommentlblframe.origin.y=99;
        commenttxtframe.origin.y=99;
        [commentTxtlbl setFrame:commenttxtframe];
        [totalCommentLbl setFrame:Totalcommentlblframe];
        totalCommentLbl.hidden=NO;
        commentTxtlbl.hidden=NO;
        TotalteeLbl.hidden=NO;
        TeetxtLbl.hidden=NO;
        
    }
    else
    {
        NSLog(@"the 4");
        totalCommentLbl.hidden=YES;
        commentTxtlbl.hidden=YES;
        TotalteeLbl.hidden=YES;
        TeetxtLbl.hidden=YES;
    }
    if (!IsInLandScapemode)
    {
        if (IsIphone5)
        {
            [MainScrollVire setContentOffset:CGPointMake(320*[ClickphotoId integerValue], 568)];
            [MainScrollVire setContentSize:CGSizeMake(320*[ParamPhotoArry count], 568)];
        }
       else
        {
           [MainScrollVire setContentOffset:CGPointMake(320*[ClickphotoId integerValue], 480)];
           [MainScrollVire setContentSize:CGSizeMake(320*[ParamPhotoArry count], 480)];
        }
    
    }
    else
    {
        if (IsIphone5)
        {
            [MainScrollVire setContentOffset:CGPointMake(320*[ClickphotoId integerValue], 568)];
            [MainScrollVire setContentSize:CGSizeMake(320*[ParamPhotoArry count], 568)];
        }
        else
        {
            [MainScrollVire setContentOffset:CGPointMake(320*[ClickphotoId integerValue], 480)];
            [MainScrollVire setContentSize:CGSizeMake(320*[ParamPhotoArry count], 480)];
        }

    }
    
    
}


-(void)ShowmoreButtonclick
{
    CGRect caPtionString;
    UILabel *captionLbl;
    if (ISShowMoreCaption==FALSE)
    {
        ISShowMoreCaption=TRUE;
        [SeeMoreButton setTitle:@"Hide." forState:UIControlStateNormal];
        if ([[PreSentPhotoArry valueForKey:@"location"] length]>2)
        {
            captionLbl=locationLbl;
            caPtionString=[locationLbl frame];
           
        }
        else
        {
            captionLbl=ImageTitelLbl;
            caPtionString=[ImageTitelLbl frame];
        }
        captionLbl.numberOfLines=2;
        caPtionString.size.height=21+16;
        [captionLbl setFrame:caPtionString];
        
      }
      else
       {
           ISShowMoreCaption=FALSE;
           
           [SeeMoreButton setTitle:@"See More." forState:UIControlStateNormal];
            if ([[PreSentPhotoArry valueForKey:@"location"] length]>2)
            {
               //[locationLbl setFrame:caPtionString];
                locationLbl.numberOfLines=1;
            }
           else
           {
              // [ImageTitelLbl setFrame:caPtionString];
               ImageTitelLbl.numberOfLines=1;
               
  
           }
          
           

       }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

- (IBAction)DoneButtonclick:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        [SVProgressHUD dismiss];
    }];
}

- (IBAction)Teedthephoto:(id)sender
{
   if(Canuserlike)
    {
       
      
        NSInteger totalLike=[[PreSentPhotoArry valueForKey:@"likecount"] integerValue]-1;
        TotalteeLbl.text=[NSString stringWithFormat:@"%d",totalLike];
        Canuserlike=FALSE;
        
       
    }
    else
    {
        NSInteger totalLike=[[PreSentPhotoArry valueForKey:@"likecount"] integerValue]+1;
        TotalteeLbl.text=[NSString stringWithFormat:@"%d",totalLike];
         Canuserlike=TRUE;
    }
    [self ReloadbackSectionofphoto];
    [self.Buttonteabox setBackgroundImage:[UIImage imageNamed:(Canuserlike)?@"tee":@"tee"] forState:UIControlStateNormal];
    
    NSInvocationOperation *Invoc=[[NSInvocationOperation alloc] initWithTarget:self selector:@selector(PerformLiker:) object:[PreSentPhotoArry valueForKey:@"photo_id"]];
    [operationPhoto addOperation:Invoc];
}
-(void)PerformLiker :(NSString *)PhotoId
{
    @try
    {
        NSString *URLString=[NSString stringWithFormat:@"%@user.php?mode=photoLike&userid=%@&photoid=%@&type=%@loggedin_userid=%@", API, ViewerId, PhotoId, (Canuserlike)?@"like":@"dislike",[self LoggedId]];
        NSLog(@"%@", URLString);
        [NSData dataWithContentsOfURL:[NSURL URLWithString:URLString]];
    }
    @catch (NSException *juju)
    {
        NSLog(@"Reporting juju from PerformLiker : %@", juju);
    }
}



- (IBAction)CommentOnthephoto:(id)sender
{
    
    
}
- (IBAction)ShareThephoto:(id)sender
{
    [self ShowShareOptions];
}

- (IBAction)tagThephoto:(id)sender
{
    TTTTagesuserViewcontroller *tagList=[[TTTTagesuserViewcontroller alloc]init];
    tagList.ParamphotoPhotoID=[PreSentPhotoArry valueForKey:@"photo_id"];
    [self presentViewController:tagList animated:YES completion:^{
        
    }];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    static NSInteger previousPage = 0;
    CGFloat pageWidth = scrollView.frame.size.width;
    float fractionalPage = scrollView.contentOffset.x / pageWidth;
    NSInteger page = lround(fractionalPage);
    
    if (previousPage != page)
    {
        previousPage = page;
        /* Page did change */
        NSLog(@"the value of page:%d",page);
        [self ShowimageInScreenview:page];
        
    }
}



-(void)ShowimageInScreenview:(NSInteger)position
{
    NSArray *Array=[MainScrollVire subviews];
     ISShowMoreCaption=FALSE;
    [SeeMoreButton setTitle:@"See More." forState:UIControlStateNormal];
    CGRect frame1=[locationLbl frame];
    CGRect frame2=[ImageTitelLbl frame];
    frame1.size.height=21.0f;
    frame2.size.height=21.0f;
    [locationLbl setFrame:frame1];
    [ImageTitelLbl setFrame:frame2];
    
    locationLbl.numberOfLines=1;
    ImageTitelLbl.numberOfLines=1;
    for (UIImageView *Imageview in Array)
    {
        [Imageview removeFromSuperview];
    }
    
    PreSentPhotoArry=[ParamPhotoArry objectAtIndex:position];
    NSString *MyImageContent=[PreSentPhotoArry valueForKey:@"original"];
    UIImageView *imageview;
    if (IsInLandScapemode)
    {
        if (IsIphone5)
        {
            imageview=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 568, 320)];
        }
        else
        {
            imageview=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 480, 320)];
        }
    }
    else
    {
        if (IsIphone5)
        {
            imageview=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 568, 320)];
        }
        else
        {
            imageview=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 480, 320)];
        }
    }
    
    [imageview setContentMode:UIViewContentModeScaleAspectFit];
    NSURLRequest *request_img4 = [NSURLRequest requestWithURL:[NSURL URLWithString:MyImageContent]];
    [SpinnerView startAnimating];
    [imageview setTag:[[PreSentPhotoArry valueForKey:@"photo_id"] integerValue]];
    
    AFImageRequestOperation *operation = [AFImageRequestOperation imageRequestOperationWithRequest:request_img4
                                                                              imageProcessingBlock:nil
                                                                                           success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image)
                                          {
                                              if(image!=nil)
                                              {
                                                  
                                                  imageview.image=image;
                                                  [SpinnerView stopAnimating];
                                               }
                                              
                                              }
                                                                                    failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error)
                                             {
                                              NSLog(@"The errorcode:%@",error);
                                              [SpinnerView stopAnimating];
                                              [SpinnerView hidesWhenStopped];
                                           }];
    [operation start];
    
    [MainScrollVire addSubview:imageview];
    totalCommentLbl.text=[PreSentPhotoArry valueForKey:@"commentcount"];
    TotalteeLbl.text=[PreSentPhotoArry valueForKey:@"likecount"];
    dateLble.text=[PreSentPhotoArry valueForKey:@"datetime"];
    Canuserlike=[[PreSentPhotoArry valueForKey:@"isUserLiked"] integerValue]>0?TRUE:FALSE;
    [imageview setUserInteractionEnabled:YES];
    PinchGesture=[[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(AllowZoomInZoomOut:)];
    [imageview addGestureRecognizer:PinchGesture];
   
    if ([[PreSentPhotoArry valueForKey:@"location"] length]>2&&[[PreSentPhotoArry valueForKey:@"caption"] length]>37)
    {
        NSLog(@"i am in 1");
        
        loactionBackview.hidden=FALSE;
        locationLbl.hidden=FALSE;
        locationLbl.text=[PreSentPhotoArry valueForKey:@"caption"];
        ImageTitelLbl.text=[PreSentPhotoArry valueForKey:@"location"];
        CGRect FrameTitle=[ImageTitelLbl frame];
        CGRect FrameLocation=[locationLbl frame];
        CGRect frameDateTime=[dateLble frame];
        FrameLocation.origin.y=0;
        FrameTitle.origin.y=32.0f;
        frameDateTime.origin.y=55.0f;
        locationLbl.frame=FrameLocation;
        ImageTitelLbl.frame=FrameTitle;
        dateLble.frame=frameDateTime;
        SeeMoreButton.hidden=NO;
        
    }
    else if ([[PreSentPhotoArry valueForKey:@"location"] length]<2&&[[PreSentPhotoArry valueForKey:@"caption"] length]>37)
    {
        NSLog(@"i am in 2");
        if (IsIphone5)
        {
            [self.blacktransparentView setFrame:CGRectMake(0, 460, 320, 110)];
        }
        CGRect FrameTitle=[ImageTitelLbl frame];
        CGRect frameDateTime=[dateLble frame];
        [ImageTitelLbl setText:[PreSentPhotoArry valueForKey:@"caption"]];
        [self.blacktransparentView setFrame:self.blackView.frame];
        FrameTitle.origin.y=18.0f;
        frameDateTime.origin.y=55.0f;
        ImageTitelLbl.frame=FrameTitle;
        dateLble.frame=frameDateTime;
        SeeMoreButton.hidden=NO;
    }
    
    else
    {
        NSLog(@"i am in 3");
        if (IsIphone5)
        {
            [self.blacktransparentView setFrame:CGRectMake(0, 479, 320, 90)];
        }
        
        loactionBackview.hidden=TRUE;
        locationLbl.hidden=TRUE;
        CGRect FrameTitle=[ImageTitelLbl frame];
        CGRect frameDateTime=[dateLble frame];
        CGRect FrameLocation=[locationLbl frame];
        FrameLocation.origin.y=16.0f;
        FrameTitle.origin.y=40.0f;
        frameDateTime.origin.y=63.0f;
        locationLbl.frame=FrameLocation;
        ImageTitelLbl.frame=FrameTitle;
        dateLble.frame=frameDateTime;
        ImageTitelLbl.text=[PreSentPhotoArry valueForKey:@"caption"];
        SeeMoreButton.hidden=YES;
        
        
    }
    
    
    if ([TotalteeLbl.text integerValue]<1&&[[totalCommentLbl text] integerValue]>1)
    {
        NSLog(@"1");
        CGRect commenttxtframe=[commentTxtlbl frame];
        CGRect Totalcommentlblframe=[totalCommentLbl frame];
        Totalcommentlblframe.origin.y=85;
        commenttxtframe.origin.y=85;
        
        TeetxtLbl.hidden=YES;
        TotalteeLbl.hidden=YES;
        commentTxtlbl.hidden=NO;
        commentTxtlbl.hidden=NO;
        [commentTxtlbl setFrame:commenttxtframe];
        [totalCommentLbl setFrame:Totalcommentlblframe];
    }
    else if ([TotalteeLbl.text integerValue]>1&&[[totalCommentLbl text] integerValue]<1)
    {
        NSLog(@"2");
        totalCommentLbl.hidden=YES;
        commentTxtlbl.hidden=YES;
        TotalteeLbl.hidden=NO;
        TeetxtLbl.hidden=NO;
        
    }
  else if ([TotalteeLbl.text integerValue]>1&&[[totalCommentLbl text] integerValue]>1)
    {
        NSLog(@"3");
        CGRect commenttxtframe=[commentTxtlbl frame];
        CGRect Totalcommentlblframe=[totalCommentLbl frame];
        Totalcommentlblframe.origin.y=99;
        commenttxtframe.origin.y=99;
        [commentTxtlbl setFrame:commenttxtframe];
        [totalCommentLbl setFrame:Totalcommentlblframe];
        totalCommentLbl.hidden=NO;
        commentTxtlbl.hidden=NO;
        TotalteeLbl.hidden=NO;
        TeetxtLbl.hidden=NO;
        
    }
    else
    {
        NSLog(@"the 4");
        totalCommentLbl.hidden=YES;
        commentTxtlbl.hidden=YES;
        TotalteeLbl.hidden=YES;
        TeetxtLbl.hidden=YES;
    }
    
    [MainScrollVire addSubview:imageview];
    

}
//Action Set Option for Shareing an image
- (void)ShowShareOptions
{
    NSString *actionSheetTitle = @"Choose an share option"; //Action Sheet Title
    NSString *destructiveTitle = @"Cancel";
    NSString *other1 = @"Share with Friends";
    NSString *other2 = @"Post to facebook";
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:actionSheetTitle delegate:self cancelButtonTitle:destructiveTitle destructiveButtonTitle:nil otherButtonTitles:other1, other2, nil];
    
    [actionSheet showFromRect:CGRectMake(0.0f, 0.0f, 0.0f, 0.0f) inView:[self view] animated:YES];
}
//UIScroll view Delegate


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch(buttonIndex)
    {
        case 0:
            [self ShareWithFriend];
            break;
        case 1:
            [self PostImageToFacebook:[self getCurrentlyShowingImage]];
            break;
    }
}

-(void)ShareWithFriend
{
   
    NSString *URLString=[NSString stringWithFormat:@"%@photo.php?mode=sharewithfriend&userid=%@&photoid=%@&loggedin_userid=%@", API, ViewerId, [PreSentPhotoArry valueForKey:@"photo_id"],[self LoggedId]];
    [self PingServer:URLString];
    [SVProgressHUD showSuccessWithStatus:@"Successfully shared with your friends"];
}

//get image to be share

-(UIImage *)getCurrentlyShowingImage
{
    

    for(UIImageView *Child in [MainScrollVire subviews])
    {
        if([Child isKindOfClass:[UIImageView class]])
        {
            if([Child tag] == [[PreSentPhotoArry valueForKey:@"photo_id"] integerValue])
            {
                if([Child image])
                {
                    NSLog(@"I am in getting image page:");
                    return [Child image];
                }
            }
        }
    }
    return nil;
    
}
// portion of image zooming using Transform


-(void)AllowZoomInZoomOut :(UIPinchGestureRecognizer *)Recognizer
{
   
    if([Recognizer state] ==  UIGestureRecognizerStateEnded || [Recognizer state] == UIGestureRecognizerStateChanged)
    {
        UIImageView *VictimView=(UIImageView *)[[Recognizer self] view];
        
        CGFloat CurrentScale=[VictimView frame].size.width/[VictimView bounds].size.width;
        CGFloat NewScale=CurrentScale*[Recognizer scale];
        
        if(NewScale<0.50f)
            NewScale=0.50f;
        else if(NewScale > 3.0f)
            NewScale=3.0f;
        
        CGAffineTransform Transform = CGAffineTransformMakeScale(NewScale, NewScale);
        [VictimView setTransform:Transform];
        [MainScrollVire setTransform:Transform];
        [Recognizer setScale:1.0f];
    }
}
//tag operation



//See more button functionalety
- (IBAction)SheeMoretextButton:(id)sender
{
    NSLog(@"See more button:");
    [self ShowmoreButtonclick];
}



@end
