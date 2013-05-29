
#import <UIKit/UIKit.h>

@interface ComboSetDishIcon : UIButton {
    
    NSString    *dishTitle;
    NSString    *dishHeader;
    NSString    *dishType;
    NSString    *preSelected;
    NSString    *isSelected;
    NSString    *dishID;
    UIImage     *dishImage;
 
    NSString    *groupId;
    NSString    *groupDishItem;
    NSString    *maxSelection;
    NSString    *groupName;
    NSString    *selectionHeader;
    
    BOOL        gradient_status;

    
}


@property(nonatomic, retain) NSString *dishTitle;
@property(nonatomic, retain) NSString *dishHeader;
@property(nonatomic, retain) NSString *dishType;
@property(nonatomic, retain) NSString *preSelected;
@property(nonatomic, retain) NSString *isSelected;
@property(nonatomic, retain) NSString *dishID;
@property(nonatomic, retain) UIImage  *dishImage;
@property(nonatomic, retain) NSString *groupId;
@property(nonatomic, retain) NSString *groupDishItem;
@property(nonatomic, retain) NSString *maxSelection;
@property(nonatomic, retain) NSString *groupName;
@property(nonatomic, retain) NSString *selectionHeader;


-(void)customizeIcon;



@end
