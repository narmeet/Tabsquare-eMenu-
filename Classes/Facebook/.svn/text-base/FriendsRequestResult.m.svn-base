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

#import "FriendsRequestResult.h"


@implementation FriendsRequestResult

- (id) initWithDelegate:(id<FriendsRequestDelegate>)delegate {
  self = [super init];
  _friendsRequestDelegate = delegate;
  return self;   
}

/**
 * FBRequestDelegate
 */
- (void)request:(FBRequest*)request didLoad:(id)result{
  
    NSMutableArray *friendsInfo = [[NSMutableArray alloc] init];
    for (NSDictionary *info in result) {
	if (!([info[@"is_app_user"] boolValue])) 
	{
		continue;
	}
      NSString *friend_id = [NSString stringWithString:[info[@"uid"] stringValue]];
      NSString *friend_name = nil;
      if (info[@"name"] != [NSNull null]) {
        friend_name = [NSString stringWithString:info[@"name"]];
      } 
      NSString *friend_pic = info[@"pic_square"];
      NSString *friend_status = info[@"status"];
      NSMutableDictionary *friend_info = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                          friend_id,@"uid",
                                          friend_name, @"name", 
                                          friend_pic, @"pic", 
                                          friend_status, @"status", 
                                          nil];
      [friendsInfo addObject:friend_info];
    }
    

    [_friendsRequestDelegate FriendsRequestCompleteWithFriendsInfo:friendsInfo];
    
}


@end
