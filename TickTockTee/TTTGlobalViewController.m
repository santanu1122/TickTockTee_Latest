//
//  TTTGlobalViewController.m
//  Ticktocktee
//
//  Created by Iphone_2 on 17/02/14.
//  Copyright (c) 2014 com.esolz.Ticktocktee. All rights reserved.
//

#import "TTTGlobalViewController.h"
#import "TTTLoginViewController.h"
#import "TTTMatchListing.h"
#import "TTTSignInuploadImage.h"
#import "TTTActivityStreem.h"
#import <CoreImage/CoreImage.h>
#import <CoreGraphics/CoreGraphics.h>
#import "FXBlurView.h"
#import "TTTScorecardList.h"
#import "TTTStatisticsViewController.h"
#import "TTTPhotosofme.h"
#import "AFNetworking.h"
#import "TTTProfileViewController.h"
#import "TTTShowAllfriendmanu.h"
#import "TTTNotificationViewController.h"
#import "TTTAcceptFndrequest.h"
#import "TTTMessageListViewController.h"
#import "TTTCourseListViewController.h"
#import "TTTVideoListViewController.h"
#import "TTTCretenewmessage.h"
#import "AFImageRequestOperation.h"




@interface TTTGlobalViewController ()

{
    
    UITapGestureRecognizer *TapGestureGlobal;
    NSMutableArray  *MenuViewContainer;
    BOOL DontDoAnyThing, GlobalIsMenuOpen, GlobalIsCourseOpen, IsPerformingMenu;
    UILabel *LblGlobalMore;
     @private NSUserDefaults *PrivateLogger;
    NSOperationQueue *GlobalOperationQueue;
    UIView *VMenuBack, *VCourseBack, *VCourseMenuBack, *VMenuMenuBack, *VSwipeProtector;
    UIImageView *ImgMenuIndecator, *ImgCourseIndecator;
    UIScrollView *SVLeftBack;
    NSTimer *ChatRefresherTimer;
    NSOperationQueue *ChatOperationQueue;
    UIPanGestureRecognizer *GlobalPanGesture;
    TTTGlobalMethods *GlobalMethodInLocal;
    NSArray *manuarray;
    
    NSMutableArray *arrChat;//TEST Array decleared here
    UIView *chatArea;
   UIActivityIndicatorView *activityonChat;
    
    NSTimer *nbotificationtimer;
}
@property (strong, nonatomic) IBOutlet UIScrollView *manuContainScroll;
@property (strong,nonatomic)UIScrollView *scrlChatView;



@property(nonatomic, retain) UILabel *messageBadges;

@property(nonatomic, retain) UILabel *notificationBadges;

@property(nonatomic, retain) UILabel *activityBadges;

@property(nonatomic, retain) UILabel *onlineBadges;



typedef enum {
    MFSideMenuPanDirectionNone,
    MFSideMenuPanDirectionLeft,
    MFSideMenuPanDirectionRight
} MFSideMenuPanDirection;

typedef enum {
    MFSideMenuPanModeNone = 0, // pan disabled
    MFSideMenuPanModeCenterViewController = 1 << 0, // enable panning on the centerViewController
    MFSideMenuPanModeSideMenu = 1 << 1, // enable panning on side menus
    MFSideMenuPanModeDefault = MFSideMenuPanModeCenterViewController | MFSideMenuPanModeSideMenu
} MFSideMenuPanMode;

typedef enum {
    MFSideMenuStateClosed, // the menu is closed
    MFSideMenuStateLeftMenuOpen, // the left-hand menu is open
    MFSideMenuStateRightMenuOpen // the right-hand menu is open
} MFSideMenuState;

typedef enum {
    MFSideMenuStateEventMenuWillOpen, // the menu is going to open
    MFSideMenuStateEventMenuDidOpen, // the menu finished opening
    MFSideMenuStateEventMenuWillClose, // the menu is going to close
    MFSideMenuStateEventMenuDidClose // the menu finished closing
} MFSideMenuStateEvent;


@property (nonatomic, assign) MFSideMenuPanDirection panDirection;
@property (nonatomic, assign) CGPoint panGestureOrigin;
@property (nonatomic, assign) MFSideMenuState menuState;
@property (nonatomic, assign) CGFloat rightMenuWidth;

@property (nonatomic, assign) CGFloat menuSlideAnimationFactor;
@property (nonatomic, assign) CGFloat menuWidth;
@property (nonatomic, strong) UIView *menuContainerView;
@property (nonatomic, assign) CGFloat menuAnimationDefaultDuration;
@property (nonatomic, assign) CGFloat menuAnimationMaxDuration;
@property (nonatomic, assign) MFSideMenuPanMode panMode;
@property (nonatomic, assign) CGFloat panGestureVelocity;
@property (nonatomic, assign) CGFloat leftMenuWidth;
@property (nonatomic, assign) UIView *Panview;

@property (weak, nonatomic) IBOutlet UIScrollView *mainmanuScrrol;



@end

@implementation TTTGlobalViewController

@synthesize IsShown, TblChat, ChaterArray, FriendRqstBadges, PresentViewController;
@synthesize scrlChatView;
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
    self.rightMenuWidth=260.0f;
    self.menuContainerView = [[UIView alloc] init];
    self.menuState = MFSideMenuStateClosed;
    self.menuWidth = 260.0f;
    self.menuSlideAnimationFactor = 3.0f;
    self.menuAnimationDefaultDuration = 0.2f;
    self.menuAnimationMaxDuration = 0.4f;
    self.panMode = MFSideMenuPanModeDefault;
    MenuViewContainer=[[NSMutableArray alloc] init];
    GlobalOperationQueue=[[NSOperationQueue alloc] init];
    ChaterArray=[[NSMutableArray alloc] init];
  
    
    GlobalMethodInLocal=[[TTTGlobalMethods alloc] init];
    
    [self setIsShown:NO];
    
    DontDoAnyThing=FALSE;
    GlobalIsMenuOpen=TRUE;
    GlobalIsCourseOpen=TRUE;
    IsPerformingMenu=TRUE;
    
    PrivateLogger=[[NSUserDefaults alloc] init];
    ChatOperationQueue=[[NSOperationQueue alloc] init];
    scrlChatView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 36, 260, 532)];
//    [self Donotification];
//     nbotificationtimer=[NSTimer timerWithTimeInterval:10 target:self selector:@selector(Donotification) userInfo:nil repeats:YES];
}
-(void)Donotification
{
    NSInvocationOperation *Notification=[[NSInvocationOperation alloc]initWithTarget:self selector:@selector(thevalueofeachnotification) object:nil];
    [GlobalOperationQueue addOperation:Notification];
}
-(void)viewDidLayoutSubviews
{
   // [self.manuContainScroll setContentSize:CGSizeMake(260, 1000)];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [ChatRefresherTimer invalidate];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


-(void)RefreshChat
{
    if([[self LoggedId] integerValue]>0)
    {
        NSInvocationOperation *Invoc=[[NSInvocationOperation alloc] initWithTarget:self selector:@selector(getOnlineFriends) object:nil];
        [ChatOperationQueue addOperation:Invoc];
    }
}



#pragma mark for Thread Segment

-(void)getOnlineFriends
{
    @try
    {
        if ([self isConnectedToInternet])
        {
            NSString *URL=[NSString stringWithFormat:@"%@user.php?mode=getOnlineUsers&userid=%@", API, [self LoggedId]];
          
            NSData *getData=[NSData dataWithContentsOfURL:[NSURL URLWithString:URL]];
            
            if([getData length]>2)
            {
                [ChaterArray removeAllObjects];
                
                NSDictionary *Output=[NSJSONSerialization JSONObjectWithData:getData options:kNilOptions error:nil];
                NSArray *OnlineFriends=[Output objectForKey:@"onlinedetails"];
                NSString *TotalPendingRequest=[Output valueForKey:@"totalFriendRequest"];
                
                for(NSDictionary *var in OnlineFriends)
                {
                    if(![[var objectForKey:@"id"] isEqualToString:[self LoggedId]])
                    {
                        [ChaterArray addObject:[[TTTGlobalMethods alloc] initWithId:[var objectForKey:@"id"] withUserName:[var objectForKey:@"username"] withName:[var objectForKey:@"fullname"] withEmail:[var objectForKey:@"email"] withPhotoURL:[var objectForKey:@"image"]]];
                    }
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if(![TotalPendingRequest isEqualToString:@"0"])
                    {
                        [FriendRqstBadges setText:TotalPendingRequest];
                        [FriendRqstBadges setHidden:NO];
                    }
                    else
                    {
                        [FriendRqstBadges setHidden:YES];
                    }
                    
                    [TblChat reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
                    
                });
                
            }

        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [SVProgressHUD showErrorWithStatus:@"No internet connection available"];
            });
        }
    }
    @catch (NSException *juju)
    {
        NSLog(@"Reporting juju from getLocation : %@", juju);
    }
}




-(BOOL)IsCurrentViewController:(NSString *)controller
{
    int count=[[[self navigationController] viewControllers] count];
    
    if([controller isEqualToString:NSStringFromClass([[[[self navigationController] viewControllers] objectAtIndex:(count -1)] class])])
    {
        return TRUE;
    }
    return FALSE;
}

-(void)SetBackground:(UIView *)VictimView
{
    //[VictimView setBackgroundColor:UIColorFromRGB(0x0E2D4B)];
    //[VictimView setBackgroundColor:UIColorFromRGB(0x233E53)];
    [VictimView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"ciBg.png"]]];
}

-(void)SetBackground:(UIView *)VictimView :(NSString *)ImageName
{
    UIGraphicsBeginImageContext(VictimView.frame.size);
    [[UIImage imageNamed:ImageName] drawInRect:VictimView.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    VictimView.backgroundColor=[UIColor colorWithPatternImage:image];
}


-(void) PerformGoBackTo:(NSString *)HereWeGo WithAnimation:(BOOL)Animation
{
    CATransition* transition = [CATransition animation];
    transition.duration = 0.5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade; //kCATransitionMoveIn; //, kCATransitionPush, kCATransitionReveal, kCATransitionFade
    //transition.subtype = kCATransitionFromTop; //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
    
    int index=0;
    NSArray* arr = [[NSArray alloc] initWithArray:self.navigationController.viewControllers];
    for(int i=0 ; i<[arr count] ; i++)
    {
        if([[arr objectAtIndex:i] isKindOfClass:NSClassFromString(HereWeGo)])
        {
            index = i;
        }
    }
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    [self.navigationController popToViewController:[arr objectAtIndex:index] animated:NO];
}

-(void)PerformGoBack
{
    [self PerformGoBackWithNoOfTimes:1];
}

-(void)PerformGoBackWithNoOfTimes:(int)Times
{
    NSArray* arr = [[NSArray alloc] initWithArray:self.navigationController.viewControllers];
    int index=[arr count]-(1+Times);
    if(PresentViewController)
    {
        CATransition *Transition=[CATransition animation];
        [Transition setDuration:0.4f];
        [Transition setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
        [Transition setType:kCATransitionMoveIn];
        [Transition setSubtype:kCATransitionFromBottom];
        [[[[self navigationController] view] layer] addAnimation:Transition forKey:nil];
        [self.navigationController popToViewController:[arr objectAtIndex:index] animated:NO];
    }
    else
        [self.navigationController popToViewController:[arr objectAtIndex:index] animated:YES];
}

-(void)PerformGoBackWithTransitationFrom:(NSString *)TransitationDirection
{
    NSArray* arr = [[NSArray alloc] initWithArray:self.navigationController.viewControllers];
    int index=[arr count]-2;
    CATransition *Transition=[CATransition animation];
    [Transition setDuration:0.4f];
    [Transition setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    [Transition setType:kCATransitionPush];
    [Transition setSubtype:TransitationDirection];
    [[[[self navigationController] view] layer] addAnimation:Transition forKey:nil];
    [self.navigationController popToViewController:[arr objectAtIndex:index] animated:NO];
}

-(void) PerformGoBackTo:(NSString *)HereWeGo
{
    NSArray *StackArray = [[NSArray alloc] initWithArray:self.navigationController.viewControllers];
    [self.navigationController popToViewController:[StackArray objectAtIndex:[self getStatckIndex:HereWeGo]] animated:YES];
}

-(void)PopToStackIndex:(int)StackIndex NeedAnimation :(BOOL)Animation
{
    NSArray *StackArray = [[NSArray alloc] initWithArray:self.navigationController.viewControllers];
    [self.navigationController popToViewController:[StackArray objectAtIndex:StackIndex] animated:Animation];
}

-(int)getStatckIndex:(NSString *)Object
{
    NSArray* arr = [[NSArray alloc] initWithArray:self.navigationController.viewControllers];
    for(int i=0 ; i<[arr count] ; i++)
    {
        if([[arr objectAtIndex:i] isKindOfClass:NSClassFromString(Object)])
        {
            return i;
        }
    }
    return 0;
}

-(void)PushViewController:(UIViewController *)viewController WithAnimation:(NSString *)AnimationType
{
    CATransition *Transition=[CATransition animation];
    [Transition setDuration:0.4f];
    [Transition setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    [Transition setType:AnimationType];
    //[Transition setSubtype:AnimationType];
    [[[[self navigationController] view] layer] addAnimation:Transition forKey:nil];
    [[self navigationController] pushViewController:viewController animated:NO];
}

-(void)PopViewController:(NSString *)viewControllerName WithAnimation:(NSString *)AnimationType
{
    CATransition *Transition=[CATransition animation];
    [Transition setDuration:0.4f];
    [Transition setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    [Transition setType:AnimationType];
    //[Transition setSubtype:AnimationType];
    
    NSArray *StackArray = [[NSArray alloc] initWithArray:self.navigationController.viewControllers];
    
    [[[[self navigationController] view] layer] addAnimation:Transition forKey:nil];
    [self.navigationController popToViewController:[StackArray objectAtIndex:[self getStatckIndex:viewControllerName]] animated:NO];
}


-(void)PushViewController:(UIViewController *)viewController TransitationFrom:(NSString *)TransitationDirection
{
    CATransition *Transition=[CATransition animation];
    [Transition setDuration:0.4f];
    [Transition setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    [Transition setType:kCATransitionPush];
    [Transition setSubtype:TransitationDirection];
    [[[[self navigationController] view] layer] addAnimation:Transition forKey:nil];
    [[self navigationController] pushViewController:viewController animated:NO];
}


-(void)PerformLogout
{
    NSUserDefaults *UserId = [NSUserDefaults standardUserDefaults];
    
    
     [UserId setObject:@"" forKey:SESSION_LOGGERNAME];
     [UserId setObject:@"" forKey:SESSION_LOGGERIMAGEDATA];
     [UserId valueForKey:SESSION_USERNAME];
     [UserId valueForKey:SESSION_PASSWORD];
     [UserId valueForKey:SESSION_ID];
     [UserId synchronize];
   // [[FBSession activeSession ] close];
    //  [[FBSession activeSession] closeAndClearTokenInformation];
   // [FBSession setActiveSession:nil];
    [self PerformGoBackTo:@"SignInScreen"];
}

-(NSString *)LocalDate
{
    NSDateFormatter *formatter;
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    return [formatter stringFromDate:[NSDate date]];
}



-(NSData *)LoggerProfileImageData
{
    return [PrivateLogger valueForKey:SESSION_LOGGERIMAGEDATA];
}

-(NSString *)LoggedId
{
    return [PrivateLogger valueForKey:SESSION_ID];
}

-(NSString *)LoggerImageURL
{
    return [PrivateLogger valueForKey:SESSION_LOGGERIMAGEURL];
}

-(NSString *)LoggerName
{
    return [PrivateLogger valueForKey:SESSION_LOGGERNAME];
}

-(NSString *)LoggerUserName
{
    return [PrivateLogger valueForKey:SESSION_USERNAME];
}
-(NSString *)DeviceToken
{
    return [PrivateLogger valueForKey:SESSION_DEVICETOKEN];
}

-(NSString *)LoggerCurrentLocation
{
    return [PrivateLogger valueForKey:SESSION_USERLOCAION];
}

-(void)PingServer:(NSString *)URLString
{
    NSURL *URL=[NSURL URLWithString:URLString];
    NSInvocationOperation *Invoc=[[NSInvocationOperation alloc] initWithTarget:self selector:@selector(FireURL:) object:URL];
    [GlobalOperationQueue addOperation:Invoc];
}

-(void)FireURL:(NSURL *)URL
{
    NSLog(@"URL Fired: %@", URL);
    [NSData dataWithContentsOfURL:URL];
}

-(void)SetBorderToTextFieldView:(UIView *)TxtFieldView
{
    [[TxtFieldView layer] setBorderColor:[UIColorFromRGB(0x6E8597) CGColor]];
    [[TxtFieldView layer] setCornerRadius:4.0f];
    [[TxtFieldView layer] setBorderWidth:2.0f];
    [[TxtFieldView layer] setMasksToBounds:YES];
}

-(void)SetBorderToView:(UIView *)Views
{
    [[Views layer] setBorderColor:[[UIColor lightGrayColor] CGColor]];
    [[Views layer] setCornerRadius:4.0f];
    [[Views layer] setBorderWidth:2.0f];
    [[Views layer] setMasksToBounds:YES];
}


-(void)SetBorderToTextField:(UITextField *)TxtField
{
    [[TxtField layer] setBorderColor:[UIColorFromRGB(0x6E8597) CGColor]];
    [[TxtField layer] setCornerRadius:4.0f];
    [[TxtField layer] setBorderWidth:2.0f];
    [[TxtField layer] setMasksToBounds:YES];
    [TxtField setBorderStyle:UITextBorderStyleNone];
}

-(void)SetBorderToButton:(UIButton *)Button
{
    [[Button layer] setCornerRadius:4.0f];
    [[Button layer] setMasksToBounds:YES];
}

-(void)SetBorderToTextFieldSet:(NSArray *)TxtFieldSet
{
    for(UITextField *TxtField in TxtFieldSet)
    {
        if([TxtField isKindOfClass:[UITextField class]])
        {
            [self SetBorderToTextField:TxtField];
        }
    }
}


-(void)SetBorderToTextFieldViewSet:(NSArray *)TxtFieldSet
{
    for(UIView *TxtField in TxtFieldSet)
    {
        if([TxtField isKindOfClass:[UIView class]])
        {
            [self SetBorderToTextFieldView:TxtField];
        }
    }
}

-(void)SetBorderToButtonSet:(NSArray *)ButtonFieldSet
{
    for(UIButton *Button in ButtonFieldSet)
    {
        if([Button isKindOfClass:[UIButton class]])
        {
            [self SetBorderToButton:Button];
        }
    }
}

-(void)SetBorderToFieldSet:(NSArray *)FieldSet
{
    for(UIView *Field in FieldSet)
    {
        if([Field isKindOfClass:[UIButton class]])
        {
            [self SetBorderToButton:(UIButton *)Field];
        }
        else if([Field isKindOfClass:[UIView class]])
        {
            [self SetBorderToTextFieldView:(UIView *)Field];
        }
        else if([Field isKindOfClass:[UITextField class]])
        {
            [self SetBorderToTextField:(UITextField *)Field];
        }
    }
}

-(void)RoundMyProfilePicture:(UIImageView *)PicView
{
    [self RoundMyProfilePicture:PicView withRadious:23.0f];
}

-(void)RoundMyProfilePicture:(UIImageView *)PicView withRadious:(float)Radious
{
    [[PicView layer] setCornerRadius:Radious];
    [[PicView layer] setBorderColor:[[UIColor lightTextColor] CGColor]];
    [[PicView layer] setBorderWidth:2.0f];
    [[PicView layer] setMasksToBounds:YES];
}

-(void)makeRoundWithDropShadow:(UIImageView *)PicView InView:(UIView *)BackView
{
    [self RoundMyProfilePicture:PicView withRadious:[PicView frame].size.width/2.0f];
    
    CGRect tempRect=[PicView frame];
    tempRect.origin.x-=1.0f;
    tempRect.origin.y-=1.0f;
    tempRect.size.height+=2.0f;
    tempRect.size.width+=2.0f;
    
    UIView *VImageHolder=[[UIView alloc] initWithFrame:tempRect];
    [[VImageHolder layer] setShadowColor:[[UIColor lightGrayColor] CGColor]];
    
    [[VImageHolder layer] setMasksToBounds:NO];
    [BackView addSubview:VImageHolder];
    [VImageHolder addSubview:PicView];
    [PicView setFrame:CGRectMake(1.0f, 1.0f, [PicView frame].size.width, [PicView frame].size.height)];
    [BackView bringSubviewToFront:VImageHolder];
}

-(void)setRoundBorderToImageView:(UIImageView *)PicView
{
    [[PicView layer] setCornerRadius:[PicView frame].size.width/2.0f];
    [[PicView layer] setBorderColor:[UIColor clearColor].CGColor];
    [[PicView layer] setBorderWidth:0.0f];
    [[PicView layer] setMasksToBounds:YES];
}

-(void)SetroundborderWithborderWidth:(CGFloat)BorderWidth WithColour:(UIColor *)RGB ForImageview:(UIImageView *)ImageView
{
  
    [[ImageView layer] setCornerRadius:[ImageView frame].size.width/2.0f];
    [[ImageView layer] setBorderColor:[RGB CGColor]];
     [[ImageView layer] setBorderWidth:BorderWidth];
    [[ImageView layer] setMasksToBounds:YES];
    
}

-(void)setRoundBorderToUiview:(UIView *)uiview
{
    [[uiview layer] setCornerRadius:[uiview frame].size.width/2.0f];
    [[uiview layer] setBorderColor:[UIColor clearColor].CGColor];
   // [[uiview layer] setOpacity:0.50f];
    [[uiview layer] setBorderWidth:0.0f];
    [[uiview layer] setMasksToBounds:YES];
}

-(void)setRoundBorderTolable:(UILabel *)uiviewLabl
{
    [[uiviewLabl layer] setCornerRadius:[uiviewLabl frame].size.width/2.0f];
    [[uiviewLabl layer] setBorderColor:[UIColor clearColor].CGColor];
   
    [[uiviewLabl layer] setBorderWidth:0.0f];
    [[uiviewLabl layer] setMasksToBounds:YES];
}


-(void)setBorderToView:(UIView *)VictimView withCornerRadius:(float)Radious withColor:(UIColor *)color
{
    [self setBorderToView:VictimView withCornerRadius:Radious withColor:color withBorderWidth:1.0f];
}

-(void)setBorderToView:(UIView *)VictimView withCornerRadius:(float)Radious withColor:(UIColor *)color withBorderWidth:(float)BorderWidth
{
    [[VictimView layer] setCornerRadius:Radious];
    [[VictimView layer] setBorderColor:[color CGColor]];
    [[VictimView layer] setBorderWidth:BorderWidth];
    [[VictimView layer] setMasksToBounds:YES];
}

-(void)setBorderToViews:(NSArray *)ViewArray withCornerRadius:(float)Radious withColor:(UIColor *)color
{
    for(UIView *view in ViewArray) [self setBorderToView:view withCornerRadius:Radious withColor:color withBorderWidth:1.0f];
}

-(void)SetCornerToView:(UIView *)Views
{
    [[Views layer] setCornerRadius:2.0f];
    [[Views layer] setMasksToBounds:YES];
}

-(void)SetCornerToView:(UIView *)Views to:(float)corner
{
    [[Views layer] setCornerRadius:corner];
    [[Views layer] setMasksToBounds:YES];
}

-(void)setRadiousToBox:(UIView *)View to:(float)corner
{
    [[View layer] setCornerRadius:corner];
    [[View layer] setBorderColor:[[UIColor lightGrayColor] CGColor]];
    [[View layer] setBorderWidth:1.0f];
    [[View layer] setMasksToBounds:YES];
}

-(void)SetCornerToViews:(NSArray *)Views
{
    for(UIView *sub in Views)
    {
        [self SetCornerToView:sub];
    }
}

-(void)SetBorderToBackView:(UIView *)BackView
{
    [[BackView layer] setBorderColor:[UIColorFromRGB(0xEDEDED) CGColor]];
    [[BackView layer] setCornerRadius:4.0f];
    [[BackView layer] setBorderWidth:1.0f];
    [[BackView layer] setMasksToBounds:YES];
}

-(void)SetDropShadowToBackView:(UIView *)BackView
{
    [[BackView layer] setMasksToBounds:NO];
    //[[BackView layer] setBorderColor:[[UIColor lightGrayColor] CGColor]];
    //[[BackView layer] setBorderWidth:1.0f];
    [[BackView layer] setShadowOffset:CGSizeMake(2.0f, 2.0f)];
    [[BackView layer] setShadowOpacity:0.2f];
    [[BackView layer] setShouldRasterize:YES];
    [[BackView layer] setRasterizationScale:[UIScreen mainScreen].scale];
}

-(void)SetBorderToField:(UIView *)TxtField
{
    [self SetBorderToTextFieldView:TxtField];
}

-(void)SetBorderToFieldIn:(UIView *)FieldView
{
    for(UIView *sub in [FieldView subviews])
    {
        if([sub class]==[UIView class])
        {
            [self SetBorderToField:sub];
        }
    }
}

-(void)SetDelegetsToTextFiledIn:(UIView *)FieldView
{
    for(UIView *sub in [FieldView subviews])
    {
        if([sub class]==[UITextField class])
        {
            UITextField *TempTxt=(UITextField *)sub;
            [TempTxt setDelegate:self];
        }
        else
        {
            for(UIView *sub1 in [sub subviews])
            {
                if([sub1 class]==[UITextField class])
                {
                    UITextField *TempTxt=(UITextField *)sub1;
                    [TempTxt setDelegate:self];
                }
            }
        }
    }
}




-(void)SetBorderToSubViewOf:(UIView *)Views
{
    for(UIView *sub in [Views subviews])
    {
        if([sub tag]>0)
        {
            [[sub layer] setBorderColor:[UIColorFromRGB(0xD6D6D6) CGColor]];
            [[sub layer] setBorderWidth:2.0f];
            [[sub layer] setCornerRadius:4.0f];
            [[sub layer] setMasksToBounds:YES];
        }
    }
}



-(NSArray *)IndexPathForNoOfObjects:(int)ObjectNumber
{
    return [self IndexPathForNoOfObjects:ObjectNumber startFrom:0 inSection:0];
}

-(NSArray *)IndexPathForNoOfObjects:(int)ObjectNumber startFrom:(int)start
{
    return [self IndexPathForNoOfObjects:ObjectNumber startFrom:start inSection:0];
}

-(NSArray *)IndexPathForNoOfObjects:(int)ObjectNumber startFrom:(int)start inSection:(int)section
{
    NSMutableArray *IndexPathArray=[[NSMutableArray alloc] initWithCapacity:ObjectNumber];
    for(int i=ObjectNumber; i>0; i--)
    {
        [IndexPathArray addObject:[NSIndexPath indexPathForRow:start inSection:section]];
        start+=1;
    }
    return [NSArray arrayWithArray:IndexPathArray];
}


-(float)heightForRowForObject:(TTTGlobalMethods *)LocalMethod initialHeight:(float)initialHeight
{
    float ReturnHeight=0.0f;
    if([[LocalMethod ActivityType] isEqualToString:@"photos"])
    {
        
        ReturnHeight= initialHeight-5;
        
    }
    
    else if([[LocalMethod ActivityType] isEqualToString:@"events"])
        
    {
        
        ReturnHeight= initialHeight-5;
    }
    
    else if([[LocalMethod ActivityType] isEqualToString:@"friends"] || [[LocalMethod ActivityType] isEqualToString:@"events.wall"])
    {
        ReturnHeight= initialHeight-5;
    }
    else if([[LocalMethod ActivityType] isEqualToString:@"groups.discussion"]||[[LocalMethod ActivityType] isEqualToString:@"groups"]||[[LocalMethod ActivityType] isEqualToString:@"profile"])
    {
        ReturnHeight= initialHeight-5;
    }
    else
    {
        ReturnHeight-=5;
        
    }
    
    
    return ReturnHeight+GapBetweenActivities;
    
    
}


-(NSAttributedString *)getAttributedString:(NSString *)FullString HightLightString:(NSString *)HightLightString
{
    UIFont *BoldFont= [UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0f];
    UIFont *RegularFont= [UIFont fontWithName:@"HelveticaNeue-Light" size:16.0f];
    
    NSDictionary *AttributeDic=[NSDictionary dictionaryWithObjectsAndKeys:RegularFont, NSFontAttributeName,  nil];
    NSDictionary *SubAttributeDic=[NSDictionary dictionaryWithObjectsAndKeys:BoldFont, NSFontAttributeName, nil];
    
    NSRange Range=[FullString rangeOfString:HightLightString options:NSCaseInsensitiveSearch];
    
    NSMutableAttributedString *AttributedString=[[NSMutableAttributedString alloc] initWithString:FullString attributes:AttributeDic];
    [AttributedString setAttributes:SubAttributeDic range:Range];
    return AttributedString;
}

-(NSAttributedString *)getAttributedString:(NSString *)FullString HightLightString:(NSString *)HightLightString withFontSize:(float)fontSize
{
    UIFont *BoldFont= [UIFont fontWithName:MYRIARDPROSAMIBOLT size:fontSize];
    UIFont *RegularFont= [UIFont fontWithName:MYRIARDPROLIGHT size:fontSize];
    
    NSDictionary *AttributeDic=[NSDictionary dictionaryWithObjectsAndKeys:RegularFont, NSFontAttributeName,  nil];
    NSDictionary *SubAttributeDic=[NSDictionary dictionaryWithObjectsAndKeys:BoldFont, NSFontAttributeName, nil];
    
    NSRange Range=[FullString rangeOfString:HightLightString options:NSCaseInsensitiveSearch];
    
    NSMutableAttributedString *AttributedString=[[NSMutableAttributedString alloc] initWithString:FullString attributes:AttributeDic];
    [AttributedString setAttributes:SubAttributeDic range:Range];
    return AttributedString;
}

-(NSAttributedString *)getAttributedString:(NSString *)FullString HightLightString:(NSString *)HightLightString1 HightLighted2:(NSString *)HightLightString2 withFontSize:(float)fontSize
{
    UIFont *BoldFont= [UIFont fontWithName:MYRIARDPROSAMIBOLT size:fontSize];
    UIFont *RegularFont= [UIFont fontWithName:MYRIARDPROLIGHT size:fontSize];
    
    NSDictionary *AttributeDic=[NSDictionary dictionaryWithObjectsAndKeys:RegularFont, NSFontAttributeName,  nil];
    NSDictionary *SubAttributeDic=[NSDictionary dictionaryWithObjectsAndKeys:BoldFont, NSFontAttributeName, nil];
    NSDictionary *SubattributeDic2=[NSDictionary dictionaryWithObjectsAndKeys:BoldFont,NSFontAttributeName, nil];
    
    NSRange Range1=[FullString rangeOfString:HightLightString1 options:NSCaseInsensitiveSearch];
    NSRange Range2=[FullString rangeOfString:HightLightString2 options:NSCaseInsensitiveSearch];
    
    NSMutableAttributedString *AttributedString=[[NSMutableAttributedString alloc] initWithString:FullString attributes:AttributeDic];
    [AttributedString setAttributes:SubAttributeDic range:Range1];
    [AttributedString setAttributes:SubattributeDic2 range:Range2];
    
    return AttributedString;
}


-(void)AddNavigationBarTo:(UIView *)VictimView withSelected:(NSString *)SelectedMenu
{
    
    UIView *NavBarView=[[[NSBundle mainBundle] loadNibNamed:@"ExtendedDesign" owner:self options:nil] objectAtIndex:0];
    [VictimView addSubview:NavBarView];
     NavBarView.opaque = NO;
    
    [NavBarView setBackgroundColor:[UIColor clearColor]];
    
    UIView *ActivityView=(UIView *)[VictimView viewWithTag:1];
    UIView *FriendsRqstView=(UIView *)[VictimView viewWithTag:2];
    UIView *MessageView=(UIView *)[VictimView viewWithTag:3];
    UIView *NotificationView=(UIView *)[VictimView viewWithTag:4];
    UIView *ChatView=(UIView *)[VictimView viewWithTag:5];
    
    FriendRqstBadges=(UILabel *)[FriendsRqstView viewWithTag:31];
    [self setRoundBorderTolable:FriendRqstBadges];
    [FriendRqstBadges setHidden:YES];
     [FriendRqstBadges setFont:[UIFont fontWithName:MYREADPROREGULAR size:10.0f]];
    
    _activityBadges=(UILabel *)[ActivityView viewWithTag:30];
    
   
    [self setRoundBorderTolable:_activityBadges];
    [_activityBadges setFont:[UIFont fontWithName:MYREADPROREGULAR size:10.0f]];
    
    
    
    [_activityBadges setHidden:YES];
    
    
    

    
   _messageBadges= (UILabel *)[MessageView viewWithTag:32];
    
    [_messageBadges setFont:[UIFont fontWithName:MYREADPROREGULAR size:10.0f]];
   
    [self setRoundBorderTolable:_messageBadges];
    [_messageBadges setHidden:YES];
    
    
    
    _notificationBadges=(UILabel *)[NotificationView viewWithTag:33];
     [self setRoundBorderTolable:_notificationBadges];
     [_notificationBadges setFont:[UIFont fontWithName:MYREADPROREGULAR size:10.0f]];
     [_notificationBadges setHidden:YES];
    
    _onlineBadges=(UILabel *)[ChatView viewWithTag:34];
     [_onlineBadges setFont:[UIFont fontWithName:MYREADPROREGULAR size:10.0f]];
    [self setRoundBorderTolable:_onlineBadges];
    
    TapGestureGlobal=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(SwitchToActivityView)];
    [ActivityView addGestureRecognizer:TapGestureGlobal];
    
    TapGestureGlobal=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(PerformChatSliderOperation)];
    [ChatView addGestureRecognizer:TapGestureGlobal];
    
    TapGestureGlobal=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(SwitchToFriendRequstView)];
    [FriendsRqstView addGestureRecognizer:TapGestureGlobal];
    
    TapGestureGlobal=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(SwitchToMessageView)];
    [MessageView addGestureRecognizer:TapGestureGlobal];
    
    TapGestureGlobal=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(SwitchToNotificationView)];
    [NotificationView addGestureRecognizer:TapGestureGlobal];
    [self SetSelectedNavTo:SelectedMenu inView:NavBarView];
    [self Donotification];
   // nbotificationtimer=[NSTimer timerWithTimeInterval:10 target:self selector:@selector(Donotification) userInfo:nil repeats:YES];
}


-(void)thevalueofeachnotification
{
    @try
    {
        NSLog(@"Notification call");
       // NSError *Error;
        if ([self isConnectedToInternet])
        {
            NSString *NotificationString=[NSString stringWithFormat:@"%@user.php?mode=notifycounter&userid=%@",API,[self LoggedId]];
            NSLog(@"The value of Photo url:%@",NotificationString);
            NSData *data=[NSData dataWithContentsOfURL:[NSURL URLWithString:NotificationString]];
            NSDictionary *MainDic=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSLog(@"This is main:%@",MainDic);
            NSMutableDictionary *mutDicall=[[NSMutableDictionary alloc]init];
            [mutDicall setValue:[NSString stringWithFormat:@"%@",[MainDic valueForKey:@"activity_count"]] forKey:@"activity_count"];
            [mutDicall setValue:[NSString stringWithFormat:@"%@",[MainDic valueForKey:@"friend_request_count"]] forKey:@"friend_request_count"];
            [mutDicall setValue:[NSString stringWithFormat:@"%@",[MainDic valueForKey:@"message_count"] ] forKey:@"message_count"];
            [mutDicall setValue:[NSString stringWithFormat:@"%@",[MainDic valueForKey:@"notification_count"]]  forKey:@"notification_count"];
            [mutDicall setValue:[NSString stringWithFormat:@"%@",[MainDic valueForKey:@"online_count"]] forKey:@"online_count"];
           
            [self performSelectorOnMainThread:@selector(UpdateFooterlable:) withObject:mutDicall waitUntilDone:YES];
            
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
        NSLog(@"The exception type:%@ %@",[exception name],exception);
    }
   
}
-(void)UpdateFooterlable:(NSMutableDictionary *)mainDic
{
        NSLog(@"The value of main Dic:%@",mainDic);
      [self.onlineBadges setText:[mainDic valueForKey:@"online_count"]];
      [self.messageBadges setText:[mainDic valueForKey:@"message_count"]];
      [self.notificationBadges setText:[mainDic valueForKey:@"notification_count"]];
      [self.FriendRqstBadges setText:[mainDic valueForKey:@"friend_request_count"]];
      [self.activityBadges setText:[mainDic valueForKey:@"activity_count"]];
    
    //-----------  Notification View ------------ //
    if ([self.onlineBadges.text integerValue]==0)
    {
        self.onlineBadges.hidden=YES;
    }
    else
    {
        self.onlineBadges.hidden=NO;
    }
  
    if ([self.FriendRqstBadges.text integerValue]==0)
    {
        self.FriendRqstBadges.hidden=YES;
    }
    else
    {
        self.FriendRqstBadges.hidden=NO;
    }
   
   
    if ([self.messageBadges.text integerValue]==0)
    {
        self.messageBadges.hidden=YES;
    }
    else
    {
        self.messageBadges.hidden=NO;
    }
    
    
    if ([self.activityBadges.text integerValue]==0)
    {
        self.activityBadges.hidden=YES;
    }
    else
    {
        self.activityBadges.hidden=NO;
    }
    
    if ([self.notificationBadges.text integerValue]==0)
    {
        self.notificationBadges.hidden=YES;
    }
    else
    {
        self.notificationBadges.hidden=NO;
    }
    
    
   
}


-(void)PerformChatSliderOperation
{
    
}
-(void)SwitchToMessageView
{
    TTTMessageListViewController *messageList=[[TTTMessageListViewController alloc]init];
    [self PushViewController:messageList TransitationFrom:kCATransitionFade];
}


-(void)SwitchToNotificationView
{
    TTTNotificationViewController *notificationview=[[TTTNotificationViewController alloc]init];
    [[self navigationController] pushViewController:notificationview animated:NO];
    
}

-(void)SwitchToFriendRequstView
{
    TTTAcceptFndrequest *Acceptrequest=[[TTTAcceptFndrequest alloc]init];
    [[self navigationController] pushViewController:Acceptrequest animated:NO];
}
-(void)SwitchToActivityView
{
    TTTActivityStreem *Activity=[[TTTActivityStreem alloc]init];
    [[self navigationController] pushViewController:Activity animated:NO];
}

-(void)AddNavigationBarTo:(UIView *)VictimView
{
    [self AddNavigationBarTo:VictimView withSelected:@""];
}


-(void)SetSelectedNavTo :(NSString *)selectedMenu inView :(UIView *)NavBarViewBarView
{
    UIImageView *TempImage;
    
    if([selectedMenu isEqualToString:@"ActivityStreamView"])
    {
        TempImage=(UIImageView *)[NavBarViewBarView viewWithTag:405];
        [TempImage setImage:[UIImage imageNamed:@"footer_activity_selected.png"]];
    }
    else if([selectedMenu isEqualToString:@"Friend Request"])
    {
        TempImage=(UIImageView *)[NavBarViewBarView viewWithTag:406];
        [TempImage setImage:[UIImage imageNamed:@"footer_friendRqst_selected.png"]];
    }
    else if([selectedMenu isEqualToString:@"Message"])
    {
        TempImage=(UIImageView *)[NavBarViewBarView viewWithTag:407];
        [TempImage setImage:[UIImage imageNamed:@"footer_message_selected.png"]];
    }
    else if([selectedMenu isEqualToString:@"Notification"])
    {
        TempImage=(UIImageView *)[NavBarViewBarView viewWithTag:408];
        [TempImage setImage:[UIImage imageNamed:@"footer_notification_selected.png"]];
    }
}

-(void)MakeTransparent:(NSArray *)VictimViews
{
    for(UIView *Child in VictimViews) [self MakeMeTransparent:Child];
}

-(void)MakeMeTransparent:(UIView *)VictimView
{
    [[VictimView layer] setCornerRadius:3.0f];
    [VictimView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.6f]];
    [[VictimView layer] setMasksToBounds:YES];
}

-(NSString *)CurrentFilterMenuIdBy:(NSString *)MenuName inArray:(NSMutableArray *)Holder
{
    for(TTTGlobalMethods *LocalMethod in Holder)
    {
        if([(NSString *)[LocalMethod MenuName] isEqualToString:MenuName])
            return [LocalMethod Id];
    }
    return @"";
}

-(NSString *)CurrentFilterMenuNameBy:(NSString *)MenuId inArray:(NSMutableArray *)Holder
{
    for(TTTGlobalMethods *LocalMethod in Holder)
    {
        if([(NSString *)[LocalMethod Id] isEqualToString:MenuId])
            return [LocalMethod MenuName];
    }
    return @"";
}



-(void)AddChatBoxTo:(UIView *)VictimView
{
    UIView *ChatView=[[[NSBundle mainBundle] loadNibNamed:@"ExtendedDesign" owner:self options:nil] objectAtIndex:(IsIphone5)?3:4];
    [VictimView addSubview:ChatView];
    [ChatView setBackgroundColor:[UIColor lightGrayColor]];
    
    [[ChatView layer] setBorderWidth:1.0f];
    [[ChatView layer] setBorderColor:[[UIColor lightGrayColor] CGColor]];
    [[ChatView layer] setMasksToBounds:YES];
    
    TblChat=(UITableView *)[ChatView viewWithTag:50];
    [TblChat setDelegate:self];
    [TblChat setDataSource:self];
}

-(void)AddLeftMenuTo:(UIView *)VictimView
{
    [self AddLeftMenuTo:VictimView setSelected:@""];
}

-(BOOL)isConnectedToInternet {
    
    IMFAPPPRINTMETHOD();
    
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, (const struct sockaddr *)&zeroAddress);
    
    if (reachability) {
        SCNetworkReachabilityFlags flags;
        BOOL worked = SCNetworkReachabilityGetFlags(reachability, &flags);
        CFRelease(reachability);
        
        if (worked)
        {
            
            if ((flags & kSCNetworkReachabilityFlagsReachable) == 0) {
                return NO;
            }
            
            if ((flags & kSCNetworkReachabilityFlagsConnectionRequired) == 0) {
                return YES;
            }
            
            if ((((flags & kSCNetworkReachabilityFlagsConnectionOnDemand) != 0) || (flags & kSCNetworkReachabilityFlagsConnectionOnTraffic) != 0)) {
                if ((flags & kSCNetworkReachabilityFlagsInterventionRequired) == 0) {
                    return YES;
                }
            }
            
            if ((flags & kSCNetworkReachabilityFlagsIsWWAN) == kSCNetworkReachabilityFlagsIsWWAN) {
                return YES;
            }
        }
        
    }
    return NO;
}

-(void)AddLeftMenuTo:(UIView *)VictimView setSelected:(NSString *)SelectedMenu
{
    
     UIView *LeftMenuBackView=[[[NSBundle mainBundle] loadNibNamed:@"ExtendedDesign" owner:self options:nil] objectAtIndex:2];

    
      CGRect tempRectLeftMenu=[LeftMenuBackView frame];
      tempRectLeftMenu.origin.y=0.0f;
      [LeftMenuBackView setFrame:tempRectLeftMenu];
      [VictimView addSubview:LeftMenuBackView];
      UIView *manuSacroll=(UIView *)[LeftMenuBackView viewWithTag:50];
    
    
    
    
     UIImageView *ProfileImageView=(UIImageView *)[manuSacroll viewWithTag:2];
     [ProfileImageView setImage:[UIImage imageWithData:[self LoggerProfileImageData]]];
     [ProfileImageView setUserInteractionEnabled:YES];
     [self SetroundborderWithborderWidth:2.0f WithColour:UIColorFromRGB(0x949494) ForImageview:ProfileImageView];
        _manuContainScroll.scrollEnabled=YES;
    if (IsIphone5)
    {
         [self.manuContainScroll setContentSize:CGSizeMake(260, 460)];
    }
    else
    {
        [self.manuContainScroll setContentSize:CGSizeMake(260, 540)];
    }
    
    
    
    
      UILabel *NameLabel=(UILabel *)[manuSacroll viewWithTag:3];
      [NameLabel setText:[self LoggerName]];
      [NameLabel setTextColor:UIColorFromRGB(0xb5b5b5)];
    
       NameLabel.font=[UIFont fontWithName:MYRIARDPROSAMIBOLT size:15.0f];
       UILabel *LblHandicapIndex=(UILabel *)[manuSacroll viewWithTag:4];
       [LblHandicapIndex setText:[PrivateLogger valueForKey:HANDICAPINDEX]];
       LblHandicapIndex.font=[UIFont fontWithName:MYRIARDPROLIGHT size:15.0f];
        UILabel *LblPoints=(UILabel *)[manuSacroll viewWithTag:5];
       [LblPoints setText:[PrivateLogger valueForKey:TOTALPOINT]];
       LblPoints.font=[UIFont fontWithName:MYRIARDPROLIGHT size:15.0f];
        LblPoints.layer.opacity=.7;
    
        _Scarchicon=(UIImageView *)[manuSacroll viewWithTag:99];
        _manuSearchtxt=(UITextField *)[manuSacroll viewWithTag:150];
        _manuSearchtxt.font=[UIFont fontWithName:MYRIARDPROLIGHT size:13.0f];
        _manuSearchtxt.placeholder=@"Search Location or Course name";
    [_manuSearchtxt setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
           _manuSearchtxt.delegate=self;
    
    
    
          UIView *activity=(UIView *)[self.manuContainScroll viewWithTag:100];
          UIView *MatchList=(UIView *)[self.manuContainScroll viewWithTag:101];
    
    
         UIView *Logout=(UIView *)[self.manuContainScroll viewWithTag:109];
    
         UIView *Scorecardlist=(UIView *)[self.manuContainScroll viewWithTag:102];
    
         UIView *Statisticview=(UIView *)[self.manuContainScroll viewWithTag:103];
    
         UIView *PhotoView=(UIView *)[self.manuContainScroll viewWithTag:107];
    
         UIView *Friendview=(UIView *)[self.manuContainScroll viewWithTag:105];
         UIView *CourseView=(UIView *)[self.manuContainScroll viewWithTag:104];
    
         UIView *videoView=(UIView *)[self.manuContainScroll viewWithTag:108];
    
    
          TapGestureGlobal=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(GoestoactivityView)];
           [activity addGestureRecognizer:TapGestureGlobal];
    
            TapGestureGlobal=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(GoestomatchList)];
          [MatchList addGestureRecognizer:TapGestureGlobal];
    
          TapGestureGlobal=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(Logout)];
         [Logout addGestureRecognizer:TapGestureGlobal];
    
          TapGestureGlobal=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(Scorecardlist)];
          [Scorecardlist addGestureRecognizer:TapGestureGlobal];
    
           TapGestureGlobal=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(Statisticview)];
           [Statisticview addGestureRecognizer:TapGestureGlobal];
    
          TapGestureGlobal=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(PhotoViewpage)];
          [PhotoView addGestureRecognizer:TapGestureGlobal];
    
             TapGestureGlobal=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(GoestoFriendlist)];
             [Friendview addGestureRecognizer:TapGestureGlobal];
    
            TapGestureGlobal=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(GoestoCourseView)];
           [CourseView addGestureRecognizer:TapGestureGlobal];
    
    
         TapGestureGlobal=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(videoPage)];
    
          [videoView addGestureRecognizer:TapGestureGlobal];

    
    
    
}

//Manu operation




-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
//    if(textField==_manuSearchtxt){
//        NSLog(@"_manuSearchtxt search");
//        [self globalSearch];
//    }
    return YES;
    
}
//Course view navigation

-(void)videoPage
{
    
    TTTVideoListViewController *Viderlist=[[TTTVideoListViewController alloc]init];
    [self PushViewController:Viderlist TransitationFrom:kCATransitionFade];
    
    
}



-(void)GoestoCourseView
{
    TTTCourseListViewController *CourseList=[[TTTCourseListViewController alloc]init];
    [self PushViewController:CourseList TransitationFrom:kCATransitionFade];
    
}

-(void)GoestoFriendlist
{
    TTTShowAllfriendmanu *Showall=[[TTTShowAllfriendmanu alloc]init];
    [self PushViewController:Showall TransitationFrom:kCATransitionFade];
}

-(void)GoestoactivityView
 {
     TTTActivityStreem *Activit=[[TTTActivityStreem alloc]init];
     [self PushViewController:Activit TransitationFrom:kCATransitionFade];
 }

-(void)GoestomatchList
{
    TTTMatchListing *matchListing=[[TTTMatchListing alloc]init];
    [self PushViewController:matchListing TransitationFrom:kCATransitionFade];
}
-(void)Scorecardlist
{
    TTTScorecardList *matchListing=[[TTTScorecardList alloc]init];
    [self PushViewController:matchListing TransitationFrom:kCATransitionFade];
}

-(void)Statisticview
{
    TTTStatisticsViewController *Statistic=[[TTTStatisticsViewController alloc]init];
    [self PushViewController:Statistic TransitationFrom:kCATransitionFade];
}

-(void)PhotoViewpage
{
    TTTPhotosofme *photoView=[[TTTPhotosofme alloc]init];
    [self PushViewController:photoView TransitationFrom:kCATransitionFade];
}

-(void)Logout
 {
     
     NSUserDefaults *UserId = [NSUserDefaults standardUserDefaults];
     [UserId setObject:@"" forKey:SESSION_LOGGERNAME];
     [UserId setObject:@"" forKey:SESSION_LOGGERIMAGEDATA];
     [UserId setValue:@"" forKey:SESSION_USERNAME];
     [UserId setValue:@"" forKey:SESSION_PASSWORD];
     [UserId setValue:@"" forKey:SESSION_ID];
     
      [UserId synchronize];
     TTTLoginViewController *login=[[TTTLoginViewController alloc]init];
     [self PushViewController:login TransitationFrom:kCAAlignmentLeft];
     
    // [self PerformGoBackTo:@"TTTLoginViewController"];
//     TTTLoginViewController *loginObj=[[TTTLoginViewController alloc]init];
//     
//     [self PushViewController:loginObj TransitationFrom:kCATransitionFade];
 }

-(void)SelectMyMenu:(NSString *)SelectedMenu inView:(UIScrollView *)SVBack
{
    UIView *VMenuBackLocal;
    if([SelectedMenu isEqualToString:@"Activity"])
    {
        VMenuBackLocal=(UIView *)[SVBack viewWithTag:700];
        [VMenuBackLocal setBackgroundColor:UIColorFromRGB(0x303030)];
        UIImageView *ImgMenuIcon=(UIImageView *)[SVBack viewWithTag:800];
        [ImgMenuIcon setImage:[UIImage imageNamed:@"nActivityStream-white.png"]];
        
    }
    else if([SelectedMenu isEqualToString:@"Tee Times"])
    {
       
        
    }
    else if([SelectedMenu isEqualToString:@"Matches"])
    {
        
        VMenuBackLocal=(UIView *)[SVBack viewWithTag:702];
        [VMenuBackLocal setBackgroundColor:UIColorFromRGB(0x303030)];
        UIImageView *ImgMenuIcon=(UIImageView *)[SVBack viewWithTag:802];
        [ImgMenuIcon setImage:[UIImage imageNamed:@"nMatches-white.png"]];
        
    }
    else if([SelectedMenu isEqualToString:@"Scorecards"])
    {
        
        VMenuBackLocal=(UIView *)[SVBack viewWithTag:703];
        [VMenuBackLocal setBackgroundColor:UIColorFromRGB(0x303030)];
        UIImageView *ImgMenuIcon=(UIImageView *)[SVBack viewWithTag:803];
        [ImgMenuIcon setImage:[UIImage imageNamed:@"nScorecards-white.png"]];
        
    }
    else if([SelectedMenu isEqualToString:@"Statistics"])
    {
        
        VMenuBackLocal=(UIView *)[SVBack viewWithTag:704];
        [VMenuBackLocal setBackgroundColor:UIColorFromRGB(0x303030)];
        UIImageView *ImgMenuIcon=(UIImageView *)[SVBack viewWithTag:804];
        [ImgMenuIcon setImage:[UIImage imageNamed:@"nStatistics-white.png"]];
        
    }
    else if([SelectedMenu isEqualToString:@"Courses"])
    {
        
        VMenuBackLocal=(UIView *)[SVBack viewWithTag:705];
        [VMenuBackLocal setBackgroundColor:UIColorFromRGB(0x303030)];
        UIImageView *ImgMenuIcon=(UIImageView *)[SVBack viewWithTag:805];
        [ImgMenuIcon setImage:[UIImage imageNamed:@"nCourses-white.png"]];
        
    }
    else if([SelectedMenu isEqualToString:@"Ewallet"])
    {
        
        VMenuBackLocal=(UIView *)[SVBack viewWithTag:706];
        [VMenuBackLocal setBackgroundColor:UIColorFromRGB(0x303030)];
        UIImageView *ImgMenuIcon=(UIImageView *)[SVBack viewWithTag:806];
        [ImgMenuIcon setImage:[UIImage imageNamed:@"nEwallet-white.png"]];
        
    }
    else if([SelectedMenu isEqualToString:@"MyFriends"])
    {
        
        VMenuBackLocal=(UIView *)[SVBack viewWithTag:707];
        [VMenuBackLocal setBackgroundColor:UIColorFromRGB(0x303030)];
        UIImageView *ImgMenuIcon=(UIImageView *)[SVBack viewWithTag:807];
        [ImgMenuIcon setImage:[UIImage imageNamed:@"nFriends-white.png"]];
        
    }
    else if([SelectedMenu isEqualToString:@"Groups"])
    {
        
        VMenuBackLocal=(UIView *)[SVBack viewWithTag:708];
        [VMenuBackLocal setBackgroundColor:UIColorFromRGB(0x303030)];
        UIImageView *ImgMenuIcon=(UIImageView *)[SVBack viewWithTag:808];
        [ImgMenuIcon setImage:[UIImage imageNamed:@"nGroups-white.png"]];
        
    }
    else if([SelectedMenu isEqualToString:@"Photos"])
    {
        
        VMenuBackLocal=(UIView *)[SVBack viewWithTag:709];
        [VMenuBackLocal setBackgroundColor:UIColorFromRGB(0x303030)];
        UIImageView *ImgMenuIcon=(UIImageView *)[SVBack viewWithTag:809];
        [ImgMenuIcon setImage:[UIImage imageNamed:@"nPhotos-white.png"]];
        
    }
    else if([SelectedMenu isEqualToString:@"Videos"])
    {
        
        VMenuBackLocal=(UIView *)[SVBack viewWithTag:710];
        [VMenuBackLocal setBackgroundColor:UIColorFromRGB(0x303030)];
        UIImageView *ImgMenuIcon=(UIImageView *)[SVBack viewWithTag:810];
        [ImgMenuIcon setImage:[UIImage imageNamed:@"nVideos-white.png"]];
        
    }
    else if([SelectedMenu isEqualToString:@"Tee Sheet"])
    {
        
        VMenuBackLocal=(UIView *)[SVBack viewWithTag:711];
        [VMenuBackLocal setBackgroundColor:UIColorFromRGB(0x303030)];
        UIImageView *ImgMenuIcon=(UIImageView *)[SVBack viewWithTag:811];
        [ImgMenuIcon setImage:[UIImage imageNamed:@"nTeeSheet-white.png"]];
        
    }
    else if([SelectedMenu isEqualToString:@"Administrations"])
    {
        
        VMenuBackLocal=(UIView *)[SVBack viewWithTag:712];
        [VMenuBackLocal setBackgroundColor:UIColorFromRGB(0x303030)];
        UIImageView *ImgMenuIcon=(UIImageView *)[SVBack viewWithTag:812];
        [ImgMenuIcon setImage:[UIImage imageNamed:@"nAdministration-white.png"]];
        
    }
    
    for(UIView *sub in [VMenuBackLocal subviews])
    {
        if([sub isKindOfClass:[UILabel class]])
        {
            UILabel *Lbl=(UILabel *)sub;
            [Lbl setTextColor:[UIColor whiteColor]];
        }
    }
}


-(void)MainMenuTouched
{
    if(GlobalIsMenuOpen)
    {
        GlobalIsMenuOpen=FALSE;
        [ImgMenuIndecator setImage:[UIImage imageNamed:@"nUpIcon.png"]];
        
        [UIView animateWithDuration:0.5f animations:^{
            
            [VMenuMenuBack setAlpha:0.0f];
            [VCourseBack setFrame:CGRectMake(0.0f, 111.0f, 260.0f, 124.0f)];
            
        } completion:^(BOOL finished) {
            
            [self setContentSizeToScroller];
            
        }];
    }
    else
    {
        GlobalIsMenuOpen=TRUE;
        [ImgMenuIndecator setImage:[UIImage imageNamed:@"nDownIcon.png"]];
        
        [UIView animateWithDuration:0.5f animations:^{
            
            [VMenuMenuBack setAlpha:1.0f];
            [VCourseBack setFrame:CGRectMake(0.0f, 573.0f, 260.0f, 124.0f)];
            
        } completion:^(BOOL finished) {
            
            [self setContentSizeToScroller];
            
        }];
    }
}

-(void)CourseMenuTouched
{
    if(GlobalIsCourseOpen)
    {
        GlobalIsCourseOpen=FALSE;
        [ImgCourseIndecator setImage:[UIImage imageNamed:@"nUpIcon.png"]];
        
        [UIView animateWithDuration:0.5f animations:^{
            
            [VCourseMenuBack setAlpha:0.0f];
            
        } completion:^(BOOL finished) {
            
            [self setContentSizeToScroller];
            
        }];
    }
    else
    {
        GlobalIsCourseOpen=TRUE;
        [ImgCourseIndecator setImage:[UIImage imageNamed:@"nDownIcon.png"]];
        
        [UIView animateWithDuration:0.5f animations:^{
            
            [VCourseMenuBack setAlpha:1.0f];
            
        } completion:^(BOOL finished) {
            
            [self setContentSizeToScroller];
            
        }];
    }
    
}


-(void)setContentSizeToScroller
{
    CGSize ContentSize;
    ContentSize.width=260.0f;
    ContentSize.height=75.0f;
    if(GlobalIsMenuOpen)
    {
        ContentSize.height+=552.0f;
    }
    if(GlobalIsCourseOpen)
    {
        ContentSize.height+=130.0f;
    }
    if(GlobalIsCourseOpen && GlobalIsMenuOpen)
    {
        ContentSize.height-=38.0f;
    }
    
    [SVLeftBack setContentSize:ContentSize];
}


-(BOOL)PerformChatSliding:(UIView *)MainBackView IsOpen:(bool)isOpen
{
    CGRect MainBackViewRect=[MainBackView frame];
    
    if(isOpen)
    {
        MainBackViewRect.origin.x+=260.0f;
    }
    else
    {
        MainBackViewRect.origin.x-=260.0f;
    }
    
    [UIView animateWithDuration:0.2f animations:^{
        [MainBackView setFrame:MainBackViewRect];
    }];
    
    [MainBackView endEditing:YES];
    
    return !isOpen;
}

-(BOOL)PerformMenuSliding:(UIView *)MainBackView IsOpen:(bool)isOpen
{
    CGRect MainBackViewRect=[MainBackView frame];
    
    if(isOpen)
    {
        MainBackViewRect.origin.x-=260.0f;
    }
    else
    {
        MainBackViewRect.origin.x+=260.0f;
    }
    
    [UIView animateWithDuration:0.2f animations:^{
        [MainBackView setFrame:MainBackViewRect];
    }];
    
    [MainBackView endEditing:YES];
    
    return !isOpen;
}


-(BOOL)PerformChatSlider:(UIView *)ScreenView withChatArea:(UIView *)ChatView IsOpen:(BOOL)IsOpen
{
    CGRect ScreenViewRect=[ScreenView frame];
    [ScreenView endEditing:YES];
    IsPerformingMenu=FALSE;
    
    if(IsOpen)
    {
        ScreenViewRect.origin.x+=260.0f;
        
        [self RemoveProtectorFrom:ScreenView];
        [self cacellAllOperation];
        //ChatView.hidden=YES;
        [activityonChat removeFromSuperview];
    }
    else
    {
       
        
        
        
        
        ChatView.hidden=NO;
        chatArea=ChatView;
        activityonChat=[[UIActivityIndicatorView alloc]init];
        activityonChat.activityIndicatorViewStyle=UIActivityIndicatorViewStyleGray;
        activityonChat.tag=4444;
        activityonChat.center=CGPointMake(ChatView.center.x-50,ChatView.center.y-20);
        [ChatView addSubview:activityonChat];
         ScreenViewRect.origin.x-=260.0f;
        [ChatView setHidden:NO];
        [self AddProtectorTo:ScreenView forChat:YES];
        ChatView.backgroundColor=UIColorFromRGB(0x3f4d54);
        [self loadChatTable];
        [ChatView addSubview:scrlChatView];
    }
    
    [UIView animateWithDuration:0.2f animations:^{
        [ScreenView setFrame:ScreenViewRect];
    } completion:^(BOOL finished) {
        if(IsOpen) [ChatView setHidden:YES];
    }];
    
    
    return !IsOpen;
}
-(void)cacellAllOperation
{
 [ChatOperationQueue cancelAllOperations];
}
-(void)loadChatTable
{
    
    for(UIView *view in scrlChatView.subviews)
    {
        [view removeFromSuperview];
    }
    
    NSInvocationOperation *Invoc=[[NSInvocationOperation alloc] initWithTarget:self selector:@selector(getOnlineChat) object:nil];
    [GlobalOperationQueue addOperation:Invoc];
    
    
}
-(void)getOnlineChat
{
   
    
    @try
     {
        if ([self isConnectedToInternet])
        {
           
            NSString *URL=[NSString stringWithFormat:@"%@user.php?mode=online&userid=%@&loggedin_userid=%@", API, [self LoggedId],[self LoggedId]];
            
            NSData *getData=[NSData dataWithContentsOfURL:[NSURL URLWithString:URL]];
            
            
            if([getData length]>2)
            {
                
                NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:getData options:kNilOptions error:nil];
                arrChat=[dict objectForKey:@"onlinefriends"];
                if ([arrChat count]>0)
                {
                    [self performSelectorOnMainThread:@selector(showonlinefriend) withObject:nil waitUntilDone:YES];
                }
                
            }
            
        }
    }
    @catch (NSException *exc)
    {
        NSLog(@"Reporting juju %@ %@",[exc name],exc);
     
    }

    
}

-(void)showonlinefriend
{
    int j=0;
    
    
    for(int i=0;i<[arrChat count];i++)
    {
        NSDictionary *dict=[arrChat objectAtIndex:i];
        UIView *cell=[[UIView alloc]init];
        
        cell =[[[NSBundle mainBundle] loadNibNamed:@"ChatCell" owner:self options:nil] objectAtIndex:0];
        cell.backgroundColor=UIColorFromRGB(0x5c6163);
        
        UILabel *cellLabel=(UILabel *)[cell viewWithTag:7003];
        UIView *cellImageBackView=[cell viewWithTag:7001];
        UIView *onOffView=[cell viewWithTag:7004];
        UIImageView *imageViewexy=(UIImageView *)[cell viewWithTag:7002];
        NSURLRequest *request_img = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[dict objectForKey:@"friendImage"]]]];
        AFImageRequestOperation *operation = [AFImageRequestOperation imageRequestOperationWithRequest:request_img
                                                                                  imageProcessingBlock:nil
                                                                                               success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                                                                   if(image!=nil)
                                                                                                   {
                                                                                                       
                                                                                                       [imageViewexy setImage:image];
                                                                                                       NSLog(@"The value of image :%@",image);
                                                                                                       
                                                                                                   }
                                                                                                   
                                                                                               }
                                                                                               failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                                                                                   NSLog(@"Error : Reporting juju %@",error);
                                                                                                   
                                                                                               }];
        [operation start];
        
        
        
        cellLabel.font=[UIFont fontWithName:MYRIARDPROSAMIBOLT size:15];
        onOffView.backgroundColor=UIColorFromRGB(0x49c95e);
        [self SetroundborderWithborderWidth:0.0f WithColour:[UIColor clearColor] ForImageview:imageViewexy];
        [self SetroundborderWithborderWidth:2.0f WithColour:[UIColor whiteColor] ForView:cellImageBackView];
        
        [self SetroundborderWithborderWidth:0 WithColour:[UIColor whiteColor] ForView:onOffView];
        
        
        cellLabel.text=[dict objectForKey:@"friendName"];
        cellLabel.textColor=[UIColor whiteColor];
        
        
        
        cell.frame=CGRectMake(0, j, cell.frame.size.width, cell.frame.size.height);
        cell.tag=2000+i;
        UITapGestureRecognizer *tapOnOnlineFriend=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(getTapOnOnlineFriend:)];
        [cell addGestureRecognizer:tapOnOnlineFriend];
        
        [scrlChatView addSubview:cell];
        NSLog(@"Value of j %d",j);
        j+=59;
        
        
    }

}

-(void)getTapOnOnlineFriend:(UITapGestureRecognizer *)tappp
{
    int tappedTag=tappp.view.tag-2000;
    NSDictionary *dict=[arrChat objectAtIndex:tappedTag];
    TTTCretenewmessage *creteNewmsg=[[TTTCretenewmessage alloc]init];
    creteNewmsg.MessageSenderid=[dict objectForKey:@"friendid"];
    creteNewmsg.friendName=[dict objectForKey:@"friendName"];
    creteNewmsg.Friendimageurl=[dict objectForKey:@"friendImage"];
    [self presentViewController:creteNewmsg animated:YES completion:^{
        [SVProgressHUD dismiss];
    }];
    
}
-(BOOL)PerformMenuSlider:(UIView *)ScreenView withMenuArea:(UIView *)MenuView IsOpen:(BOOL)IsOpen
{
    CGRect ScreenViewRect=[ScreenView frame];
   // [ScreenView endEditing:YES];
    IsPerformingMenu=TRUE;
    
    if(IsOpen)
    {
        ScreenViewRect.origin.x-=260.0f;
       // [self RemoveProtectorFrom:ScreenView];
    }
    else
    {
        ScreenViewRect.origin.x+=260.0f;
        [MenuView setHidden:NO];
      //  [self AddProtectorTo:ScreenView forChat:NO];
        
    }
    
    [UIView animateWithDuration:0.3f animations:^{
        [ScreenView setFrame:ScreenViewRect];
    } completion:^(BOOL finished) {
        if(IsOpen) [MenuView setHidden:NO];
    }];
    
    return !IsOpen;
}



-(void)RemoveProtectorFrom :(UIView *)ScreenView
{
    for(UIView *Child in [ScreenView subviews])
    {
        if([Child isKindOfClass:[UIView class]] && Child==VSwipeProtector)
        {
            [Child removeGestureRecognizer:GlobalPanGesture];
            [Child removeFromSuperview];
        }
    }
}


-(void)AddProtectorTo :(UIView *)ScreenView forChat:(BOOL)isforChat
{
    CGRect TempRect=CGRectMake(0.0f, 0.0f, 320.0f, [ScreenView bounds].size.height-43.0f);
    TempRect.origin.y=(isforChat)?0.0f:63.0f;
    
    VSwipeProtector=[[UIView alloc] initWithFrame:TempRect];
    [ScreenView addSubview:VSwipeProtector];
    GlobalPanGesture=[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(PerformSwipe:)];
    //[VSwipeProtector addGestureRecognizer:GlobalPanGesture];
}

-(void)PostImageToFacebook:(UIImage *)Image
{
    [SVProgressHUD showWithStatus:@"Please wait..."];
    FBSession.activeSession = [[FBSession alloc] initWithAppID:@"221738314662046" permissions:[NSArray arrayWithObjects:@"publish_actions",@"publish_stream",nil] urlSchemeSuffix:@"" tokenCacheStrategy:nil];
    [FBSession openActiveSessionWithPublishPermissions:[NSArray arrayWithObjects:@"publish_actions",@"publish_stream",nil] defaultAudience:FBSessionDefaultAudienceFriends allowLoginUI:YES completionHandler:^(FBSession *session, FBSessionState status, NSError *error)
     {
         
         if (!error && status == FBSessionStateOpen)
             [self PostToFacebookWith:[GlobalMethodInLocal ConvertImageToNSData:Image]];
         else
             [self sessionStateChanged:session state:status error:error withImageData:[GlobalMethodInLocal ConvertImageToNSData:Image]];
         
     }];
}



- (void)PostToFacebookWith:(NSData *)imageData
{
    NSMutableDictionary * params = [NSMutableDictionary dictionaryWithObjectsAndKeys: BASEURL, @"message", imageData, @"source", nil];
    
    [FBRequestConnection startWithGraphPath:@"me/photos" parameters:params HTTPMethod:@"POST" completionHandler:^(FBRequestConnection *connection, id result, NSError *error)
     {
         if(error)
         {
             NSLog(@" error is %@",error);
             [FBSession openActiveSessionWithPublishPermissions:[NSArray arrayWithObjects:@"publish_actions",@"publish_stream",nil] defaultAudience:FBSessionDefaultAudienceFriends allowLoginUI:YES completionHandler:^(FBSession *session, FBSessionState status, NSError *error)
              {
                  if (!error && status == FBSessionStateOpen)
                  {
                      //[self PostToFacebookWith:imageData];
                      [SVProgressHUD showErrorWithStatus:@"Faild to post facebook"];
                  }
                  else
                  {
                      [self sessionStateChanged:session state:status error:error withImageData:imageData];
                  }
              }];
         }
         else
         {
             [SVProgressHUD showSuccessWithStatus:@"Successfully shared to facebook"];
         }
     }];
}



- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error withImageData:(NSData *)ImageData
{
    NSLog(@"Session State Changed: %u", [[FBSession activeSession] state]);
    
    if (!(state == FBSessionStateCreated || state == FBSessionStateCreatedTokenLoaded))
    {
        // login may only be called once, and only from one of the two initial states
        
        //[[NSException exceptionWithName:FBInvalidOperationException reason:@"FBSession: an attempt was made to open an already opened or closed session" userInfo:nil] raise];
    }
    else
    {
        switch (state)
        {
            case FBSessionStateOpen:
                [self PostToFacebookWith:ImageData];
                break;
                
            case FBSessionStateClosed:
            case FBSessionStateClosedLoginFailed:
                [[FBSession activeSession] closeAndClearTokenInformation];
                [SVProgressHUD showErrorWithStatus:@"Faild to post"];
                break;
                
            default:
                break;
        }
    }
}




#pragma mark for navbar



-(NSString *)RemoveNullandreplaceWithSpace:(NSString *)CheckNullForthis
{
    
    NSString *returnString;
    if ([CheckNullForthis isEqual:(id)[NSNull null]])
    {
        returnString=@"";
    }
    else
    {
        returnString=CheckNullForthis;
    }
    return returnString;
    }



-(void)ClearMatchData
{
    NSMutableDictionary *SessionParam=[[NSMutableDictionary alloc] init];
    [SessionParam setValue:@"abc" forKey:@"23"];
    NSUserDefaults *session=[[NSUserDefaults alloc] init];
    [session setObject:SessionParam forKey:SESSION_MATCHCREATEPARAMETES];
    [session synchronize];
}


-(BOOL)IsExists:(NSString *)SuspectedId InThe:(NSArray *)Container
{
    for(TTTGlobalMethods *LocalMethod in Container)
    {
        if([(NSString *)[LocalMethod Id] isEqualToString:SuspectedId])
            return TRUE;
    }
    return FALSE;
}

-(int)getIndexOfId:(NSString *)SuspectedId InThe:(NSArray *)Container
{
    int index=0;
    for(TTTGlobalMethods *LocalMethod in Container)
    {
        if([(NSString *)[LocalMethod Id] isEqualToString:SuspectedId]) return index;
        index+=1;
    }
    return index;
}


-(NSString *)LocalTimeZoneName
{
    NSString *TimeZone=[[[NSTimeZone localTimeZone] name] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return [TimeZone stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

-(NSString *)LocalDateTime
{
    UIDatePicker *PrivateDatePicker;
    PrivateDatePicker=[[UIDatePicker alloc] init];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateStyle = kCFDateFormatterFullStyle;
    df.timeStyle=kCFTimeZoneNameStyleShortStandard;
    
    return [df stringFromDate:PrivateDatePicker.date];
}


-(UIViewController *)CurrentViewConttroler
{
    UIResponder *responder = self;
    while (![responder isKindOfClass:[UIViewController class]])
    {
        responder = [responder nextResponder];
        if (nil == responder)
        {
            break;
        }
    }
    return (UIViewController *)responder;
}


-(void)goToProfileScreen
{
    //    GolferDetilasView *GolferDetilasViewNib=[[GolferDetilasView alloc] init];
    //    [GolferDetilasViewNib setViewerId:[self LoggedId]];
    //    [[self navigationController] pushViewController:GolferDetilasViewNib animated:YES];
    
//    GolferProfileView *GolferProfileViewNib=[[GolferProfileView alloc] init];
//    [GolferProfileViewNib setViewerId:[self LoggedId]];
//    [[self navigationController] pushViewController:GolferProfileViewNib animated:YES];
}

//if(IsLeftMenuBoxOpen)
//{
//    IsLeftMenuBoxOpen=FALSE;
//    [UIView animateWithDuration:0.2f animations:^{
//
//        CGRect tempRect=[ScreenView frame];
//        tempRect.origin.x-=260.0f;
//        [ScreenView setFrame:tempRect];
//
//    } completion:^(BOOL finished) {
//
//        [VLeftMenu setHidden:YES];
//    }];
//}
//else
//{
//    IsLeftMenuBoxOpen=TRUE;
//    [VLeftMenu setHidden:NO];
//    [UIView animateWithDuration:0.2f animations:^{
//
//        CGRect tempRect=[ScreenView frame];
//        tempRect.origin.x+=260.0f;
//        [ScreenView setFrame:tempRect];
//
//    }];
//}


#pragma mark - Table view data source


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (tableView==TblChat)?44.0f:40.0f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   
    
         return [ChaterArray count];
    
    
   
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    
        cell =[[[NSBundle mainBundle] loadNibNamed:@"ExtendedCell" owner:self options:nil] objectAtIndex:4];
        
        TTTGlobalMethods *LcoalMethod=[ChaterArray objectAtIndex:[indexPath row]];
        
        UIImageView *FriendImage=(UIImageView *)[cell viewWithTag:1];
        UILabel *FriendName=(UILabel *)[cell viewWithTag:2];
        [self LoadImage:@[FriendImage, [NSURL URLWithString:[LcoalMethod FriendImageURL]], @"3", @"Fill"]];
        [FriendName setText:[LcoalMethod FriendName]];


    
    return cell;
    
}

#pragma mark - delegates

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (BOOL)shouldAutorotate
{
    return NO;
}
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

//method for add footerview
-(void)addfooterviewtoView:(UIView *)FooterView WithImage:(UIImage *)footerBackground Withintableview:(BOOL)insideTableview WithScreenView:(UIView *)Screenview
 {
    
 }

- (IBAction)GoestoEditimage:(id)sender
{
    TTTSignInuploadImage *uploadImage=[[TTTSignInuploadImage alloc]init];
    uploadImage.isUpdate=YES;
    [self PushViewController:uploadImage TransitationFrom:kCATransitionFade];
    
}

- (IBAction)goesprofileviewcontro:(id)sender
{
    TTTProfileViewController *profileview=[[TTTProfileViewController alloc]init];
    [self PushViewController:profileview TransitationFrom:kCATransitionFade];
}

-(void)SetroundborderWithborderWidth:(CGFloat)BorderWidth WithColour:(UIColor *)RGB ForView:(UIView *)Forview
{
   
    
    [[Forview layer] setCornerRadius:[Forview frame].size.width/2.0f];
    [[Forview layer] setBorderColor:[RGB CGColor]];
    [[Forview layer] setBorderWidth:BorderWidth];
    [[Forview layer] setMasksToBounds:YES];
     Forview.layer.opacity=.50f;
}

-(NSData *)ConvertImagetoDataJPEGrepresentation:(UIImageView *)Imageview
{
    NSData *Imagedata= UIImageJPEGRepresentation(Imageview.image, 0.4);
    return Imagedata;
}

//validate date time
-(BOOL)IsThaturlvalid:(NSString *)YoururlString
{
    NSString *urlRegEx =@"(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+";
    NSPredicate *urlPredic = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegEx];
    BOOL isValidURL = [urlPredic evaluateWithObject:YoururlString];
    return isValidURL;
}

-(void)globalSearch{
    NSString *searchtext=_manuSearchtxt.text;
    TTTCourseListViewController *CourseList=[[TTTCourseListViewController alloc]init];
    CourseList.searchtextfrommenu=searchtext;
    CourseList.isComingfrommenu=TRUE;
    [self PushViewController:CourseList TransitationFrom:kCATransitionFade];
}


@end
