//
//  TabSquareTwitterController.m
//  TabSquareMenu
//
//  Created by Nikhil Kumar on 8/16/12.
//  Copyright (c) 2012 Trendsetterz. All rights reserved.
//

#import "TabSquareTwitterController.h"
#import "SA_OAuthTwitterEngine.h"

/* Define the constants below with the Twitter 
 Key and Secret for your application. Create
 Twitter OAuth credentials by registering your
 application as an OAuth Client here: http://twitter.com/apps/new
 */

///#define kOAuthConsumerKey		@"4egZepckiiZLJNOXktHYw"		                //REPLACE With Twitter App OAuth Key  
//#define kOAuthConsumerSecret	@"Swo6AITrbcW5b9cWlpNzVAGuPeFhYn76LFsT72sz4"	//REPLACE With Twitter App OAuth Secret

//For Free Version
#define kOAuthConsumerKey		        @"iHTZzE0QrhjgbLyD3Yboqw"		//REPLACE ME
#define kOAuthConsumerSecret			@"tY34NOFgVuFhyvNyki96yuayZFevEFWF3mrccLyA"		//REPLACE ME



@implementation TabSquareTwitterController

#pragma mark ViewController Lifecycle

- (void)viewDidAppear: (BOOL)animated 
{
	
}

-(void)loadTwitter
{
    // Twitter Initialization / Login Code Goes Here
    if(!_engine){  
        _engine = [[SA_OAuthTwitterEngine alloc] initOAuthWithDelegate:self];  
        _engine.consumerKey    = kOAuthConsumerKey;  
        _engine.consumerSecret = kOAuthConsumerSecret;  
    }  	
    
    if(![_engine isAuthorized]){  
        SA_OAuthTwitterController *controller = [SA_OAuthTwitterController controllerToEnterCredentialsWithTwitterEngine:_engine delegate:self];  
       /// controller.twitter=self;
        if (controller){  
            [self presentModalViewController:controller animated: YES];  
        }  
    }    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


//=============================================================================================================================
#pragma mark SA_OAuthTwitterEngineDelegate
- (void) storeCachedTwitterOAuthData: (NSString *) data forUsername: (NSString *) username {
	NSUserDefaults			*defaults = [NSUserDefaults standardUserDefaults];
    
	[defaults setObject: data forKey: @"authData"];
	[defaults synchronize];
}

- (NSString *) cachedTwitterOAuthDataForUsername: (NSString *) username {
	return [[NSUserDefaults standardUserDefaults] objectForKey: @"authData"];
}

//=============================================================================================================================
#pragma mark TwitterEngineDelegate
- (void) requestSucceeded: (NSString *) requestIdentifier {
	//DLog(@"Request %@ succeeded", requestIdentifier);
}

- (void) requestFailed: (NSString *) requestIdentifier withError: (NSError *) error {
	//DLog(@"Request %@ failed with error: %@", requestIdentifier, error);
}





@end
