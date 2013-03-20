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

#import "UserRequestResult.h"


@implementation UserRequestResult

- (id) initWithDelegate:(id<UserRequestDelegate>)delegate {
  self = [super init];
  _userRequestDelegate = delegate;
  return self;  
}


/**
 * FBRequestDelegate
 */
- (void)request:(FBRequest*)request didLoad:(id)result{

  NSString *uid = result[@"id"]; 
  [_userRequestDelegate userRequestCompleteWithUid:uid];    
  
}


- (void)request:(FBRequest*)request didFailWithError:(NSError*)error {
  DLog(@"%@",[error localizedDescription]);
  [_userRequestDelegate userRequestFailed];
}

@end
