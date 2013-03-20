//
//  TabSquarefriendsorderViewController.h
//  TabSquareMenu
//
//  Created by Nikhil Kumar on 8/27/12.
//  Copyright (c) 2012 Trendsetterz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@class TabSquareMenuController;
@class TabMainMenuDetailViewController;
@class TabSquareMenuDetailController;
@class TabSquareBeerDetailController;
@class TabMainDetailView;

@interface TabSquarefriendsorderViewController : UIViewController

@property(nonatomic,strong)NSMutableArray *friendOrderData;
@property(nonatomic,strong)IBOutlet UITableView *frdOrderView;
@property(nonatomic,strong)NSMutableArray *sortCatId;
@property(nonatomic,strong)NSMutableArray *frdOrderCatId;
@property(nonatomic,strong)NSMutableArray *frdOrderDishName;
@property(nonatomic,strong)TabSquareBeerDetailController *beerDetailView;
@property(nonatomic,strong)NSMutableArray *lastOrderedData;
@property(nonatomic,strong)NSMutableArray *lastOrderedId;
@property(nonatomic,strong)NSMutableArray *lastOrderedRating;
@property(nonatomic,strong)NSMutableDictionary *resultFromDB;
@property(nonatomic,strong)TabMainDetailView *dishDetailview;
@property(nonatomic,strong)TabMainMenuDetailViewController *menudetailView;
@property(nonatomic,strong)TabSquareMenuController *menuView;
@property(nonatomic,strong)NSString *fromCheckout;
@property(nonatomic,strong)NSString *DishID;
@property(nonatomic,strong)NSString *DishName;
@property(nonatomic,strong)NSString *DishPrice;
@property(nonatomic,strong)NSString *DishDescription;
@property(nonatomic,strong)NSString *DishCatId;
@property(nonatomic,strong)NSString *DishSubCatId;
@property(nonatomic,strong)UIImage *DishImage;
@property(nonatomic,strong)NSString *custType;
@property(nonatomic,strong)NSMutableArray *DishCustomization;


-(IBAction)closeClicked:(id)sender;
-(void)loadFrdOrderData:(NSMutableArray*)frdData;

@end
