//
//  TTTTagesuserViewcontroller.m
//  TickTockTee
//
//  Created by macbook_ms on 01/04/14.
//  Copyright (c) 2014 com.esolz.TickTockTee. All rights reserved.
//

#import "TTTTagesuserViewcontroller.h"
#import "TTTCellFormatchList.h"
#import "SVProgressHUD.h"
#import "AFNetworking.h"
#import "AFImageRequestOperation.h"


@interface TTTTagesuserViewcontroller ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *taguserArry;
    NSString *ViewerId;
    NSOperationQueue *Operation;
}
@property (strong, nonatomic) IBOutlet UILabel *Taguserpage;
@property (strong, nonatomic) IBOutlet UITableView *TbltaguserList;


@end

@implementation TTTTagesuserViewcontroller
@synthesize TbltaguserList,Taguserpage,ParamphotoPhotoID,ParamViewerId;


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
    self.Taguserpage.font=[UIFont fontWithName:MYREADPROREGULAR size:16.0];
    TbltaguserList.delegate=self;
    TbltaguserList.dataSource=self;
    taguserArry=[[NSMutableArray alloc]init];
    TbltaguserList.backgroundColor=[UIColor clearColor];
     ViewerId=([ParamViewerId length]>0)?ParamViewerId:[self LoggedId];
    Operation=[[NSOperationQueue alloc]init];
    [SVProgressHUD show];
    NSInvocationOperation *operatrionTaguser=[[NSInvocationOperation alloc]initWithTarget:self selector:@selector(numboroftaguser) object:nil];
    [Operation addOperation:operatrionTaguser];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)numboroftaguser
 {
     @try
     {

        NSString *Str=[NSString stringWithFormat:@"%@user.php?mode=taglist&userid=%@&loggedin_userid=%@&photoid=%@",API,ViewerId,[self LoggedId],ParamphotoPhotoID];
         NSLog(@"The value of string url:%@",Str);
             NSURL *url=[NSURL URLWithString:Str];
             NSData *data=[NSData dataWithContentsOfURL:url];
             if (data.length>2)
             {
                 NSDictionary *DicMain=[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                 NSArray *taguserArryall=[DicMain objectForKey:@"tagUsers"];
                 if ([taguserArryall count]>0)
                 {
                     for (NSDictionary *Dictaguser in taguserArryall)
                     {
                         NSMutableDictionary *mutDic=[[NSMutableDictionary alloc] init];
                         [mutDic setValue:[Dictaguser valueForKey:@"id"] forKey:@"id"];
                         [mutDic setValue:[Dictaguser valueForKey:@"photoId"] forKey:@"photoId"];
                         [mutDic setValue:[Dictaguser valueForKey:@"userId"] forKey:@"userId"];
                         [mutDic setValue:[Dictaguser valueForKey:@"userName"] forKey:@"userName"];
                         [mutDic setValue:[Dictaguser valueForKey:@"userImage"] forKey:@"userImage"];
                         [taguserArry addObject:mutDic];
                         
                     }
                     
                     [self performSelectorOnMainThread:@selector(reloaddata) withObject:nil waitUntilDone:YES];
                 }
                 else
                 {
                     [SVProgressHUD showErrorWithStatus:@"No tag user found!"];
                 }
             }
             else
             {
                 [SVProgressHUD showErrorWithStatus:@"Unexpected error occur"];
             }
             
     
        
         
     
     }
     @catch (NSException *exception)
     {
         NSLog(@"The exception is:%@",exception);
     }
     
 }
-(void)reloaddata
{
    [SVProgressHUD dismiss];
    [TbltaguserList reloadData];
    
}

- (IBAction)BackbuttonClick:(id)sender
{
   
[self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
//tableview data Source

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [taguserArry count];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    static NSString *CellIdentifire=@"cell";
    NSMutableDictionary *mutDic=[taguserArry objectAtIndex:indexPath.row];
    
    TTTCellFormatchList *Friendcell;
    Friendcell=(TTTCellFormatchList *)[tableView dequeueReusableCellWithIdentifier:CellIdentifire];
    if (Friendcell==nil)
    {
        NSArray *CellNib=[[NSBundle mainBundle] loadNibNamed:@"TTTCellFormatchListcontroller" owner:self options:nil];
        Friendcell=(TTTCellFormatchList *)[CellNib objectAtIndex:1];
    }
    UIView *Mainview=(UIView *)[Friendcell.contentView viewWithTag:50];
    [Mainview setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"row.png"]]];
      [Friendcell setBackgroundColor:[UIColor clearColor]];
    
    UIImageView *FriendImage=(UIImageView *)[Mainview viewWithTag:1];
    [self SetroundborderWithborderWidth:2.0f WithColour:UIColorFromRGB(0xc9c9c9) ForImageview:FriendImage];
    UILabel *FriendName=(UILabel *)[Mainview viewWithTag:2];
    
    FriendName.font=[UIFont fontWithName:@"MyriadPro-Semibold" size:16.0f];
    [FriendName setTextColor:[UIColor whiteColor]];
    FriendName.alpha=1.5;
    FriendName.text=[mutDic valueForKey:@"userName"];
    UIActivityIndicatorView *SpinnerView=(UIActivityIndicatorView *)[Mainview viewWithTag:3];
    //Createing the button
    
    UIButton *FriendButton=(UIButton *)[Mainview viewWithTag:4];
    FriendButton.hidden=YES;
    
    //Set image to imageview
    NSURLRequest *request_img4 = [NSURLRequest requestWithURL:[NSURL URLWithString:[mutDic valueForKey:@"userImage"]]];
    AFImageRequestOperation *operation = [AFImageRequestOperation imageRequestOperationWithRequest:request_img4
                                                                              imageProcessingBlock:nil
                                                                                           success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                                                               if(image!=nil)
                                                                                               {
                                                                                                   
                                                                                                   FriendImage.image=image;
                                                                                                   [SpinnerView stopAnimating];
                                                                                               }
                                                                                               
                                                                                           }
                                                                                           failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error)
                                          {
                                              NSLog(@"The errorcode:%@",error);
                                              [SpinnerView stopAnimating];
                                          }];
    [operation start];

    
    
   
    
    
    return Friendcell;
}


@end
