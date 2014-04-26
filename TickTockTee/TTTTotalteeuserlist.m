//
//  TTTTotalteeuserlist.m
//  TickTockTee
//
//  Created by macbook_ms on 23/04/14.
//  Copyright (c) 2014 com.esolz.TickTockTee. All rights reserved.
//

#import "TTTTotalteeuserlist.h"
#import "TTTProfileViewController.h"
#import "SVProgressHUD.h"
#import "TTTCellForTeeduser.h"
#import "AFNetworking.h"
#import "AFImageRequestOperation.h"
#import "TTTProfileViewController.h"

@interface TTTTotalteeuserlist ()<UITableViewDataSource, UITableViewDataSource>
{
    NSMutableArray *TeeUserarray;
    NSOperationQueue *OperationTaguser;
}
@property (strong, nonatomic) IBOutlet UILabel *TeeuserListtxt;
@property (strong, nonatomic) IBOutlet UITableView *TableTaguser;

@end

@implementation TTTTotalteeuserlist
@synthesize ActivityID;
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
    
     TeeUserarray=[[NSMutableArray alloc]init];
     OperationTaguser=[[NSOperationQueue alloc]init];
    self.TableTaguser.delegate=self;
    self.TableTaguser.dataSource=self;
    [self.TableTaguser setBackgroundColor:[UIColor clearColor]];
     [SVProgressHUD show];
     NSInvocationOperation *OperationLoadalltaguser=[[NSInvocationOperation alloc]initWithTarget:self selector:@selector(Totalteeuser) object:nil];
     [OperationTaguser addOperation:OperationLoadalltaguser];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)Totalteeuser
{
    @try
    {
        
        NSString *Str=[NSString stringWithFormat:@"%@user.php?mode=activityteelist&userid=%@&activityid=%@",API,[self LoggedId],ActivityID];
        NSLog(@"The value of string url:%@",Str);
        NSURL *url=[NSURL URLWithString:Str];
        NSData *data=[NSData dataWithContentsOfURL:url];
        if (data.length>2)
        {
            NSDictionary *DicMain=[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            NSArray *taguserArryall=[DicMain objectForKey:@"teelist"];
            if ([taguserArryall count]>0)
            {
                for (NSDictionary *Dictaguser in taguserArryall)
                {
                    NSMutableDictionary *mutDic=[[NSMutableDictionary alloc] init];
                    [mutDic setValue:[Dictaguser valueForKey:@"userid"] forKey:@"userid"];
                    [mutDic setValue:[Dictaguser valueForKey:@"username"] forKey:@"username"];
                    [mutDic setValue:[Dictaguser valueForKey:@"userimage"] forKey:@"userimage"];
                    [TeeUserarray addObject:mutDic];
                    
                }
                
                 [self performSelectorOnMainThread:@selector(reloaddata) withObject:nil waitUntilDone:YES];
            }
            else
            {
               // dispatch_async(dispatch_get_main_queue(), ^{
                      [SVProgressHUD showErrorWithStatus:@"No tag user found!"];
                //});
              
            }
        }
        else
        {
           // dispatch_async(dispatch_get_main_queue(), ^{
                
                [SVProgressHUD showErrorWithStatus:@"Unexpected error occur"];
            //});
          
        }
    }
    @catch (NSException *exception)
    {
        NSLog(@"The exception is:%@ %@",[exception name],exception);
    }

   
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65.0f;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [TeeUserarray count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    static NSString *CellID=@"TTTTotalteeuserlist";
    NSMutableDictionary *mutdicell=[TeeUserarray objectAtIndex:indexPath.row];
    TTTCellForTeeduser *TeeCell=[tableView dequeueReusableCellWithIdentifier:CellID];

    if (TeeCell==nil)
    {
      NSArray *CellNib=[[NSBundle mainBundle] loadNibNamed:@"TTTCellForTeeduser" owner:self options:nil];
      TeeCell=(TTTCellForTeeduser *)[CellNib objectAtIndex:0];
    }
    [TeeCell setBackgroundColor:[UIColor clearColor]];
    UILabel *LableTeeuser=(UILabel *)[TeeCell.contentView viewWithTag:100];
    LableTeeuser.textColor=[UIColor whiteColor];
    LableTeeuser.font=[UIFont fontWithName:MYRIARDPROSAMIBOLT size:15.0f];
    LableTeeuser.text=[mutdicell objectForKey:@"username"];
    UIView *Imageback=(UIView *)[TeeCell.contentView viewWithTag:101];
    UIImageView *userimage=(UIImageView *)[TeeCell.contentView viewWithTag:102];
    [self SetroundborderWithborderWidth:2.0f WithColour:[UIColor whiteColor] ForView:Imageback];
    [self SetroundborderWithborderWidth:0.0f WithColour:[UIColor clearColor] ForImageview:userimage];
    
    //--------------------------- User image download --------------------------------//
    
    NSURLRequest *request_img = [NSURLRequest requestWithURL:[NSURL URLWithString:[mutdicell valueForKey:@"userimage"]]];
    AFImageRequestOperation *operationInvoace = [AFImageRequestOperation imageRequestOperationWithRequest:request_img
                                                                                     imageProcessingBlock:nil
                                                                                                  success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                                                                      if(image!=nil)
                                                                                                      {
                                                                                                          [userimage setImage:image];
                                                                                                      }
                                                                                                      
                                                                                                  }
                                                                                                  failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                                                                                      NSLog(@"Error %@",error);
                                                                                                      
                                                                                                      
                                                                                                      
                                                                                                  }];
    [operationInvoace start];

    
    
    return TeeCell;
    
}

//-------- table Tag user reload -------//


-(void)reloaddata
{
    [self.TableTaguser reloadData];
    [SVProgressHUD dismiss];
}




- (IBAction)performGoback:(id)sender
{
    [self PerformGoBack];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TTTProfileViewController *profile=[[TTTProfileViewController alloc]init];
    profile.ParamprofileViewerId=([[TeeUserarray objectAtIndex:indexPath.row] valueForKey:@"userid"]==[self LoggedId])?nil:[[TeeUserarray objectAtIndex:indexPath.row] valueForKey:@"userid"];
    [self PushViewController:profile TransitationFrom:kCATransitionFade];
}


@end
