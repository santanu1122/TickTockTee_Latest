//
//  TTTCretenewmessage.m
//  TickTockTee
//
//  Created by macbook_ms on 04/04/14.
//  Copyright (c) 2014 com.esolz.TickTockTee. All rights reserved.
//

#import "TTTCretenewmessage.h"
#import "TTTGlobalViewController.h"
#import "TTTGlobalMethods.h"
#import "TTTAddFriend.h"
#import "AFNetworking.h"
#import "AFImageRequestOperation.h"


@interface TTTCretenewmessage ()<UITextFieldDelegate, UITextViewDelegate>
{
    BOOL ISViewUP;
    NSString *FriendIds;
    NSMutableArray *SelectedFriends;
    NSOperationQueue *Operationmessagesent;
    NSString *senderID;
    TTTGlobalMethods *Method;
}
@property (strong, nonatomic) IBOutlet UILabel *Createnewmsgtextlbl;
@property (strong, nonatomic) IBOutlet UIScrollView *Numboroffriendscroll;
@property (strong, nonatomic) IBOutlet UITextField *Subjecttextfield;
@property (strong, nonatomic) IBOutlet UITextView *messageTxt;

@property (strong, nonatomic) IBOutlet UIView *sentorcancelmessageview;
@property (strong, nonatomic) IBOutlet UIButton *plusbutton;

@property (strong, nonatomic) IBOutlet UILabel *LblText;
@end

@implementation TTTCretenewmessage
@synthesize messageTxt,Subjecttextfield,Numboroffriendscroll,Createnewmsgtextlbl,MessageSenderid,recivername,Reciverurl,Friendimageurl,friendName;

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
    
    NSArray *Array=[Numboroffriendscroll subviews];
    if ([Array count]>1)
    {
        for (UIView *Imgview in Array)
        {
            [Imgview removeFromSuperview];
        }
        
    }
    SelectedFriends=[[NSMutableArray alloc]init];
   

    if (MessageSenderid.length>0)
    {
        FriendIds=MessageSenderid;
        self.plusbutton.hidden=YES;
        [self loaduserdetailsforparticularuser];
        
    }
    else
    {
         NSUserDefaults *userDefals=[NSUserDefaults standardUserDefaults];
         Operationmessagesent=[[NSOperationQueue alloc]init];
         self.plusbutton.hidden=NO;
         NSDictionary *SessionParam=[userDefals objectForKey:SESSION_MATCHCREATEPARAMETES];
         FriendIds=[SessionParam valueForKey:PARAM_SELECTED_FRIENDS];
         FriendIds=[SessionParam valueForKey:PARAM_SELECTED_FRIENDS];
         [userDefals synchronize];
          NSInvocationOperation *Operation=[[NSInvocationOperation alloc] initWithTarget:self selector:@selector(getMyFriends) object:nil];
         [Operationmessagesent addOperation:Operation];
    }
    
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.Subjecttextfield setFont:[UIFont fontWithName:SEGIOUI size:15]];
    [self.Subjecttextfield setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.messageTxt setFont:[UIFont fontWithName:SEGIOUI size:15.0f]];
    [self.LblText setFont:[UIFont fontWithName:SEGIOUI size:15.0f]];
    Method=[[TTTGlobalMethods alloc]init];
   
    ISViewUP=FALSE;
    
}

//Load all user data



-(void)LoadRequest
{
    int i=0;
    for (TTTGlobalMethods *localmathod in SelectedFriends)
    {
       
        UIView *messageto=[[[NSBundle mainBundle] loadNibNamed:@"EtendedDesignView" owner:self options:nil] objectAtIndex:12];
        [messageto setFrame:CGRectMake(i*messageto.frame.size.width, 0, messageto.frame.size.width, messageto.frame.size.height)];
        UIView *Backview=(UIView *)[messageto viewWithTag:10];
        [self SetroundborderWithborderWidth:2.0f WithColour:[UIColor whiteColor] ForView:Backview];
        UIImageView *Myimage=(UIImageView *)[messageto viewWithTag:11];
        [self SetroundborderWithborderWidth:2.0f WithColour:[UIColor clearColor] ForImageview:Myimage];
        
        //Createing the spinner
        
        UIActivityIndicatorView *SpinnerView=[[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(12, 12, 20, 20)];
        [Myimage addSubview:SpinnerView];
        [SpinnerView startAnimating];
        [SpinnerView hidesWhenStopped];
        
        //Download friend image cell
        
        NSURLRequest *request_img = [NSURLRequest requestWithURL:[NSURL URLWithString:localmathod.FriendImageURL]];
        AFImageRequestOperation *operation = [AFImageRequestOperation imageRequestOperationWithRequest:request_img
                                                                                  imageProcessingBlock:nil
                                                                                               success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                                                                   if(image!=nil)
                                                                                                   {
                                                                                                       [Myimage setImage:image];
                                                                                                       [SpinnerView stopAnimating];
                                                                                                       [SpinnerView setHidden:YES];
                                                                                                   }
                                                                                                   
                                                                                               }
                                                                                               failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                                                                                   NSLog(@"Error %@",error);
                                                                                                   [SpinnerView stopAnimating];
                                                                                                   
                                                                                                   
                                                                                               }];
        [operation start];
        

        
        UILabel *nameLbl=(UILabel *)[messageto viewWithTag:12.0f];
        nameLbl.font=[UIFont fontWithName:MYRIARDPROSAMIBOLT size:15.0f];
        nameLbl.text=localmathod.FriendName;
        [Numboroffriendscroll addSubview:messageto];
        i++;
    }
    [Numboroffriendscroll setContentSize:CGSizeMake([SelectedFriends count]*210,58)];
}
//Load for particular user

-(void)loaduserdetailsforparticularuser
{
    
        
        UIView *messageto=[[[NSBundle mainBundle] loadNibNamed:@"EtendedDesignView" owner:self options:nil] objectAtIndex:12];
        [messageto setFrame:CGRectMake(0, 0, messageto.frame.size.width, messageto.frame.size.height)];
        UIView *Backview=(UIView *)[messageto viewWithTag:10];
        [self SetroundborderWithborderWidth:2.0f WithColour:[UIColor whiteColor] ForView:Backview];
        UIImageView *Myimage=(UIImageView *)[messageto viewWithTag:11];
        [self SetroundborderWithborderWidth:2.0f WithColour:[UIColor clearColor] ForImageview:Myimage];
        
        //Createing the spinner
        
        UIActivityIndicatorView *SpinnerView=[[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(12, 12, 20, 20)];
        [Myimage addSubview:SpinnerView];
        [SpinnerView startAnimating];
        [SpinnerView hidesWhenStopped];
        
        //Download friend image cell
        
        NSURLRequest *request_img = [NSURLRequest requestWithURL:[NSURL URLWithString:Friendimageurl]];
        AFImageRequestOperation *operation = [AFImageRequestOperation imageRequestOperationWithRequest:request_img
                                                                                  imageProcessingBlock:nil
                                                                                               success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                                                                   if(image!=nil)
                                                                                                   {
                                                                                                       [Myimage setImage:image];
                                                                                                       [SpinnerView stopAnimating];
                                                                                                       [SpinnerView setHidden:YES];
                                                                                                   }
                                                                                                   
                                                                                               }
                                                                                               failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                                                                                   NSLog(@"Error %@",error);
                                                                                                   [SpinnerView stopAnimating];
                                                                                                   
                                                                                                   
                                                                                               }];
        [operation start];
        
        
        
        UILabel *nameLbl=(UILabel *)[messageto viewWithTag:12.0f];
        nameLbl.font=[UIFont fontWithName:MYRIARDPROSAMIBOLT size:15.0f];
        nameLbl.text=friendName;
        [Numboroffriendscroll addSubview:messageto];
    

}


-(void)getMyFriends
{
    @try
    {
        if ([self isConnectedToInternet])
        {
           
            NSString *URL=[NSString stringWithFormat:@"%@user.php?mode=friends&userid=%@", API, [self LoggedId]];
            NSLog(@"Show all friend array:%@",URL);

                NSData *getData=[NSData dataWithContentsOfURL:[NSURL URLWithString:URL]];
                
                if([getData length]>2)
                {
                    [SelectedFriends removeAllObjects];
                    NSLog(@"the friend ids:%@",FriendIds);
                    NSDictionary *Output=[NSJSONSerialization JSONObjectWithData:getData options:kNilOptions error:nil];
                    NSArray *SelectedFriendsArray=[FriendIds componentsSeparatedByString:@","];
                    NSLog(@"the selected friend array:%@",SelectedFriendsArray);
                    for(NSDictionary *var in [Output valueForKey:@"friendslist"])
                    {
                        if([self IsSelectedFriendsWithId:[var objectForKey:@"FriendId"] From:SelectedFriendsArray])
                            [SelectedFriends addObject:[[TTTGlobalMethods alloc] initWithId:[var objectForKey:@"FriendId"] withFriendName:[var objectForKey:@"FriendName"] withFriendImageURL:[var objectForKey:@"FriendImage"] withNoOfFriends:[var objectForKey:@"Totalfriends"] withFriendId:[var objectForKey:@"FriendId"]]];
                    }
                    NSLog(@"The selected friend array count:%d",[SelectedFriends count]);
                    
                    [self performSelectorOnMainThread:@selector(LoadRequest) withObject:nil waitUntilDone:YES];
                }
  
            }
             else
             {
                 [SVProgressHUD showErrorWithStatus:@"un expected error occur"];
             }
          
           
 
        
    }
    @catch (NSException *juju)
    {
        NSLog(@"Reporting juju from getLocation : %@", juju);
    }
}

-(BOOL)IsSelectedFriendsWithId:(NSString *)Id From:(NSArray *)tempSelectedFriendsArray
{
    for(NSString *friendId in tempSelectedFriendsArray)
    {
        if([friendId isEqualToString:Id])
        {
            return TRUE;
        }
    }
    return false;
}



-(void)UptheCencelOrdoneview
{
    CGRect Frame1=[self.sentorcancelmessageview frame];
    if (ISViewUP==FALSE)
    {
        Frame1.origin.y=311;
        [UIView animateWithDuration:0.18f animations:^{
            [[self sentorcancelmessageview] setFrame:Frame1];
            
        }
        completion:^(BOOL finish)
        {
            ISViewUP=TRUE;
        }];
    }
    else
    {
        Frame1.origin.y=529;
        [UIView animateWithDuration:0.18f animations:^{
            [[self sentorcancelmessageview] setFrame:Frame1];
            
        }
                         completion:^(BOOL finish)
         {
             ISViewUP=FALSE;
         }];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}
- (IBAction)performgoback:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        [SVProgressHUD dismiss];
        
    }];
}

- (IBAction)AddNewfriend:(id)sender
{
    TTTAddFriend *AddFriend=[[TTTAddFriend alloc]init];
    [self presentViewController:AddFriend animated:YES completion:^{
        [SVProgressHUD dismiss];
        
    }];
}
//Sent button click

- (IBAction)SentMessageButtonclick:(id)sender
{
    
    BOOL Abaltopost=TRUE;
    if (![Subjecttextfield.text length]>0)
    {
        Abaltopost=FALSE;
        [SVProgressHUD showErrorWithStatus:@"Subject should not be left blank"];
    }
    else if (![messageTxt.text length]>0)
    {
        Abaltopost=FALSE;
         [SVProgressHUD showErrorWithStatus:@"Sorry you can't post a blank message"];
    }
    if (Abaltopost)
    {
        [SVProgressHUD showWithStatus:@"sending.."];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
           NSError *Errordata;
           NSString *Sendmessage=[NSString stringWithFormat:@"%@user.php?mode=sendnewmeesage&userid=%@&subject=%@&message=%@&friends=%@",API,[self LoggedId],[Method Encoder:Subjecttextfield.text],[Method Encoder:messageTxt.text],FriendIds];
           NSLog(@"The value of send message:%@",Sendmessage);
           NSData *deta=[NSData dataWithContentsOfURL:[NSURL URLWithString:Sendmessage]];
           if (deta.length>2)
           {
               NSDictionary *mutDic=[NSJSONSerialization JSONObjectWithData:deta options:kNilOptions error:&Errordata];
               NSString *status=[mutDic valueForKey:@"status"];
               NSString *message=[mutDic valueForKey:@"message"];
               if ([status isEqualToString:@"error"])
               {
                   dispatch_async(dispatch_get_main_queue(), ^{
                       
                       [SVProgressHUD showErrorWithStatus:message];
                       [SVProgressHUD dismiss];
                   });
                   
               }
               else
               {
                   dispatch_async(dispatch_get_main_queue(), ^{
                       [SVProgressHUD showSuccessWithStatus:message];
                       [self dismissViewControllerAnimated:YES completion:^{
                           [SVProgressHUD dismiss];
                           
                       }];
                       
                   });
                   
               }
               
               
           }

          
         // [self sentorcancelmessageview];
      });
    }
    
}
-(void)SentmessagetoId
 {
     if ([self isConnectedToInternet])
     {
         @try
         {
             NSError *Errordata;
             NSString *Sendmessage=[NSString stringWithFormat:@"%@user.php?mode=sendnewmeesage&userid=%@&subject=%@&message=%@&friends=%@",API,[self LoggedId],[Method Encoder:Subjecttextfield.text],[Method Encoder:messageTxt.text],FriendIds];
             NSLog(@"The value of send message:%@",Sendmessage);
             NSData *deta=[NSData dataWithContentsOfURL:[NSURL URLWithString:Sendmessage]];
             if (deta.length>2)
             {
                 NSDictionary *mutDic=[NSJSONSerialization JSONObjectWithData:deta options:kNilOptions error:&Errordata];
                 NSString *status=[mutDic valueForKey:@"status"];
                 NSString *message=[mutDic valueForKey:@"message"];
                 if ([status isEqualToString:@"error"])
                 {
                     dispatch_async(dispatch_get_main_queue(), ^{
                         
                          [SVProgressHUD showErrorWithStatus:message];
                          [SVProgressHUD dismiss];
                     });
                    
                 }
                 else
                  {
                      dispatch_async(dispatch_get_main_queue(), ^{
                          [SVProgressHUD showSuccessWithStatus:message];
                          [self dismissViewControllerAnimated:YES completion:^{
                              [SVProgressHUD dismiss];
                              
                          }];
                          
                      });
 
                  }
                 
                 
             }
             
         }
         @catch (NSException *exception)
         {
             NSLog(@"i catch this:%@",exception);
         }
        
     }
     else
     {
         [SVProgressHUD showErrorWithStatus:@"no internet connection available"];
         
     }
 }


- (IBAction)CencalButtonclick:(id)sender
{
    [messageTxt resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    
}
//Textview Delegate

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    [self.LblText setHidden:YES];
    ISViewUP=FALSE;
    [self UptheCencelOrdoneview];
    
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    if (messageTxt.text.length==0)
    {
        [self.LblText setHidden:NO];
    }
    [self UptheCencelOrdoneview];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
   
    [self UptheCencelOrdoneview];
    [textField resignFirstResponder];
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
     ISViewUP=FALSE;
    [self UptheCencelOrdoneview];
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    
    if([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}





@end
