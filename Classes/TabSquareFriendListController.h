//
//  TabSquareFriendListController.h
//  TabSquareMenu
//
//  Created by Nikhil Kumar on 8/25/12.
//  Copyright (c) 2012 Trendsetterz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "RateView.h"
#import "TabSquareNewBeerScrollController.h"
#import "TabMainMenuDetailViewController.h"
#import "ViewController.h"

@class TabSquareMenuController;
@class TabSquarefriendsorderViewController;
@class TabMainMenuDetailViewController;
@class TabSquareMenuDetailController;//#import "MBProgressHUD.h"
@class TabSquareBeerDetailController;


@interface TabSquareFriendListController : UIViewController<UITableViewDelegate,UITableViewDataSource,MBProgressHUDDelegate,RateViewDelegate>
{
    MBProgressHUD *progressHud;
    // TabSquareBeerDetailController *beerDetailView;
    TabSquareNewBeerScrollController *beerDetailView;
    NSString *custType;
    IBOutlet UIImageView* bgImage;
}

//@property(nonatomic,strong)TabMainMenuDetailViewController *menudetailView;
@property(nonatomic,strong)ViewController *menudetailView;

@property(nonatomic,strong)NSMutableDictionary *resultFromDB;
@property(nonatomic,strong)TabSquareMenuController *menuView;
@property(nonatomic,strong)TabSquarefriendsorderViewController *friendOrderView;
@property(nonatomic,strong)TabSquareMenuDetailController *customizationView;
@property(nonatomic,strong)TabSquareNewBeerScrollController *beerDetailView;
@property(nonatomic,strong)IBOutlet UITableView *friendlistView;
@property(nonatomic,strong)IBOutlet UITableView *lastOrderedView;
@property(nonatomic,strong)NSMutableArray *lastOrderedData;
@property(nonatomic,strong)NSMutableArray *lastOrderedId;
@property(nonatomic,strong)NSMutableArray *lastOrderedRating;
@property(nonatomic,strong)NSMutableArray *friendName;
@property(nonatomic,strong)NSMutableArray *friendImage;
@property(nonatomic,strong)NSMutableArray *friendId;
@property(nonatomic,strong)NSMutableArray *friendInstalled;
@property(nonatomic,strong)NSArray *friendData;
@property(nonatomic,strong)NSArray *friendorderData;
@property(nonatomic,strong)NSString *DishID;
@property(nonatomic,strong)NSString *DishName;
@property(nonatomic,strong)NSString *DishPrice;
@property(nonatomic,strong)NSString *DishDescription;
@property(nonatomic,strong)NSString *DishCatId;
@property(nonatomic,strong)UIImage *DishImage;
@property(nonatomic,strong)NSMutableArray *DishCustomization;
@property(nonatomic,strong)NSString* DishSubCatId;
@property(nonatomic,strong)NSString *custType;
@property(nonatomic,strong)NSString *fromCheckout;
-(IBAction)logOutClicked:(id)sender;

-(void)loadFriendList;

-(void) showIndicator;

@end
