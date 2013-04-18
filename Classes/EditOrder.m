//
//  EditOrder.m
//  TabSquareMenu
//
//  Created by Nikhil Kumar on 10/08/12.
//  Copyright (c) 2012 Trendsetterz. All rights reserved.
//

#import "EditOrder.h"
#import "AddDiscount.h"
//#import "PrintBillAndCheckOut.h"
#import "TabSquareTableStatus.h"
#import "ShareableData.h"
#import "SBJSON.h"
#import "TabSquareDBFile.h"
#import "TabSquareMenuController.h"
#import "TabSquareHomeController.h"
#import <QuartzCore/CALayer.h>
float totalPriceMinusDrinks;
@interface EditOrder ()

@end

@implementation EditOrder
@synthesize ReportSummaryTable;

@synthesize TaxesTable,TaxListValue;
@synthesize SubTotal,Total;
@synthesize tableNumber,lblTableNumber,t1,t2,t3,t4,v1,v2;

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

-(void)viewDidAppear:(BOOL)animated{
    
    [self checkForWIFIConnection];
}
- (void)viewDidLoad
{
    taskType=0;
    [self getTaxesList];
    v1.layer.cornerRadius=12.0;
    v2.layer.cornerRadius=12.0;
    
    [ShareableData sharedInstance].isTakeaway=@"0";
    float t=0;
    for(int i=0;i<[[ShareableData sharedInstance].DishName count];i++)
    {
        int q=[([ShareableData sharedInstance].DishQuantity)[i] intValue];
        float r=[([ShareableData sharedInstance].DishRate)[i] floatValue];
        t=t+q*r;
    }

    SubTotal.text=[NSString stringWithFormat:@"$%.2f",t];
    t-=totalPriceMinusDrinks;
    float tt=0;
    TaxListValue=[[NSMutableArray alloc]init];
    
    float amountafterdiscount=0;
    
    for(int i=0;i<[[ShareableData sharedInstance].TaxNameValue count];i++)
    {
        
        //int isDeduction=[[[ShareableData sharedInstance].isDeduction objectAtIndex:i] intValue];
        int isPercentage=[([ShareableData sharedInstance].inFormat)[i] intValue];
        
        float v=[([ShareableData sharedInstance].TaxNameValue)[i] floatValue];
        float cv;
        
        if(isPercentage==1)
        {
            cv=t*v/100;
        }
        else
        {
            cv=v;
        }
        
        NSString *string = ([ShareableData sharedInstance].TaxList)[i];
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
    
    amountafterdiscount=t-amountafterdiscount + totalPriceMinusDrinks;
    DLog(@"Amount After Discount : %f",amountafterdiscount);
    
    for(int i=0;i<[[ShareableData sharedInstance].TaxNameValue count];i++)
    {
        int isDeduction=[([ShareableData sharedInstance].isDeduction)[i] intValue];
        int isPercentage=[([ShareableData sharedInstance].inFormat)[i] intValue];
        
        NSString *string = ([ShareableData sharedInstance].TaxList)[i];
        
        float v=[([ShareableData sharedInstance].TaxNameValue)[i] floatValue];
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
    Total.text=[NSString stringWithFormat:@"$%.2f",tt];
    if (tableNumber.intValue > 1233){
        lblTableNumber.text = [NSString stringWithFormat:@"Edit Order : Table No. TA%d",(tableNumber.intValue - 1233)];
    }else{
    lblTableNumber.text=[NSString stringWithFormat:@"Edit Order : Table No. %@",tableNumber];
    }

    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void)updateCalculation
{
    [TaxListValue removeAllObjects];
    
    float t=0;
    for(int i=0;i<[[ShareableData sharedInstance].DishName count];i++)
    {
        int q=[([ShareableData sharedInstance].DishQuantity)[i] intValue];
        float r=[([ShareableData sharedInstance].DishRate)[i] floatValue];
        t=t+q*r;
    }
    
    SubTotal.text=[NSString stringWithFormat:@"$%.2f",t];
    
    float amountafterdiscount=0;
    
    for(int i=0;i<[[ShareableData sharedInstance].TaxNameValue count];i++)
    {
        
        //int isDeduction=[[[ShareableData sharedInstance].isDeduction objectAtIndex:i] intValue];
        int isPercentage=[([ShareableData sharedInstance].inFormat)[i] intValue];
        
        float v=[([ShareableData sharedInstance].TaxNameValue)[i] floatValue];
        float cv;
        
        if(isPercentage==1)
        {
            cv=t*v/100;
        }
        else
        {
            cv=v;
        }
        
        NSString *string = ([ShareableData sharedInstance].TaxList)[i];
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
    
    float tt=0;
    
    for(int i=0;i<[[ShareableData sharedInstance].TaxNameValue count];i++)
    {
        int isDeduction=[([ShareableData sharedInstance].isDeduction)[i] intValue];
        int isPercentage=[([ShareableData sharedInstance].inFormat)[i] intValue];
        
        NSString *string = ([ShareableData sharedInstance].TaxList)[i];
        
        float v=[([ShareableData sharedInstance].TaxNameValue)[i] floatValue];
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
    Total.text=[NSString stringWithFormat:@"$%.2f",tt];
    
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
    return [[ShareableData sharedInstance].DishName count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    
    if(tableView==TaxesTable)
    {
        UILabel *TaxName=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 330, 20)];
        TaxName.text= ([ShareableData sharedInstance].TaxList)[indexPath.row];;
        TaxName.textAlignment=UITextAlignmentLeft;
        TaxName.font=[UIFont boldSystemFontOfSize:18];
        TaxName.backgroundColor=[UIColor clearColor];
        [cell.contentView addSubview:TaxName];
        
        UILabel *TaxValue=[[UILabel alloc]initWithFrame:CGRectMake(380, 0, 150, 20)];
        TaxValue.text= [NSString stringWithFormat:@"$%@",TaxListValue[indexPath.row]];
        TaxValue.textAlignment=UITextAlignmentLeft;
        TaxValue.font=[UIFont boldSystemFontOfSize:18];
        TaxValue.backgroundColor=[UIColor clearColor];
        [cell.contentView addSubview:TaxValue];
    }
    else
    {
        UILabel *ItemName=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 20)];
        ItemName.text= ([ShareableData sharedInstance].DishName)[indexPath.row];;
        ItemName.textAlignment=UITextAlignmentLeft;
        ItemName.font=[UIFont boldSystemFontOfSize:18];
        [cell.contentView addSubview:ItemName];
        
        UIButton *KVoid=[UIButton buttonWithType:UIButtonTypeCustom];
        KVoid.frame=CGRectMake(220, 0, 80, 28);
        [KVoid setImage:[UIImage imageNamed:@"void_btn.png"] forState:UIControlStateNormal];
        [KVoid setImage:[UIImage imageNamed:@"void_btn.png"] forState:UIControlStateHighlighted];
        [KVoid setImage:[UIImage imageNamed:@"void_btn.png"] forState:UIControlStateSelected];
        [KVoid addTarget:self action:@selector(voidBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:KVoid];
        KVoid.tag=indexPath.row;
        
        
        
        UIButton *KAdd=[UIButton buttonWithType:UIButtonTypeCustom];
        KAdd.frame=CGRectMake(310, 0, 35, 28);
        [KAdd setImage:[UIImage imageNamed:@"minus.png"] forState:UIControlStateNormal];
        [KAdd setImage:[UIImage imageNamed:@"minus.png"] forState:UIControlStateHighlighted];
        [KAdd setImage:[UIImage imageNamed:@"minus.png"] forState:UIControlStateSelected];
        [KAdd addTarget:self action:@selector(minusBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        KAdd.tag=indexPath.row;
        [cell.contentView addSubview:KAdd];
        
        UILabel *ItemQuantity=[[UILabel alloc]initWithFrame:CGRectMake(360, 0, 20, 20)];
        ItemQuantity.text= ([ShareableData sharedInstance].DishQuantity)[indexPath.row];;
        ItemQuantity.textAlignment=UITextAlignmentLeft;
        ItemQuantity.font=[UIFont boldSystemFontOfSize:14];
        [cell.contentView addSubview:ItemQuantity];
        
        
        UIButton *KMinus=[UIButton buttonWithType:UIButtonTypeCustom];
        KMinus.frame=CGRectMake(390, 0, 35, 28);
        [KMinus setImage:[UIImage imageNamed:@"plus.png"] forState:UIControlStateNormal];
        [KMinus setImage:[UIImage imageNamed:@"plus.png"] forState:UIControlStateHighlighted];
        [KMinus setImage:[UIImage imageNamed:@"plus.png"] forState:UIControlStateSelected];
        [KMinus addTarget:self action:@selector(plusBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        KMinus.tag=indexPath.row;
        [cell.contentView addSubview:KMinus];
        
        
        UILabel *ItemRate=[[UILabel alloc]initWithFrame:CGRectMake(450, 0, 100, 20)];
        ItemRate.text=[NSString stringWithFormat:@"$%@",([ShareableData sharedInstance].DishRate)[indexPath.row]];
        ItemRate.textAlignment=UITextAlignmentLeft;
        ItemRate.font=[UIFont boldSystemFontOfSize:14];
        [cell.contentView addSubview:ItemRate];
        
        UIButton *Kamt=[UIButton buttonWithType:UIButtonTypeCustom];
        Kamt.frame=CGRectMake(450, 0, 100, 20);
        // UILabel *ItemQuantity=[[UILabel alloc]initWithFrame:CGRectMake(360, 0, 20, 20)];
        // ItemQuantity.text= [[ShareableData sharedInstance].DishQuantity objectAtIndex:indexPath.row];;
        // ItemQuantity.textAlignment=UITextAlignmentLeft;
        // ItemQuantity.font=[UIFont boldSystemFontOfSize:14];
        [Kamt addTarget:self action:@selector(changeAmountBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        Kamt.tag=indexPath.row;
        [cell.contentView addSubview:Kamt];
        
        if([([ShareableData sharedInstance].DishQuantity)[indexPath.row] isEqualToString:@"0"])
        {
            KVoid.hidden=TRUE;
            KMinus.hidden=TRUE;
           // KAdd.hidden=TRUE;
            
        }

    }
    
    return cell;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    if (CGRectContainsPoint([self.t1 frame], [touch locationInView:self.view])
        ||CGRectContainsPoint([self.t2 frame], [touch locationInView:self.view])
        ||CGRectContainsPoint([self.t3 frame], [touch locationInView:self.view])
        ||CGRectContainsPoint([self.t4 frame], [touch locationInView:self.view])
        )
    {
        
    }
    else
    {
        [t1 resignFirstResponder];
        [t2 resignFirstResponder];
        [t3 resignFirstResponder];
        [t4 resignFirstResponder];
    }
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
    ////NSLOG(@"Bill Number :%@",data);
    
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
    [request setURL:[NSURL URLWithString:kURL@"central/webs/get_temp_order"]];
    
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
    
    //[ReportSummaryTable reloadData];
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


-(IBAction)voidBtnClick:(id)sender
{
    UIButton *btn=(UIButton*)sender;
    //int tag=btn.tag;
    void_btn_tag = btn.tag;
    
    
    ([ShareableData sharedInstance].DishQuantity)[void_btn_tag] = [NSString stringWithFormat:@"%d",0];
    [self updateCalculation];
    [ReportSummaryTable reloadData];
    [TaxesTable reloadData];
    
    /////before it was connected with passcode with the below method
//
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Please enter password"
//                                                   delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
//	alert.alertViewStyle = UIAlertViewStyleSecureTextInput;
//    UITextField * alertTextField = [alert textFieldAtIndex:0];
//    alertTextField.keyboardType = UIKeyboardTypeNumberPad;
//    alert.tag=1500;
//    [alert show];

    
}
-(IBAction)changeAmountBtnClick:(id)sender
{
    UIButton *btn=(UIButton*)sender;
    tempTag=btn.tag;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Enter new price:"
                                                   delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Modify", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField * alertTextField = [alert textFieldAtIndex:0];
    alertTextField.keyboardType = UIKeyboardTypeDecimalPad;
    [alert textFieldAtIndex:0].text = ([ShareableData sharedInstance].DishRate)[tempTag];
    [alert show];
   // int v=[[[ShareableData sharedInstance].DishRate objectAtIndex:tag] intValue];
   
  //  [[ShareableData sharedInstance].DishQuantity replaceObjectAtIndex:tag withObject:[NSString stringWithFormat:@"%d",v]];
   // [self updateCalculation];
   // [ReportSummaryTable reloadData];
  //  [TaxesTable reloadData];
}


-(IBAction)minusBtnClick:(id)sender
{
    ////NSLOG(@"minus clicked");
    UIButton *btn=(UIButton*)sender;
    minus_btn_tag = btn.tag;
    
    int v=[([ShareableData sharedInstance].DishQuantity)[minus_btn_tag] intValue];
    if(v>0)
    {
        v--;
    }
    ([ShareableData sharedInstance].DishQuantity)[minus_btn_tag] = [NSString stringWithFormat:@"%d",v];
    [self updateCalculation];
    [ReportSummaryTable reloadData];
    [TaxesTable reloadData];

    /////before it was connected with passcode with the below method

//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Please enter password"
//                                                   delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
//	alert.alertViewStyle = UIAlertViewStyleSecureTextInput;
//    UITextField * alertTextField = [alert textFieldAtIndex:0];
//    alertTextField.keyboardType = UIKeyboardTypeNumberPad;
//    alert.tag=1501;
//    [alert show];

}

-(IBAction)plusBtnClick:(id)sender
{
    UIButton *btn=(UIButton*)sender;
    int tag=btn.tag;
    int v=[([ShareableData sharedInstance].DishQuantity)[tag] intValue];
    v++;
    ([ShareableData sharedInstance].DishQuantity)[tag] = [NSString stringWithFormat:@"%d",v];
    [self updateCalculation];
    [ReportSummaryTable reloadData];
    [TaxesTable reloadData];
}


- (IBAction)AddItemButtonClick:(id)sender
{   
    taskType=3;
    [ShareableData sharedInstance].IsEditOrder=@"1";
    [ShareableData sharedInstance].isQuickOrder=@"1";
    [ShareableData sharedInstance].isFeedbackDone=@"0";
    [ShareableData sharedInstance].isConfermOrder=TRUE;
    if([[ShareableData sharedInstance].isConfromHomePage isEqualToString:@"1"])
    {
        TabSquareMenuController *TableMgmt=[[TabSquareMenuController alloc]initWithNibName:@"TabSquareMenuController" bundle:nil];
        [self.navigationController pushViewController:TableMgmt animated:YES];
        
    }
    else 
    {
        //[self dismissModalViewControllerAnimated:NO];
        TabSquareHomeController *TableMgmt=[[TabSquareHomeController alloc]initWithNibName:@"TabSquareHomeController" bundle:nil];
       [self.navigationController pushViewController:TableMgmt animated:YES];
    }   
}

- (IBAction)CheckoutButtonClick:(id)sender //conferm
{
    if([self checkDigit:t1.text]==1)
    {
        UIAlertView *alert3=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Invalid Discount value!!!" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert3 show];
    }
    else if([self checkDigit:t1.text]==1 )
    {
        UIAlertView *alert3=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Invalid Discount value!!!" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert3 show];
    }
    else if([self checkDigit:t1.text]==1)
    {
        UIAlertView *alert3=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Invalid Delivery Charges value!!!" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert3 show];
    }
    else if([t1.text intValue]>100 )
    {
        UIAlertView *alert3=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Invalid Discount value!!!" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert3 show];
    }
    else
    {
        taskType=1;
        [self showIndicator];
        
    }
}


-(IBAction)Back:(id)sender
{
    taskType=2;
    [self showIndicator];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if([title isEqualToString:@"OK"] && alertView.tag==1500)
    {
        UITextField *password = [alertView textFieldAtIndex:0];
        BOOL authenticate=[ShareableData hasAccess:password.text level:VOID_ITEM];
        
        if (authenticate) {

            ([ShareableData sharedInstance].DishQuantity)[void_btn_tag] = [NSString stringWithFormat:@"%d",0];
            [self updateCalculation];
            [ReportSummaryTable reloadData];
            [TaxesTable reloadData];
        }
        
        return;
    }
    else if([title isEqualToString:@"OK"] && alertView.tag==1501) {
        
        UITextField *password = [alertView textFieldAtIndex:0];
        BOOL authenticate=[ShareableData hasAccess:password.text level:REDUCE_ITEMS];

            if (authenticate) {
                int v=[([ShareableData sharedInstance].DishQuantity)[minus_btn_tag] intValue];
                if(v>0)
                {
                    v--;
                }
                ([ShareableData sharedInstance].DishQuantity)[minus_btn_tag] = [NSString stringWithFormat:@"%d",v];
                [self updateCalculation];
                [ReportSummaryTable reloadData];
                [TaxesTable reloadData];
            }
        
        return;
    }
    
    
    if ([title isEqualToString:@"Modify"]){
        UITextField *guests = [alertView textFieldAtIndex:0];
        float x = [guests.text floatValue];
        
        if (x >0){
            ([ShareableData sharedInstance].DishRate)[tempTag] = [NSString stringWithFormat:@"%.2f",x];
            [self updatePrice:tableNumber DName:([ShareableData sharedInstance].TempOrderID)[tempTag] DQ:[NSString stringWithFormat:@"%.2f",x]];
            [self updateCalculation];
            [ReportSummaryTable reloadData];
            [TaxesTable reloadData];
            UIAlertView *alert3=[[UIAlertView alloc]initWithTitle:@"Notice" message:@"Amount modified" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alert3 show];
            //[NSString stringWithFormat:@"$%.2f",t]
        }else{
            UIAlertView *alert3=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Invalid Amount Entered" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alert3 show];

            
        }
        
    }
    
     
    
}
-(void)getBackgroundImage
{
        
      
    NSString *img_name = [NSString stringWithFormat:@"%@%@_%@.png", PRE_NAME, BACKGROUND_IMAGE, [ShareableData appKey]];
    
    UIImage *img = [[TabSquareDBFile sharedDatabase] getImage:img_name];
    
    if(img == nil || img == NULL) {
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        [arr addObject:BACKGROUND_IMAGE];
        
        [[TabSquareDBFile sharedDatabase] updateUIImages:arr];
        
        img = [[TabSquareDBFile sharedDatabase] getImage:img_name];
    }
    
    [bgImage setImage:img];
        
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [self getBackgroundImage];
    [super viewWillAppear:YES];
    
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}



- (void)viewWillDisappear:(BOOL)animated
{
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return YES;  
}

-(void)keyboardWillShow
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    CGRect rect = self.view.frame;
    rect.origin.y -= 150;
    rect.size.height += 150;
    self.view.frame = rect;
    [UIView commitAnimations];
}

-(void)keyboardWillHide
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    CGRect rect = self.view.frame;
    rect.origin.y += 150;
    rect.size.height -= 150;
    self.view.frame = rect;
    [UIView commitAnimations];
}

-(IBAction)gotoDishMenuLIst:(id)sender
{
    if([[ShareableData sharedInstance].isConfromHomePage isEqualToString:@"1"])
    {
        //[self dismissModalViewControllerAnimated:NO];
        TabSquareMenuController *TableMgmt=[[TabSquareMenuController alloc]initWithNibName:@"TabSquareMenuController" bundle:nil];
        [self.navigationController pushViewController:TableMgmt animated:YES];
        
    }
    else 
    {
        //[self dismissModalViewControllerAnimated:NO];
        TabSquareHomeController *TableMgmt=[[TabSquareHomeController alloc]initWithNibName:@"TabSquareHomeController" bundle:nil];
        [self.navigationController pushViewController:TableMgmt animated:YES];
        
    }}


-(NSInteger)checkDigit:(NSString*)amount
{
    int j=0;
    for (int i=0;i<[amount length];i++) 
    {
        
        char c = [amount characterAtIndex:i];
       // DLog(@"%c",c);
        if(!(c=='0' || c=='1' || c=='2'|| c=='3'|| c=='4'|| c=='5'|| c=='6'|| c=='7'|| c=='8'|| c=='9'))
        {
            j=1;
        }
    }
    return j;
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
    //DLog(@"%@",data);
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
    if(taskType==1)
    {
       // BOOL authenticate=[self AuthenticateWater:t4.text];
       // if(authenticate)
     // {
            
           if([t1.text intValue]>0)
            {
                [self discountAddedToServer:tableNumber cName:[NSString stringWithFormat:@"Discount @ %@%%",t1.text] vValue:[NSString stringWithFormat:@"%@",t1.text] isDu:@"1" inF:@"1"];
            }
            
            
            if([t2.text intValue]>0)
            {
                [self discountAddedToServer:tableNumber cName:@"Discount" vValue:[NSString stringWithFormat:@"%@",t2.text] isDu:@"1" inF:@"0"];
            }
            
            
            if([t3.text intValue]>0)
            {
                [self discountAddedToServer:tableNumber cName:@"Delivery Charges" vValue:[NSString stringWithFormat:@"%@",t3.text] isDu:@"0" inF:@"0"];
            }
            
            
            for(int i=0;i<[[ShareableData sharedInstance].TDishName count];i++)
            {
                if([([ShareableData sharedInstance].DishQuantity)[i] intValue] != [([ShareableData sharedInstance].TDishQuantity)[i] intValue])
                {
                    
                    if ([([ShareableData sharedInstance].DishQuantity)[i] intValue] <[([ShareableData sharedInstance].TDishQuantity)[i] intValue]){
                        int tempVal = [([ShareableData sharedInstance].DishQuantity)[i] intValue] - [([ShareableData sharedInstance].TDishQuantity)[i] intValue];

                        [self updateQuantity:tableNumber DName:([ShareableData sharedInstance].TempOrderID)[i] DQ:[NSString stringWithFormat:@"%d",tempVal] isConfirm:@"1" PLU:[ShareableData sharedInstance].DishId[i] NewQty:([ShareableData sharedInstance].DishQuantity)[i]];
                    }
                    
                    else{
                        int tempVal = [([ShareableData sharedInstance].DishQuantity)[i] intValue] - [([ShareableData sharedInstance].TDishQuantity)[i] intValue];

                        [self updateQuantity:tableNumber DName:([ShareableData sharedInstance].TempOrderID)[i] DQ:[NSString stringWithFormat:@"%d",tempVal] isConfirm:@"0" PLU:[ShareableData sharedInstance].DishId[i] NewQty:([ShareableData sharedInstance].DishQuantity)[i]];
                        
                        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
                        [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@Ex/printDishes.php?tableid=%@&request=%@&key=%@", [ShareableData serverURL],tableNumber,@"", [ShareableData appKey]]]];
                        
                       NSError *error;
                       NSURLResponse *response;
                       NSData *uData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
                        NSString *data=[[NSString alloc]initWithData:uData encoding:NSUTF8StringEncoding];
                        
                        NSMutableURLRequest *request2 = [[NSMutableURLRequest alloc] init];
                        [request2 setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@Ex/printDrinks.php?tableid=%@&request=%@", [ShareableData serverURL],tableNumber,@""]]];
                       
                        
                       NSError *error2;
                       NSURLResponse *response2;
                       NSData *uData2=[NSURLConnection sendSynchronousRequest:request2 returningResponse:&response2 error:&error2];
                        NSString *data2=[[NSString alloc]initWithData:uData2 encoding:NSUTF8StringEncoding];
                       // [self updateQuantity:tableNumber DName:([ShareableData sharedInstance].TempOrderID)[i] DQ:([ShareableData sharedInstance].DishQuantity)[i] isConfirm:@"1"];

                        
                    }
                    
                    
                }
            }
            
            
            TabSquareTableStatus *SalesReport1=[[TabSquareTableStatus alloc]initWithNibName:@"TabSquareTableStatus" bundle:nil];
            SalesReport1.tableNumber=tableNumber;
            //[self dismissModalViewControllerAnimated:NO];
           [self.navigationController pushViewController:SalesReport1 animated:YES];
       /* }
        else 
        {
            UIAlertView *alert4 = [[UIAlertView alloc] initWithTitle:nil message:@"plz enter currect password"
                                                            delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alert4 show];
            [alert4 release];
            
        }*/
    }
    else if(taskType==2)
    {
        TabSquareTableStatus *SalesReport1=[[TabSquareTableStatus alloc]initWithNibName:@"TabSquareTableStatus" bundle:nil];
        SalesReport1.tableNumber=tableNumber;
        //[self dismissModalViewControllerAnimated:NO];
        [self.navigationController pushViewController:SalesReport1 animated:YES];
    }
    else if(taskType==3)
    {
        
        
    }
    
}



-(void)discountAddedToServer:(NSString*)tableNumber1 cName:(NSString*)ccName vValue:(NSString*)vValue1 isDu:(NSString*)isDu1 inF:(NSString*)inF1
{
    NSString *post =[NSString stringWithFormat:@"table=%@&charge_name=%@&value=%@&is_deduction=%@&in_format=%@&key=%@",tableNumber,ccName,vValue1,isDu1,inF1, [ShareableData appKey]];
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    NSString *url_string = [NSString stringWithFormat:@"%@/webs/set_temp_charges", [ShareableData serverURL]];
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
    DLog(@"Data :%@",data);
}


-(void)getTableTaxDetails
{
    
    NSString *post =[NSString stringWithFormat:@"table=%@&key=%@",tableNumber, [ShareableData appKey]];
    ////NSLOG(@"post==%@",post);
    
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    NSString *url_string = [NSString stringWithFormat:@"%@/webs/get_temp_charges", [ShareableData serverURL]];
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
    //DLog(@"Data :%@",data);
    
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
    [[ShareableData sharedInstance].TaxList removeAllObjects];
    [[ShareableData sharedInstance].TaxNameValue removeAllObjects];
    [[ShareableData sharedInstance].inFormat removeAllObjects];
    [[ShareableData sharedInstance].isDeduction removeAllObjects];
    
    NSString *post =[NSString stringWithFormat:@"key=%@", [ShareableData appKey]];
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    NSString *url_string = [NSString stringWithFormat:@"%@/webs/get_charges", [ShareableData serverURL]];
    
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
    
    SBJSON *parser = [[SBJSON alloc] init];
    NSMutableArray *resultFromPost = [parser objectWithString:data error:nil];
  //  DLog(@"Data :%@",resultFromPost);
    
    
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
-(void)insertInItemRaptor:(NSString*)POSID OperatorNo:(NSString*)OperatorNo TableNo:(NSString*)TableNo SalesNo:(NSString*)SalesNo SplitNo:(NSString*)SplitNo PLUNo:(NSString*)PLUNo Qty:(NSString*)Qty ItemRemark:(NSString*)ItemRemark
{
    
    NSString *post =[NSString stringWithFormat:@"POSID=%@&OperatorNo=%@&TableNo=%@&SalesNo=%@&SplitNo=%@&PLUNo=%@&Qty=%@&ItemRemark=%@&CtgryID=%@",POSID,OperatorNo,TableNo,SalesNo,SplitNo,PLUNo,Qty,ItemRemark, [ShareableData sharedInstance].categoryID];
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:kURL@"Raptor/OrderItem.php"]];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/x-www-form-urlencoded charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSError *error;
    NSURLResponse *response;
    NSData *uData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    //NSString *buf=[[NSString alloc]initWithData:uData encoding:NSUTF8StringEncoding];
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:uData options:kNilOptions error:&error];
    
    
    // if ([json count]!=0){
    NSArray* returnVal = [json objectForKey:@"returnVal"];
    
    // for (int i=0;i<[returnedNodes count];i++){
    NSDictionary* node = [returnVal objectAtIndex:0];
  //  salesRef = [node objectForKey:@"SalesRef"];
    
    
}


-(void)updateQuantity:(NSString*)tblN DName:(NSString*)DName1 DQ:(NSString*)DQ1 isConfirm:(NSString*)confirm PLU:(NSString*)plu NewQty:(NSString*)NewQty
{
    NSString *post =[NSString stringWithFormat:@"table=%@&dish_name=%@&quantity=%@&confirm=%@&PLU=%@&NewQty=%@&key=%@",tblN,DName1,DQ1,confirm, plu,NewQty,[ShareableData appKey]];
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    NSString *url_string = [NSString stringWithFormat:@"%@/webs/update_temp_order", [ShareableData serverURL]];
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
    
    DLog(@"Update Quantity :%@",data);
    
    
}

-(void)updatePrice:(NSString*)tblN DName:(NSString*)DName1 DQ:(NSString*)DQ1
{
    NSString *post =[NSString stringWithFormat:@"table=%@&dish_name=%@&price=%@&key=%@",tblN,DName1,DQ1, [ShareableData appKey]];
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    NSString *url_string = [NSString stringWithFormat:@"%@/webs/update_temp_order_price", [ShareableData serverURL]];
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
    
    DLog(@"Update Price :%@",data);
    
    
}



@end
