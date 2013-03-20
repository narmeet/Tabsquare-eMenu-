

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@class TabSquareMenuDetailController;
@class TabSquareOrderSummaryController;
@class TabMainDetailView;
@class TabMainCourseMenuListViewController;

@interface TabMainMenuDetailViewController : UIViewController<MBProgressHUDDelegate,UITextViewDelegate,UIScrollViewDelegate>
{
    MBProgressHUD *progressHud;
    int nextOrPrev;
    TabMainDetailView *currentdetailView;
    int currentIndex;
    NSString *currentCatId;
    NSString *currentSubId;
    bool currentMove;
    IBOutlet UIImageView* bggg;
    UIView *shadow;
    NSTimer* tt;
     NSString *orderScreenFlag;
}
@property(nonatomic,strong)NSString *orderScreenFlag;

@property(nonatomic)TabMainDetailView *detailView1;
@property(nonatomic)TabMainDetailView *detailView2;
@property(nonatomic,weak)IBOutlet UIScrollView *swipeDetailView;
@property(nonatomic,weak)IBOutlet UIView *detailView;
@property(nonatomic,weak)TabSquareOrderSummaryController *orderSummaryView;
@property(nonatomic,weak)TabSquareMenuDetailController *menuDetailView;
@property(nonatomic,weak)TabMainCourseMenuListViewController *dd;
@property(nonatomic,weak)NSMutableArray *custType;
@property(nonatomic,weak)NSString *IshideAddButton;
@property(nonatomic,weak)NSString *Viewtype;
@property(nonatomic,weak)IBOutlet UILabel *KDishName;
@property(nonatomic,weak)NSString *KDishCustType;
@property(nonatomic,weak)NSString *kDishId;
@property(nonatomic,weak)IBOutlet UILabel *KDishDescription;
@property(nonatomic,weak)IBOutlet UILabel *KDishRate;
@property(nonatomic,weak)IBOutlet UIImageView *KDishImage;
@property(nonatomic,weak)NSString *KDishCatId;
@property(nonatomic,weak)NSMutableArray *KDishCust;
@property(nonatomic,weak)NSString *selectedID;
@property(nonatomic,weak)NSMutableArray *DishName;
@property(nonatomic,weak)NSMutableArray *DishPrice;
@property(nonatomic,weak)NSMutableArray *DishDescription;
@property(nonatomic,weak)NSMutableArray *DishID;
@property(nonatomic,weak)NSMutableArray *DishCatId;
@property(nonatomic,weak)NSMutableArray *DishSubId;
@property(nonatomic,weak)NSMutableArray *DishImage;
@property(nonatomic,weak)NSMutableArray *DishCustomization;
@property(nonatomic,weak)IBOutlet UIButton *addButton;
@property(nonatomic,weak)IBOutlet UIButton *leftButton;
@property(nonatomic,weak)IBOutlet UIButton *rightButton;
@property(nonatomic,weak)IBOutlet UIImageView *popupBackground;
@property(nonatomic,weak)IBOutlet UIScrollView *descriptionScroll;


-(IBAction)closeClicked:(id)sender;
-(void)moveNextSubCat;
-(void)movePrevSubCat;
-(void)hideButtons;
-(void)showButtons;
-(void)showDetailView;
-(void)removeSwipeSubviews;
-(void)loadData:(TabMainDetailView*)detailview;


@end
