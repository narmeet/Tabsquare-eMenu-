
#import <Foundation/Foundation.h>


#define DISH_OPEN_EVENT     @"Dish Item Opened"
#define DISH_PURCHASE_EVENT   @"Dish Item Purchased"


@interface TabSquareFlurryTracking : NSObject {

    NSString *currentEvent;
    
}



+(TabSquareFlurryTracking*)flurryTracking;
-(void)startSession;
-(void)endSession;
-(void)trackItem:(NSString *)item eventName:(NSString *)event category:(NSString *)category;
-(void)endTrackingEvent;


@end
