//
//  ViewController.h
//  PagedFlowView
//
//  Created by manoj on 5/2/13.
//  Copyright (c) 2012 geeklu.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PagedFlowView.h"
#import "MBProgressHUD.h"
#import "Global.h"
#import "TabSquareMenuController.h"

@class TabSquareMenuDetailController;
@class TabSquareOrderSummaryController;
@class TabMainDetailView;
@class TabMainCourseMenuListViewController;

@interface ViewController : UIViewController<PagedFlowViewDelegate,PagedFlowViewDataSource,MBProgressHUDDelegate,UITextViewDelegate,UIScrollViewDelegate>{
    
    
    id mParent;
    IBOutlet UIView *bgBlackView;
    
    MBProgressHUD *progressHud;
    int nextOrPrev;
  //  TabMainDetailView *currentdetailView;
    int currentIndex,selectedIndex;
    NSString *currentCatId;
    NSString *currentSubId;
    bool currentMove;
    IBOutlet UIImageView* bggg;
    NSTimer* tt;
    UIImageView *imageView;
    NSString *orderScreenFlag;
    IBOutlet UIImageView* bgImage;
    
    UIButton *curr_btn;
    CGRect cur_frm;
    
}
@property (nonatomic) id mParent;

@property (nonatomic, retain) IBOutlet PagedFlowView *hFlowView;
@property (nonatomic, retain) IBOutlet PagedFlowView *vFlowView;
@property (nonatomic, retain) IBOutlet UIPageControl *hPageControl;
@property (nonatomic, retain) IBOutlet UIImageView *imageView;

- (IBAction)pageControlValueDidChange:(id)sender;

@property (nonatomic, retain) UIView *bgBlackView;

@property(nonatomic,strong)NSString *orderScreenFlag;

@property(nonatomic)TabMainDetailView *tabMainDetailView;
//@property(nonatomic)TabMainDetailView *detailView2;
@property(nonatomic)IBOutlet UIScrollView *swipeDetailView;
@property(nonatomic)IBOutlet UIView *detailView;
@property(nonatomic)TabSquareOrderSummaryController *orderSummaryView;
@property(nonatomic)TabSquareMenuDetailController *menuDetailView;
@property(nonatomic)TabMainCourseMenuListViewController *tabMainCourseMenuListViewController;
@property(nonatomic)NSMutableArray *custType;
@property(nonatomic)NSString *IshideAddButton;
@property(nonatomic)NSString *Viewtype;
@property(nonatomic)IBOutlet UILabel *KDishName;
@property(nonatomic)NSString *KDishCustType;
@property(nonatomic)NSString *kDishId;
@property(nonatomic)IBOutlet UILabel *KDishDescription;
@property(nonatomic)IBOutlet UILabel *KDishRate;
@property(nonatomic)IBOutlet UIImageView *KDishImage;
@property(nonatomic)NSString *KDishCatId;
@property(nonatomic)NSMutableArray *KDishCust;
@property(nonatomic)NSString *selectedID;
@property(nonatomic)NSMutableArray *DishName;
@property(nonatomic)NSMutableArray *isSetType;
@property(nonatomic)NSMutableArray *DishPrice;
@property(nonatomic)NSMutableArray *DishDescription;
@property(nonatomic)NSMutableArray *DishID;
@property(nonatomic)NSMutableArray *DishCatId;
@property(nonatomic)NSMutableArray *DishSubId;
@property(nonatomic)NSMutableArray *DishImage;
@property(nonatomic)NSMutableArray *DishCustomization;
@property(nonatomic)IBOutlet UIButton *addButton;
@property(nonatomic)IBOutlet UIButton *leftButton;
@property(nonatomic)IBOutlet UIButton *rightButton;
@property(nonatomic)IBOutlet UIButton *mcloseButton;
@property(nonatomic)IBOutlet UIScrollView *descriptionScroll;

@property NSInteger pageIndex;



@property(nonatomic,strong)IBOutlet UIButton *closeButton;

//@property(nonatomic,strong)IBOutlet UIScrollView *descriptionScroll;
@property(nonatomic,strong)IBOutlet NSString *currIndex;




-(IBAction)addClicked:(id)sender;
-(IBAction)closeClicked:(id)sender;
-(void)moveNextSubCat;
-(void)movePrevSubCat;
-(void)hideButtons;
-(void)showButtons;
-(void)showDetailView;
-(void)removeSwipeSubviews;
-(void)loadData:(TabMainDetailView*)detailview;
-(void)showDetailView:(int)selectedItem;
-(void)hFlowViewCallBack;
-(void)allocateArray;
-(void)setParent:(id)sender;
-(void)orderAddAnimation;


@end
