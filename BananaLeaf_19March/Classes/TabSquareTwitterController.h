//
//  TabSquareTwitterController.h
//  TabSquareMenu
//
//  Created by Nikhil Kumar on 8/16/12.
//  Copyright (c) 2012 Trendsetterz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SA_OAuthTwitterController.h"

@class SA_OAuthTwitterEngine;

@interface TabSquareTwitterController : UIViewController< SA_OAuthTwitterControllerDelegate>
{
    SA_OAuthTwitterEngine *_engine;
}

-(void)loadTwitter;

@end
