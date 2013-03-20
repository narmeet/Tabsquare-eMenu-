//
//  EditOrder.m
//  TabSquareMenu
//
//  Created by Nikhil Kumar on 10/08/12.
//  Copyright (c) 2012 Trendsetterz. All rights reserved.
//

#import "TakeWayEditOrder.h"
#import "AddDiscount.h"
//#import "PrintBillAndCheckOut.h"
#import "PrintBillAndCheckOutFinal.h"
#import "TabSquareTableStatus.h"
#import "ShareableData.h"
#import "SBJSON.h"
#import "TabSquareMenuController.h"
#import "TabSquareHomeController.h"
#import "TabSquareTableManagement.h"
#import <QuartzCore/CALayer.h>

@interface TakeWayEditOrder ()

@end

@implementation TakeWayEditOrder
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
    //DLog(@"Data :%@",resultFromPost);
    
    
    for(int i=0;i<[resultFromPost count];i++)
    {
        NSMutableDictionary *dataitem=resultFromPost[i];
        [[ShareableData sharedInstance].TaxList addObject:[NSString stringWithFormat:@"%@",dataitem[@"name"]]];
        [[ShareableData sharedInstance].TaxNameValue addObject:[NSString stringWithFormat:@"%@",dataitem[@"value"]]];
        [[ShareableData sharedInstance].inFormat addObject:[NSString stringWithFormat:@"%@",dataitem[@"is_percent"]]];
        [[ShareableData sharedInstance].isDeduction addObject:[NSString stringWithFormat:@"%@",dataitem[@"is_deduction"]]];
    }
    
       
}

-(void)getTableDetails:(NSString*)SearchTableNumber
{
    // DLog(@"Table Number : %@",SearchTableNumber);
    
    //[self getBillNumber:SearchTableNumber];
    
    [ShareableData sharedInstance].assignedTable1=SearchTableNumber;
    
    [[ShareableData sharedInstance].DishId removeAllObjects];
    [[ShareableData sharedInstance].DishName removeAllObjects];
    [[ShareableData sharedInstance].DishQuantity removeAllObjects];
    [[ShareableData sharedInstance].DishRate removeAllObjects];
    
    [[ShareableData sharedInstance].TDishName removeAllObjects];
    [[ShareableData sharedInstance].TDishQuantity removeAllObjects];
    [[ShareableData sharedInstance].TDishRate removeAllObjects];
    
    NSString *post =[NSString stringWithFormat:@"table_id=%@&key=%@",SearchTableNumber, [ShareableData appKey] ];
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    NSString *url_string = [NSString stringWithFormat:@"%@/webs/get_temp_order", [ShareableData serverURL]];
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
    // DLog(@"Data :%@",data);
    
    SBJSON *parser = [[SBJSON alloc] init];
    NSMutableArray *resultFromPost = [parser objectWithString:data error:nil];
    //DLog(@"Data :%@",resultFromPost);
    
    
    for(int i=0;i<[resultFromPost count];i++)
    {
        NSMutableDictionary *dataitem=resultFromPost[i];
        
        [[ShareableData sharedInstance].DishId addObject:[NSString stringWithFormat:@"%@",dataitem[@"dish_id"]]];        
        [[ShareableData sharedInstance].DishName addObject:[NSString stringWithFormat:@"%@",dataitem[@"dish_name"]]];
        [[ShareableData sharedInstance].DishQuantity addObject:[NSString stringWithFormat:@"%@",dataitem[@"quantity"]]];
        
        NSString *quantity=[NSString stringWithFormat:@"%@",dataitem[@"quantity"]];
        int qquantity=[quantity intValue];
        NSString *price=[NSString stringWithFormat:@"%@",dataitem[@"price"]];
        float fprice=[price floatValue]/qquantity;
        
        [[ShareableData sharedInstance].DishRate addObject:[NSString stringWithFormat:@"%.2f",fprice]];
        //[[ShareableData sharedInstance].DishRate addObject:[NSString stringWithFormat:@"%@",[dataitem objectForKey:@"price"]]];
        
        [[ShareableData sharedInstance].OrderItemID addObject:[NSString stringWithFormat:@"%@",dataitem[@"dish_id"]]];        
        [[ShareableData sharedInstance].OrderItemName addObject:[NSString stringWithFormat:@"%@",dataitem[@"dish_name"]]];
        [[ShareableData sharedInstance].OrderItemQuantity addObject:[NSString stringWithFormat:@"%@",dataitem[@"quantity"]]];
        [[ShareableData sharedInstance].OrderItemRate addObject:[NSString stringWithFormat:@"%@",dataitem[@"price"]]];
        
        [[ShareableData sharedInstance].confirmOrder addObject:[NSString stringWithFormat:@"%@",dataitem[@"confirm_order"]]];
        
        
        
        //[[ShareableData sharedInstance].IsOrderCustomization addObject:[NSString stringWithFormat:@"%@",[dataitem objectForKey:@"is_order_customisation"]]];
        
        [[ShareableData sharedInstance].IsOrderCustomization addObject:@"0"];
        
        NSString *trimmedString = [[NSString stringWithFormat:@"%@",dataitem[@"order_cat_id"]] stringByTrimmingCharactersInSet:
                                   [NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        [[ShareableData sharedInstance].OrderCatId addObject:trimmedString];
        [[ShareableData sharedInstance].OrderSpecialRequest addObject:[NSString stringWithFormat:@"%@",dataitem[@"order_special_request"]]];
        
        [[ShareableData sharedInstance].OrderCustomizationDetail addObject:[NSString stringWithFormat:@"%@",dataitem[@"order_customisation_detail"]]];
        
        
        
        
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


- (void)viewDidLoad
{
    
    [ShareableData sharedInstance].isTakeaway=@"1";
    DLog(@" AddItemFromTakeaway View Did Load : %@",[ShareableData sharedInstance].AddItemFromTakeaway);
    
    if([[ShareableData sharedInstance].AddItemFromTakeaway isEqualToString:@"0"])
    {
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
    }
    
    [self getTaxesList];
    
    float t=0;
    for(int i=0;i<[[ShareableData sharedInstance].OrderItemName count];i++)
    {
        int q=[([ShareableData sharedInstance].OrderItemQuantity)[i] intValue];
        float r=[([ShareableData sharedInstance].OrderItemRate)[i] floatValue];
        t=t+q*r;
    }
    
    SubTotal.text=[NSString stringWithFormat:@"$%.2f",t];
    
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
    
    amountafterdiscount=t-amountafterdiscount;
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
    
    lblTableNumber.text=[NSString stringWithFormat:@"Edit Order : Table No. %@",tableNumber];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void)updateCalculation
{
    v1.layer.cornerRadius=12.0;
    v2.layer.cornerRadius=12.0;
    [TaxListValue removeAllObjects];
    
    float t=0;
    for(int i=0;i<[[ShareableData sharedInstance].OrderItemName count];i++)
    {
        int q=[([ShareableData sharedInstance].OrderItemQuantity)[i] intValue];
        float r=[([ShareableData sharedInstance].OrderItemRate)[i] floatValue];
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
    
    //lblTableNumber.text=[NSString stringWithFormat:@"Edit Order : Table No. %@",tableNumber];
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
    return [[ShareableData sharedInstance].OrderItemName count];
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
        ItemName.text= ([ShareableData sharedInstance].OrderItemName)[indexPath.row];;
        ItemName.textAlignment=UITextAlignmentLeft;
        ItemName.font=[UIFont boldSystemFontOfSize:18];
        [cell.contentView addSubview:ItemName];
        
        UIButton *KVoid=[UIButton buttonWithType:UIButtonTypeCustom];
        KVoid.frame=CGRectMake(220, 0, 80, 28);
        [KVoid setImage:[UIImage imageNamed:@"void_btn.png"] forState:UIControlStateNormal];
        [KVoid setImage:[UIImage imageNamed:@"void_btn.png"] forState:UIControlStateHighlighted];
        [KVoid setImage:[UIImage imageNamed:@"void_btn.png"] forState:UIControlStateSelected];
        [KVoid addTarget:self action:@selector(minusBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:KVoid];
        
        UIButton *KAdd=[UIButton buttonWithType:UIButtonTypeCustom];
        KAdd.frame=CGRectMake(310, 0, 35, 28);
        [KAdd setImage:[UIImage imageNamed:@"minus.png"] forState:UIControlStateNormal];
        [KAdd setImage:[UIImage imageNamed:@"minus.png"] forState:UIControlStateHighlighted];
        [KAdd setImage:[UIImage imageNamed:@"minus.png"] forState:UIControlStateSelected];
        [KAdd addTarget:self action:@selector(minusBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        KAdd.tag=indexPath.row;
        [cell.contentView addSubview:KAdd];
        
        UILabel *ItemQuantity=[[UILabel alloc]initWithFrame:CGRectMake(360, 0, 20, 20)];
        ItemQuantity.text= ([ShareableData sharedInstance].OrderItemQuantity)[indexPath.row];;
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
        
        NSString *quantity=([ShareableData sharedInstance].OrderItemQuantity)[indexPath.row];
        int qquantity=[quantity intValue];
        NSString *price=([ShareableData sharedInstance].OrderItemRate)[indexPath.row];
        float fprice=[price floatValue]/qquantity;
        
        //ItemRate.text=[NSString stringWithFormat:@"$%@",[[ShareableData sharedInstance].OrderItemRate objectAtIndex:indexPath.row]];
        ItemRate.text=[NSString stringWithFormat:@"$%.2f",fprice];
        ItemRate.textAlignment=UITextAlignmentLeft;
        ItemRate.font=[UIFont boldSystemFontOfSize:14];
        [cell.contentView addSubview:ItemRate];
    }
    
    return cell;
}

-(IBAction)minusBtnClick:(id)sender
{
    UIButton *btn=(UIButton*)sender;
    int tag=btn.tag;
    int v=[([ShareableData sharedInstance].OrderItemQuantity)[tag] intValue];
    if(v>0)
    {
        v--;
    }
    ([ShareableData sharedInstance].OrderItemQuantity)[tag] = [NSString stringWithFormat:@"%d",v];
    [self updateCalculation];
    [ReportSummaryTable reloadData];
    [TaxesTable reloadData];
}

-(IBAction)plusBtnClick:(id)sender
{
    UIButton *btn=(UIButton*)sender;
    int tag=btn.tag;
    int v=[([ShareableData sharedInstance].OrderItemQuantity)[tag] intValue];
    v++;
    ([ShareableData sharedInstance].OrderItemQuantity)[tag] = [NSString stringWithFormat:@"%d",v];
    [self updateCalculation];
    [ReportSummaryTable reloadData];
    [TaxesTable reloadData];
}


- (IBAction)AddItemButtonClick:(id)sender
{
    
    
    [ShareableData sharedInstance].AddItemFromTakeaway=@"1";
    [ShareableData sharedInstance].IsEditOrder=@"2";
    
    [ShareableData sharedInstance].assignedTable1=@"-1";
    [ShareableData sharedInstance].assignedTable2=@"-1";
    [ShareableData sharedInstance].assignedTable3=@"-1";
    [ShareableData sharedInstance].assignedTable4=@"-1";
    
    DLog(@" AddItemFromTakeaway AddItemButtonClick : %@",[ShareableData sharedInstance].AddItemFromTakeaway);
    
    if([[ShareableData sharedInstance].isConfromHomePage isEqualToString:@"1"])
    {
        //[self dismissModalViewControllerAnimated:NO];
        TabSquareMenuController *TableMgmt=[[TabSquareMenuController alloc]initWithNibName:@"TabSquareMenuController" bundle:nil];
        [self presentModalViewController:TableMgmt animated:YES];
        
    }
    else 
    {
        //[self dismissModalViewControllerAnimated:NO];
        TabSquareHomeController *TableMgmt=[[TabSquareHomeController alloc]initWithNibName:@"TabSquareHomeController" bundle:nil];
        [self presentModalViewController:TableMgmt animated:YES];
        
    }   
}

- (IBAction)CheckoutButtonClick:(id)sender //conferm
{
    
    if([self checkDigit:t1.text]==1)
    {
        UIAlertView *alert3=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Invalid Discount value!!!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert3 show];
    }
    else if([self checkDigit:t1.text]==1)
    {
        UIAlertView *alert3=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Invalid Discount value!!!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert3 show];
    }
    else if([self checkDigit:t1.text]==1)
    {
        UIAlertView *alert3=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Invalid Delivery Charges value!!!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert3 show];
    }
    else
    {
        [self showIndicator];
    }
}

-(IBAction)Back:(id)sender
{
    TabSquareTableManagement *SalesReport1=[[TabSquareTableManagement alloc]initWithNibName:@"TabSquareTableManagement" bundle:nil];
    //SalesReport1.tableNumber=tableNumber;
    //[self dismissModalViewControllerAnimated:NO];
    [self presentModalViewController:SalesReport1 animated:YES];
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
       // [self dismissModalViewControllerAnimated:NO];
        TabSquareMenuController *TableMgmt=[[TabSquareMenuController alloc]initWithNibName:@"TabSquareMenuController" bundle:nil];
        [self presentModalViewController:TableMgmt animated:YES];
        
    }
    else 
    {
       // [self dismissModalViewControllerAnimated:NO];
        TabSquareHomeController *TableMgmt=[[TabSquareHomeController alloc]initWithNibName:@"TabSquareHomeController" bundle:nil];
        [self presentModalViewController:TableMgmt animated:YES];
        
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
    NSString *post =[NSString stringWithFormat:@"password=%@&key=%@",passtext, [ShareableData appKey] ];
    
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
    BOOL authenticate=[self AuthenticateWater:t4.text];
    if(authenticate)
    {
        
        if([t1.text intValue]>0)
        {
            [[ShareableData sharedInstance].TaxList addObject:[NSString stringWithFormat:@"Discount @ %@%%",t1.text]]; 
            [[ShareableData sharedInstance].TaxNameValue addObject:[NSString stringWithFormat:@"%@",t1.text]];
            [[ShareableData sharedInstance].isDeduction addObject:@"1"];
            [[ShareableData sharedInstance].inFormat addObject:@"1"];
        }
        
        if([t2.text intValue]>0)
        {
            [[ShareableData sharedInstance].TaxList addObject:@"Discount"]; 
            [[ShareableData sharedInstance].TaxNameValue addObject:[NSString stringWithFormat:@"%@",t2.text]];
            [[ShareableData sharedInstance].isDeduction addObject:@"1"];
            [[ShareableData sharedInstance].inFormat addObject:@"0"];
        }
        
        
        if([t3.text intValue]>0)
        {
            [[ShareableData sharedInstance].TaxList addObject:@"Delivery Charges"]; 
            [[ShareableData sharedInstance].TaxNameValue addObject:[NSString stringWithFormat:@"%@",t3.text]];
            [[ShareableData sharedInstance].isDeduction addObject:@"0"];
            [[ShareableData sharedInstance].inFormat addObject:@"0"];
        }
        
        PrintBillAndCheckOutFinal *SalesReport1=[[PrintBillAndCheckOutFinal alloc]initWithNibName:@"PrintBillAndCheckOutFinal" bundle:nil];
        //[self dismissModalViewControllerAnimated:NO];
        [self presentModalViewController:SalesReport1 animated:YES];
        
    }
    else 
    {
        UIAlertView *alert4 = [[UIAlertView alloc] initWithTitle:nil message:@"plz enter currect password"
                                                        delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert4 show];
        
    }
    
}

- (void)viewWillAppear:(BOOL)animated
{
    
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




@end
