//
//  TTTAcceptFndrequest.m
//  TickTockTee
//
//  Created by macbook_ms on 03/04/14.
//  Copyright (c) 2014 com.esolz.TickTockTee. All rights reserved.
//

#import "TTTAcceptFndrequest.h"
#import "AFNetworking.h"
#import "AFImageRequestOperation.h"
#import "TTTCellForInvitefriend.h"

@interface TTTAcceptFndrequest ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *ShowFriendRequestList;
    NSOperationQueue *friendListOperation;
    NSTimer *MainTimer;
}
@property (strong, nonatomic) IBOutlet UITableView *friendlistTbl;
@property (strong, nonatomic) IBOutlet UILabel *Friendrequesttext;

@end

@implementation TTTAcceptFndrequest
@synthesize friendlistTbl,Friendrequesttext;
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
    
    ShowFriendRequestList=[[NSMutableArray alloc]init];
    friendListOperation=[[NSOperationQueue alloc]init];
    friendlistTbl.backgroundColor=[UIColor clearColor];
    [SVProgressHUD show];
    [self DomyJob];
    MainTimer= [NSTimer scheduledTimerWithTimeInterval:10.0 target: self
                                                      selector: @selector(DomyJob) userInfo: nil repeats: YES];
    
}
-(void)DomyJob
{
    [ShowFriendRequestList removeAllObjects];
    NSInvocationOperation *Invocation=[[NSInvocationOperation alloc]initWithTarget:self selector:@selector(AcceptFriendrequest) object:nil];
    [friendListOperation addOperation:Invocation];
}

- (IBAction)backButtronTap:(id)sender
{
    [self PerformGoBack];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [ShowFriendRequestList count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 78;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifier=@"TTTCellForInvitefriend";
    
    TTTCellForInvitefriend *cell=(TTTCellForInvitefriend *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    NSMutableDictionary *mutDic=[ShowFriendRequestList objectAtIndex:indexPath.row];
    
    if (cell==nil)
    {
        NSArray *arr=[[NSBundle mainBundle]loadNibNamed:cellIdentifier owner:self options:nil];
        cell=(TTTCellForInvitefriend *)[arr objectAtIndex:0];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
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
    NSString *BackgroundImageStgring=[mutDic valueForKey:@"SENDERIMAGE"];
    
    
    
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
    
    UILabel *name = (UILabel *) [cell.contentView viewWithTag:113];
    name.text =[mutDic valueForKey:@"SENDERNAME"];
    name.font=[UIFont fontWithName:MYRIARDPROSAMIBOLT size:16.0];
    
    UILabel *no_friends = (UILabel *) [cell.contentView viewWithTag:114];
    
    no_friends.text =[NSString stringWithFormat:@"%@ Friends",[mutDic valueForKey:@"FRIENDSCOUNT"]];
    no_friends.font=[UIFont fontWithName:MYRIARDPROLIGHT size:14.0];
    
        UIButton *messAgebtn=(UIButton *) [cell.contentView viewWithTag:115];
        [messAgebtn setBackgroundImage:[UIImage imageNamed:@"tick"] forState:UIControlStateNormal];
        messAgebtn.tag=9999+indexPath.row;
        [messAgebtn addTarget:self action:@selector(Sendmessage:) forControlEvents:UIControlEventTouchUpInside];
        messAgebtn.hidden=YES;
        
        UIButton *Deletbutton=(UIButton *)[cell.contentView viewWithTag:116];
       
        Deletbutton.tag=99999+indexPath.row;
        [Deletbutton addTarget:self action:@selector(Deleteanfrend:) forControlEvents:UIControlEventTouchUpInside];
       
    
    
    
    
    return cell;
    
}

//text field text



-(void)AcceptFriendrequest
{
    if ([self isConnectedToInternet])
    {
        NSError *Error;
        @try
        {
            
            NSString *StringUrl=[NSString stringWithFormat:@"%@user.php?mode=friendrequest&userid=%@",API,[self LoggedId]];
            NSLog(@"Sstrong url:%@",StringUrl);
            NSData *data=[NSData dataWithContentsOfURL:[NSURL URLWithString:StringUrl]];
            NSDictionary *MainDataDic=[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&Error];
            //section loadmore dictionary
                       //section main data dic
            
            if ([[MainDataDic valueForKey:@"REQUEST"] isKindOfClass:[NSArray class]])
            {
                
                NSArray *Friendlist=[MainDataDic valueForKey:@"REQUEST"];
                if (Friendlist.count>0)
                {
                    //Store data in my arry and arry object are dictionary
                    
                    for (NSDictionary *DicSearchlist in Friendlist)
                    {
                        //use nsmutable dic for save temp data
                        
                        NSMutableDictionary *MutDicforfrenddata=[[NSMutableDictionary alloc]init];
                        [MutDicforfrenddata setValue:[self RemoveNullandreplaceWithSpace:[DicSearchlist valueForKey:@"REQUESTID"]] forKey:@"REQUESTID"];
                        [MutDicforfrenddata setValue:[self RemoveNullandreplaceWithSpace:[DicSearchlist valueForKey:@"SENDERID"]] forKey:@"SENDERID"];
                        [MutDicforfrenddata setValue:[self RemoveNullandreplaceWithSpace:[DicSearchlist valueForKey:@"SENDERIMAGE"]] forKey:@"SENDERIMAGE"];
                        [MutDicforfrenddata setValue:[self RemoveNullandreplaceWithSpace:[DicSearchlist valueForKey:@"FRIENDSCOUNT"]] forKey:@"FRIENDSCOUNT"];
                        [MutDicforfrenddata setValue:[self RemoveNullandreplaceWithSpace:[DicSearchlist valueForKey:@"SENDERNAME"]] forKey:@"SENDERNAME"];
                        [MutDicforfrenddata setValue:[self RemoveNullandreplaceWithSpace:[DicSearchlist valueForKey:@"SENDERFRIENDS"]] forKey:@"SENDERFRIENDS"];
                        [ShowFriendRequestList addObject:MutDicforfrenddata];
                        
                    }
                    [self performSelectorOnMainThread:@selector(TablereloadOnadddata) withObject:nil waitUntilDone:YES];
                    
                }
                else
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [SVProgressHUD showErrorWithStatus:@"No friend request found!"];
                    });
                    
                }
                
            }
            else
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [SVProgressHUD showErrorWithStatus:@"No friend request found!"];
                });
                
            }
            
        }
        @catch (NSException *exception)
        {
            NSLog(@"the exception is:%@",exception);
        }
        
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [SVProgressHUD showErrorWithStatus:@"No internet connection"];
            
        });
    }
    
}
-(void)TablereloadOnadddata
{
    [SVProgressHUD dismiss];
    [friendlistTbl reloadData];
}


-(IBAction)Sendmessage:(UIButton *)sender
{
    NSInteger numbor=sender.tag-9999;
    NSMutableDictionary *mutDic=[ShowFriendRequestList objectAtIndex:numbor];
    [ShowFriendRequestList removeObjectAtIndex:numbor];
    [friendlistTbl reloadData];
    NSInvocationOperation *invcation=[[NSInvocationOperation alloc]initWithTarget:self selector:@selector(SendAcceptRequestFor:) object:[mutDic valueForKey:@"REQUESTID"]];
    [friendListOperation addOperation:invcation];
}

-(IBAction)Deleteanfrend:(UIButton *)sender
{
    NSInteger numbor=sender.tag-99999;
    NSMutableDictionary *mutDic=[ShowFriendRequestList objectAtIndex:numbor];
    [ShowFriendRequestList removeObjectAtIndex:numbor];
    [friendlistTbl reloadData];
    NSInvocationOperation *invcation=[[NSInvocationOperation alloc]initWithTarget:self selector:@selector(SendRejectRequestFor:) object:[mutDic valueForKey:@"REQUESTID"]];
    [friendListOperation addOperation:invcation];
}

-(void)SendRejectRequestFor:(NSString *)RequestId
{
    @try
    {
     
        NSError *Error;
        NSURL *URL=[NSURL URLWithString:[NSString stringWithFormat:@"%@user.php?mode=rejectrequest&userid=%@&requestid=%@", API, [self LoggedId], RequestId]];
        NSLog(@"%@", URL);
        NSData *rejectrequest=[NSData dataWithContentsOfURL:URL];
        NSDictionary *rejectDic=[NSJSONSerialization JSONObjectWithData:rejectrequest options:kNilOptions error:&Error];
        NSString *message=[rejectDic valueForKey:@"message"];
        NSString *Responce=[rejectDic valueForKey:@"response"];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if ([Responce isEqualToString:@"success"])
            {
                [SVProgressHUD showSuccessWithStatus:message];
            }
            else
            {
                [SVProgressHUD showErrorWithStatus:message];
            }
            
        });
    }
    @catch (NSException *juju)
    {
        NSLog(@"Reporting juju from SendRejectRequestFor : %@", juju);
    }
}


-(void)SendAcceptRequestFor:(NSString *)RequestId
{
    @try
    {
        NSError *Error;
        NSURL *URL=[NSURL URLWithString:[NSString stringWithFormat:@"%@user.php?mode=approverequest&userid=%@&requestid=%@", API, [self LoggedId], RequestId]];
         NSLog(@"%@", URL);
        NSData *rejectrequest=[NSData dataWithContentsOfURL:URL];
        NSDictionary *rejectDic=[NSJSONSerialization JSONObjectWithData:rejectrequest options:kNilOptions error:&Error];
        NSString *message=[rejectDic valueForKey:@"message"];
        NSString *Responce=[rejectDic valueForKey:@"response"];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if ([Responce isEqualToString:@"success"])
            {
                [SVProgressHUD showSuccessWithStatus:message];
            }
            else
            {
                [SVProgressHUD showErrorWithStatus:message];
            }
            
        });
    }
    @catch (NSException *juju)
    {
        NSLog(@"Reporting juju from SendAcceptRequestFor : %@", juju);
    }
}

//Scrollview functionality
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.tag>0)
    {
        if (scrollView.contentOffset.x>30)
        {
            NSLog(@"the value 1");
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
            NSLog(@"i am in 2");
            
            
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
-(void)viewWillDisappear:(BOOL)animated
{
    [MainTimer invalidate];
    [friendListOperation cancelAllOperations];
}

@end
