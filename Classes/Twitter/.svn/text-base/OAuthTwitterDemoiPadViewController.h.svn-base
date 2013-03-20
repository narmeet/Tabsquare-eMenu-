//
//  OAuthTwitterDemoiPadViewController.h
//  OAuthTwitterDemo
//
//  Created by Gautam on 29 Feb 2012.
//  Copyright IBC Mobile. 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SA_OAuthTwitterController.h"
#import "TwitterResponseDelegateiPad.h"


@class SA_OAuthTwitterEngine;
@class TabSquareFavouriteViewController;

@interface OAuthTwitterDemoiPadViewController : UIViewController <SA_OAuthTwitterControllerDelegate,UITabBarControllerDelegate> {
    
    SA_OAuthTwitterEngine				*_engine;
    UITabBarController                  *objTabbarCtrl;
    
}

@property (nonatomic,strong)TabSquareFavouriteViewController *favouriteView;
@property (strong, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (nonatomic, strong) id <TwitterResponseDelegateiPad> delegate;
@property (nonatomic, strong) UITabBarController   *objTabbarCtrl;
@property (nonatomic, strong) SA_OAuthTwitterEngine	*_engine;;



+ (OAuthTwitterDemoiPadViewController*) sharedData;

- (void) searchingUser:(NSString *)user;
- (void) clearCredentials;
- (void) logout;
- (void) userInfo;
- (void) followingInfo;
- (void) followersInfo;
- (void) userInfoForId:(NSString *)personId;
- (void) notificationsOn:(BOOL)isNotificationOn;
- (void) followingRecentPhotos:(int)forPage maxId:(NSString *)maxId;
- (void) tweetInfo:(unsigned long long)updateId;
- (void) personTweets:(NSString *)personId pageNumber:(int)pgNo;
- (void) personTweets:(NSString *)personId pageNumber:(int)pgNo maxId:(NSString *)maxId;
- (void) sendTweetInReply:(NSMutableDictionary *)replyDict;
- (void) sendTweetWithimageUploading:(NSMutableDictionary *)replyDict;

- (void) setFavourite:(NSString *)tweetId  asFavorite:(BOOL)isFavourite;
- (void) getFavourite:(int) forPage;
- (void) getFavourite:(NSString *)personId pageNumber:(int)pgNo maxId:(NSString *)maxId;
- (void) getAllFriends:(NSString *)cursor;
- (void) getAllFollowers:(NSString *)cursor;
- (void) getUsersInformation:(NSString *)usersId;

- (void) cancelCurrentRequests;

@end

