//
//  TabSquareBeerDetailController.m
//  TabSquareMenu
//
//  Created by Nikhil Kumar on 7/7/12.
//  Copyright (c) 2012 Trendsetterz. All rights reserved.
//

#import "TabSquareBeerDetailController.h"
#import <QuartzCore/QuartzCore.h>
#import "TabSquareBeerListController.h"
#import "TabSquareBeerController.h"
#import "ShareableData.h"
#import "TabSquareMenuDetailController.h"
#import "TabSquareDBFile.h"
#import "TabSquareFlurryTracking.h"
#import "TabSquareCommonClass.h"

@implementation TabSquareBeerDetailController

@synthesize detailImageView,drinkName,drinkImage;
@synthesize beerListView,drinkDiscription,beverageView,addBeverageId,addBeverageQunatity;
@synthesize beverageCatId,tempDishID;
@synthesize beverageCustomization,beverageCutType,selectedIndex;
@synthesize customizationView,beverageSkUView,beverageSKUDetail,leftArrow,rightArrow;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
        // Custom initialization
        self.view.frame=CGRectMake(0,4, self.view.frame.size.width, self.view.frame.size.height);
    }
    return self;
}
-(void)addBlankCustomizationView
{
    NSMutableDictionary *skudetail=beverageSKUDetail[beverageSkuIndex];
    customizationView.KKselectedID  =skudetail[@"sku_id"];
    NSString *beverageName=[NSString stringWithFormat:@"%@(%@)",(beverageView.beverageName)[[self.selectedIndex intValue]],skudetail[@"sku_name"]];
    customizationView.KKselectedName=beverageName;
    customizationView.KKselectedRate=skudetail[@"sku_price"];
    customizationView.KKselectedCatId=beverageCatId;
    customizationView.DishCustomization=(beverageView.beverageCustomization)[[selectedIndex intValue]];
    customizationView.KKselectedImage=(beverageView.beverageImageData)[[selectedIndex intValue]];
    customizationView.view.frame=CGRectMake(12, 0, self.view.frame.size.width-24, self.view.frame.size.height);
    customizationView.detailImageView.frame = CGRectMake(104, 229, 530, 222);
    customizationView.detailImageView.contentMode = UIViewContentModeRedraw;
    
    
    customizationView.detailImageView.clipsToBounds=YES;
    [customizationView.customizationView reloadData];
    customizationView.requestView.text=@"";
    customizationView.swipeIndicator=@"0";
    customizationView.isView=@"beverageinfo";
    if([customizationView.DishCustomization count]!=0)
    {
        [self.view addSubview:customizationView.view];
    }
}


-(void)addCustomizationView
{
    NSMutableDictionary *skudetail=beverageSKUDetail[beverageSkuIndex];
    customizationView.KKselectedID  =skudetail[@"sku_id"];
     NSString *beverageName=[NSString stringWithFormat:@"%@(%@)",(beverageView.beverageName)[[self.selectedIndex intValue]],skudetail[@"sku_name"]];
    customizationView.KKselectedName=beverageName;
    customizationView.KKselectedRate=skudetail[@"sku_price"];
    customizationView.KKselectedCatId=beverageCatId;
    customizationView.DishCustomization=(beverageView.beverageCustomization)[[selectedIndex intValue]];
    customizationView.KKselectedImage=(beverageView.beverageImageData)[[selectedIndex intValue]];
    [customizationView.customizationView reloadData];
    customizationView.requestView.text=@"";
    customizationView.swipeIndicator=@"0";
    customizationView.isView=@"beverageinfo";
    if([customizationView.DishCustomization count]!=0)
    {
        [self.view addSubview:customizationView.view];   
    }
}

-(void)addItem
{
    NSMutableDictionary *skudetail=beverageSKUDetail[beverageSkuIndex];
    [[ShareableData sharedInstance].OrderItemID addObject:skudetail[@"sku_id"]];
    NSString *beverageName=[NSString stringWithFormat:@"%@(%@)",(beverageView.beverageName)[[self.selectedIndex intValue]],skudetail[@"sku_name"]];
    [[ShareableData sharedInstance].OrderItemName addObject:beverageName]; 
    
    [[ShareableData sharedInstance].OrderItemRate addObject:skudetail[@"sku_price"]];
    [[ShareableData sharedInstance].OrderCatId addObject:beverageCatId];
    [[ShareableData sharedInstance].IsOrderCustomization addObject:@"0"];
    [[ShareableData sharedInstance].OrderCustomizationDetail addObject:@"0"];
    [[ShareableData sharedInstance].OrderSpecialRequest addObject:@"0"];
    [[ShareableData sharedInstance].OrderItemQuantity addObject:@"1"];
    [[ShareableData sharedInstance].confirmOrder addObject:@"0"];
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
          
          NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
          NSString *libraryDirectory = [paths lastObject];
          NSString *location = [libraryDirectory stringByAppendingString:@"/orderarrays.plist"];
          NSString *location2 = [libraryDirectory stringByAppendingString:@"/orderstrings.plist"];
          [array writeToFile:location atomically:YES];
          [array2 writeToFile:location2 atomically:YES];
          DLog(@"Added to Temp");
          
          // [[NSUserDefaults standardUserDefaults] synchronize];
      });
    
    TabSquareFlurryTracking *flurry = [TabSquareFlurryTracking flurryTracking];
    NSMutableArray *orders = [ShareableData sharedInstance].OrderItemName;
    NSString *item_name = [orders objectAtIndex:[orders count]-1];
    [flurry trackItem:item_name eventName:DISH_PURCHASE_EVENT category:[TabSquareCommonClass getValueInUserDefault:@"current_menu"]];

}

-(void)checkItemInOrderList
{
    bool itemExist=false;
    for(int i=0;i<[[ShareableData sharedInstance].OrderItemID count];++i)
    {
        NSMutableDictionary *beveragesku=beverageSKUDetail[beverageSkuIndex];
        if([([ShareableData sharedInstance].OrderItemID)[i] isEqualToString:beveragesku[@"sku_id"]]&&[([ShareableData sharedInstance].confirmOrder)[i]isEqualToString:@"0"])
        {
            int quantity= [([ShareableData sharedInstance].OrderItemQuantity)[i]intValue];
            float price=[([ShareableData sharedInstance].OrderItemRate)[i]floatValue]/quantity;
            quantity++;
            NSString *currentPrice=[NSString stringWithFormat:@"%.02f",price*quantity];
            NSString *currentQty=[NSString stringWithFormat:@"%d",quantity];
            ([ShareableData sharedInstance].OrderItemRate)[i] = currentPrice;
            ([ShareableData sharedInstance].OrderItemQuantity)[i] = currentQty;
            
            itemExist=true;
            break;
            
        }
    }
    if(!itemExist)
    {
        [self addItem];
    }
}

-(void)removeView2:(id)sender
{
    if([[ShareableData sharedInstance].IsViewPage count]==0)
    {
        [[ShareableData sharedInstance].IsViewPage addObject:@"beverage_main"];
    }
    else
    {
        ([ShareableData sharedInstance].IsViewPage)[0] = @"beverage_main";
    }
    [sender removeFromSuperview];
   // [self.view removeFromSuperview];
}

-(void)addImageAnimation:(CGRect)btnFrame btnView:(UIView*)view
{
    UIImageView* imgView = [[UIImageView alloc] initWithFrame:CGRectMake(btnFrame.origin.x, btnFrame.origin.y, 350, 300)];
    // imgView = self.KKselectedImage;
    imgView.alpha = 1.0f;
    CGRect imageFrame = imgView.frame;
    //  viewOrigin.y = 77 + imgView.size.height / 2.0f;
    // viewOrigin.x = 578 + imgView.size.width / 2.0f;
    
    UIImage *itemImage;
    itemImage=(beverageView.beverageImageData)[[selectedIndex intValue]];
    imgView.contentMode=UIViewContentModeScaleAspectFit;
    [imgView setImage:itemImage];
    [self.view addSubview:imgView];
    [self.view bringSubviewToFront:imgView];
    imgView.clipsToBounds = NO;
    
    CABasicAnimation *fadeOutAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    [fadeOutAnimation setToValue:@0.3f];
    fadeOutAnimation.fillMode = kCAFillModeForwards;
    fadeOutAnimation.removedOnCompletion = NO;
    
    // Set up scaling
    CABasicAnimation *resizeAnimation = [CABasicAnimation animationWithKeyPath:@"bounds.size"];
    [resizeAnimation setToValue:[NSValue valueWithCGSize:CGSizeMake(40.0f, imageFrame.size.height * (40.0f / 350))]];
    resizeAnimation.fillMode = kCAFillModeForwards;
    resizeAnimation.removedOnCompletion = NO;
    
    // Set up path movement
    CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    pathAnimation.calculationMode = kCAAnimationPaced;
    pathAnimation.fillMode = kCAFillModeForwards;
    pathAnimation.removedOnCompletion = NO;
    
    CGPoint endPoint = CGPointMake(630, -190);
    CGMutablePathRef curvedPath = CGPathCreateMutable();
    CGPathMoveToPoint(curvedPath, NULL, btnFrame.origin.x, btnFrame.origin.y);
    CGPathAddCurveToPoint(curvedPath, NULL, endPoint.x, btnFrame.origin.x, endPoint.x,btnFrame.origin.y, endPoint.x, endPoint.y);
    pathAnimation.path = curvedPath;
    CGPathRelease(curvedPath);
    
    CAAnimationGroup *group = [CAAnimationGroup animation]; 
    group.fillMode = kCAFillModeForwards;
    group.removedOnCompletion = NO;
    [group setAnimations:@[fadeOutAnimation, pathAnimation, resizeAnimation]];
    group.duration = 0.7f;
    group.delegate = self;
    [group setValue:imgView forKey:@"imageViewBeingAnimated"];
    [imgView.layer addAnimation:group forKey:@"savingAnimation"];
    
    [self performSelector:@selector(removeView2:) withObject:imgView afterDelay:0.8];
    [self checkItemInOrderList];
    // DLog(@"Order Conferm");
}

-(IBAction)addBeerListView:(id)sender
{
    UIButton *btn=(UIButton*)sender;
    UIView *view= [btn superview];
    CGRect frame=btn.frame;
    beverageSkuIndex=btn.tag;
   // NSString *type=[beverageCutType objectAtIndex:[selectedIndex intValue]];
    if([(beverageView.beverageCustomization)[[selectedIndex intValue]]count]==0)
    {
       // [self addImageAnimation:frame btnView:view];
        if ([[ShareableData sharedInstance].isSpecialReq isEqualToString:@"0"]){
            [self addImageAnimation:frame btnView:view];
        }else{
            [self addBlankCustomizationView];
        }
    }
    else 
    {
        [self addCustomizationView];
    }
    
}

-(UIView*)addLabelAndButton:(UITableViewCell*)cell indexPath:(NSInteger)index
{
    [cell.contentView setBackgroundColor:[UIColor clearColor]];

    //CGFloat width=cell.frame.size.width;
    UIView *cellView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 406,34)];
    cellView.backgroundColor=[UIColor whiteColor];
    [cellView.layer setMasksToBounds:NO];
    [cellView.layer setBorderWidth:1.7];
    [cellView.layer setShadowOpacity:0.7];
    [cellView.layer setShadowOffset:CGSizeMake(1.5, 1.5)];
    [cellView.layer setBorderColor:[UIColor colorWithRed:244.0/255.0 green:213.0/255.0 blue:198.0/255.0 alpha:1.0].CGColor];

    /*
    UIImageView *backImg=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"labelstrip.png"]];
    backImg.frame=CGRectMake(0, 0, 406,32);
    [cellView addSubview:backImg];
    */
    
    //add label header
    UILabel *skuName=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, 140, 33)];
    
    NSMutableDictionary *skudetail=beverageSKUDetail[index];
   
    skuName.text=skudetail[@"sku_name"];
    skuName.backgroundColor=[UIColor clearColor];
    skuName.font=[UIFont systemFontOfSize:16];
    [cellView addSubview:skuName];
    
    //add price label
    UILabel *price=[[UILabel alloc]initWithFrame:CGRectMake(212, 0, 60,33)];
    price.backgroundColor=[UIColor clearColor];
    price.font=[UIFont systemFontOfSize:16];
    price.textAlignment=UITextAlignmentRight;
    price.text=[NSString stringWithFormat:@"$%@",skudetail[@"sku_price"]];;
    [cellView addSubview:price];
    
    //add label button
    UIButton *add=[UIButton buttonWithType:UIButtonTypeCustom];
    add.tag=index;
    add.frame=CGRectMake(303, 2, 105, 32);
    [add setBackgroundImage:[UIImage imageNamed:@"add_btn.png"] forState:UIControlStateNormal];
    [add setTitle:@"Add" forState:UIControlStateNormal];
    [add setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [add.titleLabel setFont:[UIFont systemFontOfSize:20.0]];
    //[add setImage:[UIImage imageNamed:@"add_btn.png"] forState:UIControlStateHighlighted];
    //[add setImage:[UIImage imageNamed:@"add_btn.png"] forState:UIControlStateSelected];
    [add addTarget:self action:@selector(addBeerListView:) forControlEvents:UIControlEventTouchUpInside];
    if([ShareableData sharedInstance].ViewMode==1)
    {
       add.hidden=YES;
    }
    else 
    {
        add.hidden=NO;
    }
    [cellView addSubview:add];
   
    return cellView;
}



-(void)loadBeverageData:(int)index
{
//    if ([[ShareableData sharedInstance].TaskType isEqualToString:@"3"]){
//        
//        DLog(@"current index %d",index);
//            // DLog(@"current index %@",selectedIndex);
//            selectedIndex = [[NSString stringWithFormat:@"%d",index] copy] ;
//           // [[TabSquareDBFile sharedDatabase] openDatabaseConnection];
//            //NSString *temp=[[TabSquareDBFile sharedDatabase]getBeverageId:selectedIndex];
//           // [[TabSquareDBFile sharedDatabase] closeDatabaseConnection];
//            DLog(@"selected index %@",selectedIndex);
//            currentindex=index;
//            int newindex=0;
//            for (int i=0;i<[beverageView.beverageID count];i++){
//                if ([(beverageView.beverageID)[i] isEqualToString:[NSString stringWithFormat:@"%d",tempDishID]]){
//                    newindex=i;
//                    break;
//                }
//            }
//        selectedIndex = [[NSString stringWithFormat:@"%d",newindex] copy];
//        currentindex = newindex;
//         
//            drinkName.text=(beverageView.beverageName)[newindex];
//            drinkImage.image=(beverageView.beverageImageData)[newindex];
//            drinkImage.contentMode=UIViewContentModeScaleAspectFill;
//            drinkDiscription.text=(beverageView.beverageDescription)[newindex];
//            
//            //get beverageskudetail
//            
//         //   [[TabSquareDBFile sharedDatabase]openDatabaseConnection];
//            beverageSKUDetail=[[TabSquareDBFile sharedDatabase]getBeverageSkuDetail:(beverageView.beverageID)[newindex]];
//          //  [[TabSquareDBFile sharedDatabase]closeDatabaseConnection];
//            
//            if([beverageSKUDetail count]==0)
//            {
//                beverageSkUView.hidden=YES;
//            }
//            else
//            {
//                beverageSkUView.hidden=NO;
//                [beverageSkUView reloadData];
//            }
//            
//        
//
//        
//        [ShareableData sharedInstance].TaskType = @"0";
//    }
   // else{
    if(index==0||(index>0&index<[beverageView.beverageName count]))
    {DLog(@"current index %d",index);
       // DLog(@"current index %@",selectedIndex);
        selectedIndex = [[NSString stringWithFormat:@"%d",index] copy] ;
        DLog(@"selected index %@",selectedIndex);
        currentindex=index;
        drinkName.text=(beverageView.beverageName)[index];
        drinkImage.image=(beverageView.beverageImageData)[index];
        [drinkImage.layer setShadowOpacity:1.0];
        [drinkImage.layer setShadowOffset:CGSizeMake(2.5, 1.5)];

        drinkImage.contentMode=UIViewContentModeScaleAspectFill;
        drinkDiscription.text=(beverageView.beverageDescription)[index];
      
        //get beverageskudetail
        
     //   [[TabSquareDBFile sharedDatabase]openDatabaseConnection];
        beverageSKUDetail=[[TabSquareDBFile sharedDatabase]getBeverageSkuDetail:(beverageView.beverageID)[index]];
       // [[TabSquareDBFile sharedDatabase]closeDatabaseConnection];
      
        if([beverageSKUDetail count]==0)
        {
            beverageSkUView.hidden=YES;
        }
        else 
        {
            beverageSkUView.hidden=NO;
            [beverageSkUView reloadData];
        }
        
    }
        
        TabSquareFlurryTracking *flurry = [TabSquareFlurryTracking flurryTracking];
        [flurry trackItem:(beverageView.beverageName)[index] eventName:DISH_OPEN_EVENT category:[TabSquareCommonClass getValueInUserDefault:@"current_menu"]];

   // }
}

-(IBAction)leftClicked:(id)sender
{
    int index=currentindex;
    if (index < [beverageView.beverageID count]-1){
    [self loadBeverageData:++index];
    }
}
-(IBAction)rightClicked:(id)sender
{
    int index=currentindex;
    if (index >0 ){
    [self loadBeverageData:--index];
    }
}

-(void)createBeerListView
{
    beerListView=[[TabSquareBeerListController alloc]initWithNibName:@"TabSquareBeerListController" bundle:nil];
    beerListView.beverageDetailView=self;
}

-(void)createCustomizationView
{
    customizationView=[[TabSquareMenuDetailController alloc]initWithNibName:@"TabSquareMenuDetailController" bundle:nil];
}


- (void)viewDidLoad
{
    [self createBeerListView];
    [self createCustomizationView];
    [beverageSkUView setBackgroundColor:[UIColor clearColor]];
    
    addBeverageId=[[NSMutableArray alloc]init];
    addBeverageQunatity=[[NSMutableArray alloc]init];
    beverageCustomization=[[NSMutableArray alloc]init];
    beverageCutType=[[NSMutableArray alloc]init];
    detailImageView.layer.borderWidth=3.0;
    detailImageView.layer.borderColor=[UIColor colorWithRed:220.0f/255.0f green:208.0f/255.0f blue:156.0f/255.0f alpha:0.8].CGColor;
    [detailImageView.layer setShadowOpacity:0.85];
    [detailImageView.layer setShadowOffset:CGSizeMake(4.0, 2.5)];
    if ([[ShareableData sharedInstance].isQuickOrder isEqualToString:@"1"]){
        bgg.hidden = YES;
    }else{
        bgg.hidden = NO;
    }
    /*[NSTimer scheduledTimerWithTimeInterval:1.0
                                     target:self
                                   selector:@selector(onTick:)
                                   userInfo:nil
                                    repeats:YES];*/
    [super viewDidLoad];
}

-(UIButton*)getAddbutton:(UIView*)view
{
    UIButton *add = nil;
    for(int i=0;i<[view.subviews count];++i)
    {
        if([(view.subviews)[i] isKindOfClass:[UIButton class]])
        {
            add=(UIButton*)(view.subviews)[i];
            return add;
        }
    }
    return add;
}

-(void)onTick:(NSTimer *)timer 
{
    
}
    

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
   // DLog(@"TabSquareBeerDetailController UnLoad");
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [beverageSKUDetail count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{   
    static NSString *CellIdentifier = @"TableViewCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) 
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];       
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    UIView *detailView=[self addLabelAndButton:cell indexPath:indexPath.row];
    detailView.tag=indexPath.row;
    [cell.contentView addSubview:detailView];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 36;
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

-(IBAction)closeClicked:(id)sender
{
    if([[ShareableData sharedInstance].IsViewPage count]==0)
    {
        [[ShareableData sharedInstance].IsViewPage addObject:@"beverage_main"];
    }
    else
    {
        ([ShareableData sharedInstance].IsViewPage)[0] = @"beverage_main";
    }
    [ShareableData sharedInstance].swipeView.scrollEnabled=YES;
    
    TabSquareFlurryTracking *flurry = [TabSquareFlurryTracking flurryTracking];
    [flurry endTrackingEvent];
    
    [self.view removeFromSuperview];
}

@end
