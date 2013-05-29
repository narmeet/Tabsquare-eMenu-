
#import "LanguageControler.h"
#import "ShareableData.h"
#import "TabSquareDBFile.h"
#import <QuartzCore/QuartzCore.h>


@implementation LanguageControler


static LanguageControler *_language = nil;

/*=============Singletone Class ==============*/
+(LanguageControler *)languageController
{
	if (_language == nil) {
        _language = [[LanguageControler alloc] init];
    }
    return _language;
}


/*============Convert column name according to current active language===============*/
+(NSString *)activeLanguage:(NSString *)field
{
    NSString *current_language = [NSString stringWithFormat:@"%@", [ShareableData sharedInstance].currentLanguage];
    NSString *active_column = @"";
    
    if([current_language isEqualToString:ENGLISH])
        active_column = [NSString stringWithFormat:@"%@", field];
    else if([current_language isEqualToString:CHINESE])
        active_column = [NSString stringWithFormat:@"ch_%@", field];
    else if([current_language isEqualToString:JAPANESE])
        active_column = [NSString stringWithFormat:@"ja_%@", field];
    else if([current_language isEqualToString:KOREAN])
        active_column = [NSString stringWithFormat:@"ko_%@", field];
    else if([current_language isEqualToString:INDONESIAN])
        active_column = [NSString stringWithFormat:@"in_%@", field];
    else if([current_language isEqualToString:FRENCH])
        active_column = [NSString stringWithFormat:@"fr_%@", field];
        
    return active_column;
}

/*==============Finding Static Text of Currently Active Language=================*/
+(NSString *)activeText:(NSString *)text
{
    NSString *current_language = [NSString stringWithFormat:@"%@", [ShareableData sharedInstance].currentLanguage];
    NSString *active_text = @"";
    
    if([current_language isEqualToString:ENGLISH])
        active_text = [NSString stringWithFormat:@"en_%@_", text];
    else if([current_language isEqualToString:CHINESE])
        active_text = [NSString stringWithFormat:@"ch_%@_", text];
    else if([current_language isEqualToString:JAPANESE])
        active_text = [NSString stringWithFormat:@"ja_%@_", text];
    else if([current_language isEqualToString:KOREAN])
        active_text = [NSString stringWithFormat:@"ko_%@_", text];
    else if([current_language isEqualToString:INDONESIAN])
        active_text = [NSString stringWithFormat:@"in_%@_", text];
    else if([current_language isEqualToString:FRENCH])
        active_text = [NSString stringWithFormat:@"fr_%@_", text];
    
    NSMutableArray *texts_array = [[NSUserDefaults standardUserDefaults] objectForKey:STATIC_TEXTS];
    NSString *final = @"";

    for(int i = 0; i < [texts_array count]; i++) {
        NSString *text = [NSString stringWithFormat:@"%@", texts_array[i]];
        
        if([LanguageControler compare:active_text with:text]) {
            final = [NSString stringWithFormat:@"%@", [LanguageControler filterString:text pattern:active_text]];
            break;
        }
        else {
            continue;
        }
    }
    
    if([final length] == 0) {
        final = [NSString stringWithFormat:@"%@", text];
    }
        
    return final;
}

+(BOOL)compare:(NSString *)_suffix with:(NSString *)_id_text
{
	BOOL status = FALSE;
	
	int _length = [_suffix length];
	
	if(_length > [_id_text length])
		return status;
	
	NSString *to_compare = [_id_text substringWithRange:NSMakeRange(0, _length)];
	
	if([[_suffix lowercaseString] isEqualToString:[to_compare lowercaseString]])
		status = TRUE;
	
	return status;
}

+(NSString *)filterString:(NSString *)str pattern:(NSString *)pattern
{
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSString *category = [regex stringByReplacingMatchesInString:str options:0 range:NSMakeRange(0, [str length]) withTemplate:@""];
    category = [category stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    return category;
}

/*=================Updating category ad subcategory data according to multilanguage================*/
-(void)UpdateCategoryData:(UIView *)_mainView
{
    mainView = _mainView;
    
    /*======================Fade In Out Animation======================*/
    [self loadingAnimation];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH
                                             , 0), ^{
        [self getUpdatedData];
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            [loading stopAnimating];
            [loading removeFromSuperview];
            [self sendLanguageChangeBroadcast];
        });
        
    });

    
}



-(void)loadingAnimation
{
    UILabel *status = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320.0, 56.0)];
    [status setFont:[UIFont boldSystemFontOfSize:25.0]];
    [status setText:[LanguageControler activeText:@"Updating Menu Language"]];
    [status setBackgroundColor:[UIColor colorWithRed:5.0/255.0 green:5.0/255.0 blue:5.0/255.0 alpha:0.7]];
    [status.layer setBorderWidth:1.8];
    [status.layer setBorderColor:[UIColor blackColor].CGColor];
    [status.layer setCornerRadius:8.0];
    [status setTextAlignment:NSTextAlignmentCenter];
    [status setTextColor:[UIColor whiteColor]];
    [status setCenter:[mainView center]];
    [mainView addSubview:status];
    [status setAlpha:0.7];
    
    [UIView transitionWithView:mainView duration:0.4 options:UIViewAnimationOptionTransitionNone animations:^(void) {
        [mainView setAlpha:0.7];
        [status setAlpha:1.0];
        
        
    } completion:^(BOOL finished){
     
        [UIView transitionWithView:mainView duration:0.6 options:UIViewAnimationOptionTransitionNone animations:^(void) {
            [mainView setAlpha:1.0];
            [status setAlpha:0.5];
            [status removeFromSuperview];

        } completion:^(BOOL finished){
        }];

    
    }];
     

}

/*============Get Updated Data===========*/
-(void)getUpdatedData
{
    [[ShareableData sharedInstance].categoryList removeAllObjects];
    [[ShareableData sharedInstance].categoryIdList removeAllObjects];
    [[ShareableData sharedInstance].SubCategoryList removeAllObjects];
    
    NSMutableArray *resultFromPost = [[TabSquareDBFile sharedDatabase]getCategoryData];
    
    for(int i=0;i<[resultFromPost count];i++)
    {
        NSMutableDictionary *dataitem=resultFromPost[i];
        [[ShareableData sharedInstance].categoryList addObject:[NSString stringWithFormat:@"%@",dataitem[@"name"]]];
        [[ShareableData sharedInstance].categoryIdList addObject:[NSString stringWithFormat:@"%@",dataitem[@"id"]]];
        
        NSMutableArray *subCategoryItem=[[TabSquareDBFile sharedDatabase]getSubCategoryData:[ShareableData sharedInstance].categoryIdList[i]];
        [[ShareableData sharedInstance].SubCategoryList addObject:subCategoryItem];
    }

}

/*===========Send broadcast to all classes, when language need to be updated=============*/
-(void)sendLanguageChangeBroadcast
{
    [[NSNotificationCenter defaultCenter]
     postNotificationName:LANGUAGE_CHANGED
     object:self];

}

/*=======Storing the updated Customization array for global access*/
-(void)setUpdatedCustomization:(NSMutableArray *)_dishCustomization
{
    dishCustomization = _dishCustomization;
}

-(NSMutableArray *)updatedDishCustomizationData
{
    return dishCustomization;
}


-(void)changeLanguageInBackground
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH
                                             , 0), ^{
        [self getUpdatedData];
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            [self sendLanguageChangeBroadcast];
        });
        
    });

}






@end
