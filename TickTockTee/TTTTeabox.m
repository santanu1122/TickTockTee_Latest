//
//  TTTTeabox.m
//  TickTockTee
//
//  Created by macbook_ms on 26/02/14.
//  Copyright (c) 2014 com.esolz.TickTockTee. All rights reserved.
//

#import "TTTTeabox.h"
#import "TTTGlobalMethods.h"
#import "SVProgressHUD.h"
#import "TTTCellFormatchList.h"
#import "TTTCreatematch.h"

@interface TTTTeabox ()
{
    BOOL IsChatBoxOpen, IsLeftMenuBoxOpen;
    NSMutableArray *CourseTeeBoxArray;
    NSOperationQueue *OperationQueue;
    TTTGlobalMethods *Method;
}

@end

@implementation TTTTeabox
@synthesize TblTeeBoxes, IsComingThroughModal;
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
    
    [TblTeeBoxes setBackgroundColor:[UIColor clearColor]];
    [self PrepareScreen];
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.

}
-(void)PrepareScreen
{
    IsChatBoxOpen=FALSE;
    IsLeftMenuBoxOpen=FALSE;
 
    CourseTeeBoxArray=[[NSMutableArray alloc] init];
    OperationQueue=[[NSOperationQueue alloc] init];
    
    [self AssignWork];
}


-(void)AssignWork
{
    NSUserDefaults *session=[[NSUserDefaults alloc] init];
  
    
    if([[session valueForKey:COURSE_ID] integerValue] >0)
    {
        [SVProgressHUD showWithStatus:@"Please Wait..."];
        NSInvocationOperation *Operation=[[NSInvocationOperation alloc] initWithTarget:self selector:@selector(getTeeBoxes:) object:[session valueForKey:COURSE_ID]];
        [OperationQueue addOperation:Operation];
    }
    else
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Warning!!" message:@"Please select location first." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert setTag:234];
        [alert show];
    }
}



#pragma mark for Thread Segments


-(void)getTeeBoxes :(NSString *)CourseId
{
    @try
    {
        NSString *URL=[NSString stringWithFormat:@"%@user.php?mode=getCourseteebox&courseid=%@", API, CourseId];
        NSLog(@"%@", URL);
        NSData *getData=[NSData dataWithContentsOfURL:[NSURL URLWithString:URL]];
        
        if([getData length]>2)
        {
            [CourseTeeBoxArray removeAllObjects];
             NSArray *Output=[NSJSONSerialization JSONObjectWithData:getData options:kNilOptions error:nil];
            
            for(NSDictionary *var in Output)
            {
                [CourseTeeBoxArray addObject:[[TTTGlobalMethods alloc] initWithId:[var objectForKey:@"id"] withColorBox:[var objectForKey:@"colorbox"] withColorCode:[var objectForKey:@"colorcode"]]];
            }
           
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
                [TblTeeBoxes reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
            });
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
        NSLog(@"Reporting juju from getTeeBoxes : %@", juju);
    }
}



#pragma mark for IBAction


- (IBAction)GoBack:(id)sender
{
    
        [self dismissViewControllerAnimated:YES completion:^{
            
      }];

}






#pragma mark - Table view data source


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (tableView==TblChat)?44.0f:42.0f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (tableView==TblChat)?[ChaterArray count]:[CourseTeeBoxArray count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
     static NSString *CellIdentifire=@"cell";
      TTTCellFormatchList *TeeBoxListing;
       TeeBoxListing=(TTTCellFormatchList *)[tableView dequeueReusableCellWithIdentifier:CellIdentifire];
      if (TeeBoxListing==nil)
      {
           NSArray *CellNib=[[NSBundle mainBundle] loadNibNamed:@"TTTCellFormatchListcontroller" owner:self options:nil];
            TeeBoxListing=(TTTCellFormatchList *)[CellNib objectAtIndex:2];
      }
        UIView *MainView=(UIView *)[TeeBoxListing.contentView viewWithTag:101];
      [MainView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"row.png"]]];
      Method=[CourseTeeBoxArray objectAtIndex:indexPath.row];
    
     UIView *ColorBox=(UIView *)[MainView viewWithTag:50];
     UILabel *ColorName=(UILabel *)[MainView viewWithTag:51];
     [ColorName setTextColor:[UIColor whiteColor]];
      ColorName.font=[UIFont fontWithName:@"MyriadPro-Semibold" size:16.0f];
     [[ColorBox layer] setBorderColor:[[UIColor whiteColor] CGColor]];
     [[ColorBox layer] setBorderWidth:1.0f];
     [ColorBox setBackgroundColor:[Method TeeBoxColor]];
     [ColorName setText:[Method ColorBox]];
    
    return TeeBoxListing;
    
}



#pragma mark - delegates

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[self TblTeeBoxes] deselectRowAtIndexPath:indexPath animated:YES];
    
    Method=[CourseTeeBoxArray objectAtIndex:[indexPath row]];
    TTTCreatematch *createMatch=[[TTTCreatematch alloc]init];
    createMatch.isCommingfromLocation=FALSE;
    NSUserDefaults *session=[[NSUserDefaults alloc] init];
    NSMutableDictionary *SessionParam=[[NSMutableDictionary alloc] initWithDictionary:[session objectForKey:SESSION_MATCHCREATEPARAMETES]];
    [SessionParam setValue:[Method ColorBox] forKey:PARAM_TEEBOX_NAME];
    [SessionParam setValue:[Method ColorCode] forKey:PARAM_TEEBOX_COLOR];
    [SessionParam setValue:[Method Id] forKey:PARAM_TEEBOX_ID];
    [session setObject:SessionParam forKey:SESSION_MATCHCREATEPARAMETES];
    [session synchronize];
    
    [self GoBack:nil];
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==0)
    {
        if([alertView tag]==234)
        {
            [self GoBack:nil];
        }
    }
}
- (IBAction)CencelButton:(id)sender
{
    
    [self dismissViewControllerAnimated:YES completion:^{
        [OperationQueue cancelAllOperations];
        
    }];
}

@end
