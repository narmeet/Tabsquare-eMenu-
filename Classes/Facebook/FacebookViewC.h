//
//  FacebookViewC.h
//
//  Copyright 2010 . All rights reserved.
//
#import <UIKit/UIKit.h>
#import "FBConnect.h"
#import "FBLoginButton.h"
#import "UserInfo.h"
#import "MBProgressHUD.h"
#import <Accounts/Accounts.h>
#import <Social/Social.h>

@class TabSquareFavouriteViewController;
@class TabFeedbackViewController;
@class TabSquareFeedbackLLViewController;

@interface FacebookViewC : UIViewController <FBRequestDelegate,FBDialogDelegate,FBSessionDelegate,UserInfoLoadDelegate,MBProgressHUDDelegate>
{
    
    ACAccountStore *_accountStore;
    ACAccount *_facebookAccount;
    
	// Facebook
	IBOutlet FBLoginButton* _fbButton;
    MBProgressHUD *progressHud; 
	Facebook* _facebook;
	NSArray* _permissions;
	UserInfo *_userInfo;
	id __weak loginDelegate1;
    int tasktype;
    
}
@property(nonatomic,strong) NSArray *data;
@property(nonatomic,strong) TabFeedbackViewController *feedbackView;
@property(nonatomic,strong) TabSquareFavouriteViewController *favouriteView;
@property(nonatomic,strong) TabSquareFeedbackLLViewController *finalFeedbackView;

@property (nonatomic, weak) 	id loginDelegate1;

-(void) facebookButtonClicked;
- (void) publish1:(NSString*)dishName rating:(NSString*)rate imageUrl:(NSString*)imageurl;
- (void) login ;
- (void) logout ;


@end
