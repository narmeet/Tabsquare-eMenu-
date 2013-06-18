#import <UIKit/UIKit.h>
#import "RateView.h"
#import "MBProgressHUD.h"

@class FacebookViewC;
@class TabSquareMenuController;
@class TabSquareFeedbackLLViewController;

@interface TabFeedbackViewController : UIViewController<UITextViewDelegate,UITableViewDataSource,UITableViewDelegate,RateViewDelegate,MBProgressHUDDelegate,UITextViewDelegate>
{
    NSMutableArray *foodList;
    NSMutableArray *foodId;
    NSMutableArray *FeedbackQuestionList;
    NSMutableArray *FeedbackQuestionID;
    NSMutableArray *FeedbackQuestionRating;
    
    NSMutableArray *FoodRating;
    NSMutableArray *FoodQuantity;
    MBProgressHUD *progressHud;
    int TaskType;
    int i1;
    IBOutlet UIButton *skipBtn;
    IBOutlet UIButton *doneBtn;
    
    IBOutlet UIImageView* bgImage;
}
@property(nonatomic,strong) NSMutableArray *feedItemId;
@property(nonatomic,strong) UIViewController *menuView;
@property(nonatomic,strong)IBOutlet UITableView *foodView;
@property(nonatomic,strong)IBOutlet UITextView *commentView;
@property(nonatomic,strong)IBOutlet RateView *cleanRateView;
@property(nonatomic,strong)IBOutlet RateView *waitRateView;
@property(nonatomic,strong)IBOutlet RateView *menuRateView;
@property(nonatomic,strong)IBOutlet UITableView *FeedbackQuestionTable;
@property(nonatomic,strong)FacebookViewC	*objFacebookViewC;
@property(nonatomic,strong) TabSquareFeedbackLLViewController *favouriteView;
@property(nonatomic,strong)NSString *DishName;
@property(nonatomic,strong)NSString *DishRating;
@property (assign) float c_rate;
@property (assign) float w_rate;
@property (assign) float e_rate;

-(IBAction)skipClicked:(id)sender;
-(IBAction)doneClicked:(id)sender;
-(void)addFoodData;

@end
