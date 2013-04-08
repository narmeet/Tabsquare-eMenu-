//
//  TabSquarefriendsorderViewController.m
//  TabSquareMenu
//
//  Created by Nikhil Kumar on 8/27/12.
//  Copyright (c) 2012 Trendsetterz. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "TabSquareFriendListController.h"
#import "TabSquareFriendListController.h"
#import "ShareableData.h"
#import "TabSquareMenuController.h"
#import "TabSquareFavouriteViewController.h"
#import "FacebookViewC.h"
#import "TabSquareOrderSummaryController.h"
#import "SBJSON.h"
#import "TabSquarefriendsorderViewController.h"
#import "TabSquareDBFile.h"
#import "TabMainCourseMenuListViewController.h"
#import "TabMainMenuDetailViewController.h"
#import "TabSquareMenuDetailController.h"
#import "TabMainDetailView.h"
#import "TabSquareBeerController.h"
#import "TabSquareBeerDetailController.h"
#import "RateView.h"

@interface TabSquarefriendsorderViewController () <UITableViewDelegate, UITableViewDataSource, MBProgressHUDDelegate, RateViewDelegate> {
    MBProgressHUD *progressHud;
    NSMutableArray *orderCatIdList;
    NSMutableArray *orderCatNameList;
    NSString *orderCatId;
    NSString *orderCatName;
    int totalOrderCat;
    int categoryTag;
    NSString *DishSubCatId;
    NSString *custType;
    TabSquareBeerDetailController *beerDetailView;
}

@end

@implementation TabSquarefriendsorderViewController

@synthesize friendOrderData,frdOrderView,sortCatId,lastOrderedData,lastOrderedId,lastOrderedRating;
@synthesize frdOrderCatId,frdOrderDishName,fromCheckout;
@synthesize menuView,dishDetailview, beerDetailView;
//@synthesize customizationView2;
@synthesize DishID,DishName,DishPrice,DishImage,DishCatId,DishDescription,DishCustomization,DishSubCatId,custType,menudetailView;
@synthesize resultFromDB;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)createMenuDetail
{
    menudetailView=[[TabMainMenuDetailViewController alloc]initWithNibName:@"TabMainMenuDetailViewController" bundle:nil];
}

-(void)createDishDetailview
{
    dishDetailview=[[TabMainDetailView alloc]initWithNibName:@"TabMainDetailView" bundle:[NSBundle mainBundle]];
}

- (void)viewDidLoad
{
    
   // friendName=[[NSMutableArray alloc]init];
    //friendImage=[[NSMutableArray alloc]init];
    //friendId=[[NSMutableArray alloc]init];
    //friendInstalled=[[NSMutableArray alloc]init];
    lastOrderedId=[[NSMutableArray alloc]init];
    lastOrderedData=[[NSMutableArray alloc]init];
    lastOrderedRating=[[NSMutableArray alloc]init];

    orderCatIdList=[[NSMutableArray alloc]init];
    orderCatNameList=[[NSMutableArray alloc]init];
    sortCatId=[[NSMutableArray alloc]init];
    friendOrderData=[[NSMutableArray alloc]init];
    frdOrderCatId=[[NSMutableArray alloc]init];
    frdOrderDishName=[[NSMutableArray alloc]init];
    [self allocateArray];
    [self createMenuDetail];
    [self createDishDetailview];
    
    beerDetailView =[[TabSquareBeerDetailController alloc]initWithNibName:@"TabSquareBeerDetailController" bundle:nil];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)getlastOrderedDataList:(NSString*)email
{
    NSString *post =[NSString stringWithFormat:@"email=%@&key=%@",email, [ShareableData appKey]];
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
    SBJSON *parser = [[SBJSON alloc] init];
    NSMutableArray *resultFromPost = [parser objectWithString:data error:nil];
    for(int i=0;i<[resultFromPost count];++i)
    {
        NSMutableDictionary *dataitem=resultFromPost[i];
        if (![[NSString stringWithFormat:@"%@",dataitem[@"dish_id"]] isEqualToString:@"0"]){
        [lastOrderedId addObject:[NSString stringWithFormat:@"%@",dataitem[@"dish_id"]]];
        [lastOrderedData addObject:[NSString stringWithFormat:@"%@",dataitem[@"dish_name"]]];
        [lastOrderedRating addObject:[NSString stringWithFormat:@"%@",dataitem[@"rating"]]];
        }
    }
    [frdOrderView reloadData];
    //DLog(@"Result : %@",data);
}

-(void)loadlastOrdereddata
{
    if([lastOrderedData count]!=0)
    {
        [lastOrderedId removeAllObjects];
        [lastOrderedData removeAllObjects];
        [lastOrderedRating removeAllObjects];
    }
    [self getlastOrderedDataList:[ShareableData sharedInstance].isLogin];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

-(void)loadFrdOrderData:(NSMutableArray*)frdData
{
    DLog(@"%@",frdData);
    [lastOrderedId removeAllObjects];
    [lastOrderedData removeAllObjects];
    [lastOrderedRating removeAllObjects];
    //[frdOrderCatId removeAllObjects];
  //  [frdOrderDishName removeAllObjects];
    for(int i=0;i<[frdData count];++i)
    {
        NSMutableDictionary *dataitem=frdData[i];
        if (![[NSString stringWithFormat:@"%@",dataitem[@"dish_id"]] isEqualToString:@"0"]){
        [lastOrderedId addObject:[NSString stringWithFormat:@"%@",dataitem[@"dish_id"]]];
        [lastOrderedData addObject:[NSString stringWithFormat:@"%@",dataitem[@"dish_name"]]];
         [lastOrderedRating addObject:[NSString stringWithFormat:@"%@",dataitem[@"rating"]]];
        }
      
    }
    [frdOrderView reloadData];
}

-(void)addCustomizationView
{
     menudetailView.menuDetailView=[[TabSquareMenuDetailController alloc]initWithNibName:@"TabSquareMenuDetailController" bundle:nil];
//customizationView2=menuView2.menulistView1.menudetailView.menuDetailView;
    menudetailView.menuDetailView.KKselectedID  =DishID;
    menudetailView.menuDetailView.KKselectedName=DishName;
    menudetailView.menuDetailView.KKselectedRate=DishPrice;
    menudetailView.menuDetailView.KKselectedCatId=DishCatId;
    menudetailView.menuDetailView.backImage.hidden=NO;
    menudetailView.menuDetailView.DishCustomization=DishCustomization;
    menudetailView.menuDetailView.KKselectedImage=DishImage;
    [menudetailView.menuDetailView.customizationView reloadData];
    menudetailView.menuDetailView.requestView.text=@"";
    menudetailView.menuDetailView.swipeIndicator=@"1";
    menudetailView.menuDetailView.isView=@"main";
    menudetailView.menuDetailView.view.frame=CGRectMake(12, 0, self.view.frame.size.width-24, self.view.frame.size.height);
    [self.view addSubview:menudetailView.menuDetailView.view];
    [self.view bringSubviewToFront:menudetailView.menuDetailView.view];
}

-(void)addItem
{
    [[ShareableData sharedInstance].OrderItemID addObject:DishID];
    [[ShareableData sharedInstance].OrderItemName addObject:DishName];
    [[ShareableData sharedInstance].OrderItemRate addObject:DishPrice];
    [[ShareableData sharedInstance].OrderCatId addObject:DishCatId];
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
          
          NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);;
          NSString *libraryDirectory = [paths lastObject];
          NSString *location = [libraryDirectory stringByAppendingString:@"/orderarrays.plist"];
          NSString *location2 = [libraryDirectory stringByAppendingString:@"/orderstrings.plist"];
          [array writeToFile:location atomically:YES];
          [array2 writeToFile:location2 atomically:YES];
          DLog(@"Added to Temp");
          
          // [[NSUserDefaults standardUserDefaults] synchronize];
});
}

-(void)checkItemInOrderList
{
    bool itemExist=false;
    for(int i=0;i<[[ShareableData sharedInstance].OrderItemID count];++i)
    {
        if([([ShareableData sharedInstance].OrderItemID)[i] isEqualToString:DishID]&&[([ShareableData sharedInstance].confirmOrder)[i]isEqualToString:@"0"])
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
    [sender removeFromSuperview];
}


-(void)addImageAnimation:(CGRect)btnFrame btnView:(UIView*)view
{
    UIImageView* imgView = [[UIImageView alloc] initWithFrame:CGRectMake(btnFrame.origin.x, btnFrame.origin.y, 350, 300)];
    // imgView = self.KKselectedImage;
    imgView.alpha = 1.0f;
    CGRect imageFrame = imgView.frame;
    // viewOrigin.y = 77 + imgView.size.height / 2.0f;
    // viewOrigin.x = 578 + imgView.size.width / 2.0f;
    
    imgView.frame = imageFrame;
    UIImage *itemImage=DishImage;
    
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
    
    //DLog(@"Order Conferm");
}


-(IBAction)infoClicked:(id)sender
{
    UIButton *btn=(UIButton*)sender;
   
    int tag=btn.tag;
    
    //selectedItem=tag;
    [ShareableData sharedInstance].swipeView.scrollEnabled=NO;
    NSString *orderId=[NSString stringWithFormat:@"%@",lastOrderedId[tag]];
   // [[TabSquareDBFile sharedDatabase]openDatabaseConnection];
    NSMutableArray *resultFromPost=[[TabSquareDBFile sharedDatabase]getDishDataDetail:orderId];
   // [[TabSquareDBFile sharedDatabase]closeDatabaseConnection];
    
    resultFromDB=resultFromPost[0];
    
    //parse data
    [self loadDishData];
    
   // [[TabSquareDBFile sharedDatabase]openDatabaseConnection];
    // NSString *dishCatId2 = [DishCategoryId objectAtIndex:selectedItem];
    // NSString *dishSubCatId2 = [DishSubCategoryId objectAtIndex:selectedItem];
    int bevDisplay = 0;
    TabSquareBeerController* beveragesBeerView=[[TabSquareBeerController alloc]initWithNibName:@"TabSquareBeerController" bundle:nil];
    if([DishCatId isEqualToString:[ShareableData sharedInstance].bevCat]){
        [ShareableData sharedInstance].TaskType = @"3";
        
        NSMutableArray *subCategoryData=[[TabSquareDBFile sharedDatabase]getSubCategoryData:[ShareableData sharedInstance].bevCat];
        for(int i=0;i<[subCategoryData count];++i){
            NSMutableDictionary *subCategory=subCategoryData[i];
            NSString *subId=subCategory[@"id"];
            NSString *displayId=subCategory[@"display"];
            if ([subId isEqualToString:DishSubCatId]&&[displayId isEqualToString:@"1"]){
                bevDisplay = 1;
                [beveragesBeerView reloadDataOfSubCat:DishSubCatId cat:DishCatId];
                [beveragesBeerView.beverageView reloadData];
            }
            
        }
        
      //  [[TabSquareDBFile sharedDatabase]closeDatabaseConnection];
    }
    if (bevDisplay == 1){
        // NSMutableArray *beverageCustomization;
        // NSMutableArray *beverageSkuDetail;
        // NSMutableArray *beverageCustType;
        beerDetailView.beverageView = beveragesBeerView;
        //int currentindex=[[DishID objectAtIndex:selectedItem] intValue];
        beerDetailView.selectedIndex=[NSString stringWithFormat:@"%d",tag];
        beerDetailView.tempDishID = DishID.intValue;
       // [[TabSquareDBFile sharedDatabase]openDatabaseConnection];
        beerDetailView.beverageSKUDetail=[[TabSquareDBFile sharedDatabase]getBeverageSkuDetail:DishID];
      //  [[TabSquareDBFile sharedDatabase]closeDatabaseConnection];
        beerDetailView.beverageCatId=[NSString stringWithFormat:@"%d",8];
        beerDetailView.beverageCustomization=DishCustomization;
        //beerDetailView.beverageCutType=custType;
        [beerDetailView.beverageSkUView reloadData];
        [beerDetailView loadBeverageData:DishID.intValue];
        [ShareableData sharedInstance].swipeView.scrollEnabled=NO;
        [self.view addSubview:beerDetailView.view];
        [self.view bringSubviewToFront:beerDetailView.view];
    }else{
        beerDetailView.leftArrow.hidden=NO;
        beerDetailView.rightArrow.hidden=NO;
        
        [menuView.menulistView1.menudetailView.tabMainDetailView.KDishCust removeAllObjects];
        [menuView.menulistView1.menudetailView removeSwipeSubviews];
        [menuView.menulistView1.menudetailView.swipeDetailView addSubview:menuView.menulistView1.menudetailView.tabMainDetailView.view];
        menuView.menulistView1.menudetailView.swipeDetailView.scrollEnabled=NO;
        menuView.menulistView1.menudetailView.tabMainDetailView.IshideAddButton=@"1";
        menuView.menulistView1.menudetailView.tabMainDetailView.Viewtype=@"2";
        menuView.menulistView1.menudetailView.view.frame=CGRectMake(3, 20, menuView.menulistView1.menudetailView.view.frame.size.width, menuView.menulistView1.menudetailView.view.frame.size.height);
        [self.view addSubview:menuView.menulistView1.menudetailView.view];
        for(int i=0;i<[resultFromPost count];i++)
        {
            NSMutableDictionary *dataitem=resultFromPost[i];
            menuView.menulistView1.menudetailView.tabMainDetailView.KDishCatId=[NSString stringWithFormat:@"%@",DishCatId];
            menuView.menulistView1.menudetailView.tabMainDetailView.KDishName.text=[NSString stringWithFormat:@"%@",dataitem[@"name"]];
            menuView.menulistView1.menudetailView.tabMainDetailView.KDishRate.text=[NSString stringWithFormat:@"%@",dataitem[@"price"]];
            menuView.menulistView1.menudetailView.tabMainDetailView.KDishDescription.text=[NSString stringWithFormat:@"%@",dataitem[@"description"]];
            menuView.menulistView1.menudetailView.tabMainDetailView.kDishId =[NSString stringWithFormat:@"%@",orderId];
            [menuView.menulistView1.menudetailView.tabMainDetailView.KDishCust addObject:dataitem[@"customisations"]];
            menuView.menulistView1.menudetailView.tabMainDetailView.KDishCustType=[NSString stringWithFormat:@"%@",dataitem[@"cust"]];
            UIImage *imageUrl = [UIImage imageWithContentsOfFile:dataitem[@"images"]];
            if(imageUrl)
            {
                menuView.menulistView1.menudetailView.tabMainDetailView.KDishImage.image=imageUrl;
            }
            
            break;
        }
        menuView.menulistView1.menudetailView.tabMainDetailView.KDishName.font=[UIFont fontWithName:@"Lucida Calligraphy" size:21];
        menuView.menulistView1.menudetailView.tabMainDetailView.KDishRate.font=[UIFont fontWithName:@"Lucida Calligraphy" size:17];
        menuView.menulistView1.menudetailView.tabMainDetailView.KDishDescription.font=[UIFont fontWithName:@"Lucida Calligraphy" size:14];
        CGSize newsize=  [menuView.menulistView1.menudetailView.tabMainDetailView.KDishName.text sizeWithFont:menuView.menulistView1.menudetailView.tabMainDetailView.KDishName.font constrainedToSize:CGSizeMake(241, 400) lineBreakMode:menuView.menulistView1.menudetailView.tabMainDetailView.KDishName.lineBreakMode];
        menuView.menulistView1.menudetailView.tabMainDetailView.KDishName.frame=CGRectMake(menuView.menulistView1.menudetailView.tabMainDetailView.KDishName.frame.origin.x,menuView.menulistView1.menudetailView.tabMainDetailView.KDishName.frame.origin.y, newsize.width, newsize.height);
        
        
        [menuView.menulistView1.menudetailView.tabMainDetailView  hideButtons];
    }
   // [menudetailView.detailView1  hideButtons];
}
-(void)loadDishData
{
    DishID=[NSString stringWithFormat:@"%@",resultFromDB[@"id"]];
    DishName=[NSString stringWithFormat:@"%@",resultFromDB[@"name"]];
    DishPrice=[NSString stringWithFormat:@"%@",resultFromDB[@"price"]];
    DishDescription=[NSString stringWithFormat:@"%@",resultFromDB[@"description"]];
    DishCatId=[NSString stringWithFormat:@"%@",resultFromDB[@"category"]];
    DishCustomization=resultFromDB[@"customisations"];
    DishImage=[UIImage imageWithContentsOfFile:resultFromDB[@"images"]];
    DishSubCatId = [NSString stringWithFormat:@"%@",resultFromDB[@"sub_category"]];
   custType= [NSString stringWithFormat:@"%@",resultFromDB[@"cust"]];
   // DishDisplay =
}

-(IBAction)addClicked:(id)sender
{
    [ShareableData sharedInstance].TaskType = @"3";
    UIButton *btn=(UIButton*)sender;
    UIView *view= [btn superview];
    CGRect frame=btn.frame;
    int tag=btn.tag;
    // DLog(@"Tag : %d",tag);
    //selectedItem=tag;
   // NSString *type=[custType objectAtIndex:tag];
    NSString *orderId=[NSString stringWithFormat:@"%@",lastOrderedId[tag]];
   // [[TabSquareDBFile sharedDatabase]openDatabaseConnection];
    NSMutableArray *resultFromPost=[[TabSquareDBFile sharedDatabase]getDishDataDetail:orderId];
    //[[TabSquareDBFile sharedDatabase]closeDatabaseConnection];
    
    resultFromDB=resultFromPost[0];
    
    //parse data
    [self loadDishData];
    
   // [[TabSquareDBFile sharedDatabase]openDatabaseConnection];
   // NSString *dishCatId2 = [DishCategoryId objectAtIndex:tag];
  //  NSString *dishSubCatId2 = [DishSubCategoryId objectAtIndex:tag];
    int bevDisplay = 0;
    TabSquareBeerController* beveragesBeerView=[[TabSquareBeerController alloc]initWithNibName:@"TabSquareBeerController" bundle:nil];
    if([DishCatId isEqualToString:[ShareableData sharedInstance].bevCat]){
        NSMutableArray *subCategoryData=[[TabSquareDBFile sharedDatabase]getSubCategoryData:[ShareableData sharedInstance].bevCat];
        for(int i=0;i<[subCategoryData count];++i){
            NSMutableDictionary *subCategory=subCategoryData[i];
            NSString *subId=subCategory[@"id"];
            NSString *displayId=subCategory[@"display"];
            if ([subId isEqualToString:DishSubCatId]&&[displayId isEqualToString:@"1"]){
                bevDisplay = 1;
                [beveragesBeerView reloadDataOfSubCat:DishSubCatId cat:DishCatId];
                [beveragesBeerView.beverageView reloadData];
            }
            
        }
        
       // [[TabSquareDBFile sharedDatabase]closeDatabaseConnection];
    }
    if (bevDisplay == 1){
        // NSMutableArray *beverageCustomization;
        // NSMutableArray *beverageSkuDetail;
        // NSMutableArray *beverageCustType;
        beerDetailView.beverageView = beveragesBeerView;
        //int currentindex=[[DishID objectAtIndex:selectedItem] intValue];
        beerDetailView.selectedIndex=[NSString stringWithFormat:@"%d",tag];
        beerDetailView.tempDishID = DishID.intValue;
      //  [[TabSquareDBFile sharedDatabase]openDatabaseConnection];
        beerDetailView.beverageSKUDetail=[[TabSquareDBFile sharedDatabase]getBeverageSkuDetail:DishID];
      //  [[TabSquareDBFile sharedDatabase]closeDatabaseConnection];
        beerDetailView.beverageCatId=[NSString stringWithFormat:@"%d",8];
        beerDetailView.beverageCustomization=DishCustomization;
        //beerDetailView.beverageCutType=custType;
        [beerDetailView.beverageSkUView reloadData];
        [beerDetailView loadBeverageData:DishID.intValue];
        [ShareableData sharedInstance].swipeView.scrollEnabled=NO;
        [self.view addSubview:beerDetailView.view];
        [self.view bringSubviewToFront:beerDetailView.view];
    }else{
        
        if([custType isEqualToString:@"0"])
        {
            [self addImageAnimation:frame btnView:view];
        }
        else
        {
            if([[ShareableData sharedInstance].IsViewPage count]==0)
            {
                [[ShareableData sharedInstance].IsViewPage addObject:@"main_customization"];
            }
            else
            {
                ([ShareableData sharedInstance].IsViewPage)[0] = @"main_customization";
            }
            
            [ShareableData sharedInstance].swipeView.scrollEnabled=NO;
            [self addCustomizationView];
        }
    }


}



-(UIButton*)addButton:(UITableViewCell*)cell indexPath:(NSInteger)rowIndex
{
    UIButton *add=[UIButton buttonWithType:UIButtonTypeCustom];
    add.tag=rowIndex;
    add.frame=CGRectMake(520, -2, 72, 42);
    [add setImage:[UIImage imageNamed:@"add.png"] forState:UIControlStateNormal];
    [add setImage:[UIImage imageNamed:@"add.png"] forState:UIControlStateHighlighted];
    [add setImage:[UIImage imageNamed:@"add.png"] forState:UIControlStateSelected];
    [add addTarget:self action:@selector(addClicked:) forControlEvents:UIControlEventTouchUpInside];
    return add;
    // return add;
}


-(UIButton*)addInfoButton:(UITableViewCell*)cell indexPath:(NSInteger)rowIndex
{
    UIButton *addinfo=[UIButton buttonWithType:UIButtonTypeCustom];
    addinfo.userInteractionEnabled=YES;
    addinfo.tag=rowIndex;
    addinfo.frame=CGRectMake(460,5, 44, 32);
    [addinfo setImage:[UIImage imageNamed:@"i_connect.png"] forState:UIControlStateNormal];
    [addinfo setImage:[UIImage imageNamed:@"i_connect.png"] forState:UIControlStateHighlighted];
    [addinfo setImage:[UIImage imageNamed:@"i_connect.png"] forState:UIControlStateSelected];
    [addinfo addTarget:self action:@selector(infoClicked:) forControlEvents:UIControlEventTouchUpInside];
    return addinfo;
    // return add;
}


-(void)removesuperView:(UITableViewCell*)cell
{
    NSArray *subviews=[cell.contentView subviews];
    for(int i=0;i<[subviews count];++i)
    {
        UIView *view=subviews[i];
        if([view isKindOfClass:[UIButton class]])
        {
            // DLog(@"dfdf");
        }
        [view removeFromSuperview];
    }
}



-(int)getDishIndex:(NSString*)catId rowIndex:(NSInteger)index
{
    int i=0;
    for(int j=0;j<[frdOrderCatId count];++j)
    {
        if([frdOrderCatId[j] isEqualToString:catId])
        {
            if(index==i)
            {
                return j;
            }
            i++;
        }
    }
    return i;
}


-(int)getTotalCatDishes:(NSString*)catId
{
    int totalDishes = 0;
    for(int j=0;j<[frdOrderCatId count];++j)
    {
        if([frdOrderCatId[j] isEqualToString:catId])
        {
            totalDishes++;
        }
    }
    return totalDishes;
}


-(void)DishCategorized
{
    [sortCatId removeAllObjects];
    [orderCatIdList removeAllObjects];
    [orderCatNameList removeAllObjects];
    totalOrderCat=0;
    orderCatId=@"";
    orderCatName=@"";
    int total;
    // DLog(@"%@",[[ShareableData sharedInstance] OrderCatId]);
    for(int i=0;i<[[ShareableData sharedInstance].categoryIdList count];++i)
    {
        total=i;
        int count=0;
        NSString *catId=([ShareableData sharedInstance].categoryIdList)[i];
        NSString *catName=([ShareableData sharedInstance].categoryList)[i];
        for(int j=0;j<[frdOrderCatId count];++j)
        {
            
            if([frdOrderCatId[j] isEqualToString:catId])
            {
                count=1;
                if(total==i)
                {
                    totalOrderCat++;
                    [orderCatIdList addObject:catId];
                    [orderCatNameList addObject:catName];
                    
                    total=[[ShareableData sharedInstance].categoryIdList count];
                }
                [sortCatId addObject:[NSString stringWithFormat:@"%d",j]];    
            }
            
        }
        if(count==0) 
        {
            if([orderCatId isEqualToString:@""])
            {
                categoryTag=i; 
                orderCatId=catId;
                orderCatName=([ShareableData sharedInstance].categoryList)[i];
            }
        }
        
    }
}
-(void)allocateArray
{
   // SubSectionIdData=[[NSMutableArray alloc]init];
  //  SubSectionNameData=[[NSMutableArray alloc]init];
  //  SectionDishData=[[NSMutableArray alloc]init];
 //   resultFromPost=[[[NSMutableArray alloc]init]retain];
   /* DishName=[[[NSMutableArray alloc]init]retain];
    DishPrice=[[[NSMutableArray alloc]init]retain];
    DishDescription=[[[NSMutableArray alloc]init]retain];
    DishID=[[[NSMutableArray alloc]init]retain];
    DishImage=[[[NSMutableArray alloc]init]retain];
    DishCategoryId=[[[NSMutableArray alloc]init]retain];
    DishSubCategoryId=[[NSMutableArray alloc]init];
    DishSubSubCategoryId=[[NSMutableArray alloc]init];*/
    DishCustomization=[[NSMutableArray alloc]init];
   // currentListTag=0;
   // custType=[[NSMutableArray alloc]init];
}

-(UILabel*)addDishName:(NSInteger)index
{
    //add label header
    UILabel *foodName=[[UILabel alloc]initWithFrame:CGRectMake(30, 8, 270, 400)];
    foodName.text=frdOrderDishName[index];
    foodName.backgroundColor=[UIColor clearColor];
    foodName.font=[UIFont fontWithName:@"Lucida Calligraphy" size:18];
    foodName.lineBreakMode=UILineBreakModeWordWrap;
    CGSize newsize=  [foodName.text sizeWithFont:foodName.font constrainedToSize:CGSizeMake(270, 400) lineBreakMode:foodName.lineBreakMode];
    foodName.frame=CGRectMake(foodName.frame.origin.x, foodName.frame.origin.y, newsize.width, newsize.height);
    foodName.textAlignment=UITextAlignmentLeft;
    return foodName;
}

-(void)addDishItem:(UITableViewCell*)cell indexPath:(NSInteger)rowIndex
{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, 2, 200, 45)];
    titleLabel.backgroundColor=[UIColor clearColor];
    titleLabel.text = lastOrderedData[rowIndex];
    titleLabel.font=[UIFont fontWithName:@"Lucida Calligraphy" size:17];
    [cell.contentView addSubview:titleLabel];
    
}
-(RateView*)addRateView:(int)index
{
    RateView *rateView=[[RateView alloc]initWithFrame:CGRectMake(250, 4, 160, 30)];
    [self configureView:rateView];
    rateView.tag=index;
    return rateView;
}
- (void)configureView:(RateView*)rateView
{
    // Update the user interface for the detail item.
    rateView.notSelectedImage = [UIImage imageNamed:@"star.png"];
    rateView.halfSelectedImage = [UIImage imageNamed:@"star.png"];
    rateView.fullSelectedImage = [UIImage imageNamed:@"red star.png"];
    rateView.editable = NO;
    rateView.maxRating = 5;
    rateView.delegate = self;
    rateView.rating = 0;
    
}


#pragma mark Table view methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
   // [self DishCategorized];
    //return totalOrderCat;
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //return [self getTotalCatDishes:[orderCatIdList objectAtIndex:section]];
    return [lastOrderedId count];
}

/*-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *customView = [[[UIView alloc] initWithFrame:CGRectMake(0.0,8.0,tableView.bounds.size.width, 40)] autorelease];
    customView.backgroundColor = [UIColor grayColor];
    
    UILabel *headerLabel = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.opaque = NO;
    headerLabel.textColor = [UIColor whiteColor];
    headerLabel.font = [UIFont boldSystemFontOfSize:18];
    headerLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
    headerLabel.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
    headerLabel.frame = CGRectMake(11,-11, 320.0, 44.0);
    headerLabel.textAlignment = UITextAlignmentLeft;
    NSString* headertxt=[orderCatNameList objectAtIndex:section];
    headerLabel.text=headertxt;
    [customView addSubview:headerLabel];
    return customView;
}*/

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cellidentifier %d",indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) 
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];       
    }
   /* int sortIndex=[self getDishIndex:[orderCatIdList objectAtIndex:indexPath.section] rowIndex:indexPath.row];
    
    UILabel *dishName=[self addDishName:sortIndex];
    
    [cell.contentView addSubview:dishName];*/
    //[self removesuperView:cell];
    [self addDishItem:cell indexPath:indexPath.row];
    RateView  *FoodrateView=[self addRateView:indexPath.row+100];
    if([lastOrderedRating count]>indexPath.row)
    {
        FoodrateView.rating=[lastOrderedRating[indexPath.row]intValue];
        [cell.contentView addSubview:FoodrateView];
    }
    UIButton *addInfo = [self addInfoButton:cell indexPath:indexPath.row];
    [cell.contentView addSubview:addInfo];
    if (![fromCheckout isEqualToString:@"1"]){
       // [self addButton:cell indexPath:indexPath.row];
        UIButton *addBtn = [self addButton:cell indexPath:indexPath.row];
        [cell.contentView addSubview:addBtn];
    }
 
    
    return cell;
}

/*-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [[[UIView alloc] initWithFrame:CGRectMake(0.0,4.0,tableView.bounds.size.width, 40)] autorelease]; 
    footerView.backgroundColor = [UIColor clearColor];
    return footerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat cellHeight=42;
    int sortIndex=[self getDishIndex:[orderCatIdList objectAtIndex:indexPath.section] rowIndex:indexPath.row]; 
    NSString *dishName= [frdOrderDishName  objectAtIndex:sortIndex];
    CGSize newsize= [dishName sizeWithFont:[UIFont fontWithName:@"Lucida Calligraphy" size:18] constrainedToSize:CGSizeMake(264, 400) lineBreakMode:UILineBreakModeWordWrap];
    
    if(newsize.height>42)
    {
        cellHeight= newsize.height+5;
    }
    return cellHeight;
    
}*/

-(IBAction)closeClicked:(id)sender
{
    [self.view removeFromSuperview];
}

#pragma mark - RateView Delegate
-(void)rateView:(RateView *)rateView ratingDidChange:(float)rating {
	
}



@end
