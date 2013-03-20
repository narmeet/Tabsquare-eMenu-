//
//  TabSquareAppDelegate.m
//  TabSquareMenu
//
//  Created by Nikhil Kumar on 7/5/12.
//  Copyright (c) 2012 Trendsetterz. All rights reserved.
//

#import "AppDelegate.h"
#import "TabSquareHomeController.h"
#import "ShareableData.h"
#import "TabSquareAssignTable.h"
#import "TabSquareDBFile.h"
#import "TabSquareFavouriteViewController.h"
#import "Reachability.h"
#import "TabSquareTableManagement.h"
#import "TabSquareQuickOrder.h"
#import "PrintBillAndCheckOutFinal.h"
#import "TabSquareCommonClass.h"

NSString *kNameColorKey= @"nameColorKey";

@interface AppDelegate () <UIApplicationDelegate> {
	Reachability* hostReach;
	Reachability* internetReach;
	Reachability* wifiReach;
}

@end

@implementation AppDelegate



-(BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSSetUncaughtExceptionHandler(&onUncaughtException);
    
    TabSquareFlurryTracking *flurry = [TabSquareFlurryTracking flurryTracking];
    [flurry startSession];
    
    
    NSString *server_url = nil;
    NSString *dish_tag = nil;
    
    BOOL value = [[NSUserDefaults standardUserDefaults] boolForKey:DISH_TAG];
    //NSLOG(@"value = %d", value);
    
    NSString *str = [[NSUserDefaults standardUserDefaults] valueForKey:SERVER_URL];
    //NSLOG(@"string = %@, lenght = %d", str, [str length]);
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [[ShareableData sharedInstance] allocateArray];
    //copy database
    [[TabSquareDBFile sharedDatabase]createEditableCopyOfDatabaseIfNeeded];
    [[ShareableData sharedInstance].IsDBUpdated addObject:@"0"];
    // Override point for customization after application launch.
    self.viewController = [[TabSquareTableManagement alloc] initWithNibName:@"TabSquareTableManagement" bundle:nil];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:self.viewController];
    [navigationController setNavigationBarHidden:YES];
    self.window.rootViewController = navigationController;//self.viewController;
    [self.window makeKeyAndVisible];
    // [[TabSquareDBFile sharedDatabase] optimizeDB];
    //Uncomment later
	/* [[NSNotificationCenter defaultCenter] addObserver:self
	 selector:@selector(defaultsChanged:)
	 name:NSUserDefaultsDidChangeNotification
	 object:nil];
	 
     [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(reachabilityChanged:) name: kReachabilityChangedNotification object: nil];*/
   // internetReach = [Reachability reachabilityForInternetConnection];
	//   [internetReach startNotifier];
    
    [self checkForWIFIConnection];
    return YES;
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    // Display text
    UIAlertView *alertView;
    NSString *text = [[url host] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    alertView = [[UIAlertView alloc] initWithTitle:@"Text" message:text delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    DLog(text);
    [alertView show];
   
    return YES;
}
- (void)checkForWIFIConnection {
    Reachability* wifiReach = [Reachability reachabilityForLocalWiFi];
    
    NetworkStatus netStatus = [wifiReach currentReachabilityStatus];
    
    if (netStatus!=ReachableViaWiFi)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"No WIFI available!", @"AlertView")
                                                            message:NSLocalizedString(@"You have no wifi connection available. Please connect to a WIFI network.", @"AlertView")
                                                           delegate:self
                                                  cancelButtonTitle:NSLocalizedString(@"Cancel", @"AlertView")
                                                  otherButtonTitles:NSLocalizedString(@"Check Your Settings", @"AlertView"), nil];
        [alertView show];
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        // [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=AIRPLANE_MODE"]];
        NSURL*url=[NSURL URLWithString:@"prefs:root=WIFI"];
        [[UIApplication sharedApplication] openURL:url];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    // [[TabSquareDBFile sharedDatabase] closeDatabaseConnection];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    // [[TabSquareDBFile sharedDatabase] closeDatabaseConnection];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    // [[TabSquareDBFile sharedDatabase] openDatabaseConnection];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [self checkForWIFIConnection];

    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    // [[TabSquareDBFile sharedDatabase] openDatabaseConnection];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
     //[[TabSquareDBFile sharedDatabase] closeDatabaseConnection];
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

-(void)setupByPreferences {
    NSString *testValue = [[NSUserDefaults standardUserDefaults] stringForKey:kNameColorKey];
	if (testValue == nil)
	{
		// no default values have been set, create them here based on what's in our Settings bundle info
		//
		NSString *pathStr = [[NSBundle mainBundle] bundlePath];
		NSString *settingsBundlePath = [pathStr stringByAppendingPathComponent:@"Settings.bundle"];
		NSString *finalPath = [settingsBundlePath stringByAppendingPathComponent:@"Root.plist"];
        
		NSDictionary *settingsDict = [NSDictionary dictionaryWithContentsOfFile:finalPath];
		NSArray *prefSpecifierArray = settingsDict[@"PreferenceSpecifiers"];
        
		NSNumber *nameColorDefault = nil;
		
		NSDictionary *prefItem;
		for (prefItem in prefSpecifierArray)
		{
			NSString *keyValueStr = prefItem[@"Key"];
			id defaultValue = prefItem[@"DefaultValue"];
			if ([keyValueStr isEqualToString:kNameColorKey])
			{
				nameColorDefault = defaultValue;
			}
		}
        
		// since no default values have been set (i.e. no preferences file created), create it here		
		NSDictionary *appDefaults = @{kNameColorKey: nameColorDefault};
        
		[[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults];
		[[NSUserDefaults standardUserDefaults] synchronize];
	}
	
	// we're ready to go, so lastly set the key preference values
	
	_viewModeValue = [[NSUserDefaults standardUserDefaults] integerForKey:kNameColorKey];
    
    
    DLog(@"First Time : Setting Value : %d",_viewModeValue);
	
}

- (void)defaultsChanged:(NSNotification *)notif
{
   // [self setupByPreferences];
    //[ShareableData sharedInstance].ViewMode=ViewModeValue;
   // DLog(@"Update : Setting Value : %d",ViewModeValue);
}

- (void) configureTextField:(Reachability*) curReach
{
    
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    BOOL connectionRequired= [curReach connectionRequired];
    NSString* statusString= @"";
    switch (netStatus)
    {
        case NotReachable:
        {
            statusString = @"Access Not Available";
            connectionRequired= NO; 
            [ShareableData sharedInstance].isInternetConnected=false;
            DLog(@"------------------Intenet not Connect------------");
            if(![ShareableData sharedInstance].isInternetConnected)
            {
                UIAlertView *alert3=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please check internet connection" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil]; 
                [alert3 show];
            }
            
            break;
        }
            
        case ReachableViaWWAN:
        {
            statusString = @"Reachable WWAN";
             DLog(@"---------------Intenet Connect--------------");
            break;
        }
        case ReachableViaWiFi:
        {
            statusString= @"Reachable WiFi";
            DLog(@"---------------Intenet Connect--------------");
            [ShareableData sharedInstance].isInternetConnected=true;
            
            break;
        }
    }
    if(connectionRequired)
    {
        statusString= [NSString stringWithFormat: @"%@, Connection Required", statusString];
    }
    
}

- (void) updateInterfaceWithReachability: (Reachability*) curReach
{
    if(curReach == hostReach)
	{
		[self configureTextField:curReach];
       // NetworkStatus netStatus = [curReach currentReachabilityStatus];
        BOOL connectionRequired= [curReach connectionRequired];
        
        //summaryLabel.hidden = (netStatus != ReachableViaWWAN);
        NSString* baseLabel=  @"";
        if(connectionRequired)
        {
            baseLabel=  @"Cellular data network is available.\n  Internet traffic will be routed through it after a connection is established.";
        }
        else
        {
            baseLabel=  @"Cellular data network is active.\n  Internet traffic will be routed through it.";
        }
        // summaryLabel.text= baseLabel;
    }
	if(curReach == internetReach)
	{	
		[self configureTextField: curReach];
	}
	if(curReach == wifiReach)
	{	
		[self configureTextField: curReach];
	}
	
}

//Called by Reachability whenever status changes.
- (void) reachabilityChanged: (NSNotification* )note
{
	Reachability* curReach = [note object];
	NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
	[self updateInterfaceWithReachability: curReach];
    
}
void onUncaughtException(NSException *exception)
{
    DLog(@"uncaught exception: %@", exception.description);
}

@end
