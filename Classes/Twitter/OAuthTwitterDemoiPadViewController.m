//
//  OAuthTwitterDemoiPadViewController.m
//  OAuthTwitterDemo
//
//  Created by Ben Gottlieb on 7/24/09.
//  Copyright Stand Alone, Inc. 2009. All rights reserved.
//

#import "OAuthTwitterDemoiPadViewController.h"
#import "SA_OAuthTwitterEngine.h"
#import "Utils.h"
#import "TabSquareFavouriteViewController.h"

/*#import "NewiPadVC.h"
#import "PhotosiPadVC.h"
#import "FollowersiPadVC.h"
#import "FollowingiPadVC.h"
#import "SearchiPadVC.h"
#import "FavouriteiPadVC.h"*/

/*
//For Paid Version
#define kOAuthConsumerKey_Paid				@"NH2q5U5UCFEcu68FSV9Cg"		//REPLACE ME
#define kOAuthConsumerSecret_Paid			@"3qpIiOceWeeueNnBf3Qo0QjYHu77XcVzc7KrzIInQ"		//REPLACE ME

//For Free Version
#define kOAuthConsumerKey_Free				@"h56ldYNzEfsSNIEaDooA"		//REPLACE ME
#define kOAuthConsumerSecret_Free			@"5jafsBFSLLGI1sTWnfiphO7dy3gSJFrkXc9RwbGVcY"		//REPLACE ME
*/


//For Paid Version
//#define kOAuthConsumerKey_Paid				@"H234HnKV07Q9Opy4151k4A"		//REPLACE ME
//#define kOAuthConsumerSecret_Paid			@"FtcVZ5VdAIFBCW7uaLcC2tLdCo6tNYf5dzppQKef9nU"		//REPLACE ME

//For Free Version
//#define kOAuthConsumerKey_Free				@"iHTZzE0QrhjgbLyD3Yboqw"		//REPLACE ME
//#define kOAuthConsumerSecret_Free			@"tY34NOFgVuFhyvNyki96yuayZFevEFWF3mrccLyA"		//REPLACE ME

#define kOAuthConsumerKey_Free				@"ZNdmXpbFLA5Sl70a9UEA"		//REPLACE ME
#define kOAuthConsumerSecret_Free			@"AzgVnTgGSIg8JWrNHg4yoiUoLq9AcP42Gn2i4To80"		//REPLACE ME

#define kIsLoggedIn                     @"isLoggedIn"

@implementation OAuthTwitterDemoiPadViewController
@synthesize backgroundImageView;
@synthesize delegate,_engine;
@synthesize objTabbarCtrl;
@synthesize favouriteView;


//=============================================================================================================================
#pragma mark SA_OAuthTwitterEngineDelegate
- (void) storeCachedTwitterOAuthData: (NSString *) data forUsername: (NSString *) username 
{
    
    NSUserDefaults			*defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject: data forKey: @"authData"];
    [defaults synchronize];
    
}

- (NSString *) cachedTwitterOAuthDataForUsername: (NSString *) username 
{
    NSString *accessToken = [[NSUserDefaults standardUserDefaults] objectForKey: @"authData"];
    return accessToken;
    
}


- (void) responseOfTwt:(id) response requestIdentifier:(NSString *)identifier
{
    [self.delegate twitterResponse:response];
}

- (void) parsingTwitterAPIError
{
    [self.delegate twitterServiceFailed];
}

//=============================================================================================================================
#pragma mark SA_OAuthTwitterControllerDelegate
- (void) OAuthTwitterController: (SA_OAuthTwitterController *) controller authenticatedWithUsername: (NSString *) username 
{
    
    DLog(@"Authenicated for %@", username);
    
}

- (void) OAuthTwitterControllerFailed: (SA_OAuthTwitterController *) controller 
{
    
    DLog(@"Authentication Failed!");
    UIAlertView *aAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Authentication Failed!\n Try Again" delegate:nil cancelButtonTitle:@"O.K." otherButtonTitles: nil];
    [aAlert show];
    aAlert = nil;
}

- (void) OAuthTwitterControllerCanceled: (SA_OAuthTwitterController *) controller 
{
	DLog(@"Authentication Canceled.");
    
    
    [self.navigationController popViewControllerAnimated:NO];
    
}

//=============================================================================================================================
#pragma mark TwitterEngineDelegate
- (void) requestSucceeded: (NSString *) requestIdentifier 
{
    
    DLog(@"Request %@ succeeded", requestIdentifier);
    
}


-(void)requestFailed:(NSString *)requestIdentifier withError:(NSError *)error 
{
        //[[TwtBoothAppDelegate getDelegate] hideIndicator];
    
    NSString *errorReason = nil;
    DLog(@"Error.Code : %i",error.code);
    if(error.code == 502)
        errorReason = @"Twitter is down or being upgraded.";
    else if(error.code == 503)
        errorReason = @"The Twitter servers are up, but overloaded with requests. Try again later.";
    else if(error.code == 406)
        errorReason = @"Returned by the Search API when an invalid format is specified in the request.";
    else if(error.code == 500)
        errorReason = @"Something is broken. Try Again";
    
    
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:errorReason delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];
        [alert show];
        alert = nil;
        [self.delegate twitterServiceFailed];
}




//=============================================================================================================================

static OAuthTwitterDemoiPadViewController*	singleton;

+ (OAuthTwitterDemoiPadViewController*) sharedData
{
	if (!singleton) 
	{
		singleton = [[OAuthTwitterDemoiPadViewController alloc] init];
	}
	return singleton;
}

-(id) init
{
    
    if (self = [super init]) 
    {
        SA_OAuthTwitterEngine *_engineTemp = [[SA_OAuthTwitterEngine alloc] initOAuthWithDelegate: self];
        self._engine = _engineTemp;
        
#if isPAIDVERSION
        
        self._engine.consumerKey = kOAuthConsumerKey_Paid;
        self._engine.consumerSecret = kOAuthConsumerSecret_Paid;
#else
        
        self._engine.consumerKey = kOAuthConsumerKey_Free;
        self._engine.consumerSecret = kOAuthConsumerSecret_Free;
#endif

    }
    return self;
}




- (void) viewDidLoad
{
    
    [super viewDidLoad];

    UIImage *splashImage = nil;
    
#if isPAIDVERSION
    splashImage = [UIImage imageNamed:@"ipad_login-screenblueeyes.png"];
#else
    splashImage = [UIImage imageNamed:@"ipad_login-screenyelleweyes.png"];
#endif
    self.backgroundImageView.image = splashImage;    
    [self.backgroundImageView setFrame:CGRectMake(0, 00, 768, 1004)];

    
}

- (void) viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    
    NSUserDefaults *userPref =  [NSUserDefaults standardUserDefaults];
    BOOL    isSignedIn = [userPref boolForKey:kIsLoggedIn];

    UIViewController *controller = nil;
        controller = [SA_OAuthTwitterController controllerToEnterCredentialsWithTwitterEngine: self._engine delegate: self];
    
    if (controller && !isSignedIn) 
    {
        [self presentModalViewController:controller animated:YES];
    }
    else 
    {
        //[Utils showToast:self.view withText:@"Logged In"];
        NSUserDefaults *userPref =  [NSUserDefaults standardUserDefaults];
        [userPref setBool:YES forKey:kIsLoggedIn];
        [userPref synchronize];
        
    }
    
}



- (void) viewDidAppear:(BOOL)animated
{
    
    NSUserDefaults *userPref =  [NSUserDefaults standardUserDefaults];
    BOOL    isSignedIn = [userPref boolForKey:kIsLoggedIn];
    if(isSignedIn)
    {
        
        if(self.objTabbarCtrl)
        {
            [self.objTabbarCtrl removeFromParentViewController];
            objTabbarCtrl = nil;
            
        }
        UITabBarController *tabBarCtrl = [[UITabBarController alloc] init];
        self.objTabbarCtrl = tabBarCtrl;
        
        NSMutableArray* vcMutableArray = [[NSMutableArray alloc] init];
 
       /* NewiPadVC* VC1 = [[NewiPadVC alloc] init];
        UINavigationController* newNav = [[UINavigationController alloc] initWithRootViewController:VC1];
        [vcMutableArray addObject:newNav];
        newNav.tabBarItem.title = @"New";
        newNav.tabBarItem.image = [UIImage imageNamed:@"new_tab.png"];
        newNav.tabBarItem.tag   = 0;
        [VC1 release];
        [newNav release];*/
        
        
        [self.objTabbarCtrl setViewControllers:vcMutableArray];
        self.objTabbarCtrl.delegate = self;
        
#if isPAIDVERSION        
        NSUserDefaults *userPref =  [NSUserDefaults standardUserDefaults];
        NSString *themeStr = [userPref objectForKey:kThemeColor];
        if(themeStr.length > 0)
           // [TwtBoothAppDelegate getDelegate].themeColor = themeStr;
        else
            //[TwtBoothAppDelegate getDelegate].themeColor = @"grayColor";
#else
        //[TwtBoothAppDelegate getDelegate].themeColor = @"grayColor";
#endif
        

        [self.navigationController presentModalViewController:self.objTabbarCtrl animated:NO];
    }
}


#pragma mark Twitter API Methods : 

- (void) searchingUser:(NSString *)user
{
    [self._engine searchUser:user];

}

- (void) getAllFriends:(NSString *)cursor
{
    NSDictionary *userInfoDic = [favouriteView loggedInUserData];
    BOOL isAlertShouldShow = NO;
    if (userInfoDic)
    {
        NSString *userId = userInfoDic[@"id_str"];
        if(userId.length > 0)
            [self._engine getAllFriends:userId pageNumber:cursor];
        else
            isAlertShouldShow = YES;
    }
    else
        isAlertShouldShow = YES;
    
    if(isAlertShouldShow)
    {
        //[Utils showToast:[TwtBoothAppDelegate getDelegate].window withText:@"Error, First reload the New Page"];
        //[[TwtBoothAppDelegate getDelegate] hideIndicator];
    }    
}
- (void) getAllFollowers:(NSString *)cursor
{
    NSDictionary *userInfoDic = [favouriteView loggedInUserData];
    BOOL isAlertShouldShow = NO;
    if (userInfoDic)
    {
        NSString *userId = userInfoDic[@"id_str"];
        if(userId.length > 0)
            [self._engine getAllFollowers:userId pageNumber:cursor];
        else
            isAlertShouldShow = YES;
    }
    else
        isAlertShouldShow = YES;
    
    if(isAlertShouldShow)
    {
        //[Utils showToast:[TwtBoothAppDelegate getDelegate].window withText:@"Error, First reload the New Page"];
       // [[TwtBoothAppDelegate getDelegate] hideIndicator];
    }    
}


- (void) getUsersInformation:(NSString *)usersId
{
    [self._engine getUsersInformation:usersId];
}


- (void) userInfo
{
    [self._engine checkUserCredentials];
    
}


- (void) followingRecentPhotos:(int)forPage maxId:(NSString *)maxId
{
    [self._engine getFollowedTimelineSinceID:0 withMaximumID:maxId startingAtPage:0 count:200];
    
}

- (void) personTweets:(NSString *)personId pageNumber:(int)pgNo
{
    [self._engine getUserTimelineFor:personId sinceID:0 startingAtPage:pgNo count:200];
}

- (void) personTweets:(NSString *)personId pageNumber:(int)pgNo maxId:(NSString *)maxId
{
    [self._engine getUserTimelineFor:personId sinceID:@"0" withMaximumID:maxId startingAtPage:0 count:200];
    
}



- (void) followingInfo
{
    [self._engine getRecentlyUpdatedFriendsFor:nil startingAtPage:1];
    
    
}

- (void) followersInfo
{
    [self._engine getFollowersIncludingCurrentStatus];
    
}

- (void) tweetInfo:(unsigned long long)updateId
{
    //        [self._engine getRepliesSinceID:updateId startingAtPage:1 count:200];
    //    [self._engine getUpdate:updateId];
    //        [self._engine getUpdate:updateId];  
    //    [self._engine getRetweets:updateId];
    
    
}

- (void) sendTweetInReply:(NSMutableDictionary *)replyDict
{
    [self._engine sendUpdate:replyDict];
}

- (void) sendTweetWithimageUploading:(NSMutableDictionary *)replyDict
{
    
//    NSDictionary *locationDict = replyDict[@"location"];
   // NSString *lati   = [locationDict objectForKey:KeyLattitude];
    //NSString *longi  = [locationDict objectForKey:KeyLongitude];
//    NSString *status = replyDict[@"status"];
//    UIImage   *image = replyDict[@"image"];
    
   // [self._engine sendUpdate:status uploadPhoto:image latitude:[lati doubleValue] longitude:[longi doubleValue]];
    
}
- (void) logout
{
    
    NSUserDefaults *userPref =  [NSUserDefaults standardUserDefaults];
   // [userPref setObject:@"grayColor" forKey:kThemeColor];
    [userPref setBool:NO forKey:kIsLoggedIn];
    //[TwtBoothAppDelegate getDelegate].themeColor = @"grayColor";
    [userPref synchronize];
    
    //[TwtBoothAppDelegate getDelegate].shouldNavigate = NO;
    favouriteView.loggedInUserData = nil;
    [self clearCredentials];
        NSHTTPCookie *cookie;
        NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        for (cookie in [storage cookies])
        {
            NSString* domainName = [cookie domain];
            NSRange domainRange = [domainName rangeOfString:@"twitter"];
            if(domainRange.length > 0)
            {
                [storage deleteCookie:cookie];
            }
            
        }
    
    UINavigationController *obj = self.navigationController;
    [self.navigationController dismissModalViewControllerAnimated:NO];
    
    BOOL    isPop = NO;
    NSArray *viewCtrls = [obj viewControllers];
    for(int x= 0 ; x < [viewCtrls count] ; x++)
    {
        
//        id vwCtrl = viewCtrls[x];
       /* if([vwCtrl isKindOfClass:[LoginiPadVC class]])
        {
            isPop = YES;
            [self.navigationController popToViewController:vwCtrl animated:NO];
            break;
        }*/
        
    }
    
    if(!isPop)
    {
        
        //LoginiPadVC *obj = [[LoginiPadVC alloc] initWithNibName:@"LoginiPadVC" bundle:nil];
        //[self.navigationController pushViewController:obj animated:NO];
        //[obj release];
        //obj = nil;
        
    }
    //[[TwtBoothAppDelegate getDelegate] hideIndicator];
    singleton = nil;

}

- (void) clearCredentials
{
    [self._engine setClearsCookies:YES];
    [self._engine clearAccessToken];
    
}


- (void) userInfoForId:(NSString *)personId
{
    [self._engine getUserInformationFor:personId];
    
}

- (void) notificationsOn:(BOOL)isNotificationOn
{
    
    if(isNotificationOn)
        [self._engine setNotificationsDeliveryMethod:@"sms"];
    else
        [self._engine setNotificationsDeliveryMethod:nil];
    
}

- (void) setFavourite:(NSString *)tweetId  asFavorite:(BOOL)isFavourite
{
    [self._engine markUpdate:tweetId asFavorite:isFavourite];
    
}

- (void) getFavourite:(int) forPage
{
    [self._engine getFavoriteUpdatesFor:nil startingAtPage:forPage];

}

- (void) getFavourite:(NSString *)personId pageNumber:(int)pgNo maxId:(NSString *)maxId
{
    [self._engine getFavoriteUpdatesFor:personId startingAtPage:0 sinceId:@"0" maxId:maxId];
}

- (void) cancelCurrentRequests
{
    [self._engine cancelCurrentRequest];
}

#pragma mark TabBarController Delegate

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    
    if(tabBarController.selectedIndex == 0 || tabBarController.selectedIndex == 1)
    {
//        UINavigationController *viewCtrl = (UINavigationController *)viewController;
//        id topCtrl = [viewCtrl topViewController];
        /*if([topCtrl isKindOfClass:[NewiPadVC class]])
        {
            NewiPadVC *obj = (NewiPadVC *) topCtrl;
            [obj refreshBtnClicked];
        }*/
        /*else if([topCtrl isKindOfClass:[PhotosiPadVC class]])
        {
            PhotosiPadVC *obj = (PhotosiPadVC *) topCtrl;
            [obj refreshBtnClicked];
        }*/
    }
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController 
{
    //BOOL shouldNavigate = [TwtBoothAppDelegate getDelegate].shouldNavigate;
    //return shouldNavigate;
	return YES;
}


//- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
//- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
//- (void)tabBarController:(UITabBarController *)tabBarController willBeginCustomizingViewControllers:(NSArray *)viewControllers 
//- (void)tabBarController:(UITabBarController *)tabBarController willEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed 
//- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
//

#pragma mark ViewController Stuff

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIDeviceOrientationPortraitUpsideDown);
//	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}




- (void)viewDidUnload 
{
    
        self.objTabbarCtrl = nil;
        [self setBackgroundImageView:nil];
        [self setDelegate:nil];
        [self set_engine:nil];
        [super viewDidUnload];
    
}


@end
