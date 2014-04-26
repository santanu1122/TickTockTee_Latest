//
//  TTTGlobalMethods.h
//  Ticktocktee
//
//  Created by Iphone_2 on 17/02/14.
//  Copyright (c) 2014 com.esolz.Ticktocktee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TTTGlobalMethods : NSObject

// Declare Global Parameters

@property (nonatomic, assign) int AssignId;
@property (nonatomic, assign) int NoOfStar;


@property (nonatomic, assign) BOOL IsMyActivity;
@property (nonatomic, assign) BOOL IsMyMatch;
@property (nonatomic, assign) BOOL IsMyCourse;
@property (nonatomic, assign) BOOL IsUnread;
@property (nonatomic, assign) BOOL IsUserLiked;
@property (nonatomic, assign) BOOL IsMyFriend;
@property (nonatomic, assign) BOOL IsFriendRequestSent;
@property (nonatomic, assign) BOOL IsFriendRequestReceived;
@property (nonatomic, assign) BOOL IsRequestPending;
@property (nonatomic, assign) BOOL LikePermission;
@property (nonatomic, assign) BOOL CommentPermission;
@property (nonatomic, assign) BOOL isJoined;

@property (nonatomic, retain) NSString *Id;
@property (nonatomic, retain) NSString *MenuName;
@property (nonatomic, retain) NSString *MenuLink;
@property (nonatomic, retain) NSString *MenuImage;
@property (nonatomic, retain) NSString *ActivityType;
@property (nonatomic, retain) NSString *Name;

@property (nonatomic, retain) NSString *ActivityTitle;
@property (nonatomic, retain) NSString *ActivityOwner;
@property (nonatomic, retain) NSString *ActivityOwnerImageURL;
@property (nonatomic, retain) NSString *ActivityImageURL;
@property (nonatomic, retain) NSString *ActivityTime;
@property (nonatomic, retain) NSString *NoOfLikes;
@property (nonatomic, retain) NSString *NoOfComments;
@property (nonatomic, retain) NSString *PhotoURL;
@property (nonatomic, retain) NSString *PhotoHeight;
@property (nonatomic, retain) NSString *PhotoWidth;
@property (nonatomic, retain) NSString *ActivityId;
@property (nonatomic, retain) NSString *ActivityOwnerId;
@property (nonatomic, retain) NSString *ActivityContent;

@property (nonatomic, retain) NSString *MatchId;
@property (nonatomic, retain) NSString *MatchTitle;
@property (nonatomic, retain) NSString *MatchLocation;
@property (nonatomic, retain) NSString *MatchCreator;
@property (nonatomic, retain) NSString *MatchImageURL;
@property (nonatomic, retain) NSString *MatchInvitedGuest;
@property (nonatomic, retain) NSString *MatchConfirmGuest;
@property (nonatomic, retain) NSString *MatchType;
@property (nonatomic, retain) NSString *MatchDateTime;
@property (nonatomic, retain) NSString *MatchCourses;
@property (nonatomic, retain) NSString *GrossScore;

@property (nonatomic, retain) NSString *CourseId;
@property (nonatomic, retain) NSString *CourseTitle;
@property (nonatomic, retain) NSString *CourseLocation;
@property (nonatomic, retain) NSString *CourseAverageReview;
@property (nonatomic, retain) NSString *CourseTotalReviews;
@property (nonatomic, retain) NSString *CourseRating;
@property (nonatomic, retain) NSString *CourseBestScore;
@property (nonatomic, retain) NSString *MaximumTimePlayed;
@property (nonatomic, retain) NSString *CourseUserId;

@property (nonatomic, retain) NSString *ColorBox;
@property (nonatomic, retain) NSString *ColorCode;

@property (nonatomic, retain) UIColor *TeeBoxColor;
@property (nonatomic, retain) UIColor *TeeBoxTextColor;
@property (nonatomic, retain) UIColor *ScoreBackgroundColor;
@property (nonatomic, retain) UIColor *ScoreTextColor;

@property (nonatomic, retain) NSString *FriendName;
@property (nonatomic, retain) NSString *FriendImageURL;
@property (nonatomic, retain) NSString *FriendTotalFriends;
@property (nonatomic, retain) NSString *FriendId;

@property (nonatomic, retain) NSString *UserName;
@property (nonatomic, retain) NSString *Email;
@property (nonatomic, retain) NSString *SenderName;
@property (nonatomic, retain) NSString *MessageSubject;
@property (nonatomic, retain) NSString *MessageBody;
@property (nonatomic, retain) NSString *SendingDate;
@property (nonatomic, retain) NSString *SenderId;

@property (nonatomic, retain) NSString *NotificationType;
@property (nonatomic, retain) NSString *InvitationSenderName;
@property (nonatomic, retain) NSString *InvitationSenderId;
@property (nonatomic, retain) NSString *NotificationEventTitle;
@property (nonatomic, retain) NSString *NotificationImageURL;
@property (nonatomic, retain) NSString *NotificationDisplayMessage;

@property (nonatomic, retain) NSString *AlbumId;
@property (nonatomic, retain) NSString *AlbumName;
@property (nonatomic, retain) NSString *AlbumDescription;
@property (nonatomic, retain) NSString *AlbumCoverImageURL;
@property (nonatomic, retain) NSString *PhotoCaption;
@property (nonatomic, retain) NSString *PhotoThumb;
@property (nonatomic, retain) NSString *PhotoOriginal;
@property (nonatomic, retain) NSString *Comment;
@property (nonatomic, retain) NSString *CommentDays;
@property (nonatomic, retain) NSString *CommenterImageURL;
@property (nonatomic, retain) NSString *CommenterName;
@property (nonatomic, retain) NSString *TotalComments;
@property (nonatomic, retain) NSString *TotalLikes;
@property (nonatomic, retain) NSString *ImageDateTime;
@property (nonatomic, retain) NSString *ImageLocation;
@property (nonatomic, retain) NSString *CommenterId;
@property (nonatomic, retain) NSString *CommentId;

@property (nonatomic, retain) NSString *HoleNumber;
@property (nonatomic, retain) NSString *Par;
@property (nonatomic, retain) NSString *Length;
@property (nonatomic, retain) NSString *Handicap;

@property (nonatomic, retain) NSString *PlayerName;
@property (nonatomic, retain) NSString *PlayerScore;
@property (nonatomic, retain) NSString *PlayerProgress;
@property (nonatomic, retain) NSString *PlayerImageURL;

@property (nonatomic, retain) NSString *VideoTitle;
@property (nonatomic, retain) NSString *VideoType;
@property (nonatomic, retain) NSString *VideoURL;
@property (nonatomic, retain) NSString *VideoPlaceHolderImageURL;
@property (nonatomic, retain) NSString *VideoDescription;

@property (nonatomic, retain) NSString *TaggerId;
@property (nonatomic, retain) NSString *TaggerName;

@property (nonatomic, retain) NSString *MatchCreatedMonth;
@property (nonatomic, retain) NSString *MatchCreatedDay;
@property (nonatomic, retain) NSString *TTTIndex;
@property (nonatomic, retain) NSString *TTTHandicapDifferentialPerRound;
@property (nonatomic, retain) NSString *TTTHandicapIndex;
@property (nonatomic, retain) NSString *Rating;
@property (nonatomic, retain) NSString *Slope;
@property (nonatomic, retain) NSString *Eagles;
@property (nonatomic, retain) NSString *Bogeys;
@property (nonatomic, retain) NSString *Doubles;
@property (nonatomic, retain) NSString *Other;
@property (nonatomic, retain) NSString *Birdies;
@property (nonatomic, retain) NSString *TotalAcheveiements;
@property (nonatomic, retain) NSString *AchievementTitle;
@property (nonatomic, retain) NSString *AchiementImageURL;
@property (nonatomic, retain) NSString *AchievementDate;
@property (nonatomic, retain) NSString *AchievementDescription;
@property (nonatomic, retain) NSString *AchievementType;
@property (nonatomic, retain) NSString *Front;
@property (nonatomic, retain) NSString *ReviewDate;
@property (nonatomic, retain) NSString *Review;
@property (nonatomic, retain) NSString *ReviewerId;

@property (nonatomic, retain) NSString *GroupName;
@property (nonatomic, retain) NSString *GroupDescription;
@property (nonatomic, retain) NSString *GroupOwnerId;
@property (nonatomic, retain) NSString *GroupMembers;
@property (nonatomic, retain) NSString *GroupImageURL;
@property (nonatomic, retain) NSString *GroupCreatedTime;
@property (nonatomic, retain) NSString *GroupDisscussioinCount;
@property (nonatomic, retain) NSString *GroupWallCount;
@property (nonatomic, retain) NSString *GroupCategory;
@property (nonatomic, retain) NSString *GroupAdmins;

@property (nonatomic, retain) NSString *DiscussionTitle;
@property (nonatomic, retain) NSString *DiscussionMessage;
@property (nonatomic, retain) NSString *DiscussionCreatorId;
@property (nonatomic, retain) NSString *DiscussionCreatorName;
@property (nonatomic, retain) NSString *LastRepliedId;
@property (nonatomic, retain) NSString *LastReplierName;
@property (nonatomic, retain) NSString *LastReplyDate;
@property (nonatomic, retain) NSString *LastRepliedBy;
@property (nonatomic, retain) NSString *TotalReplies;
@property (nonatomic, retain) NSString *CategoryName;

@property (nonatomic, retain) NSData *ImageData;

@property (nonatomic, retain) NSArray *TaggerArray;

@property (nonatomic, retain) NSMutableArray *PhotoObjectHolder;

@property (nonatomic, retain) TTTGlobalMethods *PhotoObject;
@property (nonatomic, retain) TTTGlobalMethods *MatchObject;


// General Methods Decleration

-(BOOL)IsBlank:(NSString *)str;
-(BOOL)IsContainAnythingIn:(NSString *)str except:(NSString *)exceptString;
-(NSString *) Encoder:(NSString *)str;
-(NSData *)ConvertImageToNSData:(UIImage *)image;
-(NSURL *)ConvertStringToNSUrl:(NSString *)String;
-(NSString *)ConvertNSDataToNSString:(NSData *)data;
+ (UIColor *)colorFromHexString:(NSString *)hexString;


-(id)initWithMenuName:(NSString *)MenuName withMenuLink:(NSString *)MenuLink withMenuImage:(NSString *)MenuImage;
-(id)initWithName:(NSString *)Name withActivityType:(NSString *)ActivityType;

//Object-type: Activity

-(id)initWithActivityId:(NSString *)ActivityId withActivityType:(NSString *)ActivityType withActivityTitle:(NSString *)ActivityTitle withActivityOwner:(NSString *)ActivityOwner withActivityOwnerImageURL:(NSString *)ActivityOwnerImageURL withActivityImageURL:(NSString *)ActivityImageURL IsMyActivity:(NSString *)IsMyActivity withActivityTime:(NSString *)ActivityTime NoOfLikes:(NSString *)NoOfLikes NoOfComments:(NSString *)NoOfComments withPhoto :(NSString *)PhotoURL withPhotoHeight :(NSString *)PhotoHeight withPhotoWidth :(NSString *)PhotoWidth withActivityContent :(NSString *)ActivityContent withActivityOwnerId :(NSString *)ActivityOwnerId withPhotoObject :(TTTGlobalMethods *)PhotoObject withPhotoObjectHolder :(NSMutableArray *)PhotoObjectHolder withIsUserLiked :(NSString *)IsUserLiked withLikePermission :(NSString *)LikePermission withCommentPermission :(NSString *)CommentPermission;

-(id)initWithActivityId:(NSString *)ActivityId withActivityType:(NSString *)ActivityType withActivityTitle:(NSString *)ActivityTitle withActivityOwner:(NSString *)ActivityOwner withActivityOwnerImageURL:(NSString *)ActivityOwnerImageURL withActivityImageURL:(NSString *)ActivityImageURL IsMyActivity:(NSString *)IsMyActivity withActivityTime:(NSString *)ActivityTime NoOfLikes:(NSString *)NoOfLikes NoOfComments:(NSString *)NoOfComments withPhoto :(NSString *)PhotoURL withPhotoHeight :(NSString *)PhotoHeight withPhotoWidth :(NSString *)PhotoWidth withActivityContent :(NSString *)ActivityContent withActivityOwnerId :(NSString *)ActivityOwnerId withPhotoObject :(TTTGlobalMethods *)PhotoObject withPhotoObjectHolder :(NSMutableArray *)PhotoObjectHolder withIsUserLiked :(NSString *)IsUserLiked withLikePermission :(NSString *)LikePermission withCommentPermission :(NSString *)CommentPermission withMatchObject :(TTTGlobalMethods *)MatchObject;

-(id)initWithActivityId :(NSString *)ActivityId withActivityTitle :(NSString *)ActivityTitle withActivityOwner :(NSString *)ActivityOwner withActivityOwnerId :(NSString *)ActivityOwnerId withActivityOwnerImageURL :(NSString *)ActivityOwnerImageURL withActivityTime :(NSString *)ActivityTime withTotalLikes :(NSString *)TotalLikes withTotalComments :(NSString *)TotalComments;

//Object-type: Matches

-(id)initWithId :(NSString *)Id withMatchTitle :(NSString *)MatchTitle withMatchLocation :(NSString *)MatchLocation withMatchCreator :(NSString *)MatchCreator withMatchImageURL :(NSString *)MatchImageURL withMatchInvitedGuest :(NSString *)MatchInvitedGuest withMatchConfirmGuest :(NSString *)MatchConfirmGuest withMatchType :(NSString *)MatchType withMatchDateTime :(NSString *)MatchDateTime withMatchCourses :(NSString *)MatchCourses IsMyMatch :(int)IsMyMatch;

-(id)initWithId :(NSString *)Id withColorBox :(NSString *)ColorBox withColorCode :(NSString *)ColorCode;

-(id)initWithMatchTitle :(NSString *)MatchTitle withCourseTitle :(NSString *)CourseTitle withMatchDateTime :(NSString *)MatchDateTime withMatchConfirmGuest :(NSString *)MatchConfirmGuest withMatchImageURL :(NSString *)MatchImageURL withMatchId :(NSString *)MatchId;


//Object-type: Friend

-(id)initWithId :(NSString *)Id withFriendName :(NSString *)FriendName withFriendImageURL :(NSString *)FriendImageURL withNoOfFriends :(NSString *)FriendTotalFriends withFriendId :(NSString *)FriendId;

-(id)initWithFriendId :(NSString *)FriendId withFriendName :(NSString *)FriendName withFriendImageURL :(NSString *)FriendImageURL withNoOfFriends :(NSString *)FriendTotalFriends withIsMyFriend :(NSString *)IsMyFriend withRequestPending :(NSString *)IsRequestPending;

//Object-type: Courses

-(id)initWithId :(NSString *)Id withCourseTitle :(NSString *)CourseTitle withCourseCity :(NSString *)CourseCity withCourseState :(NSString *)CourseState withCourseCountry :(NSString *)CourseCountry;


-(id)initWithId :(NSString *)Id withCourseTitle :(NSString *)CourseTitle withCourseCity :(NSString *)CourseCity withCourseState :(NSString *)CourseState withCourseCountry :(NSString *)CourseCountry withTotalReview :(NSString *)CourseTotalReview withAverageReview :(int)CourseAverageReview withIsMycourse :(int)IsMyCourse;

-(id)initWithId :(NSString *)Id withCourseTitle :(NSString *)CourseTitle withCourseCity :(NSString *)CourseCity withCourseState :(NSString *)CourseState withCourseCountry :(NSString *)CourseCountry withTotalReviews :(NSString *)CourseTotalReviews withBestScore :(NSString *)CourseBestScore withMaximumTimePlayed :(NSString *)MaximumTimePlayed withCourseUserId :(NSString *)CourseUserId withReviewPercentage :(NSString *)ReviewPercentage;

-(id)initWithReviewerName :(NSString *)Name withReviewImageURL :(NSString *)PhotoURL withRating :(NSString *)Rating withDate:(NSString *)ReviewDate withReview :(NSString *)Review withReviewerId:(NSString *)ReviewerId;


//Object-type: Chat

-(id)initWithId :(NSString *)Id withUserName :(NSString *)UserName withName :(NSString *)FriendName withEmail :(NSString *)Email withPhotoURL :(NSString *)PhotoURL;

//Object-type: Message

-(id)initWithId :(NSString *)Id withSenderName :(NSString *)SenderName withSubject :(NSString *)MessageSubject withMessage :(NSString *)MessageBody withFriendImageURL :(NSString *)FriendImageURL IsUnread :(NSString *)IsUnread withSendDate :(NSString *)SendingDate withSenderId :(NSString *)SenderId;

//Object-type: Notification

-(id)initWithId :(NSString *)Id NotificationType :(NSString *)NotificationType withInvitationSenderName :(NSString *)InvitationSenderName withInvitationSenderId :(NSString *)InvitationSenderId withNotificationImageURL :(NSString *)NotificationImageURL withNotificationEventTitle :(NSString *)NotificationEventTitle;



//Object-type: Images

-(id)initWithId :(NSString *)Id withAlbumName :(NSString *)AlbumName withAlbumDescription :(NSString *)AlbumDescription withAlbumCoverImageURL :(NSString *)AlbumCoverImageURL withImageData :(NSData *)ImageData;

-(id)initWithId :(NSString *)Id withAlbumId :(NSString *)AlbumId withCaption :(NSString *)PhotoCaption withOriginalPhotoURL :(NSString *)PhotoOriginal withThumbPhotoURL :(NSString *)PhotoThumb;

-(id)initWithId :(NSString *)Id withAlbumId :(NSString *)AlbumId withCaption :(NSString *)PhotoCaption withOriginalPhotoURL :(NSString *)PhotoOriginal withThumbPhotoURL :(NSString *)PhotoThumb withTotalComments :(NSString *)TotalComment withTotalLikes :(NSString *)TotalLikes withIsUserLiked :(NSString *)IsUserLiked withDateAndTime:(NSString *)ImageDateTime withLocation :(NSString *)ImageLocation;

-(id)initWithId :(NSString *)Id withImageData :(NSData *)ImageData;

-(id)initWithCommentId :(NSString *)Id withComment :(NSString *)Comment withCommenterImageURL :(NSString *)CommenterImageURL withCommenterName :(NSString *)CommenterName withCommentDays :(NSString *) CommentDays;

-(id)initWithCommentId :(NSString *)Id withComment :(NSString *)Comment withCommenterImageURL :(NSString *)CommenterImageURL withCommenterName :(NSString *)CommenterName withCommentDays :(NSString *) CommentDays withCommenterId :(NSString *)CommenterId;

-(id)initWithTaggerId :(NSString *)TaggerId withTaggerName :(NSString *)TaggerName;

-(id)initWithId :(NSString *)Id withName :(NSString *)Name withImageURL :(NSString *)PhotoURL;


//Object-type: Videos

-(id)initWithId :(NSString *)Id withTitle :(NSString *)VideoTitle withVideoType :(NSString *)VideoType withVideoURL :(NSString *)VideoURL withVideoPlaceHolderImageURL :(NSString *)VideoPlaceHolderImageURL withDescription :(NSString *)VideoDescription;



//Object-type: Score

-(id)initWithId :(NSString *)Id withMatchName :(NSString *)MatchTitle withMatchDateTime :(NSString *)MatchDateTime withMatchLocation :(NSString *)MatchLocation withCourseTitle :(NSString *)CourseTitle withTeeBoxColorCode :(NSString *)ColorCode withTeeBoxColorName :(NSString *)TeeBoxColor withGrossScore :(NSString *)GrossScore withMatchImageURL :(NSString *)MatchImageURL withTeeBoxTextColor :(NSString *)TeeBoxTextColor withMatchId:(NSString *)MatchId;


//Scorecard

-(id)initWithId :(NSString *)Id withHoleNumber :(NSString *)HoleNumber withPar :(NSString *)Par withLength :(NSString *)Length withHandicap :(NSString *)Handicap withGrossScore :(NSString *)GrossScore withScoreBackgroundColor :(NSString *)ScoreBackgroundColor withScoreTextColor :(NSString *)ScoreTextColor;

-(id)initWithId :(NSString *)Id withPlayerName :(NSString *)PlayerName withPlayerScore :(NSString *)PlayerScore withPlayerProgress :(NSString *)PlayerProgress withplayerImageURL :(NSString *)PlayerImageURL;


// Object-type : Statistic

-(id)initWithId :(NSString *)Id withMatchTitle :(NSString *)MatchTitle withCourseTitle :(NSString *)CourseTitle withMatchCreatedMonth :(NSString *)MatchCreatedMonth withmatchCreatedDay :(NSString *)MatchCreatedDay withGrossScore :(NSString *)GrossScore withLocation :(NSString *)MatchLocation withMatchDateTime :(NSString *)MatchDateTime withTeeBoxTextColor :(NSString *)TeeBoxTextColor withTeeBoxColor :(NSString *)TeeBoxColor withPar :(NSString *)Par withBirdies:(NSString *)Birdies withEagles :(NSString *)Eagles withBogeys :(NSString *)Bogeys withDoubles :(NSString *)Doubles withOther :(NSString *)Other withSlope :(NSString *)Slope withRating :(NSString *)Rating withTeeBoxColorName :(NSString *)TeeBoxColor;

-(id)initWithId :(NSString *)Id withMatchTitle :(NSString *)MatchTitle withCourseTitle :(NSString *)CourseTitle withMatchCreatedMonth :(NSString *)MatchCreatedMonth withmatchCreatedDay :(NSString *)MatchCreatedDay withTTTIndex :(NSString *)TTTIndex withTeeBoxColorName :(NSString *)TeeBoxColor withSlope :(NSString *)Slope withRating :(NSString *)Rating withGrossScore :(NSString *)GrossScore withTTTHandicapIndex :(NSString *)TTTHandicapIndex withTTTHandicapDifferentialPerRound :(NSString *)TTTHandicapDifferentialPerRound withMatchDateTime :(NSString *)MatchDateTime withMatchLocation :(NSString *)MatchLocation withTeeBoxColor:(NSString *)TeeBoxColorCode withTeeBoxTextColor:(NSString *)TeeBoxTextColor;


-(id)initWithAchievementTitle :(NSString *)AchievementTitle withAchiementImageURL :(NSString *)AchiementImageURL withTotalAcheviements :(NSString *)TotalAcheveiements withAchievementType:(NSString *)AchievementType;

-(id)initWithId :(NSString *)Id withAchievementTitle :(NSString *)AchievementTitle  withAchiementImageURL :(NSString *)AchiementImageURL withMatchId :(NSString *)MatchId withAchievementDescription :(NSString *)AchievementDescription withAchievementDate :(NSString *)AchievementDate;

-(id)initWithTeeBoxColorCode:(NSString *)TeeBoxColorCode withRating :(NSString *)Rating withSlope :(NSString *)Slope withFront :(NSString *)Front;

//Object-type : Filter Menu

-(id)initWithId :(NSString *)Id withMenuName :(NSString *)MenuName;

//Object-type : Groups

-(id)initWithId: (NSString *)Id withGroupName: (NSString *)GroupName withGroupDescription :(NSString *)GroupDescription withGroupOwnerId :(NSString *)GroupOwnerId withGroupMembers :(NSString *)GroupMembers withGroupImageURL :(NSString *)GroupImageURL withGroupCreatedTime :(NSString *)GroupCreatedTime withGroupDiscussionCount :(NSString *)GroupDisscussioinCount withGroupWallCount :(NSString *)GroupWallCount withGroupCategory :(NSString *)GroupCategory withJoinStatus :(NSString *)JoinStatus;

-(id)initWithGroupName:(NSString *)GroupName withGroupDescription :(NSString *)GroupDescription withGroupMembers :(NSString *)GroupMembers withGroupCreatedTime :(NSString *)GroupCreatedTime withGroupAdmins :(NSArray *)GroupAdmins withJoinStatus :(NSString *)JoinStatus;

-(id)initWithDiscussionTitle :(NSString *)DiscussionTitle withDiscussionMessage :(NSString *)DiscussionMessage withDiscussionCreatorId :(NSString *)DiscussionCreatorId withDiscussionCreatorName :(NSString *)DiscussionCreatorName withLastRepliedId :(NSString *)LastRepliedId withLastReplierName :(NSString *)LastReplierName withLastReplyDate :(NSString *)LastReplyDate withTotalReplies :(NSString *)TotalReplies withId :(NSString *)Id;

-(id)initWithId :(NSString *)Id withCategoryName :(NSString *)CategoryName;


@end
