/*
 * Copyright 2010 Facebook
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *    http://www.apache.org/licenses/LICENSE-2.0
 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import "UserInfo.h"
#import "FBConnect.h"


@implementation UserInfo

@synthesize facebook = _facebook,
                 uid = _uid,
         friendsList = _friendsList,
         friendsInfo = _friendsInfo,
    userInfoDelegate = _userInfoDelegate;

///////////////////////////////////////////////////////////////////////////////////////////////////

/**
 * initialization
 */
- (id)initWithFacebook:(Facebook *)facebook andDelegate:(id<UserInfoLoadDelegate>)delegate {
  self = [super init];
  _facebook = facebook;
  _userInfoDelegate = delegate;
  return self;
}


/**
 * Request all info from the user is start with request user id as the authorization flow does not 
 * return the user id. This is an intermediate solution to obtain the logged in user id
 * All other information are requested in the FBRequestDelegate function after Uid obtained. 
 */
- (void) requestAllInfo {
  [self requestUid];
}

/**
 * Request the user id of the logged in user.
 *
 * Currently the authorization flow does not return a user id anymore. This is
 * an intermediate solution to get the logged in user id.
 */
- (void) requestUid
{
  UserRequestResult *userRequestResult = 
    [[UserRequestResult alloc] initializeWithDelegate:self];
  [_facebook requestWithGraphPath:@"me" andDelegate:userRequestResult];
}

/** 
 * Request friends detail information
 *
 * Use FQL to query detailed friends information
 */
- (void) requestFriendsDetail{
  FriendsRequestResult *friendsRequestResult = 
    [[FriendsRequestResult alloc] initializeWithDelegate:self];
   
  NSString *query = @"SELECT uid, name, is_app_user, pic_square, status FROM user WHERE uid IN (";
  query = [query stringByAppendingFormat:@"SELECT uid2 FROM friend WHERE uid1 = %@)", _uid];
  NSMutableDictionary * params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                  query, @"query",
                                  nil];
  [_facebook requestWithMethodName: @"fql.query" 
                         andParams: params
                     andHttpMethod: @"POST" 
                       andDelegate: friendsRequestResult]; 
}

/**
 * UserRequestDelegate
 */
- (void)userRequestCompleteWithUid:(NSString *)uid {
  self.uid = uid;
	 DLog(@"_userInfo.uid            %@= ",uid);
	
	/*NSString *query =	[NSString stringWithFormat:@"SELECT uid,name FROM user WHERE uid=%@",uid];
	
	NSMutableDictionary * params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
									query, @"query",
									nil];
	[_facebook requestWithMethodName: @"fql.query" 
						   andParams: params
					   andHttpMethod: @"POST" 
						 andDelegate: self]; */

	
  [self requestFriendsDetail];
}

- (void)userRequestFailed {
  if ([self.userInfoDelegate respondsToSelector:@selector(userInfoFailToLoad)]) {
    [_userInfoDelegate userInfoFailToLoad];
  }
}

/**
 * FriendsRequestDelegate
 */
- (void)FriendsRequestCompleteWithFriendsInfo:(NSMutableArray *)friendsInfo 
{
	//ReleaseObject([FoodCashingAppDelegate getAppdelegate].appUserList);
	//([FoodCashingAppDelegate getAppdelegate]).appUserList = [[NSMutableArray alloc] initWithArray:friendsInfo];
	//([FoodCashingAppDelegate getAppdelegate]).getAppUserBool = YES;
  /*_friendsInfo = [friendsInfo retain];
  if ([self.userInfoDelegate respondsToSelector:@selector(userInfoDidLoad)]) 
  {
    [_userInfoDelegate userInfoDidLoad];
  }*/
	
	if ([self.userInfoDelegate respondsToSelector:@selector(callLoginGo)]) 
	{
		//[_userInfoDelegate callLoginGo];
	}
	
}
  
//- (void)request:(FBRequest*)request didLoad:(id)result 
//{
//	if ([result isKindOfClass:[NSArray class]])
//	{
//		result = [result objectAtIndex:0]; 
//	}
//	if ([result objectForKey:@"owner"]) 
//	{
//		//[self.label setText:@"Photo upload Success"];
//	} 
//	else 
//	{
//		//[self.label setText:[result objectForKey:@"name"]];
//		
//		//DLog(@"_userInfo.uid = ",_userInfo.uid);
//		
//		NSArray *arr = [[NSArray alloc] initWithArray:[result objectForKey:@"data"]];
//		DLog(@"%@",arr);
//	}
//	
//}
@end
