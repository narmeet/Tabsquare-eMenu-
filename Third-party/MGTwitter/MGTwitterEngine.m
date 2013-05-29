//
//  MGTwitterEngine.m
//  MGTwitterEngine
//
//  Created by Matt Gemmell on 10/02/2008.
//  Copyright 2008 Instinctive Code.
//

#import "MGTwitterEngine.h"
#import "MGTwitterHTTPURLConnection.h"
#import "SA_OAuthTwitterEngine.h"

#import "NSData+Base64.h"

#define USE_LIBXML 0

#if YAJL_AVAILABLE
	#define API_FORMAT @"json"
    //#define API_FORMAT @"xml"

//	#import "MGTwitterStatusesYAJLParser.h"
//	#import "MGTwitterMessagesYAJLParser.h"
//	#import "MGTwitterUsersYAJLParser.h"
//	#import "MGTwitterMiscYAJLParser.h"
//	#import "MGTwitterSearchYAJLParser.h"
#else
	//#define API_FORMAT @"xml"
    #define API_FORMAT @"json"

	#if USE_LIBXML
		#import "MGTwitterStatusesLibXMLParser.h"
		#import "MGTwitterMessagesLibXMLParser.h"
		#import "MGTwitterUsersLibXMLParser.h"
		#import "MGTwitterMiscLibXMLParser.h"
	#else
//		#import "MGTwitterStatusesParser.h"
//		#import "MGTwitterUsersParser.h"
//		#import "MGTwitterMessagesParser.h"
//		#import "MGTwitterMiscParser.h"
	#endif
#endif

//#define TWITTER_DOMAIN          @"twitter.com"
#define TWITTER_DOMAIN          @"api.twitter.com/1"
//#define TWITTER_DOMAIN          @"stream.twitter.com"
#if YAJL_AVAILABLE
	#define TWITTER_SEARCH_DOMAIN	@"search.twitter.com"
#endif
#define HTTP_POST_METHOD        @"POST"
#define MAX_MESSAGE_LENGTH      140 // Twitter recommends tweets of max 140 chars
#define MAX_NAME_LENGTH			20
#define MAX_EMAIL_LENGTH		40
#define MAX_URL_LENGTH			100
#define MAX_LOCATION_LENGTH		30
#define MAX_DESCRIPTION_LENGTH	160

#define DEFAULT_CLIENT_NAME     @"MGTwitterEngine"
#define DEFAULT_CLIENT_VERSION  @"1.0"
#define DEFAULT_CLIENT_URL      @"http://mattgemmell.com/source"
#define DEFAULT_CLIENT_TOKEN	@"mgtwitterengine"

#define URL_REQUEST_TIMEOUT     25.0 // Twitter usually fails quickly if it's going to fail at all.


@interface MGTwitterEngine (PrivateMethods)

// Utility methods
- (NSDateFormatter *)_HTTPDateFormatter;
- (NSString *)_queryStringWithBase:(NSString *)base parameters:(NSDictionary *)params prefixed:(BOOL)prefixed;
- (NSDate *)_HTTPToDate:(NSString *)httpDate;
- (NSString *)_dateToHTTP:(NSDate *)date;
- (NSString *)_encodeString:(NSString *)string;

// Connection/Request methods
- (NSString *)_sendRequestWithMethod:(NSString *)method 
                                path:(NSString *)path 
                     queryParameters:(NSDictionary *)params
                                body:(NSString *)body 
                         requestType:(MGTwitterRequestType)requestType 
                        responseType:(MGTwitterResponseType)responseType;

// Parsing methods
- (void)_parseDataForConnection:(MGTwitterHTTPURLConnection *)connection;

// Delegate methods
- (BOOL) _isValidDelegateForSelector:(SEL)selector;

@end


@implementation MGTwitterEngine


#pragma mark Constructors


+ (MGTwitterEngine *)twitterEngineWithDelegate:(NSObject *)theDelegate
{
    return [[MGTwitterEngine alloc] initWithDelegate:theDelegate];
}


- (MGTwitterEngine *)initWithDelegate:(NSObject<MGTwitterEngineDelegate>*)newDelegate
{
    if (self = [super init]) {
        _delegate = newDelegate; // deliberately weak reference
        _connections = [[NSMutableDictionary alloc] initWithCapacity:0];
        _clientName = DEFAULT_CLIENT_NAME;
        _clientVersion = DEFAULT_CLIENT_VERSION;
        _clientURL = DEFAULT_CLIENT_URL;
		_clientSourceToken = DEFAULT_CLIENT_TOKEN;
		_APIDomain = TWITTER_DOMAIN;
#if YAJL_AVAILABLE
		_searchDomain = [TWITTER_SEARCH_DOMAIN retain];
#endif

        _secureConnection = NO;
		_clearsCookies = NO;
#if YAJL_AVAILABLE
		_deliveryOptions = MGTwitterEngineDeliveryAllResultsOption;
#endif
    }
    
    return self;
}


- (void)dealloc
{
    _delegate = nil;
    
    [[_connections allValues] makeObjectsPerformSelector:@selector(cancel)];
    
#if YAJL_AVAILABLE
	[_searchDomain release];
#endif
    
}


#pragma mark Configuration and Accessors


+ (NSString *)version
{
    // 1.0.0 = 22 Feb 2008
    // 1.0.1 = 26 Feb 2008
    // 1.0.2 = 04 Mar 2008
    // 1.0.3 = 04 Mar 2008
	// 1.0.4 = 11 Apr 2008
	// 1.0.5 = 06 Jun 2008
	// 1.0.6 = 05 Aug 2008
	// 1.0.7 = 28 Sep 2008
	// 1.0.8 = 01 Oct 2008
    return @"1.0.8";
}


- (NSString *)username
{
    return _username;
}


- (NSString *)password
{
    return _password;
}


- (void)setUsername:(NSString *)newUsername password:(NSString *)newPassword
{
    // Set new credentials.
    _username = newUsername;
    _password = newPassword;
    
	if ([self clearsCookies]) {
		// Remove all cookies for twitter, to ensure next connection uses new credentials.
		NSString *urlString = [NSString stringWithFormat:@"%@://%@", 
							   (_secureConnection) ? @"https" : @"http", 
							   _APIDomain];
		NSURL *url = [NSURL URLWithString:urlString];
		
		NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
		NSEnumerator *enumerator = [[cookieStorage cookiesForURL:url] objectEnumerator];
		NSHTTPCookie *cookie = nil;
		while (cookie = [enumerator nextObject]) {
			[cookieStorage deleteCookie:cookie];
		}
	}
}


- (NSString *)clientName
{
    return _clientName;
}


- (NSString *)clientVersion
{
    return _clientVersion;
}


- (NSString *)clientURL
{
    return _clientURL;
}


- (NSString *)clientSourceToken
{
    return _clientSourceToken;
}


- (void)setClientName:(NSString *)name version:(NSString *)version URL:(NSString *)url token:(NSString *)token;
{
    _clientName = name;
    _clientVersion = version;
    _clientURL = url;
    _clientSourceToken = token;
}


- (NSString *)APIDomain
{
	return _APIDomain;
}


- (void)setAPIDomain:(NSString *)domain
{
	if (!domain || [domain length] == 0) {
		_APIDomain = TWITTER_DOMAIN;
	} else {
		_APIDomain = domain;
	}
}


#if YAJL_AVAILABLE

- (NSString *)searchDomain
{
	return [[_searchDomain retain] autorelease];
}


- (void)setSearchDomain:(NSString *)domain
{
	[_searchDomain release];
	if (!domain || [domain length] == 0) {
		_searchDomain = [TWITTER_SEARCH_DOMAIN retain];
	} else {
		_searchDomain = [domain retain];
	}
}

#endif


- (BOOL)usesSecureConnection
{
    return _secureConnection;
}


- (void)setUsesSecureConnection:(BOOL)flag
{
    _secureConnection = flag;
}


- (BOOL)clearsCookies
{
	return _clearsCookies;
}


- (void)setClearsCookies:(BOOL)flag
{
	_clearsCookies = flag;
}

#if YAJL_AVAILABLE

- (MGTwitterEngineDeliveryOptions)deliveryOptions
{
	return _deliveryOptions;
}

- (void)setDeliveryOptions:(MGTwitterEngineDeliveryOptions)deliveryOptions
{
	_deliveryOptions = deliveryOptions;
}

#endif

#pragma mark Connection methods


- (int)numberOfConnections
{
    return [_connections count];
}


- (NSArray *)connectionIdentifiers
{
    return [_connections allKeys];
}


- (void)closeConnection:(NSString *)connectionIdentifier
{
    MGTwitterHTTPURLConnection *connection = _connections[connectionIdentifier];
    if (connection) {
        [connection cancel];
        [_connections removeObjectForKey:connectionIdentifier];
		if ([self _isValidDelegateForSelector:@selector(connectionFinished:)])
			[_delegate connectionFinished:connectionIdentifier];
    }
}


- (void)closeAllConnections
{
    [[_connections allValues] makeObjectsPerformSelector:@selector(cancel)];
    [_connections removeAllObjects];
}


#pragma mark Utility methods


- (NSDateFormatter *)_HTTPDateFormatter
{
    // Returns a formatter for dates in HTTP format (i.e. RFC 822, updated by RFC 1123).
    // e.g. "Sun, 06 Nov 1994 08:49:37 GMT"
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	//[dateFormatter setDateFormat:@"%a, %d %b %Y %H:%M:%S GMT"]; // won't work with -init, which uses new (unicode) format behaviour.
	[dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
	[dateFormatter setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss GMT"];
	return dateFormatter;
}


- (NSString *)_queryStringWithBase:(NSString *)base parameters:(NSDictionary *)params prefixed:(BOOL)prefixed
{
    // Append base if specified.
    NSMutableString *str = [NSMutableString stringWithCapacity:0];
    if (base) {
        [str appendString:base];
    }
    
    // Append each name-value pair.
    if (params) {
        int i;
        NSArray *names = [params allKeys];
        for (i = 0; i < [names count]; i++) {
            if (i == 0 && prefixed) {
                [str appendString:@"?"];
            } else if (i > 0) {
                [str appendString:@"&"];
            }
            NSString *name = names[i];
            [str appendString:[NSString stringWithFormat:@"%@=%@", 
             name, [self _encodeString:params[name]]]];
        }
    }
    
    return str;
}


- (NSDate *)_HTTPToDate:(NSString *)httpDate
{
    NSDateFormatter *dateFormatter = [self _HTTPDateFormatter];
    return [dateFormatter dateFromString:httpDate];
}


- (NSString *)_dateToHTTP:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [self _HTTPDateFormatter];
    return [dateFormatter stringFromDate:date];
}


- (NSString *)_encodeString:(NSString *)string
{
    NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, 
                                                                 (CFStringRef)string, 
                                                                 NULL, 
                                                                 (CFStringRef)@";/?:@&=$+{}<>,",
                                                                 kCFStringEncodingUTF8));
    return result;
}


- (NSString *)getImageAtURL:(NSString *)urlString
{
    // This is a method implemented for the convenience of the client, 
    // allowing asynchronous downloading of users' Twitter profile images.
	NSString *encodedUrlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:encodedUrlString];
    if (!url) {
        return nil;
    }
    
    // Construct an NSMutableURLRequest for the URL and set appropriate request method.
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url 
                                                              cachePolicy:NSURLRequestReloadIgnoringCacheData 
                                                          timeoutInterval:URL_REQUEST_TIMEOUT];
    
    // Create a connection using this request, with the default timeout and caching policy, 
    // and appropriate Twitter request and response types for parsing and error reporting.
    MGTwitterHTTPURLConnection *connection;
    connection = [[MGTwitterHTTPURLConnection alloc] initWithRequest:theRequest 
                                                            delegate:self 
                                                         requestType:MGTwitterImageRequest 
                                                        responseType:MGTwitterImage];
    
    if (!connection) {
        return nil;
    } else {
        _connections[[connection identifier]] = connection;
    }
    
    return [connection identifier];
}


#pragma mark Request sending methods

#define SET_AUTHORIZATION_IN_HEADER 1

- (NSString *)_sendRequestWithMethod:(NSString *)method 
                                path:(NSString *)path 
                     queryParameters:(NSDictionary *)params 
                                body:(NSString *)body 
                         requestType:(MGTwitterRequestType)requestType 
                        responseType:(MGTwitterResponseType)responseType
{
    // Construct appropriate URL string.
    NSString *fullPath = path;
    if (params) {
        fullPath = [self _queryStringWithBase:fullPath parameters:params prefixed:YES];
    }

#if YAJL_AVAILABLE
	NSString *domain = nil;
	NSString *connectionType = nil;
	if (requestType == MGTwitterSearchRequest || requestType == MGTwitterSearchCurrentTrendsRequest)
	{
		domain = _searchDomain;
		connectionType = @"http";
	}
	else
	{
		domain = _APIDomain;
		if (_secureConnection)
		{
			connectionType = @"https";
		}
		else
		{
			connectionType = @"http";
		}
	}
#else
	NSString *domain = _APIDomain;
	NSString *connectionType = nil;
	if (_secureConnection)
	{
		connectionType = @"https";
	}
	else
	{
		connectionType = @"http";
	}
#endif
	
#if SET_AUTHORIZATION_IN_HEADER
    NSString *urlString = [NSString stringWithFormat:@"%@://%@/%@", 
                           connectionType,
                           domain, fullPath];
#else    
    NSString *urlString = [NSString stringWithFormat:@"%@://%@:%@@%@/%@", 
                           connectionType, 
                           [self _encodeString:_username], [self _encodeString:_password], 
                           domain, fullPath];
#endif
    
    NSURL *finalURL = [NSURL URLWithString:urlString];
    if (!finalURL) {
        return nil;
    }

#if DEBUG
    if (YES) {
		DLog(@"MGTwitterEngine: finalURL = %@", finalURL);
	}
#endif

    // Construct an NSMutableURLRequest for the URL and set appropriate request method.
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:finalURL 
                                                              cachePolicy:NSURLRequestReloadIgnoringCacheData 
                                                          timeoutInterval:URL_REQUEST_TIMEOUT];
    if (method) {
        [theRequest setHTTPMethod:method];
    }
    [theRequest setHTTPShouldHandleCookies:NO];
    
    // Set headers for client information, for tracking purposes at Twitter.
    [theRequest setValue:_clientName    forHTTPHeaderField:@"X-Twitter-Client"];
    [theRequest setValue:_clientVersion forHTTPHeaderField:@"X-Twitter-Client-Version"];
    [theRequest setValue:_clientURL     forHTTPHeaderField:@"X-Twitter-Client-URL"];
    
#if SET_AUTHORIZATION_IN_HEADER
	if ([self username] && [self password]) {
		// Set header for HTTP Basic authentication explicitly, to avoid problems with proxies and other intermediaries
		NSString *authStr = [NSString stringWithFormat:@"%@:%@", [self username], [self password]];
		NSData *authData = [authStr dataUsingEncoding:NSASCIIStringEncoding];
		NSString *authValue = [NSString stringWithFormat:@"Basic %@", [authData base64EncodingWithLineLength:80]];
		[theRequest setValue:authValue forHTTPHeaderField:@"Authorization"];
	}
#endif

    // Set the request body if this is a POST request.
    BOOL isPOST = (method && [method isEqualToString:HTTP_POST_METHOD]);
    if (isPOST) {
        // Set request body, if specified (hopefully so), with 'source' parameter if appropriate.
        NSString *finalBody = @"";
		if (body) {
			finalBody = [finalBody stringByAppendingString:body];
		}
        if (_clientSourceToken) {
            finalBody = [finalBody stringByAppendingString:[NSString stringWithFormat:@"%@source=%@", 
                                                            (body) ? @"&" : @"?" , 
                                                            _clientSourceToken]];
        }
        
        if (finalBody) {
            [theRequest setHTTPBody:[finalBody dataUsingEncoding:NSUTF8StringEncoding]];
#if DEBUG
			if (YES) {
				DLog(@"MGTwitterEngine: finalBody = %@", finalBody);
			}
#endif
        }
    }
    
    
    // Create a connection using this request, with the default timeout and caching policy, 
    // and appropriate Twitter request and response types for parsing and error reporting.
    MGTwitterHTTPURLConnection *connection;
    connection = [[MGTwitterHTTPURLConnection alloc] initWithRequest:theRequest 
                                                            delegate:self 
                                                         requestType:requestType 
                                                        responseType:responseType];
    
    if (!connection) {
        return nil;
    } else {
        _connections[[connection identifier]] = connection;
    }
    
    return [connection identifier];
}


#pragma mark Parsing methods

#if YAJL_AVAILABLE
- (void)_parseDataForConnection:(MGTwitterHTTPURLConnection *)connection
{
    NSString *identifier = [[[connection identifier] copy] autorelease];
    NSData *jsonData = [[[connection data] copy] autorelease];
    MGTwitterRequestType requestType = [connection requestType];
    MGTwitterResponseType responseType = [connection responseType];

	NSURL *URL = [connection URL];

#if DEBUG
	if (NO) {
		DLog(@"MGTwitterEngine: jsonData = %@ from %@", [[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding] autorelease], URL);
	}
#endif

    switch (responseType) {
        case MGTwitterStatuses:
        case MGTwitterStatus:
            [MGTwitterStatusesYAJLParser parserWithJSON:jsonData delegate:self 
                              connectionIdentifier:identifier requestType:requestType 
                                      responseType:responseType URL:URL deliveryOptions:_deliveryOptions];
            break;
        case MGTwitterUsers:
        case MGTwitterUser:
            [MGTwitterUsersYAJLParser parserWithJSON:jsonData delegate:self 
                           connectionIdentifier:identifier requestType:requestType 
                                   responseType:responseType URL:URL deliveryOptions:_deliveryOptions];
            break;
        case MGTwitterDirectMessages:
        case MGTwitterDirectMessage:
            [MGTwitterMessagesYAJLParser parserWithJSON:jsonData delegate:self 
                              connectionIdentifier:identifier requestType:requestType 
                                      responseType:responseType URL:URL deliveryOptions:_deliveryOptions];
            break;
		case MGTwitterMiscellaneous:
			[MGTwitterMiscYAJLParser parserWithJSON:jsonData delegate:self 
						  connectionIdentifier:identifier requestType:requestType 
								  responseType:responseType URL:URL deliveryOptions:_deliveryOptions];
			break;
        case MGTwitterSearchResults:
 			[MGTwitterSearchYAJLParser parserWithJSON:jsonData delegate:self 
						  connectionIdentifier:identifier requestType:requestType 
								  responseType:responseType URL:URL deliveryOptions:_deliveryOptions];
			break;
       default:
            break;
    }
}
#else
- (void)_parseDataForConnection:(MGTwitterHTTPURLConnection *)connection
{
    NSString *identifier = [[connection identifier] copy];
    NSData *xmlData = [[connection data] copy];
//    MGTwitterRequestType requestType = [connection requestType];
//    MGTwitterResponseType responseType = [connection responseType];
            
//    if(requestType == MGTwitterUserInformationRequest && responseType == MGTwitterUsers)
    {
        NSString *string = [[NSString alloc] initWithData: xmlData encoding: NSUTF8StringEncoding];
        NSError *error;
        NSData *jsonData = [string dataUsingEncoding:NSUTF8StringEncoding];
        
        //NSDictionary *jsonArray = [string JSONValue];
        NSDictionary *jsonArray = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
        if(jsonArray)
            [_delegate responseOfTwt:jsonArray requestIdentifier:identifier];
        else
            [_delegate parsingTwitterAPIError];
        return;
    }
    
//#if USE_LIBXML
//	NSURL *URL = [connection URL];
//
//    switch (responseType) {
//        case MGTwitterStatuses:
//        case MGTwitterStatus:
//            [MGTwitterStatusesLibXMLParser parserWithXML:xmlData delegate:self 
//                              connectionIdentifier:identifier requestType:requestType 
//                                      responseType:responseType URL:URL];
//            break;
//        case MGTwitterUsers:
//        case MGTwitterUser:
//            [MGTwitterUsersLibXMLParser parserWithXML:xmlData delegate:self 
//                           connectionIdentifier:identifier requestType:requestType 
//                                   responseType:responseType URL:URL];
//            break;
//        case MGTwitterDirectMessages:
//        case MGTwitterDirectMessage:
//            [MGTwitterMessagesLibXMLParser parserWithXML:xmlData delegate:self 
//                              connectionIdentifier:identifier requestType:requestType 
//                                      responseType:responseType URL:URL];
//            break;
//		case MGTwitterMiscellaneous:
//			[MGTwitterMiscLibXMLParser parserWithXML:xmlData delegate:self 
//						  connectionIdentifier:identifier requestType:requestType 
//								  responseType:responseType URL:URL];
//			break;
//        default:
//            break;
//    }
//#else
//    // Determine which type of parser to use.
//    switch (responseType) {
//        case MGTwitterStatuses:
//        case MGTwitterStatus:
//            [MGTwitterStatusesParser parserWithXML:xmlData delegate:self 
//                              connectionIdentifier:identifier requestType:requestType 
//                                      responseType:responseType];
//            break;
//        case MGTwitterUsers:
//        case MGTwitterUser:
//            [MGTwitterUsersParser parserWithXML:xmlData delegate:self 
//                           connectionIdentifier:identifier requestType:requestType 
//                                   responseType:responseType];
//            break;
//        case MGTwitterDirectMessages:
//        case MGTwitterDirectMessage:
//            [MGTwitterMessagesParser parserWithXML:xmlData delegate:self 
//                              connectionIdentifier:identifier requestType:requestType 
//                                      responseType:responseType];
//            break;
//		case MGTwitterMiscellaneous:
//			[MGTwitterMiscParser parserWithXML:xmlData delegate:self 
//						  connectionIdentifier:identifier requestType:requestType 
//								  responseType:responseType];
//			break;
//        default:
//            break;
//    }
//#endif
}
#endif

#pragma mark Delegate methods

- (BOOL) _isValidDelegateForSelector:(SEL)selector
{
	return ((_delegate != nil) && [_delegate respondsToSelector:selector]);
}

#pragma mark MGTwitterParserDelegate methods

- (void)parsingSucceededForRequest:(NSString *)identifier 
                    ofResponseType:(MGTwitterResponseType)responseType 
                 withParsedObjects:(NSArray *)parsedObjects
{
    // Forward appropriate message to _delegate, depending on responseType.
    switch (responseType) {
        case MGTwitterStatuses:
        case MGTwitterStatus:
			if ([self _isValidDelegateForSelector:@selector(statusesReceived:forRequest:)])
				[_delegate statusesReceived:parsedObjects forRequest:identifier];
            break;
        case MGTwitterUsers:
        case MGTwitterUser:
			if ([self _isValidDelegateForSelector:@selector(userInfoReceived:forRequest:)])
				[_delegate userInfoReceived:parsedObjects forRequest:identifier];
            break;
        case MGTwitterDirectMessages:
        case MGTwitterDirectMessage:
			if ([self _isValidDelegateForSelector:@selector(directMessagesReceived:forRequest:)])
				[_delegate directMessagesReceived:parsedObjects forRequest:identifier];
            break;
		case MGTwitterMiscellaneous:
			if ([self _isValidDelegateForSelector:@selector(miscInfoReceived:forRequest:)])
				[_delegate miscInfoReceived:parsedObjects forRequest:identifier];
			break;
#if YAJL_AVAILABLE
		case MGTwitterSearchResults:
			if ([self _isValidDelegateForSelector:@selector(searchResultsReceived:forRequest:)])
				[_delegate searchResultsReceived:parsedObjects forRequest:identifier];
			break;
#endif
        default:
            break;
    }
}

- (void)parsingFailedForRequest:(NSString *)requestIdentifier 
                 ofResponseType:(MGTwitterResponseType)responseType 
                      withError:(NSError *)error
{
	if ([self _isValidDelegateForSelector:@selector(requestFailed:withError:)])
		[_delegate requestFailed:requestIdentifier withError:error];
}

#if YAJL_AVAILABLE

- (void)parsedObject:(NSDictionary *)dictionary forRequest:(NSString *)requestIdentifier 
                 ofResponseType:(MGTwitterResponseType)responseType
{
	if ([self _isValidDelegateForSelector:@selector(receivedObject:forRequest:)])
		[_delegate receivedObject:dictionary forRequest:requestIdentifier];
}

- (void) response:(id)response
{

        DLog(@"MGTwitterEngine%@",response);
    
}

#endif

#pragma mark NSURLConnection delegate methods


- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
	if (_username && _password && [challenge previousFailureCount] == 0 && ![challenge proposedCredential]) {
		NSURLCredential *credential = [NSURLCredential credentialWithUser:_username password:_password 
															  persistence:NSURLCredentialPersistenceForSession];
		[[challenge sender] useCredential:credential forAuthenticationChallenge:challenge];
	} else {
		[[challenge sender] continueWithoutCredentialForAuthenticationChallenge:challenge];
	}
}


- (void)connection:(MGTwitterHTTPURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    // This method is called when the server has determined that it has enough information to create the NSURLResponse.
    // it can be called multiple times, for example in the case of a redirect, so each time we reset the data.
    [connection resetDataLength];
    
    DLog(@"%@",[connection description]);
    
    // Get response code.
    NSHTTPURLResponse *resp = (NSHTTPURLResponse *)response;
    int statusCode = [resp statusCode];
    if (statusCode >= 400) {
        // Assume failure, and report to delegate.
        NSError *error = [NSError errorWithDomain:@"HTTP" code:statusCode userInfo:nil];
		if ([self _isValidDelegateForSelector:@selector(requestFailed:withError:)])
			[_delegate requestFailed:[connection identifier] withError:error];
        
        // Destroy the connection.
        [connection cancel];
		NSString *connectionIdentifier = [connection identifier];
		[_connections removeObjectForKey:connectionIdentifier];
		if ([self _isValidDelegateForSelector:@selector(connectionFinished:)])
			[_delegate connectionFinished:connectionIdentifier];
			        
    } else if (statusCode == 304 || [connection responseType] == MGTwitterGeneric) {
        // Not modified, or generic success.
		if ([self _isValidDelegateForSelector:@selector(requestSucceeded:)])
			[_delegate requestSucceeded:[connection identifier]];
        if (statusCode == 304) {
            [self parsingSucceededForRequest:[connection identifier] 
                              ofResponseType:[connection responseType] 
                           withParsedObjects:@[]];
        }
        
        // Destroy the connection.
        [connection cancel];
		NSString *connectionIdentifier = [connection identifier];
		[_connections removeObjectForKey:connectionIdentifier];
		if ([self _isValidDelegateForSelector:@selector(connectionFinished:)])
			[_delegate connectionFinished:connectionIdentifier];
    }
    
#if DEBUG
    if (NO) {
        // Display headers for debugging.
        NSHTTPURLResponse *resp = (NSHTTPURLResponse *)response;
        DLog(@"MGTwitterEngine: (%d) [%@]:\r%@", 
              [resp statusCode], 
              [NSHTTPURLResponse localizedStringForStatusCode:[resp statusCode]], 
              [resp allHeaderFields]);
    }
#endif
}


- (void)connection:(MGTwitterHTTPURLConnection *)connection didReceiveData:(NSData *)data
{
    // Append the new data to the receivedData.
    
    [connection appendData:data];
}


- (void)connection:(MGTwitterHTTPURLConnection *)connection didFailWithError:(NSError *)error
{
    
    DLog(@"Fail didFailWithError");
    // Inform delegate.
	if ([self _isValidDelegateForSelector:@selector(requestFailed:withError:)])
		[_delegate requestFailed:[connection identifier] withError:error];
    
    // Release the connection.
	NSString *connectionIdentifier = [connection identifier];
    [_connections removeObjectForKey:connectionIdentifier];
	if ([self _isValidDelegateForSelector:@selector(connectionFinished:)])
		[_delegate connectionFinished:connectionIdentifier];
}


- (void)connectionDidFinishLoading:(MGTwitterHTTPURLConnection *)connection
{
    // Inform delegate.
	if ([self _isValidDelegateForSelector:@selector(requestSucceeded:)])
		[_delegate requestSucceeded:[connection identifier]];
    
    NSData *receivedData = [connection data];
    if (receivedData) {
#if DEBUG
        if (NO) {
            // Dump data as string for debugging.
            NSString *dataString = [NSString stringWithUTF8String:[receivedData bytes]];
            DLog(@"MGTwitterEngine: Succeeded! Received %d bytes of data:\r\r%@", [receivedData length], dataString);
        }
        
        if (NO) {
            // Dump XML to file for debugging.
            NSString *dataString = [NSString stringWithUTF8String:[receivedData bytes]];
            [dataString writeToFile:[[NSString stringWithFormat:@"~/Desktop/twitter_messages.%@", API_FORMAT] stringByExpandingTildeInPath] 
                         atomically:NO encoding:NSUnicodeStringEncoding error:NULL];
        }
#endif
        
        if ([connection responseType] == MGTwitterImage) {
            
			// Create image from data.
#if TARGET_OS_IPHONE
            
            
             UIImage *image = [[UIImage alloc] initWithData:[connection data]];
                                
#else
            NSImage *image = [[[NSImage alloc] initWithData:[connection data]] autorelease];
#endif
            
            // Inform delegate.
			if ([self _isValidDelegateForSelector:@selector(imageReceived:forRequest:)])
				[_delegate imageReceived:image forRequest:[connection identifier]];
            
        } else {
            // Parse data from the connection (either XML or JSON.)
            [self _parseDataForConnection:connection];
        }
    }
    
    // Release the connection.
	NSString *connectionIdentifier = [connection identifier];
    [_connections removeObjectForKey:connectionIdentifier];
	if ([self _isValidDelegateForSelector:@selector(connectionFinished:)])
		[_delegate connectionFinished:connectionIdentifier];
}


#pragma mark -
#pragma mark REST API methods
#pragma mark -

#pragma mark Status methods


- (NSString *)getPublicTimeline
{
    NSString *path = [NSString stringWithFormat:@"statuses/public_timeline.%@", API_FORMAT];
    
	return [self _sendRequestWithMethod:nil path:path queryParameters:nil body:nil 
                            requestType:MGTwitterPublicTimelineRequest 
                           responseType:MGTwitterStatuses];
}




#pragma mark -


- (NSString *)getFollowedTimelineSinceID:(NSString *)sinceID startingAtPage:(int)page count:(int)count
{
    return [self getFollowedTimelineSinceID:sinceID withMaximumID:0 startingAtPage:page count:count];
}

- (NSString *)getFollowedTimelineSinceID:(NSString *)sinceID withMaximumID:(NSString *)maxID startingAtPage:(int)page count:(int)count
{
	NSString *path = [NSString stringWithFormat:@"statuses/home_timeline.%@", API_FORMAT];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];

    
    params[@"include_entities"] = @"1";
//    [params setObject:@"0" forKey:@"include_rts"];
//    [params setObject:@"0" forKey:@"exclude_replies"];

    
    if ([sinceID intValue] > 0) {
        params[@"since_id"] = [NSString stringWithFormat:@"%u", sinceID];
    }
    if ([maxID intValue] > 0) {
        params[@"max_id"] = [NSString stringWithFormat:@"%@", maxID];
    }
    if (page > 0) {
        params[@"page"] = [NSString stringWithFormat:@"%d", page];
    }
    if (count > 0) {
        params[@"count"] = [NSString stringWithFormat:@"%d", count];
    }
    
    return [self _sendRequestWithMethod:nil path:path queryParameters:params body:nil 
                            requestType:MGTwitterFollowedTimelineRequest 
                           responseType:MGTwitterStatuses];
}


#pragma mark -


- (NSString *)getUserTimelineFor:(NSString *)username sinceID:(NSString *)sinceID startingAtPage:(int)page count:(int)count
{
    return [self getUserTimelineFor:username sinceID:sinceID withMaximumID:0 startingAtPage:0 count:count];
}

- (NSString *)getUserTimelineFor:(NSString *)username sinceID:(NSString *)sinceID withMaximumID:(NSString *)maxID startingAtPage:(int)page count:(int)count
{
	NSString *path = [NSString stringWithFormat:@"statuses/user_timeline.%@", API_FORMAT];
    MGTwitterRequestType requestType = MGTwitterUserTimelineRequest;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    
    params[@"include_entities"] = @"1";
    params[@"include_rts"] = @"0";
    params[@"exclude_replies"] = @"1";
    
    
    if ([sinceID intValue] > 0) {
        params[@"since_id"] = [NSString stringWithFormat:@"%@", sinceID];
    }
    if ([maxID intValue] > 0) {
        params[@"max_id"] = [NSString stringWithFormat:@"%@", maxID];
    }
	if (page > 0) 
    {
        params[@"page"] = [NSString stringWithFormat:@"%d", page];
    }
    if (count > 0) 
    {
        params[@"count"] = [NSString stringWithFormat:@"%d", count];
    }
    
    if(username)
    {
          params[@"user_id"] = [NSString stringWithFormat:@"%@",username];
        
        
        
//        [params setObject:[NSString stringWithFormat:@"%@",@"44804066"] forKey:@"user_id"];
//        [params setObject:[NSString stringWithFormat:@"%@",@"465329295"] forKey:@"user_id"];

//          471741741      manmohan singh
//          44804066       sheena 
//          465329295      NDTVMovies
    }
    
		requestType = MGTwitterUserTimelineForUserRequest;
    return [self _sendRequestWithMethod:nil path:path queryParameters:params body:nil 
                            requestType:requestType 
                           responseType:MGTwitterStatuses];
}

- (NSString *)cancelCurrentRequest
{
        
   // return [self _cancelingTheRequestDone]; narmeet
    return @"CANCELED";
}


#pragma mark -


- (NSString *)getTweetInfo:(NSString *)updateID 
{
    NSString *path = [NSString stringWithFormat:@"statuses/show/%@.%@", updateID, API_FORMAT];
    
     NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    params[@"include_entities"] = [NSString stringWithFormat:@"%@",[NSNumber numberWithBool:TRUE]];
    params[@"include_my_retweet"] = [NSString stringWithFormat:@"%@",[NSNumber numberWithBool:TRUE]];
    
    return [self _sendRequestWithMethod:nil path:path queryParameters:params body:nil 
                            requestType:MGTwitterUpdateGetRequest
                           responseType:MGTwitterStatus];
}


- (NSString *)getRetweets:(NSString *)tweetId 
{
    NSString *path = [NSString stringWithFormat:@"statuses/%@/retweeted_by.%@", tweetId, API_FORMAT];
    
//    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
//    [params setObject:[NSString stringWithFormat:@"%@",[NSNumber numberWithBool:TRUE]] forKey:@"include_entities"];
//    [params setObject:[NSString stringWithFormat:@"%d", 15] forKey:@"count"];
    
    return [self _sendRequestWithMethod:nil path:path queryParameters:nil body:nil 
                            requestType:MGTwitterUpdateGetRequest
                           responseType:MGTwitterStatus];
}



- (NSString *)sendUpdate:(NSDictionary *)replyDict
{
    if (!replyDict[@"status"]) {
        return nil;
    }
    
    NSString *path = [NSString stringWithFormat:@"statuses/update.%@", API_FORMAT];
    
    NSString *trimmedText = replyDict[@"status"];
    if ([trimmedText length] > MAX_MESSAGE_LENGTH) {
        trimmedText = [trimmedText substringToIndex:MAX_MESSAGE_LENGTH];
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    NSMutableDictionary *locationDict = replyDict[@"location"];
    if(locationDict)
    {
        params[@"display_coordinates"] = @"1";
        params[@"lat"] = locationDict[@"Lattitude"];
        params[@"long"] = locationDict[@"Longitude"];
    }
    
    params[@"status"] = trimmedText;
    if (replyDict[@"tweetid"] > 0) {
        params[@"in_reply_to_status_id"] = replyDict[@"tweetid"];
    }
    NSString *body = [self _queryStringWithBase:nil parameters:params prefixed:NO];
    
    return [self _sendRequestWithMethod:HTTP_POST_METHOD path:path 
                        queryParameters:params body:body 
                            requestType:MGTwitterUpdateSendRequest
                           responseType:MGTwitterStatus];
}


- (NSString *)sendUpdate:(NSString *)status uploadPhoto:(UIImage *)image latitude:(double)aLatitude longitude:(double)aLongitude
{
    
    //https://api.twitter.com/1/help/configuration.json
    //"max_media_per_upload": 1,
    
    NSData * imageData = (UIImagePNGRepresentation(image));
    
    NSString *boundary = @"----------------------------991990ee82f7";
    
    NSString *body = [[NSString alloc] init];
    body = [body stringByAppendingFormat:@"--%@\r\n", boundary];
    body = [body stringByAppendingFormat:@"Content-Disposition: form-data; name=\"media_data[]\"; filename=\"photo.png\"\r\n"];
    body = [body stringByAppendingFormat:@"Content-Type: application/octet-stream\r\n"];
    body = [body stringByAppendingFormat:@"\r\n"];  
    body = [body stringByAppendingFormat:[imageData base64EncodingWithLineLength:0]];
    body = [body stringByAppendingFormat:@"\r\n--%@\r\n", boundary];
    body = [body stringByAppendingFormat:@"Content-Disposition: form-data; name=\"status\"\r\n"];
    body = [body stringByAppendingFormat:@"\r\n"];
    body = [body stringByAppendingFormat:@"%@\r\n", status];
    body = [body stringByAppendingFormat:@"--%@--\r\n", boundary];
    
    if(aLatitude != 0){
        body = [body stringByAppendingFormat:@"Content-Disposition: form-data; name=\"lat\"\r\n"];
        body = [body stringByAppendingFormat:@"\r\n"];
        body = [body stringByAppendingFormat:@"%f", aLatitude];
        body = [body stringByAppendingFormat:@"\r\n"];
        body = [body stringByAppendingFormat:@"--%@--\r\n", boundary];
    }
    
    if(aLongitude != 0){
        body = [body stringByAppendingFormat:@"Content-Disposition: form-data; name=\"long\"\r\n"];
        body = [body stringByAppendingFormat:@"\r\n"];
        body = [body stringByAppendingFormat:@"%f", aLongitude];
        body = [body stringByAppendingFormat:@"\r\n"];
        body = [body stringByAppendingFormat:@"--%@--\r\n", boundary];
    }
    
    
    NSString *path = [NSString stringWithFormat:@"statuses/update_with_media.%@", API_FORMAT];
    
    
  /*  return [self _sendUploadRequestWithMethod:HTTP_POST_METHOD
                                         path:path 
                                         body:body
                                  requestType:MGTwitterUpdateSendRequest
                                 responseType:MGTwitterStatus];*/// narmeet
    return @"0";
}




#pragma mark -


- (NSString *)getRepliesStartingAtPage:(int)page
{
    return [self getRepliesSinceID:0 startingAtPage:page count:0]; // zero means default
}

- (NSString *)getRepliesSinceID:(unsigned long)sinceID startingAtPage:(int)page count:(int)count
{
    return [self getRepliesSinceID:sinceID withMaximumID:0 startingAtPage:page count:count];
}

- (NSString *)getRepliesSinceID:(unsigned long)sinceID withMaximumID:(unsigned long)maxID startingAtPage:(int)page count:(int)count
{
// NOTE: identi.ca can't handle mentions URL yet...
//	NSString *path = [NSString stringWithFormat:@"statuses/mentions.%@", API_FORMAT];
	NSString *path = [NSString stringWithFormat:@"statuses/replies.%@", API_FORMAT];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    if (sinceID > 0) {
        params[@"since_id"] = [NSString stringWithFormat:@"%u", sinceID];
    }
    if (maxID > 0) {
        params[@"max_id"] = [NSString stringWithFormat:@"%u", maxID];
    }
    if (page > 0) {
        params[@"page"] = [NSString stringWithFormat:@"%d", page];
    }
    if (count > 0) {
        params[@"count"] = [NSString stringWithFormat:@"%d", count];
    }
    
    return [self _sendRequestWithMethod:nil path:path queryParameters:params body:nil 
                            requestType:MGTwitterRepliesRequest 
                           responseType:MGTwitterStatuses];
}


#pragma mark -


- (NSString *)deleteUpdate:(unsigned long)updateID
{
    NSString *path = [NSString stringWithFormat:@"statuses/destroy/%u.%@", updateID, API_FORMAT];
    
    return [self _sendRequestWithMethod:HTTP_POST_METHOD path:path queryParameters:nil body:nil 
                            requestType:MGTwitterUpdateDeleteRequest
                           responseType:MGTwitterStatus];
}


#pragma mark -


- (NSString *)getFeaturedUsers
{
    NSString *path = [NSString stringWithFormat:@"statuses/featured.%@", API_FORMAT];
    
    return [self _sendRequestWithMethod:nil path:path queryParameters:nil body:nil 
                            requestType:MGTwitterFeaturedUsersRequest 
                           responseType:MGTwitterUsers];
}


#pragma mark User methods


- (NSString *)getRecentlyUpdatedFriendsFor:(NSString *)username startingAtPage:(int)page
{
    NSString *path = [NSString stringWithFormat:@"statuses/friends.%@", API_FORMAT];
    MGTwitterRequestType requestType = MGTwitterFriendUpdatesRequest;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    if (username) 
    {
        path = [NSString stringWithFormat:@"statuses/friends/%@.%@", username, API_FORMAT];
		requestType = MGTwitterFriendUpdatesForUserRequest;
    }
    if (page > 0) 
    {
        params[@"page"] = [NSString stringWithFormat:@"%d", page];
    }
    
    return [self _sendRequestWithMethod:nil path:path queryParameters:params body:nil 
                            requestType:requestType 
                           responseType:MGTwitterUsers];
}


- (NSString *)getAllFriends:(NSString *)username pageNumber:(NSString *)pageNo
{
    
    NSString *path = [NSString stringWithFormat:@"friends/ids.%@", @"json"];
    
    if (username) 
    {
        path = [NSString stringWithFormat:@"friends/ids.%@?cursor=%@&user_id=%@&stringify_ids=1", @"json", pageNo, username];
//        path = [NSString stringWithFormat:@"friends/ids.%@?cursor=%@&screen_name=%@&stringify_ids=1", @"json", pageNo, @"whoissheena"];
    }
    
    return [self _sendRequestWithMethod:nil path:path queryParameters:nil body:nil 
                            requestType:MGTwitterUserInformationRequest responseType:MGTwitterUsers];
}

- (NSString *)getAllFollowers:(NSString *)username pageNumber:(NSString *)pageNo
{
    
    NSString *path = [NSString stringWithFormat:@"followers/ids.%@", @"json"];
    
    if (username) 
    {
        path = [NSString stringWithFormat:@"followers/ids.%@?cursor=%@&user_id=%@&stringify_ids=1", @"json", pageNo, username];
    }
    
    return [self _sendRequestWithMethod:nil path:path queryParameters:nil body:nil 
                            requestType:MGTwitterUserInformationRequest responseType:MGTwitterUsers];
}

- (NSString *) getUsersInformation:(NSMutableString *)usersId
{

    NSString *path = [NSString stringWithFormat:@"users/lookup.%@", API_FORMAT];
    
    if (usersId) 
    {
        path = [NSString stringWithFormat:@"users/lookup.%@?user_id=%@&include_entities=0", @"json", usersId];
    }
    
    return [self _sendRequestWithMethod:nil path:path queryParameters:nil body:nil 
                            requestType:MGTwitterUserInformationRequest responseType:MGTwitterUsers];


}

#pragma mark -

- (NSString *)getFollowersIncludingCurrentStatus
{
    return [self getFollowersIncludingCurrentStatus:YES];
}



- (NSString *)getFollowersIncludingCurrentStatus:(BOOL)flag
{
    NSString *path = [NSString stringWithFormat:@"statuses/followers.%@", API_FORMAT];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    if (!flag) {
        params[@"lite"] = @"true";
    }
    
    return [self _sendRequestWithMethod:nil path:path queryParameters:params body:nil 
                            requestType:MGTwitterFollowerUpdatesRequest
                           responseType:MGTwitterUsers];
}




#pragma mark -


- (NSString *)getUserInformationFor:(NSString *)usernameOrID
{
    if (!usernameOrID) {
        return nil;
    }
    
    
    NSString *path = [NSString stringWithFormat:@"users/show.%@", API_FORMAT];
     NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    params[@"user_id"] = usernameOrID;
    params[@"include_entities"] = [NSString stringWithFormat:@"%@",[NSNumber numberWithBool:TRUE]];
    
    return [self _sendRequestWithMethod:nil path:path queryParameters:params body:nil 
                            requestType:MGTwitterUserInformationRequest 
                           responseType:MGTwitterUser];
}


- (NSString *)getUserInformationForEmail:(NSString *)email
{
    NSString *path = [NSString stringWithFormat:@"users/show.%@", API_FORMAT];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    if (email) {
        params[@"email"] = email;
    } else {
        return nil;
    }
    
    return [self _sendRequestWithMethod:nil path:path queryParameters:params body:nil 
                            requestType:MGTwitterUserInformationRequest 
                           responseType:MGTwitterUser];
}

- (NSString *)searchUser:(NSString *)usernameOrID
{
    if (!usernameOrID) 
    {
        return nil;
    }
    
    NSString *path = [NSString stringWithFormat:@"users/search.%@", API_FORMAT];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    
    
    params[@"q"] = usernameOrID;
    
    params[@"include_entities"] = [NSString stringWithFormat:@"%@",[NSNumber numberWithBool:TRUE]];
    
    return [self _sendRequestWithMethod:nil path:path queryParameters:params body:nil 
                            requestType:MGTwitterUserInformationRequest 
                           responseType:MGTwitterUser];
}



#pragma mark Direct Message methods


- (NSString *) getOembedData:(NSString *)tweetId url:(NSString *)url
{
    if (!tweetId) 
    {
        return nil;
    }
    
    NSString *path = [NSString stringWithFormat:@"statuses/oembed.%@", @"json"];
   
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    params[@"id"] = tweetId;
    params[@"url"] = url;
    
    return [self _sendRequestWithMethod:nil path:path queryParameters:params body:nil 
                            requestType:MGTwitterUpdateGetRequest 
                           responseType:MGTwitterStatus];
}


- (NSString *)getDirectMessagesSinceID:(unsigned long)sinceID startingAtPage:(int)page
{
    return [self getDirectMessagesSinceID:sinceID withMaximumID:0 startingAtPage:page count:0];
}

- (NSString *)getDirectMessagesSinceID:(unsigned long)sinceID withMaximumID:(unsigned long)maxID startingAtPage:(int)page count:(int)count
{
    NSString *path = [NSString stringWithFormat:@"direct_messages.%@", API_FORMAT];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    if (sinceID > 0) {
        params[@"since_id"] = [NSString stringWithFormat:@"%u", sinceID];
    }
    if (maxID > 0) {
        params[@"max_id"] = [NSString stringWithFormat:@"%u", maxID];
    }
    if (page > 0) {
        params[@"page"] = [NSString stringWithFormat:@"%d", page];
    }
    if (count > 0) {
        params[@"count"] = [NSString stringWithFormat:@"%d", count];
    }
    
    return [self _sendRequestWithMethod:nil path:path queryParameters:params body:nil 
                            requestType:MGTwitterDirectMessagesRequest 
                           responseType:MGTwitterDirectMessages];
}


#pragma mark -

- (NSString *)getSentDirectMessagesSinceID:(unsigned long)sinceID startingAtPage:(int)page
{
    return [self getSentDirectMessagesSinceID:sinceID withMaximumID:0 startingAtPage:page count:0];
}

- (NSString *)getSentDirectMessagesSinceID:(unsigned long)sinceID withMaximumID:(unsigned long)maxID startingAtPage:(int)page count:(int)count
{
    NSString *path = [NSString stringWithFormat:@"direct_messages/sent.%@", API_FORMAT];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    if (sinceID > 0) {
        params[@"since_id"] = [NSString stringWithFormat:@"%u", sinceID];
    }
    if (maxID > 0) {
        params[@"max_id"] = [NSString stringWithFormat:@"%u", maxID];
    }
    if (page > 0) {
        params[@"page"] = [NSString stringWithFormat:@"%d", page];
    }
    if (count > 0) {
        params[@"count"] = [NSString stringWithFormat:@"%d", count];
    }
    
    return [self _sendRequestWithMethod:nil path:path queryParameters:params body:nil 
                            requestType:MGTwitterDirectMessagesSentRequest 
                           responseType:MGTwitterDirectMessages];
}


#pragma mark -


- (NSString *)sendDirectMessage:(NSString *)message to:(NSString *)username
{
    if (!message || !username) {
        return nil;
    }
    
    NSString *path = [NSString stringWithFormat:@"direct_messages/new.%@", API_FORMAT];
    
    NSString *trimmedText = message;
    if ([trimmedText length] > MAX_MESSAGE_LENGTH) {
        trimmedText = [trimmedText substringToIndex:MAX_MESSAGE_LENGTH];
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    params[@"text"] = trimmedText;
    params[@"user"] = username;
    NSString *body = [self _queryStringWithBase:nil parameters:params prefixed:NO];
    
    return [self _sendRequestWithMethod:HTTP_POST_METHOD path:path 
                        queryParameters:params body:body 
                            requestType:MGTwitterDirectMessageSendRequest
                           responseType:MGTwitterDirectMessage];
}


- (NSString *)deleteDirectMessage:(unsigned long)updateID
{
    NSString *path = [NSString stringWithFormat:@"direct_messages/destroy/%u.%@", updateID, API_FORMAT];
    
    return [self _sendRequestWithMethod:HTTP_POST_METHOD path:path queryParameters:nil body:nil 
                            requestType:MGTwitterDirectMessageDeleteRequest 
                           responseType:MGTwitterDirectMessage];
}


#pragma mark Friendship methods


- (NSString *)enableUpdatesFor:(NSString *)username
{
    // i.e. follow
    if (!username) {
        return nil;
    }
    NSString *path = [NSString stringWithFormat:@"friendships/create/%@.%@", username, API_FORMAT];
    
    return [self _sendRequestWithMethod:HTTP_POST_METHOD path:path queryParameters:nil body:nil 
                            requestType:MGTwitterUpdatesEnableRequest 
                           responseType:MGTwitterUser];
}

//friends/ids


- (NSString *)disableUpdatesFor:(NSString *)username
{
    // i.e. no longer follow
    if (!username) {
        return nil;
    }
    NSString *path = [NSString stringWithFormat:@"friendships/destroy/%@.%@", username, API_FORMAT];
    
    return [self _sendRequestWithMethod:HTTP_POST_METHOD path:path queryParameters:nil body:nil 
                            requestType:MGTwitterUpdatesDisableRequest 
                           responseType:MGTwitterUser];
}


- (NSString *)isUser:(NSString *)username1 receivingUpdatesFor:(NSString *)username2
{
	if (!username1 || !username2) {
        return nil;
    }
	NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    params[@"user_a"] = username1;
	params[@"user_b"] = username2;
	
    NSString *path = [NSString stringWithFormat:@"friendships/exists.%@", API_FORMAT];
    
    return [self _sendRequestWithMethod:nil path:path queryParameters:params body:nil 
                            requestType:MGTwitterUpdatesCheckRequest 
                           responseType:MGTwitterMiscellaneous];
}


#pragma mark Account methods


- (NSString *)checkUserCredentials
{
    NSString *path = [NSString stringWithFormat:@"account/verify_credentials.%@", API_FORMAT];
    
    return [self _sendRequestWithMethod:nil path:path queryParameters:nil body:nil 
                            requestType:MGTwitterAccountRequest 
                           responseType:MGTwitterUser];
}


- (NSString *)getAccountSettings
{
    NSString *path = [NSString stringWithFormat:@"account/settings.%@", API_FORMAT];
    
    return [self _sendRequestWithMethod:nil path:path queryParameters:nil body:nil 
                            requestType:MGTwitterAccountRequest 
                           responseType:MGTwitterUser];
}

//MGTwitterFriendUpdatesRequest



- (NSString *)endUserSession
{
    NSString *path = @"account/end_session"; 
///    path = [NSString stringWithFormat:@"account/end_session.%@", API_FORMAT];
    
    
    // deliberately no format specified
    //
//     NSString *oauth_token = [[NSUserDefaults standardUserDefaults] objectForKey: @"authData"];
//    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
//    [params setObject:oauth_token forKey:@"oauth_token"];
    
    return [self _sendRequestWithMethod:HTTP_POST_METHOD path:path queryParameters:nil body:nil 
                            requestType:MGTwitterAccountRequest 
                           responseType:MGTwitterGeneric];
}


#pragma mark -


// TODO: this API is deprecated, change to account/update_profile
- (NSString *)setLocation:(NSString *)location
{
	if (!location) {
        return nil;
    }
    
    NSString *path = [NSString stringWithFormat:@"account/update_profile.%@", API_FORMAT];
    
    NSString *trimmedLocation = location;
    if ([trimmedLocation length] > MAX_LOCATION_LENGTH) {
        trimmedLocation = [trimmedLocation substringToIndex:MAX_LOCATION_LENGTH];
    }

    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    params[@"location"] = trimmedLocation;
    NSString *body = [self _queryStringWithBase:nil parameters:params prefixed:NO];
    
    return [self _sendRequestWithMethod:HTTP_POST_METHOD path:path 
                        queryParameters:params body:body 
                            requestType:MGTwitterAccountLocationRequest 
                           responseType:MGTwitterUser];
}


#pragma mark -


- (NSString *)setNotificationsDeliveryMethod:(NSString *)method
{
	NSString *deliveryMethod = method;
	if (!method || [method length] == 0) {
		deliveryMethod = @"none";
	}
	
	NSString *path = [NSString stringWithFormat:@"account/update_delivery_device.%@", API_FORMAT];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    if (deliveryMethod) {
        params[@"device"] = deliveryMethod;
    }
    
    return [self _sendRequestWithMethod:HTTP_POST_METHOD path:path queryParameters:params body:nil 
                            requestType:MGTwitterAccountDeliveryRequest
                           responseType:MGTwitterUser];
}


#pragma mark -


- (NSString *)getRateLimitStatus
{
	NSString *path = [NSString stringWithFormat:@"account/rate_limit_status.%@", API_FORMAT];
	
	return [self _sendRequestWithMethod:nil path:path queryParameters:nil body:nil 
                            requestType:MGTwitterAccountStatusRequest 
                           responseType:MGTwitterMiscellaneous];
}


#pragma mark Favorite methods


- (NSString *)getFavoriteUpdatesFor:(NSString *)username startingAtPage:(int)page
{
    NSString *path = [NSString stringWithFormat:@"favorites.%@", API_FORMAT];
    MGTwitterRequestType requestType = MGTwitterFavoritesRequest;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    params[@"include_entities"] = [NSString stringWithFormat:@"%@",[NSNumber numberWithBool:TRUE]];
    if (page > 0) {
        params[@"page"] = [NSString stringWithFormat:@"%d", page];
    }
    params[@"count"] = @"200";
    if (username) {
        path = [NSString stringWithFormat:@"favorites/%@.%@", username, API_FORMAT];
		requestType = MGTwitterFavoritesForUserRequest;
    }
    
    return [self _sendRequestWithMethod:nil path:path queryParameters:params body:nil 
                            requestType:requestType 
                           responseType:MGTwitterStatuses];
}

- (NSString *)getFavoriteUpdatesFor:(NSString *)username startingAtPage:(int)page sinceId:(NSString *)sinceId maxId:(NSString *)maxId
{ 
        NSString *path = [NSString stringWithFormat:@"favorites.%@", API_FORMAT];
         MGTwitterRequestType requestType = MGTwitterFavoritesRequest;
         NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
         
        if (username) 
        {
            path = [NSString stringWithFormat:@"favorites/%@.%@", username, API_FORMAT];
            requestType = MGTwitterFavoritesForUserRequest;
        }
         params[@"include_entities"] = @"1";
         params[@"count"] = @"200";
    
         if ([sinceId intValue] > 0) {
         params[@"since_id"] = [NSString stringWithFormat:@"%u", sinceId];
         }
         if ([maxId intValue] > 0) {
         params[@"max_id"] = [NSString stringWithFormat:@"%u", maxId];
         }
         if (page > 0) {
         params[@"page"] = [NSString stringWithFormat:@"%d", page];
         }
         
         
         return [self _sendRequestWithMethod:nil path:path queryParameters:params body:nil 
         requestType:requestType 
         responseType:MGTwitterStatuses];
}


#pragma mark -


- (NSString *)markUpdate:(NSString *)updateID asFavorite:(BOOL)flag
{
	NSString *path = nil;
	MGTwitterRequestType requestType;
	if (flag)
	{
		path = [NSString stringWithFormat:@"favorites/create/%@.%@", updateID, API_FORMAT];
		requestType = MGTwitterFavoritesEnableRequest;
    }
	else 
    {
		path = [NSString stringWithFormat:@"favorites/destroy/%@.%@", updateID, API_FORMAT];
		requestType = MGTwitterFavoritesDisableRequest;
	}
	
    return [self _sendRequestWithMethod:HTTP_POST_METHOD path:path queryParameters:nil body:nil 
                            requestType:requestType 
                           responseType:MGTwitterStatus];
}




#pragma mark Notification methods


- (NSString *)enableNotificationsFor:(NSString *)username
{
    
//    if (!username) {
//        return nil;
//    }
    NSString *path = [NSString stringWithFormat:@"notifications/follow/%@.%@", username, API_FORMAT];
    
    return [self _sendRequestWithMethod:HTTP_POST_METHOD path:path queryParameters:nil body:nil 
                            requestType:MGTwitterNotificationsEnableRequest 
                           responseType:MGTwitterUser];
}


- (NSString *)disableNotificationsFor:(NSString *)username
{
    if (!username) {
        return nil;
    }
    NSString *path = [NSString stringWithFormat:@"notifications/leave/%@.%@", username, API_FORMAT];
    
    return [self _sendRequestWithMethod:HTTP_POST_METHOD path:path queryParameters:nil body:nil 
                            requestType:MGTwitterNotificationsDisableRequest 
                           responseType:MGTwitterUser];
}


#pragma mark Block methods


- (NSString *)block:(NSString *)username
{
	if (!username) {
		return nil;
	}
	
	NSString *path = [NSString stringWithFormat:@"blocks/create/%@.%@", username, API_FORMAT];
    
    return [self _sendRequestWithMethod:HTTP_POST_METHOD path:path queryParameters:nil body:nil 
                            requestType:MGTwitterBlockEnableRequest
                           responseType:MGTwitterUser];
}


- (NSString *)unblock:(NSString *)username
{
	if (!username) {
		return nil;
	}
	
	NSString *path = [NSString stringWithFormat:@"blocks/destroy/%@.%@", username, API_FORMAT];
    
    return [self _sendRequestWithMethod:HTTP_POST_METHOD path:path queryParameters:nil body:nil 
                            requestType:MGTwitterBlockDisableRequest
                           responseType:MGTwitterUser];
}


#pragma mark Help methods


- (NSString *)testService
{
	NSString *path = [NSString stringWithFormat:@"help/test.%@", API_FORMAT];
	
	return [self _sendRequestWithMethod:nil path:path queryParameters:nil body:nil 
                            requestType:MGTwitterAccountRequest
                           responseType:MGTwitterMiscellaneous];
}


- (NSString *)getDowntimeSchedule
{
	NSString *path = [NSString stringWithFormat:@"help/downtime_schedule.%@", API_FORMAT];
	
	return [self _sendRequestWithMethod:nil path:path queryParameters:nil body:nil 
                            requestType:MGTwitterAccountRequest
                           responseType:MGTwitterMiscellaneous];
}



#if YAJL_AVAILABLE

#pragma mark -
#pragma mark Search API methods
#pragma mark -


#pragma mark Search

- (NSString *)getSearchResultsForQuery:(NSString *)query
{
    return [self getSearchResultsForQuery:query sinceID:0 startingAtPage:0 count:0]; // zero means default
}


- (NSString *)getSearchResultsForQuery:(NSString *)query sinceID:(unsigned long)sinceID startingAtPage:(int)page count:(int)count
{
    return [self getSearchResultsForQuery:query sinceID:sinceID startingAtPage:0 count:0 geocode:nil]; // zero means default
}

- (NSString *)getSearchResultsForQuery:(NSString *)query sinceID:(unsigned long)sinceID startingAtPage:(int)page count:(int)count geocode:(NSString *)geocode
{
    NSString *path = [NSString stringWithFormat:@"search.%@", API_FORMAT];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
	if (query) {
		[params setObject:query forKey:@"q"];
	}
    if (sinceID > 0) {
        [params setObject:[NSString stringWithFormat:@"%u", sinceID] forKey:@"since_id"];
    }
	if (page > 0) {
        [params setObject:[NSString stringWithFormat:@"%d", page] forKey:@"page"];
    }
    if (count > 0) {
        [params setObject:[NSString stringWithFormat:@"%d", count] forKey:@"rpp"];
    }
    if (geocode) {
        [params setObject:geocode forKey:@"geocode"];
    }
	
	/*
	NOTE: These parameters are also available but not implemented yet:
	
		lang: restricts tweets to the given language, given by an ISO 639-1 code.

			Ex: http://search.twitter.com/search.atom?lang=en&q=devo

		geocode: returns tweets by users located within a given radius of the given latitude/longitude, where the user's
			location is taken from their Twitter profile. The parameter value is specified by "latitide,longitude,radius",
			where radius units must be specified as either "mi" (miles) or "km" (kilometers).

			Note that you cannot use the near operator via the API to geocode arbitrary locations; however you can use this
			geocode parameter to search near geocodes directly.

			Ex: http://search.twitter.com/search.atom?geocode=40.757929%2C-73.985506%2C25km
	*/

	
    return [self _sendRequestWithMethod:nil path:path queryParameters:params body:nil 
                            requestType:MGTwitterSearchRequest 
                           responseType:MGTwitterSearchResults];
}


- (NSString *)getCurrentTrends
{
    NSString *path = [NSString stringWithFormat:@"trends/current.%@", API_FORMAT];
    
    return [self _sendRequestWithMethod:nil path:path queryParameters:nil body:nil 
                            requestType:MGTwitterSearchCurrentTrendsRequest 
                           responseType:MGTwitterSearchResults];
}


#endif

@end
