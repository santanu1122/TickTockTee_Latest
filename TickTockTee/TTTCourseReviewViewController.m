//
//  TTTCourseReviewViewController.m
//  TickTockTee
//
//  Created by Esolz_Mac on 08/04/14.
//  Copyright (c) 2014 com.esolz.TickTockTee. All rights reserved.
//

#import "TTTCourseReviewViewController.h"
#import "SVProgressHUD.h"
#import "TTTCellForCourseReview.h"
#import "TTTAddReviewViewController.h"
#import "AFImageRequestOperation.h"
#import "TTTCourseDetailsView.h"
@interface TTTCourseReviewViewController (){
 NSOperationQueue *OperationQ;
    CGFloat height;
    NSString *viewerid;
    NSMutableArray *reviewarray;
    
}
@property (strong, nonatomic) IBOutlet UIView *ScreenView;
@property (strong, nonatomic) IBOutlet UILabel *title;
@property (strong, nonatomic) IBOutlet UITableView *reviewlist;
@end

@implementation TTTCourseReviewViewController
@synthesize ScreenView,title,reviewlist,courseid,paramid,reviewarraylist;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
         self=(IsIphone5)?[super initWithNibName:@"TTTCourseReviewViewController" bundle:nil]:[super initWithNibName:@"TTTCourseReviewViewController_iPhone4" bundle:nil];
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    title.font = [UIFont fontWithName:MYREADPROREGULAR size:18.0];
    reviewlist.delegate=self;
    reviewlist.dataSource=self;
    reviewlist.backgroundColor=[UIColor clearColor];
    OperationQ=[[NSOperationQueue alloc]init];
    reviewarray=[[NSMutableArray alloc]init];
    viewerid=(paramid.length>0)?paramid:viewerid;
    height=0.0f;
    [SVProgressHUD show];
    [self showreview];
}
-(void)showreview
{
    NSInvocationOperation *operation=[[NSInvocationOperation alloc]initWithTarget:self selector:@selector(Viewwillall) object:nil];
    [OperationQ addOperation:operation];
    
}

-(void)Viewwillall
{
    NSError *error;
    
    NSString *str=[NSString stringWithFormat:@"%@user.php?mode=coursedetailsreview&userid=%@&courseid=%@",API,[self LoggedId],courseid];
    NSURL *url=[NSURL URLWithString:str];
    NSData *data=[NSData dataWithContentsOfURL:url];
    if (data.length>2)
    {
        NSDictionary *MainDic=[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        NSDictionary *reviewListArry=[MainDic valueForKey:@"reviewlist"];
        for (NSDictionary *ReviewDic in reviewListArry)
        {
            NSMutableDictionary *mutDic=[[NSMutableDictionary alloc]init];
            [mutDic setValue:[ReviewDic valueForKey:@"reviewId"] forKey:@"reviewId"];
            [mutDic setValue:[ReviewDic valueForKey:@"review_user_name"] forKey:@"review_user_name"];
            [mutDic setValue:[ReviewDic valueForKey:@"review_user_rating"] forKey:@"review_user_rating"];
            [mutDic setValue:[ReviewDic valueForKey:@"review_time"] forKey:@"review_time"];
            [mutDic setValue:[ReviewDic valueForKey:@"review"] forKey:@"review"];
            [mutDic setValue:[ReviewDic valueForKey:@"review_provider"] forKey:@"review_provider"];
            [reviewarray addObject:mutDic];
        }
        [self performSelectorOnMainThread:@selector(reloadteble) withObject:nil waitUntilDone:YES];
    }
}

-(void)reloadteble
{
    [SVProgressHUD dismiss];
    [reviewlist reloadData];
}
-(void)getreview:(NSMutableArray *)reviewarr{
    if ([self isConnectedToInternet])
    {
        @try{
              for(NSMutableDictionary *loop in reviewarr)
                {
                  NSMutableDictionary *dicForReview = [[NSMutableDictionary alloc]init];
                                
                  [dicForReview setValue:[self RemoveNullandreplaceWithSpace:[loop objectForKey:@"reviewId"]]forKey:@"reviewId"];
                  [dicForReview setValue:[self RemoveNullandreplaceWithSpace:[loop objectForKey:@"review_user_name"]]forKey:@"review_user_name"];
                  [dicForReview setValue:[self RemoveNullandreplaceWithSpace:[loop objectForKey:@"review_user_rating"]] forKey:@"review_user_rating"];
                  [dicForReview setValue:[self RemoveNullandreplaceWithSpace:[loop objectForKey:@"review_time"]] forKey:@"review_time"];
                  [dicForReview setValue:[self RemoveNullandreplaceWithSpace:[loop objectForKey:@"review"]] forKey:@"review"];
                  [dicForReview setValue:[self RemoveNullandreplaceWithSpace:[loop objectForKey:@"review_provider"]] forKey:@"review_provider"];
                               
                  [reviewarray addObject:dicForReview];
                }
         [self performSelectorOnMainThread:@selector(ReloadTable) withObject:nil waitUntilDone:YES];
                            
        }@catch (NSException *exception) {
            [SVProgressHUD dismiss];
            NSLog(@" %s exception %@",__PRETTY_FUNCTION__,exception);
        }
    }else
    {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:@"No internet connection "];
    }
}

-(void)ReloadTable
{
    [SVProgressHUD dismiss];
    
    [reviewlist reloadData];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [reviewarray count];
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITextView *reviewtxt=[[UITextView alloc]initWithFrame:CGRectMake(15, 70, 295, 30)];
    reviewtxt.font=[UIFont fontWithName:MYRIARDPROLIGHT size:15.0f];
    reviewtxt.textColor=[UIColor whiteColor];
    reviewtxt.textAlignment=NSTextAlignmentLeft;
    [reviewtxt setEditable:NO];
    reviewtxt.text =[NSString stringWithFormat:@"                   %@",[[reviewarray objectAtIndex:indexPath.row]valueForKey:@"review"]];
    // NSAttributedString *Attributed=[[NSAttributedString alloc]initWithString:message.text];
    
    NSAttributedString *Attributed=[[NSAttributedString alloc]initWithString:reviewtxt.text attributes:@{
                                                                                                       
                                                                                                       NSFontAttributeName : [UIFont fontWithName:MYRIARDPROLIGHT size:15.0f],
                                                                                                       NSForegroundColorAttributeName : [UIColor whiteColor]
                                                                                                       }];
    
    
    
    [reviewtxt setAttributedText:Attributed];
    
    CGSize newSize = [reviewtxt sizeThatFits:CGSizeMake(295, MAXFLOAT)];
    CGFloat Extraheight=0.0f;
    if (newSize.height>30)
    {
        CGRect frame=[reviewtxt frame];
        Extraheight=newSize.height-30;
        frame.size.height+=Extraheight;
        [reviewtxt setFrame:frame];
    }
    
    height+=102+Extraheight;
   // NSLog(@"height %f",height);*/
    return 102+Extraheight;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TTTCellForCourseReview *cell=(TTTCellForCourseReview *)[tableView dequeueReusableCellWithIdentifier:nil];
    
    if (cell==nil)
    {
        NSArray *arr=[[NSBundle mainBundle]loadNibNamed:@"TTTCellForCourseReview" owner:self options:nil];
        
        cell=[arr objectAtIndex:0];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    cell.sendername.font=[UIFont fontWithName:MYRIARDPROSAMIBOLT size:18.0];
    
    cell.sendername.text=[[reviewarray objectAtIndex:indexPath.row]valueForKey:@"review_user_name"];
    cell.review.font=[UIFont fontWithName:MYRIARDPROLIGHT size:15.0f];
    cell.time.font=[UIFont fontWithName:MYRIARDPROLIGHT size:13.0f];
    cell.time.text=[[reviewarray objectAtIndex:indexPath.row]valueForKey:@"review_time"];
    [self SetroundborderWithborderWidth:2.0f WithColour:[UIColor whiteColor] ForView:cell.viewOnsenderimage];
    
   
    [self SetroundborderWithborderWidth:2.0f WithColour:[UIColor clearColor] ForImageview:cell.senderimage];
    
    NSString *BackgroundImageStgring=[[reviewarray objectAtIndex:indexPath.row]valueForKey:@"review_provider"];
    
    
    
    NSURLRequest *request_img = [NSURLRequest requestWithURL:[NSURL URLWithString:BackgroundImageStgring]];
    AFImageRequestOperation *operation = [AFImageRequestOperation imageRequestOperationWithRequest:request_img
                                                                              imageProcessingBlock:nil
                                                                                           success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                                                               if(image!=nil)
                                                                                               {
                                                                                                   [cell.senderimage setImage:image];
                                                                                                   [cell.spinner stopAnimating];
                                                                                                   [cell.spinner setHidden:YES];
                                                                                               }
                                                                                               
                                                                                           }
                                                                                           failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                                                                               NSLog(@"Error %@",error);
                                                                                               [cell.spinner stopAnimating];
                                                                                               [cell.spinner setHidden:YES];
                                                                                               
                                                                                               
                                                                                           }];
    [operation start];
    
    
    

    int rating=[[[reviewarray objectAtIndex:indexPath.row]valueForKey:@"review_user_rating"]intValue];
    for(int i=0; i<rating;  i++)
    {
        UIImageView *star=(UIImageView *)[cell.starView viewWithTag:100+i];
        [star setHidden:NO];
    }
    cell.review.textColor=[UIColor whiteColor];
    cell.review.backgroundColor=[UIColor clearColor];
    cell.review.textAlignment=NSTextAlignmentLeft;
    cell.review.delegate=self;
    cell.review.scrollEnabled=NO;
    [cell.review setEditable:NO];
    cell.review.text =[NSString stringWithFormat:@"                   %@",[[reviewarray objectAtIndex:indexPath.row]valueForKey:@"review"]];
    
    NSAttributedString *Attributed=[[NSAttributedString alloc]initWithString:cell.review.text attributes:@{
                                                                                                          NSFontAttributeName :[UIFont fontWithName:MYRIARDPROLIGHT size:15.0f],
                                                                                                          NSForegroundColorAttributeName :[UIColor whiteColor]
                                                                                                          }];
    
    [cell.review setAttributedText:Attributed];
    
    CGSize newSize = [cell.review sizeThatFits:CGSizeMake(295, MAXFLOAT)];
    CGFloat Extraheight=0.0f;
    if (newSize.height>30)
    {
        CGRect frame=[cell.review frame];
        
        Extraheight=newSize.height-30;
        frame.size.height+=Extraheight;
        
        
        [cell.review setFrame:frame];
        cell.review.scrollEnabled=YES;
    }
    // Change the size of cell frame according to the textfield text
  
    CGRect Celframe=[cell.BackView frame];
    Celframe.size.height+=Extraheight;
    [cell.BackView setFrame:Celframe];
    
    return cell;
    
    
}


- (IBAction)postreview:(id)sender
{
    TTTAddReviewViewController *addreview=[[TTTAddReviewViewController alloc]init];
    
    addreview.reviewCourseID=courseid;

    [self PushViewController:addreview TransitationFrom:kCATransitionFade];
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)BackToprivious:(id)sender
{
  
    TTTCourseDetailsView *coursedetails=[[TTTCourseDetailsView alloc]init];
    coursedetails.CourseID=courseid;
    [self PushViewController:coursedetails TransitationFrom:kCATransitionFromBottom];
}
@end
