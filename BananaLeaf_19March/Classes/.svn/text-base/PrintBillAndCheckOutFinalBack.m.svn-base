//
//  PrintBillAndCheckOutFinal.m
//  TabSquareMenu
//
//  Created by Nikhil Kumar on 09/08/12.
//  Copyright (c) 2012 Trendsetterz. All rights reserved.
//

#import "PrintBillAndCheckOutFinal.h"
#import "UYLGenericPrintPageRenderer.h"
#import "ViewBillHistory.h"
#import "ShareableData.h"
#import "SBJSON.h"
#import "TabSquareTableStatus.h"
#import "TabSquareTableManagement.h"
#import "TabSquareMenuController.h"
#import "TabSquareHomeController.h"
#import "TakeWayEditOrder.h"
#import "TabSquareAssignTable.h"
#import <QuartzCore/CALayer.h>
#import "TabSquarePrintViewController.h"
#import "BillPrintPreview.h"


@interface PrintBillAndCheckOutFinal ()

@end

@implementation PrintBillAndCheckOutFinal

@synthesize ReportSummaryTable;

@synthesize TaxesTable,TaxListValue;
@synthesize SubTotal,Total;
@synthesize tableNumber,lblTableNumber;
@synthesize t1,t2,t3,t4,t5,t6,t7,t8,t9,t10,t11,t12,t13,t14,t15,t16,t17,t18,t19;
@synthesize DateAndTime,BillNumber,PaxNumber,ttt;
@synthesize DateAndTime1,BillNumber1,PaxNumber1,v1,v2;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if(self)
    {
        // Custom initialization
    }
    return self;
}

-(void)loadWebView
{
    webView = [[UIWebView alloc] initWithFrame:CGRectMake(20, 101,728, 883)];
    webView.tag = 121;
    //NSURL *targetURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://108.178.27.242/kinara/webs/printable/%@",[ShareableData sharedInstance].assignedTable1]];
    //NSURLRequest *request = [NSURLRequest requestWithURL:targetURL];
   // [webView  loadRequest:request];
   // [self.view addSubview:webView];
    
    NSURL *targetURL2 = [NSURL URLWithString:[NSString stringWithFormat:@"http://108.178.27.242/kinaraEx/printHTMLBill.php?tableid=%@",[ShareableData sharedInstance].assignedTable1]];
    NSURLRequest *request2 = [NSURLRequest requestWithURL:targetURL2];
    [billView  loadRequest:request2];
    
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
    [self loadWebView];
    taskType=0;
    [self getTaxesList];
    //ttt = @"0";
   ttt = [[self getDiscount] copy];
    v1.layer.cornerRadius=12.0;
    v2.layer.cornerRadius=12.0;
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
  /*  float t=0;
    
    if([[ShareableData sharedInstance].isTakeaway isEqualToString:@"1"])
    {
        for(int i=0;i<[[ShareableData sharedInstance].OrderItemName count];i++)
        {
            int q=[[[ShareableData sharedInstance].OrderItemQuantity objectAtIndex:i] intValue];
            float r=[[[ShareableData sharedInstance].OrderItemRate objectAtIndex:i] floatValue];
            t=t+q*r;
        }
    }
    else
    {
        for(int i=0;i<[[ShareableData sharedInstance].DishName count];i++)
        {
            int q=[[[ShareableData sharedInstance].DishQuantity objectAtIndex:i] intValue];
            float r=[[[ShareableData sharedInstance].DishRate objectAtIndex:i] floatValue];
            t=t+q*r;
        }
    }
    
    SubTotal.text=[NSString stringWithFormat:@"$%.2f",t];*/
    
//    float tt=0;
    TaxListValue=[[NSMutableArray alloc]init];
    
//    float amountafterdiscount=0;
    
   /* for(int i=0;i<[[ShareableData sharedInstance].TaxNameValue count];i++)
    {
        
        //int isDeduction=[[[ShareableData sharedInstance].isDeduction objectAtIndex:i] intValue];
        int isPercentage=[[[ShareableData sharedInstance].inFormat objectAtIndex:i] intValue];
        
        float v=[[[ShareableData sharedInstance].TaxNameValue objectAtIndex:i] floatValue];
        float cv;
        
        if(isPercentage==1)
        {
            cv=t*v/100;
        }
        else
        {
            cv=v;
        }
        
        NSString *string = [[ShareableData sharedInstance].TaxList objectAtIndex:i];
        if ([string rangeOfString:@"Discount"].location == NSNotFound) 
        {
            ;
        } 
        else 
        {
            //DLog(@"%@",[[ShareableData sharedInstance].TaxList objectAtIndex:i]);
            amountafterdiscount+=cv;
        }
    }
    
    amountafterdiscount=t-amountafterdiscount;
    DLog(@"Amount After Discount : %f",amountafterdiscount);
    
    
    for(int i=0;i<[[ShareableData sharedInstance].TaxNameValue count];i++)
    {
        int isDeduction=[[[ShareableData sharedInstance].isDeduction objectAtIndex:i] intValue];
        int isPercentage=[[[ShareableData sharedInstance].inFormat objectAtIndex:i] intValue];
        
        NSString *string = [[ShareableData sharedInstance].TaxList objectAtIndex:i];
        
        float v=[[[ShareableData sharedInstance].TaxNameValue objectAtIndex:i] floatValue];
        float cv;
        
        if(isPercentage==1)
        {
            if ([string rangeOfString:@"Discount"].location == NSNotFound) 
            {
                cv=amountafterdiscount*v/100;
            }
            else
            {
                cv=t*v/100;
            }
        }
        else
        {
            cv=v;
        }
        [TaxListValue addObject:[NSString stringWithFormat:@"%.2f",cv]];
        
        
        if ([string rangeOfString:@"Discount"].location == NSNotFound) 
        {
            if(isDeduction==0)//0-Add in total 1-Substratct from total
            {
                tt=tt+cv;
            }
            else
            {
                tt=tt-cv;
            }
        }
        
    }
    
    tt=tt+amountafterdiscount;
    float valueToRound = tt;
    int decimalPrecisionAtWhichToRound = 1;
    float scale = 10^decimalPrecisionAtWhichToRound;
    float tmp = valueToRound * scale;
    tmp = (float)((int)(tmp + 0.5));
    float roundedValue = tmp / scale;
    
    tt=roundedValue;*/

    Total.text=[self getTotal];
    SubTotal.text = [Total.text copy];
    
    lblTableNumber.text=[NSString stringWithFormat:@"Discount Table No. %@",tableNumber];
    
    NSDateFormatter *formatter;
    NSString        *dateString;
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd-MM-yyyy HH:mm"];
    dateString = [formatter stringFromDate:[NSDate date]];
    
    PaxNumber1=[ShareableData sharedInstance].OrderId;
    BillNumber1=PaxNumber1;
    
    DateAndTime1=dateString;
    
    BillNumber.text=[NSString stringWithFormat:@"Bill No : %@",BillNumber1];
    PaxNumber.text=[NSString stringWithFormat:@"Pax No : %@",PaxNumber1];
    DateAndTime.text=[NSString stringWithFormat:@"%@",DateAndTime1];
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
    if(tableView==TaxesTable)
        return [TaxListValue count];
    
    if([[ShareableData sharedInstance].isTakeaway isEqualToString:@"1"])
        return [[ShareableData sharedInstance].OrderItemName count];
    
    return [[ShareableData sharedInstance].DishName count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    //cell.textLabel.text=[ReportValues objectAtIndex:indexPath.row];
    
    if(tableView==TaxesTable)
    {
        UILabel *TaxName=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 330, 20)];
        TaxName.text= ([ShareableData sharedInstance].TaxList)[indexPath.row];;
        TaxName.textAlignment=UITextAlignmentLeft;
        TaxName.font=[UIFont boldSystemFontOfSize:18];
        TaxName.backgroundColor=[UIColor clearColor];
        [cell.contentView addSubview:TaxName];
        
        UILabel *TaxValue=[[UILabel alloc]initWithFrame:CGRectMake(400, 0, 150, 20)];
        TaxValue.text= [NSString stringWithFormat:@"$%@",TaxListValue[indexPath.row]];
        TaxValue.textAlignment=UITextAlignmentLeft;
        TaxValue.font=[UIFont boldSystemFontOfSize:18];
        TaxValue.backgroundColor=[UIColor clearColor];
        [cell.contentView addSubview:TaxValue];
    }
    else
    {
        UILabel *ItemName=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 270, 20)];
        if([[ShareableData sharedInstance].isTakeaway isEqualToString:@"1"])
            ItemName.text= ([ShareableData sharedInstance].OrderItemName)[indexPath.row];
        else
            ItemName.text= ([ShareableData sharedInstance].DishName)[indexPath.row];
        ItemName.textAlignment=UITextAlignmentLeft;
        ItemName.font=[UIFont boldSystemFontOfSize:18];
        [cell.contentView addSubview:ItemName];
        
        UILabel *ItemQuantity=[[UILabel alloc]initWithFrame:CGRectMake(280, 0, 50, 20)];
        if([[ShareableData sharedInstance].isTakeaway isEqualToString:@"1"])
            ItemQuantity.text= ([ShareableData sharedInstance].OrderItemQuantity)[indexPath.row];
        else
            ItemQuantity.text= ([ShareableData sharedInstance].DishQuantity)[indexPath.row];
        
        ItemQuantity.textAlignment=UITextAlignmentLeft;
        ItemQuantity.font=[UIFont boldSystemFontOfSize:18];
        [cell.contentView addSubview:ItemQuantity];
        
        UILabel *ItemRate=[[UILabel alloc]initWithFrame:CGRectMake(400, 0, 200, 20)];
        if([[ShareableData sharedInstance].isTakeaway isEqualToString:@"1"])
            ItemRate.text=[NSString stringWithFormat:@"$%@",([ShareableData sharedInstance].OrderItemRate)[indexPath.row]];
        else
            ItemRate.text=[NSString stringWithFormat:@"$%@",([ShareableData sharedInstance].DishRate)[indexPath.row]];
        ItemRate.textAlignment=UITextAlignmentLeft;
        ItemRate.font=[UIFont boldSystemFontOfSize:18];
        [cell.contentView addSubview:ItemRate];
    }
    return cell;
}

-(IBAction)PrintAndCheckoutButtonClick:(id)sender
{
    NSString *x1 = [t1.text stringByTrimmingCharactersInSet:
                    [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *x2 = [t2.text stringByTrimmingCharactersInSet:
                    [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *x3 = [t3.text stringByTrimmingCharactersInSet:
                    [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *x4 = [t4.text stringByTrimmingCharactersInSet:
                    [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *x5 = [t5.text stringByTrimmingCharactersInSet:
                    [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *x6 = [t6.text stringByTrimmingCharactersInSet:
                    [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *x7 = [t7.text stringByTrimmingCharactersInSet:
                    [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *x8 = [t8.text stringByTrimmingCharactersInSet:
                    [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *x9 = [t9.text stringByTrimmingCharactersInSet:
                    [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *x10 = [t10.text stringByTrimmingCharactersInSet:
                    [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *x11 = [t11.text stringByTrimmingCharactersInSet:
                    [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *x12 = [t12.text stringByTrimmingCharactersInSet:
                    [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *x13 = [t13.text stringByTrimmingCharactersInSet:
                    [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *x19 = [t19.text stringByTrimmingCharactersInSet:
                     [NSCharacterSet whitespaceAndNewlineCharacterSet]];

    if([x1 floatValue]==0 && [x2 floatValue]==0 && [x3 floatValue]==0 && [x4 floatValue]==0 && [x5 floatValue]==0 && [x6 floatValue]==0 && [x7 floatValue]==0 && [x8 floatValue]==0 && [x9 floatValue]==0 && [x10 floatValue]==0 && [x11 floatValue]==0 && [x12 floatValue]==0 && [x13 floatValue]==0)
    {
        UIAlertView *alert3=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Payment methods are empty" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert3 show];
    }else if ([x19 floatValue] < SubTotal.text.floatValue){
        UIAlertView *alert3=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Total entered value cannot be less than bill amount" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert3 show];
        
    }
    else
    {
        taskType=1;
        [self showIndicator];
    }
    
    
    
    //return data;
    
}

-(IBAction)Back:(id)sender
{
    taskType=2;
   
    //[self dismissModalViewControllerAnimated:NO];
    
    if([[ShareableData sharedInstance].isTakeaway isEqualToString:@"1"])
    {
        TakeWayEditOrder *SalesReport1=[[TakeWayEditOrder alloc]initWithNibName:@"TakeWayEditOrder" bundle:nil];
        //SalesReport1.tableNumber=tableNumber;
        //[self dismissModalViewControllerAnimated:NO];
        [self presentModalViewController:SalesReport1 animated:YES];
    }
    else
    {
        TabSquareTableStatus *SalesReport1=[[TabSquareTableStatus alloc]initWithNibName:@"TabSquareTableStatus" bundle:nil];
        SalesReport1.tableNumber=tableNumber;
        // [self dismissModalViewControllerAnimated:NO];
        [self presentModalViewController:SalesReport1 animated:YES];
    }
    
    
    //[self showIndicator];
}


-(IBAction)updateTotal
{
    
}
-(NSString*)getTotal{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://108.178.27.242/kinaraEx/getTotalAmount.php?tableid=%@",tableNumber]]];
    NSError *error;
    NSURLResponse *response;
    NSData *uData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSString *data=[[[NSString alloc]initWithData:uData encoding:NSUTF8StringEncoding]stringByTrimmingCharactersInSet:
    [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    return data;
    
}
-(NSString*)getDiscount{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://108.178.27.242/kinaraEx/getDiscountValue.php?tableid=%@",tableNumber]]];
    NSError *error;
    NSURLResponse *response;
    NSData *uData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSString *data=[[[NSString alloc]initWithData:uData encoding:NSUTF8StringEncoding]stringByTrimmingCharactersInSet:
                    [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    return data;
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if([self checkDigit:t1.text]==1 || [self checkDigit:t2.text]==1 || [self checkDigit:t3.text]==1 || [self checkDigit:t4.text]==1 || [self checkDigit:t5.text]==1 || [self checkDigit:t6.text]==1 || [self checkDigit:t7.text]==1 || [self checkDigit:t8.text]==1 || [self checkDigit:t9.text]==1 || [self checkDigit:t10.text]==1 || [self checkDigit:t11.text]==1 || [self checkDigit:t12.text]==1 || [self checkDigit:t13.text]==1 )
    {
        UIAlertView *alert3=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Invalid Amount Value!!!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert3 show];
    }
    else
    {
        float t21=[t1.text floatValue];
        float t22=[t2.text floatValue];
        float t33=[t3.text floatValue];
        float t44=[t4.text floatValue];
        float t55=[t5.text floatValue];
        float t66=[t6.text floatValue];
        float t77=[t7.text floatValue];
        float t88=[t8.text floatValue];
        float t99=[t9.text floatValue];
        float t100=[t10.text floatValue];
        float t111=[t11.text floatValue];
        float t222=[t12.text floatValue];
        float t333=[t13.text floatValue];
       
        float t999=[t19.text floatValue];
        t999= t21+t22+t33+t44+t55+t66+t77+t88+t99+t100+t111+t222+t333;
        t19.text=[NSString stringWithFormat:@"%.2f",t999];
    }
}


-(void)sendPayment:(NSString*)orderId PaymentMethodName:(NSString*)PaymentMethodName Amount:(NSString*)Amount
{
    NSString *post =[NSString stringWithFormat:@"table_id=%@&payment_name=%@&amount=%@",orderId,PaymentMethodName,Amount];
    
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"http://108.178.27.242/kinara/webs/set_payment"]];
    
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

-(void)sendDishes:(NSString*)orderId  ItemId:(NSString*)ItemId ItemName:(NSString*)ItemName Rate:(NSString*)Rate Quantity:(NSString*)Quantity tempid:(NSString*)tempid isOrderCust:(NSString*)isOrderCust orderCat:(NSString*)orderCat specialrequest:(NSString*)specialrequest
{
    NSString *post =[NSString stringWithFormat:@"table_id=%@&dish_id=%@&dish_name=%@&quantity=%@&price=%@&tempOrderId=%@&isOrderCustomisation=%@&orderCatId=%@&orderSpecialRequest=%@",orderId,ItemId,ItemName,Quantity,Rate,tempid,isOrderCust,orderCat,specialrequest];
    
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"http://108.178.27.242/kinara/webs/set_order_items"]];
    
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

-(void)sendCharges:(NSString*)orderId ChargeName:(NSString*)ChargeName Amount:(NSString*)Amount disc:(NSString*)disc
{
    NSString *post =[NSString stringWithFormat:@"charge_name=%@&value=%@&table_id=%@&disc=%@",ChargeName,Amount,orderId,disc];
    
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"http://108.178.27.242/kinara/webs/set_charges"]];
    
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


-(void)sendOther:(NSString*)orderId Pax:(NSString*)Pax Total1:(NSString*)Total1
{
    NSString *type=@"in";
    if([[ShareableData sharedInstance].isTakeaway isEqualToString:@"1"])
        type=@"Takeaway"; 
    else
        type=@"in";
    NSString *post =[NSString stringWithFormat:@"order_type=%@&pax=%@&total_amount=%@&table_id=%@&customer_id=%@",type,Pax,Total1,orderId,[ShareableData sharedInstance].isLogin];
    
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"http://108.178.27.242/kinara/webs/order_update"]];
    
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



-(void) showIndicator
{
    // [self loadWebView];
    UIView *progressView = [[UIView alloc]initWithFrame:CGRectMake(0,187, self.view.frame.size.width, self.view.frame.size.height)];
	progressHud= [[MBProgressHUD alloc] initWithView:progressView];
	[self.view addSubview:progressHud];
	[self.view bringSubviewToFront:progressHud];
	//progressHud.dimBackground = YES;
	progressHud.delegate = self;
    //progressHud.labelText = @"loading....";
	[progressHud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
    //[self printWebView];
}

- (void)myTask
{
    if(taskType==1)
    {
        
        
        if([self checkDigit:t1.text]==1 || [self checkDigit:t2.text]==1 || [self checkDigit:t3.text]==1 || [self checkDigit:t4.text]==1 || [self checkDigit:t5.text]==1 || [self checkDigit:t6.text]==1 || [self checkDigit:t7.text]==1 || [self checkDigit:t8.text]==1 || [self checkDigit:t9.text]==1 || [self checkDigit:t10.text]==1 || [self checkDigit:t11.text]==1 || [self checkDigit:t12.text]==1 || [self checkDigit:t13.text]==1 )
        {
            UIAlertView *alert3=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Invalid Amount Value!!!" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alert3 show];
            
            alterType=1;
        }
        else
        {
            
           // if([[ShareableData sharedInstance].isTakeaway isEqualToString:@"1"])
             //   tableNumber=@"1234";
            
            if([t1.text floatValue]>0)
                [self sendPayment:tableNumber PaymentMethodName:@"Cash" Amount:t1.text];
            if([t2.text floatValue]>0)
                [self sendPayment:tableNumber PaymentMethodName:@"Visa" Amount:t2.text];
            if([t3.text floatValue]>0)
                [self sendPayment:tableNumber PaymentMethodName:@"MasterCard" Amount:t3.text];
            if([t4.text floatValue]>0)
                [self sendPayment:tableNumber PaymentMethodName:@"Amex" Amount:t4.text];
            if([t5.text floatValue]>0)
                [self sendPayment:tableNumber PaymentMethodName:@"NETS" Amount:t5.text];
            if([t6.text floatValue]>0)
                [self sendPayment:tableNumber PaymentMethodName:@"SGDine" Amount:t6.text];
            if([t7.text floatValue]>0)
                [self sendPayment:tableNumber PaymentMethodName:@"JCB" Amount:t7.text];
            if([t8.text floatValue]>0)
                [self sendPayment:tableNumber PaymentMethodName:@"Diners" Amount:t8.text];
            if([t9.text floatValue]>0)
                [self sendPayment:tableNumber PaymentMethodName:@"Cheque" Amount:t9.text];
            if([t10.text floatValue]>0)
                [self sendPayment:tableNumber PaymentMethodName:@"Voucher" Amount:t10.text];
            if([t11.text floatValue]>0)
                [self sendPayment:tableNumber PaymentMethodName:@"HungryGoWhere" Amount:t11.text];
            if([t12.text floatValue]>0)
                [self sendPayment:tableNumber PaymentMethodName:@"Cuisine Express" Amount:t12.text];
            if([t13.text floatValue]>0)
                [self sendPayment:tableNumber PaymentMethodName:@"Room Service" Amount:t13.text];
                        
            
            for(int i=0;i<[[ShareableData sharedInstance].TaxNameValue count];i++)
            {
                
                [self sendCharges:tableNumber ChargeName:([ShareableData sharedInstance].TaxList)[i] Amount:([ShareableData sharedInstance].TaxNameValue)[i] disc:ttt];
            }
            
            if([[ShareableData sharedInstance].isTakeaway isEqualToString:@"1"])
            {
                for(int i=0;i<[[ShareableData sharedInstance].OrderItemName count];i++)
                {
                 /*[self sendDishes:tableNumber ItemId:[[ShareableData sharedInstance].OrderItemID objectAtIndex:i] ItemName: [[ShareableData sharedInstance].OrderItemName objectAtIndex:i] Rate:[[ShareableData sharedInstance].OrderItemRate objectAtIndex:i] Quantity:[[ShareableData sharedInstance].OrderItemQuantity objectAtIndex:i] :[[ShareableData sharedInstance].OrderItemQuantity objectAtIndex:i]];*/
                    
                    [self sendDishes:tableNumber ItemId:([ShareableData sharedInstance].OrderItemID)[i] ItemName:([ShareableData sharedInstance].OrderItemName)[i] Rate:([ShareableData sharedInstance].OrderItemRate)[i] Quantity:([ShareableData sharedInstance].OrderItemQuantity)[i] tempid:([ShareableData sharedInstance].TempOrderID)[i] isOrderCust:([ShareableData sharedInstance].IsOrderCustomization)[i] orderCat:([ShareableData sharedInstance].OrderCatId)[i] specialrequest:([ShareableData sharedInstance].OrderSpecialRequest)[i]];
                    
                    
                   
                } 
            }
            else
            {
                for(int i=0;i<[[ShareableData sharedInstance].DishName count];i++)
                {
                   // [self sendDishes:tableNumber ItemId:[[ShareableData sharedInstance].DishId objectAtIndex:i] ItemName:[[ShareableData sharedInstance].DishName objectAtIndex:i] Rate:[[ShareableData sharedInstance].DishRate objectAtIndex:i] Quantity:[[ShareableData sharedInstance].DishQuantity objectAtIndex:i]];
                    [self sendDishes:tableNumber ItemId:([ShareableData sharedInstance].DishId)[i] ItemName:([ShareableData sharedInstance].OrderItemName)[i] Rate:([ShareableData sharedInstance].DishRate)[i] Quantity:([ShareableData sharedInstance].OrderItemQuantity)[i] tempid:([ShareableData sharedInstance].TempOrderID)[i] isOrderCust:([ShareableData sharedInstance].IsOrderCustomization)[i] orderCat:([ShareableData sharedInstance].OrderCatId)[i] specialrequest:([ShareableData sharedInstance].OrderSpecialRequest)[i]];
                }
            }
            
            [self sendOther:tableNumber Pax:PaxNumber1 Total1:SubTotal.text];
            
            
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Thank you for visiting!!!!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alert show]; 
            alterType=2;
           
            
            [[ShareableData sharedInstance].OrderItemID removeAllObjects];
            [[ShareableData sharedInstance].OrderItemName removeAllObjects];
            [[ShareableData sharedInstance].OrderItemQuantity removeAllObjects];
            [[ShareableData sharedInstance].OrderItemRate removeAllObjects];
            [[ShareableData sharedInstance].OrderSpecialRequest removeAllObjects];
            [[ShareableData sharedInstance].OrderCustomizationDetail removeAllObjects];
            [[ShareableData sharedInstance].OrderCatId removeAllObjects];
            [[ShareableData sharedInstance].confirmOrder removeAllObjects];
            [[ShareableData sharedInstance].IsOrderCustomization removeAllObjects];
            [[ShareableData sharedInstance].TempOrderID removeAllObjects];
            
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://108.178.27.242/kinaraEx/printFullBillText.php?orderid=%@&tableid=%@",[ShareableData sharedInstance].OrderId,tableNumber]]];
            
//            NSError *error;
//            NSURLResponse *response;
//            NSData *uData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
       //     NSString *data=[[NSString alloc]initWithData:uData encoding:NSUTF8StringEncoding];
            
            [ShareableData sharedInstance].assignedTable1=@"-1";
            [ShareableData sharedInstance].assignedTable2=@"-1";
            [ShareableData sharedInstance].assignedTable3=@"-1";
            [ShareableData sharedInstance].assignedTable4=@"-1";
            
            [ShareableData sharedInstance].tableNumber=@"-1";
            [ShareableData sharedInstance].isLogin=@"0";
        }
    }
    else if(taskType==2)
    {
        if([[ShareableData sharedInstance].isTakeaway isEqualToString:@"1"])
        {
            TakeWayEditOrder *SalesReport1=[[TakeWayEditOrder alloc]initWithNibName:@"TakeWayEditOrder" bundle:nil];
            //SalesReport1.tableNumber=tableNumber;
            //[self dismissModalViewControllerAnimated:NO];
            [self presentModalViewController:SalesReport1 animated:YES];
        }
        else
        {
            TabSquareTableStatus *SalesReport1=[[TabSquareTableStatus alloc]initWithNibName:@"TabSquareTableStatus" bundle:nil];
            SalesReport1.tableNumber=tableNumber;
            // [self dismissModalViewControllerAnimated:NO];
            [self presentModalViewController:SalesReport1 animated:YES];
        }
        
    }
    
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alterType==2)
    {
      
        //[self dismissModalViewControllerAnimated:NO];
        TabSquareTableManagement *TableMgmt=[[TabSquareTableManagement alloc]initWithNibName:@"TabSquareTableManagement" bundle:nil];
        
        //TabSquareAssignTable *TableMgmt=[[TabSquareAssignTable alloc]initWithNibName:@"TabSquareAssignTable" bundle:nil];
        
        [self presentModalViewController:TableMgmt animated:YES];
        
        [[ShareableData sharedInstance].OrderItemID removeAllObjects];
        [[ShareableData sharedInstance].OrderItemName removeAllObjects];
        [[ShareableData sharedInstance].OrderItemQuantity removeAllObjects];
        [[ShareableData sharedInstance].OrderItemRate removeAllObjects];
        
        [[ShareableData sharedInstance].OrderSpecialRequest removeAllObjects];
        [[ShareableData sharedInstance].OrderCatId removeAllObjects];
        [[ShareableData sharedInstance].OrderBeverageContainerId removeAllObjects];
        [[ShareableData sharedInstance].OrderCustomizationDetail removeAllObjects];
        [[ShareableData sharedInstance].confirmOrder removeAllObjects];
        [[ShareableData sharedInstance].IsOrderCustomization removeAllObjects];
        
        
        [[ShareableData sharedInstance].TaxList removeAllObjects];
        [[ShareableData sharedInstance].TaxNameValue removeAllObjects];
        [[ShareableData sharedInstance].inFormat removeAllObjects];
        [[ShareableData sharedInstance].isDeduction removeAllObjects];
        
        [ShareableData sharedInstance].assignedTable1=@"-1";
        [ShareableData sharedInstance].assignedTable2=@"-1";
        [ShareableData sharedInstance].assignedTable3=@"-1";
        [ShareableData sharedInstance].assignedTable4=@"-1";
        
        //[[ShareableData sharedInstance] allocateArray];
       
       
    }
    
}

-(void)printItem 
{
    
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, YES, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.view.layer renderInContext:context];
    UIImage *imageFromCurrentView = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIPrintInteractionController *printController = [UIPrintInteractionController sharedPrintController];
    printController.printingItem = imageFromCurrentView;
    UIPrintInfo *printInfo = [UIPrintInfo printInfo];
    printInfo.outputType = UIPrintInfoOutputGrayscale;
    printController.printInfo = printInfo;
    printController.showsPageRange = YES;
    
    
    void (^completionHandler)(UIPrintInteractionController *, BOOL, NSError *) = ^(UIPrintInteractionController *printController, BOOL completed, NSError *error)
    {
        if (!completed && error) 
        {
           // DLog(@"FAILED! due to error in domain %@ with error code %u", error.domain, error.code);
        }
    };
    [printController presentAnimated:YES completionHandler:completionHandler];
    
} 



-(IBAction)PrintBill:(id)sender
{
    BillPrintPreview *billprintView=[[BillPrintPreview alloc]initWithNibName:@"BillPrintPreview" bundle:nil];
    [self presentModalViewController:billprintView animated:YES];
    [billprintView loadWebView];
   // [self  printhere];
}


-(void)printhere
{
    
   /*NSString *test1=@"kalim";
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
    
    NSData    *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://108.178.27.242/kinara/webs/printable/%@",[ShareableData sharedInstance].assignedTable1]]];          
    
//    NSURL *url=[NSURL URLWithString:@"http://108.178.27.242/kinara/webs/printable/2"];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"done" ofType:@"png"];
    NSData *myData = [NSData dataWithContentsOfFile: path];    
    
   /*UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, YES, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.view.layer renderInContext:context];
    UIImage *imageFromCurrentView = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();*/
    
    if([UIPrintInteractionController canPrintData:myData])
    {
        DLog(@"print item");
    }
    
    UIPrintInteractionController *printController = [UIPrintInteractionController sharedPrintController];
    printController.delegate=self;
    printController.printingItem = imageData;
    UIPrintInfo *printInfo = [UIPrintInfo printInfo];
    printInfo.outputType = UIPrintInfoOutputGeneral;
    printController.printInfo = printInfo;
    printController.showsPageRange = YES;
    
    
    void (^completionHandler)(UIPrintInteractionController *, BOOL, NSError *) = ^(UIPrintInteractionController *printController, BOOL completed, NSError *error) {
        if (!completed && error)
        {
           // DLog(@"FAILED! due to error in domain %@ with error code %u", error.domain, error.code);
        }
    };
    
    [printController presentAnimated:YES completionHandler:completionHandler];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    if (CGRectContainsPoint([self.t1 frame], [touch locationInView:self.view])
        ||CGRectContainsPoint([self.t2 frame], [touch locationInView:self.view])
        ||CGRectContainsPoint([self.t3 frame], [touch locationInView:self.view])
        ||CGRectContainsPoint([self.t4 frame], [touch locationInView:self.view])
        ||CGRectContainsPoint([self.t5 frame], [touch locationInView:self.view])
        ||CGRectContainsPoint([self.t6 frame], [touch locationInView:self.view])
        ||CGRectContainsPoint([self.t7 frame], [touch locationInView:self.view])
        ||CGRectContainsPoint([self.t8 frame], [touch locationInView:self.view])
        ||CGRectContainsPoint([self.t9 frame], [touch locationInView:self.view])
        ||CGRectContainsPoint([self.t10 frame], [touch locationInView:self.view])
        ||CGRectContainsPoint([self.t11 frame], [touch locationInView:self.view])
        ||CGRectContainsPoint([self.t12 frame], [touch locationInView:self.view])
        ||CGRectContainsPoint([self.t13 frame], [touch locationInView:self.view])
        ||CGRectContainsPoint([self.t19 frame], [touch locationInView:self.view])
        )
    {
        
    }
    else
    {
        [t1 resignFirstResponder];
        [t2 resignFirstResponder];
        [t3 resignFirstResponder];
        [t4 resignFirstResponder];
        [t5 resignFirstResponder];
        [t6 resignFirstResponder];
        [t7 resignFirstResponder];
        [t8 resignFirstResponder];
        [t9 resignFirstResponder];
        [t10 resignFirstResponder];
        [t11 resignFirstResponder];
        [t12 resignFirstResponder];
        [t13 resignFirstResponder];
        [t19 resignFirstResponder];
    }
}

-(NSInteger)checkDigit:(NSString*)amount
{
    int j=0;
    int pp=0;
    
    for (int i=0;i<[amount length];i++) 
    {
        
        char c = [amount characterAtIndex:i];
        if(c=='.')
        {
            pp++;
        }
    }
    
    if(pp<=1)
    {
        for (int i=0;i<[amount length];i++) 
        {
            
            char c = [amount characterAtIndex:i];
            //DLog(@"%c",c);
            if(!(c=='0' || c=='1' || c=='2'|| c=='3'|| c=='4'|| c=='5'|| c=='6'|| c=='7'|| c=='8'|| c=='9'||c=='.'))
            {
                j=1;
            }
        }
    }
    else
    {
        j=1;
    }
    return j;
}

-(void)getTableTaxDetails
{
    NSString *post =[NSString stringWithFormat:@"table=%@",tableNumber];
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"http://108.178.27.242/kinara/webs/get_temp_charges"]];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/x-www-form-urlencoded charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSError *error;
    NSURLResponse *response;
    NSData *uData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSString *data=[[NSString alloc]initWithData:uData encoding:NSUTF8StringEncoding];
   // DLog(@"Data :%@",data);
    
    SBJSON *parser = [[SBJSON alloc] init];
    NSMutableArray *resultFromPost = [parser objectWithString:data error:nil];
    //DLog(@"Data :%@",resultFromPost);
    for(int i=0;i<[resultFromPost count];i++)
    {
        NSMutableDictionary *dataitem=resultFromPost[i];
        [[ShareableData sharedInstance].TaxList addObject:[NSString stringWithFormat:@"%@",dataitem[@"charge_name"]]];
        [[ShareableData sharedInstance].TaxNameValue addObject:[NSString stringWithFormat:@"%@",dataitem[@"value"]]];
        [[ShareableData sharedInstance].inFormat addObject:[NSString stringWithFormat:@"%@",dataitem[@"in_format"]]];
        [[ShareableData sharedInstance].isDeduction addObject:[NSString stringWithFormat:@"%@",dataitem[@"is_deduction"]]];
    }
}

-(void)getTaxesList
{
    if([[ShareableData sharedInstance].isTakeaway isEqualToString:@"0"])
    {
        [[ShareableData sharedInstance].TaxList removeAllObjects];
        [[ShareableData sharedInstance].TaxNameValue removeAllObjects];
        [[ShareableData sharedInstance].inFormat removeAllObjects];
        [[ShareableData sharedInstance].isDeduction removeAllObjects];
        
        NSString *post =[NSString stringWithFormat:@""];
        NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        
        NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:@"http://108.178.27.242/kinara/webs/get_charges"]];
        
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [request setValue:@"application/x-www-form-urlencoded charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
        
        NSError *error;
        NSURLResponse *response;
        NSData *uData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        NSString *data=[[NSString alloc]initWithData:uData encoding:NSUTF8StringEncoding];
        
        SBJSON *parser = [[SBJSON alloc] init];
        NSMutableArray *resultFromPost = [parser objectWithString:data error:nil];
        // DLog(@"Data :%@",resultFromPost);
        
        for(int i=0;i<[resultFromPost count];i++)
        {
            NSMutableDictionary *dataitem=resultFromPost[i];
            [[ShareableData sharedInstance].TaxList addObject:[NSString stringWithFormat:@"%@",dataitem[@"name"]]];
            [[ShareableData sharedInstance].TaxNameValue addObject:[NSString stringWithFormat:@"%@",dataitem[@"value"]]];
            [[ShareableData sharedInstance].inFormat addObject:[NSString stringWithFormat:@"%@",dataitem[@"is_percent"]]];
            [[ShareableData sharedInstance].isDeduction addObject:[NSString stringWithFormat:@"%@",dataitem[@"is_deduction"]]];
        }
        
        [self getTableTaxDetails];
    }
}



@end
