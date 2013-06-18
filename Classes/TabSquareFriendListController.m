//
//  TabSquareFriendListController.m
//  TabSquareMenu
//
//  Created by Nikhil Kumar on 8/25/12.
//  Copyright (c) 2012 Trendsetterz. All rights reserved.
//

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
#import <QuartzCore/QuartzCore.h>

@implementation TabSquareFriendListController

@synthesize friendlistView,friendName,friendImage,friendId,friendData,friendorderData,DishSubCatId,beerDetailView;
@synthesize menuView,friendInstalled,friendOrderView,lastOrderedId,lastOrderedData,lastOrderedRating,custType;
@synthesize lastOrderedView,customizationView;
@synthesize DishID,DishName,DishPrice,DishImage,DishCatId,DishDescription,DishCustomization;
@synthesize resultFromDB,fromCheckout;
@synthesize menudetailView;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated
{
    [self loadlastOrdereddata];
    
}

- (void)viewDidLoad
{
    friendName=[[NSMutableArray alloc]init];
    friendImage=[[NSMutableArray alloc]init];
    friendId=[[NSMutableArray alloc]init];
    friendInstalled=[[NSMutableArray alloc]init];
    lastOrderedId=[[NSMutableArray alloc]init];
    lastOrderedData=[[NSMutableArray alloc]init];
    lastOrderedRating=[[NSMutableArray alloc]init];
    beerDetailView =[[TabSquareNewBeerScrollController alloc]initWithNibName:@"TabSquareNewBeerScrollController" bundle:nil];
    // [super viewDidLoad];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
-(void)viewWillAppear:(BOOL)animated{
    
    NSString *img_name1 = [NSString stringWithFormat:@"%@%@_%@", PRE_NAME, POPUP_IMAGE,[ShareableData appKey]];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);;
    NSString *libraryDirectory = [paths lastObject];
    NSString *location = [NSString stringWithFormat:@"%@/%@%@",libraryDirectory,img_name1,@".png"];
    
    UIImage *img1 = [UIImage imageWithContentsOfFile:location];
    
    bgImage.image = img1;
    
    NSLog(@"View will appear in Favourite View Controller");
}
-(void)loadFriendList
{
    [friendName removeAllObjects];
    [friendId removeAllObjects];
    [friendImage removeAllObjects];
    //DLog(@"%@",friendData);
    for(int i=0;i<[friendInstalled count];++i)
    {
        NSString *frdId=friendInstalled[i];
        for(int j=0;j<[friendData count];++j)
        {
            
            NSDictionary *result2=friendData[j];
            NSString *id1=result2[@"id"];
            if([frdId isEqualToString:id1])
            {
                NSString *friendname=result2[@"name"];
                NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture",id1]]];
                [friendId addObject:id1];
                [friendName addObject:friendname];
                [friendImage addObject:imageData];
                break;
            }
        }
        
    }
    
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message: @"Login Successful" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alert show];
    
    [friendlistView reloadData];
}
-(NSString*)getEmailID:(NSString*)email
{
    NSString *post =[NSString stringWithFormat:@"email=%@&key=%@",email, [ShareableData appKey]];
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    NSString *url_string = [NSString stringWithFormat:@"%@/webs/get_emailid", [ShareableData serverURL]];
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
    
    NSString* tt = @"-1";
    
    for(int i=0;i<[resultFromPost count];++i)
    {
        
        // NSMutableDictionary *dataitem=[resultFromPost objectAtIndex:0];
        NSMutableDictionary *dataitem2=resultFromPost[0];
        
        tt=[NSString stringWithFormat:@"%@",dataitem2[@"id"]];
        
    }
    
    
    // DLog(@"Result : %@",dataitem);
    return tt;
}

-(void)getlastOrderedDataList:(NSString*)email
{
    [self updateFeedback:email order_id:[ShareableData sharedInstance].OrderId];
    [self updateFeedbackAboutDish:email order_id:[ShareableData sharedInstance].OrderId];
    
    
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
    [lastOrderedView reloadData];
    //DLog(@"Result : %@",data);
}
-(void)updateFeedback:(NSString*)cid order_id:(NSString*)order_id
{
    //NSString *Key=@"kinara123";
    
    NSString *post =[NSString stringWithFormat:@"key=%@&customer_id=%@&order_id=%@", [ShareableData appKey],cid,order_id];
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    NSString *url_string = [NSString stringWithFormat:@"%@/webs/update_feedback", [ShareableData serverURL]];
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
}
-(void)updateFeedbackAboutDish:(NSString*)email1 order_id:(NSString*)order_id1
{
    
    //   DLog(@"ID ,NAME,RATING: %@%@%@",dish_id,dish_name1,rating1);
    
    
    NSString *post =[NSString stringWithFormat:@"email=%@&order_id=%@&key=%@",email1,order_id1, [ShareableData appKey]];
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    NSString *url_string = [NSString stringWithFormat:@"%@/webs/update_dish_feedback", [ShareableData serverURL]];
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


-(void) showIndicator
{
//    UIView *progressView = [[UIView alloc]initWithFrame:CGRectMake(0,187, self.view.frame.size.width, self.view.frame.size.height)];
//	progressHud= [[MBProgressHUD alloc] initWithView:progressView];
//	[self.view addSubview:progressHud];
//	[self.view bringSubviewToFront:progressHud];
//	//progressHud.dimBackground = YES;
//	progressHud.delegate = self;
//    //progressHud.labelText = @"loading....";
//	[progressHud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
    
        [self myTask];
    
}

- (void)myTask
{
    [self loadFriendList];
    [self loadlastOrdereddata];
    
   
}
-(NSMutableArray*)getlastOrderedDataList2:(NSString*)email
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
    
    //  [lastOrderedView reloadData];
    DLog(@"Result : %@",data);
    return resultFromPost;
}



-(NSMutableArray*)getOrderSummmary:(NSString*)facebookId
{
    NSString *post =[NSString stringWithFormat:@"facebook_id=%@&key=%@",facebookId, [ShareableData appKey]];
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    NSString *url_string = [NSString stringWithFormat:@"%@/webs/get_order_by_customer", [ShareableData serverURL]];
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
    
    return resultFromPost;
    
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

-(void)addDishItem:(UITableViewCell*)cell indexPath:(NSInteger)rowIndex
{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, 2, 200, 45)];
    titleLabel.backgroundColor=[UIColor clearColor];
    titleLabel.text = lastOrderedData[rowIndex];
    titleLabel.font=[UIFont fontWithName:@"Lucida Calligraphy" size:17];
    titleLabel.textColor=[UIColor whiteColor];
    [cell.contentView addSubview:titleLabel];
    
}

-(void)loadDishData
{
    DishID=[NSString stringWithFormat:@"%@",resultFromDB[@"id"]];
    DishName=[NSString stringWithFormat:@"%@",resultFromDB[@"name"]];
    DishPrice=[NSString stringWithFormat:@"%@",resultFromDB[@"price"]];
    DishDescription=[NSString stringWithFormat:@"%@",resultFromDB[@"description"]];
    DishCatId=[NSString stringWithFormat:@"%@",resultFromDB[@"category"]];
    DishCustomization=resultFromDB[@"customisations"];
    DishSubCatId=[NSString stringWithFormat:@"%@",resultFromDB[@"sub_category"]];
    DishImage=[UIImage imageWithContentsOfFile:resultFromDB[@"images"]];//resultFromDB[@"images"];
    custType =[NSString stringWithFormat:@"%@",resultFromDB[@"cust"]];
    
}



-(void)addCustomizationView
{
    menuView.menulistView1.menudetailView.menuDetailView=[[TabSquareMenuDetailController alloc]initWithNibName:@"TabSquareMenuDetailController" bundle:nil];
    customizationView=menuView.menulistView1.menudetailView.menuDetailView;
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
-(void)createMenuDetail
{
    
    
    ////change newScrollVC
    menudetailView=[[ViewController alloc]initWithNibName:@"ViewController" bundle:nil];
    [menudetailView allocateArray];
}

-(IBAction)infoClicked:(id)sender
{
    UIButton *btn=(UIButton*)sender;
    
    int tag=btn.tag;
    [self createMenuDetail];
    //selectedItem=tag;
    [ShareableData sharedInstance].swipeView.scrollEnabled=NO;
    NSString *orderId=[NSString stringWithFormat:@"%@",lastOrderedId[tag]];
    // [[TabSquareDBFile sharedDatabase]openDatabaseConnection];
    NSMutableArray *resultFromPost=[[TabSquareDBFile sharedDatabase]getDishDataDetail:orderId];
    // [[TabSquareDBFile sharedDatabase]closeDatabaseConnection];
    
    resultFromDB=resultFromPost[0];
    
    //parse data
    [self loadDishData];
    
    //[[TabSquareDBFile sharedDatabase]openDatabaseConnection];
    // NSString *dishCatId2 = [DishCategoryId objectAtIndex:selectedItem];
    // NSString *dishSubCatId2 = [DishSubCategoryId objectAtIndex:selectedItem];
    int bevDisplay = 0;
    TabSquareNewBeerScrollController* beveragesBeerView=[[TabSquareNewBeerScrollController alloc]initWithNibName:@"TabSquareNewBeerScrollController" bundle:nil];
    if([DishCatId isEqualToString:[ShareableData sharedInstance].bevCat]){
        
        NSMutableArray *subCategoryData=[[TabSquareDBFile sharedDatabase]getSubCategoryData:[ShareableData sharedInstance].bevCat];
        for(int i=0;i<[subCategoryData count];++i){
            NSMutableDictionary *subCategory=subCategoryData[i];
            NSString *subId=subCategory[@"id"];
            NSString *displayId=subCategory[@"display"];
            if ([subId isEqualToString:DishSubCatId]&&[displayId isEqualToString:@"1"]){
                [ShareableData sharedInstance].TaskType = @"3";
                bevDisplay = 1;
                // [beveragesBeerView reloadDataOfSubCat:DishSubCatId cat:DishCatId];
                //[beveragesBeerView.beverageView reloadData];
            }
            
        }
        
        // [[TabSquareDBFile sharedDatabase]closeDatabaseConnection];
    }
    if (bevDisplay == 1){
        // NSMutableArray *beverageCustomization;
        // NSMutableArray *beverageSkuDetail;
        // NSMutableArray *beverageCustType;
        beerDetailView =[[TabSquareNewBeerScrollController alloc]initWithNibName:@"TabSquareNewBeerScrollController" bundle:nil];
        beerDetailView.beverageView = self;
        
        beerDetailView.tempDishID = orderId.intValue;
        
        beerDetailView.orderScreenFlag=@"1";
        beerDetailView.selectedIndex=[NSString stringWithFormat:@"%d",tag];
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
        beerDetailView.selectedItemIndex=tag;
        
        //[beerDetailView loadBeverageData:selectedItemIndex];
        [ShareableData sharedInstance].swipeView.scrollEnabled=NO;
        [self.view addSubview:beerDetailView.view];
        [self.view bringSubviewToFront:beerDetailView.view];
    }else{
        
        //        [menudetailView.KDishCust removeAllObjects];
        //
        //        menudetailView.orderSummaryView=self;
        //        menudetailView.IshideAddButton=@"1";
        //
        //
        //
        //
        //        for(int i=0;i<[resultFromPost count];i++)
        //        {
        //            NSMutableDictionary *dataitem=resultFromPost[i];
        //            menudetailView.KDishCatId=[NSString stringWithFormat:@"%@",DishCatId];
        //            menudetailView.KDishName.text=[NSString stringWithFormat:@"%@",dataitem[@"name"]];
        //            menudetailView.KDishRate.text=[NSString stringWithFormat:@"%@",dataitem[@"price"]];
        //            menudetailView.KDishDescription.text=[NSString stringWithFormat:@"%@",dataitem[@"description"]];
        //            menudetailView.kDishId =[NSString stringWithFormat:@"%@",orderId];
        //            [menudetailView.KDishCust addObject:dataitem[@"customisations"]];
        //            menudetailView.KDishCustType=[NSString stringWithFormat:@"%@",dataitem[@"cust"]];
        //            menudetailView.KDishName.font=[UIFont fontWithName:@"Century Gothic" size:21];
        //            CGSize newsize=  [menudetailView.KDishName.text sizeWithFont:menudetailView.KDishName.font constrainedToSize:CGSizeMake(241, 400) lineBreakMode: menudetailView.KDishName.lineBreakMode];
        //            menudetailView.KDishName.frame=CGRectMake( menudetailView.KDishName.frame.origin.x, menudetailView.KDishName.frame.origin.y, newsize.width, newsize.height);
        //            menudetailView.orderScreenFlag=@"1";
        //
        //            UIImage *imageUrl = [UIImage imageWithContentsOfFile:dataitem[@"images"]];
        //            if(imageUrl)
        //            {
        //                menudetailView.KDishImage=[UIImage imageWithContentsOfFile:dataitem[@"images"]];
        //            }
        //            menudetailView.view.frame=CGRectMake(10,-10, menudetailView.view.frame.size.width, menudetailView.view.frame.size.height);
        //            [self.view addSubview:menudetailView.view];
        //            menudetailView.Viewtype=@"1";
        //            [menudetailView loadDataInView:tag];
        //            break;
        //        }
    }
    
}

-(IBAction)addClicked:(id)sender
{
    
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
    // [[TabSquareDBFile sharedDatabase]closeDatabaseConnection];
    
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
                [ShareableData sharedInstance].TaskType = @"3";
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
             DLog(@"MANOJ");
        }
        [view removeFromSuperview];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView==friendlistView)
    {
        return [friendName count];
    }
    else if (tableView==lastOrderedView)
    {
        return [lastOrderedId count];
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier=@"cellIdentifier";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell==nil)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    if(tableView==friendlistView)
    {
        [self removesuperView:cell];
        if([friendImage count]>indexPath.row)
        {
            [friendlistView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

            UIImageView *frdImg=[[UIImageView alloc]initWithImage:[UIImage imageWithData:friendImage[indexPath.row]]];
            frdImg.frame=CGRectMake(4, 8, 60, 57);
            [cell.contentView addSubview:frdImg];
            
            
            UILabel *frdname=[[UILabel alloc]initWithFrame:CGRectMake(75, 25, 270, 30)];
            frdname.text= friendName[indexPath.row];
            frdname.backgroundColor=[UIColor clearColor];
            frdname.font=[UIFont systemFontOfSize:19.0];
            frdname.textAlignment=NSTextAlignmentLeft;
            frdname.textColor=[UIColor whiteColor];
            [cell.contentView addSubview:frdname];
            cell.selectionStyle=UITableViewCellSelectionStyleGray;
            
        }
    }
    else if (tableView==lastOrderedView)
    {
        [lastOrderedView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

        [self removesuperView:cell];
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
            UIButton *addBtn = [self addButton:cell indexPath:indexPath.row];
            [cell.contentView addSubview:addBtn];
        }
        
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSString *fbId=friendId[indexPath.row];
    //get last order summary detail
    DLog(@"Friend ID: %@",fbId);
    NSMutableArray *orderData=[self getlastOrderedDataList2:[self getEmailID:fbId]];
    if([orderData count]!=0)
    {
        friendOrderView=[[TabSquarefriendsorderViewController alloc]initWithNibName:@"TabSquarefriendsorderViewController" bundle:nil];
        friendOrderView.view.frame=CGRectMake(0, 0, friendOrderView.view.frame.size.width, friendOrderView.view.frame.size.height);
        [friendOrderView loadFrdOrderData:orderData];
        friendOrderView.menuView = self.menuView;
        [self.view addSubview:friendOrderView.view];
    }
    else
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"No Data Found!!!!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
    }
    
}

-(void)fbLogout
{
    NSUserDefaults *userPref =  [NSUserDefaults standardUserDefaults];
    [userPref synchronize];
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies])
    {
        NSString* domainName = [cookie domain];
        NSRange domainRange = [domainName rangeOfString:@"facebook"];
        if(domainRange.length > 0)
        {
            [storage deleteCookie:cookie];
        }
        
    }
}

-(IBAction)logOutClicked:(id)sender
{
    [ShareableData sharedInstance].isLogin = @"0";
    [ShareableData sharedInstance].Customer = @"0";
    [ShareableData sharedInstance].isFBLogin = @"0";
    [ShareableData sharedInstance].isTwitterLogin = @"0";
    [menuView.favouriteView.objFacebookViewC logout];
    [menuView favouriteClicked:0];
    [self.view.superview.superview removeFromSuperview];//narmeet
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"LogOut Successful!!!!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alert show];
}

-(void)rateView:(RateView *)rateView ratingDidChange:(float)rating {
	
}

@end
