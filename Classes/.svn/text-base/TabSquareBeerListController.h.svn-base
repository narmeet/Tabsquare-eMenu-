//
//  TabSquareBeerListController.h
//  TabSquareMenu
//
//  Created by Nikhil Kumar on 7/9/12.
//  Copyright (c) 2012 Trendsetterz. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TabSquareBeerDetailController;

@interface TabSquareBeerListController : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>
{
    NSMutableArray *drinkList;
}

@property(nonatomic,strong)IBOutlet UITableView *drinklistView;
@property(nonatomic,strong)IBOutlet UIView *whiskyView;
@property(nonatomic,strong)IBOutlet UIView *limeView;
@property(nonatomic,strong)IBOutlet UITextView *requestView;
@property(nonatomic,strong)TabSquareBeerDetailController *beverageDetailView;
@property(nonatomic,strong)NSMutableArray *beverageQuantity;
@property(nonatomic,strong)NSString* beverageCatID;

-(IBAction)doneClicked:(id)sender;
-(void)addObjectsInBeverage;
-(IBAction)closeClicked:(id)sender;


@end
