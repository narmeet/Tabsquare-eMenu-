

#import <Foundation/Foundation.h>

#import <Social/Social.h>
#import <Accounts/Accounts.h>


@interface FacebookInfo : NSObject {
    
    ACAccountStore *_accountStore;
    ACAccount *_facebookAccount;
    
    SLComposeViewController *mySLComposerSheet;
    
    NSMutableArray  *friends;
    NSMutableArray  *installed;
    NSString        *userName;
    NSString        *userID;
    
    BOOL     status;
    BOOL     friendListStatus;
    

}


@property(nonatomic, retain)     NSString *userName;
@property(nonatomic, retain)     NSString *userID;

-(BOOL)connectToFacebook;
-(void)getUserInfo;
-(void)me;
-(BOOL)loadFriendList;
-(NSMutableArray *)getFriends;
-(void)loadInstalled;
-(NSMutableArray *)getInstalled;


@end
