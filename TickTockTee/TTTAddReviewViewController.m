//
//  TTTAddReviewViewController.m
//  TickTockTee
//
//  Created by Esolz_Mac on 08/04/14.
//  Copyright (c) 2014 com.esolz.TickTockTee. All rights reserved.
//

#import "TTTAddReviewViewController.h"
#import "TTTCourseReviewViewController.h"

@interface TTTAddReviewViewController (){
    BOOL slideup,IScancelButtonclick,isfinish,clickcancel;
    int rating;
    NSString *viewerID;
     NSOperationQueue *OperationQ;
     NSString *MyString;
}
@property (strong, nonatomic) IBOutlet UILabel *reviewOptionLbl;
@property (strong, nonatomic) IBOutlet UIView *ScreenView;
@property (strong, nonatomic) IBOutlet UIView *footerview;
@property (strong, nonatomic) IBOutlet UITextView *writereview;
@property (strong, nonatomic) IBOutlet UIButton *star1;
@property (strong, nonatomic) IBOutlet UIButton *star2;
@property (strong, nonatomic) IBOutlet UIButton *star3;
@property (strong, nonatomic) IBOutlet UIButton *star4;
@property (strong, nonatomic) IBOutlet UIButton *star5;
@property (strong, nonatomic) IBOutlet UILabel *instruction;
@property (weak, nonatomic)    IBOutlet UIButton *ButtonDon;
@end

@implementation TTTAddReviewViewController
@synthesize ScreenView,footerview,writereview,star1,star2,star3,star4,star5,instruction,reviewCourseID,AllReviews;
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
    (!IsIphone5)?[footerview setFrame:CGRectMake(0, (480 - footerview.frame.size.height),footerview.frame.size.width, footerview.frame.size.height)]:[footerview setFrame:CGRectMake(0, (568 - footerview.frame.size.height), footerview.frame.size.width,footerview.frame.size.height)];
    [ScreenView addSubview:footerview];
    instruction.font=[UIFont fontWithName:MYRIARDPROLIGHT size:16];
     OperationQ=[[NSOperationQueue alloc]init];
    IScancelButtonclick=FALSE;
    isfinish=FALSE;
    clickcancel=FALSE;
    instruction.text=@"Tap Star to Rate";
    writereview.delegate=self;
   
    writereview.font=[UIFont fontWithName:MYRIARDPROLIGHT size:18];
   
	NSDate *now = [NSDate date];
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"MMM d ,yyyy"];
	MyString = [dateFormatter stringFromDate:now];
    NSLog(@"Then my string:%@",MyString);
	
    viewerID=[self LoggedId];
    rating=0;
    [star1 addTarget:self action:@selector(rating:) forControlEvents:UIControlEventTouchUpInside];
    star1.tag=100;
    [star2 addTarget:self action:@selector(rating:) forControlEvents:UIControlEventTouchUpInside];
    star2.tag=101;
    [star3 addTarget:self action:@selector(rating:) forControlEvents:UIControlEventTouchUpInside];
    star3.tag=102;
    [star4 addTarget:self action:@selector(rating:) forControlEvents:UIControlEventTouchUpInside];
    star4.tag=103;
    [star5 addTarget:self action:@selector(rating:) forControlEvents:UIControlEventTouchUpInside];
    star5.tag=104;
    
writereview.font=[UIFont fontWithName:MYREADPROREGULAR size:15];
    self.reviewOptionLbl.font=[UIFont fontWithName:MYREADPROREGULAR size:15];
    
}
-(void)rating:(UIButton *)sender{
   
    int tapbutton=sender.tag-100;
    if([sender.currentBackgroundImage isEqual:[UIImage imageNamed:@"starnot"]]){
    for(int i=0;i<tapbutton+1;i++){
        UIButton *star=(UIButton *)[ScreenView viewWithTag:100+i];
        if([star.currentBackgroundImage isEqual:[UIImage imageNamed:@"starnot"]]){
            [star setBackgroundImage:[UIImage imageNamed:@"star.png"] forState:UIControlStateNormal];
            rating++;
        }
    }
    }else if([sender.currentBackgroundImage isEqual:[UIImage imageNamed:@"star"]]){
        for(int i=tapbutton;i<5;i++){
            UIButton *star=(UIButton *)[ScreenView viewWithTag:100+i];
            if([star.currentBackgroundImage isEqual:[UIImage imageNamed:@"star"]])
            {
                [star setBackgroundImage:[UIImage imageNamed:@"starnot"] forState:UIControlStateNormal];
                rating--;
            }
        }
    }
    if(rating>0){
        
        [[self ButtonDon] setBackgroundImage:[UIImage imageNamed:@"donegreen"] forState:UIControlStateNormal];
        
        [[self ButtonDon] setBackgroundImage:[UIImage imageNamed:@"donegreen"] forState:UIControlStateHighlighted];
        
        [[self ButtonDon] setBackgroundImage:[UIImage imageNamed:@"donegreen"] forState:UIControlStateSelected];
        
    }else{
        
        [[self ButtonDon] setBackgroundImage:[UIImage imageNamed:@"doneLocation"] forState:UIControlStateNormal];
        
        [[self ButtonDon] setBackgroundImage:[UIImage imageNamed:@"doneLocation"] forState:UIControlStateHighlighted];
        
        [[self ButtonDon] setBackgroundImage:[UIImage imageNamed:@"doneLocation"] forState:UIControlStateSelected];
        
    }
    
    NSLog(@"rating %d",rating);
}


- (void)textViewDidBeginEditing:(UITextView *)textView
{
    slideup=FALSE;
    [self slidefooterview];
    [self.reviewOptionLbl setHidden:YES];
        //[textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    slideup=TRUE;
    [self slidefooterview];
    if (!textView.text.length>0)
    {
        self.reviewOptionLbl.hidden=NO;
    }

    [textView resignFirstResponder];
}
- (IBAction)cancel:(id)sender{
    slideup=TRUE;
    IScancelButtonclick=TRUE;
    [self clearrating];
    [self slidefooterview];
    [self PerformGoBack];
    
}
-(void)clearrating
{
    for(int i=0;i<5;i++){
        UIButton *star=(UIButton *)[ScreenView viewWithTag:100+i];
        if([star.currentBackgroundImage isEqual:[UIImage imageNamed:@"star.png"]])
        {
            [star setBackgroundImage:[UIImage imageNamed:@"starnot"] forState:UIControlStateNormal];
            rating--;
        }
    }
}
-(void)slidefooterview{
    if(slideup==FALSE){
    [UIView animateWithDuration:.1f animations:^{
        
        CGRect rect1 = footerview.frame;
        rect1.origin.y=302;
       footerview.frame = rect1;
        
    }];
    }
    else
    {
   [UIView animateWithDuration:.1f animations:^{
        CGRect rect1 = footerview.frame;
        if(IsIphone5){
            rect1.origin.y=519;
        }else{
            rect1.origin.y=431;
        }
   footerview.frame = rect1;
    }completion:^(BOOL finish)
     {
         [writereview resignFirstResponder];
       
     }];
    }
   
}
- (IBAction)submit:(id)sender
{
    
    slideup=TRUE;
    [self slidefooterview];

    NSInvocationOperation *operation=[[NSInvocationOperation alloc]initWithTarget:self selector:@selector(postreview) object:nil];
    [OperationQ addOperation:operation];
    
}
-(void)postreview
 {
    if([[writereview.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0){
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self clearrating];
            [SVProgressHUD showErrorWithStatus:@"Please write a review"];
        });
    }
    else if (!rating >0)
    {
       [SVProgressHUD showErrorWithStatus:@"Please add rating"];
    }
    
    else
    {
        
        if ([self isConnectedToInternet])
        {
            NSError *Error;
            @try
            {
                NSString *URL=[NSString stringWithFormat:@"%@user.php?mode=course_review&userid=%@&courseid=%@&msg=%@&rating=%d", API,viewerID,reviewCourseID,[[writereview.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],rating];
                NSLog(@"%@", URL);
                
                NSData *data=[NSData dataWithContentsOfURL:[NSURL URLWithString:URL]];
                if([data length]>0)
                {
                     NSDictionary * OutputDic=[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&Error];
                    
            if ([OutputDic isKindOfClass:[NSDictionary class]]){
                         NSDictionary *extraparam=[OutputDic valueForKey:@"extraparam"];
                if ([extraparam isKindOfClass:[NSDictionary class]]){
                    if([[extraparam valueForKey:@"response"] isEqualToString:@"success"])
                     {
                         dispatch_async(dispatch_get_main_queue(), ^{
                             
                            
                            [self clearrating];
//                            NSMutableDictionary *mutDic=[[NSMutableDictionary alloc]init];
//                             [mutDic setValue:writereview.text forKey:@"review"];
//                             [mutDic setValue:[NSString stringWithFormat:@"%d",rating] forKey:@"review_user_rating"];
//                             [mutDic setValue:MyString forKey:@"review_time"];
//                             [mutDic setValue:[self LoggerName] forKey:@"review_user_name"];
//                             [mutDic setValue:[self LoggerImageURL] forKey:@"review_provider"];
//                             [AllReviews addObject:mutDic];
                              [SVProgressHUD showSuccessWithStatus:[extraparam valueForKey:@"message"]];
                             TTTCourseReviewViewController *courseReview=[[TTTCourseReviewViewController alloc]init];
                             courseReview.reviewarraylist=[AllReviews copy];
                             courseReview.courseid=reviewCourseID;
                             [self PushViewController:courseReview TransitationFrom:kCATransitionFade];
                            
                            
                         });
                     }else
                       {
                           dispatch_async(dispatch_get_main_queue(), ^{
                   
                             [SVProgressHUD showErrorWithStatus:[extraparam valueForKey:@"message"]];
                           });
                   
                   
                        }
                 }
                 else
                 {
                 dispatch_async(dispatch_get_main_queue(), ^{
                    
                  [SVProgressHUD showErrorWithStatus:@"Unexpected error occured."];
                    
                   });
                 }
            }
            else
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [SVProgressHUD showErrorWithStatus:@"Unexpected error occured."];
                    
                });
            }
                }
                
            }@catch (NSException *exception) {
              
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [SVProgressHUD showErrorWithStatus:@"Unexpected error occured."];
                    
                });

                 NSLog(@" %s exception %@",__PRETTY_FUNCTION__,exception);
            }
            
        }else
        {
            [SVProgressHUD showErrorWithStatus:@"No internet connection"];
        }
    }
    
}

- (IBAction)BackToprivious:(id)sender
{
    [self PerformGoBack];
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        
        NSInvocationOperation *operation=[[NSInvocationOperation alloc]initWithTarget:self selector:@selector(postreview) object:nil];
        [OperationQ addOperation:operation];
        return NO;
        
    }return  YES;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
