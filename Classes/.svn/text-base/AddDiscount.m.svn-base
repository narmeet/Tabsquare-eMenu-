//
//  AddDiscount.m
//  TabSquareMenu
//
//  Created by Nikhil Kumar on 10/08/12.
//  Copyright (c) 2012 Trendsetterz. All rights reserved.
//

#import "AddDiscount.h"
#import "TabSquareTableStatus.h"
#import "ShareableData.h"
#import "SBJSON.h"
#import "TabSquareMenuController.h"
#import "TabSquareHomeController.h"
#import <QuartzCore/CALayer.h>

@interface AddDiscount ()

@end

@implementation AddDiscount

@synthesize ReportSummaryTable;

@synthesize TaxesTable,TaxListValue;
@synthesize SubTotal,Total;
@synthesize tableNumber,lblTableNumber,t1,t2,v1,v2;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(void)taxUpdate
{
    
}

- (void)viewDidLoad
{
    taskType=0;
    [self loadWebView];
    [self getTaxesList];
    
    v1.layer.cornerRadius=12.0;
    v2.layer.cornerRadius=12.0;
    
    /*float t=0;
    for(int i=0;i<[[ShareableData sharedInstance].DishName count];i++)
    {
        int q=[[[ShareableData sharedInstance].DishQuantity objectAtIndex:i] intValue];
        float r=[[[ShareableData sharedInstance].DishRate objectAtIndex:i] floatValue];
        t=t+q*r;
    }
    
    subtotalK=t;
    SubTotal.text=[NSString stringWithFormat:@"$%.2f",t];
    
    float tt=0;
    TaxListValue=[[NSMutableArray alloc]init];
    float amountafterdiscount=0;
    
    for(int i=0;i<[[ShareableData sharedInstance].TaxNameValue count];i++)
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
    Total.text=[NSString stringWithFormat:@"$%.2f",tt];
    totalK=tt;*/
    
    dishesPrice = [self getDishesPrice];
    bevPrice = [self getDrinksPrice];
    totalK = dishesPrice + bevPrice;
    subtotalK = dishesPrice + bevPrice;
    DLog(@"Sub Total : %f",dishesPrice);
    DLog(@"Sub Total : %f",bevPrice);
    if (tableNumber.intValue > 1233){
        lblTableNumber.text = [NSString stringWithFormat:@"Discount Table No. TA%d",(tableNumber.intValue - 1233)];
    }else{
    lblTableNumber.text=[NSString stringWithFormat:@"Discount Table No. %@",tableNumber];
    }
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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
    //cell.textLabel.text=[ReportValues objectAtIndex:indexPath.row];
    
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
    }
    return cell;
}




-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

- (IBAction)AddDiscountButtonClick:(id)sender
{
    /*NSString *post =[NSString stringWithFormat:@"table_id=%@",tableNumber];
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
    [request setURL:[NSURL URLWithString:@"http://108.178.27.242/luigi/webs/apply_void_discount"]];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/x-www-form-urlencoded charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSError *error;
    NSURLResponse *response;
    NSData *uData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSString *data=[[NSString alloc]initWithData:uData encoding:NSUTF8StringEncoding];
    DLog(@"Result : %@",data);
    
    TabSquareTableStatus *SalesReport1=[[TabSquareTableStatus alloc]initWithNibName:@"TabSquareTableStatus" bundle:nil];
    SalesReport1.tableNumber=tableNumber;*/

    taskType=1;
    [self showIndicator];
    
}

- (IBAction)VoidDiscountButtonClick:(id)sender
{
    taskType=3;
    [self showIndicator];
   
}

-(IBAction)Back:(id)sender
{
    taskType=2;
    [self showIndicator];
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
-(void)loadWebView
{
    NSURL *targetURL2 = [NSURL URLWithString:[NSString stringWithFormat:@"%@/printHTMLBill.php?tableid=%@&key=%@", [ShareableData serverURL],[ShareableData sharedInstance].assignedTable1, [ShareableData appKey]]];
    NSURLRequest *request2 = [NSURLRequest requestWithURL:targetURL2];
    [billView  loadRequest:request2];
    
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

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    if (CGRectContainsPoint([self.t1 frame], [touch locationInView:self.view])
        ||CGRectContainsPoint([self.t2 frame], [touch locationInView:self.view])

        )
    {
        
    }
    else
    {
        [t1 resignFirstResponder];
        [t2 resignFirstResponder];
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
        // [self dismissModalViewControllerAnimated:NO];
        TabSquareHomeController *TableMgmt=[[TabSquareHomeController alloc]initWithNibName:@"TabSquareHomeController" bundle:nil];
      [self.navigationController pushViewController:TableMgmt animated:YES];
        
    }
}

-(NSInteger)checkDigit:(NSString*)amount
{
    int j=0;
    for (int i=0;i<[amount length];i++) 
    {
        
        char c = [amount characterAtIndex:i];
       // DLog(@"%c",c);
        if(!(c=='0' || c=='1' || c=='2'|| c=='3'|| c=='4'|| c=='5'|| c=='6'|| c=='7'|| c=='8'|| c=='9'||c=='.'))
        {
            j=1;
        }
    }
    return j;
}

-(void)discountAddedToServer:(NSString*)tableNumber1 cName:(NSString*)ccName vValue:(NSString*)vValue1 isDu:(NSString*)isDu1 inF:(NSString*)inF1
{
    NSString *post =[NSString stringWithFormat:@"key=%@&table=%@&charge_name=%@&value=%@&is_deduction=%@&in_format=%@", [ShareableData appKey],tableNumber,ccName,vValue1,isDu1,inF1];
    
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
    
    NSString *post =[NSString stringWithFormat:@"key=%@&table=%@", [ShareableData appKey],tableNumber];
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
-(float)getDishesPrice{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@Ex/getDishesTotal.php?tableid=%@&key=%@", [ShareableData serverURL],tableNumber, [ShareableData appKey]]]];
    NSError *error;
    NSURLResponse *response;
    NSData *uData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSString *data=[[[NSString alloc]initWithData:uData encoding:NSUTF8StringEncoding]stringByTrimmingCharactersInSet:
    [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    return data.floatValue;
    
}
-(float)getDrinksPrice{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@Ex/getDrinksTotal.php?tableid=%@&key=%@", [ShareableData serverURL],tableNumber, [ShareableData appKey]]]];
    NSError *error;
    NSURLResponse *response;
    NSData *uData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSString *data=[[[NSString alloc]initWithData:uData encoding:NSUTF8StringEncoding]stringByTrimmingCharactersInSet:
    [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    return data.floatValue;
    
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
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [billView reload];
}


-(void) showIndicator
{
   /* UIView *progressView = [[[UIView alloc]initWithFrame:CGRectMake(0,187, self.view.frame.size.width, self.view.frame.size.height)]autorelease];
	progressHud= [[MBProgressHUD alloc] initWithView:progressView];
	[self.view addSubview:progressHud];
	[self.view bringSubviewToFront:progressHud];
	//progressHud.dimBackground = YES;
	progressHud.delegate = self;
    //progressHud.labelText = @"loading....";
	[progressHud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
    [billView reload];*/
    [self myTask];
}

- (void)myTask
{
    if(taskType==1)
    {
        
        NSString *t111 = [t1.text stringByTrimmingCharactersInSet:
                          [NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        NSString *t222 = [t2.text stringByTrimmingCharactersInSet:
                          [NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        
        
        
        int s=0;
        float discount1=0;
        float discount2=0;
        int counter1=0;
        int counter2=0;
        
        if([self checkDigit:t111]==1)
        {
            s=1;
            UIAlertView *alert3=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Invalid Discount value!!!" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alert3 show];
            
        }
        else if([t111 intValue]<0 || [t111 intValue]>100)
        {
            s=1;
            UIAlertView *alert3=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Invalid Discount value!!!" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alert3 show];
        }
        else if([t111 intValue]>0 && [t111 intValue]<=100)
        {
            
            discount1=subtotalK*([t111 floatValue]/100);
            DLog(@"Sub Total : %f",subtotalK);
           // DLog(@"Dis : %f",[t111 floatValue]);
            
            
            /*[self discountAddedToServer:tableNumber cName:[NSString stringWithFormat:@"Discount @ %@\%",t111] vValue:[NSString stringWithFormat:@"%@",t111] isDu:@"1" inF:@"1"];
             
             UIAlertView *alert3=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Discount Added" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
             [alert3 show];
             [alert3 release];*/
            counter1=1;
            
            
        }
        
        if([self checkDigit:t222]==1)
        {
            s=2;
            UIAlertView *alert3=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Invalid Discount value!!!" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alert3 show];
        }
        else if([t222 intValue]>0 )
        {
            discount2=[t222 floatValue];
            counter2=1;
            
            /* [self discountAddedToServer:tableNumber cName:@"Discount" vValue:[NSString stringWithFormat:@"%@",t222] isDu:@"1" inF:@"0"];
             UIAlertView *alert3=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Discount Added" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
             [alert3 show];
             [alert3 release];
             */
        }
        
        if(counter1==1 && counter2==1)
        {
            float tempTotal=totalK-discount1-discount2;
           // DLog(@"Discount Amount1 : %f",discount1);
           // DLog(@"Discount Amount2 : %f",discount2);
            
            if(tempTotal>=0)
            {
                [self voidrebate];
                [self voiddiscount];
                [self discountAddedToServer:tableNumber cName:[NSString stringWithFormat:@"Discount @ %@%%",t111] vValue:[NSString stringWithFormat:@"%@",t111] isDu:@"1" inF:@"1"];
                [self discountAddedToServer:tableNumber cName:@"Rebate" vValue:[NSString stringWithFormat:@"%@",t222] isDu:@"1" inF:@"0"];
                [billView reload];
                UIAlertView *alert3=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Discount Added" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                [alert3 show];
               // [alert3 release];
                
                
            }
            else
            {
                s=1;
                UIAlertView *alert3=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"After Adding amount total less than zero, Please check discount Amount" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                [alert3 show];
            }
        }
        else if(counter1==1)
        {
            float tempTotal=totalK-discount1; 
            
           // DLog(@"Discount Amount1 : %f",discount1);
            
            if(tempTotal>=0)
            {
                //[self voidrebate];
                [self voiddiscount];
                [self discountAddedToServer:tableNumber cName:[NSString stringWithFormat:@"Discount @ %@%%",t111] vValue:[NSString stringWithFormat:@"%@",t111] isDu:@"1" inF:@"1"];
                [billView reload];
                UIAlertView *alert3=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Discount Added" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                [alert3 show];
               // [alert3 release];
                
            }
            else
            {
                s=1;
                UIAlertView *alert3=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"After Adding amount total less than zero, Please check discount Amount" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                [alert3 show];
            }
        }
        else if(counter2==1)
        {
            float tempTotal=totalK-discount2; 
            
            
           // DLog(@"Discount Amount2 : %f",discount2);
            
            if(tempTotal>=0)
            {
                [self voidrebate];
               // [self voiddiscount];
                [self discountAddedToServer:tableNumber cName:@"Rebate" vValue:[NSString stringWithFormat:@"%@",t222] isDu:@"1" inF:@"0"];
                [billView reload];
                UIAlertView *alert3=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Rebate Added" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                [alert3 show];
               // [alert3 release];
                
            }
            else
            {
                s=1;
                UIAlertView *alert3=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"After Adding amount total less than zero, Please check discount Amount" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                [alert3 show];
            }
        }
        
        if(s==0)
        {
            if([t111 length]==0 && [t222 length]==0)
            {
                UIAlertView *alert3=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Both Discount fields are empty." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil]; 
                [alert3 show];
            }
            else
            {
               // TabSquareTableStatus *SalesReport1=[[TabSquareTableStatus alloc]initWithNibName:@"TabSquareTableStatus" bundle:nil];
             //   SalesReport1.tableNumber=tableNumber;
                //[self dismissModalViewControllerAnimated:NO];
              //  [self presentModalViewController:SalesReport1 animated:YES];
                [billView reload];
            }
        }
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
        [self voiddiscount];
        [self voidrebate];
        [billView reload];
        UIAlertView *alert3=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Discount Voided" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert3 show];
        //[alert3 release];
        
        
    }
}

-(void)voiddiscount
{
    NSString *post =[NSString stringWithFormat:@"table_id=%@&key=%@",tableNumber, [ShareableData appKey]];
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    NSString *url_string = [NSString stringWithFormat:@"%@/webs/apply_void_discount", [ShareableData serverURL]];
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
    DLog(@"Result : %@",data);
    
   /* TabSquareTableStatus *SalesReport1=[[TabSquareTableStatus alloc]initWithNibName:@"TabSquareTableStatus" bundle:nil];
    SalesReport1.tableNumber=tableNumber;
    //[self dismissModalViewControllerAnimated:NO];
    [self presentModalViewController:SalesReport1 animated:YES];*/
    
}
-(void)voidrebate
{
    NSString *post =[NSString stringWithFormat:@"table_id=%@&key=%@",tableNumber, [ShareableData appKey]];
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    NSString *url_string = [NSString stringWithFormat:@"%@/webs/apply_void_rebate", [ShareableData serverURL]];
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
    DLog(@"Result : %@",data);
    
    /*TabSquareTableStatus *SalesReport1=[[TabSquareTableStatus alloc]initWithNibName:@"TabSquareTableStatus" bundle:nil];
    SalesReport1.tableNumber=tableNumber;
    //[self dismissModalViewControllerAnimated:NO];
    [self presentModalViewController:SalesReport1 animated:YES];*/
    
}




@end
