//
//  TTTProfileViewController.m
//  TickTockTee
//
//  Created by Esolz Tech on 29/03/14.
//  Copyright (c) 2014 com.esolz.TickTockTee. All rights reserved.
//

#import "TTTProfileViewController.h"
#import "AFNetworking.h"
#import "AFImageRequestOperation.h"
#import "AFJSONRequestOperation.h"
#import "TTTStatisticsViewController.h"
#import "TTTShowAllfriendmanu.h"
#import "TTTPhotosofme.h"
#import "TTTAchievementStatisticViewController.h"
#import "TTTCretenewmessage.h"
#import "TTTMatchListing.h"

@interface TTTProfileViewController ()<NSURLConnectionDelegate>{
    BOOL IsLeftMenuBoxOpen;
    NSMutableData *datax;
    NSURL *url;
    BOOL islastlocation;
    BOOL isFastLocation,IsChatMenuBoxOpen;
}
@property (strong, nonatomic) IBOutlet UIView *vfooterbackview;

@property (weak, nonatomic) IBOutlet UIButton *BackButtonClick;
@property (weak, nonatomic) IBOutlet UIButton *menu;
@property (strong, nonatomic) IBOutlet UIView *chatBoxView;
@end

@implementation TTTProfileViewController
@synthesize profileTable,ParamprofileViewerId,BackButtonClick,menu;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [super viewDidAppear:YES];
    [_indicatorOnScreen stopAnimating];
    IsChatMenuBoxOpen=NO;
    islastlocation=TRUE;
    isFastLocation=TRUE;
    [self AddLeftMenuTo:_sideView];
    
    [self setRoundBorderToImageView:_profileImage];
    [self SetroundborderWithborderWidth:2.0f WithColour:[UIColor whiteColor] ForView:_viewOnProfileImage];
    [self AddNavigationBarTo:_vfooterbackview];
    
    
    
    _scrollMenu.clipsToBounds=YES;
    [_indicatorOnProfile startAnimating];
    _dict=[[NSDictionary alloc]init];
    
    _profileTTHCP.font=[UIFont fontWithName:MYRIARDPROLIGHT size:18];
    _profilePoints.font=[UIFont fontWithName:MYRIARDPROLIGHT size:18];
    _profileName.font=[UIFont fontWithName:MYREADPROREGULAR size:18];
    _profilePlace.font=[UIFont fontWithName:MYREADPROREGULAR size:12];
    
    _loggedInUserid=[self LoggedId];
    _MainLabel.text=[NSString stringWithFormat:@"%@'s Profile",_mainLabelString];
    ParamprofileViewerId=([ParamprofileViewerId length]>0)?ParamprofileViewerId:[self LoggedId];
    [self initializeDict];
    
    if([_loggedInUserid isEqualToString:ParamprofileViewerId])
    {
        _unflowButton.hidden=NO;
        _messagebutton.hidden=NO;
        _plusButton.hidden=YES;
        self.menu.hidden=NO;
        self.BackButtonClick.hidden=YES;
        UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panDetected:)];
        [_screenView addGestureRecognizer:panRecognizer];
        
    }
    else{
        _unflowButton.hidden=YES;
        _messagebutton.hidden=YES;
        _plusButton.hidden=NO;
        self.menu.hidden=YES;
        self.BackButtonClick.hidden=NO;
    }
    profileTable.delegate=self;
    profileTable.dataSource=self;
    IsLeftMenuBoxOpen=FALSE;
    _indicatorOnScreen.center=CGPointMake(_screenView.bounds.size.width/2, _screenView.bounds.size.height/2);   //_screenView.bounds.size.width/2,;
    [_indicatorOnScreen startAnimating];
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
            
            stopLocation = [panRecognizer translationInView:_screenView];
            
            CGRect frame=[_screenView frame];
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
                        _screenView.frame=frame;
                        
                    }];
                    
                }
                else
                {
                    NSLog(@"close satisfied");
                    IsLeftMenuBoxOpen=YES;
                    isFastLocation=TRUE;
                    CGRect lastFrame=[_screenView frame];
                    lastFrame.origin.x=260;
                    [UIView animateWithDuration:.5 animations:^{
                        _screenView.frame=lastFrame;
                        
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
                        _screenView.frame=frame;
                        
                    }];
                    
                }
                else
                {
                    NSLog(@"close satisfied");
                    IsLeftMenuBoxOpen=NO;
                    islastlocation=TRUE;
                    CGRect lastFrame2=[_screenView frame];
                    lastFrame2.origin.x=0;
                    [UIView animateWithDuration:.5 animations:^{
                        _screenView.frame=lastFrame2;
                        
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
                CGRect framelast=[_screenView frame];
                framelast.origin.x=0;
                
                
                [UIView animateWithDuration:.6 animations:^{
                    _screenView.frame=framelast;
                    
                }];
            }
            
            if (stopLocation.x*-1<100.0f&isFastLocation==TRUE&IsLeftMenuBoxOpen==YES)
            {
                NSLog(@"Left Menu opened%f",stopLocation.x);
                
                CGRect framelast=[_screenView frame];
                framelast.origin.x=260;
                
                
                [UIView animateWithDuration:.6 animations:^{
                    _screenView.frame=framelast;
                    
                }];
                
            }
            
            
        }
        
    }
    
}


-(void)PerformChatSliderOperation
{
    
    IsChatMenuBoxOpen=[self PerformChatSlider:_screenView withChatArea:self.chatBoxView IsOpen:IsChatMenuBoxOpen];
    NSLog(@"PerformChatSliderOperation %@",IsChatMenuBoxOpen?@"YES":@"NO");
    
}

-(void)viewDidAppear:(BOOL)animated{
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark NSURLConnectionDelegate
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    datax.length=0;
    
}


-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [datax appendData:data];
}


-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"Failed with Error---");
}


-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSError *error;
    // datax=[NSData dataWithContentsOfURL:url options:0 error:&error];
    if(!error){
        _dict=[NSJSONSerialization JSONObjectWithData:datax  options:kNilOptions error:nil];
        if(!error){
            [self setimage:[_dict objectForKey:@"coverphoto"] tag:1];
            [self setimage:[_dict objectForKey:@"thumb"] tag:0];
            _profileName.text=[_dict objectForKey:@"userfullname"];
            NSString *mainString;
            if ([[_dict objectForKey:@"CityTown"] length]>0&&[[_dict objectForKey:@"State"] length]>0&&[[_dict objectForKey:@"Country"] length]>0)
            {
                mainString=[NSString stringWithFormat:@"%@, %@, %@",[self RemoveNullandreplaceWithSpace:[_dict objectForKey:@"CityTown"]],[self RemoveNullandreplaceWithSpace:[_dict objectForKey:@"State"] ],[self RemoveNullandreplaceWithSpace:[_dict objectForKey:@"Country"]]];
            }
            else if ([[_dict objectForKey:@"CityTown"] length]==0&&[[_dict objectForKey:@"State"] length]>0&&[[_dict objectForKey:@"Country"] length]>0)
            {
                mainString=[NSString stringWithFormat:@"%@, %@",[self RemoveNullandreplaceWithSpace:[_dict objectForKey:@"State"]],[self RemoveNullandreplaceWithSpace:[_dict objectForKey:@"Country"]]];
            }
            else if ([[_dict objectForKey:@"CityTown"] length]==0&&[[_dict objectForKey:@"State"] length]==0&&[[_dict objectForKey:@"Country"] length]>0)
            {
                mainString=[NSString stringWithFormat:@"%@",[self RemoveNullandreplaceWithSpace:[_dict objectForKey:@"Country"]]];
            }
            
            
            _profilePlace.text=mainString;
            _profileTTHCP.text=[_dict objectForKey:@"handicapindex"];
            _profilePoints.text=[_dict objectForKey:@"points"];
            _lblFriends.text=[NSString stringWithFormat:@"(%@)",[_dict objectForKey:@"myfriendCount"]];
            _lblPhotos.text=[NSString stringWithFormat:@"(%@)",[_dict objectForKey:@"myphotoCount"]];
            
        }
        else
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error during json creation"
                                                                message:[error localizedDescription]
                                                               delegate:nil
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil];
            [alertView show];
        }
        _MainLabel.text=[_dict objectForKey:@"username"];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error Retrieving data"
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
    }
    [_indicatorOnProfile stopAnimating];
    [_indicatorOnProfile hidesWhenStopped];
}
#pragma mark UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  5;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    cell=[tableView dequeueReusableCellWithIdentifier:@"profileCell"];
    if(cell==nil){
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"profileCell"];
    }
    
    cell.backgroundColor=[UIColor clearColor];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    if(indexPath.row==0){
        [cell.contentView addSubview:_headerView];
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==0)
    {
        return _headerView.frame.size.height;
    }
    else
    {
        return 50;
    }
    
}

-(void)initializeDict
{
    NSString *stringurl = [NSString stringWithFormat:@"%@user.php?mode=userprofile&userid=%@&loggedin_userid=%@",API,ParamprofileViewerId,[self LoggedId]];
    NSLog(@"stringurl %@",stringurl);
    NSURL *urlinisilize = [NSURL URLWithString:stringurl];
    NSURLRequest *req = [NSURLRequest requestWithURL:urlinisilize];
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:req delegate:self];
    if (connection)
    {
        datax = [[NSMutableData alloc]init];
    }
    [_indicatorOnProfile startAnimating];
}


-(void)setimage:(NSString *)urldata tag:(int)i
{
    
    NSURLRequest *request_img = [NSURLRequest requestWithURL:[NSURL URLWithString:urldata]];
    AFImageRequestOperation *operation = [AFImageRequestOperation imageRequestOperationWithRequest:request_img
                                                                              imageProcessingBlock:nil
                                                                                           success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                                                               if(image!=nil)
                                                                                               {
                                                                                                   
                                                                                                   if(i==0){
                                                                                                       [_profileImage setImage:image];
                                                                                                       NSLog(@"The value of image :%@",image);
                                                                                                       
                                                                                                       
                                                                                                       [_indicatorOnProfile stopAnimating];
                                                                                                       
                                                                                                       
                                                                                                   }
                                                                                                   if(i==1){
                                                                                                       [_holeProfileImage setImage:image];
                                                                                                       
                                                                                                   }
                                                                                               }
                                                                                               
                                                                                           }
                                                                                           failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                                                                               NSLog(@"Error %@",error);
                                                                                               
                                                                                               NSLog(@"error")
                                                                                               ;
                                                                                               
                                                                                               
                                                                                           }];
    [operation start];
    
    
}
- (IBAction)menuClicked:(id)sender
{
    [self keyboardhide];
    IsLeftMenuBoxOpen=[self PerformMenuSlider:_screenView withMenuArea:_sideView IsOpen:IsLeftMenuBoxOpen];
    
}
- (IBAction)unflowAction:(id)sender
{
    
}
- (IBAction)messageAction:(id)sender
{
    TTTCretenewmessage *creteNewmsg=[[TTTCretenewmessage alloc]init];
    creteNewmsg.MessageSenderid=ParamprofileViewerId;
    creteNewmsg.friendName=_mainLabelString;
    creteNewmsg.Friendimageurl=[_dict objectForKey:@"thumb"];
    [self presentViewController:creteNewmsg animated:YES completion:^{
        [SVProgressHUD dismiss];
    }];
}

- (IBAction)previousAction:(id)sender
{
    CGPoint p=[_scrollMenu contentOffset];
    if(p.x>54)
        [_scrollMenu setContentOffset:CGPointMake(p.x-70,p.y) animated:YES];
    _previous.userInteractionEnabled=NO;
    _next.userInteractionEnabled=YES;
    [_previous setBackgroundImage:[UIImage imageNamed:@"left-arrow-black"] forState:UIControlStateNormal];
    
}

- (IBAction)nextAction:(id)sender {
    CGPoint p=[_scrollMenu contentOffset];
    if(p.x<54)
        [_scrollMenu setContentOffset:CGPointMake(p.x+70,p.y) animated:YES];
    _next.userInteractionEnabled=NO;
    _previous.userInteractionEnabled=YES;
    [_previous setBackgroundImage:[UIImage imageNamed:@"left-arrow"] forState:UIControlStateNormal];
}
- (IBAction)goStatistics:(id)sender
{
    if([_loggedInUserid isEqualToString:ParamprofileViewerId])
    {
        ParamprofileViewerId=@"";
    }
    
    TTTStatisticsViewController *achievement=[[TTTStatisticsViewController alloc]init];
    achievement.paramviewID=ParamprofileViewerId;
    [self PushViewController:achievement TransitationFrom:kCATransitionFade];
}
- (IBAction)goBadges:(id)sender
{
    if([_loggedInUserid isEqualToString:ParamprofileViewerId])
    {
        ParamprofileViewerId=@"";
    }
    TTTAchievementStatisticViewController *AchiveMent=[[TTTAchievementStatisticViewController alloc]init];
    AchiveMent.ParamViewid=ParamprofileViewerId;
    [self PushViewController:AchiveMent TransitationFrom:kCATransitionFade];
}

- (IBAction)plusClickedAction:(id)sender
{
    
    
}

- (IBAction)GoestoFeiendlist:(id)sender
{
    if([_loggedInUserid isEqualToString:ParamprofileViewerId])
    {
        ParamprofileViewerId=@"";
    }
    TTTShowAllfriendmanu *Showfriend=[[TTTShowAllfriendmanu alloc]init];
    Showfriend.Parmfrienduserid=ParamprofileViewerId;
    [self PushViewController:Showfriend TransitationFrom:kCATransitionFade];
}
- (IBAction)photosofuserpagelink:(id)sender
{
    NSLog(@"the vphoto button click");
    if([_loggedInUserid isEqualToString:ParamprofileViewerId])
    {
        ParamprofileViewerId=@"";
    }
    TTTPhotosofme *photosofme=[[TTTPhotosofme alloc]init];
    photosofme.ParmuserofPhoto=ParamprofileViewerId;
    photosofme.ViewerName=_mainLabelString;
    [self PushViewController:photosofme TransitationFrom:kCATransitionFade];
}


- (IBAction)ShowMatches:(id)sender
{
    if([_loggedInUserid isEqualToString:ParamprofileViewerId])
    {
        ParamprofileViewerId=@"";
    }
    TTTMatchListing *matchList=[[TTTMatchListing alloc]init];
    matchList.ParamUserID=ParamprofileViewerId;
    [self PushViewController:matchList TransitationFrom:kCATransitionFade];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    
    CGRect frame=[self.Scarchicon frame];
    frame.origin.x=9;
    [UIView animateWithDuration:.3f animations:^{
        
        self.Scarchicon.frame=frame;
        
        
    }];
    
    
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    
    [textField resignFirstResponder];
    
    
    if ([self.manuSearchtxt.text length]<1)
    {
        CGRect frame=[self.Scarchicon frame];
        frame.origin.x=122;
        [UIView animateWithDuration:.3f animations:^{
            
            self.Scarchicon.frame=frame;
            
            
        }];
        
    }
    
    return YES;
}

-(void)keyboardhide{
    
    [self.manuSearchtxt resignFirstResponder];
    [SVProgressHUD dismiss];
    if ([self.manuSearchtxt.text length]<1 && self.Scarchicon.frame.origin.x==9)
    {
        CGRect frame=[self.Scarchicon frame];
        frame.origin.x=122;
        [UIView animateWithDuration:.3f animations:^{
            
            self.Scarchicon.frame=frame;
            
            
        }];
    }
    
}

- (IBAction)backButtonClick:(id)sender
{
    [self PerformGoBack];
}
@end
