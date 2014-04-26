//
//  TTTShowphotosofalbam.m
//  TickTockTee
//
//  Created by macbook_ms on 28/03/14.
//  Copyright (c) 2014 com.esolz.TickTockTee. All rights reserved.
//

#import "TTTShowphotosofalbam.h"
#import "SVProgressHUD.h"
#import "AFNetworking.h"
#import "AFImageRequestOperation.h"
#import "TTTPhotodetailsViewController.h"

@interface TTTShowphotosofalbam ()
{
    NSMutableArray *AlbamAllphoto;
    NSString *TotalPhoto;
    NSOperationQueue *operationAlbemDetails;
    UITapGestureRecognizer *TapGesture;
    NSString *ViewerId;
}
@property (strong, nonatomic) IBOutlet UILabel *TotalPhotosLbl;
@property (strong, nonatomic) IBOutlet UILabel *MyAlbamnamelbl;
@property (strong, nonatomic) IBOutlet UIScrollView *AllPhotoscroll;

@end

@implementation TTTShowphotosofalbam
@synthesize AlbamId,Albamname,AllPhotoscroll,TotalComment,TotalPhotosLbl,paramviewId;

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
    AlbamAllphoto=[[NSMutableArray alloc]init];
    operationAlbemDetails=[[NSOperationQueue alloc]init];
    [self.MyAlbamnamelbl setFont:[UIFont fontWithName:MYREADPROREGULAR size:17.0f]];
    self.MyAlbamnamelbl.text=Albamname;
    ViewerId=([paramviewId length]>0)?paramviewId:[self LoggedId];
    [self Domyjob];
    
}
-(void)Domyjob
{
    NSInvocationOperation *ShowalbenDetails=[[NSInvocationOperation alloc]initWithTarget:self selector:@selector(getLatestPhotos) object:nil];
    [operationAlbemDetails addOperation:ShowalbenDetails];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)BacktoPriviouspage:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        [SVProgressHUD dismiss];
    }];
}
-(void)getLatestPhotos
{
    @try
    {
        
        NSString *URL=[NSString stringWithFormat:@"%@user.php?mode=getphoto&userid=%@&timezone=%@&albumid=%@&loggedin_userid=%@", API, ViewerId, [self LocalTimeZoneName],AlbamId,[self LoggedId]];
        NSLog(@"%@", URL);
        NSData *getData=[NSData dataWithContentsOfURL:[NSURL URLWithString:URL]];
        
        if([getData length]>2)
        {
            NSDictionary *Output=[NSJSONSerialization JSONObjectWithData:getData options:kNilOptions error:nil];
            NSArray *photolist=[Output objectForKey:@"photolist"];
            NSArray *Extraparam=[Output objectForKey:@"extraparam"];
            NSDictionary *ExtraparamDic=[Extraparam objectAtIndex:0];
            TotalPhoto=[ExtraparamDic valueForKey:@"total_count"];
            
            
            for(NSDictionary *var in photolist)
            {
                
                NSMutableDictionary *mutDic=[[NSMutableDictionary alloc]init];
                [mutDic setValue:[var valueForKey:@"photo_id"] forKey:@"photo_id"];
                [mutDic setValue:[var valueForKey:@"albumid"] forKey:@"albumid"];
                [mutDic setValue:[var valueForKey:@"caption"] forKey:@"caption"];
                [mutDic setValue:[var valueForKey:@"location"] forKey:@"location"];
                [mutDic setValue:[var valueForKey:@"datetime"] forKey:@"datetime"];
                [mutDic setValue:[var valueForKey:@"thumbnail"] forKey:@"thumbnail"];
                [mutDic setValue:[var valueForKey:@"original"] forKey:@"original"];
                [mutDic setValue:[var valueForKey:@"likecount"] forKey:@"likecount"];
                [mutDic setValue:[var valueForKey:@"commentcount"] forKey:@"commentcount"];
                [mutDic setValue:[var valueForKey:@"isUserLiked"] forKey:@"isUserLiked"];
                [AlbamAllphoto addObject:mutDic];
                
            }
            
            
            [self performSelectorOnMainThread:@selector(LoadPhotoScroll) withObject:nil waitUntilDone:YES];
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
                [SVProgressHUD showErrorWithStatus:@"Unexpected error occured."];
            });
        }
        
    }
    @catch (NSException *juju)
    {
        NSLog(@"Reporting juju from getLatestPhotos : %@", juju);
    }
}

-(void)LoadPhotoScroll
{
    
    [SVProgressHUD dismiss];
    CGFloat Thevalueofy=0.0f;

    int j=0;
    
    for (int i=0; i<[AlbamAllphoto count]; i++)
    {
        UIImageView *Imageviewmain=[[UIImageView alloc]init];
        
        TapGesture=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ViewPhotos:)];
        [TapGesture setNumberOfTapsRequired:1];
        [Imageviewmain setTag:i];
        [Imageviewmain addGestureRecognizer:TapGesture];
        [Imageviewmain setUserInteractionEnabled:YES];
        
        if (i%4==0&i!=0)
        {
            Thevalueofy=Thevalueofy+80;
            
            j=0;
        }
        
        
        [Imageviewmain setFrame:CGRectMake(80*j, Thevalueofy, 80, 80)];
        [AllPhotoscroll addSubview:Imageviewmain];
         UIActivityIndicatorView *Spinner=[[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(30, 30, 20, 20)];
        [Spinner startAnimating];
        [Imageviewmain addSubview:Spinner];
        NSMutableDictionary *PhotoDic=[AlbamAllphoto objectAtIndex:i];
        //Download Image in imageview
        NSURLRequest *request_img4 = [NSURLRequest requestWithURL:[NSURL URLWithString:[PhotoDic valueForKey:@"thumbnail"]]];
        AFImageRequestOperation *operation = [AFImageRequestOperation imageRequestOperationWithRequest:request_img4
                                                                                  imageProcessingBlock:nil
                                                                                               success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                                                                   if(image!=nil)
                                                                                                   {
                                                                                                       
                                                                                                       Imageviewmain.image=image;
                                                                                                       [Spinner stopAnimating];
                                                                                                       [Spinner hidesWhenStopped];
                                                                                                   }
                                                                                                   
                                                                                               }
                                                                                               failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error)
                                              {
                                                  //NSLog(@"The errorcode:%@",error);
                                                  [Spinner stopAnimating];
                                                  [Spinner hidesWhenStopped];
                                              }];
        [operation start];
        
        
        j++;
        
    }
    
    [AllPhotoscroll setContentSize:CGSizeMake(320, (([AlbamAllphoto count]*80)/4)+80.0f)];
    TotalPhotosLbl.text=[NSString stringWithFormat:@"%@ %@",TotalComment,@"Photos"];
    TotalPhotosLbl.font=[UIFont fontWithName:MYRIARDPROSAMIBOLT size:16.0f];
}

-(void)ViewPhotos:(UITapGestureRecognizer *)Recognizer
{
   
    
    UIImageView *TouchedView=(UIImageView *)[[Recognizer self] view];
    NSString *TouchviewTag=[NSString stringWithFormat:@"%d",TouchedView.tag];
    
    TTTPhotodetailsViewController *PhotoDetais=[[TTTPhotodetailsViewController alloc]init];
    PhotoDetais.ParamPhotoArry=[AlbamAllphoto copy];
    PhotoDetais.ClickphotoId=TouchviewTag;
    //TouchedView
    [self presentViewController:PhotoDetais animated:YES completion:^{
        
    }];
    
  }





@end
