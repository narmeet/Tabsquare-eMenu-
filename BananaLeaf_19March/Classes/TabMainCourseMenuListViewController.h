//
//  TabMainCourseMenuListViewController.h
//  TabSquareMenu
//
//  Created by Nikhil Kumar on 7/6/12.
//  Copyright (c) 2012 Trendsetterz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DishItem.h"
#import "MBProgressHUD.h"
#import "ViewController.h"

@class TabMainMenuDetailViewController;
@class TabSquareMenuDetailController;
@class TabSquareMenuController;
@class TabMainDetailView;
@class TabSquareBeerDetailController;
@class TabSquareBeerController;
@class ViewController;

@interface TabMainCourseMenuListViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,MBProgressHUDDelegate>
{
    NSInteger pageIndex;
   // TabSquareMenuDetailController *SoupView;
   //  TabSquareBeerDetailController *beerDetailView;
    MBProgressHUD *progressHud;
    NSInteger selectedItem;
    NSString *currentCatId;
    NSString *currentSubId;
    int totalSubSection;
    UIButton *currentButton;
    
    BOOL tag_switch;
    
    NSString        *fontName;
    UIColor         *fontColor;
    float           fontSize;

}

@property NSInteger pageIndex;
@property(nonatomic)NSMutableArray *SubSectionIdData;
@property(nonatomic)NSMutableArray *SubSectionNameData;
@property(nonatomic)NSMutableArray *SectionDishData;
@property(nonatomic, retain)NSMutableArray *isSetType;
@property(nonatomic, retain)NSMutableArray *tagIcons;
@property(nonatomic, retain)NSMutableArray *tagNames;
@property(nonatomic,weak)TabSquareMenuController *menuview;
@property(nonatomic,weak)TabSquareBeerDetailController *beerDetailView;
@property(nonatomic)NSMutableArray *custType;
@property(nonatomic,weak)TabMainDetailView *dishDetailview;

//@property(nonatomic)TabMainMenuDetailViewController *menudetailView;

//
///change according newscrollVc
@property(nonatomic,strong)ViewController *menudetailView;

@property(nonatomic)NSString *currentListTag;
@property(nonatomic,weak)TabSquareMenuDetailController *SoupView;
@property(nonatomic)TabSquareMenuDetailController * menuDetailViewT;
@property(nonatomic,weak)IBOutlet DishItem *tmpCell;
@property(nonatomic,strong)IBOutlet UITableView *DishList;
@property(nonatomic,weak)NSMutableArray *resultFromPost;

@property(nonatomic)NSMutableArray *DishName;
@property(nonatomic)NSMutableArray *DishPrice;
@property(nonatomic)NSMutableArray *DishDescription;
@property(nonatomic)NSMutableArray *DishID;
@property(nonatomic)NSMutableArray *DishImage;
@property(nonatomic)NSMutableArray *DishCategoryId;
@property(nonatomic)NSMutableArray *DishSubCategoryId;
@property(nonatomic)NSMutableArray *DishSubSubCategoryId;
@property(nonatomic)NSMutableArray *DishCustomization;
@property(nonatomic,weak)TabSquareBeerController* beveragesBeerView;

-(IBAction)addClicked:(id)sender;
-(IBAction)infoClicked:(id)sender;

-(void) reloadDataOfSubCat:(NSString *)sub cat:(NSString*)CatID;
-(void)reloadDataOfSubCat2:(NSString *)sub cat:(NSString *)CatID;
-(void)orderAddAnimation;
-(void)unhideTheScrollerAndSubCatBgOnMenuController;


@end
