//
//  TabSquareMenuDetailController.h
//  TabSquareMenu
//
//  Created by Nikhil Kumar on 7/9/12.
//  Copyright (c) 2012 Trendsetterz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSLabel.h"
#import "TabSquareMenuController.h"
@class TabSquareSoupViewController;
@class CustomizationUnPaidCell;
@class CustomizationPaidCell;
@class TabSquareMenuController;

@interface TabSquareMenuDetailController : UIViewController<UITextViewDelegate,UITableViewDelegate,UITableViewDataSource>
{
    CGRect viewFrame;
    CGRect viewFrame2;
    UITapGestureRecognizer *gestureView;
    UIView *detailImageView1;
    UIView *detailImageView2;
   // IBOutlet UIImageView* bggg;
    
    id mParent;
    MSLabel *headerSectionLabel;
    UILabel *headerLabel;
}
@property (nonatomic) id mParent;
@property(nonatomic,strong)MSLabel *headerSectionLabel;
@property(nonatomic,strong)UILabel *headerLabel;

@property(nonatomic,strong)IBOutlet UIButton *crossBtn;
@property(nonatomic,strong)NSString* swipeIndicator;
@property(nonatomic,strong)IBOutlet CustomizationUnPaidCell *unpaidCell;
@property(nonatomic,strong)IBOutlet CustomizationPaidCell *paidCell;
@property(nonatomic,strong)IBOutlet UITableView *customizationView;
@property(nonatomic,strong)NSDictionary *tableContent;
@property(nonatomic,strong)IBOutlet UIView* detailImageView;
@property(nonatomic,strong)IBOutlet UITextView* requestView;
@property(nonatomic,strong)NSString* KKselectedID;
@property(nonatomic,strong)NSString* KKselectedName;
@property(nonatomic,strong)NSString* KKselectedRate;
@property(nonatomic,strong)NSString* KKselectedCatId;
@property(nonatomic,strong)UIImage* KKselectedImage;
@property(nonatomic,strong)NSMutableArray *DishCustomization;
@property(nonatomic,strong)TabSquareSoupViewController *soupMenu;
@property(nonatomic,strong)TabSquareMenuController *menuView;/////////////////change the mparentt value in this class
@property(nonatomic,strong)NSString *isView;
@property(nonatomic,strong)IBOutlet UIImageView *backImage;
@property (nonatomic, strong)IBOutlet UIView *bgBlackView;

-(IBAction)doneClicked:(id)sender;
-(IBAction)closeClicked:(id)sender;
-(IBAction)minusClicked:(id)sender;
-(IBAction)plusClicked:(id)sender;
-(void)setParent:(id)sender;
-(void)unhideTheScrollerAndSubCatBgOnMenuController;
-(void)unHideAllTheButtononMenuAfterCustomizationIsDone;

@end
