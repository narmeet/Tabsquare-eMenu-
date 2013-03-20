

//
//  EditOrder.h
//  TabSquareMenu
//
//  Created by Nikhil Kumar on 10/08/12.
//  Copyright (c) 2012 Trendsetterz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface TakeWayEditOrder : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,MBProgressHUDDelegate>
{
    MBProgressHUD *progressHud;
    
}

@property(nonatomic,strong)IBOutlet UITableView *ReportSummaryTable;

@property(nonatomic,strong)IBOutlet UITableView *TaxesTable;

@property(nonatomic,strong)NSMutableArray *TaxListValue;


@property(nonatomic,strong)IBOutlet UILabel *SubTotal;
@property(nonatomic,strong)IBOutlet UILabel *Total;

@property(nonatomic,strong)NSString *tableNumber;
@property(nonatomic,strong)IBOutlet UILabel *lblTableNumber;

@property(nonatomic,strong)IBOutlet UITextField *t1;
@property(nonatomic,strong)IBOutlet UITextField *t2;
@property(nonatomic,strong)IBOutlet UITextField *t3;
@property(nonatomic,strong)IBOutlet UITextField *t4;

@property(nonatomic,strong)IBOutlet UIView *v1;
@property(nonatomic,strong)IBOutlet UIView *v2;

-(void)getTableDetails:(NSString*)SearchTableNumber;

@end
