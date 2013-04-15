//
//  TabSquareTableManagement.h
//  TabSquareMenu
//
//  Created by Nikhil Kumar on 8/9/12.
//  Copyright (c) 2012 Trendsetterz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
@class TabSquareAssignTable;
@class TabSquareTableStatus;
@class TabSquareHomeController;
@class TabSquareMenuController;
@class SalesReport;
@class TakeWayEditOrder;

@interface TabSquareTableManagement : UIViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate, UITextFieldDelegate, UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,MBProgressHUDDelegate>
{
    
    NSMutableArray *tableData;
    NSMutableArray *tableStatus;
    TabSquareAssignTable *assignTableView;
    TabSquareTableStatus *tablestatusView;
    TabSquareHomeController *homeView;
    TabSquareMenuController *TableMgmt;
    //TabSquareHomeController *home;
    SalesReport *SalesReport1;
   // TakeWayEditOrder *taEdit;
    NSMutableArray *TotalFreeTables;
    NSMutableArray *TableStatus;
    NSMutableArray *TATables;
    int totalData;
    int totalTable;
    NSTimer* tt;
    
    UITextField *myTextField;
    MBProgressHUD *progressHud;
    
    int taskType;
    UITextField *numberOfGuests;
    IBOutlet UISwitch *quickOrderSwitch;
    
}

@property(nonatomic,strong) UISwitch *quickOrderSwitch;;
-(IBAction)quickOrderSwitch:(id)sender;
-(IBAction)gotoDishViewMode;
-(IBAction)infoButton:(id)sender;
-(void)viewDidDisappear:(BOOL)animated;
@property(nonatomic,strong) UITextField *numberOfGuests;;

@property(nonatomic,strong)NSString *TotalTableNo;

@property(nonatomic,strong)IBOutlet UITableView *tableNoView;
//@property(nonatomic,retain)IBOutlet UITableView *tableStatusView;
@property(nonatomic,strong)IBOutlet UIView *statusView;

@property(nonatomic,strong)IBOutlet UIButton *takeawayButton;
@property(nonatomic,strong)IBOutlet UIButton *takeawayAssignBtn;
@property(nonatomic,strong)IBOutlet UIImageView *bgImage;

@property(nonatomic,strong)NSString *tableNumber;

@property(nonatomic,strong)NSString *sectionID;
@property(nonatomic,strong)NSString *oldTableNumber;

@end
