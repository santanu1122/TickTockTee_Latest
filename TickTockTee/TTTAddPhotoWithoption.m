//
//  TTTAddPhotoWithoption.m
//  TickTockTee
//
//  Created by macbook_ms on 27/03/14.
//  Copyright (c) 2014 com.esolz.TickTockTee. All rights reserved.
//

#import "TTTAddPhotoWithoption.h"
#import "SVProgressHUD.h"
#import "TTTGlobalMethods.h"
#import <CoreLocation/CoreLocation.h>
@interface TTTAddPhotoWithoption ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,UITextFieldDelegate,CLLocationManagerDelegate>
{
    BOOL newMedia;
    BOOL IsAllowUserLocation;
    UIImage *DefaultSectionImage;
    NSOperationQueue *operationUploadimage;
    TTTGlobalMethods *Method;
}
@property (strong, nonatomic) IBOutlet UILabel *AddPhototext;


@property (strong, nonatomic) IBOutlet UIImageView *PhocaptionImgView;
@property (strong, nonatomic) IBOutlet UIImageView *CheckSigninImgeClick;

@property (strong, nonatomic) IBOutlet UIView *ScreenView;
@property (strong, nonatomic) IBOutlet UITextField *EnterCaptionTxtfield;
@property (strong, nonatomic) CLLocationManager *locationManager;


@end

@implementation TTTAddPhotoWithoption
@synthesize EnterCaptionTxtfield,CheckSigninImgeClick,PhocaptionImgView,AddPhototext;
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
    IsAllowUserLocation=FALSE;
    newMedia=FALSE;
    operationUploadimage=[[NSOperationQueue alloc]init];
    DefaultSectionImage=[UIImage imageNamed:@"add-photo"];
    Method=[[TTTGlobalMethods alloc]init];
    [PhocaptionImgView setImage:DefaultSectionImage];
    AddPhototext.font=[UIFont fontWithName:MYREADPROREGULAR size:17.0f];
    [EnterCaptionTxtfield setTextColor:[UIColor whiteColor]];
    [EnterCaptionTxtfield setFont:[UIFont fontWithName:MYRIARDPROLIGHT size:17.0f]];
    [EnterCaptionTxtfield setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
     CheckSigninImgeClick.hidden=YES;
    
    
}


-(void)getLocationByLatLong
{
    @try
    {
        self.locationManager =[[CLLocationManager alloc]init];
        CLLocation *Location=[self.locationManager location];
        NSLog(@"location manager.location:%f",[Location coordinate].latitude);
        if([Location coordinate].latitude!=0.0f && [Location coordinate].longitude!=0.0f)
        {
            NSString *URLString=[NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?latlng=%f,%f&sensor=false", [Location coordinate].latitude, [Location coordinate].longitude];
            NSLog(@"the string url for the event:%@",URLString);
            NSData *getData=[NSData dataWithContentsOfURL:[NSURL URLWithString:URLString]];
            
            NSDictionary *Output=[NSJSONSerialization JSONObjectWithData:getData options:kNilOptions error:nil];
            
            
            
            NSArray *Result=[Output objectForKey:@"results"];
            NSDictionary *Dic1=[Result objectAtIndex:0];
            NSArray *address_components=[Dic1 objectForKey:@"address_components"];
            NSMutableArray *AddressArray=[[NSMutableArray alloc] initWithCapacity:3];
            
            for(NSDictionary *Dic2 in address_components)
            {
                NSArray *TypesArray=[Dic2 objectForKey:@"types"];
                if([(NSString *)[TypesArray objectAtIndex:0] isEqualToString:@"locality"] || [(NSString *)[TypesArray objectAtIndex:0] isEqualToString:@"administrative_area_level_1"])
                {
                    [AddressArray addObject:[Dic2 objectForKey:@"long_name"]];
                }
                
            }
            NSString *NewAddress=[AddressArray componentsJoinedByString:@", "];
            
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSUserDefaults *User=[[NSUserDefaults alloc] init];
                [User setValue:NewAddress forKey:SESSION_USERLOCAION];
                NSLog(@"the new address is:%@",NewAddress);
                [User synchronize];
                
            });
        }
        else
        {
//                        NSInvocationOperation *Invoc=[[NSInvocationOperation alloc] initWithTarget:self selector:@selector(getLocationByLatLong) object:nil];
//                        [op addOperation:Invoc];
        }
    }
    @catch (NSException *juju)
    {
        NSLog(@"Reporting juju from getLocationByLatLong: %@", juju);
    }
}


#pragma mark form Thread Segment

-(void)CreateAlbum
{
    @try
    {
        NSString *URLString = [NSString stringWithFormat:@"%@user.php?mode=createnewalbum&userid=%@", API, [self LoggedId]];
        NSLog(@"The url String:%@",URLString);
        NSData *getData=[[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:URLString]];
        NSDictionary *Output=[NSJSONSerialization JSONObjectWithData:getData options:kNilOptions error:nil];
        NSLog(@"%@", Output);
        int AlbumId=[[Output valueForKey:@"albumid"] integerValue];
        
        if(AlbumId>0)
        {
            NSInvocationOperation *UploadOperation;
             NSMutableDictionary *ObjectCarrier=[[NSMutableDictionary alloc] initWithCapacity:3];
                [ObjectCarrier setObject:UIImageJPEGRepresentation(PhocaptionImgView.image, 0.4) forKey:@"Data"];
                [ObjectCarrier setObject:[Method Encoder:EnterCaptionTxtfield.text] forKey:@"caption"];
                [ObjectCarrier setValue:[NSString stringWithFormat:@"%d", AlbumId] forKey:@"AlbumId"];
            
                UploadOperation=[[NSInvocationOperation alloc] initWithTarget:self selector:@selector(UploadMyImage:) object:ObjectCarrier];
                [operationUploadimage addOperation:UploadOperation];
            
  
                
           
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[self view] setUserInteractionEnabled:YES];
                [SVProgressHUD showErrorWithStatus:@"Unexpeted Error Occured"];
            });
        }
    }
    @catch (NSException *juju)
    {
        NSLog(@"Reporting juju from Create Album : %@", juju);
    }
}


-(void)UploadMyImage:(NSDictionary *)ObjectReceiver
{
    @try
    {
        
        NSString *URLString=[NSString stringWithFormat:@"%@index.php?option=com_community&view=photos&task=jsonalbumPhotoUpload&userid=%@&albumid=%@&tmpl=component&show_location=%@&caption=%@&location=%@", BASEURL, [self LoggedId], [ObjectReceiver valueForKey:@"AlbumId"], (IsAllowUserLocation)?@"1":@"0", [ObjectReceiver valueForKey:@"caption"], [Method Encoder:[self LoggerCurrentLocation]]];
        NSLog(@"%@", URLString);
        
        NSData *ImageData=(NSData *)[ObjectReceiver objectForKey:@"Data"];
        
        NSURL* requestURL = [NSURL URLWithString:URLString];
        
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
        
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"Files\"; filename=\"Mobile Upload.jpg\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        
        [body appendData:[[NSString stringWithFormat:@"Content-Type: image/png\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        
        [body appendData:[NSData dataWithData:ImageData]];
        
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        [request setHTTPBody:body];
        
        [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        
        [self performSelectorOnMainThread:@selector(ResponseReceived) withObject:nil waitUntilDone:YES];
    }
    @catch (NSException *juju)
    {
        NSLog(@"Reporting juju from UploadMyImage %@", juju);
    }
}


-(void)ResponseReceived
{
    
    [SVProgressHUD dismiss];
    [[self view] setUserInteractionEnabled:YES];
    [self dismissViewControllerAnimated:YES completion:^{
        
        
        [SVProgressHUD showSuccessWithStatus:@"image successfully uploaded"];
        
    }];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)AddPhotoButton:(id)sender
{
    [self OpenImageUploadOption];
    
}


- (IBAction)gobackToPrivioudpage:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (IBAction)CencelSelactopn:(id)sender
{
    [
     
     self dismissViewControllerAnimated:YES completion:^{
        
        
    }];
    
}

//Done button click to Save the image in server mobile/image folder

- (IBAction)DoneSelectionButton:(id)sender
{
    if (PhocaptionImgView.image==DefaultSectionImage)
    {
        [SVProgressHUD showErrorWithStatus:@"Please select an image to upload first!"];
    }
    else
    {
      
          [SVProgressHUD showWithStatus:@"Please wait..."];
           NSInvocationOperation *Invocation=[[NSInvocationOperation alloc]initWithTarget:self selector:@selector(CreateAlbum) object:nil];
          [operationUploadimage addOperation:Invocation];
        
        
       
    }
    
}

//All The user to Select the location of user

- (IBAction)ShowlocationButtonclick:(id)sender
{
    if (IsAllowUserLocation==FALSE)
    {
        IsAllowUserLocation=TRUE;
        CheckSigninImgeClick.hidden=NO;
        if ([[self LoggerCurrentLocation] length]==0)
        {
            NSInvocationOperation *LocationInvocation=[[NSInvocationOperation alloc]initWithTarget:self selector:@selector(getLocationByLatLong) object:nil];
            [operationUploadimage addOperation:LocationInvocation];
        }
        
    }
    else
    {
        IsAllowUserLocation=FALSE;
        CheckSigninImgeClick.hidden=YES;
        
    }
    
}

//Perform Photo Operation

- (void)OpenImageUploadOption
{
    NSString *actionSheetTitle = @"Choose an option";
    NSString *destructiveTitle = @"Cancel";
    NSString *other1 = @"Use Camera";
    NSString *other2 = @"User Camera Roll";
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:actionSheetTitle
															 delegate:self
													cancelButtonTitle:destructiveTitle
											   destructiveButtonTitle:nil
													otherButtonTitles:other1, other2, nil];
    
    
    
    [actionSheet showFromRect:CGRectMake(0.0f, 0.0f, 0.0f, 0.0f) inView:self.ScreenView animated:YES];
}



#pragma mark UIActionSheetDelegate Methods
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
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


//use method when u want to open camara

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
//use method when you want to add image from library

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

//method For Set the image in Desire image view here PhocaptionImgView.

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:Nil];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    if (newMedia)
        
        UIImageWriteToSavedPhotosAlbum(image,
                                       self,
                                       @selector(image:finishedSavingWithError:contextInfo:),
                                       nil);
    
    [PhocaptionImgView setImage:image];
    
  
}
//Dismiss image picker model IOS Defalds

- (void)imagePickerControllerDidCancel:(UIImagePickerController*)picker
{
    [picker dismissViewControllerAnimated:YES completion:Nil];
}

//call When image pick Finish picking image user for showing error if come at upload time

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

//UITextField Delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}





@end
