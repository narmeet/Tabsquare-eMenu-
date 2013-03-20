
#import <Foundation/Foundation.h>


#define DEV_VERSION			@"dev_version"
#define TOP_BAR_HEIGHT      44
#define TAB_BAR_HEIGHT      49.0
#define PHOTO_LIBRARY		2
#define CAMERA				3


@interface TabSquareCommonClass : NSObject {
    
}


+(void)setValueInUserDefault:(NSString *)_key value:(NSString *)_value;
+(NSString *)getValueInUserDefault:(NSString *)_key;
+(CGRect)deviceFrame;
+(BOOL)isHDDevice;
+(UIImage*)resizeImage:(UIImage*)image scaledToSize:(CGSize)size;
+(int)generateRandomNumber:(int)min_range max:(int)max_range;
+(UIImage *)imageFromView:(UIView *)view;
+(BOOL)internetAvailable;
+(CGRect)getBarFrame;
+(UIView *)getSubView:(UIView *)on_view byTag:(int)view_tag;
+(BOOL)createNewDirectory:(NSString *)_name;
+(NSString *)directoryFullPath:(NSString *)_name;
+(UIImage *)downloadImage:(NSString *)image_url;
+(BOOL)cameraAvailable;
+(BOOL)isValidUrl:(NSString *)_string;
+(BOOL)compare:(NSString *)_prefix with:(NSString *)_name;
+(NSNumber*)longNumber;
+(BOOL)isExists:(NSString *)file;
+(NSString *)documentDirectory;
+(void)createRecursiveDirs:(NSString *)path;
+(void)playSoundFile:(NSString *)fileName repeat:(int)loop;
+(CGRect)setImageInFrame:(CGRect)frame1 :(UIImage*)gg;
+(NSString *)filterString:(NSString *)str pattern:(NSString *)pattern;
+(UIImage *)imageByApplyingAlpha:(CGFloat) alpha image:(UIImage *)image;

@end
