//
//  TabSquareLastOrderedViewController.m
//  TabSquareMenu
//
//  Created by Nikhil Kumar on 8/21/12.
//  Copyright (c) 2012 Trendsetterz. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "TabSquareLastOrderedViewController.h"
#import "ShareableData.h"
#import "SBJSON.h"
#import "RateView.h"
#import "TabSquareMenuController.h"
#import "TabMainMenuDetailViewController.h"
#import "TabSquareMenuDetailController.h"
#import "TabSquareDBFile.h"
#import "TabMainCourseMenuListViewController.h"
#import "TabMainDetailView.h"
#import "TabSquareBeerController.h"
#import "TabSquareBeerDetailController.h"
#import "RateView.h"

@interface TabSquareLastOrderedViewController () <UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate, RateViewDelegate> {
    NSInteger selectedItem;
   // TabSquareBeerDetailController *beerDetailView;
    TabSquareNewBeerScrollController *beerDetailView;
    TabSquareBeerController *beveragesBeerView2;
    NSString *custType;
    int selectedItemIndex;

}

@end

@implementation TabSquareLastOrderedViewController

@synthesize lastOrderedView,lastOrderedData,lastOrderedRating,lastOrderedId;
@synthesize menuView,itemDetailView,resultFromDB,customizationView;
@synthesize DishID,DishName,DishPrice,DishImage,DishCatId,DishDescription,DishCustomization,DishSubCatId,beerDetailView,custType,fromCheckout;

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)createMenuDetail
{
   itemDetailView=[[TabMainMenuDetailViewController alloc]initWithNibName:@"TabMainMenuDetailViewController" bundle:nil];
    
}
//-(void)viewDidAppear:(BOOL)animated
//{     
//    [self loadlastOrdereddata];
//    
//}
-(void)viewWillAppear:(BOOL)animated{
    
    [self loadlastOrdereddata];

}

- (void)viewDidLoad
{
    lastOrderedId=[[NSMutableArray alloc]init];
    lastOrderedData=[[NSMutableArray alloc]init];
    lastOrderedRating=[[NSMutableArray alloc]init];
    [self createMenuDetail];
  //  beerDetailView =[[TabSquareBeerDetailController alloc]initWithNibName:@"TabSquareBeerDetailController" bundle:nil];
    
    beerDetailView =[[TabSquareNewBeerScrollController alloc]initWithNibName:@"TabSquareNewBeerScrollController" bundle:nil];
    
    beveragesBeerView2=[[TabSquareBeerController alloc]initWithNibName:@"TabSquareBeerController" bundle:nil];
    beerDetailView.beverageView = beveragesBeerView2;
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
    
    NSString *url_string = [NSString stringWithFormat:@"%@/webs/get_dish_feedback", [ShareableData serverURL]];
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
    DLog(@"Result : %@",data);
}

-(void)loadlastOrdereddata
{
    if([lastOrderedData count]!=0)
    {
        [lastOrderedId removeAllObjects];
        [lastOrderedData removeAllObjects];
        [lastOrderedRating removeAllObjects];
    }
    DLog(@"what %@",[ShareableData sharedInstance].isLogin);
    [self getlastOrderedDataList:[ShareableData sharedInstance].isLogin];
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(IBAction)logOutClicked:(id)sender
{
    [ShareableData sharedInstance].isLogin = @"0";
    [ShareableData sharedInstance].Customer = @"0";
    [ShareableData sharedInstance].isFBLogin = @"0";
    [ShareableData sharedInstance].isTwitterLogin = @"0";
    //[menuView.favouriteView.objFacebookViewC logout];
    [menuView favouriteClicked:0];
    [self.view.superview.superview removeFromSuperview];//narmeet
//    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"LogOut Successful!!!!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
//    [alert show];

}


-(void)addDishItem:(UITableViewCell*)cell indexPath:(NSInteger)rowIndex
{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, 2, 200, 45)];
    titleLabel.backgroundColor=[UIColor clearColor];
    titleLabel.text = lastOrderedData[rowIndex]; 
    titleLabel.font=[UIFont fontWithName:@"Lucida Calligraphy" size:17];
    [cell.contentView addSubview:titleLabel];   
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

-(RateView*)addRateView:(int)index
{
    RateView *rateView=[[RateView alloc]initWithFrame:CGRectMake(250, 4, 160, 30)];
    [self configureView:rateView];
    rateView.tag=index;
    return rateView;
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
}

-(void)addBlankCustomizationView
{
    itemDetailView.menuDetailView=[[TabSquareMenuDetailController alloc]initWithNibName:@"TabSquareMenuDetailController" bundle:nil];
    customizationView=itemDetailView.menuDetailView;
    customizationView.KKselectedID  =DishID;
    customizationView.KKselectedName=DishName;
    customizationView.KKselectedRate=DishPrice;
    customizationView.KKselectedCatId=DishCatId;
    customizationView.backImage.hidden=NO;
    customizationView.DishCustomization=DishCustomization;
    customizationView.KKselectedImage=DishImage;
    [customizationView.customizationView reloadData];
    customizationView.requestView.text=@"";
    customizationView.swipeIndicator=@"1";
    customizationView.isView=@"main";
    customizationView.view.frame=CGRectMake(12, 0, self.view.frame.size.width-24, self.view.frame.size.height);
    customizationView.detailImageView.frame = CGRectMake(104, 229, 530, 222);
    customizationView.detailImageView.contentMode = UIViewContentModeRedraw;
    
    
    customizationView.detailImageView.clipsToBounds=YES;
    [self.view addSubview:customizationView.view];
}


-(void)addCustomizationView
{
    itemDetailView.menuDetailView=[[TabSquareMenuDetailController alloc]initWithNibName:@"TabSquareMenuDetailController" bundle:nil];
    customizationView=itemDetailView.menuDetailView;
    customizationView.KKselectedID  =DishID;
    customizationView.KKselectedName=DishName;
    customizationView.KKselectedRate=DishPrice;
    customizationView.KKselectedCatId=DishCatId;
    customizationView.backImage.hidden=NO;
    customizationView.DishCustomization=DishCustomization;
    customizationView.KKselectedImage=DishImage;
    [customizationView.customizationView reloadData];
    customizationView.requestView.text=@"";
    customizationView.swipeIndicator=@"1";
    customizationView.isView=@"main";
    customizationView.view.frame=CGRectMake(12, 0, self.view.frame.size.width-24, self.view.frame.size.height);
    [self.view addSubview:customizationView.view];
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



-(IBAction)dishInfoClicked:(id)sender

{    UIButton *btn=(UIButton*)sender;
    selectedItemIndex=btn.tag;
    
    
    NSString *orderId=([ShareableData sharedInstance].OrderItemID)[selectedItemIndex];
    // [ShareableData sharedInstance].or
    //get data from DB
    // [[TabSquareDBFile sharedDatabase]openDatabaseConnection];
  
    if([[TabSquareDBFile sharedDatabase] isBevCheck:([ShareableData sharedInstance].OrderCatId)[selectedItemIndex]])
    {
        NSString *temp=[[TabSquareDBFile sharedDatabase]getBeverageId:orderId];
        if (temp.intValue != 0){
            orderId = [temp copy];
        }
    }
    NSMutableArray *resultFromPost=[[TabSquareDBFile sharedDatabase]getDishDataDetail:orderId];
    //  [[TabSquareDBFile sharedDatabase]closeDatabaseConnection];
    
    //  [[TabSquareDBFile sharedDatabase]openDatabaseConnection];
    NSString *dishCatId2 = ([ShareableData sharedInstance].OrderCatId)[selectedItemIndex];
    NSString *dishSubCatId2 = [NSString stringWithFormat:@"%@",resultFromPost[0][@"sub_category"]];
    int bevDisplay = 0;
    
    if(  [[TabSquareDBFile sharedDatabase] isBevCheck:dishCatId2]){
        [ShareableData sharedInstance].TaskType = @"3";
        NSMutableArray *subCategoryData=[[TabSquareDBFile sharedDatabase]getSubCategoryData:dishCatId2];
        for(int i=0;i<[subCategoryData count];++i){
            NSMutableDictionary *subCategory=subCategoryData[i];
            NSString *subId=subCategory[@"id"];
            NSString *displayId=subCategory[@"display"];
            if ([subId isEqualToString:dishSubCatId2]&&[displayId isEqualToString:@"1"]){
                bevDisplay = 1;
                [_beveragesBeerView2 reloadDataOfSubCat:dishSubCatId2 cat:dishCatId2];
                [_beveragesBeerView2.beverageView reloadData];
            }
            
        }
        
        //  [[TabSquareDBFile sharedDatabase]closeDatabaseConnection];
    }
    if (bevDisplay == 1){
        // NSMutableArray *beverageCustomization;
        // NSMutableArray *beverageSkuDetail;
        // NSMutableArray *beverageCustType;
        beerDetailView =[[TabSquareNewBeerScrollController alloc]initWithNibName:@"TabSquareNewBeerScrollController" bundle:nil];
        beerDetailView.beverageView = self;
        
        beerDetailView.tempDishID = orderId.intValue;
        
        beerDetailView.orderScreenFlag=@"1";
        beerDetailView.selectedIndex=[NSString stringWithFormat:@"%d",selectedItemIndex];
        // [[TabSquareDBFile sharedDatabase]openDatabaseConnection];
        beerDetailView.beverageSKUDetail=[[TabSquareDBFile sharedDatabase]getBeverageSkuDetail:orderId];
        // [[TabSquareDBFile sharedDatabase]closeDatabaseConnection];
        beerDetailView.beverageCatId=[NSString stringWithFormat:@"%d",8];
        beerDetailView.beverageCustomization=resultFromPost[0][@"customisations"];
        beerDetailView.drinkNameFromOrderSummary=resultFromPost[0][@"name"];
        beerDetailView.drinkDescriptionFromOrderSummary=resultFromPost[0][@"description"];//[NSString stringWithFormat:@"%@",dataitem[@"price"]];
        beerDetailView.beverageCutType=resultFromPost[0][@"cust"];
        //UIImage *imageUrl = [UIImage imageWithContentsOfFile:resultFromPost[0][@"images"]];
        //if(imageUrl)
        //{
        beerDetailView.KDishImage=[UIImage imageWithContentsOfFile:resultFromPost[0][@"images"]];
        //}
        [beerDetailView.beverageSkUView reloadData];
        beerDetailView.selectedItemIndex=selectedItemIndex;
        
        //[beerDetailView loadBeverageData:selectedItemIndex];
        [ShareableData sharedInstance].swipeView.scrollEnabled=NO;
        [self.view addSubview:beerDetailView.view];
        [self.view bringSubviewToFront:beerDetailView.view];
    }else{
        
        
        
        [itemDetailView.KDishCust removeAllObjects];
        //[menudetailView removeSwipeSubviews];
        //[menudetailView.swipeDetailView addSubview:menudetailView.detailView1.view];
        //menudetailView.swipeDetailView.scrollEnabled=NO;
        itemDetailView.orderSummaryView=self;
        itemDetailView.IshideAddButton=@"1";
        //menudetailView.detailView1.Viewtype=@"2";
        // [menudetailView.menuDetailView.view removeFromSuperview];
        itemDetailView.view.frame=CGRectMake(10,-10, itemDetailView.view.frame.size.width, itemDetailView.view.frame.size.height);
        [self.view addSubview:itemDetailView.view];
        //////NSLOG(@"resultFromPost==%@",resultFromPost);
        
        for(int i=0;i<[resultFromPost count];i++)
        {
            NSMutableDictionary *dataitem=resultFromPost[i];
            itemDetailView.KDishCatId=[NSString stringWithFormat:@"%@",([ShareableData sharedInstance].OrderCatId)[selectedItemIndex]];
            itemDetailView.KDishName.text=[NSString stringWithFormat:@"%@",dataitem[@"name"]];
            itemDetailView.KDishRate.text=[NSString stringWithFormat:@"%@",dataitem[@"price"]];
            itemDetailView.KDishDescription.text=[NSString stringWithFormat:@"%@",dataitem[@"description"]];
            itemDetailView.kDishId =[NSString stringWithFormat:@"%@",orderId];
            [itemDetailView.KDishCust addObject:dataitem[@"customisations"]];
            itemDetailView.KDishCustType=[NSString stringWithFormat:@"%@",dataitem[@"cust"]];
            itemDetailView.KDishName.font=[UIFont fontWithName:@"Century Gothic" size:21];
            CGSize newsize=  [itemDetailView.KDishName.text sizeWithFont:itemDetailView.KDishName.font constrainedToSize:CGSizeMake(241, 400) lineBreakMode: itemDetailView.KDishName.lineBreakMode];
            itemDetailView.KDishName.frame=CGRectMake( itemDetailView.KDishName.frame.origin.x, itemDetailView.KDishName.frame.origin.y, newsize.width, newsize.height);
            itemDetailView.orderScreenFlag=@"1";
            
            UIImage *imageUrl = [UIImage imageWithContentsOfFile:dataitem[@"images"]];
            if(imageUrl)
            {
                itemDetailView.KDishImage=[UIImage imageWithContentsOfFile:dataitem[@"images"]];
            }
            break;
        }
        
        //[menudetailView  hideButtons];
    }
}

-(IBAction)addClicked:(id)sender
{
    UIButton *btn=(UIButton*)sender;
    UIView *view= [btn superview];
    CGRect frame=btn.frame;
    int tag=btn.tag;
    // DLog(@"Tag : %d",tag);
    selectedItem=tag;
    // NSString *type=[custType objectAtIndex:tag];
    NSString *orderId=[NSString stringWithFormat:@"%@",lastOrderedId[tag]];
   // [[TabSquareDBFile sharedDatabase]openDatabaseConnection];
    NSMutableArray *resultFromPost=[[TabSquareDBFile sharedDatabase]getDishDataDetail:orderId];
   // [[TabSquareDBFile sharedDatabase]closeDatabaseConnection];
    
    resultFromDB=resultFromPost[0];
    
    //parse data
    [self loadDishData];
    
   // [[TabSquareDBFile sharedDatabase]openDatabaseConnection];
    // NSString *dishCatId2 = [DishCategoryId objectAtIndex:tag];
    //  NSString *dishSubCatId2 = [DishSubCategoryId objectAtIndex:tag];
    int bevDisplay = 0;
    TabSquareBeerController* beveragesBeerView=[[TabSquareBeerController alloc]initWithNibName:@"TabSquareBeerController" bundle:nil];
    if(  [[TabSquareDBFile sharedDatabase] isBevCheck:DishCatId]){
        NSMutableArray *subCategoryData=[[TabSquareDBFile sharedDatabase]getSubCategoryData:DishCatId];
        for(int i=0;i<[subCategoryData count];++i){
            NSMutableDictionary *subCategory=subCategoryData[i];
            NSString *subId=subCategory[@"id"];
            NSString *displayId=subCategory[@"display"];
            if ([subId isEqualToString:DishSubCatId]&&[displayId isEqualToString:@"1"]){
                [ShareableData sharedInstance].TaskType = @"3";
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
       // [[TabSquareDBFile sharedDatabase]closeDatabaseConnection];
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
           // [self addImageAnimation:frame btnView:view];
            if ([[ShareableData sharedInstance].isSpecialReq isEqualToString:@"0"]){
                [self addImageAnimation:frame btnView:view];
            }else{
                [self addBlankCustomizationView];
            }
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


-(void)addInfoButton:(UITableViewCell*)cell indexPath:(NSInteger)rowIndex
{
    UIButton *addinfo=[UIButton buttonWithType:UIButtonTypeCustom];
    addinfo.userInteractionEnabled=YES;
    addinfo.tag=rowIndex;
    addinfo.frame=CGRectMake(460,5, 44, 32);
    [addinfo setImage:[UIImage imageNamed:@"i_connect.png"] forState:UIControlStateNormal];
    [addinfo setImage:[UIImage imageNamed:@"i_connect.png"] forState:UIControlStateHighlighted];
    [addinfo setImage:[UIImage imageNamed:@"i_connect.png"] forState:UIControlStateSelected];
    [addinfo addTarget:self action:@selector(dishInfoClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:addinfo];  
}

-(void)addButton:(UITableViewCell*)cell indexPath:(NSInteger)rowIndex
{
    UIButton *add=[UIButton buttonWithType:UIButtonTypeCustom];
    add.tag=rowIndex;
    add.frame=CGRectMake(520,-2, 72, 42);
    [add setImage:[UIImage imageNamed:@"add.png"] forState:UIControlStateNormal];
    [add setImage:[UIImage imageNamed:@"add.png"] forState:UIControlStateHighlighted];
    [add setImage:[UIImage imageNamed:@"add.png"] forState:UIControlStateSelected];
    [add addTarget:self action:@selector(addClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:add];
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


#pragma mark Table view methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [lastOrderedData  count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TableViewCellIdentifier";
   
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];  
    if (cell == nil) 
    {
         cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier]; 
    }
    
    [self removesuperView:cell];
    [self addDishItem:cell indexPath:indexPath.row];
    RateView  *FoodrateView=[self addRateView:indexPath.row+100];
    if([lastOrderedRating count]>indexPath.row)
    {
        FoodrateView.rating=[lastOrderedRating[indexPath.row]intValue];
        [cell.contentView addSubview:FoodrateView];
    }
    [self addInfoButton:cell indexPath:indexPath.row];
    if (![fromCheckout isEqualToString:@"1"]){
    [self addButton:cell indexPath:indexPath.row];
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

#pragma mark - RateView Delegate
-(void)rateView:(RateView *)rateView ratingDidChange:(float)rating {
	
}

@end
