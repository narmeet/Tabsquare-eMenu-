
#import "FacebookInfo.h"
#import "ShareableData.h"
#import "TabSquareCommonClass.h"
#import "SBJSON.h"

//#define kAppId @"218172004987897"///Moghual mahal
#define   kAppId  @"567350413284422"/////for Banana Leaf

@implementation FacebookInfo


@synthesize userName, userID;


-(id)init
{
    status           = FALSE;
    friendListStatus = FALSE;
    
    return self;
}

-(BOOL)connectToFacebook
{
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
    {
        [self getUserInfo];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Facebook Message" message:@"Make sure you have any Facebook account setup." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
    }

    return status;
}


-(void)getUserInfo
{
    if(!_accountStore)
        _accountStore = [[ACAccountStore alloc] init];
    
    ACAccountType *facebookTypeAccount = [_accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
    
    /*
    NSDictionary *options = @{ACFacebookAppIdKey: kAppId,ACFacebookPermissionsKey: @[@"read_stream",@"email",@"user_photos",@"user_photo_video_tags", @"read_friendlists", @"user_location"],
    
    ACFacebookAudienceKey: ACFacebookAudienceFriends
    };
     */
    
     NSDictionary *options = @{ACFacebookAppIdKey: kAppId,ACFacebookPermissionsKey: @[@"read_friendlists", @"email", @"user_location", @"read_stream"],
     ACFacebookAudienceKey: ACFacebookAudienceFriends
     };

    
    [_accountStore requestAccessToAccountsWithType:facebookTypeAccount
                                           options:options
                                        completion:^(BOOL granted, NSError *error) {
                                            if(granted)
                                            {
                                                
                                                NSArray *accounts = [_accountStore accountsWithAccountType:facebookTypeAccount];
                                                
                                                //NSLOG(@"account data = %@\n", accounts);
                                                
                                                _facebookAccount = [accounts lastObject];
                                                
                                                NSString *uid = [NSString stringWithFormat:@"%@", [[_facebookAccount valueForKey:@"properties"] valueForKey:@"uid"]];
                                                
                                                self.userName = [NSString stringWithString:_facebookAccount.username];
                                                self.userID = [NSString stringWithString:uid];
                                                status = TRUE;

                                                //[self me];
                                                /*=====================*/
                                                //[self loadFriendList];
                                                [self loadInstalled];
                                                /*=====================*/
                                                
                                            }
                                            else
                                            {
                                                status = FALSE;
                                                //NSLOG(@"Fail");
                                                //NSLOG(@"Error: %@", error);
                                            }
                                        }];
    
}





-(BOOL)loadFriendList
{
    /*
    [_accountStore renewCredentialsForAccount:_facebookAccount completion:^(ACAccountCredentialRenewResult renewResult, NSError *error) {
        
        //NSLOG(@"Renewed");
        
        if (error){
            //NSLOG(@"Failed");
        }
    }];
    */
    //https://graph.facebook.com/FACEBOOK_USER_ID/posts?access_token=ACCESS_TOKEN

    /*===========================*/
    
    NSString *acessToken = [NSString stringWithFormat:@"%@",_facebookAccount.credential.oauthToken];
    NSDictionary *parameters = @{@"access_token": acessToken};
    NSURL *feedURL = [NSURL URLWithString:@"https://graph.facebook.com/me/friends"];
    SLRequest *feedRequest = [SLRequest
                              requestForServiceType:SLServiceTypeFacebook
                              requestMethod:SLRequestMethodGET
                              URL:feedURL
                              parameters:parameters];
    feedRequest.account = _facebookAccount;
    [feedRequest performRequestWithHandler:^(NSData *responseData,
                                             NSHTTPURLResponse *urlResponse, NSError *error)
     {
         NSString *list_data = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
         
         //NSLOG(@"Raw data = %@", list_data);
         SBJSON *parser = [[SBJSON alloc] init];
         NSMutableDictionary *resultFromPost = [parser objectWithString:list_data error:nil];
         NSMutableArray *arr = [resultFromPost objectForKey:@"data"];
         
         friends = [[NSMutableArray alloc] init];
         
         for(int i = 0; i < [arr count]; i++)
         {
             NSMutableDictionary *dict = [arr objectAtIndex:i];
             [friends addObject:[dict objectForKey:@"name"]];
         }
         //NSLOG(@"friends list= %@", friends);
     }];

    
    return friendListStatus;
}

-(NSMutableArray *)getFriends
{
    return friends;
}


-(void)loadInstalled
{
    
    NSString *acessToken = [NSString stringWithFormat:@"%@",_facebookAccount.credential.oauthToken];
    NSDictionary *parameters = @{@"access_token": acessToken};
    NSURL *feedURL = [NSURL URLWithString:@"https://graph.facebook.com/me/friends?fields=installed?access_token=%@"];
    SLRequest *feedRequest = [SLRequest
                              requestForServiceType:SLServiceTypeFacebook
                              requestMethod:SLRequestMethodGET
                              URL:feedURL
                              parameters:parameters];
    feedRequest.account = _facebookAccount;
    [feedRequest performRequestWithHandler:^(NSData *responseData,
                                             NSHTTPURLResponse *urlResponse, NSError *error)
     {
         NSString *list_data = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
         //NSLOG(@"installed list data = %@", list_data);
         SBJSON *parser = [[SBJSON alloc] init];
         NSMutableDictionary *resultFromPost = [parser objectWithString:list_data error:nil];
         NSMutableArray *arr = [resultFromPost objectForKey:@"data"];
         
         installed = [[NSMutableArray alloc] init];
         
         for(int i = 0; i < [arr count]; i++)
         {
             NSMutableDictionary *dict = [arr objectAtIndex:i];
             [installed addObject:[dict objectForKey:@"name"]];
         }
         //NSLOG(@"installed list= %@", installed);
     }];

}


-(NSMutableArray *)getInstalled
{
    return installed;
}



- (void)me
{
    NSURL *meurl = [NSURL URLWithString:@"https://graph.facebook.com/me"];
    
    SLRequest *merequest = [SLRequest requestForServiceType:SLServiceTypeFacebook
                                              requestMethod:SLRequestMethodGET
                                                        URL:meurl
                                                 parameters:nil];
    
    merequest.account = _facebookAccount;
    
    [merequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        //NSString *meDataString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        
        
    }];
    
}


@end
