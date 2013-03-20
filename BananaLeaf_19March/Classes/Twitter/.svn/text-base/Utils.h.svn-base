//

#import <Foundation/Foundation.h>
#import "ALToastView.h"

@class LabelCustomAlignment,DragView;
@interface Utils : NSObject 
{

}

+ (NSString*) stringFromDate: (NSDate*) date dateFormat: (NSString*) dateFormat;
+ (NSDate*) dateWithString: (NSString*) string dateFormat: (NSString*) dateFormat;

+ (NSString*) getPath:(NSString*)fName;
+ (NSArray*)readPlist;
+ (void)writeToPlistWithArr:(NSArray*)arrToWrite;

///Alerts
+ (void) showToast:(UIView *)parentView withText:(NSString *)text;
+ (void) showOKAlertWithTitle:(NSString*)aTitle message:(NSString*)aMsg;
+ (void) showOKAlertWithTitle:(NSString*)aTitle message:(NSString*)aMsg andDelegate:(id)alertDelegate;
+ (void) showOKCancelAlertWithTitle:(NSString*)aTitle message:(NSString*)aMsg andDelegate:(id)alertDelegate;


+ (UIImage *)generatePhotoThumbnail:(UIImage *)image ;
+ (UIImage *)scaleImage:(UIImage *)image maxWidth:(int) maxWidth maxHeight:(int) maxHeight;
@end

@interface ImageNavigationBar : UINavigationBar {
	
}

@end

// Label2.h
// (c) 2009 Ivan Misuno, www.cuberoom.biz

#import <UIKit/UIKit.h>

typedef enum
{
	VerticalAlignmentTop = 0, // default
	VerticalAlignmentMiddle,
	VerticalAlignmentBottom,
} VerticalAlignment;

@interface LabelCustomAlignment : UILabel
{
@private
	VerticalAlignment _verticalAlignment;
}

@property (nonatomic) VerticalAlignment verticalAlignment;

@end

@interface NSString (StringHelper)
- (CGFloat)RAD_textHeightForSystemFontOfSize:(CGFloat)size;
- (CGRect)RAD_frameForCellLabelWithSystemFontOfSize:(CGFloat)size;
- (UILabel *)RAD_newSizedCellLabelWithSystemFontOfSize:(CGFloat)size;
- (void)RAD_resizeLabel:(UILabel *)aLabel WithSystemFontOfSize:(CGFloat)size;
- (CGFloat)getTextWidthForBoldSystemFontOfSize:(CGFloat)size; 
@end
