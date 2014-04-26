//
//  TTTNotificationViewController.m
//  TickTockTee
//
//  Created by Esolz_Mac on 02/04/14.
//  Copyright (c) 2014 com.esolz.TickTockTee. All rights reserved.
//
//
//  TTTNotificationViewController.m
//  TickTockTee
//
//  Created by Esolz_Mac on 02/04/14.
//  Copyright (c) 2014 com.esolz.TickTockTee. All rights reserved.
//

#import "TTTNotificationViewController.h"
#import "TTTCellForInvitefriend.h"
#import "SVProgressHUD.h"
#import "AFImageRequestOperation.h"
#import "TTTMatchDetails.h"
#import "TTTPhotodetailsViewController.h"
@interface TTTNotificationViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    
    NSMutableArray *notificationarray,*photosarray;
    NSOperationQueue *OperationQ;
    UIButton *accept,*reject;
    int id;
    NSTimer *ScheduleTimer;
    NSInteger numbor;
}

@property (strong, nonatomic) IBOutlet UILabel *page_title;
@property (strong, nonatomic) IBOutlet UIView *ScreenView;
@property (strong, nonatomic) IBOutlet UITableView *notificationlist;

@end


@implementation TTTNotificationViewController
@synthesize page_title,ScreenView,notificationlist;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self=(IsIphone5)?[super initWithNibName:@"TTTNotificationViewController" bundle:nil]:[super initWithNibName:@"TTTNotificationViewController_iPhone4" bundle:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    page_title.font = [UIFont fontWithName:MYREADPROREGULAR size:18.0];
    photosarray=[[NSMutableArray alloc]init];
    notificationarray=[[NSMutableArray alloc] init];
    notificationlist.delegate=self;
    notificationlist.dataSource=self;
    notificationlist.backgroundColor=[UIColor clearColor];
    OperationQ=[[NSOperationQueue alloc]init];
    [SVProgressHUD show];
    [self domyjob];
    
    
}

-(void)domyjob
{
    [notificationarray removeAllObjects];
    
    NSInvocationOperation *operation=[[NSInvocationOperation alloc]initWithTarget:self selector:@selector(LoadAlldata) object:Nil];
    [OperationQ addOperation:operation];
    
}
-(void)SentFriendrequest
{
    NSInvocationOperation *PerationTimer=[[NSInvocationOperation alloc]initWithTarget:self selector:@selector(LoadAlldata) object:Nil];
    [OperationQ addOperation:PerationTimer];
}
-(void)LoadAlldata
{
    
    
    if ([self isConnectedToInternet])
    {
        NSError *Error;
        @try
        {
            NSString *StringUrl=[NSString stringWithFormat:@"%@user.php?mode=notification&userid=%@",API,[self LoggedId]];
            NSLog(@"The string url:%@",StringUrl);
            NSData *data=[NSData dataWithContentsOfURL:[NSURL URLWithString:StringUrl]];
            if([data length]>0){
                id maindic=[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&Error];
                if ([maindic isKindOfClass:[NSDictionary class]]){
                    
                    if ([[maindic valueForKey:@"notification"] isKindOfClass:[NSArray class]])
                    {
                        NSArray *matchArray=[maindic objectForKey:@"notification"];
                        if ([matchArray count]>0)
                        {
                            
                            for(NSMutableDictionary *loop in matchArray)
                            {
                                NSMutableDictionary *dicForAll = [[NSMutableDictionary alloc]init];
                                
                                [dicForAll setValue:[self RemoveNullandreplaceWithSpace:[loop objectForKey:@"id"]]forKey:@"id"];
                                [dicForAll setValue:[self RemoveNullandreplaceWithSpace:[loop objectForKey:@"type"]]forKey:@"type"];
                                
                                
                                
                                
                                [dicForAll setValue:[self RemoveNullandreplaceWithSpace:[loop objectForKey:@"messageheader"]] forKey:@"messageheader"];
                                [dicForAll setValue:[self RemoveNullandreplaceWithSpace:[loop objectForKey:@"message"]] forKey:@"message"];
                                
                                [dicForAll setValue:[self RemoveNullandreplaceWithSpace:[loop objectForKey:@"invitedby"]] forKey:@"invitedby"];
                                [dicForAll setValue:[self RemoveNullandreplaceWithSpace:[loop objectForKey:@"invitedbyname"]] forKey:@"invitedbyname"];
                                [dicForAll setValue:[self RemoveNullandreplaceWithSpace:[loop objectForKey:@"invitedbythumb"]] forKey:@"invitedbythumb"];
                                [dicForAll setValue:[self RemoveNullandreplaceWithSpace:[loop objectForKey:@"action"]] forKey:@"action"];
                                
                               
                                    [dicForAll setValue:[self RemoveNullandreplaceWithSpace:[loop valueForKey:@"photoid"]] forKey:@"photo_id"];
                                    [dicForAll setValue:[self RemoveNullandreplaceWithSpace:[loop valueForKey:@"photourl"]] forKey:@"photourl"];
                                    [dicForAll setValue:[self RemoveNullandreplaceWithSpace:[loop valueForKey:@"albumid"]]forKey:@"albumid"];
                                    [dicForAll setValue:[self RemoveNullandreplaceWithSpace:[loop valueForKey:@"caption"]] forKey:@"caption"];
                                    [dicForAll setValue:[self RemoveNullandreplaceWithSpace:[loop valueForKey:@"location"]] forKey:@"location"];
                                    [dicForAll setValue:[self RemoveNullandreplaceWithSpace:[loop valueForKey:@"datetime"]] forKey:@"datetime"];
                                    [dicForAll setValue:[self RemoveNullandreplaceWithSpace:[loop valueForKey:@"thumbnail"]] forKey:@"thumbnail"];
                                    [dicForAll setValue:[self RemoveNullandreplaceWithSpace:[loop valueForKey:@"original"]] forKey:@"original"];
                                    [dicForAll setValue:[self RemoveNullandreplaceWithSpace:[loop valueForKey:@"likePermission"]] forKey:@"likePermission"];
                                    [dicForAll setValue:[self RemoveNullandreplaceWithSpace:[loop valueForKey:@"commentPermission"]] forKey:@"commentPermission"];
                                    [dicForAll setValue:[self RemoveNullandreplaceWithSpace:[loop valueForKey:@"sharePermission"]] forKey:@"sharePermission"];
                                    [dicForAll setValue:[self RemoveNullandreplaceWithSpace:[loop valueForKey:@"tagPermission"]] forKey:@"tagPermission"];
                                    
                                    [dicForAll setValue:[self RemoveNullandreplaceWithSpace:[loop valueForKey:@"ActivityLikeCount"]] forKey:@"likecount"];
                                    [dicForAll setValue:[self RemoveNullandreplaceWithSpace:[loop valueForKey:@"ActivityCommentCount"]] forKey:@"commentcount"];
                                    
                                    [dicForAll setValue:[self RemoveNullandreplaceWithSpace:[loop valueForKey:@"ActivityUserLiked"]] forKey:@"isUserLiked"];
                                
                                
                                
                                [notificationarray addObject:dicForAll];
                                
                                
                            }
                            
                            
                            [self performSelectorOnMainThread:@selector(ReloadTable) withObject:nil waitUntilDone:YES];
                            
                        }else
                        {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                
                                [SVProgressHUD showErrorWithStatus:@"No Notification Found"];
                            });
                        }}
                    else
                    {
                        [SVProgressHUD showErrorWithStatus:@"Unexpected error occured"];
                    }
                }else
                {
                    [SVProgressHUD showErrorWithStatus:@"Unexpected error occured"];
                }
            }
        }@catch (NSException *exception) {
            [SVProgressHUD dismiss];
            NSLog(@" %s exception %@",__PRETTY_FUNCTION__,exception);
        }
    }else
    {
        [SVProgressHUD showErrorWithStatus:@"No internet connection"];
    }
}




-(void)ReloadTable
{
    
    [notificationlist reloadData];
    [SVProgressHUD dismiss];
}

- (IBAction)BackToprivious:(id)sender
{
    
    [self PerformGoBack];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [notificationarray count];
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 79;
    
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TTTCellForInvitefriend *cell=(TTTCellForInvitefriend *)[tableView dequeueReusableCellWithIdentifier:@"TTTCellForInvitefriend"];
    cell=nil;
    if (cell==nil)
    {
        NSArray *arr=[[NSBundle mainBundle]loadNibNamed:@"TTTCellForInvitefriend" owner:self options:nil];
        
        cell=[arr objectAtIndex:0];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    UIScrollView *scroll = (UIScrollView *) [cell.contentView viewWithTag:117];
    
    scroll.delegate=self;
    scroll.userInteractionEnabled = YES;
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureAction:)];
    [recognizer setNumberOfTapsRequired:1];
    [scroll addGestureRecognizer:recognizer];
    UIView *viewOnProfileImage = (UIView *) [scroll viewWithTag:111];
    [self SetroundborderWithborderWidth:2.0f WithColour:[UIColor whiteColor] ForView:viewOnProfileImage];
    
    UIImageView *profileImage = (UIImageView *) [scroll viewWithTag:112];
    [self setRoundBorderToImageView:profileImage];
    UIActivityIndicatorView *spinner=(UIActivityIndicatorView *)[scroll viewWithTag:200];
    NSString *BackgroundImageStgring;
//    if([[[notificationarray objectAtIndex:indexPath.row]valueForKey:@"type"] isEqualToString:@"event"]){
//        BackgroundImageStgring=[[notificationarray objectAtIndex:indexPath.row]valueForKey:@"thumb"];
//    }else if([[[notificationarray objectAtIndex:indexPath.row]valueForKey:@"type"] isEqualToString:@"photos"] || [[[notificationarray objectAtIndex:indexPath.row]valueForKey:@"type"] isEqualToString:@"videos"] ){
        BackgroundImageStgring=[[notificationarray objectAtIndex:indexPath.row]valueForKey:@"photourl"];
//    }
    
    NSLog(@"BackgroundImageStgring %@",BackgroundImageStgring);
    
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
                                                                         [spinner stopAnimating];
                                                                         [spinner setHidden:YES];
                                                                                               
                                                                                               
                                                                                           }];
    [operation start];
    
    
    
    
    UILabel *messageheader = (UILabel *) [scroll viewWithTag:113];
    messageheader.text =[[notificationarray objectAtIndex:indexPath.row]valueForKey:@"messageheader"] ;
    messageheader.font=[UIFont fontWithName:MYRIARDPROSAMIBOLT size:16.0];
    
    UILabel *message = (UILabel *) [scroll viewWithTag:114];
    message.text =[[notificationarray objectAtIndex:indexPath.row]valueForKey:@"message"];
    message.font=[UIFont fontWithName:MYRIARDPROLIGHT size:13.0];
    message.numberOfLines=2;
    [message sizeToFit];
    
    accept = (UIButton *) [scroll viewWithTag:115];
    [accept setBackgroundImage:[UIImage imageNamed:@"tick.png"] forState:UIControlStateNormal];
    [accept addTarget:self action:@selector(accept:) forControlEvents:UIControlEventTouchUpInside];
    accept.tag=indexPath.row+9999;
    reject = (UIButton *) [scroll viewWithTag:116];
  
    [reject addTarget:self action:@selector(reject:) forControlEvents:UIControlEventTouchUpInside];
    reject.tag=indexPath.row+99999;
    reject.hidden=YES;
    accept.hidden=YES;
    if([[[notificationarray objectAtIndex:indexPath.row]valueForKey:@"action"] isEqualToString:@"1"] && [[[notificationarray objectAtIndex:indexPath.row]valueForKey:@"type"] isEqualToString:@"event"]){
        scroll.contentSize=CGSizeMake(384,77);
        [scroll setTag:indexPath.row+999];
    }
    
    
    return cell;
    
    
}



-(void)accept:(UIButton *)sender
{
    
    [SVProgressHUD show];
    numbor=sender.tag-9999;
    NSInvocationOperation *acceptReqest=[[NSInvocationOperation alloc]initWithTarget:self selector:@selector(acceptfriendReqest:) object:[notificationarray objectAtIndex:numbor]];
    [OperationQ addOperation:acceptReqest];
    
}

-(void)acceptfriendReqest:(NSMutableDictionary *)NotificationDic
{
    @try
    {
        if([self isConnectedToInternet])
        {
            NSError *error;
            NSString *StringUrl=[NSString stringWithFormat:@"%@user.php?mode=accept_notification&userid=%@&eventid=%@&invitationid=%@",API,[self LoggedId],[NotificationDic valueForKey:@"eventid"],[NotificationDic valueForKey:@"id"]];
            NSLog(@"StringUrl1 %@",StringUrl);
            NSData *data=[NSData dataWithContentsOfURL:[NSURL URLWithString:StringUrl]];
            if([data length]>0)
            {
                NSMutableDictionary *OutputDic=[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                NSString *returnmessage=[OutputDic valueForKey:@"message"];
                NSString *status=[OutputDic valueForKey:@"status"];
                if ([status isEqualToString:@"error"])
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [SVProgressHUD showErrorWithStatus:returnmessage];
                    });
                }
                else
                {
                    [self performSelectorOnMainThread:@selector(RemoverowandShowstatus:) withObject:returnmessage waitUntilDone:YES];
                    
                }
            }
            else
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [SVProgressHUD showErrorWithStatus:@"Unexpected error occured!"];
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
        
    }
    
}


-(void)reject:(UIButton *)sender
{
    [SVProgressHUD show];
    numbor=sender.tag-99999;
    NSInvocationOperation *rejectReqest=[[NSInvocationOperation alloc]initWithTarget:self selector:@selector(Rejctfriendrequest:) object:[notificationarray objectAtIndex:numbor]];
    [OperationQ addOperation:rejectReqest];
    
}
-(void)Rejctfriendrequest:(NSMutableDictionary *)NotificationDic
{
    @try
    {
        if([self isConnectedToInternet])
        {
            NSError *error;
            NSString *StringUrl=[NSString stringWithFormat:@"%@user.php?mode=reject_notification&userid=%@&eventid=%@&invitationid=%@",API,[self LoggedId],[NotificationDic valueForKey:@"eventid"],[NotificationDic valueForKey:@"id"]];
            NSLog(@"StringUrl1 %@",StringUrl);
            NSData *data=[NSData dataWithContentsOfURL:[NSURL URLWithString:StringUrl]];
            if([data length]>0)
            {
                NSMutableDictionary *OutputDic=[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                NSString *returnmessage=[OutputDic valueForKey:@"message"];
                NSString *status=[OutputDic valueForKey:@"status"];
                if ([status isEqualToString:@"error"])
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [SVProgressHUD showErrorWithStatus:returnmessage];
                    });
                }
                else
                {
                    [self performSelectorOnMainThread:@selector(RemoverowandShowstatus:) withObject:returnmessage waitUntilDone:YES];
                    
                }
            }
            else
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [SVProgressHUD showErrorWithStatus:@"Unexpected error occured!"];
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
        
    }
    
}

-(void)RemoverowandShowstatus:(NSString *)message
{
    
    [notificationarray removeObjectAtIndex:numbor];
    [notificationlist reloadData];
       dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD showSuccessWithStatus:message];
    });
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.tag>998)
    {
        if (scrollView.contentOffset.x>30)
        {
            NSArray *subView=[scrollView subviews];
            
            
            for (UIView *MyView in subView)
            {
                if ([MyView isKindOfClass:[UIButton class]])
                {
                    UIButton *button=(UIButton *)MyView;
                    button.hidden=NO;
                }
            }
            
        }
        else
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


-(void)gestureAction:(UITapGestureRecognizer *) sender
{
    CGPoint touchLocation = [sender locationOfTouch:0 inView:notificationlist];
    NSIndexPath *indexPath = [notificationlist indexPathForRowAtPoint:touchLocation];
    NSLog(@"The value of indexpath.row %d",indexPath.row);
    
    if([[[notificationarray objectAtIndex:indexPath.row]valueForKey:@"type"] isEqualToString:@"event"])
    {
        TTTMatchDetails *matchdetais=[[TTTMatchDetails alloc]init];
        matchdetais.matchID=[[notificationarray objectAtIndex:indexPath.row]valueForKey:@"eventid"];
        matchdetais.ParamViewerID=[[notificationarray objectAtIndex:indexPath.row]valueForKey:@"invitedby"];
        [self.navigationController pushViewController:matchdetais animated:YES];
    }
    else if([[[notificationarray objectAtIndex:indexPath.row]valueForKey:@"type"] isEqualToString:@"photos"])
    {
        NSMutableArray *mutPhotoarry=[[NSMutableArray alloc]init];
        [mutPhotoarry addObject:[notificationarray objectAtIndex:indexPath.row]];
        
        TTTPhotodetailsViewController *PhotoDetais=[[TTTPhotodetailsViewController alloc]init];
        PhotoDetais.ParamPhotoArry=mutPhotoarry;
        NSString *TouchviewTag=@"0";
        PhotoDetais.ClickphotoId=TouchviewTag;
        [self presentViewController:PhotoDetais animated:YES completion:^{
            
        }];
    }else if([[[notificationarray objectAtIndex:indexPath.row]valueForKey:@"type"] isEqualToString:@"events.wall"])
    {
        NSMutableArray *mutPhotoarry=[[NSMutableArray alloc]init];
        [mutPhotoarry addObject:[notificationarray objectAtIndex:indexPath.row]];
        
        TTTPhotodetailsViewController *PhotoDetais=[[TTTPhotodetailsViewController alloc]init];
        PhotoDetais.ParamPhotoArry=mutPhotoarry;
        NSString *TouchviewTag=@"0";
        PhotoDetais.ClickphotoId=TouchviewTag;
        [self presentViewController:PhotoDetais animated:YES completion:^{
            
        }];
    }
//    else if([[[notificationarray objectAtIndex:indexPath.row]valueForKey:@"type"] isEqualToString:@"videos"])
//    {
//        NSMutableArray *mutPhotoarry=[[NSMutableArray alloc]init];
//        [mutPhotoarry addObject:[notificationarray objectAtIndex:indexPath.row]];
//        
//        TTTWebVideoViewController *PhotoDetais=[[TTTWebVideoViewController alloc]init];
//        PhotoDetais.ParamPhotoArry=mutPhotoarry;
//        NSString *TouchviewTag=@"0";
//        PhotoDetais.ClickphotoId=TouchviewTag;
//        [self presentViewController:PhotoDetais animated:YES completion:^{
//            
//        }];
//    }
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [ScheduleTimer invalidate];
    [SVProgressHUD dismiss];
    [OperationQ cancelAllOperations];
}

@end
