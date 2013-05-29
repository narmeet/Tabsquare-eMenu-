
#import "TabSquareFlurryTracking.h"
#import "Flurry.h"

#define FlurryKey       @"NCWYXPKZB6YZ2GJZKCY6"

@implementation TabSquareFlurryTracking

void uncaughtExceptionHandler(NSException *exception)
{
    [Flurry logError:@"Uncaught" message:@"Crash!" exception:exception];
}

static TabSquareFlurryTracking *flurryTracking = nil;

+(TabSquareFlurryTracking*)flurryTracking
{
	if (flurryTracking == nil) {
        flurryTracking = [[TabSquareFlurryTracking alloc] init];
    }
    return flurryTracking;
}


-(void)startSession
{
    currentEvent   = nil;

    [Flurry startSession:FlurryKey];
    //[Flurry setDebugLogEnabled:TRUE];
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
}


-(void)endSession
{
    // Closing connection in 1 second.
    [Flurry setSessionContinueSeconds:1];
}


-(void)trackItem:(NSString *)item eventName:(NSString *)event category:(NSString *)category
{
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:category, item, nil];

    if ([event isEqualToString:DISH_PURCHASE_EVENT]) {
        
        [Flurry logEvent:event withParameters:dictionary timed:NO];
    }
    else if([event isEqualToString:DISH_OPEN_EVENT]) {
        
        if (currentEvent != nil) {
            [Flurry endTimedEvent:currentEvent withParameters:nil];
        }
        currentEvent = [NSString stringWithString:event];
        [Flurry logEvent:event withParameters:dictionary timed:YES];
    }
}


-(void)endTrackingEvent
{   
    [Flurry endTimedEvent:currentEvent withParameters:nil];
}



@end
