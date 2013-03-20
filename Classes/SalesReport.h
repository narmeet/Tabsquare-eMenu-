//
//  SalesReport.h
//  TabSquareMenu
//
//  Created by Nikhil Kumar on 09/08/12.
//  Copyright (c) 2012 Trendsetterz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SalesReport : UIViewController<UIPickerViewDelegate,UIPickerViewDataSource,UIWebViewDelegate,UIAlertViewDelegate>
{
    IBOutlet UIWebView* billView;
    IBOutlet UIButton* printPDFBtn;
    
}

@property(nonatomic,strong)IBOutlet UITextField *txtshift;
@property(nonatomic,strong)IBOutlet UITextField *txtdate;
@property(nonatomic,strong)IBOutlet UITextField *txtTodate;

@property(nonatomic,strong)NSMutableArray *shiftID;
@property(nonatomic,strong)NSMutableArray *shiftName;

@property(nonatomic,strong)IBOutlet UIDatePicker *DDate;
@property(nonatomic,strong)IBOutlet UIDatePicker *ToDate;

@property(nonatomic,strong)IBOutlet UIPickerView *ShiftPicker;

@property(nonatomic,strong)NSString *ShiftIDV;



@property(nonatomic,strong)IBOutlet UIView *v1;

-(void)clearSubViews;

@end
