//
//  TabSquareMenuController.h
//  TabSquareMenu
//
//  Created by Nikhil Kumar on 7/5/12.
//  Copyright (c) 2012 Trendsetterz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "TabSquareQuickOrder.h"
#import "TabSquareFlurryTracking.h"
#import "CustomBadge.h"
#import "FBDialog.h"
#import "FBLoginDialog.h"
#import "FBRequest.h"
#include "ProgressBar.h"


@class TabSquareFavouriteViewController;
@class TabMainCourseMenuListViewController;
@class TabSquareBeerController;
@class TabSquareOrderSummaryController;
@class TabSquareSoupViewController;
@class TabSearchViewController;
@class TabFeedbackViewController;
@class TabSquareHelpController;
@class TabSquareLastOrderedViewController;
@class TabSquareFriendListController;
@class TabTwitterFollowerListControllerViewController;
@class TabSquareTableManagement;
@class EditOrder;


@interface TabSquareMenuController : UIViewController<MBProgressHUDDelegate,ProgressBarDelegate,UIScrollViewDelegate,UIAlertViewDelegate, UITableViewDelegate, UITableViewDataSource,FBLoginDialogDelegate>
{
    
    FBLoginDialog* _fbDialog;
    
    TabMainCourseMenuListViewController     *menulistView;
    TabMainCourseMenuListViewController     *menulistView1;
    TabMainCourseMenuListViewController     *menulistView2;
     TabMainCourseMenuListViewController    *menulistView3;
    TabSquareHelpController                 *helpView;
    TabSquareBeerController                 *beveragesBeerView;
    TabSquareBeerController                 *beveragesBeerView1;    
    TabSquareBeerController                 *beveragesBeerView2;  
    TabSquareLastOrderedViewController      *lastOrderedview;
    TabSquareFriendListController           *fbFriendview;
    TabTwitterFollowerListControllerViewController *twitFriendview;
    int i1;
    EditOrder                       *editOrderView;
    TabSquareOrderSummaryController *orderSummaryView;
    TabSearchViewController         *searchView;
    TabFeedbackViewController       *feedbackView;
    TabSquareSoupViewController     *soupView;
    int         categorytag;
    NSString    *subId;
    int         catIndex;
    int         TaskType;
    float prevX;
    int initLoading;
    UISwipeGestureRecognizerDirection swipeDirection;
    MBProgressHUD *progressHud;
    ProgressBar *progressBar;
    UIButton *subbtn;
    CustomBadge* summaryTotalBadge;
    NSTimer * tt;
    UIImageView* subCatbg;
    
    //int HightlightedCategoryMenu;
    //int HightlightedSubCategoryMenu;
    
    int currentSubTag;
    UIButton *currentSelected;
    int hasLoaded;
    int alertTag;
    
    CGPoint KinaraCurrentScrollPositionPoint;
    BOOL KinaraCategoryBtnClick;
    CGPoint KinaraOriginalScrollPositionPoint;
    IBOutlet UIView *overviewMenuView;
    CGPoint KinaraCurrentScrollPositionPointSub;
    BOOL KinaraSubcategoryBtnClick;
    CGPoint KinaraOriginalScrollPositionPointSub;
    
    int KinaraSelectedCategoryID;
    int KinaraSelectedSubCategoryID;
    bool flag;
    int KinaraNumberOfButton;
    NSString* isRecon;
    
    UIButton        *selectedButton;
    UIView          *mainMenu;
    UITableView     *menuTable;
    NSMutableArray  *firstImages;
    
    NSMutableArray  *sub_cat_buttons;
    UIScrollView    *subcatScroller;
    UIButton        *prev_btn;
    UIButton        *temp_btn;
    
    NSString        *fontName;
    UIColor         *fontColor;
    float           fontSize;
    
    
    int             main_cat_id;
    BOOL            favorite_status;
    
    BOOL            searchStatus;
    BOOL            searchOpened;
    NSString        *searhKeyword;
    
    BOOL            bestsellers;
    BOOL            bestsellersOpened;
    
    /*=========Performance improvement==========*/
    UIImage *cellImage;

    CGSize thumbanilSize;
    NSMutableArray *tempCategoryList;
    
    NSString *backupActiveLanguage;
    NSString *prevSubId;

    id mparent;///for Unhiding the orderUmarry & back button
}
@property(nonatomic,strong)id mparent;
@property(nonatomic,strong) UIScrollView    *subcatScroller;
@property(nonatomic,strong) UIImageView* subCatbg;


@property(nonatomic,strong) TabMainCourseMenuListViewController *menulistView1;
@property(strong,atomic) UIButton *KinaraSelectorCategory;
@property(strong,atomic) UIButton *KinaraSelectorSubCategory;
@property(strong,atomic) UIScrollView *KinaraCategory;
@property(strong,atomic) UIScrollView *KinaraSubCategory;
@property(strong,atomic) NSMutableArray *KinaraSubategoryNameList;
@property(strong,atomic) NSString *KinaraSelectedCategoryName;
@property(strong,atomic) NSString *KinaraSelectedSubCategoryName;
@property(nonatomic,strong) TabSquareFavouriteViewController *favouriteView;
@property(nonatomic,strong)UIImageView *helpOverlay;
@property(nonatomic,strong)NSString *swipeIndicator;
@property(nonatomic,strong)IBOutlet UIScrollView *swipeView;
@property(nonatomic,strong)IBOutlet UIImageView *logoImage;
@property(nonatomic,strong)NSString *selectedCategoryID;
@property(nonatomic,strong)NSMutableDictionary *menuCategory;
@property(nonatomic,strong)NSString* isRecon;

@property(nonatomic,strong)NSMutableArray *categoryList;
@property(nonatomic,strong)NSMutableArray *categoryIdList;
@property(nonatomic,strong)NSMutableArray *subcategoryList;
@property(nonatomic,strong)NSMutableArray *subcategoryIdList;
@property(nonatomic,strong)NSMutableArray *subcategoryDisplayList;
@property(nonatomic,strong)IBOutlet UIImageView *maincourseImage;
@property(nonatomic,strong)IBOutlet UIImageView *backgroundImage;
@property(nonatomic,strong)TabSquareOrderSummaryController *orderSummaryView;
@property(nonatomic,strong)TabSquareQuickOrder *menuQuick;
@property(nonatomic,strong)TabSquareTableManagement *assignTable;

@property(nonatomic,strong)IBOutlet UIButton *search;
@property(nonatomic,strong)IBOutlet UIButton *feedback;
@property(nonatomic,strong)IBOutlet UIButton *favourite;
@property(nonatomic,strong)IBOutlet UIButton *help;
@property(nonatomic,strong)IBOutlet UIButton *flagButton;
@property(nonatomic,strong)IBOutlet UIButton *OrderSummaryButton;
@property(nonatomic,strong)IBOutlet UIButton *overviewMenuButton;
@property(nonatomic,strong)IBOutlet UIButton *KinaraLogo;
@property(nonatomic,strong)IBOutlet UIButton *FeedbackDisabled;
@property(nonatomic,strong)UIButton *btnn;


-(IBAction)feedbackDisabledClicked:(id)sender;
-(IBAction)orderSummaryClicked:(id)sender;
-(IBAction)searchClicked:(id)sender;
-(IBAction)feedbackClicked:(id)sender;
-(IBAction)favouriteClicked:(id)sender;
-(IBAction)helpClicked:(id)sender;
//-(void)setCategoryClicked:(int)tag;
-(void)scrollsubcategoryClicked:(int)subTag;
-(void)scrollcategoryClicked:(int)catTag;
-(IBAction)KinaraClicked:(id)sender;
-(void)showMenuHighlight;
-(void)KinarasetCategoryClicked:(int)tag;
-(void)KinarasetSubCategoryClicked:(int)tag;
-(IBAction)KinaraSubCategoryClicked2:(int)sender;
-(IBAction)KinaraCategoryClicked2:(int)sender;
-(IBAction)KinaraCategoryClicked:(id)sender;
-(IBAction)overviewBtnClicked:(id)sender;
-(IBAction)displayOverview;
-(void)clearSubViews;
-(void)returnToEdit;
-(void)addTable;
-(void)badgeRefresh;
-(NSString *)filterString:(NSString *)str pattern:(NSString *)pattern;
-(void)alphaAnimation:(UIView *)view dutarion:(CGFloat)time;

-(void)hideTheScrollerAndSubCatBgOnMenuController;
-(void)UnhideTheScrollerAndSubCatBgOnMenuController;
-(void)setSearchOn:(NSString *)keyword;
-(IBAction)flagPressed:(id)sender;
-(void)overviewBtnClicked2:(id) sender;
-(void)setParent:(id)sender;

@end
