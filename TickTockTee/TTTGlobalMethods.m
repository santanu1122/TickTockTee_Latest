//
//  TTTGlobalMethods.m
//  Ticktocktee
//
//  Created by Iphone_2 on 17/02/14.
//  Copyright (c) 2014 com.esolz.Ticktocktee. All rights reserved.
//

#import "TTTGlobalMethods.h"

@implementation TTTGlobalMethods

@synthesize MenuName, MenuLink, MenuImage, Name, ActivityType, Id, VideoURL, SendingDate, AchievementType, GroupAdmins;

@synthesize ActivityImageURL, ActivityOwner, ActivityTitle, AssignId, IsMyActivity, ActivityTime, NoOfComments, NoOfLikes, PhotoURL, ActivityId, PhotoWidth, PhotoHeight;

@synthesize MatchId, MatchConfirmGuest, MatchCreator, MatchDateTime, MatchImageURL, MatchInvitedGuest, MatchLocation, MatchTitle, MatchType, MatchCourses, IsMyMatch;

@synthesize CourseId, CourseTitle, CourseLocation, TeeBoxColor, ColorBox, ColorCode,  FriendImageURL, FriendName, IsMyCourse, CourseAverageReview, GrossScore, TeeBoxTextColor;

@synthesize Email, UserName, MessageBody, MessageSubject, IsUnread, SenderId, NoOfStar, CommenterId, CommentId, isJoined, CategoryName;

@synthesize NotificationType, NotificationImageURL, InvitationSenderId, InvitationSenderName, NotificationEventTitle, NotificationDisplayMessage;

@synthesize AlbumCoverImageURL, AlbumDescription, AlbumName, AlbumId, PhotoThumb, PhotoOriginal, PhotoCaption, TotalComments, TotalLikes, IsUserLiked;

@synthesize HoleNumber, Par, Length, Handicap, ScoreTextColor, ScoreBackgroundColor, SenderName, PlayerProgress, PlayerName, PlayerScore, PlayerImageURL;

@synthesize VideoPlaceHolderImageURL, VideoType, VideoTitle, VideoDescription, ImageData, LikePermission, CommentPermission, ReviewerId;

@synthesize CommenterImageURL, CommentDays, Comment, CommenterName, ActivityContent, ImageLocation, ImageDateTime, Front,ReviewDate, Review;

@synthesize TaggerId, TaggerName, TaggerArray, ActivityOwnerId, FriendId, IsMyFriend, IsFriendRequestSent, IsRequestPending, MatchCreatedDay, MatchCreatedMonth, TTTIndex;

@synthesize TTTHandicapDifferentialPerRound, TTTHandicapIndex, Rating, Slope, Eagles, Bogeys, Doubles, Other, Birdies, TotalAcheveiements, AchievementTitle, AchiementImageURL;

@synthesize AchievementDate, AchievementDescription, CourseTotalReviews, CourseBestScore, MaximumTimePlayed, CourseUserId, PhotoObject, PhotoObjectHolder, MatchObject;

@synthesize GroupName, GroupDescription, GroupOwnerId, GroupMembers, GroupImageURL, GroupCreatedTime, GroupDisscussioinCount, GroupWallCount, GroupCategory;

@synthesize DiscussionTitle, DiscussionMessage, DiscussionCreatorId, DiscussionCreatorName, LastRepliedId, LastReplierName, LastReplyDate, TotalReplies, LastRepliedBy;


-(NSString *) Encoder:(NSString *)str
{
    NSString *trimmedString = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return [trimmedString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

-(BOOL)IsContainAnythingIn:(NSString *)str except:(NSString *)exceptString
{
    if([self IsBlank:str]) return FALSE;
    else if([[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:exceptString]) return FALSE;
    else return TRUE;
}

-(BOOL)IsBlank:(NSString *)str
{
    if([str isEqual:[NSNull null]]) return TRUE;
    return ([[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""])?TRUE:FALSE;
}

-(NSData *)ConvertImageToNSData:(UIImage *)image
{
    return UIImageJPEGRepresentation(image, .4);
}

-(NSURL *)ConvertStringToNSUrl:(NSString *)String
{
    return [NSURL URLWithString:String];
}

-(NSString *)ConvertNSDataToNSString:(NSData *)data
{
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}


+ (UIColor *)colorFromHexString:(NSString *)hexString
{
   
    //IMFAPPPRINTMETHOD();
    if(![hexString isEqual:[NSNull null]] && [hexString length]>0)
    {
        unsigned rgbValue = 0;
        NSScanner *scanner = [NSScanner scannerWithString:hexString];
        [scanner setScanLocation:1]; // bypass '#' character
        [scanner scanHexInt:&rgbValue];
        return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
    }
    else
        return [UIColor blackColor];
}

-(id)initWithMenuName:(NSString *)ParamMenuName withMenuLink:(NSString *)ParamMenuLink withMenuImage:(NSString *)ParamMenuImage
{
    self=[super init];
    if(self)
    {
        [self setMenuImage:ParamMenuImage];
        [self setMenuLink:ParamMenuLink];
        [self setMenuName:ParamMenuName];
    }
    return self;
}

-(id)initWithName:(NSString *)ParamName withActivityType:(NSString *)ParamActivityType
{
    self=[super init];
    if(self)
    {
        [self setName:ParamName];
        [self setActivityType:ParamActivityType];
    }
    return  self;
}

-(id)initWithActivityId:(NSString *)ParamActivityId withActivityType:(NSString *)ParamActivityType withActivityTitle:(NSString *)ParamActivityTitle withActivityOwner:(NSString *)ParamActivityOwner withActivityOwnerImageURL:(NSString *)ParamActivityOwnerImageURL withActivityImageURL:(NSString *)ParamActivityImageURL IsMyActivity:(NSString *)ParamIsMyActivity withActivityTime:(NSString *)ParamActivityTime NoOfLikes:(NSString *)ParamNoOfLikes NoOfComments:(NSString *)ParamNoOfComments withPhoto:(NSString *)ParamPhotoURL withPhotoHeight:(NSString *)ParamPhotoHeight withPhotoWidth:(NSString *)ParamPhotoWidth withActivityContent:(NSString *)ParamActivityContent withActivityOwnerId:(NSString *)ParamActivityOwnerId withPhotoObject:(TTTGlobalMethods *)ParamPhotoObject withPhotoObjectHolder:(NSMutableArray *)ParamPhotoObjectHolder withIsUserLiked:(NSString *)ParamIsUserLiked withLikePermission:(NSString *)ParamLikePermission withCommentPermission:(NSString *)ParamCommentPermission
{
    self=[super init];
    if(self)
    {
        [self setActivityType:ParamActivityType];
        [self setActivityTitle:ParamActivityTitle];
        [self setActivityOwner:ParamActivityOwner];
        [self setActivityOwnerImageURL:ParamActivityOwnerImageURL];
        [self setActivityImageURL:ParamActivityImageURL];
        [self setActivityTime:ParamActivityTime];
        [self setNoOfComments:ParamNoOfComments];
        [self setNoOfLikes:ParamNoOfLikes];
        [self setIsMyActivity:([ParamIsMyActivity isEqualToString:@"me"])?TRUE:FALSE];
        [self setPhotoURL:ParamPhotoURL];
        [self setActivityId:ParamActivityId];
        [self setPhotoHeight:ParamPhotoHeight];
        [self setPhotoWidth:ParamPhotoWidth];
        [self setActivityContent:ParamActivityContent];
        [self setActivityOwnerId:ParamActivityOwnerId];
        [self setPhotoObject:ParamPhotoObject];
        [self setPhotoObjectHolder:ParamPhotoObjectHolder];
        [self setIsUserLiked:([ParamIsUserLiked isEqualToString:@"1"])?TRUE:FALSE];
        [self setCommentPermission:([ParamCommentPermission isEqualToString:@"1"])?TRUE:FALSE];
        [self setLikePermission:([ParamLikePermission isEqualToString:@"1"])?TRUE:FALSE];
    }
    return  self;
}

-(id)initWithActivityId:(NSString *)ParamActivityId withActivityType:(NSString *)ParamActivityType withActivityTitle:(NSString *)ParamActivityTitle withActivityOwner:(NSString *)ParamActivityOwner withActivityOwnerImageURL:(NSString *)ParamActivityOwnerImageURL withActivityImageURL:(NSString *)ParamActivityImageURL IsMyActivity:(NSString *)ParamIsMyActivity withActivityTime:(NSString *)ParamActivityTime NoOfLikes:(NSString *)ParamNoOfLikes NoOfComments:(NSString *)ParamNoOfComments withPhoto:(NSString *)ParamPhotoURL withPhotoHeight:(NSString *)ParamPhotoHeight withPhotoWidth:(NSString *)ParamPhotoWidth withActivityContent:(NSString *)ParamActivityContent withActivityOwnerId:(NSString *)ParamActivityOwnerId withPhotoObject:(TTTGlobalMethods *)ParamPhotoObject withPhotoObjectHolder:(NSMutableArray *)ParamPhotoObjectHolder withIsUserLiked:(NSString *)ParamIsUserLiked withLikePermission:(NSString *)ParamLikePermission withCommentPermission:(NSString *)ParamCommentPermission withMatchObject:(TTTGlobalMethods *)ParamMatchObject
{
    self=[super init];
    if(self)
    {
        [self setActivityType:ParamActivityType];
        [self setActivityTitle:ParamActivityTitle];
        [self setActivityOwner:ParamActivityOwner];
        [self setActivityOwnerImageURL:ParamActivityOwnerImageURL];
        [self setActivityImageURL:ParamActivityImageURL];
        [self setActivityTime:ParamActivityTime];
        [self setNoOfComments:ParamNoOfComments];
        [self setNoOfLikes:ParamNoOfLikes];
        [self setIsMyActivity:([ParamIsMyActivity isEqualToString:@"me"])?TRUE:FALSE];
        [self setPhotoURL:ParamPhotoURL];
        [self setActivityId:ParamActivityId];
        [self setPhotoHeight:ParamPhotoHeight];
        [self setPhotoWidth:ParamPhotoWidth];
        [self setActivityContent:ParamActivityContent];
        [self setActivityOwnerId:ParamActivityOwnerId];
        [self setPhotoObject:ParamPhotoObject];
        [self setPhotoObjectHolder:ParamPhotoObjectHolder];
        [self setIsUserLiked:([ParamIsUserLiked isEqualToString:@"1"])?TRUE:FALSE];
        [self setCommentPermission:([ParamCommentPermission isEqualToString:@"1"])?TRUE:FALSE];
        [self setLikePermission:([ParamLikePermission isEqualToString:@"1"])?TRUE:FALSE];
        [self setMatchObject:ParamMatchObject];
    }
    return  self;
}


-(id)initWithId:(NSString *)ParamId withMatchTitle:(NSString *)ParamMatchTitle withMatchLocation:(NSString *)ParamMatchLocation withMatchCreator:(NSString *)ParamMatchCreator withMatchImageURL:(NSString *)ParamMatchImageURL withMatchInvitedGuest:(NSString *)ParamMatchInvitedGuest withMatchConfirmGuest:(NSString *)ParamMatchConfirmGuest withMatchType:(NSString *)ParamMatchType withMatchDateTime:(NSString *)ParamMatchDateTime withMatchCourses:(NSString *)ParamMatchCourses IsMyMatch:(int)ParamIsMyMatch
{
    self=[super init];
    if(self)
    {
        [self setMatchId:ParamId];
        [self setMatchTitle:ParamMatchTitle];
        [self setMatchLocation:ParamMatchLocation];
        [self setMatchCreator:ParamMatchCreator];
        [self setMatchImageURL:ParamMatchImageURL];
        [self setMatchInvitedGuest:ParamMatchInvitedGuest];
        [self setMatchConfirmGuest:ParamMatchConfirmGuest];
        [self setMatchType:ParamMatchType];
        [self setMatchDateTime:ParamMatchDateTime];
        [self setMatchCourses:ParamMatchCourses];
        [self setIsMyMatch:(ParamIsMyMatch==1)?TRUE:FALSE];
    }
    return self;
}



-(id)initWithId:(NSString *)ParamId withCourseTitle:(NSString *)ParamCourseTitle withCourseCity:(NSString *)ParamCourseCity withCourseState:(NSString *)ParamCourseState withCourseCountry:(NSString *)ParamCourseCountry
{
    self=[super init];
    if(self)
    {
        [self setCourseId:ParamId];
        [self setCourseTitle:ParamCourseTitle];
        [self setCourseLocation:[NSString stringWithFormat:@"%@, %@, %@", ParamCourseCity, ParamCourseState, ParamCourseCountry]];
    }
    return self;
}

-(id)initWithId:(NSString *)ParamId withColorBox:(NSString *)ParamColorBox withColorCode:(NSString *)ParamColorCode
{
    self=[super init];
    if(self)
    {
        [self setId:ParamId];
        [self setColorBox:ParamColorBox];
        [self setTeeBoxColor:([ParamColorCode length]>0)?[TTTGlobalMethods colorFromHexString:ParamColorCode]:[UIColor blueColor]];
        [self setColorCode:ParamColorCode];
    }
    return self;
}

-(id)initWithId:(NSString *)ParamId withFriendName:(NSString *)ParamFriendName withFriendImageURL:(NSString *)ParamFriendImageURL withNoOfFriends:(NSString *)ParamFriendTotalFriends withFriendId:(NSString *)ParamFriendId
{
    self=[super init];
    if(self)
    {
        [self setId:ParamId];
        [self setFriendName:ParamFriendName];
        [self setFriendImageURL:ParamFriendImageURL];
        [self setFriendId:ParamFriendId];
        [self setFriendTotalFriends:[NSString stringWithFormat:@"%@ Friends", ParamFriendTotalFriends]];
    }
    return self;
}


-(id)initWithId:(NSString *)ParamId withCourseTitle:(NSString *)ParamCourseTitle withCourseCity:(NSString *)ParamCourseCity withCourseState:(NSString *)ParamCourseState withCourseCountry:(NSString *)ParamCourseCountry withTotalReview:(NSString *)ParamCourseTotalReview withAverageReview:(int)ParamCourseAverageReview withIsMycourse:(int)ParamIsMyCourse
{
    self=[super init];
    if(self)
    {
        [self setCourseId:ParamId];
        [self setCourseTitle:ParamCourseTitle];
        [self setCourseLocation:[NSString stringWithFormat:@"%@, %@, %@", ParamCourseCity, ParamCourseState, ParamCourseCountry]];
        [self setIsMyCourse:(ParamIsMyCourse==1)?TRUE:FALSE];
        [self setCourseTotalReviews:ParamCourseTotalReview];
        [self setCourseAverageReview:[NSString stringWithFormat:@"%d", ParamCourseAverageReview]];
    }
    return self;
}


-(id)initWithId:(NSString *)ParamId withUserName:(NSString *)ParamUserName withName:(NSString *)ParamFriendName withEmail:(NSString *)ParamEmail withPhotoURL:(NSString *)ParamPhotoURL
{
    self=[super init];
    if(self)
    {
        [self setId:ParamId];
        [self setUserName:ParamUserName];
        [self setFriendName:ParamFriendName];
        [self setFriendImageURL:ParamPhotoURL];
        [self setEmail:ParamEmail];
    }
    return self;
}


-(id)initWithId:(NSString *)ParamId withSenderName:(NSString *)ParamSenderName withSubject:(NSString *)ParamMessageSubject withMessage:(NSString *)ParamMessageBody withFriendImageURL:(NSString *)ParamFriendImageURL IsUnread:(NSString *)ParamIsUnread withSendDate:(NSString *)ParamSendingDate withSenderId:(NSString *)ParamSenderId
{
    self=[super init];
    if(self)
    {
        [self setId:ParamId];
        [self setSenderName:ParamSenderName];
        [self setMessageSubject:ParamMessageSubject];
        [self setMessageBody:ParamMessageBody];
        [self setIsUnread:([ParamIsUnread isEqualToString:@"1"])?TRUE:FALSE];
        [self setFriendImageURL:ParamFriendImageURL];
        [self setSendingDate:ParamSendingDate];
        [self setSenderId:ParamSenderId];
    }
    return self;
}

-(id)initWithId:(NSString *)ParamId NotificationType:(NSString *)ParamNotificationType withInvitationSenderName:(NSString *)ParamInvitationSenderName withInvitationSenderId:(NSString *)ParamInvitationSenderId withNotificationImageURL:(NSString *)ParamNotificationImageURL withNotificationEventTitle:(NSString *)ParamNotificationEventTitle
{
    self=[super init];
    if(self)
    {
        [self setId:ParamId];
        [self setNotificationType:ParamNotificationType];
        [self setNotificationImageURL:ParamNotificationImageURL];
        [self setInvitationSenderId:ParamInvitationSenderId];
        [self setInvitationSenderName:ParamInvitationSenderName];
        [self setNotificationEventTitle:ParamNotificationEventTitle];
        
        if([ParamNotificationType isEqualToString:@"event"])
        {
            [self setNotificationDisplayMessage:[NSString stringWithFormat:@"%@ has invited you to join %@ match", InvitationSenderName, ParamNotificationEventTitle]];
        }
        else if([ParamNotificationType isEqualToString:@"group"])
        {
            [self setNotificationDisplayMessage:[NSString stringWithFormat:@"%@ has invited you to join %@ group", InvitationSenderName, ParamNotificationEventTitle]];
        }
    }
    return self;
}

-(id)initWithId:(NSString *)ParamId withAlbumName:(NSString *)ParamAlbumName withAlbumDescription:(NSString *)ParamAlbumDescription withAlbumCoverImageURL:(NSString *)ParamAlbumCoverImageURL withImageData:(NSData *)ParamImageData
{
    self=[super init];
    if(self)
    {
        [self setId:ParamId];
        [self setAlbumName:ParamAlbumName];
        [self setAlbumCoverImageURL:ParamAlbumCoverImageURL];
        [self setAlbumDescription:ParamAlbumDescription];
        [self setImageData:ParamImageData];
    }
    return self;
}


-(id)initWithId:(NSString *)ParamId withAlbumId:(NSString *)ParamAlbumId withCaption:(NSString *)ParamPhotoCaption withOriginalPhotoURL:(NSString *)ParamPhotoOriginal withThumbPhotoURL:(NSString *)ParamPhotoThumb
{
    self=[super init];
    if(self)
    {
        [self setId:ParamId];
        [self setAlbumId:ParamAlbumId];
        [self setPhotoCaption:ParamPhotoCaption];
        [self setPhotoOriginal:ParamPhotoOriginal];
        [self setPhotoThumb:ParamPhotoThumb];
    }
    return self;
}


-(id)initWithId:(NSString *)ParamId withAlbumId:(NSString *)ParamAlbumId withCaption:(NSString *)ParamPhotoCaption withOriginalPhotoURL:(NSString *)ParamPhotoOriginal withThumbPhotoURL:(NSString *)ParamPhotoThumb withTotalComments:(NSString *)ParamTotalComment withTotalLikes:(NSString *)ParamTotalLikes withIsUserLiked:(NSString *)ParamIsUserLiked withDateAndTime:(NSString *)ParamImageDateTime withLocation:(NSString *)ParamImageLocation
{
    self=[super init];
    if(self)
    {
        [self setId:ParamId];
        [self setAlbumId:ParamAlbumId];
        [self setPhotoCaption:ParamPhotoCaption];
        [self setPhotoOriginal:ParamPhotoOriginal];
        [self setPhotoThumb:ParamPhotoThumb];
        [self setTotalComments:ParamTotalComment];
        [self setTotalLikes:ParamTotalLikes];
        [self setIsUserLiked:([ParamIsUserLiked isEqualToString:@"1"])?TRUE:FALSE];
        [self setImageDateTime:ParamImageDateTime];
        [self setImageLocation:ParamImageLocation];
    }
    return self;
}



-(id)initWithId:(NSString *)ParamId withMatchName:(NSString *)ParamMatchTitle withMatchDateTime:(NSString *)ParamMatchDateTime withMatchLocation:(NSString *)ParamMatchLocation withCourseTitle:(NSString *)ParamCourseTitle withTeeBoxColorCode:(NSString *)ParamColorCode withTeeBoxColorName:(NSString *)ParamTeeBoxColor withGrossScore:(NSString *)ParamGrossScore withMatchImageURL:(NSString *)ParamMatchImageURL withTeeBoxTextColor:(NSString *)ParamTeeBoxTextColor withMatchId:(NSString *)ParamMatchId
{
    self=[super init];
    if(self)
    {
        [self setId:ParamId];
        [self setMatchTitle:ParamMatchTitle];
        [self setMatchDateTime:ParamMatchDateTime];
        [self setMatchLocation:ParamMatchLocation];
        [self setCourseTitle:ParamCourseTitle];
        [self setTeeBoxColor:[TTTGlobalMethods colorFromHexString:ParamColorCode]];
        [self setTeeBoxTextColor:[TTTGlobalMethods colorFromHexString:ParamTeeBoxTextColor]];
        [self setColorBox:ParamTeeBoxColor];
        [self setGrossScore:ParamGrossScore];
        [self setMatchImageURL:ParamMatchImageURL];
        [self setMatchId:ParamMatchId];
    }
    return self;
}

-(id)initWithId:(NSString *)ParamId withHoleNumber:(NSString *)ParamHoleNumber withPar:(NSString *)ParamPar withLength:(NSString *)ParamLength withHandicap:(NSString *)ParamHandicap withGrossScore:(NSString *)ParamGrossScore withScoreBackgroundColor:(NSString *)ParamScoreBackgroundColor withScoreTextColor:(NSString *)ParamScoreTextColor
{
    self=[super init];
    if(self)
    {
        [self setId:ParamId];
        [self setHoleNumber:ParamHoleNumber];
        [self setPar:ParamPar];
        [self setLength:ParamLength];
        [self setHandicap:ParamHandicap];
       
        [self setScoreBackgroundColor:[TTTGlobalMethods colorFromHexString:ParamScoreBackgroundColor]];
        [self setScoreTextColor:[TTTGlobalMethods colorFromHexString:ParamScoreTextColor]];
    }
    return self;
}

-(id)initWithId:(NSString *)ParamId withPlayerName:(NSString *)ParamPlayerName withPlayerScore:(NSString *)ParamPlayerScore withPlayerProgress:(NSString *)ParamPlayerProgress withplayerImageURL:(NSString *)ParamPlayerImageURL
{
    self=[super init];
    if(self)
    {
        [self setId:ParamId];
        [self setPlayerImageURL:ParamPlayerImageURL];
        [self setPlayerName:ParamPlayerName];
        [self setPlayerProgress:ParamPlayerProgress];
        [self setPlayerScore:ParamPlayerScore];
    }
    return self;
}


-(id)initWithId:(NSString *)ParamId withTitle:(NSString *)ParamVideoTitle withVideoType:(NSString *)ParamVideoType withVideoURL:(NSString *)ParamVideoURL withVideoPlaceHolderImageURL:(NSString *)ParamVideoPlaceHolderImageURL withDescription:(NSString *)ParamVideoDescription
{
    self=[super init];
    if(self)
    {
        [self setId:ParamId];
        [self setVideoTitle:ParamVideoTitle];
        [self setVideoType:ParamVideoType];
        [self setVideoURL:ParamVideoURL];
        [self setVideoPlaceHolderImageURL:ParamVideoPlaceHolderImageURL];
        [self setVideoDescription:ParamVideoDescription];
    }
    return self;
}

-(id)initWithId:(NSString *)ParamId withImageData:(NSData *)ParamImageData
{
    self=[super init];
    if(self)
    {
        [self setId:ParamId];
        [self setImageData:ParamImageData];
    }
    return self;
}

-(id)initWithCommentId:(NSString *)ParamId withComment:(NSString *)ParamComment withCommenterImageURL:(NSString *)ParamCommenterImageURL withCommenterName:(NSString *)ParamCommenterName withCommentDays:(NSString *)ParamCommentDays
{
    self=[super init];
    if(self)
    {
        [self setId:ParamId];
        [self setComment:ParamComment];
        [self setCommenterImageURL:ParamCommenterImageURL];
        [self setCommenterName:ParamCommenterName];
        [self setCommentDays:ParamCommentDays];
    }
    return self;
}

-(id)initWithCommentId:(NSString *)ParamId withComment:(NSString *)ParamComment withCommenterImageURL:(NSString *)ParamCommenterImageURL withCommenterName:(NSString *)ParamCommenterName withCommentDays:(NSString *)ParamCommentDays withCommenterId:(NSString *)ParamCommenterId
{
    if(self=[super init])
    {
        [self setCommentId:ParamId];
        [self setComment:ParamComment];
        [self setCommenterImageURL:ParamCommenterImageURL];
        [self setCommenterName:ParamCommenterName];
        [self setCommenterId:ParamCommenterId];
        [self setCommentDays:ParamCommentDays];
    }
    return self;
}

-(id)initWithTaggerId:(NSString *)ParamTaggerId withTaggerName:(NSString *)ParamTaggerName
{
    self=[super init];
    if(self)
    {
        [self setTaggerId:ParamTaggerId];
        [self setTaggerName:ParamTaggerName];
    }
    return self;
}


-(id)initWithId:(NSString *)ParamId withName:(NSString *)ParamName withImageURL:(NSString *)ParamPhotoURL
{
    self=[super init];
    if(self)
    {
        [self setId:ParamId];
        [self setPhotoURL:ParamPhotoURL];
        [self setName:ParamName];
    }
    return self;
}


-(id)initWithFriendId:(NSString *)ParamFriendId withFriendName:(NSString *)ParamFriendName withFriendImageURL:(NSString *)ParamFriendImageURL withNoOfFriends:(NSString *)ParamFriendTotalFriends withIsMyFriend:(NSString *)ParamIsMyFriend withRequestPending:(NSString *)ParamIsRequestPending
{
    self=[super init];
    if(self)
    {
        [self setFriendId:ParamFriendId];
        [self setFriendName:ParamFriendName];
        [self setFriendImageURL:ParamFriendImageURL];
        [self setFriendTotalFriends:[NSString stringWithFormat:@"%@ Friend(s)", ParamFriendTotalFriends]];
        
        if([ParamIsMyFriend isEqualToString:@"0"] && [ParamIsRequestPending isEqualToString:@"0"]) [self setIsMyFriend:NO];
        if([ParamIsRequestPending integerValue]>0 && [ParamIsMyFriend integerValue]>0) [self setIsRequestPending:YES];
        if([ParamIsRequestPending isEqualToString:@"0"] && [ParamIsMyFriend integerValue]>0) [self setIsMyFriend:YES];
    }
    return self;
}


-(id)initWithId:(NSString *)ParamId withMatchTitle:(NSString *)ParamMatchTitle withCourseTitle:(NSString *)ParamCourseTitle withMatchCreatedMonth:(NSString *)ParamMatchCreatedMonth withmatchCreatedDay:(NSString *)ParamMatchCreatedDay withGrossScore:(NSString *)ParamGrossScore withLocation:(NSString *)ParamMatchLocation withMatchDateTime:(NSString *)ParamMatchDateTime withTeeBoxTextColor:(NSString *)ParamTeeBoxTextColor withTeeBoxColor:(NSString *)ParamTeeBoxColor withPar:(NSString *)ParamPar withBirdies:(NSString *)ParamBirdies withEagles:(NSString *)ParamEagles withBogeys:(NSString *)ParamBogeys withDoubles:(NSString *)ParamDoubles withOther:(NSString *)ParamOther withSlope:(NSString *)ParamSlope withRating:(NSString *)ParamRating withTeeBoxColorName:(NSString *)ParamTeeBoxColorName
{
    self=[super init];
    if(self)
    {
        [self setId:ParamId];
        [self setMatchTitle:ParamMatchTitle];
        [self setCourseTitle:ParamCourseTitle];
        [self setMatchCreatedMonth:ParamMatchCreatedMonth];
        [self setMatchCreatedDay:ParamMatchCreatedDay];
        [self setGrossScore:ParamGrossScore];
        [self setMatchLocation:ParamMatchLocation];
        [self setMatchDateTime:ParamMatchDateTime];
        [self setTeeBoxTextColor:[TTTGlobalMethods colorFromHexString:ParamTeeBoxTextColor]];
        [self setTeeBoxColor:[TTTGlobalMethods colorFromHexString:ParamTeeBoxColor]];
        [self setPar:ParamPar];
        [self setBirdies:ParamBirdies];
        [self setEagles:ParamEagles];
        [self setBogeys:ParamBogeys];
        [self setDoubles:ParamDoubles];
        [self setOther:ParamOther];
        [self setSlope:ParamSlope];
        [self setRating:ParamRating];
        [self setColorBox:ParamTeeBoxColorName];
    }
    return self;
}


-(id)initWithId:(NSString *)ParamId withMatchTitle:(NSString *)ParamMatchTitle withCourseTitle:(NSString *)ParamCourseTitle withMatchCreatedMonth:(NSString *)ParamMatchCreatedMonth withmatchCreatedDay:(NSString *)ParamMatchCreatedDay withTTTIndex:(NSString *)ParamTTTIndex withTeeBoxColorName:(NSString *)ParamTeeBoxColor withSlope:(NSString *)ParamSlope withRating:(NSString *)ParamRating withGrossScore:(NSString *)ParamGrossScore withTTTHandicapIndex:(NSString *)ParamTTTHandicapIndex withTTTHandicapDifferentialPerRound:(NSString *)ParamTTTHandicapDifferentialPerRound withMatchDateTime:(NSString *)ParamMatchDateTime withMatchLocation:(NSString *)ParamMatchLocation withTeeBoxColor:(NSString *)ParamTeeBoxColorCode withTeeBoxTextColor:(NSString *)ParamTeeBoxTextColor
{
    self=[super init];
    if(self)
    {
        [self setId:ParamId];
        [self setMatchTitle:ParamMatchTitle];
        [self setCourseTitle:ParamCourseTitle];
        [self setMatchCreatedMonth:ParamMatchCreatedMonth];
        [self setMatchCreatedDay:ParamMatchCreatedDay];
        [self setTTTIndex:ParamTTTIndex];
        [self setColorBox:ParamTeeBoxColor];
        [self setSlope:ParamSlope];
        [self setRating:ParamRating];
        [self setGrossScore:ParamGrossScore];
        [self setTTTHandicapDifferentialPerRound:ParamTTTHandicapDifferentialPerRound];
        [self setTTTHandicapIndex:ParamTTTHandicapIndex];
        [self setMatchDateTime:ParamMatchDateTime];
        [self setMatchLocation:ParamMatchLocation];
        [self setTeeBoxColor:[TTTGlobalMethods colorFromHexString:ParamTeeBoxColorCode]];
        [self setTeeBoxTextColor:[TTTGlobalMethods colorFromHexString:ParamTeeBoxTextColor]];
    }
    return self;
}

-(id)initWithId:(NSString *)ParamId withMenuName:(NSString *)ParamMenuName
{
    self=[super init];
    if(self)
    {
        [self setId:ParamId];
        [self setMenuName:ParamMenuName];
    }
    return self;
}

-(id)initWithAchievementTitle:(NSString *)ParamAchievementTitle withAchiementImageURL:(NSString *)ParamAchiementImageURL withTotalAcheviements:(NSString *)ParamTotalAcheveiements withAchievementType:(NSString *)ParamAchievementType
{
    self=[super init];
    if(self)
    {
        [self setAchievementTitle:ParamAchievementTitle];
        [self setAchiementImageURL:ParamAchiementImageURL];
        [self setTotalAcheveiements:ParamTotalAcheveiements];
        [self setAchievementType:ParamAchievementType];
    }
    return self;
}

-(id)initWithId:(NSString *)ParamId withAchievementTitle:(NSString *)ParamAchievementTitle withAchiementImageURL:(NSString *)ParamAchiementImageURL withMatchId:(NSString *)ParamMatchId withAchievementDescription:(NSString *)ParamAchievementDescription withAchievementDate:(NSString *)ParamAchievementDate
{
    if(self=[super init])
    {
        [self setId:ParamId];
        [self setAchievementTitle:ParamAchievementTitle];
        [self setAchiementImageURL:ParamAchiementImageURL];
        [self setAchievementDate:ParamAchievementDate];
        [self setMatchId:ParamMatchId];
        [self setAchievementDescription:ParamAchievementDescription];
    }
    return self;
}

-(id)initWithId:(NSString *)ParamId withCourseTitle:(NSString *)ParamCourseTitle withCourseCity:(NSString *)ParamCourseCity withCourseState:(NSString *)ParamCourseState withCourseCountry:(NSString *)ParamCourseCountry withTotalReviews:(NSString *)ParamCourseTotalReviews withBestScore:(NSString *)ParamCourseBestScore withMaximumTimePlayed:(NSString *)ParamMaximumTimePlayed withCourseUserId:(NSString *)ParamCourseUserId withReviewPercentage:(NSString *)ReviewPercentage
{
    self=[super init];
    if(self)
    {
        [self setId:ParamId];
        [self setCourseTitle:ParamCourseTitle];
        [self setCourseLocation:[NSString stringWithFormat:@"%@, %@, %@", ParamCourseCity, ParamCourseState, ParamCourseCountry]];
        [self setCourseTotalReviews:[NSString stringWithFormat:@"%@ %@",ParamCourseTotalReviews, ([ParamCourseTotalReviews integerValue]>1)?@"Reviews":@"Review"]];
        [self setCourseBestScore:[NSString stringWithFormat:@"Best Course: %@", ([ParamCourseBestScore isEqualToString:@""])?@"0":ParamCourseBestScore]];
        [self setMaximumTimePlayed:[NSString stringWithFormat:@"Played %@ %@", ParamMaximumTimePlayed, ([ParamMaximumTimePlayed integerValue]>1)?@"times":@"time"]];
        [self setCourseUserId:ParamCourseUserId];
        [self setNoOfStar:round([ReviewPercentage integerValue]/20.0f)];
    }
    return self;
}


-(id)initWithTeeBoxColorCode:(NSString *)ParamTeeBoxColorCode withRating:(NSString *)ParamRating withSlope:(NSString *)ParamSlope withFront:(NSString *)ParamFront
{
    
    if(self=[super init])
    {
        [self setTeeBoxColor:[TTTGlobalMethods colorFromHexString:ParamTeeBoxColorCode]];
        [self setSlope:ParamSlope];
        [self setFront:([ParamFront length]>0)?ParamFront:@"0"];
        [self setRating:ParamRating];
    }
    return self;
}

-(id)initWithReviewerName:(NSString *)ParamName withReviewImageURL:(NSString *)ParamPhotoURL withRating:(NSString *)ParamRating withDate:(NSString *)ParamReviewDate withReview:(NSString *)ParamReview withReviewerId:(NSString *)ParamReviewerId
{
    if(self=[super init])
    {
        [self setName:ParamName];
        [self setPhotoURL:ParamPhotoURL];
        [self setReviewDate:ParamReviewDate];
        [self setReview:ParamReview];
        [self setRating:ParamRating];
        [self setReviewerId:ParamReviewerId];
    }
    return self;
}



-(id)initWithMatchTitle:(NSString *)ParamMatchTitle withCourseTitle:(NSString *)ParamCourseTitle withMatchDateTime:(NSString *)ParamMatchDateTime withMatchConfirmGuest:(NSString *)ParamMatchConfirmGuest withMatchImageURL:(NSString *)ParamMatchImageURL withMatchId:(NSString *)ParamMatchId
{
    if(self=[super init])
    {
        [self setMatchTitle:ParamMatchTitle];
        [self setCourseTitle:ParamCourseTitle];
        [self setMatchDateTime:ParamMatchDateTime];
        [self setMatchConfirmGuest:ParamMatchConfirmGuest];
        [self setMatchImageURL:ParamMatchImageURL];
        [self setMatchId:ParamMatchId];
    }
    return self;
}


-(id)initWithId:(NSString *)ParamId withGroupName:(NSString *)ParamGroupName withGroupDescription:(NSString *)ParamGroupDescription withGroupOwnerId:(NSString *)ParamGroupOwnerId withGroupMembers:(NSString *)ParamGroupMembers withGroupImageURL:(NSString *)ParamGroupImageURL withGroupCreatedTime:(NSString *)ParamGroupCreatedTime withGroupDiscussionCount:(NSString *)ParamGroupDisscussioinCount withGroupWallCount:(NSString *)ParamGroupWallCount withGroupCategory:(NSString *)ParamGroupCategory withJoinStatus:(NSString *)ParamJoinStatus
{
    if(self=[super init])
    {
        [self setId:ParamId];
        [self setGroupName:ParamGroupName];
        [self setGroupDescription:ParamGroupDescription];
        [self setGroupOwnerId:ParamGroupOwnerId];
        [self setGroupMembers:ParamGroupMembers];
        [self setGroupImageURL:ParamGroupImageURL];
        [self setGroupCreatedTime:ParamGroupCreatedTime];
        [self setGroupDisscussioinCount:ParamGroupDisscussioinCount];
        [self setGroupWallCount:ParamGroupWallCount];
        [self setGroupCategory:ParamGroupCategory];
        [self setIsJoined:([ParamJoinStatus isEqualToString:@"1"])?TRUE:FALSE];
    }
    return self;
}

-(id)initWithGroupName:(NSString *)ParamGroupName withGroupDescription:(NSString *)ParamGroupDescription withGroupMembers:(NSString *)ParamGroupMembers withGroupCreatedTime:(NSString *)ParamGroupCreatedTime withGroupAdmins:(NSArray *)ParamGroupAdmins withJoinStatus:(NSString *)ParamJoinStatus
{
    if(self=[super init])
    {
        [self setGroupName:ParamGroupName];
        [self setGroupDescription:ParamGroupDescription];
        [self setGroupMembers:[NSString stringWithFormat:@"%@ %@", ParamGroupMembers, ([ParamGroupMembers integerValue]>1)?@"Members":@"Member"]];
        [self setGroupCreatedTime:ParamGroupCreatedTime];
        
        NSMutableString *adminMutalbeString=[NSMutableString string];
        for(NSDictionary *var in ParamGroupAdmins)[adminMutalbeString appendFormat:@", %@", [var valueForKey:@"name"]];
        
        NSString *adminString=([adminMutalbeString length]>0)?[adminMutalbeString substringWithRange:NSMakeRange(1, [adminMutalbeString length]-1)]:@"";
        [self setGroupAdmins:[NSString stringWithFormat:@"Group Administrator: %@", adminString]];
        [self setIsJoined:([ParamJoinStatus isEqualToString:@"1"])?TRUE:FALSE];
    }
    return self;
}


-(id)initWithActivityId:(NSString *)ParamActivityId withActivityTitle:(NSString *)ParamActivityTitle withActivityOwner:(NSString *)ParamActivityOwner withActivityOwnerId:(NSString *)ParamActivityOwnerId withActivityOwnerImageURL:(NSString *)ParamActivityOwnerImageURL withActivityTime:(NSString *)ParamActivityTime withTotalLikes:(NSString *)ParamTotalLikes withTotalComments:(NSString *)ParamTotalComments
{
    if(self=[super init])
    {
        [self setActivityId:ParamActivityId];
        [self setActivityTitle:ParamActivityTitle];
        [self setActivityOwner:ParamActivityOwner];
        [self setActivityOwnerId:ParamActivityOwnerId];
        [self setActivityOwnerImageURL:ParamActivityOwnerImageURL];
        [self setActivityTime:ParamActivityTime];
        [self setTotalComments:ParamTotalComments];
        [self setTotalLikes:ParamTotalLikes];
    }
    return self;
}


-(id)initWithDiscussionTitle:(NSString *)ParamDiscussionTitle withDiscussionMessage:(NSString *)ParamDiscussionMessage withDiscussionCreatorId:(NSString *)ParamDiscussionCreatorId withDiscussionCreatorName:(NSString *)ParamDiscussionCreatorName withLastRepliedId:(NSString *)ParamLastRepliedId withLastReplierName:(NSString *)ParamLastReplierName withLastReplyDate:(NSString *)ParamLastReplyDate withTotalReplies:(NSString *)ParamTotalReplies withId:(NSString *)ParamId
{
    if(self=[super init])
    {
        [self setId:ParamId];
        [self setDiscussionTitle:ParamDiscussionTitle];
        [self setDiscussionMessage:ParamDiscussionMessage];
        [self setDiscussionCreatorId:ParamDiscussionCreatorId];
        [self setDiscussionCreatorName:ParamDiscussionCreatorName];
        [self setLastRepliedId:ParamLastRepliedId];
        [self setLastReplierName:ParamLastReplierName];
        [self setLastReplyDate:ParamLastReplyDate];
        [self setTotalReplies:ParamTotalReplies];
        //[self setTotalReplies:[NSString stringWithFormat:@"%@ %@", ParamTotalReplies, ([ParamTotalReplies integerValue]>1)?@"Replies":@"Reply"]];
        [self setLastRepliedBy:[NSString stringWithFormat:@"%@ on %@", ParamLastReplierName, ParamLastReplyDate]];
    }
    return self;
}

-(id)initWithId:(NSString *)ParamId withCategoryName:(NSString *)ParamCategoryName
{
    if(self=[super init])
    {
        [self setId:ParamId];
        [self setCategoryName:ParamCategoryName];
    }
    return self;
}
@end
