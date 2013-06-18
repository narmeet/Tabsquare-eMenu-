
#import "TabSquareTableRequestHandler.h"
#import "Reachability.h"
#import "ShareableData.h"
#import "SBJSON.h"

#define LOOP_TIME   5
#define LOOP_INDEX  0


@implementation TabSquareTableRequestHandler



-(id)initWithTableNo:(NSString *)_number
{
    threadStatus = TRUE;
    callStatus     = FALSE;
    tableNumber  = [NSString stringWithFormat:@"%@", _number];
    
    return self;
}


-(void)startThread
{
    threadStatus = TRUE;
    
    [self fetchRequestStatus];
    
    //[self performSelector:@selector(stopThread) withObject:nil afterDelay:12.0];
}

-(void)stopThread
{
    threadStatus = FALSE;
}

-(BOOL)isRunning
{
    return threadStatus;
}



/*==============After Calling for Waiter/Bill check in the background what is the status of request=============*/
-(void)fetchRequestStatus
{
    if(!threadStatus)
        return;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH
                                             , 0), ^{
        
        BOOL status = [self callGetTableStatus];
        /*=================Stop Background Loop when Acknowledged=================*/
        if(status) {
            [self stopThread];
            [self showAcknowledgement];
        }
        
        dispatch_sync(dispatch_get_main_queue(), ^{

            if(threadStatus) {
                [self performSelector:@selector(fetchRequestStatus) withObject:nil afterDelay:LOOP_TIME];
            }
            
        });
        
    });
}


/*================1 for waiter 2 for Bill==================*/
-(BOOL)callForStaff:(NSString *)type
{
    callType = [NSString stringWithFormat:@"%@", type];
    
    if(![self checkNetwork]) {
        return FALSE;
    }
    
    BOOL status = [self callTableAttentionAPI:[NSString stringWithFormat:@"%@", type]];
    
    if(status) {
        callStatus = TRUE;
        [self startThread];
    }
    else {
        [ShareableData showAlert:@"Alert" message:@"Message could not be sent."];
    }
    
    return status;
}

-(BOOL)checkNetwork
{
    Reachability* wifiReach = [Reachability reachabilityForLocalWiFi];
    NetworkStatus netStatus = [wifiReach currentReachabilityStatus];
    
    BOOL status = FALSE;
    
    if (netStatus == ReachableViaWiFi) {
        status = TRUE;
    }
    else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"No WIFI available!", @"AlertView")
                                                            message:NSLocalizedString(@"You have no wifi connection available. Please connect to a WIFI network.", @"AlertView")
                                                           delegate:self
                                                  cancelButtonTitle:NSLocalizedString(@"Cancel", @"AlertView")
                                                  otherButtonTitles:NSLocalizedString(@"Check Your Settings", @"AlertView"), nil];
        
        [alertView performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];

    }

    return status;
}

/*=================== -1 > Return all rows and pass table number for getting a single table's status====================*/
-(BOOL)callGetTableStatus
{
    
    BOOL status = FALSE;
    
    NSString *post =[NSString stringWithFormat:@"key=%@&table_no=%@", [ShareableData appKey], tableNumber];
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    NSString *url_string = [NSString stringWithFormat:@"%@/webs/get_status", [ShareableData serverURL]];
    [request setURL:[NSURL URLWithString:url_string]];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/x-www-form-urlencoded charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSError *error;
    NSURLResponse *response;
    NSData *uData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSDictionary* data = [NSJSONSerialization JSONObjectWithData:uData options:kNilOptions error:&error];
    
    if([data[@"success"] intValue] == 1) {
        if([data[@"table_status"] intValue] == 1) {
            status = TRUE;
        }
    }
    

    
    return status;
}


/*==================Call for Waiter/Bill Api====================*/
-(BOOL)callTableAttentionAPI:(NSString *)type
{
    BOOL status = FALSE;
    
    NSString *post =[NSString stringWithFormat:@"key=%@&call_type=%@&table_no=%@", [ShareableData appKey], callType, tableNumber];
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    NSString *url_string = [NSString stringWithFormat:@"%@/webs/call_for_waiter", [ShareableData serverURL]];
    [request setURL:[NSURL URLWithString:url_string]];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/x-www-form-urlencoded charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSError *error;
    NSURLResponse *response;
    NSData *uData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSDictionary* data = [NSJSONSerialization JSONObjectWithData:uData options:kNilOptions error:&error];
        
    if([data[@"success"] intValue] == 1) {
        status = TRUE;
    }
    
    return status;
}



-(void)showAcknowledgement
{    
    NSString *msg = @"Our staff will attend to you shortly. Thank you.";
    
    if([callType isEqualToString:BILL]) {
        msg = @"Your bill will be presented to you shortly. Thank you.";
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:msg delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];
}


@end
