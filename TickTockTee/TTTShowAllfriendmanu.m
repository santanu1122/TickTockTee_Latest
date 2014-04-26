//
//  TTTShowAllfriendmanu.m
//  TickTockTee
//
//  Created by macbook_ms on 02/04/14.
//  Copyright (c) 2014 com.esolz.TickTockTee. All rights reserved.
//

#import "TTTShowAllfriendmanu.h"
#import "TTTGlobalMethods.h"
#import "TTTProfileViewController.h"
#import "TTTCellForInvitefriend.h"
#import "AFImageRequestOperation.h"
#import "AFNetworking.h"
#import "TTTScarchfriendInfriendList.h"
#import "TTTProfileViewController.h"
#import "TTTCretenewmessage.h"
#import "TTTAddPhotoWithoption.h"
@interface TTTShowAllfriendmanu ()<UIGestureRecognizerDelegate>
{
BOOL IfSearchViewopen,IsLeftMenuBoxOpen;
NSMutableArray *friendlistarray;
NSMutableDictionary *dicForAll;
UIButton *message;
NSOperationQueue *Opeartion;
NSMutableArray *AppCeck;
BOOL isCheck;
NSString *ViewerID;
NSMutableArray *FilterArry;
BOOL isFiltered;
NSInteger numbor;
BOOL  islastlocation;
BOOL isFastLocation;
NSString *LastLoadedid;
    BOOL isloadmoredata;
    
    
    

    
}
@property (strong, nonatomic) IBOutlet UIButton *Menubutton;

@property (strong, nonatomic) IBOutlet UIButton *BackbuttonWhenshowfriend;
@property (strong, nonatomic) IBOutlet UIButton *Invitefndbuton;

@property (strong, nonatomic) IBOutlet UILabel *page_title;
@property (strong, nonatomic) IBOutlet UIView *footerView;
@property (strong, nonatomic) IBOutlet UIView *ScreenView;
@property (strong, nonatomic) IBOutlet UILabel *search_lbl;
@property (strong, nonatomic) IBOutlet UITableView *friendlist;
@property (strong, nonatomic) IBOutlet UIView *MenuView;
@property (strong, nonatomic) IBOutlet UILabel *footer_label;
@property (strong, nonatomic) IBOutlet UIView *searchView;
@property (strong, nonatomic) IBOutlet UITextField *Searchtextfield;
@property (strong, nonatomic) IBOutlet UIImageView *ScarchIconpng;
@property (strong, nonatomic) IBOutlet UIView *Hideview;

@end

@implementation TTTShowAllfriendmanu
@synthesize page_title,footerView,ScreenView,search_lbl,friendlist,footer_label,searchView,Searchtextfield,ScarchIconpng,MenuView,Parmfrienduserid;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //self=(IsIphone5)?[super initWithNibName:@"TTTInvitefriendViewController" bundle:nil]:[super initWithNibName:@"TTTInvitefriendViewController_iPhone4" bundle:nil];
    }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    friendlistarray=[[NSMutableArray alloc] init];
    Opeartion=[[NSOperationQueue alloc]init];
    self.Invitefndbuton.hidden=YES;
    IsLeftMenuBoxOpen=FALSE;
    isCheck=FALSE;
    isloadmoredata=TRUE;
    FilterArry=[[NSMutableArray alloc]init];
    [self AddLeftMenuTo:MenuView];
    page_title.font = [UIFont fontWithName:MYREADPROREGULAR size:17.0];
    search_lbl.font = [UIFont fontWithName:MYRIARDPROLIGHT size:16.0];
    
    Searchtextfield.font=[UIFont fontWithName:MYRIARDPROLIGHT size:15.0f];
    [Searchtextfield setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    ViewerID=([Parmfrienduserid length]>0)?Parmfrienduserid:[self LoggedId];
    
    if (Parmfrienduserid.length>0)
    {
        self.BackbuttonWhenshowfriend.hidden=NO;
        self.Menubutton.hidden=YES;
        
    }
    else
    {
        islastlocation=TRUE;
        isFastLocation=TRUE;

        self.BackbuttonWhenshowfriend.hidden=YES;
        self.Menubutton.hidden=NO;
        UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panDetected:)];
        panRecognizer.delegate=self;
        [self.ScreenView addGestureRecognizer:panRecognizer];

    }
    [SVProgressHUD show];
     NSInvocationOperation *operationLoadFnd=[[NSInvocationOperation alloc]initWithTarget:self selector:@selector(LoadAlldata:) object:@"0"];
    [Opeartion addOperation:operationLoadFnd];
    [self.Hideview setHidden:YES];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    //[self LoadAlldata];
    
    
}

- (IBAction)PerformmanuSlider:(id)sender
{
    IsLeftMenuBoxOpen=[self PerformMenuSlider:ScreenView withMenuArea:MenuView IsOpen:IsLeftMenuBoxOpen];
    if (IsLeftMenuBoxOpen==TRUE)
    {
        [self.Hideview setHidden:NO];

    }
    else
    {
        [self.Hideview setHidden:YES];

    }
    
}
- (void)panDetected:(UIPanGestureRecognizer *)panRecognizer
{
    
    CGPoint  stopLocation;
    
    
    
    if (panRecognizer.state == UIGestureRecognizerStateBegan)
    {
        
        // CGPoint startLocation = [panRecognizer translationInView:_ScreenView];
        // NSLog(@"Strart locaton:%f",startLocation.x);
        
    }
    else if (panRecognizer.state == UIGestureRecognizerStateChanged)
    {
        stopLocation = [panRecognizer translationInView:ScreenView];
        
        CGRect frame=[ScreenView frame];
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
                    ScreenView.frame=frame;
                    
                }];
                
            }
            else
            {
                
                IsLeftMenuBoxOpen=YES;
                isFastLocation=TRUE;
                CGRect lastFrame=[ScreenView frame];
                lastFrame.origin.x=260;
                [UIView animateWithDuration:.5 animations:^{
                    ScreenView.frame=lastFrame;
                    [self.Hideview setHidden:NO];

                }];
            }
        }
        
        
        else
        {
            
            
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
                
                [UIView animateWithDuration:.2 animations:^{
                    ScreenView.frame=frame;
                    
                }];
                
            }
            else
            {
                
                IsLeftMenuBoxOpen=NO;
                islastlocation=TRUE;
                CGRect lastFrame2=[ScreenView frame];
                lastFrame2.origin.x=0;
                [UIView animateWithDuration:.5 animations:^{
                    ScreenView.frame=lastFrame2;
                    [self.Hideview setHidden:YES];

                }];
            }
        }
        
        
        
        
        
    }
    
    else if (panRecognizer.state==UIGestureRecognizerStateEnded)
    {
        if (stopLocation.x<150&islastlocation==TRUE&IsLeftMenuBoxOpen==NO)
        {
            NSLog(@"The value of pan end");
            CGRect framelast=[ScreenView frame];
            framelast.origin.x=0;
            
            
            [UIView animateWithDuration:.6 animations:^{
                ScreenView.frame=framelast;
                
            }];
        }
        
        if (stopLocation.x*-1<100.0f&islastlocation==TRUE&IsLeftMenuBoxOpen==YES)
        {
            
             NSLog(@"This is the start");
            CGRect framelast=[ScreenView frame];
            framelast.origin.x=260;
            
            
            [UIView animateWithDuration:.6 animations:^{
                ScreenView.frame=framelast;
                
            }];
            
        }
        
        
    }
    
    
    
}



-(void)LoadAlldata:(NSString *)lastID
{
    if ([self isConnectedToInternet])
    {
        @try
        {
            
              NSString *StringUrl=[NSString stringWithFormat:@"%@user.php?mode=friends&userid=%@&loggedin_userid=%@&lastid=%@",API,ViewerID,[self LoggedId],lastID];
              NSLog(@"The string url:%@",StringUrl);
//            if ([self IsThaturlvalid:StringUrl])
//            {
            
                NSData *data=[NSData dataWithContentsOfURL:[NSURL URLWithString:StringUrl]];
               if (data.length>2)
               {
                   NSDictionary *alldict=[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                   NSDictionary *Extraparam=[alldict valueForKey:@"extraparam"];
                   LastLoadedid=[Extraparam valueForKey:@"lastid"];
                   if ([[Extraparam valueForKey:@"moredata"] integerValue]==0)
                   {
                       isloadmoredata=FALSE;
                   }
                   
                   NSArray *mainArray=[alldict objectForKey:@"friendslist"];
                   if ([mainArray count]>0)
                   {
                       
                       for(NSMutableDictionary *loop in mainArray)
                       {
                           NSMutableDictionary *dicForAllFormyarry = [[NSMutableDictionary alloc]init];
                           
                           [dicForAllFormyarry setValue:[loop objectForKey:@"FriendId"] forKey:@"FriendId"];
                           [dicForAllFormyarry setValue:[loop objectForKey:@"FriendName"] forKey:@"FriendName"];
                           [dicForAllFormyarry setValue:[loop objectForKey:@"FriendImage"] forKey:@"FriendImage"];
                           [dicForAllFormyarry setValue:[loop objectForKey:@"Totalfriends"] forKey:@"Totalfriends"];
                           [dicForAllFormyarry setValue:[loop objectForKey:@"email"] forKey:@"email"];
                           [dicForAllFormyarry setValue:[loop objectForKey:@"deletefriendpermission"] forKey:@"deletefriendpermission"];
                           
                           
                           [friendlistarray addObject:dicForAllFormyarry];
                           
                           
                       }
                       
                       
                       [self performSelectorOnMainThread:@selector(ReloadTable) withObject:nil waitUntilDone:YES];
                       
                   }
                   else
                   {
                       dispatch_async(dispatch_get_main_queue(), ^{
                           
                           [SVProgressHUD showErrorWithStatus:@"No Friends Found"];
                       });
                   }

               }
              else
              {
                [SVProgressHUD showErrorWithStatus:@"unexpected error occurred"];
              }
  
           // }
          
            
        }
        @catch (NSException *exception)
        {
            NSLog(@" %s exception %@",__PRETTY_FUNCTION__,exception);
        }

    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [SVProgressHUD showErrorWithStatus:@"No internet connection"];
        });

    }
}




-(void)ReloadTable
{
    [SVProgressHUD dismiss];
    [friendlist reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewDidAppear:(BOOL)animated
{
    
    friendlist.delegate=self;
    friendlist.dataSource=self;
    friendlist.backgroundColor=[UIColor clearColor];
    
}
- (IBAction)BackToprivious:(id)sender
{
   [self PerformGoBack];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    
    return (isFiltered)?[FilterArry count]:[friendlistarray count];
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 78;
    
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifier=@"TTTCellForInvitefriend";
    
    TTTCellForInvitefriend *cell;//=(TTTCellForInvitefriend *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    NSMutableDictionary *mutDic;
    if (isFiltered)
    {
        mutDic=[FilterArry objectAtIndex:indexPath.row];
    }
    else
    {
       mutDic=[friendlistarray objectAtIndex:indexPath.row];
    }
    
    
        NSArray *arr=[[NSBundle mainBundle]loadNibNamed:cellIdentifier owner:self options:nil];
        cell=(TTTCellForInvitefriend *)[arr objectAtIndex:0];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    

    

    UIScrollView *scroll = (UIScrollView *) [cell.contentView viewWithTag:117];
    scroll.contentSize=CGSizeMake(384,77);
    [scroll setTag:indexPath.row+1];
    UIView *viewOnProfileImage = (UIView *) [cell.contentView viewWithTag:111];
    [self SetroundborderWithborderWidth:2.0f WithColour:[UIColor lightGrayColor] ForView:viewOnProfileImage];

    UIImageView *profileImage = (UIImageView *) [cell.contentView viewWithTag:112];
    [self setRoundBorderToImageView:profileImage];
    UIActivityIndicatorView *spinner=(UIActivityIndicatorView *)[cell.contentView viewWithTag:200];
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureAction:)];
    [recognizer setNumberOfTapsRequired:1];
    scroll.userInteractionEnabled = YES;
    [scroll addGestureRecognizer:recognizer];
    NSString *BackgroundImageStgring=[mutDic valueForKey:@"FriendImage"];
    
    
    
    NSURLRequest *request_img = [NSURLRequest requestWithURL:[NSURL URLWithString:BackgroundImageStgring]];
    AFImageRequestOperation *operation = [AFImageRequestOperation imageRequestOperationWithRequest:request_img
                                                                              imageProcessingBlock:nil
                                                                                           success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                                                               if(image!=nil)
                                                                                               {
                                                                                                   [profileImage setImage:image];
                                                                                                   [spinner stopAnimating];
                                                                                                   [spinner setHidden:YES];
                                                                                               }
                                                                                               
                                                                                           }
                                                                                           failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                                                                               NSLog(@"Error %@",error);
                                                                                               
                                                                                               
                                                                                               
                                                                                           }];
    [operation start];
//
//    
//    
//    
    UILabel *name = (UILabel *) [cell.contentView viewWithTag:113];
    name.text =[mutDic valueForKey:@"FriendName"] ;
    name.font=[UIFont fontWithName:MYRIARDPROSAMIBOLT size:16.0];
//
    UILabel *no_friends = (UILabel *) [cell.contentView viewWithTag:114];
    
    no_friends.text =[NSString stringWithFormat:@"%@ Friends",[mutDic valueForKey:@"Totalfriends"]];
    no_friends.font=[UIFont fontWithName:MYRIARDPROLIGHT size:14.0];
    if ([[mutDic valueForKey:@"deletefriendpermission"] integerValue]==1)
    {
        UIButton *messAgebtn=(UIButton *) [cell.contentView viewWithTag:115];
        messAgebtn.tag=9999+indexPath.row;
        [messAgebtn addTarget:self action:@selector(Sendmessage:) forControlEvents:UIControlEventTouchUpInside];
        UIButton *Deletbutton=(UIButton *)[cell.contentView viewWithTag:116];
        Deletbutton.tag=99999+indexPath.row;
        [Deletbutton addTarget:self action:@selector(Deleteanfrend:) forControlEvents:UIControlEventTouchUpInside];
         messAgebtn.hidden=YES;
    }
    else
    {
        NSLog(@"Show all friend");
        UIButton *messAgebtn=(UIButton *) [scroll viewWithTag:115];
        messAgebtn.tag=9999+indexPath.row;
        [messAgebtn setHidden:YES];
        [messAgebtn setBackgroundImage:nil forState:UIControlStateNormal];
        
        [messAgebtn addTarget:self action:@selector(Sendmessage:) forControlEvents:UIControlEventTouchUpInside];
        UIButton *Deletbutton=(UIButton *)[cell.contentView viewWithTag:116];
        Deletbutton.tag=99999+indexPath.row;
        [Deletbutton setBackgroundImage:[UIImage imageNamed:@"message"] forState:UIControlStateNormal];
        [Deletbutton addTarget:self action:@selector(Deleteanfrend:) forControlEvents:UIControlEventTouchUpInside];
        messAgebtn.hidden=YES;

    }
   
//    // scroll.contentOffset.x=64.0f;
   // [scroll setContentOffset:CGPointMake(0, 0)];

    return cell;
    
}

-(IBAction)Deleteanfrend:(UIButton *)sender
{
    numbor=sender.tag-99999;
    NSMutableDictionary *mutDic;
    if (isFiltered)
    {
        mutDic=[FilterArry objectAtIndex:numbor];
    }
    else
    {
         mutDic=[friendlistarray objectAtIndex:numbor];
    }
    
    NSString *fndId=[mutDic valueForKey:@"FriendId"];
  
    if ([[mutDic valueForKey:@"deletefriendpermission"] integerValue]==1)
    {
         NSInvocationOperation *friendrequest=[[NSInvocationOperation alloc]initWithTarget:self selector:@selector(deletfriend:) object:fndId];
         [Opeartion addOperation:friendrequest];
    }
    else
    {
        NSUserDefaults *userdefalds=[NSUserDefaults standardUserDefaults];
        [userdefalds setValue:nil forKey:SESSION_MATCHCREATEPARAMETES];
        [userdefalds setValue:nil forKey:COURSE_ID];
        [userdefalds setValue:nil forKey:COURSE_NAME];
        [userdefalds synchronize];

        TTTCretenewmessage *messageViewcontroller=[[TTTCretenewmessage alloc]init];
        messageViewcontroller.MessageSenderid=fndId;
        messageViewcontroller.Friendimageurl=[mutDic valueForKey:@"FriendImage"];
        messageViewcontroller.friendName=[mutDic valueForKey:@"FriendName"];
        [self presentViewController:messageViewcontroller animated:YES completion:^{
            
        }];
    }
   
    
    
}
-(void)deletfriend:(NSString *)friendID
{
    if ([self isConnectedToInternet])
    {
        @try
        {
            NSError *Error;
            NSString *StringUrl=[NSString stringWithFormat:@"%@user.php?mode=deletefriend&userid=%@&friendid=%@",API,[self LoggedId],friendID];
            NSLog(@"The friend id:%@",friendID);
            NSData *SentDeletInfo=[NSData dataWithContentsOfURL:[NSURL URLWithString:StringUrl]];
            NSDictionary *dataDic=[NSJSONSerialization JSONObjectWithData:SentDeletInfo options:kNilOptions error:&Error];
            NSString *Responce=[dataDic valueForKey:@"status"];
            NSString *returnmessage=[dataDic valueForKey:@"message"];
            if ([Responce isEqualToString:@"success"])
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                   
                    [friendlistarray removeObjectAtIndex:numbor];
                 
                     NSIndexPath *Indexpath=[NSIndexPath indexPathForRow:numbor inSection:0];
                    [friendlist beginUpdates];
                    [friendlist deleteRowsAtIndexPaths:[[NSArray alloc]initWithObjects:Indexpath, nil] withRowAnimation:UITableViewRowAnimationFade];
                    [friendlist endUpdates];
                     [SVProgressHUD showSuccessWithStatus:returnmessage];
                    
                });
            }
            else
            {
                  [SVProgressHUD showErrorWithStatus:returnmessage];
            }

        }
        @catch (NSException *exception)
        {
            NSLog(@"ERROR REPORT:--------------%@",exception);
        }
       
        
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:@"request could not complete"];
    }
    
    
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
     [self performSearch];
    return YES;
}

-(IBAction)Sendmessage:(UIButton *)sender
{
    NSUserDefaults *userdefalds=[NSUserDefaults standardUserDefaults];
    [userdefalds setValue:nil forKey:SESSION_MATCHCREATEPARAMETES];
    [userdefalds setValue:nil forKey:COURSE_ID];
    [userdefalds setValue:nil forKey:COURSE_NAME];
    [userdefalds synchronize];

    
    numbor=sender.tag-9999;
    NSMutableDictionary *mutDic=[friendlistarray objectAtIndex:numbor];
    
    NSString *fndId=[mutDic valueForKey:@"FriendId"];
    NSLog(@"The value of frend id:%@",fndId);
    TTTCretenewmessage *messageViewcontroller=[[TTTCretenewmessage alloc]init];
    messageViewcontroller.MessageSenderid=fndId;
      messageViewcontroller.Friendimageurl=[mutDic valueForKey:@"FriendImage"];
      messageViewcontroller.friendName=[mutDic valueForKey:@"FriendName"];
    
    
    [self presentViewController:messageViewcontroller animated:YES completion:^{
        
    }];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.tag>0)
    {
        NSMutableDictionary *mutDic=[friendlistarray objectAtIndex:scrollView.tag-1];
        NSString *StrString=[mutDic valueForKey:@"deletefriendpermission"];
    
        if (scrollView.contentOffset.x>30)
        {
           
            NSArray *subView=[scrollView subviews];
           
            
            for (UIView *MyView in subView)
            {
                if ([MyView isKindOfClass:[UIButton class]])
                {
                    UIButton *button=(UIButton *)MyView;
                    if (button.tag==(scrollView.tag-1)+9999&&[StrString integerValue]==0)
                    {
                        button.hidden=YES;
                    }
                    else
                    {
                    button.hidden=NO;
                    }
                }
            }
           // [friendlist reloadData];

        }
        else if(scrollView.contentOffset.x<=5)
        {
          
            NSArray *subView=[scrollView subviews];
            for (UIView *MyView in subView)
            {
                if ([MyView isKindOfClass:[UIButton class]])
                {
                    UIButton *button=(UIButton *)MyView;
                    button.hidden=YES;
                }
            }
          

        }
    }

}





- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"call theis methos");
    
   
}

- (IBAction)FilterThefrienddata:(id)sender
{
    [self performSearch];
}

-(void)gestureAction:(UITapGestureRecognizer *) sender
{
    CGPoint touchLocation = [sender locationOfTouch:0 inView:friendlist];
    NSIndexPath *indexPath = [friendlist indexPathForRowAtPoint:touchLocation];
    NSMutableDictionary *mutablDic=[friendlistarray objectAtIndex:indexPath.row];
    TTTProfileViewController *ProfileView=[[TTTProfileViewController alloc]init];
    ProfileView.ParamprofileViewerId=[mutablDic valueForKey:@"FriendId"];
    ProfileView.mainLabelString=[mutablDic valueForKey:@"FriendName"];
    [self PushViewController:ProfileView TransitationFrom:kCATransitionFade];
    
    
}
- (IBAction)Searchfriendjson:(id)sender
{
    TTTScarchfriendInfriendList *Searchfrndlist=[[TTTScarchfriendInfriendList alloc]init];
    
    [self PushViewController:Searchfrndlist TransitationFrom:kCATransitionFromTop];
   
}

//filter array
-(void)performSearch
{
    
    isFiltered=FALSE;
    if([[Searchtextfield text] length]>0)
    {
        isFiltered=TRUE;
        [FilterArry removeAllObjects];
        
        for(NSMutableDictionary *Friendlistarry in friendlistarray)
        {
            NSRange FnameRange=[[Friendlistarry valueForKey:@"FriendName"] rangeOfString:[Searchtextfield text] options:NSCaseInsensitiveSearch];
            
            NSRange emailRange=[[Friendlistarry valueForKey:@"email"] rangeOfString:[Searchtextfield text] options:NSCaseInsensitiveSearch];
         
            
            if(FnameRange.location!=NSNotFound || emailRange.location!=NSNotFound ) [FilterArry addObject:Friendlistarry];
        }
    }
     [friendlist reloadData];
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if (textField ==Searchtextfield)
    {
         [self performSearch];
    }
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField==Searchtextfield)
    {
        [self performSearch];
    }
}
- (IBAction)Backbuttonclick:(id)sender
{
    [self PerformGoBack];
}
//onScroll loadmore
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
 
    
    CGPoint offset = scrollView.contentOffset;
    CGRect bounds = scrollView.bounds;
    CGSize size = scrollView.contentSize;
    UIEdgeInsets inset = scrollView.contentInset;
    float y = offset.y + bounds.size.height - inset.bottom;
    float h = size.height;
    
    float reload_distance = -40.0f;
    if(y > h + reload_distance)
    {
        if (!scrollView.tag>0)
        {
        if (isloadmoredata==TRUE)
        {
        NSLog(@"Print original load more:");
        NSInvocationOperation *invocation=[[NSInvocationOperation alloc] initWithTarget:self selector:@selector(LoadAlldata:) object:LastLoadedid];
        [Opeartion addOperation:invocation];
           
        }
        else
        {
            NSLog(@"no more data avilable:");
        }
        }
        
    }
    
    
    
}



@end
