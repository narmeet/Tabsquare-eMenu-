//


#import "Utils.h"
//#import "GSNSDataExtensions.h"
#import "ALToastView.h"

@implementation Utils

#pragma mark -

#pragma mark Date Conversion
+ (NSString*) stringFromDate: (NSDate*) date dateFormat: (NSString*) dateFormat
{    
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	
	[dateFormatter setDateFormat:dateFormat];
	
	if (!date)
		date = [NSDate date];
	return [dateFormatter stringFromDate:date];    
}

+ (NSDate*) dateWithString: (NSString*) string dateFormat: (NSString*) dateFormat
{
	if (string)
	{
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		
		[dateFormatter setDateFormat:dateFormat];
		return    [dateFormatter dateFromString:string];
	}
	return nil;
}

#pragma mark - Image Resize 
+ (UIImage *)scaleImage:(UIImage *)image maxWidth:(int) maxWidth maxHeight:(int) maxHeight
{
    CGImageRef imgRef = image.CGImage;
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
	
    if (width <= maxWidth && height <= maxHeight)
	{
		return image;
	}
	
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
	
    if (width > maxWidth || height > maxHeight)
	{
		CGFloat ratio = width/height;
		
		if (ratio > 1)
		{
			bounds.size.width = maxWidth;
			bounds.size.height = bounds.size.width / ratio;
		}
		else
		{
			bounds.size.height = maxHeight;
			bounds.size.width = bounds.size.height * ratio;
		}
	}
	
    CGFloat scaleRatio = bounds.size.width / width;
    UIGraphicsBeginImageContext(bounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextScaleCTM(context, scaleRatio, -scaleRatio);
    CGContextTranslateCTM(context, 0, -height);
    CGContextConcatCTM(context, transform);
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
	
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
	
    return imageCopy;
	
}


#pragma mark - Get Path 

+ (NSString*) getPath:(NSString*)fName
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths lastObject];
	
	documentsDirectory = [documentsDirectory stringByAppendingPathComponent:@"BackData"];
	
	NSError *error;
	[[NSFileManager defaultManager] createDirectoryAtPath:documentsDirectory withIntermediateDirectories:YES attributes:nil error:&error];
	
	documentsDirectory = [documentsDirectory stringByAppendingPathComponent:fName];
	
	return documentsDirectory;
}

#pragma mark ReadPlist
+ (NSArray*)readPlist
{
	NSString*    error;
	NSPropertyListFormat format;
	
	NSString* path =[self getPath:@"DataFile"];    
	NSData* data = [NSData dataWithContentsOfFile:path];    
	NSArray *dataProject = (NSArray*)[NSPropertyListSerialization propertyListFromData:data mutabilityOption:NSPropertyListImmutable format:&format errorDescription:&error];
	
	return dataProject;
}

#pragma mark WritePlist
+ (void)writeToPlistWithArr:(NSArray*)arrToWrite
{	
	NSString* path = [self getPath:@"DataFile"];
	NSString* errorStr = nil;
	NSData* data = [NSPropertyListSerialization dataFromPropertyList:arrToWrite
															  format: NSPropertyListXMLFormat_v1_0
													errorDescription: &errorStr];
	
	[data writeToFile:path atomically:YES];
}




+ (void) showToast:(UIView *)parentView withText:(NSString *)text
{
        [ALToastView toastInView:parentView withText:text];
}

+ (void) showOKAlertWithTitle:(NSString*)aTitle message:(NSString*)aMsg
{
	UIAlertView	*aAlert = [[UIAlertView alloc] initWithTitle:aTitle message:aMsg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[aAlert show];
}

+ (void) showOKCancelAlertWithTitle:(NSString*)aTitle message:(NSString*)aMsg andDelegate:(id)alertDelegate;
{
	UIAlertView	*aAlert = [[UIAlertView alloc] initWithTitle:aTitle message:aMsg delegate:alertDelegate cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
	[aAlert show];
}

+ (void) showOKAlertWithTitle:(NSString*)aTitle message:(NSString*)aMsg andDelegate:(id)alertDelegate
{
	UIAlertView	*aAlert = [[UIAlertView alloc] initWithTitle:aTitle message:aMsg delegate:alertDelegate cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[aAlert show];
}





#pragma mark -


#pragma mark - image picker
+ (UIImage *)generatePhotoThumbnail:(UIImage *)image 
{
	//int kMaxResolution = 320; 
	
	CGImageRef imgRef = image.CGImage; 
	
	CGFloat width = CGImageGetWidth(imgRef); 
	CGFloat height = CGImageGetHeight(imgRef); 
	
	CGAffineTransform transform = CGAffineTransformIdentity; 
	CGRect bounds = CGRectMake(0, 0, width, height); 
	/*if (width > kMaxResolution || height > kMaxResolution) 
	 { 
	 CGFloat ratio = width/height; 
	 if (ratio > 1)
	 { 
	 bounds.size.width = kMaxResolution; 
	 bounds.size.height = bounds.size.width / ratio; 
	 } 
	 else
	 { 
	 bounds.size.height = kMaxResolution; 
	 bounds.size.width = bounds.size.height * ratio; 
	 } 
	 } */
	
	CGFloat scaleRatio = bounds.size.width / width; 
	CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));  
	CGFloat boundHeight;                       
	UIImageOrientation orient = image.imageOrientation;                         
	switch(orient)
	{ 
		case UIImageOrientationUp: //EXIF = 1 
			transform = CGAffineTransformIdentity; 
			break;
			
		case UIImageOrientationUpMirrored: //EXIF = 2  
			transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0); 
			transform = CGAffineTransformScale(transform, -1.0, 1.0); 
			break; 
			
		case UIImageOrientationDown: //EXIF = 3 
			transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height); 
			transform = CGAffineTransformRotate(transform, M_PI); 
			break; 
			
		case UIImageOrientationDownMirrored: //EXIF = 4 
			transform = CGAffineTransformMakeTranslation(0.0, imageSize.height); 
			transform = CGAffineTransformScale(transform, 1.0, -1.0); 
			break; 
			
		case UIImageOrientationLeftMirrored: //EXIF = 5 
			boundHeight = bounds.size.height; 
			bounds.size.height = bounds.size.width; 
			bounds.size.width = boundHeight; 
			transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width); 
			transform = CGAffineTransformScale(transform, -1.0, 1.0); 
			transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0); 
			break; 
			
		case UIImageOrientationLeft: //EXIF = 6 
			boundHeight = bounds.size.height; 
			bounds.size.height = bounds.size.width; 
			bounds.size.width = boundHeight; 
			transform = CGAffineTransformMakeTranslation(0.0, imageSize.width); 
			transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0); 
			break; 
			
		case UIImageOrientationRightMirrored: //EXIF = 7 
			boundHeight = bounds.size.height; 
			bounds.size.height = bounds.size.width; 
			bounds.size.width = boundHeight; 
			transform = CGAffineTransformMakeScale(-1.0, 1.0); 
			transform = CGAffineTransformRotate(transform, M_PI / 2.0); 
			break; 
			
		case UIImageOrientationRight: //EXIF = 8 
			boundHeight = bounds.size.height; 
			bounds.size.height = bounds.size.width; 
			bounds.size.width = boundHeight; 
			transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0); 
			transform = CGAffineTransformRotate(transform, M_PI / 2.0); 
			break; 
		default: 
			[NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"]; 
			break;
	} 
	
	UIGraphicsBeginImageContext(bounds.size); 
	
	CGContextRef context = UIGraphicsGetCurrentContext(); 
	
	if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft)
	{ 
		CGContextScaleCTM(context, -scaleRatio, scaleRatio); 
		CGContextTranslateCTM(context, -height, 0); 
	} 
	else
	{ 
		CGContextScaleCTM(context, scaleRatio, -scaleRatio); 
		CGContextTranslateCTM(context, 0, -height); 
	} 
	
	CGContextConcatCTM(context, transform); 
	
	CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef); 
	UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext(); 
	UIGraphicsEndImageContext(); 
	
	return imageCopy;
	
}

@end

@implementation ImageNavigationBar

- (void) drawRect:(CGRect)rect
{
	UIImage *tabImage=[UIImage imageNamed:@"docToolbar.png"];
	[tabImage drawAtPoint:CGPointMake(0, 0)];
}
@end

#pragma mark LabelCustomAlignment

///#import "LabelCustomAlignment.h"

@implementation LabelCustomAlignment

-(id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (!self) return nil;
	
	_verticalAlignment = VerticalAlignmentTop;
	
    return self;
}


-(VerticalAlignment) verticalAlignment
{
	return _verticalAlignment;
}
-(void) setVerticalAlignment:(VerticalAlignment)value
{
	_verticalAlignment = value;
	[self setNeedsDisplay];
}

// align text block according to vertical alignment settings
-(CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines
{
	CGRect rect = [super textRectForBounds:bounds limitedToNumberOfLines:numberOfLines];
	CGRect result;
	switch (_verticalAlignment)
	{
		case VerticalAlignmentTop:
			result = CGRectMake(bounds.origin.x, bounds.origin.y, rect.size.width, rect.size.height);
			break;
		case VerticalAlignmentMiddle:
			result = CGRectMake(bounds.origin.x, bounds.origin.y + (bounds.size.height - rect.size.height) / 2, rect.size.width, rect.size.height);
			break;
		case VerticalAlignmentBottom:
			result = CGRectMake(bounds.origin.x, bounds.origin.y + (bounds.size.height - rect.size.height), rect.size.width, rect.size.height);
			break;
		default:
			result = bounds;
			break;
	}
	return result;
}

-(void)drawTextInRect:(CGRect)rect
{
	CGRect r = [self textRectForBounds:rect limitedToNumberOfLines:self.numberOfLines];
	[super drawTextInRect:r];
}


//self.navigationController.navigationBar.layer.contents = (id)[UIImage imageNamed:@"top_bar_landscape.png"].CGImage;
/*
 @implementation UINavigationBar (UINavigationBarCategory)
 - (void)drawRect:(CGRect)rect 
 {
 UIImage *backgroundImage = [UIImage imageNamed: @"docToolbar.png"];
 CGContextDrawImage(UIGraphicsGetCurrentContext(),CGRectMake(0, 0, self.frame.size.width, self.frame.size.height),backgroundImage.CGImage);
 //kCGRect aRect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
 //[backgroundImage drawAtPoint:CGPointMake(0, 0)];
 //[backgroundImage drawInRect:aRect];
 }
 @end
 */

@end

#pragma mark NSStringCategory

@implementation NSString (StringHelper)

#pragma mark Methods to determine the height of a string for resizeable table cells

- (CGFloat)getTextWidthForBoldSystemFontOfSize:(CGFloat)size 
{
	//Calculate the expected size based on the font and linebreak mode of your label
	CGFloat maxWidth = [UIScreen mainScreen].bounds.size.width;
	CGFloat maxHeight = 30;
	CGSize maximumLabelSize = CGSizeMake(maxWidth,maxHeight);
	
	CGSize expectedLabelSize = [self sizeWithFont:[UIFont boldSystemFontOfSize:size] 
								constrainedToSize:maximumLabelSize 
									lineBreakMode:UILineBreakModeWordWrap]; 
	
	return expectedLabelSize.width;
}

- (CGFloat)RAD_textHeightForSystemFontOfSize:(CGFloat)size {
	//Calculate the expected size based on the font and linebreak mode of your label
	CGFloat maxWidth = [UIScreen mainScreen].bounds.size.width - 50;
	CGFloat maxHeight = 99999;
	CGSize maximumLabelSize = CGSizeMake(maxWidth,maxHeight);
	
	CGSize expectedLabelSize = [self sizeWithFont:[UIFont systemFontOfSize:size] 
								constrainedToSize:maximumLabelSize 
									lineBreakMode:UILineBreakModeWordWrap]; 
	
	return expectedLabelSize.height;
}

- (CGFloat)RAD_textHeightForBoldSystemFontOfSize:(CGFloat)size {
	//Calculate the expected size based on the font and linebreak mode of your label
	CGFloat maxWidth = [UIScreen mainScreen].bounds.size.width - 50;
	CGFloat maxHeight = 9999;
	CGSize maximumLabelSize = CGSizeMake(maxWidth,maxHeight);
	
	CGSize expectedLabelSize = [self sizeWithFont:[UIFont boldSystemFontOfSize:size] 
								constrainedToSize:maximumLabelSize 
									lineBreakMode:UILineBreakModeWordWrap]; 
	
	return expectedLabelSize.height;
}

- (CGRect)RAD_frameForCellLabelWithSystemFontOfSize:(CGFloat)size {
	CGFloat width = [UIScreen mainScreen].bounds.size.width - 40;// - 50;
	CGFloat height = [self RAD_textHeightForSystemFontOfSize:size] + 10.0;
	///return CGRectMake(10.0f, 10.0f, width, height);
	return CGRectMake(50.0f, 10.0f, width, height);
}

- (void)RAD_resizeLabel:(UILabel *)aLabel WithSystemFontOfSize:(CGFloat)size {
	aLabel.frame = [self RAD_frameForCellLabelWithSystemFontOfSize:size];
	aLabel.text = self;
	[aLabel sizeToFit];
}

- (UILabel *)RAD_newSizedCellLabelWithSystemFontOfSize:(CGFloat)size {
	UILabel *cellLabel = [[UILabel alloc] initWithFrame:[self RAD_frameForCellLabelWithSystemFontOfSize:size]];
	cellLabel.textColor = [UIColor blackColor];
	cellLabel.backgroundColor = [UIColor clearColor];
	cellLabel.textAlignment = UITextAlignmentLeft;
	cellLabel.font = [UIFont systemFontOfSize:size];
	///cellLabel.adjustsFontSizeToFitWidth = YES;
	
	cellLabel.text = self; 
	cellLabel.numberOfLines = 0; 
	[cellLabel sizeToFit];
	
	return cellLabel;
}


@end


