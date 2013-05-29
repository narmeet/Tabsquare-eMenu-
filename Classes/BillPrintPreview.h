//
//  BillPrintPreview.h
//  TabSquareMenu
//
//  Created by Nikhil Kumar on 8/30/12.
//  Copyright (c) 2012 Trendsetterz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TabFeedbackViewController.h"

@interface BillPrintPreview : UIViewController<UIWebViewDelegate,UIPrintInteractionControllerDelegate>
{
   IBOutlet UIWebView *webView;
    TabFeedbackViewController* feedbackView;
    IBOutlet UIButton* submitFeedbackBtn;
    IBOutlet UIImageView *bgImage;
    IBOutlet UILabel *thankYouLabel;
    
    
}

-(void)loadWebView;

-(IBAction)printBill:(id)sender;
-(IBAction)backClicked:(id)sender;
-(IBAction)submitFeedbackClicked;
@property(nonatomic,strong)IBOutlet UIButton *KinaraLogo;
@property(nonatomic,strong)NSString *tableNumber;

@end
