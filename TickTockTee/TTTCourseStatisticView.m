//
//  TTTCourseStatisticView.m
//  TickTockTee
//
//  Created by macbook_ms on 10/04/14.
//  Copyright (c) 2014 com.esolz.TickTockTee. All rights reserved.
//

#import "TTTCourseStatisticView.h"
#import "SVProgressHUD.h"
#import "TTTCellForcoursestat.h"
#import "TTTGlobalMethods.h"

@interface TTTCourseStatisticView ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *StateTBL;
@property (weak, nonatomic) IBOutlet UILabel *TeeboxTxt;
@property (weak, nonatomic) IBOutlet UILabel *CourserattingText;
@property (weak, nonatomic) IBOutlet UILabel *FontLblTxt;
@property (strong, nonatomic) IBOutlet UIView *TBLheader;

@property (weak, nonatomic) IBOutlet UILabel *Sloprattingtxt;
@end

@implementation TTTCourseStatisticView
@synthesize StateTBL,CoursesatisticArray;

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
    [StateTBL setDelegate:self];
    [StateTBL setDataSource:self];
    self.TeeboxTxt.font=[UIFont fontWithName:MYRIARDPROSAMIBOLT size:12.0f];
    self.CourserattingText.font=[UIFont fontWithName:MYRIARDPROSAMIBOLT size:12.0f];
    self.FontLblTxt.font=[UIFont fontWithName:MYRIARDPROSAMIBOLT size:12.0f];
    self.Sloprattingtxt.font=[UIFont fontWithName:MYRIARDPROSAMIBOLT size:12.0f];
    [StateTBL setBackgroundColor:[UIColor clearColor]];
    [StateTBL reloadData];
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)BackbuttonClick:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        [SVProgressHUD dismiss];
    }];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *Mutdic=[CoursesatisticArray objectAtIndex:indexPath.row];
    
    TTTCellForcoursestat *courseStateCell=(TTTCellForcoursestat *)[tableView dequeueReusableCellWithIdentifier:nil];
    [courseStateCell setBackgroundColor:[UIColor clearColor]];
    if (courseStateCell==nil)
    {
        NSArray *Coursestate=[[NSBundle mainBundle]loadNibNamed:@"TTTCellForcoursestat" owner:self options:nil];
        courseStateCell=(TTTCellForcoursestat *)[Coursestate objectAtIndex:0];
    }
    courseStateCell.backgroundColor=[UIColor clearColor];
    UIView *teeBoxView=(UIView *)[courseStateCell.contentView viewWithTag:500];
    [self setRoundBorderToUiview:teeBoxView];
    [teeBoxView setBackgroundColor:[TTTGlobalMethods colorFromHexString:[Mutdic valueForKey:@"color_code"]]];
    UILabel *CourserattingLbl=(UILabel *)[courseStateCell.contentView viewWithTag:501];
    CourserattingLbl.font=[UIFont fontWithName:MYREADPROREGULAR size:13.0f];
    CourserattingLbl.text=[Mutdic valueForKey:@"course_tee_rating"];
    
    UILabel *Slopratting=(UILabel *)[courseStateCell.contentView viewWithTag:502];
    Slopratting.font=[UIFont fontWithName:MYREADPROREGULAR size:13.0f];
    Slopratting.text=[Mutdic valueForKey:@"slope_rating"];
    
    UILabel *Fontratting=(UILabel *)[courseStateCell.contentView viewWithTag:503];
    Fontratting.font=[UIFont fontWithName:MYREADPROREGULAR size:13.0f];
    Fontratting.text=[Mutdic valueForKey:@"course_front"];
    
    
    return courseStateCell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 34.0f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 29.0f;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.TBLheader;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [CoursesatisticArray count];
}

@end
