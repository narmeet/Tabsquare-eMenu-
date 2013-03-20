//
//  TabTwitterFollowerListControllerViewController.h
//  TabSquareMenu
//
//  Created by Nikhil Kumar on 8/28/12.
//  Copyright (c) 2012 Trendsetterz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TabSquareFavouriteViewController.h"
#import "TabSquareMenuDetailController.h"

@class TabSquareFavouriteViewController;
@class TabSquareMenuController;
@class TabSquarefriendsorderViewController;

@interface TabTwitterFollowerListControllerViewController: UIViewController <TwitterResponseDelegateiPad>

@property (nonatomic, copy)NSString *nextCursor;
@property(nonatomic,strong)IBOutlet UITableView *lastOrderedView;
@property(nonatomic,strong)NSMutableArray *lastOrderedData;
@property(nonatomic,strong)NSMutableArray *lastOrderedId;
@property(nonatomic,strong)NSMutableArray *lastOrderedRating;
@property(nonatomic,strong)NSMutableDictionary *resultFromDB;
@property (nonatomic,strong)TabSquareFavouriteViewController *favouriteView;
@property(nonatomic,strong)TabSquarefriendsorderViewController *friendOrderView;
@property(nonatomic,strong)TabSquareMenuDetailController *customizationView;
@property(nonatomic,strong)TabSquareMenuController *menuView;
@property (nonatomic, strong) NSMutableArray  *followersInfoArray;
@property (nonatomic, strong) NSMutableArray  *friendsIdArr;
@property (nonatomic,strong)NSMutableArray *allfrdId;
@property (nonatomic, strong) NSMutableArray  *threadArr;
@property (nonatomic, strong) NSIndexPath     *moreIndexPath;
@property (strong, nonatomic) IBOutlet UITableView *followersDataTblVw;
@property(nonatomic,strong)NSString *DishID;
@property(nonatomic,strong)NSString *DishName;
@property(nonatomic,strong)NSString *DishPrice;
@property(nonatomic,strong)NSString *DishDescription;
@property(nonatomic,strong)NSString *DishCatId;
@property(nonatomic,strong)UIImage *DishImage;
@property(nonatomic,strong)NSMutableArray *DishCustomization;




-(IBAction)logoutButtonClicked:(id)sender;
- (void) defaultServicesCalling;
-(NSMutableArray*)filterTwitterFrdList:(NSString*)frdtwitterId;
- (void) twitterResponse:(NSMutableArray *) responseArr;

@end

