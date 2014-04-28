//
//  TTTPhotosofme.m
//  TickTockTee
//
//  Created by macbook_ms on 27/03/14.
//  Copyright (c) 2014 com.esolz.TickTockTee. All rights reserved.
//

#import "TTTPhotosofme.h"
#import "TTTGlobalMethods.h"
#import "SVProgressHUD.h"
#import "AFImageRequestOperation.h"
#import "AFNetworking.h"
#import "TTTcellforPhotoAlbam.h"
#import "TTTShowphotosofalbam.h"
#import "TTTPhotodetailsViewController.h"
#import "TTTAddPhotoWithoption.h"


@interface TTTPhotosofme ()<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate>
{
    BOOL IsChatBoxOpen, IsLeftMenuBoxOpen, newMedia, IsMoreDataAvailabel, IsUpdateRequired, IsAllowUserLocation, IsMoreCommentAvailable,AddStatus,Ishoveropen;
    BOOL isPhotosofme;
    BOOL isAlbamofme;
    NSOperationQueue *OperationPhotos;
    NSMutableArray *photosOfmearry;
    NSMutableArray *Albemofmearry;
    TTTGlobalMethods *Method;
    NSMutableArray *PhotoList;
    BOOL ISDropdownopen;
    BOOL islastlocation;
    BOOL isFastLocation,IsChatMenuBoxOpen;
    NSString *TotalPhoto;
    NSString *ViewerId;
    UITapGestureRecognizer *TapGesture;
    NSString *HeaderText;
    


}

@property (strong, nonatomic) IBOutlet UIView *preparedropdownview;

@property (weak, nonatomic) IBOutlet UILabel *albamtextdriodown;

@property (weak, nonatomic) IBOutlet UILabel *Photosofmedropdown;
@property (strong, nonatomic) IBOutlet UIScrollView *PhotoSctroll;
@property (strong, nonatomic) IBOutlet UILabel *photosofmetxt;
@property (strong, nonatomic) IBOutlet UIView *ChatView;
@property (strong, nonatomic) IBOutlet UIView *Manuvire;
@property (strong, nonatomic) IBOutlet UIView *Screenview;
@property (strong, nonatomic) IBOutlet UIScrollView *MainphotocontentScroll;
@property (strong, nonatomic) IBOutlet UITableView *mainTblview;
@property (strong, nonatomic) UIRefreshControl *refresher;
@property (strong, nonatomic) IBOutlet UIImageView *DropdownSmallimg;
@property (weak, nonatomic) IBOutlet UIView *VfooterBack;

@property (weak, nonatomic) IBOutlet UILabel *TotalphotoLbl;

@property (weak, nonatomic) IBOutlet UIButton *Addphotopage;

@property (weak, nonatomic) IBOutlet UIButton *backButton;

@end

@implementation TTTPhotosofme
@synthesize mainTblview,Screenview,Manuvire,ChatView,photosofmetxt,PhotoSctroll,preparedropdownview,ParmuserofPhoto,backButton,ViewerName;

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
    ISDropdownopen=FALSE;
    isPhotosofme=TRUE;
    isAlbamofme=FALSE;
    mainTblview.hidden=YES;
    ViewerId=([ParmuserofPhoto length]>0)?ParmuserofPhoto:[self LoggedId];
    
    islastlocation=TRUE;
    Method=[[TTTGlobalMethods alloc]init];
    PhotoList=[[NSMutableArray alloc]init];
    Albemofmearry=[[NSMutableArray alloc]init];
    photosOfmearry=[[NSMutableArray alloc]init];
    OperationPhotos=[[NSOperationQueue alloc]init];
    self.refresher=[[UIRefreshControl alloc] init];
    // --Show Photo to photo view me or frien-- //
     if ([ParmuserofPhoto length]>0)
     {
        backButton.hidden=FALSE;
        self.Addphotopage.hidden=TRUE;
        HeaderText=[NSString stringWithFormat:@"%@ %@",@"Photos of",ViewerName];
         [[self Photosofmedropdown] setText:[NSString stringWithFormat:@"%@ photos",ViewerName]];
        
     }
     else
     {
        backButton.hidden=TRUE;
        self.Addphotopage.hidden=FALSE;
        HeaderText=@"Photos of me";
        UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panDetected:)];
        panRecognizer.delegate=self;
        [Screenview addGestureRecognizer:panRecognizer];
     }
    
    self.photosofmetxt.text=HeaderText;
   
    mainTblview.backgroundColor=[UIColor clearColor];
    
  
    [self AddNavigationBarTo:_VfooterBack withSelected:@""];
    IsLeftMenuBoxOpen=FALSE;
    [self AddLeftMenuTo:Manuvire];
    
    [self.refresher addTarget:self action:@selector(DomytableJob) forControlEvents:UIControlEventValueChanged];
    [[self mainTblview] addSubview:self.refresher];
    [self Dofirstjob];
    [self.photosofmetxt setFont:[UIFont fontWithName:MYREADPROREGULAR size:17.0f]];
    
}

//manu Slider operatiopn

- (void)panDetected:(UIPanGestureRecognizer *)panRecognizer
{
    
    CGPoint  stopLocation;
    [self keyboardhide];
      if(IsChatMenuBoxOpen==NO)
      {
          self.Manuvire.hidden=NO;
          self.ChatView.hidden=YES;
        
      if (panRecognizer.state == UIGestureRecognizerStateChanged)
        {
            
            stopLocation = [panRecognizer translationInView:self.Screenview];
            
            CGRect frame=[self.Screenview frame];
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
                        self.Screenview.frame=frame;
                        
                    }];
                    
                }
                else
                {
                    NSLog(@"close satisfied");
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
                    
                    NSLog(@"open satisfied");
                    [UIView animateWithDuration:.2 animations:^{
                        self.Screenview.frame=frame;
                        
                    }];
                    
                }
                else
                {
                    NSLog(@"close satisfied");
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
                NSLog(@"Left Menu closed %f",stopLocation.x);
                //self.Manuvire.hidden=YES;
                CGRect framelast=[self.Screenview frame];
                framelast.origin.x=0;
                
                
                [UIView animateWithDuration:.6 animations:^{
                    self.Screenview.frame=framelast;
                    
                }];
            }
            
            if (stopLocation.x*-1<100.0f&isFastLocation==TRUE&IsLeftMenuBoxOpen==YES)
            {
                NSLog(@"Left Menu opened%f",stopLocation.x);
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
    
   
    IsChatMenuBoxOpen=[self PerformChatSlider:self.Screenview withChatArea:self.ChatView IsOpen:IsChatMenuBoxOpen];
    if (IsChatMenuBoxOpen==FALSE) {
         self.Manuvire.hidden=NO;
    }
    else
    {
         self.Manuvire.hidden=YES;
    }
    
    
}


-(void)Dofirstjob
{
    
     [SVProgressHUD show];
     [PhotoList removeAllObjects];
      NSInvocationOperation *GetallPhotoOFme=[[NSInvocationOperation alloc] initWithTarget:self selector:@selector(getLatestPhotos) object:nil];
     [OperationPhotos addOperation:GetallPhotoOFme];
    
    
}
-(void)DomytableJob
{
    
       [SVProgressHUD show];
       [Albemofmearry removeAllObjects];
        NSInvocationOperation *GetallPhotoOFme=[[NSInvocationOperation alloc] initWithTarget:self selector:@selector(getAlbums) object:nil];
       [OperationPhotos addOperation:GetallPhotoOFme];
}


-(void)getAlbums
    {
        @try
        {
            NSString *URL=[NSString stringWithFormat:@"%@user.php?mode=getalbum&userid=%@&loggedin_userid=%@", API, ViewerId,[self LoggedId]];
            NSLog(@"get Albam  %@", URL);
            NSData *getData=[NSData dataWithContentsOfURL:[NSURL URLWithString:URL]];
            
            if([getData length]>2)
            {
                NSDictionary *Output=[NSJSONSerialization JSONObjectWithData:getData options:kNilOptions error:nil];
                NSArray *albumlist=[Output objectForKey:@"albumlist"];
                
                for(NSDictionary *var in albumlist)
                {
                    
                    NSMutableDictionary *mutDic=[[NSMutableDictionary alloc]init];
                    [mutDic setValue:[var objectForKey:@"album_id"] forKey:@"album_id"];
                    [mutDic setValue:[var objectForKey:@"album_name"] forKey:@"album_name"];
                    [mutDic setValue:[var objectForKey:@"thumbnail"] forKey:@"thumbnail"];
                    [mutDic setValue:[var objectForKey:@"count"] forKey:@"count"];
                    
                    
                    [Albemofmearry addObject:mutDic];
                   
                    
                    
                }
                
             [self performSelectorOnMainThread:@selector(LoadAlbumsofmenowatthattime) withObject:nil waitUntilDone:YES];
            }
            else
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [SVProgressHUD dismiss];
                    [self.refresher endRefreshing];
                    [SVProgressHUD showErrorWithStatus:@"Unexpected error occured."];
                });
            }
            
        }
        @catch (NSException *juju)
        {
            NSLog(@"Reporting juju from getAlbums : %@", juju);
        }
    }
    
 -(void)LoadAlbumsofmenowatthattime
{
    [SVProgressHUD dismiss];
    [mainTblview reloadData];
    [self.refresher endRefreshing];
}




-(void)getLatestPhotos
{
    @try
    {
        
        NSString *URL=[NSString stringWithFormat:@"%@user.php?mode=getlatestphoto&userid=%@&timezone=%@&loggedin_userid=%@", API, ViewerId, [self LocalTimeZoneName],[self LoggedId]];
        NSLog(@"%@", URL);
        NSData *getData=[NSData dataWithContentsOfURL:[NSURL URLWithString:URL]];
        
        if([getData length]>2)
        {
            NSDictionary *Output=[NSJSONSerialization JSONObjectWithData:getData options:kNilOptions error:nil];
            NSArray *photolist=[Output objectForKey:@"photolist"];
            NSArray *Extraparam=[Output objectForKey:@"extraparam"];
            NSDictionary *ExtraparamDic=[Extraparam objectAtIndex:0];
            TotalPhoto=[ExtraparamDic valueForKey:@"total_count"];
            
            
            for(NSDictionary *var in photolist)
            {
                NSMutableDictionary *mutDic=[[NSMutableDictionary alloc]init];
                [mutDic setValue:[var valueForKey:@"photo_id"] forKey:@"photo_id"];
                [mutDic setValue:[var valueForKey:@"albumid"] forKey:@"albumid"];
                [mutDic setValue:[var valueForKey:@"caption"] forKey:@"caption"];
                [mutDic setValue:[var valueForKey:@"location"] forKey:@"location"];
                [mutDic setValue:[var valueForKey:@"thumbnail"] forKey:@"thumbnail"];
               
                [mutDic setValue:[var valueForKey:@"original"] forKey:@"original"];
                [mutDic setValue:[var valueForKey:@"likecount"] forKey:@"likecount"];
                [mutDic setValue:[var valueForKey:@"commentcount"] forKey:@"commentcount"];
                [mutDic setValue:[var valueForKey:@"datetime"] forKey:@"datetime"];
                [mutDic setValue:[var valueForKey:@"isUserLiked"] forKey:@"isUserLiked"];
                
                [PhotoList addObject:mutDic];
                
            }
            
           
            [self performSelectorOnMainThread:@selector(LoadPhotoScroll) withObject:nil waitUntilDone:YES];
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
                [SVProgressHUD showErrorWithStatus:@"Unexpected error occured."];
            });
        }
        
    }
    @catch (NSException *juju)
    {
        NSLog(@"Reporting juju from getLatestPhotos : %@", juju);
    }
}

//Sent All the arry to the Photo Details page

-(void)ViewPhotos:(UITapGestureRecognizer *)Recognizer
{
    NSLog(@"The value of touch vire:");
    
    UIImageView *TouchedView=(UIImageView *)[[Recognizer self] view];
    NSString *TouchviewTag=[NSString stringWithFormat:@"%d",TouchedView.tag];

    TTTPhotodetailsViewController *PhotoDetais=[[TTTPhotodetailsViewController alloc]init];
    PhotoDetais.ParamPhotoArry=[PhotoList copy];
    PhotoDetais.ClickphotoId=TouchviewTag;
    [self presentViewController:PhotoDetais animated:YES completion:^{
        
    }];
    
}



-(void)LoadPhotoScroll
{
    
    [SVProgressHUD dismiss];
    CGFloat Thevalueofy=0.0f;
   
    int j=0;
    
    for (int i=0; i<[PhotoList count]; i++)
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
        [PhotoSctroll addSubview:Imageviewmain];
        UIActivityIndicatorView *Spinner=[[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(30, 30, 20, 20)];
        [Spinner startAnimating];
        [Imageviewmain addSubview:Spinner];
         NSMutableDictionary *PhotoDic=[PhotoList objectAtIndex:i];
        
        //---Download Image in imageview----//
        
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
    
    self.TotalphotoLbl.text=[NSString stringWithFormat:@"%@ %@",TotalPhoto,@"Photos"];
    self.TotalphotoLbl.font=[UIFont fontWithName:MYREADPROREGULAR size:16.0f];
    PhotoSctroll.contentSize=CGSizeMake(320, (([PhotoList count]*80)/4)+80);
    
}


- (IBAction)LeftManuopen:(id)sender
{
    [self keyboardhide];
    IsLeftMenuBoxOpen=[self PerformMenuSlider:Screenview withMenuArea:Manuvire IsOpen:IsLeftMenuBoxOpen];
    isFastLocation=IsLeftMenuBoxOpen;
    if (IsLeftMenuBoxOpen)
    {
        self.ChatView.hidden=YES;
    }
}

- (IBAction)Plusbuttonclick:(id)sender
{
    TTTAddPhotoWithoption *Addphoto=[[TTTAddPhotoWithoption alloc]init];
    [self presentViewController:Addphoto animated:YES completion:^{
        [SVProgressHUD dismiss];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//tableview data source


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    
    return [Albemofmearry count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSMutableDictionary *MutDicForAlbam=[Albemofmearry objectAtIndex:indexPath.row];
    static NSString *cellId=@"CellID";
    TTTcellforPhotoAlbam *PhotoAlbamcell = (TTTcellforPhotoAlbam *)[tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (PhotoAlbamcell==nil)
    {
        
        
        NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"TTTcellForPhotoAlbam" owner:self options:nil];
        PhotoAlbamcell = [arr objectAtIndex:0];
        UIImageView *ImageView=(UIImageView *)[PhotoAlbamcell.contentView viewWithTag:100];
        UIActivityIndicatorView *Spinner=(UIActivityIndicatorView *)[PhotoAlbamcell.contentView viewWithTag:104];
        NSURLRequest *request_img4 = [NSURLRequest requestWithURL:[NSURL URLWithString:[MutDicForAlbam objectForKey:@"thumbnail"]]];
        AFImageRequestOperation *operation = [AFImageRequestOperation imageRequestOperationWithRequest:request_img4
                                                                                  imageProcessingBlock:nil
                                                                                               success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                                                                   if(image!=nil)
                                                                                                   {
                                                                                                       
                                                                                                       ImageView.image=image;
                                                                                                       [Spinner stopAnimating];
                                                                                                   }
                                                                                                   
                                                                                               }
                                                                                               failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error)
                                              {
                                                  NSLog(@"The errorcode:%@",error);
                                                  [Spinner stopAnimating];
                                                  
                                              }];
        [operation start];

        UILabel *AlbamnameLbl=(UILabel *)[PhotoAlbamcell.contentView viewWithTag:101];
        AlbamnameLbl.font=[UIFont fontWithName:MYRIARDPROSAMIBOLT size:15.0f];
        AlbamnameLbl.text=[MutDicForAlbam valueForKey:@"album_name"];
        AlbamnameLbl.textColor=[UIColor whiteColor];
        
        UILabel *Totalnoofimage=(UILabel *)[PhotoAlbamcell.contentView viewWithTag:102];
        Totalnoofimage.font=[UIFont fontWithName:MYRIARDPROLIGHT size:15.0f];
        Totalnoofimage.textColor=[UIColor whiteColor];
        Totalnoofimage.text=[MutDicForAlbam valueForKey:@"count"];
        
    }
    
    [PhotoAlbamcell setBackgroundColor:[UIColor clearColor]];
    
    
    
     return PhotoAlbamcell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *MutDicForAlbam=[Albemofmearry objectAtIndex:indexPath.row];
    TTTShowphotosofalbam *Showphotosofalbam=[[TTTShowphotosofalbam alloc]init];
     Showphotosofalbam.Albamname=[MutDicForAlbam objectForKey:@"album_name"];
     Showphotosofalbam.AlbamId=[MutDicForAlbam objectForKey:@"album_id"];
    Showphotosofalbam.paramviewId=ViewerId;
    Showphotosofalbam.TotalComment=[MutDicForAlbam objectForKey:@"count"];
    [self presentViewController:Showphotosofalbam animated:YES completion:^{
        
        [SVProgressHUD dismiss];
        
    }];
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
   return 61.0f;
}

- (IBAction)Handeldeopdown:(id)sender
{
    _albamtextdriodown.hidden=YES;
    _Photosofmedropdown.hidden=YES;
    
    
    preparedropdownview.frame=CGRectMake(0, 60, 320, 0);
    [self.preparedropdownview setBackgroundColor:UIColorFromRGB(0x9cc6d9)];
    
    [Screenview addSubview:preparedropdownview];
    
    
    if (ISDropdownopen==FALSE)
    {
        [preparedropdownview setHidden:NO];
        self.DropdownSmallimg.hidden=YES;
        
        [UIView animateWithDuration:.2 animations:^{
            preparedropdownview.frame=CGRectMake(0, 60, 320, 110);
            
        }
                         completion:^(BOOL finished)
         {
             ISDropdownopen=TRUE;
             
             _albamtextdriodown.hidden=NO;
             _Photosofmedropdown.hidden=NO;
                }];
    }
    else
    {
        _albamtextdriodown.hidden=YES;
        _Photosofmedropdown.hidden=YES;
       
         self.DropdownSmallimg.hidden=NO;
        
        [UIView animateWithDuration:.2 animations:^{
            preparedropdownview.frame=CGRectMake(0, 60, 320, 0);
            
        }
                         completion:^(BOOL finished)
         {
             ISDropdownopen=FALSE;
             
             [preparedropdownview setHidden:YES];
             [preparedropdownview removeFromSuperview];
         }];
    }

}
-(void)viewDidDisappear:(BOOL)animated
{
    [OperationPhotos cancelAllOperations];
}

- (IBAction)Showmyallphotoiamtaged:(id)sender
{
    self.photosofmetxt.text=HeaderText;
    ISDropdownopen=FALSE;
    mainTblview.hidden=YES;
    PhotoSctroll.hidden=NO;
    self.TotalphotoLbl.hidden=FALSE;
    [UIView animateWithDuration:.2 animations:^{
        preparedropdownview.frame=CGRectMake(0, 60, 320, 0);
        
    }
                     completion:^(BOOL finished)
     {
         ISDropdownopen=FALSE;
         
         [preparedropdownview setHidden:YES];
         [preparedropdownview removeFromSuperview];
         self.DropdownSmallimg.hidden=NO;
     }];
    [self Dofirstjob];
    
    
}

- (IBAction)Showmyphotoalbam:(id)sender
{
    self.photosofmetxt.text=@"Photo Albums";
    ISDropdownopen=FALSE;
    PhotoSctroll.hidden=YES;
    mainTblview.hidden=NO;
    self.TotalphotoLbl.hidden=YES;
    [UIView animateWithDuration:.2 animations:^{
        preparedropdownview.frame=CGRectMake(0, 60, 320, 0);
        
    }
                     completion:^(BOOL finished)
     {
         ISDropdownopen=FALSE;
         
         [preparedropdownview setHidden:YES];
         [preparedropdownview removeFromSuperview];
         self.DropdownSmallimg.hidden=NO;
     }];
    
    [self DomytableJob];
}
- (IBAction)BackTopriviousPage:(id)sender
{
  //  [self PerformGoBack];
    [self PerformGoBackWithTransitationFrom:kCATransitionFromBottom];
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
