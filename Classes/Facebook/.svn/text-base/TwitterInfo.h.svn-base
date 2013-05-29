
#import <Foundation/Foundation.h>
#import <Social/Social.h>
#import <Accounts/Accounts.h>

@interface TwitterInfo : NSObject {
    
    ACAccountStore *_accountStore;
    ACAccount *_facebookAccount;
    
    SLComposeViewController *mySLComposerSheet;
    
    NSString *userName;
    NSString *userID;

    BOOL status;
}


@property(nonatomic, retain)     NSString *userName;
@property(nonatomic, retain)     NSString *userID;


-(BOOL)connectToTwitter;
-(void)getUserInfo;


@end
