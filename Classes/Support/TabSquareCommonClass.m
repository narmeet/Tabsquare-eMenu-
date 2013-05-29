
#import "TabSquareCommonClass.h"
#import "Reachability.h"
#import <QuartzCore/QuartzCore.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>



@implementation TabSquareCommonClass


+(void)setValueInUserDefault:(NSString *)_key value:(NSString *)_value
{
	if([_value isEqualToString:@""])
	{
		[[NSUserDefaults standardUserDefaults] removeObjectForKey:_key];
	}
	else
	{
		[[NSUserDefaults standardUserDefaults] setValue:_value forKey:_key];
	}
}


+(NSString *)getValueInUserDefault:(NSString *)_key
{
	NSString *_value=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:_key]];
	if([[NSUserDefaults standardUserDefaults] valueForKey:_key]==nil)
	{
		_value=@"";
	}
	return _value;
}





+(CGRect)deviceFrame
{
	CGRect screenBounds = [[UIScreen mainScreen] bounds];
	
	return screenBounds;
}


+(BOOL)isHDDevice
{
	BOOL _hd = FALSE;
	
	if([[UIScreen mainScreen] respondsToSelector:NSSelectorFromString(@"scale")])
	{
		if ([[UIScreen mainScreen] scale] < 1.1)
			_hd = FALSE;
		
		if ([[UIScreen mainScreen] scale] > 1.9)
			_hd = TRUE;
	}
	
	return _hd;
}



+(UIImage*)resizeImage:(UIImage*)image scaledToSize:(CGSize)size
{
	UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *destImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return destImage;
}


+(int)generateRandomNumber:(int)min_range max:(int)max_range
{
	int rand_number = 0;
	/* this wil generate a random number between 25 to 35 */
	rand_number = min_range + arc4random() % (max_range - min_range + 1);
	
	return rand_number;
}


+(UIImage *)imageFromView:(UIView *)view
{
	UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque , 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
	
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
	
    UIGraphicsEndImageContext();
	
    return img;
}


+(BOOL)internetAvailable
{
	Reachability *Internet = nil;
	Internet =[Reachability reachabilityForInternetConnection];
	if([Internet currentReachabilityStatus]==NotReachable)
	{
		return FALSE;
	}
	return TRUE;
}

+(CGRect)getBarFrame
{
	CGRect _frame;
    
	CGRect _size_frame = [TabSquareCommonClass deviceFrame];
	_frame = CGRectMake(0, 0, _size_frame.size.width, TOP_BAR_HEIGHT);
	
	return _frame;
	
}


+(UIView *)getSubView:(UIView *)on_view byTag:(int)view_tag
{
	UIView *_child_view;
	
	for(UIView *_sub_view in on_view.subviews)
	{
		if([_sub_view tag] == view_tag)
		{
			_child_view = _sub_view;
			break;
		}
	}
	
	return _child_view;
}


+(BOOL)createNewDirectory:(NSString *)_name
{
	BOOL status = FALSE;
	
	NSArray *path=NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask,YES);
	NSString *documentDirectory=[path objectAtIndex:0];
	
	NSString *folderPath = [NSString stringWithFormat:@"%@/%@", documentDirectory, _name];
	NSError *error;
	
	if (![[NSFileManager defaultManager] fileExistsAtPath:folderPath])
	{
		[[NSFileManager defaultManager] createDirectoryAtPath:folderPath withIntermediateDirectories:NO attributes:nil error:&error];
		status = TRUE;
	}
	
	return status;
}

+(void)createRecursiveDirs:(NSString *)path
{
	NSArray *array = [path componentsSeparatedByString:@"/"];
	
	for(int i = 0; i < [array count]; i++)
	{
		[TabSquareCommonClass createNewDirectory:[array objectAtIndex:i]];
	}
}



+(NSString *)directoryFullPath:(NSString *)_name
{
	NSArray *path=NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask,YES);
	NSString *documentDirectory=[path objectAtIndex:0];
    
	NSString *fullPath = [NSString stringWithFormat:@"%@/%@", documentDirectory, _name];
	
	return fullPath;
}

+(NSString *)documentDirectory
{
	NSArray *path=NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask,YES);
	NSString *documentDirectory = [NSString stringWithFormat:@"%@", [path objectAtIndex:0]];
    
	return documentDirectory;
}


+(BOOL)isExists:(NSString *)file;
{
	BOOL status = FALSE;
	
	NSString *full_path = [NSString stringWithFormat:@"%@", [TabSquareCommonClass directoryFullPath:file]];
	status = ([[NSFileManager defaultManager] fileExistsAtPath:full_path]);
	
	return status;
}


+(UIImage *)downloadImage:(NSString *)image_url
{
	UIImage *myImage=[[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:image_url]]];
	
	return myImage;
}


+(BOOL)cameraAvailable
{
	BOOL _status = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
	
	return _status;
}



+(BOOL)isValidUrl:(NSString *)_string
{
	BOOL _status = FALSE;
	
	NSURL *shortURL = [NSURL URLWithString:_string];
	
	if(shortURL != nil)
	{
		_status = TRUE;
	}
	
	
	return _status;
}

+(BOOL)compare:(NSString *)_prefix with:(NSString *)_name
{
	BOOL status = FALSE;
	
	int _length = [_prefix length];
	
	if(_length > [_name length])
		return status;
	
	NSString *to_compare = [_name substringWithRange:NSMakeRange(0, _length)];
	
	if([[_prefix lowercaseString] isEqualToString:[to_compare lowercaseString]])
		status = TRUE;
	
	return status;
}




+(void)playSoundFile:(NSString *)fileName repeat:(int)loop
{
	NSString *type = [fileName pathExtension];
	fileName = [NSString stringWithFormat:@"%@", [fileName stringByDeletingPathExtension]];
	
	NSString *soundFilePath = [[NSBundle mainBundle] pathForResource:fileName ofType:type];
	NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
	AVAudioPlayer *_soundPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileURL error:nil];
	[_soundPlayer setNumberOfLoops:loop];
	
	[_soundPlayer setCurrentTime:0.0f];
	[_soundPlayer prepareToPlay];
	[_soundPlayer play];
	
}


+(NSNumber *)longNumber
{
	return [NSNumber numberWithLongLong:[[NSDate date] timeIntervalSince1970] * 1000];
}


+(CGRect)setImageInFrame:(CGRect)frame1 :(UIImage*)gg
{
    CGSize kMaxImageViewSize = {.width = 129, .height = 82};
    UIImage *image=gg;
    UIImageView *imageView=[[UIImageView alloc]initWithImage:image];
    imageView.frame=frame1;
    CGSize imageSize = image.size;
    CGFloat aspectRatio = imageSize.width / imageSize.height;
    CGRect frame = imageView.frame;
    int originalWidth = frame.size.width;
    if (!(aspectRatio >= 0)){
        aspectRatio = 1;
    }
    if (kMaxImageViewSize.width / aspectRatio <= kMaxImageViewSize.height)
    {
        frame.size.width = kMaxImageViewSize.width;
        frame.size.height = frame.size.width / aspectRatio;
    }
    else
    {
        frame.size.height = kMaxImageViewSize.height;
        frame.size.width = frame.size.height * aspectRatio;
    }
    
    int spareWidth = originalWidth - frame.size.width;
    int spaceBuffer = spareWidth/2;
    
    frame.origin.x +=spaceBuffer;
    
    return frame;
}



+(NSString *)filterString:(NSString *)str pattern:(NSString *)pattern
{
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSString *category = [regex stringByReplacingMatchesInString:str options:0 range:NSMakeRange(0, [str length]) withTemplate:@""];
    category = [category stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    return category;
}


+(UIImage *)imageByApplyingAlpha:(CGFloat) alpha image:(UIImage *)image
{
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0.0f);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect area = CGRectMake(0, 0, image.size.width, image.size.height);
    
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -area.size.height);
    
    CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
    
    CGContextSetAlpha(ctx, alpha);
    
    CGContextDrawImage(ctx, area, image.CGImage);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end
