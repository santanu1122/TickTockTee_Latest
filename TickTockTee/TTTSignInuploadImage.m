//
//  TTTSignInuploadImage.m
//  TickTockTee
//
//  Created by macbook_ms on 20/02/14.
//  Copyright (c) 2014 com.esolz.TickTockTee. All rights reserved.
  //http://www.esolzdemos.com/lab3/ttt/ticktockteeV2/index.php?option=com_community&view=profile&task=uploadAvatar&userid=374&tmpl=component&Filedata=

#import "TTTSignInuploadImage.h"
#import "TTTSigninViewController.h"
#import "TTTGlobalMethods.h"
#import "TTTActivityStreem.h"


@interface TTTSignInuploadImage ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
   
    TTTGlobalMethods *Method;
    BOOL newMedia;
    UIView *Overlay;
    NSOperationQueue *OperationQueue;
    UIImage *BackGround;
    NSOperationQueue *operation;
    UIImage *imageFordownload;
    NSString *Registerdurl;

}
@property (strong, nonatomic) IBOutlet UIButton *SkipButton;
@property (strong, nonatomic) IBOutlet UIImageView *ProfileImageView;
@property (weak, nonatomic) IBOutlet UILabel *UploadPicLable;
@property (weak, nonatomic) IBOutlet UILabel *skiplbl;


@end

@implementation TTTSignInuploadImage
@synthesize skiplbl=_skiplbl;
@synthesize UploadPicLable=_UploadPicLable;
@synthesize ProfileImageView =_ProfileImageView;
@synthesize isUpdate;
@synthesize imageThumb;
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
    operation=[[NSOperationQueue alloc]init];
    newMedia=YES;
    BackGround=[UIImage imageNamed:@"profile-pic-without-text.png"];
    Method=[[TTTGlobalMethods alloc]init];
    OperationQueue=[[NSOperationQueue alloc]init];
   
   _UploadPicLable.font=[UIFont fontWithName:@"MyriadPro-Regular" size:15.0f];
    _skiplbl.font=[UIFont fontWithName:@"MyriadPro-Regular" size:18.0f];
   
    if (isUpdate)
    {

        NSLog(@"%@",imageThumb);
         [self SetroundborderWithborderWidth:4.0f WithColour:UIColorFromRGB(0xe4f5f4) ForImageview:_ProfileImageView];
         [_ProfileImageView setImage:[UIImage imageWithData:[self LoggerProfileImageData]]];
        [_UploadPicLable setText:@"Click to upload profile picture"];
        [_skiplbl setHidden:YES];
        [_SkipButton setHidden:YES];
        
    }
    else
    {
        [_UploadPicLable setText:@"Upload your Profile Picture"];
        [_skiplbl setHidden:NO];
        [_SkipButton setHidden:NO];
        
    }
    
    
}

-(void)DownloadThumb
{
     NSData *data=[NSData dataWithContentsOfURL:[NSURL URLWithString:imageThumb]];
     imageFordownload=[UIImage imageWithData:data];
    [self performSelectorOnMainThread:@selector(Setimage) withObject:nil waitUntilDone:YES];
                    
}
-(void)Setimage
 {
     [_ProfileImageView setImage:imageFordownload];
 }

- (IBAction)TapButton:(id)sender
{
    [self openactionSet];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)GotProfilePic:(id)sender
{
    
    if([_ProfileImageView image]!=BackGround)
    {
        Overlay=[[UIView alloc] initWithFrame:[[self view] frame]];
        [Overlay setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.0f]];
        [self.view addSubview:Overlay];
        
        
        UIActivityIndicatorView *Spinner=[[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(150.0f, 100.0f, 30.0f, 30.0f)];
        [Spinner setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
        [Spinner startAnimating];
        [Overlay addSubview:Spinner];
        
        [UIView animateWithDuration:0.5f animations:^{
            
            [Overlay setBackgroundColor:[[UIColor blackColor]colorWithAlphaComponent:0.7f]];
            
        }];
        
         NSUserDefaults *UserId = [NSUserDefaults standardUserDefaults];
         [UserId setObject:[Method ConvertImageToNSData:[_ProfileImageView image]] forKey:SESSION_LOGGERIMAGEDATA];
         [UserId synchronize];
         NSInvocationOperation *Op=[[NSInvocationOperation alloc] initWithTarget:self selector:@selector(UploadMyImage) object:nil];
         [OperationQueue addOperation:Op];
    }
    else
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Sorry" message:@"Please Select an Image First!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }

    
}


-(void)openactionSet
{
   
    NSString *actionSheetTitle = @"Choose an option";    // Action Sheet Title
    NSString *destructiveTitle = @"Cancel";             // Action Sheet Button Titles
    NSString *other1 = @"Use Camera";
    NSString *other2 = @"User Camera Roll";
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:actionSheetTitle
															 delegate:self
													cancelButtonTitle:nil
											   destructiveButtonTitle:destructiveTitle
													otherButtonTitles:other1, other2, nil];
    CGRect actionRect = [self.view convertRect:[_ProfileImageView frame]  fromView:[_ProfileImageView superview]];
    [actionSheet showFromRect:actionRect inView:self.view animated:YES];
}


- (IBAction)SkipToActivity:(id)sender
{
    
    TTTActivityStreem *activity=[[TTTActivityStreem alloc]initWithNibName:@"TTTActivityStreem" bundle:nil];
    [self.navigationController pushViewController:activity animated:YES];
    
}

- (IBAction)BackToPrivious:(id)sender
{
    
//    TTTSigninViewController *SignIN=[[TTTSigninViewController alloc]init];
//    [self PushViewController:SignIN TransitationFrom:kCATransitionFade];
    [self PerformGoBack];
    
   
    
}
//
-(void)UploadMyImage
{
    @try
    {
       
        if (isUpdate)
        {
           Registerdurl=[NSString stringWithFormat:@"%@index.php?option=com_community&view=profile&task=uploadappAvatar&userid=%d&tmpl=component", BASEURL, [[self LoggedId] integerValue]];
        }
        else
        {
        Registerdurl=[NSString stringWithFormat:@"%@index.php?option=com_community&view=register&task=uploadappAvatar&userid=%d&tmpl=component", BASEURL, [[self LoggedId] integerValue]];
        }
        NSLog(@"%@", Registerdurl);
        
        
        NSURL* requestURL = [NSURL URLWithString:Registerdurl];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
        [request setHTTPShouldHandleCookies:NO];
        [request setURL:requestURL];
        [request setTimeoutInterval:30];
        [request setHTTPMethod:@"POST"];
        NSURLResponse *response = nil;
        NSError *error;
        
        NSString *boundary = [NSString stringWithFormat:@"%0.9u",arc4random()];
        
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
        
        [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
        
        
        
        NSMutableData *body = [NSMutableData data];
        
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        if (isUpdate)
        {
          [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"image_upload\"; Filedata=\"sampleImage.jpg\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        }
        else
        {
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"image_upload\"; filename=\"sampleImage.jpg\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        }
        
        [body appendData:[[NSString stringWithFormat:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        
        [body appendData:[NSData dataWithData:[Method ConvertImageToNSData:[_ProfileImageView image]]]];
        
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        [request setHTTPBody:body];
        
        
        NSData *getData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        
        
        NSString *str=[[NSString alloc] initWithData:getData encoding:NSUTF8StringEncoding];
        NSLog(@"ImageUploader:: %@", str);
        
        [self performSelectorOnMainThread:@selector(RedirectMe) withObject:nil waitUntilDone:YES];
    }
    @catch (NSException *juju)
    {
        NSLog(@"Reporting juju from UploadMyImage %@", juju);
    }
}


#pragma mark for Main Thread Segments

-(void)RedirectMe
{
    //[SVProgressHUD dismiss];
         if (isUpdate)
    {
        [self PerformGoBack];
    }
    else
    {
        TTTActivityStreem *ActivityStreamViewNib=[[TTTActivityStreem alloc] init];
        [[self navigationController] pushViewController:ActivityStreamViewNib animated:YES];

    }
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //Get the name of the current pressed button
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    
    if ([buttonTitle isEqualToString:@"Cancel"])
    {
        NSLog(@"Canceled");
    }
    if ([buttonTitle isEqualToString:@"Use Camera"])
    {
        NSLog(@"Open Camera");
        [self OpenCamera];
    }
    if ([buttonTitle isEqualToString:@"User Camera Roll"])
    {
        NSLog(@"Open Camera Roll");
        [self OpenCameraRoll];
    }
 
}

-(void)OpenCamera
{
    @try
    {
        newMedia=YES;
        BOOL hasCamera = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
        UIImagePickerController* picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = hasCamera ? UIImagePickerControllerSourceTypeCamera :    UIImagePickerControllerSourceTypePhotoLibrary;
        
        [self presentViewController:picker animated:YES completion:^{
            
        }];
    }
    @catch (NSException *juju)
    {
        NSLog(@"%@", juju);
    }
}

-(void)OpenCameraRoll
{
    @try
    {
        newMedia=FALSE;
        UIImagePickerController* picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.sourceType =    UIImagePickerControllerSourceTypePhotoLibrary;
        picker.allowsEditing = YES;
        [self presentViewController:picker animated:YES completion:^{
            
        }];
    }
    @catch (NSException *juju)
    {
        NSLog(@"%@", juju);
    }
}

#pragma  Picker delegate methods
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    [picker dismissViewControllerAnimated:YES completion:Nil];
     UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    
     if (newMedia)
        
        UIImageWriteToSavedPhotosAlbum(image,
                                       self,
                                       @selector(image:finishedSavingWithError:contextInfo:),
                                       nil);
    
    
    
    
    [self SetroundborderWithborderWidth:4.0f WithColour:UIColorFromRGB(0xe4f5f4) ForImageview:_ProfileImageView];
    

    [_ProfileImageView setImage:image];
    
    
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController*)picker
{
    [picker dismissViewControllerAnimated:YES completion:Nil];
}


-(void)image:(UIImage *)image finishedSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error)
    {
        UIAlertView *alert = [[UIAlertView alloc]
                              
                              initWithTitle: @"Save failed"
                              
                              message: @"Failed to save image"
                              
                              delegate: nil
                              
                              cancelButtonTitle:@"OK"
                              
                              otherButtonTitles:nil];
        
        [alert show];
    }
}


@end
