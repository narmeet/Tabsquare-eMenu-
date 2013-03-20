//
//  TwitterResponseDelegateiPad.h
//  TabSquareMenu
//
//  Created by Fahim Farook on 14/12/12.
//  Copyright (c) 2012 Trendsetterz. All rights reserved.
//

@protocol TwitterResponseDelegateiPad <NSObject>

-(void)twitterResponse:(id) response;
-(void)twitterServiceFailed;

@end
