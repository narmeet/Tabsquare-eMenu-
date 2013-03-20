//
//  TabSquareBeerController.h
//  TabSquareMenu
//
//  Created by Nikhil Kumar on 7/6/12.
//  Copyright (c) 2012 Trendsetterz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TabSquareNewBeerScrollController.h"
#import "TabSquareMenuController.h"

@class TabSquareBeerDetailController;
@class TabSquareNewBeerScrollController;
@class TabSquareMenuController;

@interface TabSquareBeerController : UIViewController<UITableViewDelegate>
{
    UITapGestureRecognizer *tapGesture;
    //TabSquareBeerDetailController *beerDetailView;
    TabSquareNewBeerScrollController *beerDetailView;

    int bottletotal;
    NSString *category;
    NSString *currentCatId;
    NSString *currentSubId;
    int totalSubSection;
    int totalPrintItm;
    
    id mParent;
}
@property (nonatomic) id mParent;

@property(nonatomic,weak)TabSquareMenuController *menuview;

@property (nonatomic) NSInteger pageIndex;
@property (nonatomic,strong)NSMutableArray *SubSectionIdData;
@property (nonatomic,strong)NSMutableArray *SubSectionNameData;
@property (nonatomic,strong)NSMutableArray *SectionBeverageData;
@property (nonatomic,strong)IBOutlet UITableView* beverageView;
@property (nonatomic,strong)NSString *drinkName;
//@property (nonatomic,strong)TabSquareBeerDetailController *beerDetailView;
@property (nonatomic,strong)TabSquareNewBeerScrollController *beerDetailView;

@property (nonatomic,strong) NSMutableArray *resultFromPost;
@property (nonatomic,strong) NSMutableArray *beverageName;
@property (nonatomic,strong) NSMutableArray *beveragePrice;
@property (nonatomic,strong) NSMutableArray *beveragePrice1;
@property (nonatomic,strong) NSMutableArray *beverageDescription;
@property (nonatomic,strong) NSMutableArray *beverageID;
@property (nonatomic,strong) NSMutableArray *beverageSubSubCategoryId;
@property (nonatomic,strong) NSMutableArray *beverageImage;
@property (nonatomic,strong) NSMutableArray *beverageImageData;
@property (nonatomic,strong) NSMutableArray *beverageCustomization;
@property (nonatomic,strong) NSMutableArray *beverageSkuDetail;
@property (nonatomic,strong) NSMutableArray *beverageCustType;

-(void) reloadDataOfSubCat:(NSString *)sub cat:(NSString*)CatID;
-(void) reloadDataOfSubCat2:(NSMutableArray*)arr2;
-(void)setParent:(id)sender;
-(void)parentCallToUnHideTheScrollerAndSubCatBgOnMenuController;
@end
