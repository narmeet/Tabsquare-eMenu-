//
//  SalesReportDetail.h
//  TabSquareMenu
//
//  Created by Nikhil Kumar on 09/08/12.
//  Copyright (c) 2012 Trendsetterz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface SalesReportDetail : UIViewController<UITableViewDataSource,UITableViewDelegate,UIPrintInteractionControllerDelegate,MBProgressHUDDelegate,UIAlertViewDelegate>
{
    MBProgressHUD *progressHud;
    
}

-(IBAction)printReport;

@property(nonatomic,strong)IBOutlet UITableView *ReportSummaryTable;
@property(nonatomic,strong)NSMutableArray *ReportValues;
@property(nonatomic,strong)NSMutableArray *totalBills;
@property(nonatomic,strong)NSMutableArray *amount;

@property(nonatomic,strong)NSString *txtshift;
@property(nonatomic,strong)NSString *txtdate;
@property(nonatomic,strong)NSString *txtdateTo;
@property(nonatomic,strong)NSString *jsonString;

@property(nonatomic,strong)IBOutlet UIView *v1;

@end



