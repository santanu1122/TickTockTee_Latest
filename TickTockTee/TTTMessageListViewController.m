//
//  TTTMessageListViewController.m
//  TickTockTee
//
//  Created by Esolz Tech on 03/04/14.
//  Copyright (c) 2014 com.esolz.TickTockTee. All rights reserved.
//

#import "TTTMessageListViewController.h"
#import "TTTMessageListCell.h"
#import "SVProgressHUD.h"
#import "AFNetworking.h"
#import "AFImageRequestOperation.h"
#import "TTTCretenewmessage.h"
#import "TTTMessagedetailsViewController.h"
@interface TTTMessageListViewController ()
{
    NSMutableDictionary *GlobalDict;
    NSMutableArray *arrayData;
    NSOperationQueue *Opeartion;
    BOOL IsLeftMenuBoxOpen;
}
@end

@implementation TTTMessageListViewController
@synthesize messageTable,MenuView,screenView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
     [SVProgressHUD show];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    GlobalDict=[[NSMutableDictionary alloc]init];
    arrayData=[[NSMutableArray alloc]init];
    Opeartion=[[NSOperationQueue alloc]init];
    IsLeftMenuBoxOpen=FALSE;
    [self AddLeftMenuTo:MenuView];
    _page_title.font = [UIFont fontWithName:MYREADPROREGULAR size:17.0];
   
    NSInvocationOperation *operationLoadFnd=[[NSInvocationOperation alloc]initWithTarget:self selector:@selector(LoadAlldata) object:nil];
    [Opeartion addOperation:operationLoadFnd];
    messageTable.dataSource=self;
    messageTable.delegate=self;
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)LoadAlldata
{
    if ([self isConnectedToInternet])
    {
        @try
        {
            
            NSString *StringUrl=[NSString stringWithFormat:@"%@user.php?mode=messages&userid=%@",API,[self LoggedId]];
            NSLog(@"The string url:%@",StringUrl);
            NSArray *mainArray;;
            NSData *data=[NSData dataWithContentsOfURL:[NSURL URLWithString:StringUrl]];
            NSDictionary *maindict=[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            mainArray=[maindict objectForKey:@"message"];
            
            
            if ([mainArray count]>0)
            {
                
                
                for(int i=0;i<[mainArray count];i++)
                {
                    NSMutableDictionary *dicForAllFormyarry = [[NSMutableDictionary alloc]init];
                    NSMutableDictionary *objectValue=[mainArray objectAtIndex:i];
                    
                    [dicForAllFormyarry setValue:[objectValue objectForKey:@"id"] forKey:@"id"];
                    [dicForAllFormyarry setValue:[objectValue objectForKey:@"SenderId"] forKey:@"SenderId"];
                    [dicForAllFormyarry setValue:[objectValue objectForKey:@"SenderName"] forKey:@"SenderName"];
                    [dicForAllFormyarry setValue:[objectValue objectForKey:@"SenderImage"] forKey:@"SenderImage"];
                    [dicForAllFormyarry setValue:[objectValue objectForKey:@"subject"] forKey:@"subject"];
                    [dicForAllFormyarry setValue:[objectValue objectForKey:@"message"] forKey:@"message"];
                    [dicForAllFormyarry setValue:[objectValue objectForKey:@"SendDate"] forKey:@"SendDate"];
                    [dicForAllFormyarry setValue:[objectValue objectForKey:@"isunread"] forKey:@"isunread"];
                    NSLog(@"WE are in  send date %@",[objectValue objectForKey:@"SendDate"]);
                    [arrayData addObject:dicForAllFormyarry];
                    
                    
                }
                
                
                [self performSelectorOnMainThread:@selector(ReloadTable) withObject:nil waitUntilDone:YES];
                
            }
            else
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [SVProgressHUD showErrorWithStatus:@"No Messages Found"];
                });
            }
            
        }@catch (NSException *exception)
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
    [messageTable reloadData];
}

#pragma mark UITableViewDelegate and UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
  
    return [arrayData count];
    
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 78;
    
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifier=@"TTTMessageListCell";
    
    TTTMessageListCell *cell=(TTTMessageListCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    NSMutableDictionary *mutDic=[arrayData objectAtIndex:indexPath.row];
    
    if (cell==nil)
    {
        NSArray *arr=[[NSBundle mainBundle]loadNibNamed:cellIdentifier owner:self options:nil];
        cell=(TTTMessageListCell *)[arr objectAtIndex:0];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    
    
    
    UIScrollView *scroll = (UIScrollView *) [cell.contentView viewWithTag:117];
    scroll.contentSize=CGSizeMake(379,77);
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
    NSString *BackgroundImageStgring=[mutDic valueForKey:@"SenderImage"];
    
    
    
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
    name.text =[mutDic valueForKey:@"SenderName"] ;
    name.font=[UIFont fontWithName:MYRIARDPROSAMIBOLT size:15.0];
    //
    UILabel *no_friends = (UILabel *) [cell.contentView viewWithTag:114];
    
    no_friends.text =[NSString stringWithFormat:@"%@",[mutDic valueForKey:@"subject"]];
    no_friends.font=[UIFont fontWithName:MYREADPROREGULAR size:14.0];
    
    UIButton *messAgebtn=(UIButton *) [cell.contentView viewWithTag:115];
    messAgebtn.tag=9999+indexPath.row;
  
    [messAgebtn addTarget:self action:@selector(replyAction:) forControlEvents:UIControlEventTouchUpInside];
    UIButton *Deletbutton=(UIButton *)[cell.contentView viewWithTag:116];
    Deletbutton.tag=99999+indexPath.row;
    [messAgebtn setHidden:YES];
    [Deletbutton addTarget:self action:@selector(DeleteAction:) forControlEvents:UIControlEventTouchUpInside];
    UILabel *timeLabel=(UILabel *) [cell.contentView viewWithTag:160];

    timeLabel.text =[NSString stringWithFormat:@"%@",[mutDic valueForKey:@"SendDate"]];
    timeLabel.font=[UIFont fontWithName:MYRIARDPROLIGHT size:13.0];
    
  

    
    [cell.contentView bringSubviewToFront:scroll];
    return cell;
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return;
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

-(void)gestureAction:(UITapGestureRecognizer *) sender
{
    CGPoint touchLocation = [sender locationOfTouch:0 inView:messageTable];
    NSIndexPath *indexPath = [messageTable indexPathForRowAtPoint:touchLocation];
    
    TTTMessagedetailsViewController *messagedetais=[[TTTMessagedetailsViewController alloc]init];
    
    
    
    NSString *messageid=[[arrayData objectAtIndex:indexPath.row]valueForKey:@"id"];
    
    messagedetais.messageid=messageid;
    
    messagedetais.msgsender_name=[[arrayData objectAtIndex:indexPath.row]valueForKey:@"SenderName"];
    
     [self presentViewController:messagedetais animated:YES completion:^{
        
         [SVProgressHUD dismiss];
        
    }];
    
    
    
}
-(void)replyAction:(UIButton *)btn
{
    
   
    
    int i=btn.tag-9999;
    
    TTTMessagedetailsViewController *messagedetais=[[TTTMessagedetailsViewController alloc]init];
    
    
    
    NSString *messageid=[[arrayData objectAtIndex:i]valueForKey:@"id"];
    
    messagedetais.messageid=messageid;
    
    messagedetais.msgsender_name=[[arrayData objectAtIndex:i]valueForKey:@"SenderName"];
    
    
    
    [self presentViewController:messagedetais animated:YES completion:^{
        
        
        
    }];
}

-(void)DeleteAction:(UIButton *)btn
{
    NSLog(@"Delete clicked");
}


- (IBAction)plusClicked:(id)sender
{
    NSUserDefaults *userdefalds=[NSUserDefaults standardUserDefaults];
    [userdefalds setValue:nil forKey:SESSION_MATCHCREATEPARAMETES];
    [userdefalds setValue:nil forKey:COURSE_ID];
    [userdefalds setValue:nil forKey:COURSE_NAME];
    [userdefalds synchronize];
    
    TTTCretenewmessage *messaAge=[[TTTCretenewmessage alloc]init];
    [self presentViewController:messaAge animated:YES completion:^{
        [SVProgressHUD dismiss];
    }];
}

- (IBAction)backClicked:(id)sender
{

    [self PerformGoBack];
}
@end
