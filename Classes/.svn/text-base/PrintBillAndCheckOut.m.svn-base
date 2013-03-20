//
//  PrintBillAndCheckOut.m
//  TabSquareMenu
//
//  Created by Nikhil Kumar on 09/08/12.
//  Copyright (c) 2012 Trendsetterz. All rights reserved.
//

#import "PrintBillAndCheckOut.h"
#import "PrintBillAndCheckOutFinal.h"

@interface PrintBillAndCheckOut ()

@end

@implementation PrintBillAndCheckOut

@synthesize ReportSummaryTable,ReportValues;

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
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    ReportValues=[[NSMutableArray alloc]init];
    
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
    
    return cell;
}

- (IBAction)TakeOrderButtonClick:(id)sender
{
	PrintBillAndCheckOutFinal *SalesSummaryReport=[[PrintBillAndCheckOutFinal alloc]initWithNibName:@"PrintBillAndCheckOutFinal" bundle:nil];
   // [self dismissModalViewControllerAnimated:NO];
     [self.navigationController dismissViewControllerAnimated:NO completion:nil];
    [self.navigationController pushViewController:SalesSummaryReport animated:YES];
}

@end
