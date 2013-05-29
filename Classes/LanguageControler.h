
#import <Foundation/Foundation.h>
#import "YLActivityIndicatorView.h"

@class ShareableData;

@interface LanguageControler : NSObject {
    
    NSMutableArray *dishCustomization;
    
    YLActivityIndicatorView* loading;
    UIView      *mainView;

}



+(LanguageControler *)languageController;
+(NSString *)activeText:(NSString *)text;
+(NSString *)activeLanguage:(NSString *)field;
-(void)UpdateCategoryData:(UIView *)_mainView;
-(void)setUpdatedCustomization:(NSMutableArray *)_dishCustomization;
-(NSMutableArray *)updatedDishCustomizationData;
-(void)changeLanguageInBackground;



@end
