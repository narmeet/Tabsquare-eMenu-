//
//  TabSquareFavouriteViewController.h
//  TabSquareMenu
//
//  Created by Nikhil Kumar on 7/5/12.
//  Copyright (c) 2012 Trendsetterz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SA_OAuthTwitterController.h"
#import "MBProgressHUD.h"
#import "TwitterResponseDelegateiPad.h"
#import "FacebookInfo.h"

@class SA_OAuthTwitterEngine;
@class FacebookViewC;
@class TabSquareLastOrderedViewController;
@class TabSquareMenuController;
@class TabSquareFriendListController;
@class TabTwitterFollowerListControllerViewController;

@interface TabSquareFavouriteViewController : UIViewController {
    
    FacebookInfo *facebookInfo;
    IBOutlet UIImageView* bgImage;

}

@property (nonatomic, strong) SA_OAuthTwitterEngine	*_engine;
@property(nonatomic,strong)IBOutlet UITextField* txtLogin;
@property(nonatomic,strong)IBOutlet UITextField* txtPassword;
@property (nonatomic, strong) id <TwitterResponseDelegateiPad> delegate;
@property(nonatomic,strong) TabSquareLastOrderedViewController *lastOrderedView;
@property(nonatomic,strong) TabSquareFriendListController *fbfriendView;
@property(nonatomic,strong) TabTwitterFollowerListControllerViewController *twitfollowerView;
@property(nonatomic,strong) FacebookViewC	*objFacebookViewC;
@property(nonatomic,strong) TabSquareMenuController *menuView;
@property (nonatomic, strong) NSDictionary *loggedInUserData;

-(IBAction)LoginButtonClick:(id)sender;
-(IBAction)RegisterButtonClick:(id)sender;
-(IBAction)facebookLoginBtnClicked;
-(IBAction)twitterBtnClicked:(id)sender;

-(void)UserRegistration:(NSString*)Mode emailid:(NSString*)emailid password:(NSString*)pass  tableId:(NSString*)tableId name:(NSString*)name;
-(void)loadFBfriendList;
- (void) getAllFollowers:(NSString *)cursor;
- (void) getUsersInformation:(NSString *)usersId;
- (void) userInfo;
@end