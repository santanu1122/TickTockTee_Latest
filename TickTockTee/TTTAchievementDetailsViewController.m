//
//  TTTAchievementDetailsViewController.m
//  TickTockTee
//
//  Created by Esolz Tech on 20/03/14.
//  Copyright (c) 2014 com.esolz.TickTockTee. All rights reserved.
//

#import "TTTAchievementDetailsViewController.h"
#import "TTTGlobalViewController.h"
#import "TTTMatchDetails.h"
#import "AFNetworking.h"
#import "AFImageRequestOperation.h"

@interface TTTAchievementDetailsViewController ()<UITableViewDataSource,UITableViewDelegate>{
    UIView *viewxy;
    UIImageView *topBackImage;
    NSMutableArray *arrayContent;
    NSString *title,*details;
    TTTImageDownLoader *ImageDownloader;
    bool ismore;
    NSString *lastid;
    float tableViewHeight;
    NSString *ViewID;
}

@end

@implementation TTTAchievementDetailsViewController
@synthesize achivementDetailTable=_achivementDetailTable;
@synthesize mediumImageView=_mediumImageView;
@synthesize textview=_textview;
@synthesize labelOnImageView=_labelOnImageView;
@synthesize topview=_topview;
@synthesize arrayContent;
@synthesize tag;
@synthesize MainImageView           = _MainImageView;
@synthesize ParamviewAchivementdetails;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self=(IsIphone5)?[super initWithNibName:@"TTTAchievementDetailsViewController" bundle:nil]:[super initWithNibName:@"TTTAchievementDetailsViewController_iPhone4" bundle:nil];
    }
    return self;
}
-(void)getTheData
{
    @try {
        
        __block NSString *str_url;
        if(ismore==NO)
            
            str_url=[NSString stringWithFormat:@"%@user.php?mode=achivementdetails&userid=%@&loggedin_userid=%@&achivement_id=%@",API,ViewID,[self LoggedId],[NSString stringWithFormat:@"%d",tag]];
        
        else
            
            str_url=[NSString stringWithFormat:@"%@user.php?mode=achivementdetails&userid=%@&loggedin_userid=%@&achivement_id=%@&lastid=%@",API,ViewID,[self LoggedId],[NSString stringWithFormat:@"%d",tag],lastid];
        NSLog(@"str_url ----- %@",str_url);
        
        NSURL *fire_url=[NSURL URLWithString:str_url];
        
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
            NSError *err=nil;
            NSData* data = [NSData dataWithContentsOfURL:fire_url options:0 error:&err];
            
            
            dispatch_async(dispatch_get_main_queue(), ^(void)
            {
                NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data  options:kNilOptions error:nil];
                [_labelOnImageView setText:[dict objectForKey:@"Title"]];
                [_textview setText:[dict objectForKey:@"Details"]];
                ismore=[[[dict objectForKey:@"extraparam"]objectForKey:@"moredata"]isEqualToString:@"1"]?YES:NO;
                lastid=[[dict objectForKey:@"extraparam"]objectForKey:@"last_id"];
                
                UIActivityIndicatorView *Indi = (UIActivityIndicatorView *)[self.view viewWithTag:9944];
                UIImageView *Cellimage=(UIImageView *)[self.view viewWithTag:9943];
                [self SetroundborderWithborderWidth:2.0f WithColour:[UIColor whiteColor] ForImageview:Cellimage];
                [Indi startAnimating];
                NSURLRequest *request_img = [NSURLRequest requestWithURL:[NSURL URLWithString:[dict objectForKey:@"Image"]]];
              
                AFImageRequestOperation *operation = [AFImageRequestOperation imageRequestOperationWithRequest:request_img
                                                                                          imageProcessingBlock:nil
                                                                                                       success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                                                                           if(image!=nil)
                                                                                                           {
                                                                                                               
                                                                                                               [Cellimage setImage:image];
                                                                                                             
                                                                                                               [Indi stopAnimating];
                                                                                                               [Indi hidesWhenStopped];
                                                                                                               
                                                                                                           }
                                                                                                           
                                                                                                       }
                                                                                                       failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                                                                                          
                                                                                                           
                                                                                                       }];
                [operation start];
                
                
                if ([[dict objectForKey:@"achievementdetailslist"] count] > 0) {
                    
                    for (NSDictionary *Datadic in [dict objectForKey:@"achievementdetailslist"])
                    {
                        
                      
                        
                        NSMutableDictionary *TempDic = [[NSMutableDictionary alloc] init];
                        [TempDic setObject:[Datadic objectForKey:@"MatchId"] forKey:@"MatchId"];
                        [TempDic setObject:[Datadic objectForKey:@"MatchTitle"] forKey:@"MatchTitle"];
                        [TempDic setObject:[Datadic objectForKey:@"achivementdate"] forKey:@"achivementdate"];
                        [TempDic setObject:[Datadic objectForKey:@"MatchImage"] forKey:@"MatchImage"];
                        
                        
                        [arrayContent addObject:TempDic];
                        
                        [_achivementDetailTable setHidden:NO];
                        [_achivementDetailTable reloadData];
                        
                    }
                    
                   
                }
                
                
            });
        });
    }
    @catch (NSException *exception) {
        
    }
 
    
}
-(void)ImageDownLoadComplete:(TTTImageDownLoader *)ImageDownloader ImageData:(NSData *)ParamImageData ImageViewtag:(int)ParamImageViewTag ImageLoaderTag:(int)ParamImageLoaderTag
{
    
    UIImageView *ImageView = (UIImageView *)[self.view viewWithTag:9943];
    UIActivityIndicatorView *ActivityIndi  = (UIActivityIndicatorView *)[self.view viewWithTag:9944];
    [ImageView setImage:[UIImage imageWithData:ParamImageData]];
    [ImageView.layer setBorderColor: [[UIColor whiteColor] CGColor]];
    ImageView.layer.masksToBounds = YES;
    [ImageView.layer setBorderWidth: 1.5f];
    [ImageView.layer setOpacity:0.8f];
    if (ImageView.tag == 9943)
    {
        [ImageView.layer setCornerRadius:60.0f];
        [ActivityIndi stopAnimating];
    }
    else
    {
        [ImageView.layer setCornerRadius:15.0f];
    }
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    ViewID=([ParamviewAchivementdetails length]>0)?ParamviewAchivementdetails:[self LoggedId];
    ImageDownloader = [[TTTImageDownLoader alloc] init];
   
    lastid=[[NSString alloc]init];
    
    ismore=NO;
    
    arrayContent=[[NSMutableArray alloc]init];
    topBackImage=[[UIImageView alloc]initWithFrame:CGRectMake(_topview.bounds.origin.x, _topview.bounds.origin.y, _topview.bounds.size.width, _topview.bounds.size.height+2)];
    topBackImage.image=[UIImage imageNamed:@"topbar-1"];
    [self.view addSubview:topBackImage];
    [self.view sendSubviewToBack:topBackImage];
    
    _textview.editable=NO;
    _textview.textColor=[UIColor whiteColor];
    _textview.backgroundColor=[UIColor clearColor];
    _textview.font=[UIFont fontWithName:MYRIARDPROLIGHT size:15];
    
    
    _labelOnImageView.textColor=[UIColor whiteColor];
    _labelOnImageView.backgroundColor=[UIColor clearColor];
    _labelOnImageView.font=[UIFont fontWithName:MYRIARDPROSAMIBOLT size:21];
    
    _labelOnImageView.textColor=[UIColor whiteColor];
    _textview.textColor=[UIColor whiteColor];
    
    [self.view bringSubviewToFront:_labelOnImageView];
    [self.view bringSubviewToFront:_textview];
    
    UIImageView *viewimagelarge=[[UIImageView alloc]initWithFrame:self.view.frame];
    viewimagelarge.image=[UIImage imageNamed:@"bgAchievement"];
    [self.view addSubview:viewimagelarge];
    [self.view sendSubviewToBack:viewimagelarge];
    
    _achivementDetailTable.dataSource=self;
    _achivementDetailTable.delegate=self;
    
    [_achivementDetailTable setHidden:YES];
    
    
    viewxy=[[UIView alloc]initWithFrame:CGRectMake(_mediumImageView.frame.origin.x,_mediumImageView.frame.origin.y,_mediumImageView.frame.size.width,_mediumImageView.frame.size.height-61)];
    viewxy.backgroundColor=[[UIColor blackColor]colorWithAlphaComponent:0.7f];
    [_mediumImageView addSubview:viewxy];
    [self getTheData];
    
    //viewxy.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark uitableviewdatasource
-(int)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [arrayContent count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    static NSString *cellidentifier=@"cellachivement";
    cell = [tableView dequeueReusableCellWithIdentifier:cellidentifier];
    
    if(cell==nil){
        NSArray *nibviews=[[NSBundle mainBundle]loadNibNamed:@"AchivementDetailsCell" owner:self options:nil];
        cell=[nibviews objectAtIndex:0];
    }
    
    NSDictionary *dict=[arrayContent objectAtIndex:indexPath.row];
    
    UIImageView *CellImage = [[UIImageView alloc] initWithFrame:CGRectMake(15, 8, 41, 41)];
    
    [self SetroundborderWithborderWidth:2.0f WithColour:[UIColor whiteColor] ForImageview:CellImage];
    NSURLRequest *request_img = [NSURLRequest requestWithURL:[NSURL URLWithString:[dict objectForKey:@"MatchImage"]]];
  
    AFImageRequestOperation *operation = [AFImageRequestOperation imageRequestOperationWithRequest:request_img
                                                                              imageProcessingBlock:nil
                                                                                           success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                                                               if(image!=nil)
                                                                                               {
                                                                                                   
                                                                                                   [CellImage setImage:image];
                                                                                                  
                                                                                                   
                                                                                            }
                                                                                               
                                                                                           }
                                                                                           failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                                                                              
                                                                                               
                                                                                           }];
    [operation start];
    
    [cell.contentView addSubview:CellImage];
    
    
    
  
    
    UILabel *lab1=(UILabel *)[cell.contentView viewWithTag:1];
    lab1.font=[UIFont fontWithName:MYRIARDPROSAMIBOLT size:15];
    UILabel *lab2=(UILabel *)[cell.contentView viewWithTag:2];
    lab2.font=[UIFont fontWithName:SEGIOUI size:13];
    
    lab2.text=[dict objectForKey:@"achivementdate"];
    lab1.text=[dict objectForKey:@"MatchTitle"];
    
    
    
     cell.backgroundColor=[UIColor clearColor];
     cell.accessoryView = [[ UIImageView alloc ] initWithImage:[UIImage imageNamed:@"forword-arrow"]];
    [cell.accessoryView setFrame:CGRectMake(0, 0, 35, 35)];
   
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (IBAction)backFunction:(id)sender {
    [self PerformGoBack];
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *selectedCell=[tableView cellForRowAtIndexPath:indexPath];
    
    selectedCell.contentView.backgroundColor = [UIColor clearColor];
    
    NSMutableDictionary *dicttemp1=[[NSMutableDictionary alloc]init];
    
    dicttemp1=[arrayContent objectAtIndex:indexPath.row];
    
    TTTMatchDetails *matchdetais=[[TTTMatchDetails alloc]init];
    
    matchdetais.matchID=[dicttemp1 valueForKey:@"MatchId"];
    matchdetais.ParamViewerID=ParamviewAchivementdetails;
    
    [self.navigationController pushViewController:matchdetais animated:YES];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    if(ismore==YES){
        CGPoint offset = scrollView.contentOffset;
        CGRect bounds = scrollView.bounds;
        CGSize size = scrollView.contentSize;
        UIEdgeInsets inset = scrollView.contentInset;
        float y = offset.y + bounds.size.height - inset.bottom;
        float h = size.height;
        
        float reload_distance = -60.0f;
        if(y > h + reload_distance){
            [self getTheData];
        }
    }
    
}

@end
