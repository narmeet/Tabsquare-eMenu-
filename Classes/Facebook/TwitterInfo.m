

#import "TwitterInfo.h"

#define kOAuthConsumerKey		@"ZNdmXpbFLA5Sl70a9UEA"
#define kOAuthConsumerSecret	@"AzgVnTgGSIg8JWrNHg4yoiUoLq9AcP42Gn2i4To80"


@implementation TwitterInfo

@synthesize userName, userID;

-(id)init
{
    status           = FALSE;
    
    return self;
}


-(BOOL)connectToTwitter
{
    
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        [self getUserInfo];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Twitter Message" message:@"Make sure you have any Twitter account setup." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
    }
    
    return status;
}

/*
-(void)getUserInfo
{
    if(!_accountStore)
        _accountStore = [[ACAccountStore alloc] init];
    
    ACAccountType *facebookTypeAccount = [_accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
    
    NSDictionary *options = @{ACFacebookAppIdKey: kAppId,ACFacebookPermissionsKey: @[@"email", @"user_location"],
    ACFacebookAudienceKey: ACFacebookAudienceFriends
    };
    
    [_accountStore requestAccessToAccountsWithType:facebookTypeAccount
                                           options:options
                                        completion:^(BOOL granted, NSError *error) {
                                            if(granted)
                                            {
                                                ////NSLOG(@"Done");
                                                
                                                NSArray *accounts = [_accountStore accountsWithAccountType:facebookTypeAccount];
                                                
                                                _facebookAccount = [accounts lastObject];
                                                
                                                NSString *uid = [NSString stringWithFormat:@"%@", [[_facebookAccount valueForKey:@"properties"] valueForKey:@"uid"]];
                                                
                                                self.userName = [NSString stringWithString:_facebookAccount.username];
                                                self.userID = [NSString stringWithString:uid];
                                                status = TRUE;
                                                
                                                [self me];
                                                return;
                                                
                                                //=====================
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
                                                     ////NSLOG(@"data>>> %@",[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);
                                                 }];
                                                
                                                //=====================
                                                
                                            }
                                            else
                                            {
                                                status = FALSE;
                                                ////NSLOG(@"Fail");
                                                ////NSLOG(@"Error: %@", error);
                                            }
                                        }];
    
}
*/

@end
