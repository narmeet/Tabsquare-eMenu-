//
//  PrintBillAndCheckOutFinal.h
//  TabSquareMenu
//
//  Created by Nikhil Kumar on 09/08/12.
//  Copyright (c) 2012 Trendsetterz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface PrintBillAndCheckOutFinal : UIViewController<UITableViewDataSource,UITableViewDelegate,MBProgressHUDDelegate,UIPrintInteractionControllerDelegate,UIWebViewDelegate,UIPrintInteractionControllerDelegate>
{
    MBProgressHUD *progressHud; 
    int taskType;
    int alterType;
    UIWebView *webView;
    IBOutlet UIWebView *billView;
    
}

-(void)loadWebView;

@property(nonatomic,strong)IBOutlet UITableView *ReportSummaryTable;


@property(nonatomic,strong)IBOutlet UITableView *TaxesTable;

@property(nonatomic,strong)NSMutableArray *TaxListValue;


@property(nonatomic,strong)IBOutlet UILabel *SubTotal;
@property(nonatomic,strong)IBOutlet UILabel *Total;
@property(nonatomic,strong)NSString* ttt;

@property(nonatomic,strong)NSString *tableNumber;
@property(nonatomic,strong)IBOutlet UILabel *lblTableNumber;

@property(nonatomic,strong)IBOutlet UITextField *t1;
@property(nonatomic,strong)IBOutlet UITextField *t2;
@property(nonatomic,strong)IBOutlet UITextField *t3;
@property(nonatomic,strong)IBOutlet UITextField *t4;
@property(nonatomic,strong)IBOutlet UITextField *t5;
@property(nonatomic,strong)IBOutlet UITextField *t6;
@property(nonatomic,strong)IBOutlet UITextField *t7;
@property(nonatomic,strong)IBOutlet UITextField *t8;
@property(nonatomic,strong)IBOutlet UITextField *t9;
@property(nonatomic,strong)IBOutlet UITextField *t10;
@property(nonatomic,strong)IBOutlet UITextField *t11;
@property(nonatomic,strong)IBOutlet UITextField *t12;
@property(nonatomic,strong)IBOutlet UITextField *t13;
@property(nonatomic,strong)IBOutlet UITextField *t14;
@property(nonatomic,strong)IBOutlet UITextField *t15;
@property(nonatomic,strong)IBOutlet UITextField *t16;
@property(nonatomic,strong)IBOutlet UITextField *t17;
@property(nonatomic,strong)IBOutlet UITextField *t18;
@property(nonatomic,strong)IBOutlet UITextField *t19;

@property(nonatomic,strong)IBOutlet UILabel *BillNumber;
@property(nonatomic,strong)IBOutlet UILabel *PaxNumber;
@property(nonatomic,strong)IBOutlet UILabel *DateAndTime;

@property(nonatomic,strong)NSString *BillNumber1;
@property(nonatomic,strong)NSString *PaxNumber1;
@property(nonatomic,strong)NSString *DateAndTime1;

@property(nonatomic,strong)IBOutlet UIView *v1;
@property(nonatomic,strong)IBOutlet UIView *v2;

-(IBAction)updateTotal;
-(IBAction)PrintBill:(id)sender;

@end
