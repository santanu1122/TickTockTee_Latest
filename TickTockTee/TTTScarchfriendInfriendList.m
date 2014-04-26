//
//  TTTScarchfriendInfriendList.m
//  TickTockTee
//
//  Created by macbook_ms on 03/04/14.
//  Copyright (c) 2014 com.esolz.TickTockTee. All rights reserved.
//

#import "TTTScarchfriendInfriendList.h"
#import "SVProgressHUD.h"
#import "TTTCellForInvitefriend.h"
#import "AFNetworking.h"
#import "AFImageRequestOperation.h"
#import "TTTProfileViewController.h"
#import "TTTProfileViewController.h"
#import "TTTGlobalMethods.h"
#import "TTTCretenewmessage.h"

@interface TTTScarchfriendInfriendList ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    NSMutableArray *scarchListArry;
    NSString *Viewerid;
    NSString *LastId;
    NSString *moredata;
    NSOperationQueue *OperationSearch;
    NSInteger numbor;
    TTTGlobalMethods *method;
    
}
@property (strong, nonatomic) IBOutlet UITextField *Searchtxtfield;
@property (strong, nonatomic) IBOutlet UILabel *SearchFndtxtlbl;

@end

@implementation TTTScarchfriendInfriendList
@synthesize SearchListTbl,SearchFndtxtlbl,Searchtxtfield;

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
    // Do any additional setup after loading the view from its nib.
    SearchListTbl.delegate=self;
    SearchListTbl.dataSource=self;
    scarchListArry=[[NSMutableArray alloc]init];
    [SearchListTbl setBackgroundColor:[UIColor clearColor]];
    [SearchFndtxtlbl setFont:[UIFont fontWithName:MYREADPROREGULAR size:17.0f]];
    method=[[TTTGlobalMethods alloc]init];
    [self.Searchtxtfield setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.Searchtxtfield setFont:[UIFont fontWithName:MYREADPROREGULAR size:16.0f]];
     OperationSearch=[[NSOperationQueue alloc]init];
    
    
}



- (void)didReceiveMemoryWarning
 {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
 }

- (IBAction)BackButtonclick:(id)sender
{
    [self PerformGoBack];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [scarchListArry count];
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 78;
    
}


//Method For Searching a user

-(void)Searchmyfriend
{
    if ([self isConnectedToInternet])
    {
        NSError *Error;
        @try
        {
            [scarchListArry removeAllObjects];
            NSString *StringUrl=[NSString stringWithFormat:@"%@user.php?mode=friendssearch&userid=%@&loggedin_userid=%@&search=%@",API,[self LoggedId],[self LoggedId],[method Encoder:Searchtxtfield.text]];
            NSLog(@"Sstrong url:%@",StringUrl);
            NSData *data=[NSData dataWithContentsOfURL:[NSURL URLWithString:StringUrl]];
            NSDictionary *MainDataDic=[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&Error];
            //section loadmore dictionary
            
            if ([[MainDataDic valueForKey:@"extraparam"] isKindOfClass:[NSDictionary class]])
            {
                NSDictionary *Extraparm=[MainDataDic valueForKey:@"extraparam"];
                LastId=[Extraparm valueForKey:@"lastid"];
                moredata=[Extraparm valueForKey:@"moredata"];
            }
            else
            {
                moredata=@"0";
            }
           //section main data dic
            
            if ([[MainDataDic valueForKey:@"friendslist"] isKindOfClass:[NSArray class]])
            {
               
                NSArray *Friendlist=[MainDataDic valueForKey:@"friendslist"];
                if (Friendlist.count>0)
                {
                   //Store data in my arry and arry object are dictionary
                   
                    for (NSDictionary *DicSearchlist in Friendlist)
                    {
                        //use nsmutable dic for save temp data
                        
                        NSMutableDictionary *MutDicforfrenddata=[[NSMutableDictionary alloc]init];
                         [MutDicforfrenddata setValue:[self RemoveNullandreplaceWithSpace:[DicSearchlist valueForKey:@"id"]] forKey:@"id"];
                         [MutDicforfrenddata setValue:[self RemoveNullandreplaceWithSpace:[DicSearchlist valueForKey:@"name"]] forKey:@"name"];
                         [MutDicforfrenddata setValue:[self RemoveNullandreplaceWithSpace:[DicSearchlist valueForKey:@"email"]] forKey:@"email"];
                         [MutDicforfrenddata setValue:[self RemoveNullandreplaceWithSpace:[DicSearchlist valueForKey:@"image"]] forKey:@"image"];
                         [MutDicforfrenddata setValue:[self RemoveNullandreplaceWithSpace:[DicSearchlist valueForKey:@"totalfriends"]] forKey:@"totalfriends"];
                         [MutDicforfrenddata setValue:[self RemoveNullandreplaceWithSpace:[DicSearchlist valueForKey:@"isfriend"]] forKey:@"isfriend"];
                         [scarchListArry addObject:MutDicforfrenddata];
                        
                    }
                    [self performSelectorOnMainThread:@selector(Tablereload) withObject:nil waitUntilDone:YES];
                    
                }
                else
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                         [SVProgressHUD showErrorWithStatus:@"No search result found!"];
                    });
                   
                }
                
            }
            else
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [SVProgressHUD showErrorWithStatus:@"No search result found!"];
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
-(void)Tablereload
{
    [SVProgressHUD dismiss];
    [SearchListTbl reloadData];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
 {
    
    static NSString *cellIdentifier=@"TTTCellForInvitefriend";
    
    TTTCellForInvitefriend *cell=(TTTCellForInvitefriend *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    NSMutableDictionary *mutDic=[scarchListArry objectAtIndex:indexPath.row];
    
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
    NSString *BackgroundImageStgring=[mutDic valueForKey:@"image"];
    
    
    
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
    name.text =[mutDic valueForKey:@"name"] ;
    name.font=[UIFont fontWithName:MYRIARDPROSAMIBOLT size:16.0];

    UILabel *no_friends = (UILabel *) [cell.contentView viewWithTag:114];
    
    no_friends.text =[NSString stringWithFormat:@"%@ Friends",[mutDic valueForKey:@"totalfriends"]];
    no_friends.font=[UIFont fontWithName:MYRIARDPROLIGHT size:14.0];
     
    if ([[mutDic valueForKey:@"isfriend"] integerValue]==0)
    {
        UIButton *messAgebtn=(UIButton *) [cell.contentView viewWithTag:115];
        [messAgebtn setBackgroundImage:[UIImage imageNamed:@"messageSearch_friend"] forState:UIControlStateNormal];
        messAgebtn.tag=9999+indexPath.row;
        [messAgebtn addTarget:self action:@selector(Sendmessage:) forControlEvents:UIControlEventTouchUpInside];
         messAgebtn.hidden=YES;
        
        UIButton *Deletbutton=(UIButton *)[cell.contentView viewWithTag:116];
        [Deletbutton setBackgroundImage:[UIImage imageNamed:@"plussearech_friend"] forState:UIControlStateNormal];
        Deletbutton.tag=99999+indexPath.row;
        [Deletbutton addTarget:self action:@selector(Addfriend:) forControlEvents:UIControlEventTouchUpInside];
    }
    else
    {
        UIButton *messAgebtn=(UIButton *) [cell.contentView viewWithTag:115];
        [messAgebtn setBackgroundImage:nil forState:UIControlStateNormal];
        messAgebtn.tag=9999+indexPath.row;
        [messAgebtn addTarget:self action:@selector(Sendmessage:) forControlEvents:UIControlEventTouchUpInside];
        messAgebtn.hidden=YES;
        
        UIButton *Deletbutton=(UIButton *)[cell.contentView viewWithTag:116];
        [Deletbutton setBackgroundImage:[UIImage imageNamed:@"messageSearch_friend"] forState:UIControlStateNormal];
         Deletbutton.tag=99999+indexPath.row;
        [Deletbutton addTarget:self action:@selector(Addfriend:) forControlEvents:UIControlEventTouchUpInside];
    }
    
return cell;
    
}

-(void)gestureAction:(UITapGestureRecognizer *) sender
{
    CGPoint touchLocation = [sender locationOfTouch:0 inView:SearchListTbl];
    NSIndexPath *indexPath = [SearchListTbl indexPathForRowAtPoint:touchLocation];
    NSMutableDictionary *mutablDic=[scarchListArry objectAtIndex:indexPath.row];
    TTTProfileViewController *ProfileView=[[TTTProfileViewController alloc]init];
    ProfileView.ParamprofileViewerId=[mutablDic valueForKey:@"id"];
    [self PushViewController:ProfileView TransitationFrom:kCATransitionFade];
    
    
}


-(IBAction)Sendmessage:(UIButton *)sender
 {
     numbor=sender.tag-9999;
     NSUserDefaults *userdefalds=[NSUserDefaults standardUserDefaults];
     [userdefalds setValue:nil forKey:SESSION_MATCHCREATEPARAMETES];
     [userdefalds setValue:nil forKey:COURSE_ID];
     [userdefalds setValue:nil forKey:COURSE_NAME];
     [userdefalds synchronize];

     NSMutableDictionary *mutDic=[scarchListArry objectAtIndex:numbor];
       NSString *fndId=[mutDic valueForKey:@"id"];
     
     if ([[mutDic valueForKey:@"isfriend"] integerValue]==0)
     {
         TTTCretenewmessage *messageViewcontroller=[[TTTCretenewmessage alloc]init];
         messageViewcontroller.MessageSenderid=fndId;
         messageViewcontroller.friendName=[mutDic valueForKey:@"name"];
         messageViewcontroller.Friendimageurl=[mutDic valueForKey:@"image"];
         [self presentViewController:messageViewcontroller animated:YES completion:^{
             
         }];
 
     }
     
 }

-(IBAction)Addfriend:(UIButton *)sender
{
    numbor=sender.tag-99999;
    NSMutableDictionary *mutDic=[scarchListArry objectAtIndex:numbor];
    NSString *fndId=[mutDic valueForKey:@"id"];
    if ([[mutDic valueForKey:@"isfriend"] integerValue]==0)
    {
         NSInvocationOperation *friendrequest=[[NSInvocationOperation alloc]initWithTarget:self selector:@selector(SentFriendrequest:) object:fndId];
        [OperationSearch addOperation:friendrequest];
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
        messageViewcontroller.friendName=[mutDic valueForKey:@"name"];
        messageViewcontroller.Friendimageurl=[mutDic valueForKey:@"image"];

        [self presentViewController:messageViewcontroller animated:YES completion:^{
            
        }];
    }
    

}
-(void)SentFriendrequest:(NSString *)FriendID
{
    NSError *Error;
    if ([self isConnectedToInternet])
    {
        @try
        {
            NSString *StringUrl=[NSString stringWithFormat:@"%@user.php?mode=addfriendrequest&userid=%@&friendid=%@",API,[self LoggedId],FriendID];
            NSData *Data=[NSData dataWithContentsOfURL:[NSURL URLWithString:StringUrl]];
            NSDictionary *mainDic=[NSJSONSerialization JSONObjectWithData:Data options:kNilOptions error:&Error];
            NSString *messAge=[mainDic valueForKey:@"message"];
            NSString *Responce=[mainDic valueForKey:@"status"];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([Responce isEqualToString:@"error"])
                {
                     [SVProgressHUD showErrorWithStatus:messAge];
                }
                else
                {
                    NSMutableDictionary *mutDic=[scarchListArry objectAtIndex:numbor];
                    [mutDic setValue:@"0" forKey:@"isfriend"];
                    [scarchListArry removeObjectAtIndex:numbor];
                    [scarchListArry insertObject:mutDic atIndex:numbor];
                    NSIndexPath *indexpath=[NSIndexPath indexPathForRow:numbor inSection:0];
                    
                    
                    [SearchListTbl beginUpdates];
                    [SearchListTbl reloadRowsAtIndexPaths:[[NSArray alloc] initWithObjects:indexpath, nil] withRowAnimation:UITableViewRowAnimationNone];
                    [SearchListTbl endUpdates];
                    [SVProgressHUD showSuccessWithStatus:messAge];
                }
               
            });

            
            
        }
        @catch (NSException *exception)
        {
            NSLog(@"the exception is:%@",exception);
        }
        
        }
    else
    {
        [SVProgressHUD showErrorWithStatus:@"No internet connection"];
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


- (IBAction)SearchButtonclick:(id)sender
{
    [SVProgressHUD show];
    NSInvocationOperation *operationSearch=[[NSInvocationOperation alloc] initWithTarget:self selector:@selector(Searchmyfriend) object:nil];
    [OperationSearch addOperation:operationSearch];
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [SVProgressHUD show];
    NSInvocationOperation *operationSearch=[[NSInvocationOperation alloc] initWithTarget:self selector:@selector(Searchmyfriend) object:nil];
    [OperationSearch addOperation:operationSearch];
    return YES;
}
-(void)viewDidDisappear:(BOOL)animated
{
    [OperationSearch cancelAllOperations];
}

@end
