//
//  SalesReportDetail.m
//  TabSquareMenu
//
//  Created by Nikhil Kumar on 09/08/12.
//  Copyright (c) 2012 Trendsetterz. All rights reserved.
//

#import "SalesReportDetail.h"
#import "PrintBillAndCheckOut.h"
#import "SBJSON.h"
#import "SalesReport.h"
#import "ShareableData.h"
#import <QuartzCore/CALayer.h>

@interface SalesReportDetail ()

@end

@implementation SalesReportDetail

@synthesize ReportSummaryTable,ReportValues,txtdate,txtshift,v1,totalBills,amount,txtdateTo,jsonString;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    v1.layer.cornerRadius=12.0;
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    ReportValues=[[NSMutableArray alloc]init];
    
    [ReportValues addObject:@"Description"];
    
    
    totalBills=[[NSMutableArray alloc]init];
    
    [totalBills addObject:@"Total Bills"];
       
    
    amount=[[NSMutableArray alloc]init];
    
    [amount addObject:@"Amount"];
  
    
    [self showIndicator];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

#pragma mark Table view methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [ReportValues count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    //cell.textLabel.text=[ReportValues objectAtIndex:indexPath.row];
    
    UILabel *ItemName=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, 270, 20)];
    ItemName.text= ReportValues[indexPath.row];;
    ItemName.textAlignment=UITextAlignmentLeft;
    ItemName.backgroundColor=[UIColor clearColor];
    ItemName.font=[UIFont boldSystemFontOfSize:18];
    [cell.contentView addSubview:ItemName];
    
    UILabel *ItemQuantity=[[UILabel alloc]initWithFrame:CGRectMake(300, 10, 150, 20)];
    ItemQuantity.text= totalBills[indexPath.row];;
    ItemQuantity.textAlignment=UITextAlignmentCenter;
    ItemQuantity.font=[UIFont boldSystemFontOfSize:14];
    ItemQuantity.backgroundColor=[UIColor clearColor];
    [cell.contentView addSubview:ItemQuantity];
    
    UILabel *ItemRate=[[UILabel alloc]initWithFrame:CGRectMake(450, 10, 200, 20)];
    ItemRate.text= amount[indexPath.row];;
    ItemRate.textAlignment=UITextAlignmentLeft;
    ItemRate.font=[UIFont boldSystemFontOfSize:14];
    ItemRate.backgroundColor=[UIColor clearColor];
    [cell.contentView addSubview:ItemRate];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = ([indexPath row]%2)?[UIColor grayColor]:[UIColor lightGrayColor];
    if(indexPath.row==0)
    {
        cell.backgroundColor =[UIColor colorWithRed:100.0/255 green:149.0/255 blue:237.0/255 alpha:1.0];
    }
}

- (IBAction)ButtonClick:(id)sender
{
	

   /* NSString *test1=@"kalim";
    NSString *test2=@"kalim";
    
    NSMutableString *printBody = [NSMutableString stringWithFormat:@"%@, %@",test1, test2];
    [printBody appendFormat:@"\n\n\n\nPrinted From *myapp*"];
    
    UIPrintInteractionController *pic = [UIPrintInteractionController sharedPrintController];
    pic.delegate = self;
    
    UIPrintInfo *printInfo = [UIPrintInfo printInfo];
    printInfo.outputType = UIPrintInfoOutputGeneral;
    printInfo.jobName = @"Hello ,Trendsetter Printer demo  ..........";
    pic.printInfo = printInfo;
    
    UISimpleTextPrintFormatter *textFormatter = [[UISimpleTextPrintFormatter alloc] initWithText:printBody];
    textFormatter.startPage = 0;
    textFormatter.contentInsets = UIEdgeInsetsMake(72.0, 72.0, 72.0, 72.0); // 1 inch margins
    textFormatter.maximumContentWidth = 6 * 72.0;
    pic.printFormatter = textFormatter;
    [textFormatter release];
    pic.showsPageRange = YES;
    
    void (^completionHandler)(UIPrintInteractionController *, BOOL, NSError *) =
    ^(UIPrintInteractionController *printController, BOOL completed, NSError *error) {
        if (!completed && error) {
            DLog(@"Printing could not complete because of error: %@", error);
        }
    };
    
    [pic presentAnimated:YES completionHandler:completionHandler];*/
    
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, YES, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.view.layer renderInContext:context];
    UIImage *imageFromCurrentView = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIPrintInteractionController *printController = [UIPrintInteractionController sharedPrintController];
    printController.delegate=self;
    printController.printingItem = imageFromCurrentView;
    UIPrintInfo *printInfo = [UIPrintInfo printInfo];
    printInfo.outputType = UIPrintInfoOutputGrayscale;
    printController.printInfo = printInfo;
    printController.showsPageRange = YES;
    
    
    void (^completionHandler)(UIPrintInteractionController *, BOOL, NSError *) = ^(UIPrintInteractionController *printController, BOOL completed, NSError *error) {
        if (!completed && error) {
            //DLog(@"FAILED! due to error in domain %@ with error code %u", error.domain, error.code);
        }
    };
    
    [printController presentAnimated:YES completionHandler:completionHandler];
    
    
}

-(void)getAllData
{
   // DLog(@"Date : %@",self.txtdate);
   // DLog(@"Shift : %@",self.txtshift);
    
    //[ReportValues removeAllObjects];
    //[amount removeAllObjects];
    //[totalBills removeAllObjects];
    
    NSString *post =[NSString stringWithFormat:@"shift=%@&date=%@&to=%@&key=%@",self.txtshift,self.txtdate,self.txtdateTo, [ShareableData appKey]];
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    NSString *url_string = [NSString stringWithFormat:@"%@/webs/get_all_orders_of_shifts", [ShareableData serverURL]];
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
    DLog(@"Data 1:%@",data);
    jsonString = [data copy];
    SBJSON *parser = [[SBJSON alloc] init];
    NSMutableArray *resultFromPost = [parser objectWithString:data error:nil];
    
    DLog(@"Data 2:%@",resultFromPost);
    
    for(int i=0;i<[resultFromPost count];i++)
    {
        NSMutableDictionary *dataitem=resultFromPost[i];
        [amount addObject:[NSString stringWithFormat:@"%@",dataitem[@"value"]]];
        [ReportValues addObject:[NSString stringWithFormat:@"%@",dataitem[@"label"]]];
        [totalBills addObject:[NSString stringWithFormat:@"%@",dataitem[@"no_of_bills"]]];
        
    }
    [ReportSummaryTable reloadData];
}
-(IBAction)printReport
{
    // DLog(@"Date : %@",self.txtdate);
    // DLog(@"Shift : %@",self.txtshift);
    
    //[ReportValues removeAllObjects];
    //[amount removeAllObjects];
    //[totalBills removeAllObjects];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"How would you like to view the report?"
                                                   delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Email",@"Print", nil];
    //alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
    
   }
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if ([title isEqualToString:@"Email"]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Please enter your email"
                                                       delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Send", nil];
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        UITextField * alertTextField = [alert textFieldAtIndex:0];
        alertTextField.keyboardType = UIKeyboardTypeEmailAddress;
        [alert show];
    }
    if ([title isEqualToString:@"Print"]){
        
        NSString *post =[NSString stringWithFormat:@"jsonString=%@&shift=%@&date=%@&to=%@&key=%@",jsonString,self.txtshift,self.txtdate,self.txtdateTo, [ShareableData appKey]];
        NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        
        NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        NSString *url_string = [NSString stringWithFormat:@"%@Ex/printReport.php", [ShareableData serverURL]];
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
    }
    
    
    if ([title isEqualToString:@"Send"]){
        UITextField *emailT = [alertView textFieldAtIndex:0];
        
        NSString *post =[NSString stringWithFormat:@"jsonString=%@&shift=%@&date=%@&to=%@&email=%@&key=%@",jsonString,self.txtshift,self.txtdate,self.txtdateTo,[emailT.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding ], [ShareableData appKey]];
        NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        
        NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        
        NSString *url_string = [NSString stringWithFormat:@"%@Ex/saveDetailToPDF.php", [ShareableData serverURL]];
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
   
        DLog(@"%@",data);
    }
}

-(void) showIndicator
{
    UIView *progressView = [[UIView alloc]initWithFrame:CGRectMake(0,187, self.view.frame.size.width, self.view.frame.size.height)];
	progressHud= [[MBProgressHUD alloc] initWithView:progressView];
	[self.view addSubview:progressHud];
	[self.view bringSubviewToFront:progressHud];
	//progressHud.dimBackground = YES;
	progressHud.delegate = self;
    //progressHud.labelText = @"loading....";
	[progressHud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
}

- (void)myTask
{
    [self getAllData];
}

- (IBAction)BackButton:(id)sender
{
	//SalesReport *SalesSummaryReport=[[SalesReport alloc]initWithNibName:@"SalesReport" bundle:nil];
    //[self dismissModalViewControllerAnimated:NO];
   // [self.navigationController pushViewController:SalesSummaryReport animated:YES];
    //[self.navigationController dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
