//
//  TabSquareSoupViewController.m
//  TabSquareMenu
//
//  Created by Nikhil Kumar on 7/10/12.
//  Copyright (c) 2012 Trendsetterz. All rights reserved.
//

#import "TabSquareSoupViewController.h"
#import "TabSquareMenuDetailController.h"
#import "ShareableData.h"
#import "TabSquareOrderSummaryController.h"
#import "TabSquareMenuController.h"
#import <QuartzCore/QuartzCore.h>
#import "TabSquareMenuController.h"

@implementation TabSquareSoupViewController

@synthesize tomatoSoup,chickenSoup,menuDetail;
@synthesize menuView,lblheading;
@synthesize DishImage,orderSummary,catMenuLabel;
@synthesize DishName1,DishName2,DishPrice1,DishPrice2,DishQuantity1,DishQuantity2;
@synthesize DishCatId;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated{
    
    NSString *img_name1 = [NSString stringWithFormat:@"%@%@_%@", PRE_NAME, POPUP_IMAGE,[ShareableData appKey]];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);;
    NSString *libraryDirectory = [paths lastObject];
    NSString *location = [NSString stringWithFormat:@"%@/%@%@",libraryDirectory,img_name1,@".png"];
    
    UIImage *img1 = [UIImage imageWithContentsOfFile:location];
    
    bgImage.image = img1;
    
}

-(UIButton*)createMinusbutton
{
    UIButton *add=[UIButton buttonWithType:UIButtonTypeCustom];
    add.frame=CGRectMake(290, 9, 35, 28);
    [add setImage:[UIImage imageNamed:@"minus.png"] forState:UIControlStateNormal];
    [add setImage:[UIImage imageNamed:@"minus.png"] forState:UIControlStateHighlighted];
    [add setImage:[UIImage imageNamed:@"minus.png"] forState:UIControlStateSelected];
    //[add addTarget:self action:@selector(addBeerListView) forControlEvents:UIControlEventTouchUpInside];
    return add;
}

-(UIButton*)createPlusbutton
{
    UIButton *add=[UIButton buttonWithType:UIButtonTypeCustom];
    add.frame=CGRectMake(354, 9, 35, 28);
    [add setImage:[UIImage imageNamed:@"plus.png"] forState:UIControlStateNormal];
    [add setImage:[UIImage imageNamed:@"plus.png"] forState:UIControlStateHighlighted];
    [add setImage:[UIImage imageNamed:@"plus.png"] forState:UIControlStateSelected];
    //[add addTarget:self action:@selector(addBeerListView) forControlEvents:UIControlEventTouchUpInside];
    return add;
}

-(void)addLabelAndButton:(UIView*)view
{
    if (self.goToMenuBtn.tag == 8){
        tomatoSoup.hidden = YES;
        chickenSoup.hidden = YES;
    }else{
        tomatoSoup.hidden = NO;
        chickenSoup.hidden = NO;
    }
    UIImageView *backImg=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"labelstrip.png"]];
    backImg.frame=CGRectMake(0, 0, view.frame.size.width,view.frame.size.height);
    [view addSubview:backImg];
    
    //add label header
    UILabel *drinkName=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, view.frame.size.width,view.frame.size.height)];
    if(view==tomatoSoup)
    {
        drinkName.text=@"Rich Tomato Soup"; 
    }
    else {
        drinkName.text=@"Spicy Chicken Soup";
    }
    drinkName.backgroundColor=[UIColor clearColor];
    drinkName.font=[UIFont boldSystemFontOfSize:16];
    drinkName.tag=1;
    [view addSubview:drinkName];
    
    //add a minus button
    UIButton *add=[self createMinusbutton];
    [view addSubview:add];
    
    //add a plus button
    UIButton *addplus=[self createPlusbutton];
    [view addSubview:addplus];
    
    //add a label
    UILabel *text=[[UILabel alloc]initWithFrame:CGRectMake(324, 6, 35,33)];
    text.backgroundColor=[UIColor colorWithRed:253.0f/255.0f green:214.0f/255.0f blue:162.0f/255.0f alpha:1.0];
    text.textAlignment=UITextAlignmentCenter;
    text.font=[UIFont boldSystemFontOfSize:16];
    text.text=@"0";
    [view addSubview:text];    
    
}


- (void)viewDidLoad
{
    self.view.layer.borderWidth=3.0;
    self.view.layer.borderColor=[UIColor colorWithRed:168.0f/255.0f green:49.0f/255.0f blue:19.0f/255.0f alpha:1.0].CGColor;
    DishQuantity1.layer.borderWidth=1.0;
    DishQuantity1.layer.borderColor=[UIColor colorWithRed:242.0f/255.0f green:143.0f/255.0f blue:15.0f/255.0f alpha:1.0].CGColor;
    DishQuantity2.layer.borderWidth=1.0;
    DishQuantity2.layer.borderColor=[UIColor colorWithRed:242.0f/255.0f green:143.0f/255.0f blue:15.0f/255.0f alpha:1.0].CGColor;
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
   //  DLog(@"TabSquareSoupViewController Load");
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
   // DLog(@"TabSquareSoupViewController UnLoad");
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}


-(void)addItemInOrderSummary
{
    for(int i=0;i<[orderSummary.DishID count];++i)
    {
        [[ShareableData sharedInstance].OrderItemID addObject:(orderSummary.DishID)[i]]; 
        [[ShareableData sharedInstance].OrderItemName addObject:(orderSummary.DishName)[i]]; 
        [[ShareableData sharedInstance].OrderItemRate addObject:(orderSummary.DishPrice)[i]];
        [[ShareableData sharedInstance].IsOrderCustomization addObject:@"0"];
        [[ShareableData sharedInstance].OrderCustomizationDetail addObject:@"0"];
        if(i==0)
        {
            [[ShareableData sharedInstance].OrderItemQuantity addObject:DishQuantity1.text];
        }
        else {
            [[ShareableData sharedInstance].OrderItemQuantity addObject:DishQuantity2.text];
        }
        [[ShareableData sharedInstance].OrderSpecialRequest addObject:@"0"];
        [[ShareableData sharedInstance].OrderCatId addObject:(orderSummary.DishCat)[i]];
        [[ShareableData sharedInstance].confirmOrder addObject:@"0"];       
    }

}


-(IBAction)addClicked:(id)sender
{
    @try
    {
        [self addItemInOrderSummary];        
        [self.view removeFromSuperview];
        [menuDetail.view removeFromSuperview];
        [orderSummary filterData];
        [orderSummary.OrderList reloadData];
        [orderSummary CalculateTotal];
        
    }
    @catch (NSException *exception) 
    {
       DLog(@"Exception found: %@",exception); 
    }
    @finally {
        
    }
    
}

-(IBAction)skipClicked:(id)sender
{
    @try
    {
        [self.view removeFromSuperview];
        [orderSummary confirmOrder];

    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}

-(IBAction)menuClicked:(id)sender
{
    @try
    {
        //NSLOG(@"Category Tag: %@",sender);
        
        
        //manoj
        [orderSummary.menuView overviewBtnClicked2:sender];
        
        [orderSummary.view removeFromSuperview];
        
        //  [orderSummary.menuView KinarasetCategoryClicked:4];
        //  [orderSummary.menuView KinaraCategoryClicked:sender];
        //  [orderSummary.menuView showMenuHighlight];
        //  [menuView kinaraSetCategoryClicked:sender];//
        // orderSummary.menuView scrollView
        //  [orderSummary.menuView KinaraCategoryClicked:sender];
        // menuView setc
    }
    @catch (NSException *exception) {
        
        DLog(@"Exception found: %@",exception);
        
    }
    @finally {
        //orderSummary.menuView.isRecon = @"0";
        
    }
    //[orderSummary.menudetailView];

}

-(IBAction)addTotatoSoup
{
    int val=[DishQuantity1.text intValue];
    ++val;
    DishQuantity1.text=[NSString stringWithFormat:@"%d",val]; 
}

-(IBAction)minusTotatoSoup
{
    int val=[DishQuantity1.text intValue];
     if(val>0)
    --val;
    DishQuantity1.text=[NSString stringWithFormat:@"%d",val]; 
}

-(IBAction)addChickenSoup
{
    int val=[DishQuantity2.text intValue];
    ++val;
    DishQuantity2.text=[NSString stringWithFormat:@"%d",val]; 
}

-(IBAction)minusChickenSoup
{
    int val=[DishQuantity2.text intValue];
     if(val>0)
    --val;
    DishQuantity2.text=[NSString stringWithFormat:@"%d",val]; 
}

@end
