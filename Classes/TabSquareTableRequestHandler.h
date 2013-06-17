
#import <Foundation/Foundation.h>

#define WAITER  @"1"
#define BILL    @"2"


@interface TabSquareTableRequestHandler : NSObject {
        
    BOOL threadStatus;
    BOOL callStatus;
    
    NSString *tableNumber;
    NSString *callType;
    
}


-(id)initWithTableNo:(NSString *)_number;
-(void)startThread;
-(void)stopThread;
-(BOOL)isRunning;
-(BOOL)callForStaff:(NSString *)type;


@end
