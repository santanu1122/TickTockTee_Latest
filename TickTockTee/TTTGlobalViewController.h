//
//  GlobalViewController.h
//  HeartCard
//
//  Created by Iphone_2 on 13/07/13.
//  Copyright (c) 2013 esolz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageProcessor.h"
#import "TTTGlobalMethods.h"
#import "SVProgressHUD.h"
#import <QuartzCore/QuartzCore.h>
#import <FacebookSDK/FacebookSDK.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <sys/socket.h>
#import <netinet/in.h>
#import <ifaddrs.h>

@class ImageProcessor;

@interface TTTGlobalViewController : ImageProcessor <UITextFieldDelegate, UIGestureRecognizerDelegate, UIScrollViewDelegate,  UITableViewDataSource, UITableViewDelegate>
{
@public BOOL IsShown;
@public UITextField *LeftSearchBox;
@public NSMutableArray *ChaterArray;
@public UITableView *TblChat;
@public UILabel *FriendRqstBadges;
}
@property (strong, nonatomic) IBOutlet UIView *matchDetailsview;

@property (nonatomic, assign)BOOL PresentViewController;
@property (nonatomic, assign)BOOL IsShown;
@property(nonatomic, retain) UITableView *TblChat;
@property(nonatomic, retain) NSMutableArray *ChaterArray;
@property(nonatomic, retain) UILabel *FriendRqstBadges;
@property (strong, nonatomic) UITableView *Manutable;
@property (strong, nonatomic)  UIImageView *Scarchicon;
@property (nonatomic, retain) UITextField *manuSearchtxt;


-(void)SetBackground :(UIView *)VictimView;

-(void)SetBackground:(UIView *)VictimView :(NSString *)ImageName;

-(void)PerformGoBack;
-(void)PerformGoBackWithNoOfTimes:(int)Times;
-(void)PerformGoBackTo: (NSString *)HereWeGo;

-(void) PerformGoBackTo:(NSString *)HereWeGo WithAnimation:(BOOL)Animation;

-(void)PushViewController:(UIViewController *)viewController WithAnimation:(NSString *)AnimationType;
-(void)PopViewController:(NSString *)viewControllerName WithAnimation:(NSString *)AnimationType;
-(void)PushViewController:(UIViewController *)viewController TransitationFrom:(NSString *)TransitationDirection;
-(void)PerformGoBackWithTransitationFrom:(NSString *)TransitationDirection;

-(void)SetBorderToField:(UIView *)TxtField;
-(void)SetBorderToFieldIn:(UIView *)FieldView;
-(void)SetBorderToFieldSet:(NSArray *)FieldSet;
-(void)SetBorderToButton:(UIButton *)Button;
-(void)SetBorderToView:(UIView *)Views;
-(void)SetBorderToSubViewOf:(UIView *)Views;
-(void)SetCornerToView:(UIView *)Views;
-(void)SetCornerToView:(UIView *)Views to:(float)corner;
-(void)SetCornerToViews:(NSArray *)Views;
-(void)SetBorderToBackView:(UIView *)BackView;
-(void)SetDropShadowToBackView:(UIView *)BackView;
-(void)RoundMyProfilePicture:(UIImageView *)PicView;
-(void)RoundMyProfilePicture:(UIImageView *)PicView withRadious:(float)Radious;
-(void)RemoveProtectorFrom :(UIView *)ScreenView;
-(void)setBorderToView:(UIView *)VictimView withCornerRadius:(float)Radious withColor:(UIColor *)color;
-(void)setBorderToView:(UIView *)VictimView withCornerRadius:(float)Radious withColor:(UIColor *)color withBorderWidth :(float)BorderWidth;
-(void)setBorderToViews:(NSArray *)ViewArray withCornerRadius:(float)Radious withColor:(UIColor *)color;
-(void)makeRoundWithDropShadow:(UIImageView *)PicView InView:(UIView *)BackView;
-(void)setRoundBorderToImageView :(UIImageView *)PicView;
-(void)setRoundBorderToUiview:(UIView *)uiview;



-(void)setRadiousToBox:(UIView *)View to:(float)corner;

-(void)SetDelegetsToTextFiledIn:(UIView *)FieldView;

-(NSString *)LocalDate;

-(void)MakeMeTransparent:(UIView *)VictimView;
-(void)MakeTransparent:(NSArray *)VictimViews;

-(void)AddNavigationBarTo:(UIView *)VictimView;
-(void)AddNavigationBarTo:(UIView *)VictimView withSelected :(NSString *)SelectedMenu;

-(void)AddChatBoxTo:(UIView *)VictimView;
-(void)AddLeftMenuTo:(UIView *)VictimView;
-(void)AddLeftMenuTo:(UIView *)VictimView setSelected:(NSString *)SelectedMenu;

//-(BOOL)PerformChatSliding:(UIView *)MainBackView IsOpen:(bool)isOpen;
//-(BOOL)PerformMenuSliding:(UIView *)MainBackView IsOpen:(bool)isOpen;

-(BOOL)PerformMenuSlider:(UIView *)ScreenView withMenuArea :(UIView *)MenuView IsOpen :(BOOL)IsOpen;
-(BOOL)PerformChatSlider:(UIView *)ScreenView withChatArea :(UIView *)ChatView IsOpen :(BOOL)IsOpen;
-(BOOL)isConnectedToInternet;

-(NSString *)LoggedId;
-(NSString *)LoggerName;
-(NSString *)LoggerUserName;
-(NSString *)LoggerImageURL;
-(NSString *)DeviceToken;
-(NSString *)LoggerCurrentLocation;
-(NSData *)LoggerProfileImageData;

-(NSAttributedString *)getAttributedString :(NSString *)FullString HightLightString :(NSString *)HightLightString;
-(NSAttributedString *)getAttributedString :(NSString *)FullString HightLightString :(NSString *)HightLightString withFontSize :(float)fontSize;

-(void)PingServer:(NSString *)URLString;

-(NSString *)LocalTimeZoneName;
-(NSString *)LocalDateTime;

-(NSString *)CurrentFilterMenuNameBy :(NSString *)MenuId inArray :(NSMutableArray *)Holder;
-(NSString *)CurrentFilterMenuIdBy :(NSString *)MenuName inArray :(NSMutableArray *)Holder;

-(BOOL)IsCurrentViewController :(NSString *)controller;

-(BOOL)IsExists :(NSString *)SuspectedId InThe:(NSArray *)Container;
-(int)getIndexOfId :(NSString *)SuspectedId InThe:(NSArray *)z;

-(void)PostImageToFacebook:(UIImage *)Image;

//-(float)heightForRowForObject:(TTTGlobalMethods *)Param initialHeight:(float)initialHeight;

-(NSArray *)IndexPathForNoOfObjects:(int)ObjectNumber;
-(NSArray *)IndexPathForNoOfObjects:(int)ObjectNumber startFrom :(int)start;
-(NSArray *)IndexPathForNoOfObjects:(int)ObjectNumber startFrom :(int)start inSection:(int)section;
// method for setborder to imageview with radious and rgb border

-(void)SetroundborderWithborderWidth:(CGFloat)BorderWidth WithColour:(UIColor *)RGB ForImageview:(UIImageView *)ImageView;
-(void)SetroundborderWithborderWidth:(CGFloat)BorderWidth WithColour:(UIColor *)RGB ForView:(UIView *)Forview;

-(NSString *)RemoveNullandreplaceWithSpace:(NSString *)CheckNullForthis;
-(NSData *)ConvertImagetoDataJPEGrepresentation:(UIImageView *)Imageview;

-(BOOL)IsThaturlvalid:(NSString *)YoururlString;

//Set attributed text
-(NSAttributedString *)getAttributedString:(NSString *)FullString HightLightString:(NSString *)HightLightString1 HightLighted2:(NSString *)HightLightString2 withFontSize:(float)fontSize;

-(void)PerformChatSliderOperation;
-(BOOL)PerformChatSliding:(UIView *)MainBackView IsOpen:(bool)isOpen;
-(void)globalSearch;


@end
