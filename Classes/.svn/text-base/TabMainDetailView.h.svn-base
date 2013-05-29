//
//  TabMainDetailView.h
//  TabSquareMenu
//
//  Created by Nikhil Kumar on 9/8/12.
//  Copyright (c) 2012 Trendsetterz. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TabSquareOrderSummaryController;
@class TabSquareMenuDetailController;
@class TabMainMenuDetailViewController;

@interface TabMainDetailView : UIViewController
{
    int nextOrPrev;
    int currentindex;
    NSTimer* tt;
    UIButton *currentButton;
    
}

@property NSInteger pageIndex;
@property(nonatomic,strong)TabMainMenuDetailViewController *menuBaseView;
@property(nonatomic,strong)TabSquareOrderSummaryController *orderSummaryView;
@property(nonatomic,strong)TabSquareMenuDetailController *menuDetailView;
@property(nonatomic,strong)NSMutableArray *custType;
@property(nonatomic,strong)NSString *IshideAddButton;
@property(nonatomic,strong)NSString *Viewtype;
@property(nonatomic,strong)NSString *KDishCustType;
@property(nonatomic,strong)NSString *kDishId;
@property(nonatomic,strong)IBOutlet UILabel *KDishName;
@property(nonatomic,strong)IBOutlet UILabel *KDishDescription;
@property(nonatomic,strong)IBOutlet UILabel *KDishRate;
@property(nonatomic,strong)IBOutlet UIImageView *KDishImage;
@property(nonatomic,strong)NSString *KDishCatId;
@property(nonatomic,strong)NSMutableArray *KDishCust;
@property(nonatomic,strong)NSString *selectedID;
@property(nonatomic,strong)NSMutableArray *DishName;
@property(nonatomic,strong)NSMutableArray *DishPrice;
@property(nonatomic,strong)NSMutableArray *DishDescription;
@property(nonatomic,strong)NSMutableArray *DishID;
@property(nonatomic,strong)NSMutableArray *DishCatId;
@property(nonatomic,strong)NSMutableArray *DishSubId;
@property(nonatomic,strong)NSMutableArray *DishImage;
@property(nonatomic,strong)NSMutableArray *DishCustomization;
@property(nonatomic,strong)IBOutlet UIButton *addButton;
@property(nonatomic,strong)IBOutlet UIButton *leftButton;
@property(nonatomic,strong)IBOutlet UIButton *rightButton;
@property(nonatomic,strong)IBOutlet UIScrollView *descriptionScroll;
@property(nonatomic,strong)IBOutlet NSString *currIndex;
@property(nonatomic,strong)IBOutlet UIImageView *popupBackground;



-(IBAction)closeClicked:(id)sender;
-(IBAction)addClicked:(id)sender;
-(IBAction)nextClicked:(id)sender;
-(IBAction)prevClicked:(id)sender;
-(void)hideButtons;
-(void)showButtons;
-(void)loadDataInView:(int)selectedItem;
-(void)orderAddAnimation;


@end
