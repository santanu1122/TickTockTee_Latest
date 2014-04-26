//
//  TTTFollowerlistviewController.m
//  TickTockTee
//
//  Created by macbook_ms on 11/04/14.
//  Copyright (c) 2014 com.esolz.TickTockTee. All rights reserved.
//

#import "TTTFollowerlistviewController.h"
#import "TTTCellForfollowerList.h"
#import "AFNetworking.h"
#import "AFJSONRequestOperation.h"
#import "TTTProfileViewController.h"

@interface TTTFollowerlistviewController ()<UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *RevierList;
    NSOperationQueue *operation;
}
@property (strong, nonatomic) IBOutlet UITableView *TblFollowerList;

@end

@implementation TTTFollowerlistviewController
@synthesize TblFollowerList,CourseREviewID;

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
    TblFollowerList.dataSource=self;
    TblFollowerList.delegate=self;
    RevierList=[[NSMutableArray alloc]init];
    operation=[[NSOperationQueue alloc]init];
    [TblFollowerList setBackgroundColor:[UIColor clearColor]];
    [SVProgressHUD show];
     NSInvocationOperation *Stringinvo=[[NSInvocationOperation alloc]initWithTarget:self selector:@selector(Shoemeallfriendlist) object:nil];
    [operation addOperation:Stringinvo];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 77.0f;
}

-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [RevierList count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TTTCellForfollowerList *cell;//=(TTTCellForInvitefriend *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    NSMutableDictionary *mutdic=[RevierList objectAtIndex:indexPath.row];
    NSArray *arr=[[NSBundle mainBundle]loadNibNamed:@"TTTCellForfollowerList" owner:self options:nil];
    cell=(TTTCellForfollowerList *)[arr objectAtIndex:0];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.backgroundColor=[UIColor clearColor];
    UIImageView *profileImage = (UIImageView *) [cell.contentView viewWithTag:112];
    [self setRoundBorderToImageView:profileImage];
    UIActivityIndicatorView *spinner=(UIActivityIndicatorView *)[cell.contentView viewWithTag:200];
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureAction:)];
    [recognizer setNumberOfTapsRequired:1];
   
    NSString *BackgroundImageStgring=[mutdic valueForKey:@"followers_image"];
    
    
    
    NSURLRequest *request_img = [NSURLRequest requestWithURL:[NSURL URLWithString:BackgroundImageStgring]];
    AFImageRequestOperation *operationInvoace = [AFImageRequestOperation imageRequestOperationWithRequest:request_img
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
    [operationInvoace start];
    UIView *myview=(UIView *)[cell.contentView viewWithTag:111];
    [self SetroundborderWithborderWidth:2.0f WithColour:[UIColor whiteColor] ForView:myview];
    
    UILabel *name = (UILabel *) [cell.contentView viewWithTag:113];
    name.text =[mutdic valueForKey:@"followers_name"] ;
    name.font=[UIFont fontWithName:MYRIARDPROSAMIBOLT size:16.0];
    
    UILabel *no_friends = (UILabel *) [cell.contentView viewWithTag:114];
    
    no_friends.text =[NSString stringWithFormat:@"%@ Friends",[mutdic valueForKey:@"followers_friendcount"]];
    no_friends.font=[UIFont fontWithName:MYRIARDPROLIGHT size:14.0];

    return cell;
    

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"call theis methos");
    TTTProfileViewController *profileView=[[TTTProfileViewController alloc]init];
    profileView.ParamprofileViewerId=[[RevierList objectAtIndex:indexPath.row] valueForKey:@"followers_id"];
    profileView.mainLabelString=[[RevierList objectAtIndex:indexPath.row] valueForKey:@"followers_name"];
    [self PushViewController:profileView WithAnimation:kCATransitionFade];
    
}

-(void)Shoemeallfriendlist
{
    if ([self isConnectedToInternet])
    {
        @try
        {
            NSError *error;
            NSString *stringUrl=[NSString stringWithFormat:@"%@user.php?mode=coursefollowersdetails&userid=%@&courseid=%@",API,[self LoggedId],CourseREviewID];
            NSData *dataurl=[NSData dataWithContentsOfURL:[NSURL URLWithString:stringUrl]];
            NSDictionary *mainDic=[NSJSONSerialization JSONObjectWithData:dataurl options:kNilOptions error:&error];
            if ([[mainDic valueForKey:@"followerslist"] isKindOfClass:[NSArray class]])
            {
                NSArray *arryuser=[mainDic valueForKey:@"followerslist"];
                for (NSDictionary *Dicmain in arryuser)
                {
                    NSMutableDictionary *muttabledic=[[NSMutableDictionary alloc]init];
                    [muttabledic setValue:[Dicmain valueForKey:@"id"] forKey:@"id"];
                    [muttabledic setValue:[Dicmain valueForKey:@"followers_id"] forKey:@"followers_id"];
                    [muttabledic setValue:[Dicmain valueForKey:@"followers_image"] forKey:@"followers_image"];
                    [muttabledic setValue:[Dicmain valueForKey:@"followers_name"] forKey:@"followers_name"];
                    [muttabledic setValue:[Dicmain valueForKey:@"followers_status"] forKey:@"followers_status"];
                    [muttabledic setValue:[Dicmain valueForKey:@"followers_friendcount"] forKey:@"followers_friendcount"];
                    [RevierList addObject:muttabledic];
                }
                [self performSelectorOnMainThread:@selector(Reloadid) withObject:nil waitUntilDone:YES];
                
            }
        }
        @catch (NSException *exception)
        {
            NSLog(@"I am getting this error man:%@",exception);
        }
       
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [SVProgressHUD showErrorWithStatus:@"No internet connection"];
            
        });
    }
}
- (IBAction)backbuttonclick:(id)sender
{
//    [self dismissViewControllerAnimated:YES completion:^{
//        
//    }];
    [self PerformGoBack];
}

-(void)Reloadid
{
    [SVProgressHUD dismiss];
    [TblFollowerList reloadData];
}

@end
