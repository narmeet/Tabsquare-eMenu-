//
//  SalesReport.m
//  TabSquareMenu
//
//  Created by Nikhil Kumar on 09/08/12.
//  Copyright (c) 2012 Trendsetterz. All rights reserved.
//

#import "SalesReport.h"
#import "SalesReportDetail.h"
#import "TabSquareTableManagement.h"
#import "SBJSON.h"
#import "ShareableData.h"

#import <QuartzCore/CALayer.h>

@interface SalesReport ()

@end

@implementation SalesReport

@synthesize txtdate,txtshift,v1,shiftID,shiftName,DDate,ShiftPicker,ShiftIDV,txtTodate,ToDate;

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

-(void)viewDidLoad
{
    billView.hidden=YES;
    printPDFBtn.hidden=YES;
    v1.layer.cornerRadius=12.0;
    [super viewDidLoad];
    
    shiftID=[[NSMutableArray alloc]init ];
    shiftName=[[NSMutableArray alloc]init ];
    
    txtshift.text=@"All";
    ShiftIDV=@"-1";
    
    [self getshifts];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
-(void)clearSubViews
{
    [billView stopLoading];
    
    for(UIView *sub_view in self.view.subviews)
        [sub_view removeFromSuperview];
    
    billView = nil;
    self.txtdate = nil;
    self.txtshift = nil;
    self.v1 = nil;
    self.shiftID = nil;
    self.shiftName = nil;
    self.DDate = nil;
    self.ShiftPicker = nil;
    self.ShiftIDV = nil;
    self.txtTodate = nil;
    self.ToDate = nil;
    
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    if (CGRectContainsPoint([self.txtdate frame], [touch locationInView:self.view])
        ||CGRectContainsPoint([self.txtTodate frame], [touch locationInView:self.view])
        ||CGRectContainsPoint([self.txtshift frame], [touch locationInView:self.view])
        )
    {
        
    }
    else
    {
        [txtdate resignFirstResponder];
        [txtTodate resignFirstResponder];
        [txtshift resignFirstResponder];
    }
}





-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

-(IBAction)ReportSummary:(id)sender
{
	SalesReportDetail *SalesSummaryReport=[[SalesReportDetail alloc]initWithNibName:@"SalesReportDetail" bundle:nil];
    
    SalesSummaryReport.txtdate=txtdate.text;
    SalesSummaryReport.txtshift=ShiftIDV;
    SalesSummaryReport.txtdateTo=txtTodate.text;
    
    [self hideBoth];
    //[self dismissModalViewControllerAnimated:NO];
   [self.navigationController pushViewController:SalesSummaryReport animated:YES];
    
}
-(IBAction)printPDF{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"How would you like to view the report?"
                                                   delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Email",@"Print", nil];
    //alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
     
    
}
-(IBAction)printItemReport{
    
  /*  NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://108.178.27.242/luigiEx/qtyReport.php?date=%@&to=%@&shift=%@",txtdate.text,txtTodate.text,ShiftIDV]]];
    
    NSError *error;
    NSURLResponse *response;
    NSData *uData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSString *data=[[NSString alloc]initWithData:uData encoding:NSUTF8StringEncoding];*/
    NSURL *targetURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@Ex/qtyReportHTML.php?date=%@&to=%@&shift=%@&key=%@", [ShareableData serverURL],txtdate.text,txtTodate.text,ShiftIDV, [ShareableData appKey]]];
    NSURLRequest *request = [NSURLRequest requestWithURL:targetURL];
    [billView loadRequest:request];
    
    billView.hidden=NO;
    printPDFBtn.hidden=NO;
    
}
-(IBAction)showBills{
    
    NSURL *targetURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@Ex/reportsList.php?date=%@&to=%@&shift=%@&key=%@", [ShareableData serverURL],txtdate.text,txtTodate.text,ShiftIDV, [ShareableData appKey]]];
    NSURLRequest *request = [NSURLRequest requestWithURL:targetURL];
    [billView loadRequest:request];
    
    billView.hidden=NO;
    
}

-(IBAction)Back:(id)sender
{
    if (billView.hidden == YES){
    [self hideBoth];
    //TabSquareTableManagement *SalesReport1=[[TabSquareTableManagement alloc]initWithNibName:@"TabSquareTableManagement" bundle:nil];
    // [self dismissModalViewControllerAnimated:NO];
   // [self presentModalViewController:SalesReport1 animated:YES];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        if (billView.canGoBack){
            [billView goBack];
        }else{
        billView.hidden=YES;
            printPDFBtn.hidden=YES;
        }
    }
}


-(void)getshifts
{
    
    NSString *post =[NSString stringWithFormat:@"key=%@", [ShareableData appKey]];
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    NSString *url_string = [NSString stringWithFormat:@"%@/webs/get_shifts", [ShareableData serverURL]];
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
    
    [shiftID addObject:@"-1"];
    [shiftName addObject:@"All"];

    
    for(int i=0;i<[resultFromPost count];i++)
    {
        NSMutableDictionary *dataitem=resultFromPost[i];
        [shiftID addObject:[NSString stringWithFormat:@"%@",dataitem[@"id"]]];
        [shiftName addObject:[NSString stringWithFormat:@"%@",dataitem[@"name"]]];
       
    }
    
    
}

-(IBAction)datePickerValueChanged: (id)sender 
{
    NSDate *selectedDate = [sender date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSString *theDate = [dateFormat stringFromDate:selectedDate];
    txtdate.text=theDate;
    //DLog(@"Date : %@",theDate);
}

-(IBAction)datePickerValueChangedTo: (id)sender 
{
    NSDate *selectedDate = [sender date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSString *theDate = [dateFormat stringFromDate:selectedDate];
    txtTodate.text=theDate;
    //DLog(@"Date : %@",theDate);
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
{
    return [shiftName count];
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
   // DLog(@"Slected : %@",[shiftName objectAtIndex:row]);
    txtshift.text=shiftName[row];
    ShiftIDV=shiftID[row];
    ShiftPicker.hidden=YES;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;
{   
    return shiftName[row];
}

-(IBAction)showShiftPicker
{
    ShiftPicker.hidden=false;
     DDate.hidden=YES;
    ToDate.hidden=YES;
   //DLog(@"Show Shift Picker View");
}

-(IBAction)showDatePicker
{
    DDate.hidden=false;
    ShiftPicker.hidden=YES;
    ToDate.hidden=YES;
    //DLog(@"Show Date Picker View");
}

-(IBAction)showDatePickerTo
{
    DDate.hidden=YES;
    ToDate.hidden=false;
    ShiftPicker.hidden=YES;
    //DLog(@"Show Date Picker View");
}

-(IBAction)hideBoth
{
    ShiftPicker.hidden=YES;
    DDate.hidden=YES;
    ToDate.hidden=YES;
   //DLog(@"Hide Both Date/Shift Picker View");
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
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@Ex/qtyReport.php?date=%@&to=%@&shift=%@&key=%@", [ShareableData serverURL],txtdate.text,txtTodate.text,ShiftIDV, [ShareableData appKey]]]];
        
        NSError *error;
       NSURLResponse *response;
        NSData *uData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        NSString *data=[[NSString alloc]initWithData:uData encoding:NSUTF8StringEncoding];
    }
    
    
    if ([title isEqualToString:@"Send"]){
        UITextField *emailT = [alertView textFieldAtIndex:0];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@Ex/saveToPDF.php?date=%@&to=%@&shift=%@&email=%@&key=%@", [ShareableData serverURL],txtdate.text,txtTodate.text,ShiftIDV,[emailT.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding ], [ShareableData appKey]]]];
    
    NSError *error;
    NSURLResponse *response;
    NSData *uData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSString *data=[[NSString alloc]initWithData:uData encoding:NSUTF8StringEncoding];
        DLog(@"%@",data);
    }
}

@end


//---

