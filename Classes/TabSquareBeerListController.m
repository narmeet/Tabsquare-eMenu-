//
//  TabSquareBeerListController.m
//  TabSquareMenu
//
//  Created by Nikhil Kumar on 7/9/12.
//  Copyright (c) 2012 Trendsetterz. All rights reserved.
//

#import "TabSquareBeerListController.h"
#import <QuartzCore/QuartzCore.h>
#import "TabSquareBeerController.h"
#import "TabSquareBeerDetailController.h"
#import "ShareableData.h"

@implementation TabSquareBeerListController

@synthesize whiskyView,limeView,requestView,drinklistView,beverageDetailView;
@synthesize beverageQuantity,beverageCatID;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(UIButton*)createMinusbutton:(int)index
{
    UIButton *add=[UIButton buttonWithType:UIButtonTypeCustom];
    add.frame=CGRectMake(290, 9, 35, 28);
    add.tag=index;
    [add setImage:[UIImage imageNamed:@"minus.png"] forState:UIControlStateNormal];
    [add setImage:[UIImage imageNamed:@"minus.png"] forState:UIControlStateHighlighted];
    [add setImage:[UIImage imageNamed:@"minus.png"] forState:UIControlStateSelected];
    [add addTarget:self action:@selector(minusBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    return add;
}

-(UIButton*)createPlusbutton:(int)index
{
    UIButton *add=[UIButton buttonWithType:UIButtonTypeCustom];
    add.frame=CGRectMake(354, 9, 35, 28);
    add.tag=index;
    [add setImage:[UIImage imageNamed:@"plus.png"] forState:UIControlStateNormal];
    [add setImage:[UIImage imageNamed:@"plus.png"] forState:UIControlStateHighlighted];
    [add setImage:[UIImage imageNamed:@"plus.png"] forState:UIControlStateSelected];
    [add addTarget:self action:@selector(plusBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    return add;
}

-(UIView*)addLabelAndButton:(UITableViewCell*)cell indexPath:(NSInteger)index
{
    //CGFloat width=cell.frame.size.width;
    UIView *cellView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 406,45)];
    cellView.backgroundColor=[UIColor clearColor];
    
    UIImageView *backImg=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"labelstrip.png"]];
    backImg.frame=CGRectMake(0, 0, cellView.frame.size.width,44);
    [cellView addSubview:backImg];
    
    //add label header
    
    UILabel *drinkName=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, 140, 45)];
    drinkName.text=(beverageDetailView.beverageView.beverageName)[index];
    drinkName.backgroundColor=[UIColor clearColor];
    drinkName.font=[UIFont systemFontOfSize:16];
    [cellView addSubview:drinkName];
    
    //add price label
    UILabel *price=[[UILabel alloc]initWithFrame:CGRectMake(212, 0, 60,45)];
    price.backgroundColor=[UIColor clearColor];
    price.font=[UIFont systemFontOfSize:16];
    price.text=(beverageDetailView.beverageView.beveragePrice)[index];
    [cellView addSubview:price];
    
    //add a plus button
    UIButton *addplus=[self createPlusbutton:index];
    [cellView addSubview:addplus];
    
    //add a label
    UILabel *text=[[UILabel alloc]initWithFrame:CGRectMake(324, 6, 33,33)];
    text.backgroundColor=[UIColor clearColor];
    text.textAlignment=NSTextAlignmentCenter;
    text.font=[UIFont systemFontOfSize:16];
    text.backgroundColor=[UIColor colorWithRed:253.0f/255.0f green:214.0f/255.0f blue:162.0f/255.0f alpha:1.0];
    text.text=@"0";
    for(int i=0;i<[beverageDetailView.addBeverageId count];i++)
    {
        int beverageIndex=[(beverageDetailView.addBeverageId)[i]intValue];
        if(beverageIndex==index)
        {
            text.text=@"1";
            break;
        }
    }
    if([beverageQuantity count]>index)
    {
        beverageQuantity[index] = text.text;
    }
    
    text.tag=5;
    [cellView addSubview:text];    
    
    //add a minus button
    UIButton *add=[self createMinusbutton:index];
    [cellView addSubview:add];
    [add bringSubviewToFront:cellView];
    
    return cellView;
    
}

-(void)addWhiskyLime:(UIView*)view
{
    UIImageView *backImg=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"labelstrip.png"]];
    backImg.frame=CGRectMake(0, 0, view.frame.size.width,view.frame.size.height);
    [view addSubview:backImg];
    
    //add label header
    UILabel *drinkName=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, view.frame.size.width,view.frame.size.height)];
    if(view==whiskyView)
    {
        drinkName.text=@"Whisky Glasses"; 
    }
    else 
    {
        drinkName.text=@"Lime slices";
    }
    drinkName.backgroundColor=[UIColor clearColor];
    drinkName.font=[UIFont boldSystemFontOfSize:15];
    [view addSubview:drinkName];
    
    //add a minus button
    UIButton *add=[self createMinusbutton:-1];
    [view addSubview:add];
    
    //add a plus button
    UIButton *addplus=[self createPlusbutton:-1];
    [view addSubview:addplus];
    
    //add a label
    UILabel *text=[[UILabel alloc]initWithFrame:CGRectMake(324, 6, 35,33)];
    text.backgroundColor=[UIColor colorWithRed:253.0f/255.0f green:214.0f/255.0f blue:162.0f/255.0f alpha:1.0];
    text.textAlignment=NSTextAlignmentCenter;
    text.font=[UIFont boldSystemFontOfSize:16];
    text.tag=5;
    text.text=@"0";
    [view addSubview:text];    
    
}

-(void)setTextValue:(int)type currentView:(UIView*)view btnindex:(int)index
{
    for(UIView *subview in [view subviews]) 
    {
        if([subview isKindOfClass:[UILabel class]])
        {
            UILabel *label=(UILabel*)subview;
            if(label.tag==5)
            {
                int val=[label.text intValue];
                if(type==0)
                {
                    ++val;
                }
                else if(type==1)
                {
                    if(val>0)
                    {
                        --val; 
                    }
                }
                label.text=[NSString stringWithFormat:@"%d",val];
                if(index!=-1)
                beverageQuantity[index] = label.text;
            }
        }
    }
}

-(IBAction)plusBtnClick:(id)sender
{
    UIButton *btn=(UIButton*)sender;
    UIView *view=[btn superview];
    [self setTextValue:0 currentView:view btnindex:btn.tag];
}

-(IBAction)minusBtnClick:(id)sender
{
    UIButton *btn=(UIButton*)sender;
    UIView *view=[btn superview];
    [self setTextValue:1 currentView:view btnindex:btn.tag]; 
}

-(void)viewDidLoad
{
    requestView.layer.borderWidth=2.0;
    requestView.layer.borderColor=[UIColor colorWithRed:168.0f/255.0f green:49.0f/255.0f blue:19.0f/255.0f alpha:1.0].CGColor;   drinklistView.layer.borderWidth=2.0;
    drinklistView.layer.borderColor=[UIColor colorWithRed:168.0f/255.0f green:49.0f/255.0f blue:19.0f/255.0f alpha:1.0].CGColor; beverageQuantity=[[NSMutableArray alloc]init];
    [super viewDidLoad];
    [self addWhiskyLime:whiskyView];
    [self addWhiskyLime:limeView];
    // Do any additional setup after loading the view from its nib.
}

-(void)addObjectsInBeverage
{
    for(int i=0;i<[beverageDetailView.beverageView.beverageName count];i++)
    {
        [beverageQuantity addObject:[NSString stringWithFormat:@"%d",0]];
    }
}


-(void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    //DLog(@"TabSquareBeerListController UnLoad");
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

-(IBAction)doneClicked:(id)sender
{
    for(int i=0;i<[beverageDetailView.beverageView.beverageName count];i++)
    {
       // DLog(@"beverageId%@",[beverageDetailView.beverageView.beverageID objectAtIndex:i]);
      //  DLog(@"beverageName%@",[beverageDetailView.beverageView.beverageName objectAtIndex:i]);
      //  DLog(@"beveragePrice%@",[beverageDetailView.beverageView.beveragePrice objectAtIndex:i]);
      //  DLog(@"beverageQunatity%@",[beverageQuantity objectAtIndex:i]);
        
        [[ShareableData sharedInstance].OrderCatId addObject:beverageCatID];
        [[ShareableData sharedInstance].OrderItemID addObject:(beverageDetailView.beverageView.beverageID)[i]]; 
        [[ShareableData sharedInstance].OrderItemName addObject:(beverageDetailView.beverageView.beverageName)[i]]; 
        [[ShareableData sharedInstance].OrderItemRate addObject:(beverageDetailView.beverageView.beveragePrice)[i]];
        [[ShareableData sharedInstance].OrderItemQuantity addObject:beverageQuantity[i]];
        [[ShareableData sharedInstance].confirmOrder addObject:@"0"];
    }
    
    if(![self.requestView.text isEqualToString:@""])
    {
        [[ShareableData sharedInstance].OrderItemID addObject:@"SpecialS1"]; 
        [[ShareableData sharedInstance].OrderItemName addObject:self.requestView.text]; 
        [[ShareableData sharedInstance].OrderItemRate addObject:@"0"];
        [[ShareableData sharedInstance].OrderItemQuantity addObject:@"1"];
    }
      dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
          /*  [[NSUserDefaults standardUserDefaults] setObject:[ShareableData sharedInstance].OrderItemID forKey:@"OrderItemID"];
           [[NSUserDefaults standardUserDefaults] setObject:[ShareableData sharedInstance].OrderItemName forKey:@"OrderItemName"];
           [[NSUserDefaults standardUserDefaults] setObject:[ShareableData sharedInstance].OrderItemRate forKey:@"OrderItemRate"];
           [[NSUserDefaults standardUserDefaults] setObject:[ShareableData sharedInstance].OrderCatId forKey:@"OrderCatId"];
           [[NSUserDefaults standardUserDefaults] setObject:[ShareableData sharedInstance].IsOrderCustomization forKey:@"IsOrderCustomization"];
           [[NSUserDefaults standardUserDefaults] setObject:[ShareableData sharedInstance].OrderCustomizationDetail forKey:@"OrderCustomizationDetail"];
           [[NSUserDefaults standardUserDefaults] setObject:[ShareableData sharedInstance].OrderSpecialRequest forKey:@"OrderSpecialRequest"];
           [[NSUserDefaults standardUserDefaults] setObject:[ShareableData sharedInstance].OrderItemQuantity forKey:@"OrderItemQuantity"];
           [[NSUserDefaults standardUserDefaults] setObject:[ShareableData sharedInstance].confirmOrder forKey:@"confirmOrder"];
           [[NSUserDefaults standardUserDefaults] setObject:[ShareableData sharedInstance].OrderId forKey:@"OrderId"];
           [[NSUserDefaults standardUserDefaults] setObject:[ShareableData sharedInstance].assignedTable1 forKey:@"assignedTable1"];
           [[NSUserDefaults standardUserDefaults] setObject:[ShareableData sharedInstance].assignedTable1 forKey:@"assignedTable2"];
           [[NSUserDefaults standardUserDefaults] setObject:[ShareableData sharedInstance].assignedTable1 forKey:@"assignedTable3"];
           [[NSUserDefaults standardUserDefaults] setObject:[ShareableData sharedInstance].assignedTable1 forKey:@"assignedTable4"];*/
          NSArray *array=@[[ShareableData sharedInstance].OrderItemID,[ShareableData sharedInstance].OrderItemName,[ShareableData sharedInstance].OrderItemRate,[ShareableData sharedInstance].OrderCatId,[ShareableData sharedInstance].IsOrderCustomization,[ShareableData sharedInstance].OrderCustomizationDetail,[ShareableData sharedInstance].OrderSpecialRequest,[ShareableData sharedInstance].OrderItemQuantity,[ShareableData sharedInstance].confirmOrder];
          NSArray *array2 = @[[ShareableData sharedInstance].OrderId,[ShareableData sharedInstance].assignedTable1,[ShareableData sharedInstance].assignedTable2,[ShareableData sharedInstance].assignedTable3,[ShareableData sharedInstance].assignedTable4,[ShareableData sharedInstance].salesNo];;
          
          NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);;
          NSString *libraryDirectory = [paths lastObject];
          NSString *location = [libraryDirectory stringByAppendingString:@"/orderarrays.plist"];
          NSString *location2 = [libraryDirectory stringByAppendingString:@"/orderstrings.plist"];
          [array writeToFile:location atomically:YES];
          [array2 writeToFile:location2 atomically:YES];
          DLog(@"Added to Temp");
          
          // [[NSUserDefaults standardUserDefaults] synchronize];
});

    [self.view removeFromSuperview];
    
    
}

-(IBAction)closeClicked:(id)sender
{
    [self.view removeFromSuperview];
}


- (void)viewWillAppear:(BOOL)animated
{
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
    rect.origin.y -= 85;
    rect.size.height += 85;
    self.view.frame = rect;
    [UIView commitAnimations];
}

-(void)keyboardWillHide
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    CGRect rect = self.view.frame;
    rect.origin.y += 85;
    rect.size.height -= 85;
    self.view.frame = rect;
    [UIView commitAnimations];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [beverageDetailView.beverageView.beverageName count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{   
     NSString *CellIdentifier = [NSString stringWithFormat: @"TableViewCellIdentifier%d",indexPath.row ];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) 
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];       
    
    UIView *detailView=[self addLabelAndButton:cell indexPath:indexPath.row];
    detailView.tag=10;
    [cell.contentView addSubview:detailView];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 42;
}




@end
