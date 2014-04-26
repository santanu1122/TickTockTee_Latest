//
//  TTTCourseListViewController.m
//  TickTockTee
//
//  Created by Esolz Tech on 07/04/14.
//  Copyright (c) 2014 com.esolz.TickTockTee. All rights reserved.
//

#import "TTTCourseListViewController.h"
#import "TTTCourseListCell.h"
#import "AFNetworking.h"
#import "AFImageRequestOperation.h"
#import "SVProgressHUD.h"
#import "TTTCourseDetailsView.h"

@interface TTTCourseListViewController ()<UITableViewDataSource,UITableViewDelegate,NSURLConnectionDelegate,UITextFieldDelegate>
{
    BOOL IsLeftMenuBoxOpen,isEditing,Ishoveropen,ISMoreData,ISsearched,ISLastContent;
    NSMutableData *staticData;
    NSArray *arr;
    int i,count;
    NSString *lastId,*searchText;
    
    BOOL islastlocation;
    BOOL isFastLocation;
    BOOL ISSearchOpen,IfSearchViewopen;
    
}
@property (strong, nonatomic) IBOutlet UILabel *courseLabel;
@property (strong, nonatomic) IBOutlet UITableView *courseTable;
@property (strong, nonatomic) IBOutlet UIView *searchPopup;
@property (strong, nonatomic) IBOutlet UIView *MenuAppear;
@property (strong, nonatomic) IBOutlet UIImageView *arrowimage;
@property (strong, nonatomic) IBOutlet UITextField *Searchtextfield;
@property (strong, nonatomic) IBOutlet UIView *Searchview;
@property (strong, nonatomic) IBOutlet UIImageView *searchIconPng;


- (IBAction)SearchButtonClicked:(id)sender;

@end

@implementation TTTCourseListViewController
@synthesize tableContent,courseTable,searchPopup;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    Ishoveropen=FALSE;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    Ishoveropen=FALSE;
    isEditing=NO;
    ISsearched=NO;
    ISMoreData=YES;
    IsLeftMenuBoxOpen=FALSE;
    ISLastContent=YES;
    count=0;
    IfSearchViewopen=FALSE;
    tableContent=[[NSMutableArray alloc]init];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    self.navigationController.navigationBar.hidden=YES;
    [self.navigationController.navigationBar setBackgroundColor:[UIColor whiteColor]];
    [self AddLeftMenuTo:_menuView];
    
    arr=[[NSArray alloc]initWithObjects:@"My Course",@"All Course", nil];
    _courseLabel.text=[NSString stringWithFormat:@"%@",[arr objectAtIndex:0]];
    [SVProgressHUD show];
    NSString *stringurl = [NSString stringWithFormat:@"%@user.php?mode=mycourses&userid=%@&loggedin_userid=%@", API,[self LoggedId],[self LoggedId]];
    NSLog(@"stringurl---%@",stringurl);
    NSURL *url = [NSURL URLWithString:stringurl];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:req delegate:self];
    if (connection)
    {
        staticData = [[NSMutableData alloc]init];
    }
    courseTable.dataSource=self;
    courseTable.delegate=self;
    courseTable.separatorStyle=UITableViewCellSeparatorStyleNone;
    [courseTable setShowsVerticalScrollIndicator:NO];
    
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panDetected:)];
    panRecognizer.delegate=self;
    [self.screenView addGestureRecognizer:panRecognizer];
    
}
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    staticData.length=0;
    
}


-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [staticData appendData:data];
}


-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
   [self.view setUserInteractionEnabled:YES];
    NSLog(@"Failed with Error---");
}


-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    @try{
    NSDictionary *arrx = [NSJSONSerialization JSONObjectWithData:staticData options:0 error:nil];
    ISMoreData=[[[arrx objectForKey:@"extraparam"]objectForKey:@"moredata"]isEqualToString:@"1"]?YES:NO;

    if((ISMoreData==YES||ISLastContent==YES)/*&&count>0*/){
        NSMutableArray *arrr=[[NSMutableArray alloc]init];
        arrr=[arrx objectForKey:@"courselist"];
        [tableContent addObjectsFromArray:arrr];
        ISLastContent=YES;

        
        }

    else if(ISMoreData==NO)
    {
        ISLastContent=NO;
    }
    else{
        //int lastIndex=[tableContent count];
       tableContent=[arrx objectForKey:@"courselist"];
       
    }
    lastId=[[arrx objectForKey:@"extraparam"]objectForKey:@"last_id"];
    
    [courseTable reloadData];
    
    NSLog(@"tableContent lastid = %@ and %@",lastId,ISMoreData?@"YES":@"NO" );
    //NSLog(@"Contents are here is %@ length = %d",tableContent,[tableContent count]);
    [self.view setUserInteractionEnabled:YES];
    [SVProgressHUD dismiss];
    count++;
    }
    @catch(NSException *e){
      [SVProgressHUD dismiss];
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [tableContent count];
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier=@"TTTCourseListCell";
    
    TTTCourseListCell *courseListCell=(TTTCourseListCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (courseListCell==nil)
    {
        UIButton *buttonPlus;
        NSArray *arrxibref=[[NSBundle mainBundle]loadNibNamed:@"TTTCourseListCell" owner:self options:nil];
        

        courseListCell=(TTTCourseListCell *)[arrxibref objectAtIndex:0];
        [courseListCell setSelectionStyle:UITableViewCellSelectionStyleNone];
        UIActivityIndicatorView *Indi=(UIActivityIndicatorView *)[courseListCell.contentView viewWithTag:2010];
        [Indi startAnimating];
        UIImageView *Cellimage=(UIImageView *)[courseListCell.contentView viewWithTag:2008];
        UILabel *titleLabel=(UILabel *)[courseListCell.contentView viewWithTag:2004];
        UILabel *locationLabel=(UILabel *)[courseListCell.contentView viewWithTag:2005];
        titleLabel.font=[UIFont fontWithName:MYRIARDPROSAMIBOLT size:17];
        locationLabel.font=[UIFont fontWithName:MYRIARDPROLIGHT size:11];
        NSDictionary *dict=[tableContent objectAtIndex:indexPath.row];
        
        locationLabel.text=[NSString stringWithFormat:@"%@",[dict objectForKey:@"location"]];
        titleLabel.text=[NSString stringWithFormat:@"%@",[dict objectForKey:@"course_name"]];
        
        BOOL isMyCourse =[[dict objectForKey:@"its_my_course"]integerValue]==1?YES:NO;

        NSString *isPermitted =[dict objectForKey:@"course_permission"];
         buttonPlus=(UIButton *)[courseListCell.contentView viewWithTag:2002];
       if([isPermitted isEqualToString:@"0"]){
           
            UIButton *buttonFlag=(UIButton *)[courseListCell.contentView viewWithTag:2003];
           buttonPlus.hidden=YES;
           buttonFlag.hidden=YES;
           
           
        }
        
        if(isMyCourse==YES){
            UIImage *deepPlus=[UIImage imageNamed:@"plus-icon-Course"];
            [buttonPlus setImage:deepPlus forState:UIControlStateNormal];
        }else{
            UIImage *fadePlus=[UIImage imageNamed:@"plus-icon1"];
            [buttonPlus setImage:fadePlus forState:UIControlStateNormal];
        }
        [buttonPlus addTarget:self action:@selector(addremove:) forControlEvents:UIControlEventTouchUpInside];
        buttonPlus.tag=indexPath.row;
        
        NSURLRequest *request_img = [NSURLRequest requestWithURL:[NSURL URLWithString:[dict objectForKey:@"course_user_thumb"]]];
        
        AFImageRequestOperation *operation = [AFImageRequestOperation imageRequestOperationWithRequest:request_img
                                                                                  imageProcessingBlock:nil
                                                                                               success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                                                                   if(image!=nil)
                                                                                                   {
                                                                                                       
                                                                                                       [Cellimage setImage:image];
                                                                                                       
                                                                                                       [Indi stopAnimating];                                                                                                   [Indi hidesWhenStopped];
                                                                                                       [Indi removeFromSuperview];
                                                                                                   }
                                                                                                   
                                                                                               }
                                                                                               failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                                                                                   NSLog(@"Error %@",error);
                                                                                                   
                                                                                                   NSLog(@"error");
                                                                                                   
                                                                                               }];
        [operation start];
        
    }
    

    
    return courseListCell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 205.0;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    TTTCourseDetailsView *Coursedetails=[[TTTCourseDetailsView alloc]init];
    Coursedetails.CourseID=[[tableContent objectAtIndex:indexPath.row] valueForKey:@"courseid"];
    [self PushViewController:Coursedetails TransitationFrom:kCATransitionFade];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)menuClicked:(id)sender {
    IsLeftMenuBoxOpen=[self PerformMenuSlider:_screenView withMenuArea:_menuView IsOpen:IsLeftMenuBoxOpen];//[self PerformMenuSlider:_screenView withMenuArea:_menuView IsOpen:IsLeftMenuBoxOpen];
}

- (IBAction)searchClicked:(id)sender {
    if(isEditing==NO){
        isEditing=YES;   
    self.courseTable.frame=CGRectMake(self.courseTable.frame.origin.x,100,self.courseTable.frame.size.width,self.courseTable.frame.size.height);
    UIButton *search=(UIButton *)[self.searchPopup viewWithTag:1098];
    UITextField *textfld=(UITextField *)[self.searchPopup viewWithTag:1099];
    textfld.delegate=self;
    [search addTarget:self action:@selector(searchthere:) forControlEvents:UIControlEventTouchUpInside];
    [self.screenView addSubview:self.searchPopup];
        [self.screenView bringSubviewToFront:self.searchPopup];
    }
    else
    {
        isEditing=NO;
        self.searchPopup.frame=CGRectMake(0,0,0,0);
        self.courseTable.frame=CGRectMake(self.courseTable.frame.origin.x,60,self.courseTable.frame.size.width,self.courseTable.frame.size.height);
        [self.searchPopup removeFromSuperview];
    }
}

-(void)searchthere:(UIButton *)btn{
    [self searchResult];
}
-(void)searchResult{
    ISsearched=YES;
    NSLog(@"We are at search");
      NSString *stringurl;
    searchText=[_Searchtextfield text];//[textfld text];
    tableContent=[[NSMutableArray alloc]init];
    count=0;
    if(i==1)
        stringurl = [NSString stringWithFormat:@"%@user.php?mode=allcourses&userid=%@&loggedin_userid=%@&search=%@", API,[self LoggedId],[self LoggedId],[searchText stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    else if(i==0)
        stringurl = [NSString stringWithFormat:@"%@user.php?mode=mycourses&userid=%@&loggedin_userid=%@&search=%@", API,[self LoggedId],[self LoggedId],[searchText stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSLog(@"stringurl---%@",stringurl);
    NSURL *url = [NSURL URLWithString:stringurl];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:req delegate:self];
    if (connection)
    {
        staticData = [[NSMutableData alloc]init];
    }
    isEditing=NO;
    
    [self.searchPopup removeFromSuperview];
    [SVProgressHUD show];
}
- (IBAction)menuChanged:(id)sender {
    
    if (Ishoveropen==FALSE)
    {
        self.arrowimage.hidden=YES;
        self.MenuAppear.frame=CGRectMake(0, 60, 320, 0);
        self.MenuAppear.alpha=0.0000f;
        [self.screenView addSubview:self.MenuAppear];
        
        [UIView animateWithDuration:0.2f animations:^{
            
            self.MenuAppear.frame=CGRectMake(0, 60, 320, 110);
            self.MenuAppear.alpha=1.0000f;
            
        }
                         completion:^(BOOL finished)
         {
             Ishoveropen=TRUE;
         }];
        
    }
    else
    {
        self.arrowimage.hidden=NO;
        [UIView animateWithDuration:0.2f animations:^{
             self.MenuAppear.frame=CGRectMake(0, 60, 320, 0);
             self.MenuAppear.alpha=0.0000f;
        }
                         completion:^(BOOL finished)
         {
             
             Ishoveropen=FALSE;
             [ self.MenuAppear removeFromSuperview];
         }];
    }
    [ self.screenView bringSubviewToFront:self.searchPopup];
}
- (IBAction)myCourseAction:(id)sender {
    
    [UIView animateWithDuration:0.2f animations:^{
        self.MenuAppear.frame=CGRectMake(0, 60, 320, 0);
        self.MenuAppear.alpha=0.0000f;
    }
completion:^(BOOL finished)
    {
        
        Ishoveropen=FALSE;
        self.arrowimage.hidden=NO;
        [self.MenuAppear removeFromSuperview];
        [SVProgressHUD show];
    }];
    
    ISsearched=NO;
    //ISMoreData=YES;
    NSString *stringurl=[NSString stringWithFormat:@"%@user.php?mode=mycourses&userid=%@&loggedin_userid=%@", API,[self LoggedId],[self LoggedId]];
    _courseLabel.text=[arr objectAtIndex:0];
    NSURL *url = [NSURL URLWithString:stringurl];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:req delegate:self];
    if (connection)
    {
        staticData = [[NSMutableData alloc]init];
    }
    if(tableContent!=nil)
    tableContent=[[NSMutableArray alloc]init];
    i=0;
    count=0;
    }
- (IBAction)AllCourseAction:(id)sender {
    
    [UIView animateWithDuration:0.2f animations:^{
        self.MenuAppear.frame=CGRectMake(0, 60, 320, 0);
        self.MenuAppear.alpha=0.0000f;
    }
                     completion:^(BOOL finished)
     {
         
         Ishoveropen=FALSE;
         self.arrowimage.hidden=NO;
         [self.MenuAppear removeFromSuperview];
         [SVProgressHUD show];

     }];
    ISsearched=NO;
    
    _courseLabel.text=[arr objectAtIndex:1];
    NSString *stringurl=[NSString stringWithFormat:@"%@user.php?mode=allcourses&userid=%@&loggedin_userid=%@", API,[self LoggedId],[self LoggedId]];
    NSURL *url = [NSURL URLWithString:stringurl];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:req delegate:self];
    if (connection)
    {
        staticData = [[NSMutableData alloc]init];
    }
    if(tableContent!=nil)
        tableContent=[[NSMutableArray alloc]init];
    i=1;
    count=0;
}
-(void) MoreDataLoadOnTable{
    NSString *stringurl;
   
    
    if(ISMoreData==YES){
       //[SVProgressHUD show];
        if(i==1){
            if(ISsearched==YES){
              stringurl=[NSString stringWithFormat:@"%@user.php?mode=allcourses&userid=%@&loggedin_userid=%@&lastid=%@&search=%@", API,[self LoggedId],[self LoggedId],lastId,[searchText stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            }
            else{
                stringurl=[NSString stringWithFormat:@"%@user.php?mode=allcourses&userid=%@&loggedin_userid=%@&lastid=%@", API,[self LoggedId],[self LoggedId],lastId];
            }
        }
        else if(i==0){
            if(ISsearched==YES){
               stringurl=[NSString stringWithFormat:@"%@user.php?mode=mycourses&userid=%@&loggedin_userid=%@&lastid=%@&search=%@", API,[self LoggedId],[self LoggedId],lastId,[searchText stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            }
            else{
                stringurl=[NSString stringWithFormat:@"%@user.php?mode=mycourses&userid=%@&loggedin_userid=%@&lastid=%@", API,[self LoggedId],[self LoggedId],lastId];
            }
            }

        
        NSLog(@"Url is -------------------- %@",stringurl);
        NSURL *url = [NSURL URLWithString:stringurl];
        NSURLRequest *req = [NSURLRequest requestWithURL:url];
        NSURLConnection *connection = [NSURLConnection connectionWithRequest:req delegate:self];
        if (connection)
        {
            staticData = [[NSMutableData alloc]init];
        }
        
   }
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
CGPoint offset = scrollView.contentOffset;
CGRect bounds = scrollView.bounds;
CGSize size = scrollView.contentSize;
UIEdgeInsets inset = scrollView.contentInset;
float y = offset.y + bounds.size.height - inset.bottom;
float h = size.height;

float reload_distance = -60.0f;
    if(y > h + reload_distance){
        [self MoreDataLoadOnTable];
    }
}

//Pan gesture
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        CGPoint translation = [(UIPanGestureRecognizer*)gestureRecognizer translationInView:self.screenView];
        if (fabsf(translation.x) > fabsf(translation.y))
        {
            return YES;
        }
        
        return NO;
    }
    
    return YES;
}
- (void)panDetected:(UIPanGestureRecognizer *)panRecognizer
{
    
    CGPoint  stopLocation;
    
    
    
   
    if (panRecognizer.state == UIGestureRecognizerStateChanged)
    {
        stopLocation = [panRecognizer translationInView:_screenView];
        
        CGRect frame=[_screenView frame];
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
                    _screenView.frame=frame;
                    
                }];
                
            }
            else
            {
                
                IsLeftMenuBoxOpen=YES;
                isFastLocation=TRUE;
                CGRect lastFrame=[_screenView frame];
                lastFrame.origin.x=260;
                [UIView animateWithDuration:.5 animations:^{
                    _screenView.frame=lastFrame;
                    
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
                    _screenView.frame=frame;
                    
                }];
                
            }
            else
            {
                
                IsLeftMenuBoxOpen=NO;
                islastlocation=TRUE;
                CGRect lastFrame2=[_screenView frame];
                lastFrame2.origin.x=0;
                [UIView animateWithDuration:.5 animations:^{
                    _screenView.frame=lastFrame2;
                    
                }];
            }
        }
        
        
        
        
        
    }
    
    else if (panRecognizer.state==UIGestureRecognizerStateEnded)
    {
        if (stopLocation.x<150&islastlocation==TRUE&IsLeftMenuBoxOpen==NO)
        {
            
            CGRect framelast=[_screenView frame];
            framelast.origin.x=0;
            
            
            [UIView animateWithDuration:.6 animations:^{
                _screenView.frame=framelast;
                
            }];
        }
        
        if (stopLocation.x*-1<100.0f&isFastLocation==TRUE&IsLeftMenuBoxOpen==YES)
        {
            
            // NSLog(@"This is the start");
            CGRect framelast=[_screenView frame];
            framelast.origin.x=260;
            
            
            [UIView animateWithDuration:.6 animations:^{
                _screenView.frame=framelast;
                
            }];
            
        }
        
        
    }
    
    
    
}
- (IBAction)SearchButtonClicked:(id)sender
{
        
        [SVProgressHUD showWithStatus:@"searching"];
        [self.view setUserInteractionEnabled:NO];
        [self searchResult];
         isEditing=NO;
         [_Searchtextfield resignFirstResponder];

}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    [self.view setUserInteractionEnabled:NO];
    if (IsLeftMenuBoxOpen==FALSE)
    {
        [SVProgressHUD showWithStatus:@"searching"];
        [[self view] setUserInteractionEnabled:NO];
       
    }
    
    if ([self.manuSearchtxt.text length]<1)
    {
        CGRect frame=[self.Scarchicon frame];
        frame.origin.x=122;
        [UIView animateWithDuration:.3f animations:^{
            
            self.Scarchicon.frame=frame;
        }];
        
    }
    [self searchResult];
    isEditing=NO;
    
    return YES;
}

- (IBAction)SearchMatch:(id)sender
{
    [_Searchtextfield setTextColor:[UIColor whiteColor]];
    _Searchtextfield.font=[UIFont fontWithName:@"MyriadPro-Regular" size:16.0f];
    [_Searchtextfield setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [_Searchview setFrame:CGRectMake(0, 60, 320, 0)];
    [_screenView addSubview:_Searchview];
    CGRect Frame=[_Searchview frame];
    
    
    if (IfSearchViewopen==FALSE)
    {
        Frame.size.height=40;
        _Searchtextfield.hidden=YES;
        _searchIconPng.hidden=YES;
        // NSLog(@"the value of scarchlist");
        [UIView animateWithDuration:.4 animations:^{
            _Searchview.frame=Frame;
            if (IsIphone5)
            {
                courseTable.frame = CGRectMake(0, 100, 320, 468);
            }
            else
            {
                courseTable.frame = CGRectMake(0, 100, 320, 380);
            }
            
            
        }
                         completion:^(BOOL finish)
         {
             IfSearchViewopen=TRUE;
             _Searchtextfield.hidden=FALSE;
             _searchIconPng.hidden=NO;
         }];
    }
    
    else
    {
        Frame.size.height=0;
        
        [UIView animateWithDuration:.3 animations:^{
            _Searchview.frame=Frame;
            _Searchtextfield.hidden=TRUE;
            _searchIconPng.hidden=YES;
            if (IsIphone5)
            {
                courseTable.frame = CGRectMake(0, 60, 320, 508);
            }
            else
            {
                courseTable.frame = CGRectMake(0, 60, 320, 420);
            }
            
            
        }
                         completion:^(BOOL finish)
         {
             IfSearchViewopen=FALSE;
             [_Searchview removeFromSuperview];
         }];
    }
    

}
-(void)addremove:(UIButton *)sender
{
    NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
    dict=[tableContent objectAtIndex:sender.tag];
    NSLog(@"Dictionary is %@",dict);
    NSString *alreadyinlist=[dict objectForKey:@"its_my_course"];
    NSString *courseUser=[dict objectForKey:@"courseid"];
    NSString *coursePermission=[dict objectForKey:@"course_permission"];
    if([coursePermission isEqualToString:@"1"])
    {
        NSString *URL=[NSString stringWithFormat:@"%@user.php?mode=course_follow&userid=%@&courseid=%@&myoption=%@", API,[self LoggedId],courseUser,alreadyinlist];
        NSLog(@"Url is %@",URL);
        NSData *getData=[NSData dataWithContentsOfURL:[NSURL URLWithString:URL]];
        NSDictionary *dict1=[NSJSONSerialization JSONObjectWithData:getData options:kNilOptions error:nil];
        NSString *msg=[[dict1 objectForKey:@"extraparam"]objectForKey:@"message"];
        NSString *successtype=[[dict1 objectForKey:@"extraparam"]objectForKey:@"response"];
        NSLog(@"message is %@ successType %@",msg,successtype);
        
        
        if([successtype isEqualToString:@"success"]){
            
            NSString *val;
        if([[dict objectForKey:@"its_my_course"]integerValue]==1)
            val=@"0";
            if([[dict objectForKey:@"its_my_course"]integerValue]==0)
                val=@"1";
            dict=[dict mutableCopy];
        [dict setValue:val forKey:@"its_my_course"];
            
        [tableContent replaceObjectAtIndex:sender.tag withObject:dict];
        
        UIButton *buttonPlus;
        NSIndexPath *ip = [NSIndexPath indexPathForRow:sender.tag inSection:0];
        NSArray *archange=[[NSArray alloc]initWithObjects:ip, nil];
            
            if(i==1){
        TTTCourseListCell *cell = (TTTCourseListCell *)[courseTable cellForRowAtIndexPath:ip];
        BOOL isMyCourse =[[dict objectForKey:@"its_my_course"]integerValue]==1?YES:NO;
         buttonPlus=(UIButton *)[cell.contentView viewWithTag:2002];
        if(isMyCourse==YES){
            UIImage *deepPlus=[UIImage imageNamed:@"plus-icon1"];
            [buttonPlus setImage:deepPlus forState:UIControlStateNormal];
        }else{
            UIImage *fadePlus=[UIImage imageNamed:@"plus-icon-Course"];
            [buttonPlus setImage:fadePlus forState:UIControlStateNormal];
        }
        [courseTable reloadRowsAtIndexPaths:archange withRowAnimation:UITableViewRowAnimationNone];
         }
            if(i==0){
                [courseTable beginUpdates];
                [tableContent removeObjectAtIndex:sender.tag];
                [courseTable deleteRowsAtIndexPaths:[NSArray arrayWithObjects:ip, nil] withRowAnimation:UITableViewRowAnimationNone];
                [courseTable endUpdates];
                
            }
        
        }
    }
    
}

@end