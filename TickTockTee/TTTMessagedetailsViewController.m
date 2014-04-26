//
//  TTTMessagedetailsViewController.m
//  TickTockTee
//
//  Created by Esolz_Mac on 03/04/14.
//  Copyright (c) 2014 com.esolz.TickTockTee. All rights reserved.
//

#import "TTTMessagedetailsViewController.h"

#import "SVProgressHUD.h"
#import "TTTCreatematch.h"
#import "TTTCellformessage.h"
#import "AFImageRequestOperation.h"
#import "TTTCretenewmessage.h"

@interface TTTMessagedetailsViewController (){
    BOOL AddStatus;
    NSMutableArray *messagearray;
    NSOperationQueue *OperationQ;
    CGFloat tblheight;
    CGFloat height;
    TTTGlobalMethods *Method;
    NSInteger numborofmessage;
    NSString *useImage;
    BOOL ISscroll;
    NSString *date;
}
@property (strong, nonatomic) IBOutlet UIView *ScreenView;
@property (strong, nonatomic) IBOutlet UIView *showmsgView;
@property (strong, nonatomic) IBOutlet UILabel *title;
@property (strong, nonatomic) IBOutlet UILabel *txtlbl;
@property (strong, nonatomic) IBOutlet UITextView *msgtextview;
@property (strong, nonatomic) IBOutlet UIView *footerview;
@property (strong, nonatomic) IBOutlet UIView *statusview;
@property (strong, nonatomic) IBOutlet UIButton *Statusbutton;

@property (strong, nonatomic) IBOutlet UITableView *messagelist;
@end

@implementation TTTMessagedetailsViewController
@synthesize ScreenView,showmsgView,footerview,title,msgtextview,statusview,Statusbutton,messagelist,messageid,msgsender_name,txtlbl;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self=(IsIphone5)?[super initWithNibName:@"TTTMessagedetailsViewController" bundle:nil]:[super initWithNibName:@"TTTMessagedetailsViewController_iPhone4" bundle:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    title.text=msgsender_name;
    title.font = [UIFont fontWithName:MYREADPROREGULAR size:18.0];
    AddStatus=TRUE;
    ISscroll=FALSE;
    messagearray=[[NSMutableArray alloc] init];
    messagelist.delegate=self;
    messagelist.dataSource=self;
    messagelist.backgroundColor=[UIColor clearColor];
    OperationQ=[[NSOperationQueue alloc]init];
   
    [txtlbl setFont:[UIFont fontWithName:MYRIARDPROLIGHT size:15.0f]];
    msgtextview.font=[UIFont fontWithName:MYRIARDPROLIGHT size:15.0];
    NSUserDefaults *userDetais=[NSUserDefaults standardUserDefaults];
    useImage=[userDetais valueForKey:SESSION_LOGGERIMAGEURL];
    height=0.0f;
    [SVProgressHUD show];
    [self showmessage];
    
}

-(void)showmessage
{
    NSInvocationOperation *operation=[[NSInvocationOperation alloc]initWithTarget:self selector:@selector(getmessage) object:Nil];
    [OperationQ addOperation:operation];
    
}
-(void)getmessage
{
    
    if ([self isConnectedToInternet])
    {
        
        NSError *Error;
        @try{
            NSString *StringUrl=[NSString stringWithFormat:@"%@user.php?mode=messagesdetails&id=%@",API,messageid];
            NSLog(@"StringUrl %@",StringUrl);
            NSData *data=[NSData dataWithContentsOfURL:[NSURL URLWithString:StringUrl]];
            if([data length]>0){
                id messagedic=[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&Error];
                if ([messagedic isKindOfClass:[NSDictionary class]]){
                    
                    if ([[messagedic valueForKey:@"message"] isKindOfClass:[NSArray class]])
                    {
                        NSArray *array=[messagedic objectForKey:@"message"];
                        if ([array count]>0)
                        {
                            
                            for(NSMutableDictionary *loop in array)
                            {
                                NSMutableDictionary *dicFormessage = [[NSMutableDictionary alloc]init];
                                
                                [dicFormessage setValue:[self RemoveNullandreplaceWithSpace:[loop objectForKey:@"id"]]forKey:@"id"];
                                [dicFormessage setValue:[self RemoveNullandreplaceWithSpace:[loop objectForKey:@"SenderId"]]forKey:@"SenderId"];
                                [dicFormessage setValue:[self RemoveNullandreplaceWithSpace:[loop objectForKey:@"SenderName"]] forKey:@"SenderName"];
                                [dicFormessage setValue:[self RemoveNullandreplaceWithSpace:[loop objectForKey:@"SenderImage"]] forKey:@"SenderImage"];
                                [dicFormessage setValue:[self RemoveNullandreplaceWithSpace:[loop objectForKey:@"subject"]] forKey:@"subject"];
                                [dicFormessage setValue:[self RemoveNullandreplaceWithSpace:[loop objectForKey:@"message"]] forKey:@"message"];
                                [dicFormessage setValue:[self RemoveNullandreplaceWithSpace:[loop objectForKey:@"SendDate"]] forKey:@"SendDate"];
                                [dicFormessage setValue:[self RemoveNullandreplaceWithSpace:[loop objectForKey:@"isunread"]] forKey:@"isunread"];
                                
                                [messagearray addObject:dicFormessage];
                                
                                
                            }
                            
                            
                            [self performSelectorOnMainThread:@selector(ReloadTable) withObject:nil waitUntilDone:YES];
                            
                        }else
                        {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                
                                [SVProgressHUD showErrorWithStatus:@"No details found!"];
                            });
                        }}
                    else
                    {
                        [SVProgressHUD showErrorWithStatus:@"Unexpected error occured."];
                    }
                }else
                {
                    [SVProgressHUD showErrorWithStatus:@"Unexpected error occured."];
                }
            }
        }@catch (NSException *exception) {
            [SVProgressHUD dismiss];
            NSLog(@" %s exception %@",__PRETTY_FUNCTION__,exception);
        }
    }else
    {
        [SVProgressHUD showErrorWithStatus:@"No internet connection"];
    }
    
}


-(void)ReloadTable
{
    [messagelist reloadData];
    [SVProgressHUD dismiss];
}
-(void)insertintotable
{
    
    
    numborofmessage=[messagearray count]-1;
    height=0.0f;
    [messagelist beginUpdates];
    NSIndexPath *Indexpath=[NSIndexPath indexPathForRow:numborofmessage inSection:0];
    [messagelist insertRowsAtIndexPaths:[[NSArray alloc] initWithObjects:Indexpath, nil] withRowAnimation:UITableViewRowAnimationFade];
    
    [messagelist endUpdates];
    msgtextview.text=@"";
    txtlbl.hidden=NO;
    
    
    [messagelist scrollToRowAtIndexPath:Indexpath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    
    
    
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [messagearray count];
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITextView *message=[[UITextView alloc]initWithFrame:CGRectMake(54, 40, 260, 30)];
    message.font=[UIFont fontWithName:MYRIARDPROLIGHT size:13.0f];
    message.textColor=[UIColor whiteColor];
    message.textAlignment=NSTextAlignmentLeft;
    [message setEditable:NO];
    message.text =[[messagearray objectAtIndex:indexPath.row]valueForKey:@"message"];
    NSAttributedString *Attributed=[[NSAttributedString alloc]initWithString:message.text attributes:@{
                                                                                                       
                                                                                                       NSFontAttributeName : [UIFont fontWithName:MYRIARDPROLIGHT size:13.0f],
                                                                                                       NSForegroundColorAttributeName : [UIColor whiteColor]
                                                                                                       }];
    
    
    
    [message setAttributedText:Attributed];
    
    CGSize newSize = [message sizeThatFits:CGSizeMake(260, MAXFLOAT)];
    CGFloat Extraheight=0.0f;
    if (newSize.height>30)
    {
        CGRect frame=[message frame];
        Extraheight=newSize.height-30;
        frame.size.height+=Extraheight;
        [message setFrame:frame];
    }
    
    height+=80+Extraheight;
    NSLog(@"height %f",height);
    return 80+Extraheight;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TTTCellformessage *cell=(TTTCellformessage *)[tableView dequeueReusableCellWithIdentifier:nil];
    
    if (cell==nil)
    {
        NSArray *arr=[[NSBundle mainBundle]loadNibNamed:@"TTTCellformessage" owner:self options:nil];
        
        cell=[arr objectAtIndex:0];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    UIView *viewOnSenderImage = (UIView *) [cell.contentView viewWithTag:112];
    [self SetroundborderWithborderWidth:2.0f WithColour:[UIColor whiteColor] ForView:viewOnSenderImage];
    
    UIImageView *SenderImage = (UIImageView *) [cell.contentView viewWithTag:113];
    [self SetroundborderWithborderWidth:2.0f WithColour:[UIColor clearColor] ForImageview:SenderImage];
    UIActivityIndicatorView *spinner=(UIActivityIndicatorView *)[cell.contentView viewWithTag:200];
    
    NSString *BackgroundImageStgring=[[messagearray objectAtIndex:indexPath.row]valueForKey:@"SenderImage"];
    
    
    
    NSURLRequest *request_img = [NSURLRequest requestWithURL:[NSURL URLWithString:BackgroundImageStgring]];
    AFImageRequestOperation *operation = [AFImageRequestOperation imageRequestOperationWithRequest:request_img
                                                                              imageProcessingBlock:nil
                                                                                           success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                                                               if(image!=nil)
                                                                                               {
                                                                                                   [SenderImage setImage:image];
                                                                                                   [spinner stopAnimating];
                                                                                                   [spinner setHidden:YES];
                                                                                               }
                                                                                               
                                                                                           }
                                                                                           failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                                                                               
                                                                                               [spinner stopAnimating];
                                                                                               [spinner setHidden:YES];
                                                                                               
                                                                                               
                                                                                           }];
    [operation start];
    
    
    
    UILabel *SenderName = (UILabel *) [cell.contentView viewWithTag:114];
    SenderName.text =[[messagearray objectAtIndex:indexPath.row]valueForKey:@"SenderName"];
    SenderName.font=[UIFont fontWithName:MYRIARDPROSAMIBOLT size:16.0];
    //Show message in textview
    
    UILabel *msgdate = (UILabel *) [cell.contentView viewWithTag:421];
    msgdate.text =[[messagearray objectAtIndex:indexPath.row]valueForKey:@"SendDate"];
    msgdate.font=[UIFont fontWithName:MYRIARDPROLIGHT size:13.0];
    
    UITextView *messageTxt=(UITextView *)[cell.contentView viewWithTag:420];
    messageTxt.font=[UIFont fontWithName:MYRIARDPROLIGHT size:13.0f];
    messageTxt.textColor=[UIColor whiteColor];
    //messageTxt.backgroundColor=[UIColor clearColor];
    messageTxt.textAlignment=NSTextAlignmentLeft;
    messageTxt.delegate=self;
    messageTxt.scrollEnabled=NO;
    [messageTxt setEditable:NO];
    messageTxt.text =[[messagearray objectAtIndex:indexPath.row]valueForKey:@"message"];
    NSAttributedString *Attributed=[[NSAttributedString alloc]initWithString:messageTxt.text attributes:@{
                                                                                                          NSFontAttributeName :[UIFont fontWithName:MYRIARDPROLIGHT size:13.0f],
                                                                                                          NSForegroundColorAttributeName :[UIColor whiteColor]
                                                                                                          }];
    
    [messageTxt setAttributedText:Attributed];
    
    CGSize newSize = [messageTxt sizeThatFits:CGSizeMake(260, MAXFLOAT)];
    CGFloat Extraheight=0.0f;
    if (newSize.height>30)
    {
        CGRect frame=[messageTxt frame];
        
        Extraheight=newSize.height-30;
        frame.size.height+=Extraheight;
        
        
        [messageTxt setFrame:frame];
        messageTxt.scrollEnabled=YES;
    }
    // Change the size of cell frame according to the textfield text
    
    
    UIView *backview=(UIView *)[cell.contentView viewWithTag:111];
    CGRect Celframe=[backview frame];
    Celframe.size.height+=Extraheight;
    [backview setFrame:Celframe];
    
    return cell;
    
    
}




- (IBAction)AddMaxView:(id)sender
{
    
    NSUserDefaults *userdefalds=[NSUserDefaults standardUserDefaults];
    [userdefalds setValue:nil forKey:SESSION_MATCHCREATEPARAMETES];
    [userdefalds setValue:nil forKey:COURSE_ID];
    [userdefalds setValue:nil forKey:COURSE_NAME];
    [userdefalds synchronize];
    TTTCretenewmessage *CreateNew=[[TTTCretenewmessage alloc]init];
    
    [self presentViewController:CreateNew animated:YES completion:^{
        [SVProgressHUD dismiss];
    }];
}



- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [UIView animateWithDuration:.10f animations:^{
        if(IsIphone5) {
            if(height>240){
                [messagelist setContentOffset:CGPointMake(0, height-240) animated:NO];
                
            }
        }
        else
        {
            if(height>140)
            {
                [messagelist setContentOffset:CGPointMake(0, height-164) animated:NO];
                
            }
        }
    }
                     completion:^(BOOL finish)
     {
         
         CGRect rect1 = footerview.frame;
         rect1.origin.y -= 215;
         [UIView animateWithDuration:.10f animations:^{
             
             footerview.frame = rect1;
         }
                          completion:^(BOOL finish)
          {
              //[messagelist setContentOffset:CGPointMake(0, 0) animated:NO];
          }];
         
         
     }];
    [txtlbl setHidden:YES];
    
}




- (void)textViewDidEndEditing:(UITextView *)textView
{
    if(textView.text.length==0){
        [txtlbl setHidden:NO];
    }
    [textView resignFirstResponder];
}


-(void)replymessage:(NSString *)Message
{
    
    if(![msgtextview.text length]>0){
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [SVProgressHUD showErrorWithStatus:@"Please write a message"];
            [messagelist setContentOffset:CGPointMake(0, 0) animated:NO];
        });
        
        
    }else{
        if ([self isConnectedToInternet])
        {
            //    NSError *Error;
            @try
            {
                NSString *URL=[NSString stringWithFormat:@"%@user.php?mode=sendmeesageReply&id=%@&userid=%@&message=%@", API, Message, [self LoggedId],[[msgtextview.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                NSLog(@"%@", URL);
                
                NSData *data=[NSData dataWithContentsOfURL:[NSURL URLWithString:URL]];
                if([data length]>0)
                {
                    
                    NSMutableDictionary *sendmessage = [[NSMutableDictionary alloc]init];
                    
                    [sendmessage setValue:@""forKey:@"id"];
                    [sendmessage setValue:[self LoggedId]forKey:@"SenderId"];
                    [sendmessage setValue:[self RemoveNullandreplaceWithSpace:[self LoggerName]] forKey:@"SenderName"];
                    
                    [sendmessage setValue:[self RemoveNullandreplaceWithSpace:useImage] forKey:@"SenderImage"];
                    [sendmessage setValue:@"" forKey:@"subject"];
                    [sendmessage setValue:[self RemoveNullandreplaceWithSpace:msgtextview.text] forKey:@"message"];
                    [sendmessage setValue:@"1 minute ago" forKey:@"SendDate"];
                    [sendmessage setValue:@"" forKey:@"isunread"];
                    [messagearray addObject:sendmessage];
                    
                    [self performSelectorOnMainThread:@selector(insertintotable) withObject:nil waitUntilDone:YES];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [SVProgressHUD showSuccessWithStatus:@"Message sent successfully!"];//[OutputDic valueForKey:@"message"]];
                    });
                    
                }
                
            }@catch (NSException *exception) {
                [SVProgressHUD dismiss];
                NSLog(@" %s exception %@",__PRETTY_FUNCTION__,exception);
            }
        }else
        {
            [SVProgressHUD showErrorWithStatus:@"No internet connection"];
        }
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)BackToprivious:(id)sender
{
    //[self PerformGoBack];
    [self dismissViewControllerAnimated:YES completion:^{
        [SVProgressHUD dismiss];
    }];
}

- (IBAction)post:(id)sender{
    
    
    if((!IsIphone5)?footerview.frame.origin.y<435.0f:footerview.frame.origin.y<523.0f){
        [UIView animateWithDuration:.35f animations:^{
            CGRect rect1 = footerview.frame;
            rect1.origin.y += 215;
            footerview.frame = rect1;
            
            
        }completion:^(BOOL finish)
         {
             if(ISscroll==TRUE){
                 CGRect frame=[messagelist frame];
                 if(IsIphone5)
                     frame.size.height=458;
                 else
                     frame.size.height=378;
                 messagelist.frame=frame;
                 ISscroll=FALSE;
             }
             // [messagelist setContentOffset:CGPointMake(0, 0) animated:NO];
             
         }];
    }
    [msgtextview resignFirstResponder];
    NSInvocationOperation *operation=[[NSInvocationOperation alloc]initWithTarget:self selector:@selector(replymessage:) object:messageid];
    [OperationQ addOperation:operation];
    
}
//message details page

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    
    if([text isEqualToString:@"\n"])
    {
        
        [textView resignFirstResponder];
        CGRect rect1 = footerview.frame;
        rect1.origin.y += 215;
        [UIView animateWithDuration:.35 animations:^{
            footerview.frame = rect1;
            if(ISscroll==TRUE){
                CGRect frame=[messagelist frame];
                if(IsIphone5)
                    frame.size.height=458;
                else
                    frame.size.height=378;
                messagelist.frame=frame;
                ISscroll=FALSE;
            }
            
        }
                         completion:^(BOOL finish)
         {
             
             [messagelist setContentOffset:CGPointMake(0, 0) animated:NO];
         }];
        NSLog(@"text length %lu",(unsigned long)textView.text.length);
        if(textView.text.length>1){
            NSInvocationOperation *operation=[[NSInvocationOperation alloc]initWithTarget:self selector:@selector(replymessage:) object:messageid];
            [OperationQ addOperation:operation];
        }
        return NO;
    }
    
    return YES;
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    ISscroll=TRUE;
    if(IsIphone5){
        if(footerview.frame.origin.y<523){
            CGRect frame=scrollView.frame;
            frame.size.height=240;
            scrollView.frame=frame;
        }
    }else{
        if(footerview.frame.origin.y<435){
            CGRect frame=scrollView.frame;
            frame.size.height=140;
            scrollView.frame=frame;
        }
    }
    
}


@end
