//
//  TabTwitterFollowerListControllerViewController.m
//  TabSquareMenu
//
//  Created by Nikhil Kumar on 8/28/12.
//  Copyright (c) 2012 Trendsetterz. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "TabTwitterFollowerListControllerViewController.h"
#import "Utils.h"
#import "ShareableData.h"
#import "SBJSON.h"
#import "RateView.h"
#import "TabSquareDBFile.h"
#import "TabSquareFavouriteViewController.h"
#import "TabSquarefriendsorderViewController.h"
#import "TabSquareMenuController.h"
#import "TabMainCourseMenuListViewController.h"
#import "TabMainMenuDetailViewController.h"
#import "TabSquareMenuDetailController.h"
#import "TabMainDetailView.h"
#import "RateView.h"

#define FRIENDSLOADINGCOUNT             20

@interface TabTwitterFollowerListControllerViewController () <UITableViewDataSource, UITableViewDelegate, MBProgressHUDDelegate, RateViewDelegate> {
    BOOL                isGettingIds;
    BOOL                isMoreAvailable;
    BOOL                isMoreClicked;
    NSInteger           friendsLoaded;
    NSMutableArray      *cachesImagesArray;
    BOOL                 isGetUserInfo;
	MBProgressHUD *progressHud;
}

@end

@implementation TabTwitterFollowerListControllerViewController

@synthesize followersDataTblVw,followersInfoArray,friendsIdArr,nextCursor,moreIndexPath;
@synthesize favouriteView,menuView,threadArr,allfrdId,friendOrderView;
@synthesize lastOrderedId,lastOrderedData,lastOrderedRating,lastOrderedView;
@synthesize DishID,DishName,DishPrice,DishImage,DishCatId,DishDescription,DishCustomization;
@synthesize resultFromDB,customizationView;

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self)
    {
        // Custom initialization
    }
    return self;
}

-(void) allocArray
{
    NSMutableArray *arr1 =  [[NSMutableArray alloc] init];
    NSMutableArray *arr2 =  [[NSMutableArray alloc] init];
    NSMutableArray *arr3 =  [[NSMutableArray alloc] init];
    NSMutableArray *arr4 =  [[NSMutableArray alloc] init];
    
    self.friendsIdArr           = arr1;
    self.followersInfoArray     = arr2;
    self.threadArr              = arr3;
    self.allfrdId               = arr4;
   
}

-(void)viewDidLoad
{
    cachesImagesArray = [[NSMutableArray alloc] init];
    lastOrderedId=[[NSMutableArray alloc]init];
    lastOrderedData=[[NSMutableArray alloc]init];
    lastOrderedRating=[[NSMutableArray alloc]init];
    [self allocArray];
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

- (void) followersInfoLoading
{
    self.followersDataTblVw.delegate = self;
    self.followersDataTblVw.dataSource = self;
    [self loadlastOrdereddata];
    [self.followersDataTblVw reloadData];
    
}

-(void) showIndicator
{
    UIView *progressView = [[UIView alloc]initWithFrame:CGRectMake(0,187, self.view.frame.size.width, self.view.frame.size.height)];
	progressHud= [[MBProgressHUD alloc] initWithView:progressView];
	[self.view addSubview:progressHud];
	[self.view bringSubviewToFront:progressHud];
	//progressHud.dimBackground = YES;
	progressHud.delegate = self;
    //progressHud.labelText = @"loading....";
	[progressHud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
}

-(NSMutableArray*)getOrderSummmary:(NSString*)twitId
{
    NSString *post =[NSString stringWithFormat:@"facebook_id=%@&key=%@",twitId, [ShareableData appKey]];
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



-(void)myTask
{
     [self gettingIds];
}


- (void) defaultServicesCalling
{
    
    self.moreIndexPath = nil;
    friendsLoaded   = 0;    
    self.nextCursor      = @"-1";
    isGettingIds    = NO;
    isMoreAvailable = NO;
    isMoreClicked   = NO;
    isGetUserInfo   = NO;
    //[self showIndicator];
    [favouriteView userInfo];
    
}




- (void) gettingIds
{
    if(![nextCursor isEqualToString:@"0"])
    {
        isGettingIds = YES;
        [favouriteView getAllFollowers:self.nextCursor];
    }
    else 
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Message" message:@"All Friends Loaded" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil];
        [alertView show];
        isMoreAvailable = NO;
    }
}

- (void) gettingUserInfo:(NSDictionary *)responseArr
{
    NSArray *tempArr = responseArr[@"ids"];
    
    if([tempArr count] == 0)
    {
        [Utils showToast:self.view withText:@"No followers found"];
        //[[TwtBoothAppDelegate getDelegate]hideIndicator];
    }
    else
    {
        NSString *frdId;
        for (int index = 0; index < [tempArr count]; index++)
        {
            [self.allfrdId addObject:tempArr[index]];
            if(index!=0)
            {
                frdId= [NSString stringWithFormat:@"%@,%@",frdId,tempArr[index]];   
            }
            else 
            {
                frdId= [NSString stringWithFormat:@"%@",tempArr[index]];
            }
                     
        }
        //DLog(@"%@",friendsIdArr);
        
        self.friendsIdArr= [self filterTwitterFrdList:frdId];
        
        self.nextCursor =  responseArr[@"next_cursor_str"];
        
        //        if([nextCursor isEqualToString:@"0"])
        {
            [self gettingFriendsInfo];
        }
    }
    
}

- (void) gettingFriendsInfo
{
    
    NSMutableString *usersId = [[NSMutableString alloc]init];
    int remainingFriends = [self.friendsIdArr count] - friendsLoaded;
    int toLoadFriends = (remainingFriends > FRIENDSLOADINGCOUNT) ? FRIENDSLOADINGCOUNT : remainingFriends;
    
    if((friendsLoaded + toLoadFriends) == [self.friendsIdArr count])
        isMoreAvailable = NO;
    else
        isMoreAvailable = YES;
    
    for (int index = friendsLoaded ; index < friendsLoaded + toLoadFriends ; index++)
    {
        [usersId appendString:[NSString stringWithFormat:@"%@",(self.friendsIdArr)[index]]];
        if([self.friendsIdArr count]-1 != index)
            [usersId appendString:@","];
    }
    
    if(friendsLoaded == 0)
        for(int index = 0 ; index < [self.friendsIdArr count] ; index++)
            [cachesImagesArray addObject:[NSNull null]];
    
    friendsLoaded = friendsLoaded + toLoadFriends;
    isGettingIds = NO;
    [favouriteView getUsersInformation:usersId];
    
    
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
        [lastOrderedId addObject:[NSString stringWithFormat:@"%@",dataitem[@"dish_id"]]];
        [lastOrderedData addObject:[NSString stringWithFormat:@"%@",dataitem[@"dish_name"]]];
        [lastOrderedRating addObject:[NSString stringWithFormat:@"%@",dataitem[@"rating"]]];
    }
    [lastOrderedView reloadData];
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


-(NSMutableArray*)filterTwitterFrdList:(NSString*)frdtwitterId
{
    NSString *post =[NSString stringWithFormat:@"twitter_id=%@&key=%@",frdtwitterId, [ShareableData appKey] ];
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    NSString *url_string = [NSString stringWithFormat:@"%@/webs/get_ids_from_twitter", [ShareableData serverURL]];
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
    DLog(@"%@",resultFromPost);
    return resultFromPost;
}

-(void)fetchImage:(NSMutableDictionary *)obj 
{    
    @autoreleasepool {
    
        if([[NSThread currentThread] isCancelled]) 
        {
            [NSThread exit];
        }
        [self.threadArr addObject:@"1"];
        
        
        int  photoId = [obj[@"rowVal"] intValue];
        
        
        NSData *mydata = nil;	
        if (self.followersInfoArray.count > photoId)
        {
            NSDictionary *infoDict = (self.followersInfoArray)[photoId];
            
            NSString *profileImageStr  =  [[NSString alloc] initWithFormat:@"https://api.twitter.com/1/users/profile_image?screen_name=%@&size=bigger",infoDict[@"screen_name"]];
            NSURL *profileImageUrl = [[NSURL alloc] initWithString:profileImageStr];
            mydata = [[NSData alloc] initWithContentsOfURL:profileImageUrl];
            
            
        }
        UIImage *myImage = nil;
        
        if(mydata)
        {
            myImage = [[UIImage alloc] initWithData:mydata];
            [(UIImageView *)obj[@"imageView"] setImage:myImage];
            if(cachesImagesArray.count > photoId && myImage != nil)
                cachesImagesArray[photoId] = myImage;
        }
        else
        {
           // [cachesImagesArray replaceObjectAtIndex:photoId withObject:[UIImage imageNamed:@"defaultImgB.png"]];
            [(UIImageView *)obj[@"imageView"] setImage:[UIImage imageNamed:@"defaultImgB.png"]];
        }
    
    }
	
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
    DishImage=[UIImage imageWithContentsOfFile: resultFromDB[@"images"]];//resultFromDB[@"images"];
}

-(void)addBlankCustomizationView
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
    customizationView.detailImageView.frame = CGRectMake(104, 229, 530, 222);
    customizationView.detailImageView.contentMode = UIViewContentModeRedraw;
    
    
    customizationView.detailImageView.clipsToBounds=YES;
    [self.view addSubview:customizationView.view];
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

-(IBAction)infoClicked:(id)sender
{
    //DLog(@"info clicked");
    UIButton *infoBtn=(UIButton*)sender;
    int index=infoBtn.tag;
    
    NSString *orderId=[NSString stringWithFormat:@"%@",lastOrderedId[index]];  
    
    //get data from DB
  //  [[TabSquareDBFile sharedDatabase]openDatabaseConnection];
    NSMutableArray *resultFromPost=[[TabSquareDBFile sharedDatabase]getDishDataDetail:orderId];
   // [[TabSquareDBFile sharedDatabase]closeDatabaseConnection];
    //DLog(@"%@",resultFromPost);
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
        menuView.menulistView1.menudetailView.tabMainDetailView.KDishCatId=[NSString stringWithFormat:@"%@",lastOrderedId[index]];
        menuView.menulistView1.menudetailView.tabMainDetailView.KDishName.text=[NSString stringWithFormat:@"%@",dataitem[@"name"]];
        menuView.menulistView1.menudetailView.tabMainDetailView.KDishRate.text=[NSString stringWithFormat:@"%@",dataitem[@"price"]];
        menuView.menulistView1.menudetailView.tabMainDetailView.KDishDescription.text=[NSString stringWithFormat:@"%@",dataitem[@"description"]];
        menuView.menulistView1.menudetailView.tabMainDetailView.kDishId =[NSString stringWithFormat:@"%@",orderId];
        [menuView.menulistView1.menudetailView.tabMainDetailView.KDishCust addObject:dataitem[@"customisations"]];
        menuView.menulistView1.menudetailView.tabMainDetailView.KDishCustType=[NSString stringWithFormat:@"%@",dataitem[@"cust"]];
        UIImage *imageUrl = dataitem[@"images"];
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

-(IBAction)addClicked:(id)sender
{
    UIButton *btn=(UIButton*)sender;
    UIView *view= [btn superview];
    CGRect frame=btn.frame;
    int tag=btn.tag;
    // DLog(@"Tag : %d",tag);
    
    NSString *orderId=[NSString stringWithFormat:@"%@",lastOrderedId[tag]];     
    
    //get data from DB
   // [[TabSquareDBFile sharedDatabase]openDatabaseConnection];
    NSMutableArray *resultFromPost=[[TabSquareDBFile sharedDatabase]getDishDataDetail:orderId];
    //[[TabSquareDBFile sharedDatabase]closeDatabaseConnection];
    
    resultFromDB=resultFromPost[0];
    
    //parse data 
    [self loadDishData];
    
    NSString *type=[NSString stringWithFormat:@"%@",resultFromDB[@"cust"]];
    if([type isEqualToString:@"0"])
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
}


-(UIButton*)addInfoButton:(UITableViewCell*)cell indexPath:(NSInteger)rowIndex
{
    UIButton *addinfo=[UIButton buttonWithType:UIButtonTypeCustom];
    addinfo.userInteractionEnabled=YES;
    addinfo.tag=rowIndex;
    addinfo.frame=CGRectMake(460, 5, 44, 32);
    [addinfo setImage:[UIImage imageNamed:@"i_connect.png"] forState:UIControlStateNormal];
    [addinfo setImage:[UIImage imageNamed:@"i_connect.png"] forState:UIControlStateHighlighted];
    [addinfo setImage:[UIImage imageNamed:@"i_connect.png"] forState:UIControlStateSelected];
    [addinfo addTarget:self action:@selector(infoClicked:) forControlEvents:UIControlEventTouchUpInside];
    return addinfo;
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



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView==followersDataTblVw)
    {
        return [followersInfoArray count];
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
    if(tableView==followersDataTblVw)
    {
//        NSUInteger count = [self.followersInfoArray count];
        NSDictionary   *followingData = (self.followersInfoArray)[indexPath.row];
        //DLog(@"%@",followingData);
        if(followingData)
        {
            //Name Label 
            
            UIImageView *frdImg=[[UIImageView alloc]initWithFrame:CGRectMake(4, 8, 60, 57)];
            
            if(cachesImagesArray[indexPath.row] != [NSNull null])
            {
                frdImg.image  = cachesImagesArray[indexPath.row];
            }
            else
            {
                NSMutableDictionary *data=[[NSMutableDictionary alloc]init];
                
                data[@"rowVal"] = [NSString stringWithFormat:@"%i", indexPath.row];
                data[@"imageView"] = frdImg;
                
                NSThread *newThread = [[NSThread alloc] initWithTarget:self selector:@selector(fetchImage:) object:data];
                [newThread start];
                
            }
            
            [cell.contentView addSubview:frdImg];
            
            NSString  *tempStr  = [NSString stringWithFormat:@"%@",followingData[@"name"]];
            UILabel *frdname=[[UILabel alloc]initWithFrame:CGRectMake(75, 25, 270, 30)];
            frdname.text= tempStr;
            frdname.backgroundColor=[UIColor clearColor];
            frdname.font=[UIFont systemFontOfSize:19.0];
            frdname.textAlignment=UITextAlignmentLeft;
            [cell.contentView addSubview:frdname];
        }
    }
    else if (tableView==lastOrderedView) 
    {
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
        
        UIButton *addBtn = [self addButton:cell indexPath:indexPath.row];
        [cell.contentView addSubview:addBtn];        
        
    }
         
    cell.selectionStyle=UITableViewCellSelectionStyleGray;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSDictionary   *followingData = (self.followersInfoArray)[indexPath.row];
    NSString *twitId=[NSString stringWithFormat:@"%@",followingData[@"id"]];
    //get last order summary detail
    NSMutableArray *orderData=[self getOrderSummmary:twitId];
    if([orderData count]!=0)
    {
        friendOrderView=[[TabSquarefriendsorderViewController alloc]initWithNibName:@"TabSquarefriendsorderViewController" bundle:nil];
        friendOrderView.view.frame=CGRectMake(0, 0, friendOrderView.view.frame.size.width, friendOrderView.view.frame.size.height);
        [friendOrderView loadFrdOrderData:orderData];
        [self.view addSubview:friendOrderView.view];
    }
    else 
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"No Data Found!!!!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
    }
    
}

-(IBAction)logoutButtonClicked:(id)sender
{
    [ShareableData sharedInstance].isLogin = @"0";
    [ShareableData sharedInstance].Customer = @"0";
    [ShareableData sharedInstance].isFBLogin = @"0";
    [ShareableData sharedInstance].isTwitterLogin = @"0";
    //[menuView.favouriteView.objFacebookViewC logout];
    [menuView favouriteClicked:0];
    [self.view.superview.superview removeFromSuperview];//narmeet
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"LogOut Successful!!!!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alert show];

}

#pragma mark - RateView Delegates
-(void)twitterResponse:(NSMutableArray *)responseArr {
    if(!isGetUserInfo)
    {
        isGetUserInfo=true;
        NSDictionary *detailDict = (NSDictionary *)responseArr;
        NSString *userid=[NSString stringWithFormat:@"%@",detailDict[@"id"]];
        //get user registeration
        [favouriteView UserRegistration:@"twitter" emailid:userid password:@"twit12" tableId:[ShareableData sharedInstance].assignedTable1 name:userid];
        favouriteView.loggedInUserData = detailDict;
        [self gettingIds];
    }
    else if(isGettingIds)
    {
        if(friendsLoaded == 0)
        {
            [self.allfrdId removeAllObjects];
            [self.friendsIdArr removeAllObjects];
            [self.followersInfoArray removeAllObjects];
            [cachesImagesArray removeAllObjects];
            
        }
        [self gettingUserInfo:(NSDictionary *)responseArr];
    }
    else
    {
        if(!isMoreClicked)
        {
            for(int x= 0 ; x < [responseArr count] ; x++)
            {
                [self.followersInfoArray addObject:responseArr[x]];
            }
            
            [self followersInfoLoading];
        }
        else
        {
            isMoreClicked = NO;
            NSMutableArray *newPosts = [responseArr mutableCopy];
            NSUInteger newCount = [newPosts count];
            
            if (newCount > 0)
            {
                [self.followersInfoArray addObjectsFromArray:newPosts];
                //[[TwtBoothAppDelegate getDelegate] hideIndicator];
                [self loadlastOrdereddata];
                [self.followersDataTblVw reloadData];
                [self.followersDataTblVw scrollToRowAtIndexPath:self.moreIndexPath atScrollPosition:UITableViewScrollPositionNone
                                                       animated:YES];
            }
        }
        
		// [[TwtBoothAppDelegate getDelegate] hideIndicator];
    }
    
}

-(void)twitterServiceFailed {
	
}

-(void)rateView:(RateView *)rateView ratingDidChange:(float)rating {
	
}

@end
