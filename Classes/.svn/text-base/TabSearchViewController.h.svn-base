//
//  TabSearchViewController.h
//  TabSquareMenu
//
//  Created by Nikhil Kumar on 7/19/12.
//  Copyright (c) 2012 Trendsetterz. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TabMainCourseMenuListViewController;
@class TabSquareMenuController;
@class TabSquareBeerController;

@interface TabSearchViewController : UIViewController<UITextViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
{
    NSMutableArray *categoryId;
    NSMutableArray *categoryName;
    NSMutableArray *subCategoryId;
    NSMutableArray *subCategoryName;
    NSMutableArray *dishId;
    NSMutableArray *dishName;
    NSMutableArray *dishprice;
    
}

@property(nonatomic,strong)TabMainCourseMenuListViewController *menulistView1;
@property(nonatomic,strong)TabSquareMenuController *HomePage;
@property(nonatomic,strong)TabSquareBeerController *BeverageView;

@property(nonatomic,strong)NSString *selectedDishPrice;
@property(nonatomic,strong)NSString *selectedCatId;
@property(nonatomic,strong)NSString *selectedSubCatId;
@property(nonatomic,strong)NSString *selectedDishId;

@property(nonatomic,strong)IBOutlet UITextView* searchTextView;
@property(nonatomic,strong)IBOutlet UIPickerView* filterPickerView;
@property(nonatomic,strong)IBOutlet UIButton* filterBtn;
@property(nonatomic,strong)IBOutlet UIButton* keywordBtn;

-(IBAction)searchClicked:(id)sender;
-(void)getPickerData;

@end