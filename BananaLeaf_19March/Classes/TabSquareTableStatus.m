//
//  TabSquareTableStatus.m
//  TabSquareMenu
//
//  Created by Nikhil Kumar on 8/9/12.
//  Copyright (c) 2012 Trendsetterz. All rights reserved.
//

#import "TabSquareTableStatus.h"
#import "AddDiscount.h"
#import "EditOrder.h"
#import <QuartzCore/CALayer.h>
#import "TabSquareTableManagement.h"
//#import "PrintBillAndCheckOut.h"
#import "PrintBillAndCheckOutFinal.h"
#import "EditOrder.h"
#import "TabSquareDBFile.h"
#import "ShareableData.h"
#import "SBJSON.h"
#import "TabSquareMenuController.h"
#import "TabSquareHomeController.h"
#import "BillPrintPreview.h"

@implementation TabSquareTableStatus

@synthesize noOfGuest,guestName,guestlastVisit,guestMonthVisit;
@synthesize timelastOrder,timeAssigned,tableNumber,lblTableNumber,ReportSummaryTable,v1,salesNo;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)checkForWIFIConnection {
    Reachability* wifiReach = [Reachability reachabilityForLocalWiFi];
    
    NetworkStatus netStatus = [wifiReach currentReachabilityStatus];
    
    if (netStatus!=ReachableViaWiFi)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"No WIFI available!", @"AlertView")
                                                            message:NSLocalizedString(@"You have no wifi connection available. Please connect to a WIFI network.", @"AlertView")
                                                           delegate:self
                                                  cancelButtonTitle:NSLocalizedString(@"Cancel", @"AlertView")
                                                  otherButtonTitles:NSLocalizedString(@"Check Your Settings", @"AlertView"), nil];
        [alertView show];
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        // [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=AIRPLANE_MODE"]];
        NSURL*url=[NSURL URLWithString:@"prefs:root=WIFI"];
        [[UIApplication sharedApplication] openURL:url];
    }
}

-(void)roundLabelCorner
{
    noOfGuest.layer.cornerRadius=10.0;
    guestName.layer.cornerRadius=10.0;
    guestlastVisit.layer.cornerRadius=10.0;
    guestMonthVisit.layer.cornerRadius=10.0;
    timeAssigned.layer.cornerRadius=10.0;
    timelastOrder.layer.cornerRadius=10.0;
}
-(void)getSalesNumber:(NSString*)SearchTableNumber
{
    NSString *post =[NSString stringWithFormat:@"table_id=%@&key=%@",SearchTableNumber, [ShareableData appKey]];
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    NSString *url_string = [NSString stringWithFormat:@"%@/webs/get_temp_sales_id", [ShareableData serverURL]];
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
    
    [ShareableData sharedInstance].salesNo=data;
    [ShareableData sharedInstance].splitNo = @"0";
    DLog(@"Bill Number :%@",data);
    
}
-(void)voidRaptor
{
    NSString *post =[NSString stringWithFormat:@"POSID=%@&OperatorNo=%@&TableNo=%@&SalesNo=%@&SplitNo=%@",@"POS011",@"1",tableNumber,[ShareableData sharedInstance].salesNo,@"0"];
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"http://192.168.1.90/Raptor/AllVoid.php"]];
    
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

- (void)viewDidLoad
{
    [ShareableData sharedInstance].AddItemFromTakeaway=@"0";
    
    [[ShareableData sharedInstance].OrderItemID removeAllObjects];
    [[ShareableData sharedInstance].OrderItemName removeAllObjects];
    [[ShareableData sharedInstance].OrderItemQuantity removeAllObjects];
    [[ShareableData sharedInstance].OrderItemRate removeAllObjects];
    
    [[ShareableData sharedInstance].OrderSpecialRequest removeAllObjects];
    [[ShareableData sharedInstance].OrderCatId removeAllObjects];
    //[[ShareableData sharedInstance].OrderBeverageContainerId removeAllObjects];
    [[ShareableData sharedInstance].OrderCustomizationDetail removeAllObjects];
    [[ShareableData sharedInstance].confirmOrder removeAllObjects];
    [[ShareableData sharedInstance].IsOrderCustomization removeAllObjects];
    
    taskType=0;
    [self getSalesNumber:tableNumber];
    
   // lblTableNumber.text=tableNumber;
    
    v1.layer.cornerRadius=12.0;
    
    [self roundLabelCorner];
    [super viewDidLoad];
    lblTableNumber.text=tableNumber;
    
    if (tableNumber.intValue > 1233){
        lblTableNumber.text = [NSString stringWithFormat:@"TA%d",(tableNumber.intValue - 1233)];
    }
    
    
    //[self getTaxesList];
    // Do any additional setup after loading the view from its nib.
   // [self getCustomerDetails:tableNumber];
   // lblTableNumber.text=tableNumber;
  //  [self getTableDetails:tableNumber]; //Change
    //[self getTableDetails:[ShareableData sharedInstance].selectedTableNumberFordetail]; //Change
   
}


-(void)viewWillAppear:(BOOL)animated
{
    [self getBackgroundImage];

    [self checkForWIFIConnection];
    DLog(@"%@",tableNumber);
    lblTableNumber.text=tableNumber;
    if (tableNumber.intValue > 1233){
        lblTableNumber.text = [NSString stringWithFormat:@"TA%d",(tableNumber.intValue - 1233)];
    }
    [self getCustomerDetails:tableNumber];
    [self getTableDetails:tableNumber];
    //[self getTableDetails:tableNumber];
    
}



-(void)getBillNumber:(NSString*)SearchTableNumber
{
    NSString *post =[NSString stringWithFormat:@"table_id=%@&key=%@",SearchTableNumber, [ShareableData appKey]];
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    NSString *url_string = [NSString stringWithFormat:@"%@/webs/get_temp_order_id", [ShareableData serverURL]];
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
    
    [ShareableData sharedInstance].OrderId=data;
    //NSLOG(@"Bill Number :%@",data);

}

-(void)getTableDetails:(NSString*)SearchTableNumber
{
    DLog(@"Table Number : %@",SearchTableNumber);
    
    [self getBillNumber:SearchTableNumber];
    
    [ShareableData sharedInstance].assignedTable1=SearchTableNumber;
    
    [[ShareableData sharedInstance].DishId removeAllObjects];
    [[ShareableData sharedInstance].DishName removeAllObjects];
    [[ShareableData sharedInstance].DishQuantity removeAllObjects];
    [[ShareableData sharedInstance].DishRate removeAllObjects];
    [[ShareableData sharedInstance].TempOrderID removeAllObjects];
    
    [[ShareableData sharedInstance].TDishName removeAllObjects];
    [[ShareableData sharedInstance].TDishQuantity removeAllObjects];
    [[ShareableData sharedInstance].TDishRate removeAllObjects];
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
    
    NSString *post =[NSString stringWithFormat:@"table_id=%@",SearchTableNumber];
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"http://192.168.1.90/central/webs/get_temp_order"]];
    
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
    DLog(@"Data from GetTable :%@",resultFromPost);
    
    
    for(int i=0;i<[resultFromPost count];i++)
    {
        NSMutableDictionary *dataitem=resultFromPost[i];
        
        [[ShareableData sharedInstance].DishId addObject:[NSString stringWithFormat:@"%@",dataitem[@"dish_id"]]];
        [[ShareableData sharedInstance].DishName addObject:[NSString stringWithFormat:@"%@",dataitem[@"dish_name"]]];
        [[ShareableData sharedInstance].DishQuantity addObject:[NSString stringWithFormat:@"%@",dataitem[@"quantity"]]];
        [[ShareableData sharedInstance].TempOrderID addObject:[NSString stringWithFormat:@"%@",dataitem[@"id"]]];
        
        //        NSString *quantity=[NSString stringWithFormat:@"%@",dataitem[@"quantity"]];
        //        int qquantity=[quantity intValue];
        //        NSString *price=[NSString stringWithFormat:@"%@",dataitem[@"price"]];
        //        float fprice=[price floatValue]/qquantity;
        
        [[ShareableData sharedInstance].DishRate addObject:dataitem[@"price"]];
        //[[ShareableData sharedInstance].DishRate addObject:[NSString stringWithFormat:@"%@",[dataitem objectForKey:@"price"]]];
        
        [[ShareableData sharedInstance].OrderItemID addObject:[NSString stringWithFormat:@"%@",dataitem[@"dish_id"]]];
        [[ShareableData sharedInstance].OrderItemName addObject:[NSString stringWithFormat:@"%@",dataitem[@"dish_name"]]];
        [[ShareableData sharedInstance].OrderItemQuantity addObject:[NSString stringWithFormat:@"%@",dataitem[@"quantity"]]];
        [[ShareableData sharedInstance].OrderItemRate addObject:[NSString stringWithFormat:@"%@",dataitem[@"price"]]];
        
        [[ShareableData sharedInstance].confirmOrder addObject:[NSString stringWithFormat:@"%@",dataitem[@"1"]]];
        
        
        
        NSArray* customString = [[NSString stringWithFormat:@"%@",dataitem[@"customisations"]] componentsSeparatedByString:@"^"];
        
        [[ShareableData sharedInstance].IsOrderCustomization addObject:[NSString stringWithFormat:@"%@",dataitem[@"is_order_customisation"]]];
        
        //[[ShareableData sharedInstance].IsOrderCustomization addObject:[NSString stringWithFormat:@"%@",[dataitem objectForKey:@"is_order_customisation"]]];
        
        NSString *trimmedString = [[NSString stringWithFormat:@"%@",dataitem[@"order_cat_id"]] stringByTrimmingCharactersInSet:
                                   [NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        [[ShareableData sharedInstance].OrderCatId addObject:trimmedString];
        [[ShareableData sharedInstance].OrderSpecialRequest addObject:[NSString stringWithFormat:@"%@",dataitem[@"order_special_request"]]];
        NSString *orderId = dataitem[@"dish_id"];
        if ([customString count]>1){
            NSMutableArray *tempCust= [[NSMutableArray alloc]init];
            
            /*  DLog(@"WTF1: %@",tempCust);
             if([trimmedString isEqualToString:@"8"])
             {
             //  [[TabSquareDBFile sharedDatabase] openDatabaseConnection];
             NSString *temp=[[TabSquareDBFile sharedDatabase]getBeverageId:orderId];
             //  [[TabSquareDBFile sharedDatabase] closeDatabaseConnection];
             if (temp.intValue != 0){
             orderId = [temp copy];
             }
             }*/
            
            
            // [[TabSquareDBFile sharedDatabase] openDatabaseConnection];
            //  NSMutableArray *resultFromPostt=[[TabSquareDBFile sharedDatabase]getDishDataDetail:[NSString stringWithFormat:@"%@",orderId]];
            // NSMutableDictionary *dataitm2 = resultFromPostt[0];
            //DLog(@"Data FOr Dish :%@",resultFromPostt);
            // [tempCust addObject:dataitm2[@"customisations"]];
            // [[TabSquareDBFile sharedDatabase] closeDatabaseConnection];
            //  NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            //  [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://192.168.1.90/kinaraEx/getOptions.php?tempid=%@",dataitem[@"id"]]]];
            
            // NSError *error;
            //   NSURLResponse *response;
            //   NSData *uData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
            //  NSString *data=[[NSString alloc]initWithData:uData encoding:NSUTF8StringEncoding];
            //  NSArray *stringArray = [data componentsSeparatedByString: @","];
            NSMutableArray *customizationDetail=[[NSMutableArray alloc]init];
            for(int i=0;i<[customString count]-1;i++)
            {
                //NSMutableDictionary *dataitem=DishC[i][0];
                NSMutableDictionary *customizations=customString[i];
                
                NSMutableDictionary *cust=[NSMutableDictionary dictionary];
                cust[@"Customisation"] = customizations;
                cust[@"Option"] = customString[i];
                [customizationDetail addObject:cust];
                
                
            }
            [[ShareableData sharedInstance].OrderCustomizationDetail addObject:customizationDetail];
            DLog(@"WTF: %@",customizationDetail);
        }else{
            [[ShareableData sharedInstance].OrderCustomizationDetail addObject:[NSString stringWithFormat:@"%@",dataitem[@"order_customisation_detail"]]];
        }
        
        
        
        
        DLog(@"dish_id = %@",dataitem[@"dish_id"]);
        DLog(@"dish_name = %@",dataitem[@"dish_name"]);
        DLog(@"quantity = %@",dataitem[@"quantity"]);
        DLog(@"price = %@",dataitem[@"price"]);
        
        DLog(@"order_special_request = %@",dataitem[@"order_special_request"]);
        DLog(@"order_customisation_detail = %@",dataitem[@"order_customisation_detail"]);
        // DLog(@"order_beverage_container_id = %@",[dataitem objectForKey:@"order_beverage_container_id"]);
        DLog(@"order_cat_id = %@",dataitem[@"order_cat_id"]);
        DLog(@"confirm_order = %@",dataitem[@"confirm_order"]);
        DLog(@"is_order_customisation = %@",dataitem[@"is_order_customisation"]);
        
        [[ShareableData sharedInstance].TDishName addObject:[NSString stringWithFormat:@"%@",dataitem[@"dish_name"]]];
        [[ShareableData sharedInstance].TDishQuantity addObject:[NSString stringWithFormat:@"%@",dataitem[@"quantity"]]];
        [[ShareableData sharedInstance].TDishRate addObject:[NSString stringWithFormat:@"%@",dataitem[@"price"]]];
    }
    
    [ReportSummaryTable reloadData];
}
-(NSMutableArray*)getSelectedCustomization:(NSMutableArray*)DishC
{
    NSMutableArray *customizationDetail=[[NSMutableArray alloc]init];
    for(int i=0;i<[DishC count];++i)
    {
        NSMutableDictionary *dataitem=DishC[i][0];
        NSMutableDictionary *customizations=dataitem[@"Customisation"];
        NSMutableArray *Option=dataitem[@"Option"];
        NSMutableArray *optionData=[[NSMutableArray alloc]init];
        for(int j=0;j<[Option count];++j)
        {
            NSMutableDictionary *optionDic=Option[j];
            NSString *quantity=optionDic[@"quantity"];
            if([quantity intValue]>=1)
            {
                [optionData addObject:optionDic];
            }
        }
        if([optionData count]!=0)
        {
            NSMutableDictionary *cust=[NSMutableDictionary dictionary];
            cust[@"Customisation"] = customizations;
            cust[@"Option"] = optionData;
            [customizationDetail addObject:cust];
        }
        
    }
    return customizationDetail;
    //DLog(@"%@",[[ShareableData sharedInstance]OrderCustomizationDetail]);
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


-(IBAction)discountClicked:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Please enter password"
                                                   delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
	alert.alertViewStyle = UIAlertViewStyleSecureTextInput;
    UITextField * alertTextField = [alert textFieldAtIndex:0];
    alertTextField.keyboardType = UIKeyboardTypeNumberPad;
    alert.tag=1501;
    [alert show];

    
}
-(IBAction)previewBill:(id)sender
{
    [ShareableData sharedInstance].ViewMode = 1;
    BillPrintPreview *billprintView=[[BillPrintPreview alloc]initWithNibName:@"BillPrintPreview" bundle:nil];
    billprintView.tableNumber = tableNumber;
    [self.navigationController pushViewController:billprintView animated:NO];
    [billprintView loadWebView];
    
    
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Please enter password"
//                                                   delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
//	alert.alertViewStyle = UIAlertViewStyleSecureTextInput;
//    UITextField * alertTextField = [alert textFieldAtIndex:0];
//    alertTextField.keyboardType = UIKeyboardTypeNumberPad;
//    alert.tag=1503;
//    [alert show];

}


-(IBAction)editOrderClicked:(id)sender
{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Please enter password"
                                                   delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
	alert.alertViewStyle = UIAlertViewStyleSecureTextInput;
    UITextField * alertTextField = [alert textFieldAtIndex:0];
    alertTextField.keyboardType = UIKeyboardTypeNumberPad;
    alert.tag=1500;
    [alert show];
    
}

-(IBAction)checkOutClicked:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Please enter password"
                                                   delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
	alert.alertViewStyle = UIAlertViewStyleSecureTextInput;
    UITextField * alertTextField = [alert textFieldAtIndex:0];
    alertTextField.keyboardType = UIKeyboardTypeNumberPad;
    alert.tag=1502;
    [alert show];

}

-(IBAction)Back:(id)sender
{
    taskType=2;
    //[self dismissViewControllerAnimated:];
   // [self dismissViewControllerAnimated:NO completion:nil];
    [self showIndicator];
}

#pragma mark Table view methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[ShareableData sharedInstance].DishQuantity count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    //cell.textLabel.text=[ReportValues objectAtIndex:indexPath.row];
    
    UILabel *ItemName=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 270, 20)];
    ItemName.text= ([ShareableData sharedInstance].DishName)[indexPath.row];;
    ItemName.textAlignment=UITextAlignmentLeft;
    ItemName.font=[UIFont boldSystemFontOfSize:18];
    [cell.contentView addSubview:ItemName];
    
    UILabel *ItemQuantity=[[UILabel alloc]initWithFrame:CGRectMake(280, 0, 50, 20)];
    ItemQuantity.text= ([ShareableData sharedInstance].DishQuantity)[indexPath.row];;
    ItemQuantity.textAlignment=UITextAlignmentLeft;
    ItemQuantity.font=[UIFont boldSystemFontOfSize:18];
    [cell.contentView addSubview:ItemQuantity];
    
    UILabel *ItemRate=[[UILabel alloc]initWithFrame:CGRectMake(400, 0, 200, 20)];
    ItemRate.text=[NSString stringWithFormat:@"$%@",([ShareableData sharedInstance].DishRate)[indexPath.row]];
    ItemRate.textAlignment=UITextAlignmentLeft;
    ItemRate.font=[UIFont boldSystemFontOfSize:18];
    [cell.contentView addSubview:ItemRate];
    
    return cell;
}

-(void)getCustomerDetails:(NSString*)tableNumber1
{
    
    NSString *post =[NSString stringWithFormat:@"table=%@&key=%@",tableNumber1, [ShareableData appKey]];
    
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    NSString *url_string = [NSString stringWithFormat:@"%@/webs/get_client_status", [ShareableData serverURL]];
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
    
   // DLog(@"Customer details : %@",data);
    
    SBJSON *parser = [[SBJSON alloc] init];
    NSMutableArray *resultFromPost = [parser objectWithString:data error:nil];
   // DLog(@"Data :%@",resultFromPost);
    
    
    for(int i=0;i<[resultFromPost count];i++)
    {
        NSMutableDictionary *dataitem=resultFromPost[i];
        //NSLOG(@"dataitem===%@",dataitem);
        guestName.text=dataitem[@"guest_name"];
        noOfGuest.text=[NSString stringWithFormat:@"%@", dataitem[@"total_guests"]];
        guestlastVisit.text=dataitem[@"last_visit"];
        guestMonthVisit.text=dataitem[@"total_visits"];
        timeAssigned.text=dataitem[@"since_time"];
        timelastOrder.text=dataitem[@"order_since"];
        
    }
    
    
}


-(IBAction)gotoDishMenuLIst:(id)sender
{
    taskType=1;
    
    [self showIndicator];
}

-(void) showIndicator
{
   // UIView *progressView = [[[UIView alloc]initWithFrame:CGRectMake(0,187, self.view.frame.size.width, self.view.frame.size.height)]autorelease];
	//progressHud= [[MBProgressHUD alloc] initWithView:progressView];
	//[self.view addSubview:progressHud];
	//[self.view bringSubviewToFront:progressHud];
	//progressHud.dimBackground = YES;
	//progressHud.delegate = self;
    //progressHud.labelText = @"loading....";
    [self myTask];
	//[progressHud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
}
-(IBAction)voidTableNow:(id)sender{
    
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Please enter password"
                                                   delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
	alert.alertViewStyle = UIAlertViewStyleSecureTextInput;
    UITextField * alertTextField = [alert textFieldAtIndex:0];
    alertTextField.keyboardType = UIKeyboardTypeNumberPad;
    alert.tag=211;
    [alert show];
    
    

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

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
        
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    UITextField *password = [alertView textFieldAtIndex:0];
    

    if([title isEqualToString:@"OK"] && alertView.tag==211 && [password.text isEqualToString:@"1234"])
    {
         //BOOL authenticate=[self AuthenticateWater:password.text];
        
        //BOOL authenticate=[ShareableData hasAccess:password.text level:VOID_TABLE];///for user level method use thid check
        
           
            
            DLog(@"orderid is : %@",[ShareableData sharedInstance].OrderId);
            [self voidRaptor];
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@Ex/resetTable.php?tableid=%@&orderid=%@&waiter=%@&key=%@", [ShareableData serverURL],tableNumber,[ShareableData sharedInstance].OrderId,password.text, [ShareableData appKey] ]]];
            
            NSError *error;
            NSURLResponse *response;
            NSData *uData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
            NSString *data=[[NSString alloc]initWithData:uData encoding:NSUTF8StringEncoding];
            // TabSquareTableManagement *TableMgmt=[[TabSquareTableManagement alloc]initWithNibName:@"TabSquareTableManagement" bundle:nil];
            
            //TabSquareAssignTable *TableMgmt=[[TabSquareAssignTable alloc]initWithNibName:@"TabSquareAssignTable" bundle:nil];
            
            [self.navigationController popToRootViewControllerAnimated:YES];
            
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
            
            [ShareableData sharedInstance].tableNumber=@"-1";

            
        
       
        
    }
    

    
    else if([title isEqualToString:@"OK"] && alertView.tag==1500) {
        
//        BOOL authenticate=[ShareableData hasAccess:password.text level:VOID_ITEM];
//
//        if (authenticate){
//            taskType=4;
//            [self showIndicator];
//        }
        
        if ([password.text isEqualToString:@"1234"]) {
            taskType=4;
            [self showIndicator];
        }
        else{
            
        }
    }
    
    else if([title isEqualToString:@"OK"] && alertView.tag==1501) {
        
        BOOL authenticate=[ShareableData hasAccess:password.text level:MODIFY_DISCOUNTS];
        
        if (authenticate){
            taskType=5;
            [self showIndicator];
        }
    }

    else if([title isEqualToString:@"OK"] && alertView.tag==1502) {
        
        BOOL authenticate=[ShareableData hasAccess:password.text level:CHECKOUT];
        
        if (authenticate){
            taskType=3;
            [self showIndicator];
        }
    }
    
    else if([title isEqualToString:@"OK"] && alertView.tag==1503) {
        
//        BOOL authenticate=[ShareableData hasAccess:password.text level:PRESENT_BILL];
//        
//        if (authenticate){
//            [ShareableData sharedInstance].ViewMode = 1;
//            BillPrintPreview *billprintView=[[BillPrintPreview alloc]initWithNibName:@"BillPrintPreview" bundle:nil];
//            billprintView.tableNumber = tableNumber;
//            [self.navigationController pushViewController:billprintView animated:NO];
//            [billprintView loadWebView];
//            // [self  printhere];
//       }
        
        
        if ([password.text isEqualToString:@"1234"]) {
            [ShareableData sharedInstance].ViewMode = 1;
            BillPrintPreview *billprintView=[[BillPrintPreview alloc]initWithNibName:@"BillPrintPreview" bundle:nil];
            billprintView.tableNumber = tableNumber;
            [self.navigationController pushViewController:billprintView animated:NO];
            [billprintView loadWebView];
        }
        else{
            
        }
    }

        
         
}

- (void)myTask
{
    if(taskType==1)
    {
        if([[ShareableData sharedInstance].isConfromHomePage isEqualToString:@"1"])
        {
            //[self dismissModalViewControllerAnimated:NO];
            TabSquareMenuController *TableMgmt=[[TabSquareMenuController alloc]initWithNibName:@"TabSquareMenuController" bundle:nil];
            [self.navigationController pushViewController:TableMgmt animated:YES];
            
        }
        else 
        {
            // [self dismissModalViewControllerAnimated:NO];
            TabSquareHomeController *TableMgmt=[[TabSquareHomeController alloc]initWithNibName:@"TabSquareHomeController" bundle:nil];
            [self.navigationController pushViewController:TableMgmt animated:YES];
            
        }
    }
    else if(taskType==2)
    {
        //TabSquareTableManagement *SalesReport1=[[TabSquareTableManagement alloc]initWithNibName:@"TabSquareTableManagement" bundle:nil];
        // [self dismissModalViewControllerAnimated:NO];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else if(taskType==3)
    {
        [ShareableData sharedInstance].isTakeaway=@"0";
        PrintBillAndCheckOutFinal *SalesReport1=[[PrintBillAndCheckOutFinal alloc]initWithNibName:@"PrintBillAndCheckOutFinal" bundle:nil];
        SalesReport1.tableNumber=tableNumber;
        //[self dismissModalViewControllerAnimated:NO];
        [self.navigationController pushViewController:SalesReport1 animated:YES];
    }
    else if(taskType==4)
    {
        EditOrder *SalesReport1=[[EditOrder alloc]initWithNibName:@"EditOrder" bundle:nil];
        [ShareableData sharedInstance].tableNumber=tableNumber;
        SalesReport1.tableNumber=tableNumber;
        //[self dismissModalViewControllerAnimated:NO];
        [self.navigationController pushViewController:SalesReport1 animated:YES];
    }
    else if(taskType==5)
    {
        AddDiscount *SalesReport1=[[AddDiscount alloc]initWithNibName:@"AddDiscount" bundle:nil];
        SalesReport1.tableNumber=tableNumber;
        // [self dismissModalViewControllerAnimated:NO];
        [self.navigationController pushViewController:SalesReport1 animated:YES];
    }
            
    
}


@end
