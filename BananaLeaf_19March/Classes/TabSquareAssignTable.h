//
//  TabSquareAssignTable.h
//  TabSquareMenu
//
//  Created by Nikhil Kumar on 8/9/12.
//  Copyright (c) 2012 Trendsetterz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
@class TabSquareHomeController;

@interface TabSquareAssignTable : UIViewController<UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UIAlertViewDelegate,MBProgressHUDDelegate>
{
    TabSquareHomeController *homeView;
    NSMutableArray *tableData;
    NSMutableArray *ipadData;
    NSMutableArray *ipadId;
    NSMutableArray *guesesData;
    NSString *ipadid;
    int tableNo;
    int alertNo;
    
    MBProgressHUD *progressHud;
    int taskType;
}

@property(nonatomic,strong)IBOutlet UITextField *tableNo1;
@property(nonatomic,strong)IBOutlet UITextField *tableNo2;
@property(nonatomic,strong)IBOutlet UITextField *tableNo3;
@property(nonatomic,strong)IBOutlet UITextField *tableNo4;

@property(nonatomic,strong)IBOutlet UILabel *lbltableNo1;
@property(nonatomic,strong)IBOutlet UILabel *lbltableNo2;
@property(nonatomic,strong)IBOutlet UILabel *lbltableNo3;
@property(nonatomic,strong)IBOutlet UILabel *lbltableNo4;
@property(nonatomic,strong)IBOutlet UILabel *lbltotalGueses;

@property(nonatomic,strong)IBOutlet UITextField *noOfGueses;

@property(nonatomic,strong)IBOutlet UITextField *iPadNo;
@property(nonatomic,strong)IBOutlet UILabel *lbliPadNo;


@property(nonatomic,strong)IBOutlet UIImageView *homeView1;
@property(nonatomic,strong)IBOutlet UIImageView *homeView2;
@property(nonatomic,strong)IBOutlet UIPickerView *tablePicker;
@property(nonatomic,strong)IBOutlet UIPickerView *guesesPicker;

@property(nonatomic,strong)IBOutlet UIPickerView *ipadPicker;
@property(nonatomic,strong)IBOutlet UIButton *hidePickerBtn;
@property(nonatomic,strong)IBOutlet UISegmentedControl *segmentControl;

@property(nonatomic,strong)IBOutlet UIButton *gotoDish;
@property(nonatomic,strong)IBOutlet UIButton *gotoTable;
@property(nonatomic,strong)IBOutlet UIButton *gotoResetAssign;
@property(nonatomic,strong)IBOutlet UIButton *assignTakeaway;
-(IBAction)assignBtnClicked:(id)sender;
-(void)assignTableNo:(NSString*)tableNo;
-(IBAction)doorOpenClick:(id)sender;
-(IBAction)hidePickerBtn:(id)sender;
-(IBAction)assignTakeawayClicked:(id)sender;


@end



