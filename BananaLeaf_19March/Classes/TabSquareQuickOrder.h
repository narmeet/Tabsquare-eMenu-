//
//  TabSquareQuickOrder.h
//  TabSquareMenu
//
//  Created by Asvin Kaur on 4/12/12.
//  Copyright (c) 2012 Trendsetterz. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TabSquareMenuController;
@class TabSquarefriendsorderViewController;
@class TabMainMenuDetailViewController;
@class TabSquareMenuDetailController;//#import "MBProgressHUD.h"
@class TabSquareBeerDetailController;
@class TabSquareBeerController;

@interface TabSquareQuickOrder : UIViewController<UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    NSInteger selectedIndex;
    TabSquareBeerDetailController *beerDetailView;
    //IBOutlet UITableView* tt;
}
@property(nonatomic,strong)NSMutableArray *menuSubCategory;
@property(nonatomic,strong)TabSquareMenuController *menuView;
@property(nonatomic,strong)TabSquarefriendsorderViewController *friendOrderView;
@property(nonatomic,strong)TabSquareMenuDetailController *customizationView;
@property(nonatomic,strong)TabSquareBeerDetailController *beerDetailView;
@property(nonatomic,strong)IBOutlet UITableView* tt;
@property(nonatomic,strong)IBOutlet UICollectionView* tt2;
@property(nonatomic,strong)NSMutableArray *dishes;
@property(nonatomic,strong)NSString *DishID;
@property(nonatomic,strong)NSString *DishName;
@property(nonatomic,strong)NSString *DishPrice;
@property(nonatomic,strong)NSString *DishDescription;
@property(nonatomic,strong)NSString *DishCatId;
@property(nonatomic,strong)UIImage *DishImage;
@property(nonatomic,strong)NSMutableArray *DishCustomization;
@property(nonatomic,strong)NSString* DishSubCatId;
@property(nonatomic,strong)NSString *custType;
@property(nonatomic,strong)NSMutableDictionary *resultFromDB;
@property(nonatomic,strong)TabSquareBeerController* beveragesBeerView;



@end
