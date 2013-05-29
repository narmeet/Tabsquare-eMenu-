

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "TabSquareHome2Controller.h"
#import "TabSquareMenuController.h"

@interface TabSquareHomeController : UIViewController<MBProgressHUDDelegate>
{
    MBProgressHUD *hud ;
    NSString *currentDate;
}
@property(nonatomic,strong)IBOutlet UIImageView *homeView1;
@property(nonatomic,strong)IBOutlet UIImageView *homeView2;
@property(nonatomic,strong)IBOutlet UIImageView *backView;
@property(nonatomic,strong)NSMutableArray *categoryList;
@property(nonatomic,strong)NSMutableArray *categoryIdList;
@property (strong, nonatomic) TabSquareHome2Controller *homeview;
@property(nonatomic,strong)TabSquareMenuController *menu;


-(IBAction)tapClicked:(id)sender;
-(IBAction)doorOpenClick:(id)sender;
@end

