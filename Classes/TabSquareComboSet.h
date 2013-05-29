
#import <UIKit/UIKit.h>
#import "CustomPageControl.h"
#import "TabSquareComboScroller.h"

@class TabMainCourseMenuListViewController;
@class ViewController;
@class TabSquareQuickOrder;

@interface TabSquareComboSet : UIViewController <UIScrollViewDelegate, iCarouselDataSource, iCarouselDelegate>{
    
    UIScrollView *scroller;
    UIImage      *firstImage;
    UIImage      *secondImage;
    UIView       *middle;
    UIControl    *first_section;
    UIControl    *second_section;
    UIImageView  *folder_arrow;
    UILabel      *combo_title;
    
    
    CGPoint      first_pnt;
    CGPoint      second_pnt;
    CGPoint      panStart;
    CGPoint      startPoint;
    CGRect       old_frame;
    UIButton     *selected_btn;
    
    int          combo_id;
    int          selected_tag;
    int          current_val;
    float        price;
    float        side_gap;
    float        last_x;
    BOOL         opened;
    BOOL         touched;
    BOOL         quickOrder;
    int          category_id;
    
    NSMutableDictionary *combo_data;
    NSMutableArray *group_dish;
    NSMutableArray *group_data_array;
    NSMutableArray *dishData;
    
    CustomPageControl *page_control;
    TabMainCourseMenuListViewController *root;
    ViewController *detailRoot;
    TabSquareQuickOrder *quickorder;
}



-(void)addDishButtons:(NSArray *)dishButtons;
-(void)dishIconPressed:(id)sender;
-(void)setRootController:(TabMainCourseMenuListViewController *)_root;
-(void)loadComboData;
-(void)setComboId:(int)_id categoryId:(int)_category_id;
-(void)setDetailRootController:(ViewController *)_detailRoot;
-(void)setQuickOrder;
-(void)setQuickorderController:(TabSquareQuickOrder *)_quick;

@end
