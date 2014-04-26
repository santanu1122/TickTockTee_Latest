//
//  TTTAddFriend.m
//  TickTockTee
//
//  Created by macbook_ms on 26/02/14.
//  Copyright (c) 2014 com.esolz.TickTockTee. All rights reserved.
//

#import "TTTAddFriend.h"
#import "TTTCellFormatchList.h"
#import "SVProgressHUD.h"

@interface TTTAddFriend ()
{
    BOOL IsChatBoxOpen, IsLeftMenuBoxOpen, IsFilteredFrnd;
    NSMutableArray *InvitedFriendsArray, *FilteredFriends, *SelectedFriends;
    NSOperationQueue *OperationQueue;
    TTTGlobalMethods *Method;
    NSMutableString *FriendIds;
    NSMutableArray *SelectedFieldArray;
    NSMutableDictionary *performSelectornot;
   
}
@property (strong, nonatomic) IBOutlet UIButton *ButtonDon;

@end

@implementation TTTAddFriend

@synthesize  ScreenView,BtnCancel, BtnDone, TblFriends, TFSearch, IsComingThroughModal;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
         self=(IsIphone5)?[super initWithNibName:@"TTTAddFriend" bundle:nil]:[super initWithNibName:@"TTTAddFriend_iPhone4" bundle:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    performSelectornot=[[NSMutableDictionary alloc] init];
    
    [SVProgressHUD dismiss];
    [self PrepareScreen];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [SVProgressHUD dismiss];
}


-(void)PrepareScreen
{
    IsChatBoxOpen=FALSE;
    IsLeftMenuBoxOpen=FALSE;
    IsFilteredFrnd=NO;
    
   
   
    TblFriends.delegate=self;
    TblFriends.dataSource=self;
    [TblFriends setBackgroundColor:[UIColor clearColor]];
   
    [self.TFSearch setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.TFSearch setFont:[UIFont fontWithName:@"MyriadProLight" size:14.0f]];
   
     OperationQueue =[[NSOperationQueue alloc] init];
     InvitedFriendsArray=[[NSMutableArray alloc] init];
     FilteredFriends=[[NSMutableArray alloc] init];
     SelectedFriends=[[NSMutableArray alloc] init];
     FriendIds=[NSMutableString string];
     [TFSearch addTarget:self action:@selector(PerformSearchFriends) forControlEvents:UIControlEventEditingChanged];
    
    NSUserDefaults *session=[[NSUserDefaults alloc] init];
    NSDictionary *SessionParam=[session objectForKey:SESSION_MATCHCREATEPARAMETES];
    if([[SessionParam valueForKey:PARAM_SELECTED_FRIENDS] length]>0)
    {
       [FriendIds appendString:[SessionParam valueForKey:PARAM_SELECTED_FRIENDS]];
    }
    if ([FriendIds length]>0)
    {
        [[self ButtonDon] setBackgroundImage:[UIImage imageNamed:@"donegreen"] forState:UIControlStateNormal];
        [[self ButtonDon] setBackgroundImage:[UIImage imageNamed:@"donegreen"] forState:UIControlStateHighlighted];
        [[self ButtonDon] setBackgroundImage:[UIImage imageNamed:@"donegreen"] forState:UIControlStateSelected];
    }
    [self AssignWork];
}



-(void)AssignWork
{
    [SVProgressHUD showWithStatus:@"Please Wait..."];
    NSInvocationOperation *Operation=[[NSInvocationOperation alloc] initWithTarget:self selector:@selector(getMyFriends) object:nil];
    [OperationQueue addOperation:Operation];
}



#pragma mark for IBAction

- (IBAction)GoBack:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];

}


- (IBAction)CancelButtonTouched:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (IBAction)DoneButtonTouched:(id)sender
{
    
    FriendIds=[NSMutableString string];
    for(TTTGlobalMethods *LocalMethod in SelectedFriends)
    {
        [FriendIds appendFormat:@",%@", [LocalMethod Id]];
    }
    NSLog(@"the friend ids:%@",FriendIds);
    NSUserDefaults *session=[[NSUserDefaults alloc] init];
    NSMutableDictionary *SessionParam=[[NSMutableDictionary alloc] initWithDictionary:[session objectForKey:SESSION_MATCHCREATEPARAMETES]];
    [SessionParam setValue:FriendIds forKey:PARAM_SELECTED_FRIENDS];
    [session setObject:SessionParam forKey:SESSION_MATCHCREATEPARAMETES];
    [session synchronize];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    
    //[self GoBack];
}

-(void)GoBack
{
    if(IsComingThroughModal)
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    else
        [self PerformGoBack];
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [[self view] endEditing:YES];
    return YES;
}










#pragma mark for Thread Segments


-(void)getMyFriends
{
    if ([self isConnectedToInternet])
    {
        @try
        {
            NSString *URL=[NSString stringWithFormat:@"%@user.php?mode=friends&userid=%@", API, [self LoggedId]];
            NSLog(@"%@", URL);
            NSData *getData=[NSData dataWithContentsOfURL:[NSURL URLWithString:URL]];
            
            if([getData length]>2)
            {
                NSDictionary *Output=[NSJSONSerialization JSONObjectWithData:getData options:kNilOptions error:nil];
                NSMutableArray *Mutdicarray=[Output valueForKey:@"friendslist"];
                NSArray *SelectedFriendsArray=[FriendIds componentsSeparatedByString:@","];
                
                for(NSDictionary *var in Mutdicarray)
                {
                    [InvitedFriendsArray addObject:[[TTTGlobalMethods alloc] initWithId:[var objectForKey:@"FriendId"] withFriendName:[var objectForKey:@"FriendName"] withFriendImageURL:[var objectForKey:@"FriendImage"] withNoOfFriends:[var objectForKey:@"Totalfriends"] withFriendId:[var objectForKey:@"FriendId"]]];
                    
                    if([self IsSelectedFriendsWithId:[var objectForKey:@"FriendId"] From:SelectedFriendsArray])
                        [SelectedFriends addObject:[[TTTGlobalMethods alloc] initWithId:[var objectForKey:@"FriendId"] withFriendName:[var objectForKey:@"FriendName"] withFriendImageURL:[var objectForKey:@"FriendImage"] withNoOfFriends:[var objectForKey:@"Totalfriends"] withFriendId:[var objectForKey:@"FriendId"]]];
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [SVProgressHUD dismiss];
                    [TblFriends reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
                });
            }
            else
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [SVProgressHUD showErrorWithStatus:@"Unexpected error occured."];
                });
            }
            
        }
        @catch (NSException *juju)
        {
            NSLog(@"Reporting juju from getLocation : %@", juju);
        }

    }
    else
    {
       [SVProgressHUD showErrorWithStatus:@"No internet in your device"];
    }
   }







#pragma mark - Table view data source


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (tableView==TblChat)?44.0f:43.0f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView==TblChat)
        return [ChaterArray count];
    else
    {
        return (IsFilteredFrnd)?[FilteredFriends count]:[InvitedFriendsArray count];
    }
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
    TTTCellFormatchList *Friendcell;
    Friendcell=(TTTCellFormatchList *)[tableView dequeueReusableCellWithIdentifier:CellIdentifire];
    if (Friendcell==nil)
    {
        NSArray *CellNib=[[NSBundle mainBundle] loadNibNamed:@"TTTCellFormatchListcontroller" owner:self options:nil];
        Friendcell=(TTTCellFormatchList *)[CellNib objectAtIndex:1];
    }
    UIView *Mainview=(UIView *)[Friendcell.contentView viewWithTag:50];
    [Mainview setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"row.png"]]];
    Method=(IsFilteredFrnd)?[FilteredFriends objectAtIndex:[indexPath row]]:[InvitedFriendsArray objectAtIndex:indexPath.row];
    [Friendcell setBackgroundColor:[UIColor clearColor]];
  
    UIImageView *FriendImage=(UIImageView *)[Mainview viewWithTag:1];
    [self SetroundborderWithborderWidth:2.0f WithColour:UIColorFromRGB(0xc9c9c9) ForImageview:FriendImage];
    UILabel *FriendName=(UILabel *)[Mainview viewWithTag:2];
    
    FriendName.font=[UIFont fontWithName:@"MyriadPro-Semibold" size:16.0f];
    [FriendName setTextColor:[UIColor whiteColor]];
    FriendName.alpha=1.5;
    [FriendName setText:[Method FriendName]];
   
    //Createing the button
    
    UIButton *FriendButton=(UIButton *)[Mainview viewWithTag:4];
    [FriendButton setTag:indexPath.row];
    if ([FriendIds length]>0)
    {
        [[self ButtonDon] setBackgroundImage:[UIImage imageNamed:@"donegreen"] forState:UIControlStateNormal];
        [[self ButtonDon] setBackgroundImage:[UIImage imageNamed:@"donegreen"] forState:UIControlStateHighlighted];
        [[self ButtonDon] setBackgroundImage:[UIImage imageNamed:@"donegreen"] forState:UIControlStateSelected];

    }
   // doneLocation
    else
    {
        [[self ButtonDon] setBackgroundImage:[UIImage imageNamed:@"doneLocation"] forState:UIControlStateNormal];
        [[self ButtonDon] setBackgroundImage:[UIImage imageNamed:@"doneLocation"] forState:UIControlStateHighlighted];
        [[self ButtonDon] setBackgroundImage:[UIImage imageNamed:@"doneLocation"] forState:UIControlStateSelected];
    }
    if ([self IsSelected:[Method Id]])
    {
        

         [FriendButton setImage:[UIImage imageNamed:@"addedbutton"] forState:UIControlStateNormal];
         [FriendButton setImage:[UIImage imageNamed:@"addedbutton"] forState:UIControlStateHighlighted];
         [FriendButton setImage:[UIImage imageNamed:@"addedbutton"] forState:UIControlStateSelected];
        
        
        [FriendButton setBackgroundColor:UIColorFromRGB(0x74d461)];
    }
    else
    {

        [FriendButton setImage:[UIImage imageNamed:@"addButtonback"] forState:UIControlStateNormal];
        [FriendButton setImage:[UIImage imageNamed:@"addButtonback"] forState:UIControlStateHighlighted];
        [FriendButton setImage:[UIImage imageNamed:@"addButtonback"] forState:UIControlStateSelected];
    }
    [FriendButton addTarget:self action:@selector(changeAndSelectBitton:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
    [self LoadImage:@[FriendImage, [NSURL URLWithString:[Method FriendImageURL]], @"3", @"Fill"]];
  
    
    return Friendcell;
    
}
//Change Button

-(IBAction)changeAndSelectBitton:(UIButton *)Button
{
    NSLog(@"The button tap:%d",Button.tag);
    
    
    Method=(IsFilteredFrnd)?[FilteredFriends objectAtIndex:Button.tag]:[InvitedFriendsArray objectAtIndex:Button.tag];
    
    if(![self IsSelected:[Method Id]])
    {
        [SelectedFriends addObject:Method];

        [Button setImage:[UIImage imageNamed:@"addedbutton"] forState:UIControlStateNormal];
        [Button setImage:[UIImage imageNamed:@"addedbutton"] forState:UIControlStateHighlighted];
        [Button setImage:[UIImage imageNamed:@"addedbutton"] forState:UIControlStateSelected];
        
         NSIndexPath *indexpath=[NSIndexPath indexPathForRow:Button.tag inSection:0];
         [TblFriends reloadRowsAtIndexPaths:[[NSArray alloc] initWithObjects:indexpath, nil] withRowAnimation:UITableViewRowAnimationNone];
     
       
        
    }
    else
    {
         [SelectedFriends removeObjectAtIndex:[self GetIndex:[Method Id]]];

        [Button setImage:[UIImage imageNamed:@"addButtonback"] forState:UIControlStateNormal];
        [Button setImage:[UIImage imageNamed:@"addButtonback"] forState:UIControlStateHighlighted];
        [Button setImage:[UIImage imageNamed:@"addButtonback"] forState:UIControlStateSelected];
         NSIndexPath *indexpath=[NSIndexPath indexPathForRow:Button.tag inSection:0];
         [TblFriends reloadRowsAtIndexPaths:[[NSArray alloc] initWithObjects:indexpath, nil] withRowAnimation:UITableViewRowAnimationNone];
     
    }
    
    FriendIds=[NSMutableString string];
    for(TTTGlobalMethods *LocalMethod in SelectedFriends)
    {
        [FriendIds appendFormat:@",%@", [LocalMethod Id]];
    }
}






#pragma mark - delegates

/*-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if([TblFriends isEqual:tableView])
    {
        UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
        UILabel *FriendName=(UILabel *)[cell viewWithTag:2];
        
        Method=(IsFilteredFrnd)?[FilteredFriends objectAtIndex:[indexPath row]]:[InvitedFriendsArray objectAtIndex:indexPath.row];
        
        if(![self IsSelected:[Method Id]])
        {
            [SelectedFriends addObject:Method];
            [[[self TblFriends] cellForRowAtIndexPath:indexPath] setBackgroundColor:UIColorFromRGB(0x31536C)];
            [FriendName setTextColor:[UIColor whiteColor]];
        }
        else
        {
            [SelectedFriends removeObjectAtIndex:[self GetIndex:[Method Id]]];
            NSArray *indexArray=[[NSArray alloc] initWithObjects:indexPath, nil];
            [[self TblFriends] reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationNone];
            [FriendName setTextColor:[UIColor whiteColor]];
        }
        
        FriendIds=[NSMutableString string];
        for(TTTGlobalMethods *LocalMethod in SelectedFriends)
        {
            [FriendIds appendFormat:@",%@", [LocalMethod Id]];
        }
    }
}*/

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
     NSLog(@"I mam in selected array1");
     TTTCellFormatchList *Friendcell;
    Friendcell=(TTTCellFormatchList *)[tableView cellForRowAtIndexPath:indexPath];
    
    if([tableView isEqual:TblFriends])
    {
        if(IsFilteredFrnd)
            Method=[FilteredFriends objectAtIndex:indexPath.row];
        else
            Method=[InvitedFriendsArray objectAtIndex:indexPath.row];
        
       
    }
}




-(void)PerformSearchFriends
{
    if([[TFSearch text] length]>0)
    {
        IsFilteredFrnd=YES;
        [FilteredFriends removeAllObjects];
        
        for(TTTGlobalMethods *LocalMethod in InvitedFriendsArray)
        {
            NSRange TextRange=[[LocalMethod FriendName] rangeOfString:[TFSearch text] options:NSCaseInsensitiveSearch];
            if(TextRange.location != NSNotFound)
                [FilteredFriends addObject:LocalMethod];
        }
    }
    else
    {
        IsFilteredFrnd=NO;
    }
    
    [[self TblFriends] reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
}


-(BOOL)IsSelected:(NSString *)userId
{
    for(TTTGlobalMethods *LocalMethod in SelectedFriends)
    {
        if([[LocalMethod Id] isEqualToString:userId])
            return TRUE;
    }
    return FALSE;
}

-(NSInteger)GetIndex:(NSString *)userId
{
    NSInteger TotalSeleted=[SelectedFriends count];
    NSInteger Index=0;
    for(NSInteger i=0; i<TotalSeleted; i+=1)
    {
        Method=[SelectedFriends objectAtIndex:i];
        if([[Method Id] isEqualToString:userId])
        {
            Index= i; break;
        }
    }
    return Index;
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
@end