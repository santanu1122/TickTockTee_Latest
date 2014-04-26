//
//  TTTLocationName.m
//  TickTockTee
//
//  Created by macbook_ms on 26/02/14.
//  Copyright (c) 2014 com.esolz.TickTockTee. All rights reserved.
//

#import "TTTLocationName.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "TTTCreatematch.h"
#import "TTTGlobalMethods.h"
#import "SVProgressHUD.h"

@interface TTTLocationName ()<UITableViewDelegate,UITableViewDataSource,MKMapViewDelegate,CLLocationManagerDelegate,UITextFieldDelegate>
{
      CLLocationCoordinate2D coordinate;
      CGFloat latitude;
      CGFloat longitude;
      NSMutableArray *recodLocationdata;
      NSOperationQueue *operationQ;
      NSString *match_id;
      NSString *Matchname;
    TTTGlobalMethods *Method;
    
}
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *Spinner;
@property (strong, nonatomic) IBOutlet UILabel *LocatonName;
@property (strong, nonatomic) IBOutlet MKMapView *Mapview;
@property (strong, nonatomic) IBOutlet UITextField *SearchTxtfield;
@property (strong, nonatomic) IBOutlet UITableView *TblShowLocation;
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) CLLocation *Location;

@end

@implementation TTTLocationName
@synthesize LocatonName,Mapview,SearchTxtfield,TblShowLocation,Location;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self=(IsIphone5)?[super initWithNibName:@"TTTLocationName" bundle:nil]:[super initWithNibName:@"TTTLocationName_iPhone4" bundle:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
     NSUserDefaults *userdefalus=[NSUserDefaults standardUserDefaults];
     NSString *locationName=[userdefalus valueForKey:SESSION_USERLOCAION];
     [SearchTxtfield setText:locationName];
      NSLog(@"The value of location name:%@",locationName);
     recodLocationdata=[[NSMutableArray alloc]init];
     operationQ =[[NSOperationQueue alloc]init];
     Method=[[TTTGlobalMethods alloc]init];
     [TblShowLocation setBackgroundColor:[UIColor clearColor]];
     [TblShowLocation setDelegate:self];
     [TblShowLocation setDataSource:self];
     Mapview.delegate=self;
      _locationManager =[[CLLocationManager alloc] init];
     [_locationManager setDelegate:self];
     [_locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
     [_locationManager setDistanceFilter:kCLDistanceFilterNone];
     [_locationManager startUpdatingLocation];
     Location=[_locationManager location];
     latitude=[Location coordinate].latitude;
     longitude=[Location coordinate].longitude;
      [SearchTxtfield setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
     [self ShowLocationInmap];
     [self InitialWork];
    
}

-(void)InitialWork
{
    NSInvocationOperation *Invocation=[[NSInvocationOperation alloc]initWithTarget:self selector:@selector(getLocation) object:nil];
    [operationQ addOperation:Invocation];
}


- (IBAction)searchButtonClick:(id)sender
{
    [SearchTxtfield resignFirstResponder];
    [self.Spinner startAnimating];
    [recodLocationdata removeAllObjects];
    [TblShowLocation reloadData];
     NSInvocationOperation *InvocationSecrch=[[NSInvocationOperation alloc]initWithTarget:self selector:@selector(SearchWithLocation) object:nil];
    [operationQ addOperation:InvocationSecrch];
}



-(void)ShowLocationInmap
 {
     CLLocationCoordinate2D userlocation;
     userlocation.latitude = latitude;
     userlocation.longitude = longitude;
     
     MKMapPoint userPoint = MKMapPointForCoordinate(userlocation);
   
     MKMapRect userRect = MKMapRectMake(userPoint.x, userPoint.y, 0, 0);
     MKMapRect annotationRect = MKMapRectMake(userPoint.x, userPoint.y, 0, 0);
     
     MKMapRect unionRect = MKMapRectUnion(userRect, annotationRect);
     
     MKMapRect unionRectThatFits = [Mapview mapRectThatFits:unionRect];
     [Mapview setVisibleMapRect:unionRectThatFits animated:YES];
     
     
     MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
     annotation.coordinate = userlocation;
    
     [Mapview addAnnotation:annotation];
     [Mapview selectAnnotation:annotation animated:YES];
 }

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma UITableViewDataSource


-(CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0f;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0f;
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [recodLocationdata count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *reuseId=@"cellID";
    UITableViewCell *cell;
    NSMutableDictionary *mutdic=[recodLocationdata objectAtIndex:indexPath.row];
    cell=[tableView dequeueReusableCellWithIdentifier:reuseId];
    if (cell==nil)
    {
        
        cell=[[UITableViewCell alloc]init];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        UIView *BackGreoun=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 43)];
        [cell.contentView addSubview:BackGreoun];
        [BackGreoun setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"row.png"]]];
        UILabel *lable1=[[UILabel alloc] initWithFrame:CGRectMake(10, 1, 230, 23)];
        [BackGreoun addSubview:lable1];
        lable1.font=[UIFont fontWithName:@"MyriadPro-Semibold" size:15.0f];
        lable1.textColor=[UIColor whiteColor];
        lable1.textAlignment=NSTextAlignmentLeft;
        [lable1 setText:[mutdic objectForKey:@"course_name"]];
        UILabel *lable2=[[UILabel alloc] initWithFrame:CGRectMake(10, 22, 230, 20)];
        [BackGreoun addSubview:lable2];
        lable2.font=[UIFont fontWithName:@"MyriadProLight" size:14.0f];
        lable2.textColor=[UIColor whiteColor];
        lable2.textAlignment=NSTextAlignmentLeft;
        NSString *CombindString=[NSString stringWithFormat:@"%@, %@, %@",[mutdic valueForKey:@"city"],[mutdic valueForKey:@"state"],[mutdic valueForKey:@"county"]];
        lable2.text=CombindString;
        UILabel *lable3=[[UILabel alloc] initWithFrame:CGRectMake(243, 14, 39, 18)];
      
        lable3.font=[UIFont fontWithName:MYRIARDPROSAMIBOLT size:12.0f];
        lable3.textAlignment=NSTextAlignmentLeft;
        [lable3 setText:[mutdic objectForKey:@"distance"]];
        lable3.textColor=[UIColor whiteColor];
          [BackGreoun addSubview:lable3];
        UIImageView *ImageView=[[UIImageView alloc]initWithFrame:CGRectMake(280, 7, 30, 30)];
        [ImageView setImage:[UIImage imageNamed:@"course-1"]];
        [BackGreoun addSubview:ImageView];
         cell.backgroundColor=[UIColor clearColor];
        
    }
   
      return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
     cell.selectionStyle=UITableViewCellSelectionStyleBlue;
     NSMutableDictionary *mutdicForSendData=[recodLocationdata objectAtIndex:indexPath.row];
      match_id=[mutdicForSendData valueForKey:@"id"];
      Matchname=[mutdicForSendData valueForKey:@"course_name"];
    NSUserDefaults *userDetais=[NSUserDefaults standardUserDefaults];
    
    
    NSMutableDictionary *SessionParam=[[NSMutableDictionary alloc] initWithDictionary:[userDetais objectForKey:SESSION_MATCHCREATEPARAMETES]];
    [SessionParam setValue:@"" forKey:PARAM_TEEBOX_NAME];
    [SessionParam setValue:@"" forKey:PARAM_TEEBOX_ID];
    
    [userDetais setObject:SessionParam forKey:SESSION_MATCHCREATEPARAMETES];
    
    
    
    
    [userDetais setValue:match_id forKey:COURSE_ID];
    [userDetais setValue:Matchname forKey:COURSE_NAME];
    [userDetais synchronize];
    [self dismissViewControllerAnimated:YES completion:^{
        
        
    }];

    
    
}


- (IBAction)performBack:(id)sender
{
   
    [self dismissViewControllerAnimated:YES completion:^{
        
        
    }];
    
}

-(void)getLocation
{
    @try
    {
        
        //[Locationcordi coordinate].latitude
        //[Locationcordi coordinate].longitude
        CLLocation *Locationcordi =[self.locationManager location];
        NSLog(@"The value of late and long:%f %f",[Locationcordi coordinate].latitude,[Locationcordi coordinate].longitude);
        NSString *URL=[NSString stringWithFormat:@"%@user.php?mode=getNearbysearch&location=%@&latitude=%f&longitude=%f", API,SearchTxtfield.text,[Locationcordi coordinate].latitude,[Locationcordi coordinate].longitude];
        NSLog(@"%@", URL);
        NSData *getData=[NSData dataWithContentsOfURL:[NSURL URLWithString:URL]];
        
        if([getData length]>2)
            
        {
            
            [recodLocationdata removeAllObjects];
            
            NSDictionary *Output=[NSJSONSerialization JSONObjectWithData:getData options:kNilOptions error:nil];
            
            
            
            NSArray *mainarray=[Output objectForKey:@"nearby_cource"];
            
            for(NSDictionary *var in mainarray)
                
            {
                
                NSMutableDictionary *DicTion=[[NSMutableDictionary alloc] init];
                
                [DicTion setValue:[var valueForKey:@"id"] forKey:@"id"];
                
                [DicTion setValue:[var valueForKey:@"course_name"] forKey:@"course_name"];
                
                [DicTion setValue:[var valueForKey:@"city"] forKey:@"city"];
                
                [DicTion setValue:[var valueForKey:@"state"] forKey:@"state"];
                
                [DicTion setValue:[var valueForKey:@"county"] forKey:@"county"];
                
                [DicTion setValue:[var valueForKey:@"distance"] forKey:@"distance"];
                
                [recodLocationdata addObject:DicTion];
                
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                if([recodLocationdata count]>0)
                {
                    NSLog(@"all data are correct");
                    [self.Spinner stopAnimating];
                    [TblShowLocation reloadData];
                 
                }
                else
                {
                    [self.Spinner stopAnimating];
                    
                    [SVProgressHUD showErrorWithStatus:@"No courses found!"];
                }
            });
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.Spinner stopAnimating];
               [SVProgressHUD showErrorWithStatus:@"No courses found!"];
            });
        }
        
    }
    @catch (NSException *juju)
    {
        NSLog(@"Reporting juju from getLocation : %@", juju);
        
    }
}

-(void)SearchWithLocation
{
    
    @try
    {
        CLLocation *Locationcordi =[self.locationManager location];
        [TblShowLocation setHidden:YES];
        NSString *URL=[NSString stringWithFormat:@"%@user.php?mode=getNearbysearch&location=%@&latitude=%f&longitude=%f", API, [self Encoder:SearchTxtfield.text],[Locationcordi coordinate].latitude,[Locationcordi coordinate].longitude];
        NSLog(@"%@", URL);
        NSData *getData=[NSData dataWithContentsOfURL:[NSURL URLWithString:URL]];
        
        if([getData length]>2)
            
        {
            
           
            
            NSDictionary *Output=[NSJSONSerialization JSONObjectWithData:getData options:kNilOptions error:nil];
            
            
            
            NSArray *mainarray=[Output objectForKey:@"nearby_cource"];
            
            for(NSDictionary *var in mainarray)
                
            {
                
                NSMutableDictionary *DicTion=[[NSMutableDictionary alloc] init];
                
                [DicTion setValue:[var valueForKey:@"id"] forKey:@"id"];
                
                [DicTion setValue:[var valueForKey:@"course_name"] forKey:@"course_name"];
                
                [DicTion setValue:[var valueForKey:@"city"] forKey:@"city"];
                
                [DicTion setValue:[var valueForKey:@"state"] forKey:@"state"];
                
                [DicTion setValue:[var valueForKey:@"county"] forKey:@"county"];
                
                [DicTion setValue:[var valueForKey:@"distance"] forKey:@"distance"];
                
                [recodLocationdata addObject:DicTion];
                
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                if([recodLocationdata count]>0)
                {
                    NSLog(@"all data are correct");
                    [TblShowLocation setHidden:NO];
                    [self.Spinner stopAnimating];
                    [TblShowLocation reloadData];
                    
                }
                else
                {
                  
                    [self.Spinner stopAnimating];
                    [SVProgressHUD showErrorWithStatus:@"No courses found!"];
                   
                }
            });
    
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.Spinner stopAnimating];
                [SVProgressHUD showErrorWithStatus:@"No courses found!"];
            });
        }
        
    }
    @catch (NSException *juju)
    {
        NSLog(@"Reporting juju from getLocation : %@", juju);
        dispatch_async(dispatch_get_main_queue(), ^{
           [self.Spinner stopAnimating];
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"error" message:@"Unexpected error occured." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        });
    }
}
-(void)ReloadToempty
{
    [TblShowLocation reloadData];
}


-(NSString *) Encoder:(NSString *)str
{
    NSString *trimmedString = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return [trimmedString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
     [textField resignFirstResponder];
    
        [self.Spinner startAnimating];
      [recodLocationdata removeAllObjects];
         [TblShowLocation reloadData];
    
        NSInvocationOperation *InvocationSecrch=[[NSInvocationOperation alloc]initWithTarget:self selector:@selector(SearchWithLocation) object:nil];
        [operationQ addOperation:InvocationSecrch];
    
    
      return YES;
}

- (IBAction)CencelLocation:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        [self.Spinner stopAnimating];
        }];
    
}
- (IBAction)DoneLocation:(id)sender
  {
    // PARAM_TEEBOX_NAME
      
      TTTCreatematch *createMatch=[[TTTCreatematch alloc]init];
      createMatch.isCommingfromLocation=TRUE;
      NSUserDefaults *userDetais=[NSUserDefaults standardUserDefaults];
      
      
       NSMutableDictionary *SessionParam=[[NSMutableDictionary alloc] initWithDictionary:[userDetais objectForKey:SESSION_MATCHCREATEPARAMETES]];
      [SessionParam setValue:@"" forKey:PARAM_TEEBOX_NAME];
      [SessionParam setValue:@"" forKey:PARAM_TEEBOX_ID];
      
      [userDetais setObject:SessionParam forKey:SESSION_MATCHCREATEPARAMETES];
      
     
      
     
      [userDetais setValue:match_id forKey:COURSE_ID];
      [userDetais setValue:Matchname forKey:COURSE_NAME];
      [userDetais synchronize];
     [self dismissViewControllerAnimated:YES completion:^{
       
          
      }];
  }

@end
