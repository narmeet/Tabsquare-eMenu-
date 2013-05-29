//
//  FacebookViewC.m
//
//  Copyright 2010 . All rights reserved.
//

//#define kAppId  @"158680447521284"

//#define kAppId  @"345487292205652"
//#define   kAppId  @"218172004987897"/////for Moghul mahal
//#define   kAppId  @"567350413284422"/////for Banana Leaf
//#define kAppId  @"411662998896412"

#import "FacebookViewC.h"
#import "ShareableData.h"
#import "FBConnect.h"
#import "FBRequest.h"
#import "Utils.h"
#import "TabFeedbackViewController.h"
#import "TabSquareFavouriteViewController.h"
#import "TabSquareFriendListController.h"
#import "TabSquareFeedbackLLViewController.h"

@implementation FacebookViewC

@synthesize loginDelegate1;
@synthesize feedbackView,data,finalFeedbackView;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
{
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) 
	{
       
        _permissions =  @[@"read_stream", @"offline_access",@"email",@"publish_stream",@"user_photos",@"user_photo_video_tags"];
		_facebook = [[Facebook alloc] init];
		_fbButton = [[FBLoginButton alloc] init];
		_fbButton.isLoggedIn   = NO;
		[_fbButton updateImage];
		
    }
    return self;
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
    [super viewDidLoad];
}

#pragma mark Facebook

- (void) login 
{
	[_facebook authorize:kAppId permissions:_permissions delegate:self];
}

- (void) logout 
{
	[_facebook logout:self]; 
}

-(void) facebookButtonClicked
{
	if (_fbButton.isLoggedIn) 
	{
		[self logout];
	} 
	else 
	{
		[self login];
	}
}

-(void) fbDiDLogin 
{
    ////NSLOG(@"fb did login");
	_fbButton.isLoggedIn         = YES;
    tasktype=1;
    if(feedbackView)
    {
        [self publish1:[ShareableData sharedInstance].feedDishName rating:[ShareableData sharedInstance].feedDishRating imageUrl:[ShareableData sharedInstance].feedDishImage];
    }
    else if (finalFeedbackView){
        
    }
    else{
        ////NSLOG(@"Requesting graph api");
        [_facebook requestWithGraphPath:@"me" andDelegate:self];
    }
   
}
- (void)fbDidNotLogin:(BOOL)cancelled 
{
	DLog(@"did not login");
}

-(void) fbDiDLogout 
{
	_fbButton.isLoggedIn = NO;
}


#pragma mark Facebook delegate
-(void)request:(FBRequest*)request didReceiveResponse:(NSURLResponse*)response
{
	DLog(@"received response%@",response);
    [ShareableData sharedInstance].isFBLogin =@"1";
    if(feedbackView)
    {
        //[self publish1:[ShareableData sharedInstance].feedDishName rating:[ShareableData sharedInstance].feedDishRating];
    }
    else if(_favouriteView)
    {
        ////NSLOG(@"loading favorite view");
        [_favouriteView loadFBfriendList];
        //[finalFeedbackView loadFBfriendList];
    }
}

-(void)request:(FBRequest*)request didFailWithError:(NSError*)error
{
    
}


-(void)request:(FBRequest*)request didLoad:(id)result 
{
    if([result isKindOfClass:[NSDictionary class]])
    {
        DLog(@"Facebook Request = %@",result);
        //DLog(@"dictionary");
        if(tasktype==1)
        {
            
           NSString* name=[NSString stringWithFormat:@"%@",result[@"email"]];
            result=result[@"id"];
            NSString *fbid=[NSString stringWithFormat:@"%@",result];
            [_favouriteView UserRegistration:@"facebook" emailid:fbid password:@"123" tableId:[ShareableData sharedInstance].assignedTable1 name: name];
            //[finalFeedbackView UserRegistration:@"facebook" emailid:fbid password:@"123" tableId:[ShareableData sharedInstance].assignedTable1 name: name];
            DLog(@"%@",result);
            [_facebook requestWithGraphPath:@"me/friends" andDelegate:self];                
            tasktype=2;
        }
        else if(tasktype==2)
        {
            result=result[@"data"];
            
            if ([result isKindOfClass:[NSArray class]]) 
            { 
                    tasktype=3;
                    _favouriteView.fbfriendView.friendData=(NSArray*)result;
                finalFeedbackView.fbfriendView.friendData=(NSArray*)result;
                    [_facebook requestWithGraphPath:@"me/friends?fields=installed" andDelegate:self];
            }
        }
        else if (tasktype==3)
        {
            result=result[@"data"];
            ////NSLOG(@"print installed data = %@", result);
            if ([result isKindOfClass:[NSArray class]]) 
            { 
                [_favouriteView.fbfriendView.friendInstalled removeAllObjects];
                [finalFeedbackView.fbfriendView.friendInstalled removeAllObjects];
                for(int i=0;i<[result count];i++)
                {
                    NSDictionary *result2=result[i];
                    NSString *id1=result2[@"id"]; 
                    NSString *installedType=[NSString stringWithFormat:@"%@",result2[@"installed"]];
                    if([installedType isEqualToString:@"1"])
                    {
                        [_favouriteView.fbfriendView.friendInstalled addObject:id1];
                        [finalFeedbackView.fbfriendView.friendInstalled addObject:id1];
                    }
                    
                }
                [_favouriteView.fbfriendView showIndicator];
                [finalFeedbackView.fbfriendView showIndicator]; 
            }

        }
       
    }
}

-(void)dialogDidNotComplete:(FBDialog *)dialog
{
    
}


- (void)dialogDidComplete:(FBDialog*)dialog
{
	[Utils showOKAlertWithTitle:@"Status" message:@"Your message has been successfully post on facebook"];	
	
}


#pragma mark post to wall
- (void) publish 
{
	UIImage *img = [UIImage imageNamed:@"Default.png"];
	NSMutableDictionary * params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
									img, @"picture",
									nil];
	[_facebook requestWithMethodName: @"photos.upload" 
						   andParams: params
					   andHttpMethod: @"POST" 
						 andDelegate: self]; 
}

#pragma mark post to wall


- (void) publish1:(NSString*)dishName rating:(NSString*)rate imageUrl:(NSString*)imageurl
{
    
    
    
	//SBJSON *jsonWriter = [[SBJSON new] autorelease];
   // NSString *image=@"http://108.178.27.242/zoney/img/profile/bluepin.png";
    
    
	//NSDictionary* actionLinks = [NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:
													//	   @"My Link",@"text",@"http://www.trendsetterz.co.in/",@"href", nil], nil];
	
//	NSString *actionLinksStr = [jsonWriter stringWithObject:actionLinks];
	/*NSDictionary* attachment = [NSDictionary dictionaryWithObjectsAndKeys:
                                image,@"picture",							
                                dishName, @"caption",
								rate, @"description",
                                @"http://www.trendsetterz.co.in/",@"link",                                
                                nil];
    
	NSString *attachmentStr = [jsonWriter stringWithObject:attachment];*/

    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   kAppId, @"api_key",
                                   imageurl, @"picture",
                                   dishName, @"name",
                                   @"Powered by Tabsquare",@"caption", /// changed for hide the IP while posting the image
                                   rate, @"description",
                                   nil];
    

  

	[_facebook dialog: @"stream.publish"
			andParams: params
            andDelegate:self];
    
	//[Utils showOKAlertWithTitle:@"Status" message:@"Your message has been successfully post on facebook"];	
	//UIAlertView*	aAlert = [[UIAlertView alloc] initWithTitle:@"Your message has been successfully post on facebook" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    //	[aAlert show];
    //	[aAlert release];
	
}

/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


-(void)userInfoDidLoad {
	
}

-(void)userInfoFailToLoad {
	
}





/*===============================Update in FaceBook=================================*/

-(void)getUserInfo
{
    if(!_accountStore)
        _accountStore = [[ACAccountStore alloc] init];
    
    ACAccountType *facebookTypeAccount = [_accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
    
    [_accountStore requestAccessToAccountsWithType:facebookTypeAccount
                                           options:@{ACFacebookAppIdKey: @"kAppId", ACFacebookPermissionsKey: @[@"email"]}
                                        completion:^(BOOL granted, NSError *error) {
                                            if(granted){
                                                NSArray *accounts = [_accountStore accountsWithAccountType:facebookTypeAccount];
                                                _facebookAccount = [accounts lastObject];
                                                ////NSLOG(@"Success");
                                                
                                            }else{
                                                // ouch
                                                ////NSLOG(@"Fail");
                                                ////NSLOG(@"Error: %@", error);
                                            }
                                        }];

}

@end
