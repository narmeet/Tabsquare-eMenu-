//
//  ViewBillHistory.m
//  TabSquareMenu
//
//  Created by Nikhil Kumar on 10/08/12.
//  Copyright (c) 2012 Trendsetterz. All rights reserved.
//

#import "ViewBillHistory.h"
#import "EditOrder.h"

@interface ViewBillHistory ()

@end

@implementation ViewBillHistory
@synthesize ReportValues,ReportListTable,ReportListValues,ReportSummaryTable;

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
    ReportValues=[[NSMutableArray alloc]init];
    
    [ReportValues addObject:@"Mila Jula Pakoras"];
    [ReportValues addObject:@"Gobi Manchurian"];
    [ReportValues addObject:@"Jal Jeera"];
    [ReportValues addObject:@"Vodaka( On the rocks)"];
    [ReportValues addObject:@"Murga Kormar"];
    [ReportValues addObject:@"Palak Panner"];
    [ReportValues addObject:@"Lasuni Naan"];
    [ReportValues addObject:@"Sub-Total"];
    [ReportValues addObject:@"GST @ 7%"];
    [ReportValues addObject:@"Service charges 10%"];
    [ReportValues addObject:@""];
    
    ReportListValues=[[NSMutableArray alloc]init];
    
    [ReportListValues addObject:@"B1001"];
    [ReportListValues addObject:@"B1001"];
    [ReportListValues addObject:@"B1001"];
    [ReportListValues addObject:@"B1001"];
    [ReportListValues addObject:@"B1001"];
    [ReportListValues addObject:@"B1001"];
    [ReportListValues addObject:@"B1001"];
    [ReportListValues addObject:@"B1001"];
    
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
        if(tableView==ReportListTable)
    return [ReportListValues count];
    
    return [ReportValues count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    
    if(tableView==ReportListTable)
    {
        //cell.textLabel.text=[ReportListValues objectAtIndex:indexPath.row];
        UILabel *ItemName=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 270, 20)];
        ItemName.text= ReportListValues[indexPath.row];;
        ItemName.textAlignment=UITextAlignmentLeft;
        ItemName.font=[UIFont boldSystemFontOfSize:18];
        [cell.contentView addSubview:ItemName];
        
        UILabel *ItemQuantity=[[UILabel alloc]initWithFrame:CGRectMake(280, 0, 50, 20)];
        ItemQuantity.text= ReportListValues[indexPath.row];;
        ItemQuantity.textAlignment=UITextAlignmentLeft;
        ItemQuantity.font=[UIFont boldSystemFontOfSize:14];
        [cell.contentView addSubview:ItemQuantity];
        
        UILabel *ItemRate=[[UILabel alloc]initWithFrame:CGRectMake(400, 0, 200, 20)];
        ItemRate.text= ReportListValues[indexPath.row];;
        ItemRate.textAlignment=UITextAlignmentLeft;
        ItemRate.font=[UIFont boldSystemFontOfSize:14];
        [cell.contentView addSubview:ItemRate];

    }
    else
    {
          //  cell.textLabel.text=[ReportValues objectAtIndex:indexPath.row];
        UILabel *ItemName=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 270, 20)];
        ItemName.text= ReportValues[indexPath.row];;
        ItemName.textAlignment=UITextAlignmentLeft;
        ItemName.font=[UIFont boldSystemFontOfSize:18];
        [cell.contentView addSubview:ItemName];
        
        UILabel *ItemQuantity=[[UILabel alloc]initWithFrame:CGRectMake(280, 0, 50, 20)];
        ItemQuantity.text= ReportValues[indexPath.row];;
        ItemQuantity.textAlignment=UITextAlignmentLeft;
        ItemQuantity.font=[UIFont boldSystemFontOfSize:14];
        [cell.contentView addSubview:ItemQuantity];
        
        UILabel *ItemRate=[[UILabel alloc]initWithFrame:CGRectMake(400, 0, 200, 20)];
        ItemRate.text= ReportValues[indexPath.row];;
        ItemRate.textAlignment=UITextAlignmentLeft;
        ItemRate.font=[UIFont boldSystemFontOfSize:14];
        [cell.contentView addSubview:ItemRate];

    }
    return cell;
}

- (IBAction)EditBillButtonClick:(id)sender
{
	EditOrder *SalesSummaryReport=[[EditOrder alloc]initWithNibName:@"EditOrder" bundle:nil];
    [self.navigationController dismissViewControllerAnimated:NO completion:nil];
    [self.navigationController pushViewController:SalesSummaryReport animated:YES];
}

- (IBAction)ReprintBillButtonClick:(id)sender
{
	EditOrder *SalesSummaryReport=[[EditOrder alloc]initWithNibName:@"EditOrder" bundle:nil];
     [self.navigationController dismissViewControllerAnimated:NO completion:nil];
   [self.navigationController pushViewController:SalesSummaryReport animated:YES];
}

@end
