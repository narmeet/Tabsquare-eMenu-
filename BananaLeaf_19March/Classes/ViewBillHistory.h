//
//  ViewBillHistory.h
//  TabSquareMenu
//
//  Created by Nikhil Kumar on 10/08/12.
//  Copyright (c) 2012 Trendsetterz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewBillHistory : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    
}

@property(nonatomic,strong)IBOutlet UITableView *ReportSummaryTable;
@property(nonatomic,strong)NSMutableArray *ReportValues;

@property(nonatomic,strong)IBOutlet UITableView *ReportListTable;
@property(nonatomic,strong)NSMutableArray *ReportListValues;

@end
