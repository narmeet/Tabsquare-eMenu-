//
//  TabSquareBeerDetailController.h
//  TabSquareMenu
//
//  Created by Nikhil Kumar on 7/7/12.
//  Copyright (c) 2012 Trendsetterz. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TabSquareBeerListController;
@class TabSquareBeerController;
@class TabSquareMenuDetailController;

@interface TabSquareBeerDetailController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    TabSquareBeerListController *beerListView;
    int currentindex;
    int beverageSkuIndex;
    int tempDishID;
    IBOutlet UIButton* leftArrow;
    IBOutlet UIButton* rightArrow;
    IBOutlet UIImageView* bgg;
}

@property(nonatomic,strong) TabSquareMenuDetailController *customizationView;
@property(nonatomic,strong)IBOutlet UIView* detailImageView;
@property(nonatomic,strong)IBOutlet UILabel* drinkName;
@property(nonatomic,strong)IBOutlet UILabel* drinkDiscription;
@property(nonatomic,strong)IBOutlet UIImageView *drinkImage;
@property(nonatomic,strong)IBOutlet UITableView *beverageSkUView;
@property(nonatomic,strong)TabSquareBeerListController *beerListView;
@property(nonatomic,strong)TabSquareBeerController *beverageView;
@property(nonatomic,strong)IBOutlet UIButton* leftArrow;
@property(nonatomic,strong)IBOutlet UIButton* rightArrow;
@property(nonatomic,strong)NSMutableArray *addBeverageId;
@property(nonatomic,strong)NSMutableArray *addBeverageQunatity;
@property(nonatomic,strong)NSString* beverageCatId;
@property(nonatomic,strong)NSMutableArray *beverageSKUDetail;
@property(nonatomic,strong)NSMutableArray *beverageCustomization;
@property(nonatomic,strong)NSMutableArray *beverageCutType;
@property(nonatomic,strong)NSString *selectedIndex;
@property(nonatomic)int tempDishID;

-(IBAction)closeClicked:(id)sender;
-(void)loadBeverageData:(int)index;
-(IBAction)leftClicked:(id)sender;
-(IBAction)rightClicked:(id)sender;

@end
