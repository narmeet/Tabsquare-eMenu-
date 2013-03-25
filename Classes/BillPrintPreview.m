//
//  BillPrintPreview.m
//  TabSquareMenu
//
//  Created by Nikhil Kumar on 8/30/12.
//  Copyright (c) 2012 Trendsetterz. All rights reserved.
//

#import "BillPrintPreview.h"
#import "UYLGenericPrintPageRenderer.h"
#import "ShareableData.h"
#import "SBJSON.h"
#import "TabSquareTableStatus.h"
#import "TabSquareTableManagement.h"
#import "TabSquareMenuController.h"
#import "TabSquareHomeController.h"
#import "TabSquareAssignTable.h"
#import <QuartzCore/CALayer.h>
#import "TabFeedbackViewController.h"
#import "ShareableData.h"
#import "TabSquareTableStatus.h"
#import "SBJSON.h"
#import "TabSquareDBFile.h"


@interface BillPrintPreview ()

@end

@implementation BillPrintPreview
@synthesize KinaraLogo,tableNumber;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}


/*-(void)loadView
{
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(20, 101,728, 883)];
    webView.tag = 121;
    NSURL *targetURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://108.178.27.242/luigi/webs/printable/2"]];   
    NSURLRequest *request = [NSURLRequest requestWithURL:targetURL];
    [webView  loadRequest:request];
    [self.view addSubview:webView];
}*/

-(void)loadWebView
{
    //webView = [[UIWebView alloc] initWithFrame:CGRectMake(20, 101,728, 883)];
    webView.tag = 121;
    NSURL *targetURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@Ex/printHTMLBill.php?tableid=%@&key=%@", [ShareableData serverURL],[ShareableData sharedInstance].assignedTable1, [ShareableData appKey]]];
    NSURLRequest *request = [NSURLRequest requestWithURL:targetURL];
    [webView  loadRequest:request];
   // [self.view addSubview:webView];
    
}
-(void)addTapGesture
{
    UITapGestureRecognizer *singleTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)];
    singleTap.numberOfTapsRequired=3;
    [KinaraLogo addGestureRecognizer:singleTap];
}
-(void)handleTap:(UIGestureRecognizer*)gesture
{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Select Option" message:nil
                                                   delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Go Back To Tbl Mgmt",nil];
    [alert show];
    
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    
        if([title isEqualToString:@"Go Back To Tbl Mgmt"])
        {
          
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Enter a 4 digit password:"
                                                           delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
            alert.alertViewStyle = UIAlertViewStyleSecureTextInput;
            UITextField * alertTextField = [alert textFieldAtIndex:0];
            alertTextField.keyboardType = UIKeyboardTypeNumberPad;
            [alert show];
            
        }
    
    
    if([title isEqualToString:@"OK"])
    {
        UITextField *password = [alertView textFieldAtIndex:0];
       // BOOL authenticate=[self AuthenticateWater:password.text];
        
        UITextField * pwdText = [alertView textFieldAtIndex:0];
        if ([pwdText.text isEqualToString:@"1234"]) {
            
            [self.navigationController popToRootViewControllerAnimated:YES];

        }
        else{
            UIAlertView *alert4 = [[UIAlertView alloc] initWithTitle:nil message:@"please enter correct password"
                                                            delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Retry", nil];
            [alert4 show];
            
        }
        
//        BOOL authenticate=[ShareableData hasAccess:password.text level:VOID_ITEM];
//    
//        if(authenticate)
//        {
//           // TabSquareTableManagement *TableMgmt=[[TabSquareTableManagement alloc]initWithNibName:@"TabSquareTableManagement" bundle:nil];
//           // [self presentModalViewController:TableMgmt animated:YES];
//            [self.navigationController popToRootViewControllerAnimated:YES];
//            
//        }
//        else
//        {
//          //  alertNo=2;
//            UIAlertView *alert4 = [[UIAlertView alloc] initWithTitle:nil message:@"please enter correct password"
//                                                            delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Retry", nil];
//            [alert4 show];
//            
//        }
        
    }

    
}

-(BOOL)AuthenticateWater:(NSString*)passtext
{
    NSString *post =[NSString stringWithFormat:@"password=%@&key=%@",passtext, [ShareableData appKey]];
    
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    NSString *url_string = [NSString stringWithFormat:@"%@/webs/authenticate_staff", [ShareableData serverURL]];
    
    [request setURL:[NSURL URLWithString:url_string]];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/x-www-form-urlencoded charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSError *error;
    NSURLResponse *response;
    NSData *uData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSString *data=[[NSString alloc]initWithData:uData encoding:NSUTF8StringEncoding];
    if([data isEqualToString:@"1"])
    {
        return true;
    }
    else {
        return false;
    }
    // DLog(@"%@",data);
}


-(IBAction)submitFeedbackClicked{
    feedbackView.view.frame=CGRectMake(0, 120, feedbackView.view.frame.size.width, feedbackView.view.frame.size.height);
    [self.view addSubview:feedbackView.view];
    webView.hidden=YES;
    submitFeedbackBtn.hidden=YES;
}
- (void)printWebView {
    
    UIPrintInteractionController *pc = [UIPrintInteractionController sharedPrintController];
    pc.delegate = self;
    
    UIPrintInfo *printInfo = [UIPrintInfo printInfo];
    printInfo.outputType = UIPrintInfoOutputGeneral;
    printInfo.jobName = @"Bill report";
    pc.printInfo = printInfo;
    pc.showsPageRange = YES;
    
    
    UYLGenericPrintPageRenderer *renderer = [[UYLGenericPrintPageRenderer alloc] init];
    renderer.headerText = printInfo.jobName;
    renderer.footerText = @"AirPrinter - Kinara.com";
   // renderer.printableRect.size = 0.5f;
    //[webView.scrollView setZoomScale:1.5f animated:NO];
    UIViewPrintFormatter *formatter = [webView viewPrintFormatter];
     
    [renderer addPrintFormatter:formatter startingAtPageAtIndex:0];
    pc.printPageRenderer = renderer;
    
    UIPrintInteractionCompletionHandler completionHandler = 
    ^(UIPrintInteractionController *printController, BOOL completed, NSError *error) {
        if(!completed && error){
            DLog(@"Print failed - domain: %@ error code %u", error.domain, error.code);	
        }
    };
    
    [pc presentAnimated:YES completionHandler:completionHandler];
    
}


- (void)viewDidLoad
{
   [super viewDidLoad];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@Ex/printBillText.php?tableid=%@&key=%@", [ShareableData serverURL],tableNumber, [ShareableData appKey]]]];
    
    NSError *error;
    NSURLResponse *response;
    NSData *uData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    feedbackView=[[TabFeedbackViewController alloc]initWithNibName:@"TabFeedbackViewController" bundle:nil];
    feedbackView.menuView=self;
    [self addTapGesture];
    // Do any additional setup after loading the view from its nib.
}
-(void)viewDidAppear:(BOOL)animated{
    [self submitFeedbackClicked];
    [self getBackgroundImage];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
-(void)getBackgroundImage
{
    /*
     CGPoint _point = [self.view center];
     CGRect _frm = CGRectMake(_point.x-11, _point.y-12, 25, 25);
     UIActivityIndicatorView *act = [[UIActivityIndicatorView alloc] initWithFrame:_frm];
     [self.view addSubview:act];
     [act startAnimating];
     */
    
    
    //dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT
    //, 0), ^{
    
    NSString *img_name = [NSString stringWithFormat:@"%@%@_%@.png", PRE_NAME, BACKGROUND_IMAGE, [ShareableData appKey]];
    
    UIImage *img = [[TabSquareDBFile sharedDatabase] getImage:img_name];
    
    if(img == nil || img == NULL) {
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        [arr addObject:BACKGROUND_IMAGE];
        
        [[TabSquareDBFile sharedDatabase] updateUIImages:arr];
        
        img = [[TabSquareDBFile sharedDatabase] getImage:img_name];
    }
    
    [bgImage setImage:img];
    /*
     
     dispatch_sync(dispatch_get_main_queue(), ^{
     
     [self.bgImage setImage:img];
     [act removeFromSuperview];
     });
     */
    
    //});
    
    
}
-(IBAction)printBill:(id)sender
{
    [self printWebView];
}

-(IBAction)backClicked:(id)sender
{
    [self dismissModalViewControllerAnimated:NO];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

@end
